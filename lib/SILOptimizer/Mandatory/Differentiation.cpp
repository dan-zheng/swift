//===--- Differentiation.cpp - SIL Automatic Differentiation --*- C++ -*---===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//
//
// SWIFT_ENABLE_TENSORFLOW
//
// This file implements automatic differentiation.
//
// NOTE: Though automatic differentiation is developed as part of the Swift for
// TensorFlow project, it is completely independent from TensorFlow.
// Read the differentiable programming manifesto for more information:
// docs/DifferentiableProgramming.md.
//
// TODO(TF-993): Organize Differentiation.cpp into smaller files.
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "differentiation"

#include "swift/AST/ASTMangler.h"
#include "swift/AST/ASTPrinter.h"
#include "swift/AST/AnyFunctionRef.h"
#include "swift/AST/AutoDiff.h"
#include "swift/AST/Builtins.h"
#include "swift/AST/DeclContext.h"
#include "swift/AST/DiagnosticsSIL.h"
#include "swift/AST/Expr.h"
#include "swift/AST/GenericEnvironment.h"
#include "swift/AST/GenericSignatureBuilder.h"
#include "swift/AST/LazyResolver.h"
#include "swift/AST/ParameterList.h"
#include "swift/AST/SourceFile.h"
#include "swift/AST/SubstitutionMap.h"
#include "swift/AST/TypeCheckRequests.h"
#include "swift/SIL/FormalLinkage.h"
#include "swift/SIL/PrettyStackTrace.h"
#include "swift/SIL/Projection.h"
#include "swift/SIL/SILBuilder.h"
#include "swift/SIL/TypeSubstCloner.h"
#include "swift/SILOptimizer/Analysis/DifferentiableActivityAnalysis.h"
#include "swift/SILOptimizer/Analysis/DominanceAnalysis.h"
#include "swift/SILOptimizer/PassManager/Passes.h"
#include "swift/SILOptimizer/PassManager/Transforms.h"
#include "swift/SILOptimizer/Utils/CFGOptUtils.h"
#include "swift/SILOptimizer/Utils/SILOptFunctionBuilder.h"
#include "swift/SILOptimizer/Utils/Differentiation/AdjointValue.h"
#include "swift/SILOptimizer/Utils/Differentiation/ADContext.h"
#include "swift/SILOptimizer/Utils/Differentiation/Common.h"
#include "swift/SILOptimizer/Utils/Differentiation/DerivativeLookup.h"
#include "swift/SILOptimizer/Utils/Differentiation/LinearMapInfo.h"
#include "llvm/ADT/APSInt.h"
#include "llvm/ADT/BreadthFirstIterator.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/Support/CommandLine.h"

using namespace swift;
using namespace swift::autodiff;
using llvm::DenseMap;
using llvm::SmallDenseMap;
using llvm::SmallDenseSet;
using llvm::SmallMapVector;
using llvm::SmallSet;

/// This flag is used to disable `differentiable_function_extract` instruction
/// folding for SIL testing purposes.
static llvm::cl::opt<bool> SkipFoldingDifferentiableFunctionExtraction(
    "differentiation-skip-folding-differentiable-function-extraction",
    llvm::cl::init(true));

//===----------------------------------------------------------------------===//
// Helpers
//===----------------------------------------------------------------------===//

/// Given a dumpable value, dumps it to `llvm::dbgs()`.
template <typename T> static inline void debugDump(T &v) {
  LLVM_DEBUG(llvm::dbgs() << "\n==== BEGIN DEBUG DUMP ====\n"
                          << v << "\n==== END DEBUG DUMP ====\n");
}

/// Given a function, gathers all of its direct results in an order defined by
/// its result type. Note that "formal results" refer to result values in the
/// body of the function, not at call sites.
static void
collectAllDirectResultsInTypeOrder(SILFunction &function,
                                   SmallVectorImpl<SILValue> &results) {
  SILFunctionConventions convs(function.getLoweredFunctionType(),
                               function.getModule());
  auto *retInst = cast<ReturnInst>(function.findReturnBB()->getTerminator());
  auto retVal = retInst->getOperand();
  if (auto *tupleInst = dyn_cast<TupleInst>(retVal))
    results.append(tupleInst->getElements().begin(),
                   tupleInst->getElements().end());
  else
    results.push_back(retVal);
}

/// Given a function call site, gathers all of its actual results (both direct
/// and indirect) in an order defined by its result type.
static void collectAllActualResultsInTypeOrder(
    ApplyInst *ai, ArrayRef<SILValue> extractedDirectResults,
    SmallVectorImpl<SILValue> &results) {
  auto calleeConvs = ai->getSubstCalleeConv();
  unsigned indResIdx = 0, dirResIdx = 0;
  for (auto &resInfo : calleeConvs.getResults()) {
    results.push_back(resInfo.isFormalDirect()
                          ? extractedDirectResults[dirResIdx++]
                          : ai->getIndirectSILResults()[indResIdx++]);
  }
}

/// Returns the "constrained" derivative generic signature given:
/// - An original SIL function type.
/// - A wrt parameter index subset.
/// - A possibly uncanonical derivative generic signature (optional).
/// - Additional derivative requirements (optional).
/// The constrained derivative generic signature constrains all wrt parameters
/// to conform to `Differentiable`.
static GenericSignature getConstrainedDerivativeGenericSignature(
    CanSILFunctionType originalFnTy, IndexSubset *paramIndexSet,
    GenericSignature derivativeGenSig) {
  if (!derivativeGenSig)
    derivativeGenSig = originalFnTy->getSubstGenericSignature();
  if (!derivativeGenSig)
    return nullptr;
  // Constrain all wrt parameters to `Differentiable`.
  auto &ctx = derivativeGenSig->getASTContext();
  auto *diffableProto = ctx.getProtocol(KnownProtocolKind::Differentiable);
  SmallVector<Requirement, 4> requirements;
  for (unsigned paramIdx : paramIndexSet->getIndices()) {
    auto paramType = originalFnTy->getParameters()[paramIdx].getInterfaceType();
    Requirement req(RequirementKind::Conformance, paramType,
                    diffableProto->getDeclaredType());
    requirements.push_back(req);
  }
  return evaluateOrDefault(
      ctx.evaluator,
      AbstractGenericSignatureRequest{
          derivativeGenSig.getPointer(),
          /*addedGenericParams*/ {},
          std::move(requirements)},
      nullptr);
}

/// Returns the canonical derivative generic signature for the given witness
/// and original function.
/// - Return the witness derivative generic signature if it exists.
/// - Otherwise, return the original function's generic signature.
static CanGenericSignature
getDerivativeGenericSignature(SILDifferentiabilityWitness *witness,
                              SILFunction *original) {
  if (auto sig = witness->getDerivativeGenericSignature())
    return sig->getCanonicalSignature();
  return original->getLoweredFunctionType()->getSubstGenericSignature();
}

namespace {

class DifferentiationTransformer {
private:
  /// Reference to the main transform.
  SILModuleTransform &transform;

  /// Context necessary for performing the transformations.
  ADContext context;

  /// Promotes the given `differentiable_function` instruction to a valid
  /// `@differentiable` function-typed value.
  SILValue promoteToDifferentiableFunction(
      DifferentiableFunctionInst *inst, SILBuilder &builder, SILLocation loc,
      DifferentiationInvoker invoker);

public:
  /// Construct an `DifferentiationTransformer` for the given module.
  explicit DifferentiationTransformer(SILModuleTransform &transform)
       : transform(transform), context(transform) {}

  ADContext &getContext() { return context; }

  /// Canonicalize the given witness, filling in derivative functions if
  /// missing.
  ///
  /// Generated derivative functions have the same linkage as the witness.
  ///
  /// \param serializeFunctions specifies whether generated functions should be
  ///        serialized.
  bool canonicalizeDifferentiabilityWitness(
      SILFunction *original, SILDifferentiabilityWitness *witness,
      DifferentiationInvoker invoker, IsSerialized_t serializeFunctions);

  /// Process the given `differentiable_function` instruction, filling in
  /// missing derivative functions if necessary.
  bool processDifferentiableFunctionInst(DifferentiableFunctionInst *dfi);

  /// Fold `differentiable_function_extract` users of the given
  /// `differentiable_function` instruction, directly replacing them with
  /// `differentiable_function` instruction operands. If the
  /// `differentiable_function` instruction has no remaining uses, delete the
  /// instruction itself after folding.
  ///
  /// Folding can be disabled by the
  /// `SkipFoldingDifferentiableFunctionExtraction` flag for SIL testing
  /// purposes.
  void foldDifferentiableFunctionExtraction(DifferentiableFunctionInst *source);

  /// Get or create a derivative function parameter index subset thunk from
  /// `actualIndices` to `desiredIndices` for the given associated function
  /// value and original function operand. Returns a pair of the parameter
  /// index subset thunk and its interface substitution map (used to partially
  /// apply the thunk).
  /// Calls `getOrCreateSubsetParametersThunkForLinearMap` to thunk the linear
  /// map returned by the derivative function.
  std::pair<SILFunction *, SubstitutionMap>
  getOrCreateSubsetParametersThunkForDerivativeFunction(
      SILValue origFnOperand, SILValue derivativeFn,
      AutoDiffDerivativeFunctionKind kind, SILAutoDiffIndices desiredIndices,
      SILAutoDiffIndices actualIndices);

  /// Get or create a derivative function parameter index subset thunk from
  /// `actualIndices` to `desiredIndices` for the given associated function
  /// value and original function operand. Returns a pair of the parameter
  /// index subset thunk and its interface substitution map (used to partially
  /// apply the thunk).
  std::pair<SILFunction *, SubstitutionMap>
  getOrCreateSubsetParametersThunkForLinearMap(
      SILFunction *assocFn, CanSILFunctionType linearMapType,
      CanSILFunctionType targetType, AutoDiffDerivativeFunctionKind kind,
      SILAutoDiffIndices desiredIndices, SILAutoDiffIndices actualIndices);

};

} // end anonymous namespace

/// If the original function doesn't have a return, it cannot be differentiated.
/// Returns true if error is emitted.
static bool diagnoseNoReturn(ADContext &context, SILFunction *original,
                             DifferentiationInvoker invoker) {
  if (original->findReturnBB() != original->end())
    return false;
  context.emitNondifferentiabilityError(
      original->getLocation().getEndSourceLoc(), invoker,
      diag::autodiff_missing_return);
  return true;
}

/// If the original function contains unsupported control flow, emit a "control
/// flow unsupported" error at appropriate source locations. Returns true if
/// error is emitted.
///
/// Update as control flow support is added. Currently, branching terminators
/// other than `br`, `cond_br`, `switch_enum` are not supported.
static bool diagnoseUnsupportedControlFlow(ADContext &context,
                                           SILFunction *original,
                                           DifferentiationInvoker invoker) {
  if (original->getBlocks().size() <= 1)
    return false;
  // Diagnose unsupported branching terminators.
  for (auto &bb : *original) {
    auto *term = bb.getTerminator();
    // Supported terminators are: `br`, `cond_br`, `switch_enum`.
    if (isa<BranchInst>(term) || isa<CondBranchInst>(term) ||
        isa<SwitchEnumInst>(term))
      continue;
    // If terminator is an unsupported branching terminator, emit an error.
    if (term->isBranch()) {
      context.emitNondifferentiabilityError(
          term, invoker, diag::autodiff_control_flow_not_supported);
      return true;
    }
  }
  return false;
}

/// Check whether the given requirements are satisfied, with the given
/// derivative generic signature (containing requirements), and substitution
/// map. Returns true if error is emitted.
static bool diagnoseUnsatisfiedRequirements(ADContext &context,
                                            GenericSignature derivativeGenSig,
                                            SubstitutionMap substMap,
                                            DifferentiationInvoker invoker,
                                            SourceLoc loc) {
  // If there are no derivative requirements, return false.
  if (!derivativeGenSig)
    return false;
  auto requirements = derivativeGenSig->getRequirements();
  if (requirements.empty())
    return false;
  // Iterate through all requirements and check whether they are satisfied.
  auto *swiftModule = context.getModule().getSwiftModule();
  SmallVector<Requirement, 2> unsatisfiedRequirements;
  for (auto req : requirements) {
    auto firstType = req.getFirstType();
    Type secondType;
    // Substitute first and second types using the given substitution map,
    // looking up conformances in the current module, if possible.
    if (auto substFirstType =
            firstType.subst(QuerySubstitutionMap{substMap},
                            LookUpConformanceInModule(swiftModule))) {
      firstType = substFirstType;
    }
    if (req.getKind() != RequirementKind::Layout) {
      secondType = req.getSecondType();
      if (auto substSecondType =
              secondType.subst(QuerySubstitutionMap{substMap},
                               LookUpConformanceInModule(swiftModule))) {
        secondType = substSecondType;
      }
    }
    switch (req.getKind()) {
    // Check layout requirements.
    case RequirementKind::Layout: {
      auto layout = req.getLayoutConstraint();
      switch (layout->getKind()) {
      case LayoutConstraintKind::Class:
        if (!firstType->satisfiesClassConstraint())
          unsatisfiedRequirements.push_back(req);
        continue;
      default:
        // TODO: Check other layout requirements. Note that `@differentiable`
        // attribute type-checking does not yet support layout requirements in
        // where clauses; layout requirements in derivative generic signatures
        // can be formed only from `differentiable_function` instructions whose
        // original function operand is generic with layout requirements.
        break;
      }
      continue;
    }
    // Check same type requirements.
    case RequirementKind::SameType:
      // If the first type does not equal the second type, then record the
      // unsatisfied requirement.
      if (!firstType->isEqual(secondType))
        unsatisfiedRequirements.push_back(req);
      continue;
    // Check superclass requirements.
    case RequirementKind::Superclass: {
      // If the second type is not an exact superclass of second type, then
      // record the unsatisfied requirement.
      if (!secondType->isExactSuperclassOf(firstType))
        unsatisfiedRequirements.push_back(req);
      continue;
    }
    // Check conformance requirements.
    case RequirementKind::Conformance: {
      auto protocolType = req.getSecondType()->castTo<ProtocolType>();
      auto protocol = protocolType->getDecl();
      assert(protocol && "Expected protocol in generic signature requirement");
      // If the first type does not conform to the second type in the current
      // module, then record the unsatisfied requirement.
      if (!swiftModule->lookupConformance(firstType, protocol))
        unsatisfiedRequirements.push_back(req);
      continue;
    }
    }
  }
  if (unsatisfiedRequirements.empty())
    return false;
  // Diagnose unsatisfied requirements.
  std::string reqText;
  llvm::raw_string_ostream stream(reqText);
  interleave(unsatisfiedRequirements,
             [&](Requirement req) { req.print(stream, PrintOptions()); },
             [&] { stream << ", "; });
  context.emitNondifferentiabilityError(
      loc, invoker, diag::autodiff_function_assoc_func_unmet_requirements,
      stream.str());
  return true;
}

//===----------------------------------------------------------------------===//
// Code emission utilities
//===----------------------------------------------------------------------===//

/// Given a value, extracts all elements to `results` from this value if it has
/// a tuple type. Otherwise, add this value directly to `results`.
static void extractAllElements(SILValue value, SILBuilder &builder,
                               SmallVectorImpl<SILValue> &results) {
  auto tupleType = value->getType().getAs<TupleType>();
  if (!tupleType) {
    results.push_back(value);
    return;
  }
  if (builder.hasOwnership()) {
    auto *dti = builder.createDestructureTuple(value.getLoc(), value);
    results.append(dti->getResults().begin(), dti->getResults().end());
    return;
  }
  for (auto i : range(tupleType->getNumElements()))
    results.push_back(builder.createTupleExtract(value.getLoc(), value, i));
}

/// Given a range of elements, joins these into a single value. If there's
/// exactly one element, returns that element. Otherwise, creates a tuple using
/// a `tuple` instruction.
static SILValue joinElements(ArrayRef<SILValue> elements, SILBuilder &builder,
                             SILLocation loc) {
  if (elements.size() == 1)
    return elements.front();
  return builder.createTuple(loc, elements);
}

/// Given an apply site, emit copies of all parameters and place them in
/// `copiedArgs`. Any buffers that need to be destroyed will be added to
/// `newArgsToDestroy`. Any new buffers that need to be deallocated will be
/// added to `newBuffersToDealloc`. This helper is used for duplicating an
/// apply site.
static void copyParameterArgumentsForApply(
    ApplySite applySite, SmallVectorImpl<SILValue> &copiedArgs,
    SmallVectorImpl<SILValue> &newArgsToDestroy,
    SmallVectorImpl<AllocStackInst *> &newBuffersToDealloc) {
  LLVM_DEBUG({
    auto &s = getADDebugStream() << "Copying arguments from apply site: ";
    applySite.getInstruction()->print(s);
  });
  auto loc = applySite.getLoc();
  copiedArgs.reserve(applySite.getNumArguments());
  SILBuilder copyBuilder(applySite.getInstruction());
  for (auto &argOperand : applySite.getArgumentOperands()) {
    auto arg = argOperand.get();
    auto argConv = applySite.getArgumentConvention(argOperand);
    auto collectNewArg = [&](SILValue newArg) {
      copiedArgs.push_back(newArg);
      if (argConv.isGuaranteedConvention() &&
          argConv != SILArgumentConvention::Indirect_InoutAliasable)
        newArgsToDestroy.push_back(newArg);
    };
    // Copy the argument if it's to be owned by the newly created closure.
    // Objects are to be retained.
    if (arg->getType().isObject()) {
      auto newArg = copyBuilder.emitCopyValueOperation(loc, arg);
      collectNewArg(newArg);
      continue;
    }
    // Addresses depend on argument conventions.
    // If the argument is an aliasable inout reference, do not copy the
    // argument since it's a `@noescape` capture.
    if (argConv == SILArgumentConvention::Indirect_InoutAliasable) {
      collectNewArg(arg);
      continue;
    }
    // Otherwise, it must be address-only. Create a new buffer and perform
    // `copy_addr`.
    auto *argCopy = copyBuilder.createAllocStack(loc, arg->getType());
    newBuffersToDealloc.push_back(argCopy);
    copyBuilder.createCopyAddr(loc, arg, argCopy, IsNotTake,
                               IsInitialization);
    collectNewArg(argCopy);
  }
}

/// When a function value is used in an instruction (usually `apply`), there may
/// be conversion instructions in between, e.g. `thin_to_thick_function`. Given
/// a new function value and an old function value, this helper function
/// recursively converts the new function just like how the old function is
/// converted.
///
/// If the new function's generic signature is specified, it is used
/// to create substitution maps for reapplied `partial_apply` instructions.
static SILValue reapplyFunctionConversion(
    ADContext &context, SILValue newFunc, SILValue oldFunc,
    SILValue oldConvertedFunc, SILBuilder &builder, SILLocation loc,
    SmallVectorImpl<AllocStackInst *> &newBuffersToDealloc,
    IndexSubset *parameterIndices,
    GenericSignature newFuncGenSig = GenericSignature()) {
  // If the old func is the new func, then there's no conversion.
  if (oldFunc == oldConvertedFunc)
    return newFunc;
  // Handle a few instruction cases.
  // copy_value
  if (auto *cvi = dyn_cast<CopyValueInst>(oldConvertedFunc)) {
    auto innerNewFunc = reapplyFunctionConversion(
        context, newFunc, oldFunc, cvi->getOperand(), builder, loc,
        newBuffersToDealloc, parameterIndices, newFuncGenSig);
    // Note: no `copy_value` is needed for the re-converted function because the
    // caller of `reapplyFunctionConversion` should consume the re-converted
    // function.
    return innerNewFunc;
  }
  // thin_to_thick_function
  if (auto *tttfi = dyn_cast<ThinToThickFunctionInst>(oldConvertedFunc)) {
    auto innerNewFunc = reapplyFunctionConversion(
        context, newFunc, oldFunc, tttfi->getOperand(), builder, loc,
        newBuffersToDealloc, parameterIndices, newFuncGenSig);
    auto operandFnTy = innerNewFunc->getType().castTo<SILFunctionType>();
    auto thickTy = operandFnTy->getWithRepresentation(
        SILFunctionTypeRepresentation::Thick);
    auto silTy = SILType::getPrimitiveObjectType(thickTy);
    return builder.createThinToThickFunction(loc, innerNewFunc, silTy);
  }
  // partial_apply
  if (auto *pai = dyn_cast<PartialApplyInst>(oldConvertedFunc)) {
    SmallVector<SILValue, 8> newArgs;
    newArgs.reserve(pai->getNumArguments());
    SmallVector<SILValue, 1> newArgsToDestroy;
    copyParameterArgumentsForApply(pai, newArgs, newArgsToDestroy,
                                   newBuffersToDealloc);
    auto innerNewFunc = reapplyFunctionConversion(
        context, newFunc, oldFunc, pai->getCallee(), builder, loc,
        newBuffersToDealloc, parameterIndices, newFuncGenSig);
    // Reabstraction thunk `partial_apply` reapplications require special
    // support. Reabstraction thunk JVP/VJP expects a `@differentiable`
    // function-typed argument to avoid opaque function non-differentiability
    // errors. Thus, `partial_apply` reapplications must first form a
    // `differentiable_function` of the function-typed thunk argument.
    auto isReabstractionThunkCallee = [&]() -> bool {
      auto *fri = dyn_cast<FunctionRefInst>(oldFunc);
      return fri && fri->getReferencedFunctionOrNull()->isThunk() ==
                        IsReabstractionThunk;
    };
    if (isReabstractionThunkCallee()) {
      assert(newArgs.size() == 1 &&
             "Expected reabstraction thunk to be partially applied with only "
             "one argument");
      auto *dfi = context.createDifferentiableFunction(
          builder, loc, parameterIndices, newArgs.back());
      context.addDifferentiableFunctionInstToWorklist(dfi);
      newArgs.back() = dfi;
    }
    // If new function's generic signature is specified, use it to create
    // substitution map for reapplied `partial_apply` instruction.
    auto substMap = !newFuncGenSig
        ? pai->getSubstitutionMap()
        : SubstitutionMap::get(
              newFuncGenSig, QuerySubstitutionMap{pai->getSubstitutionMap()},
              LookUpConformanceInModule(builder.getModule().getSwiftModule()));
    return builder.createPartialApply(loc, innerNewFunc, substMap, newArgs,
                                      ParameterConvention::Direct_Guaranteed);
  }
  llvm_unreachable("Unhandled function conversion instruction");
}

/// Emits a reference to a derivative function of `original`, differentiated
/// with respect to a superset of `desiredIndices`. Returns the `SILValue` for
/// the derivative function and the actual indices that the derivative function
/// is with respect to.
///
/// Returns `None` on failure, signifying that a diagnostic has been emitted.
///
/// Creates new differentiation tasks, if necessary, using `invoker` as the
/// invoker. Calls `taskCallback` for all newly-created tasks (but may also call
/// `taskCallback` for already-existing tasks), so that the caller can make sure
/// that the task actually gets executed.
///
/// FIXME: This is too complicated and needs to be rewritten.
static Optional<std::pair<SILValue, SILAutoDiffIndices>>
emitDerivativeFunctionReference(
    DifferentiationTransformer &transformer,
    SILBuilder &builder, SILAutoDiffIndices desiredIndices,
    AutoDiffDerivativeFunctionKind kind, SILValue original,
    DifferentiationInvoker invoker,
    SmallVectorImpl<AllocStackInst *> &newBuffersToDealloc) {

  SILValue functionSource = original;
  ADContext &context = transformer.getContext();

  // If `original` is itself an `DifferentiableFunctionExtractInst` whose kind
  // matches the given kind and desired differentiation parameter indices,
  // simply extract the derivative function of its function operand, retain the
  // derivative function, and return it.
  if (auto *inst = original->getDefiningInstruction())
    if (auto *dfei = dyn_cast<DifferentiableFunctionExtractInst>(inst))
      if (dfei->getExtractee() ==
              NormalDifferentiableFunctionTypeComponent::Original)
        functionSource = dfei->getFunctionOperand();

  // If `functionSource` is a `@differentiable` function, just extract the
  // derivative function.
  if (auto diffableFnType =
          functionSource->getType().castTo<SILFunctionType>()) {
    if (diffableFnType->isDifferentiable()) {
      auto paramIndices = diffableFnType->getDifferentiationParameterIndices();
      for (auto i : desiredIndices.parameters->getIndices()) {
        if (!paramIndices->contains(i)) {
          context.emitNondifferentiabilityError(functionSource, invoker,
              diag::autodiff_function_nondiff_parameter_not_differentiable);
          return None;
        }
      }
      auto borrowedDiffFunc = builder.emitBeginBorrowOperation(
          functionSource.getLoc(), functionSource);
      SILValue derivativeFn = builder.createDifferentiableFunctionExtract(
          borrowedDiffFunc.getLoc(), kind, borrowedDiffFunc);
      derivativeFn =
          builder.emitCopyValueOperation(functionSource.getLoc(), derivativeFn);
      builder.emitEndBorrowOperation(functionSource.getLoc(), borrowedDiffFunc);
      SILAutoDiffIndices indices(0, desiredIndices.parameters);
      return std::make_pair(derivativeFn, indices);
    }
  }

  // Find local function reference.
  if (auto *originalFRI =
          peerThroughFunctionConversions<FunctionRefInst>(original)) {
    auto loc = originalFRI->getLoc();
    auto *originalFn = originalFRI->getReferencedFunctionOrNull();
    auto originalFnTy = originalFn->getLoweredFunctionType();
    auto *desiredResultIndices =
        IndexSubset::get(context.getASTContext(), originalFnTy->getNumResults(),
                         {desiredIndices.source});
    auto *desiredParameterIndices = desiredIndices.parameters;
    // NOTE(TF-893): Extending capacity is necessary when `originalFnTy` has
    // parameters corresponding to captured variables.
    // TODO: If posssible, change `autodiff::getLoweredParameterIndices` to
    // take `CaptureInfo` into account.
    if (originalFnTy->getNumParameters() >
        desiredParameterIndices->getCapacity()) {
      desiredParameterIndices = desiredParameterIndices->extendingCapacity(
          context.getASTContext(), originalFnTy->getNumParameters());
    }
    auto *minimalWitness = getExactDifferentiabilityWitness(
        context.getModule(), originalFn, desiredParameterIndices,
        desiredResultIndices);
    if (!minimalWitness)
      minimalWitness = getOrCreateMinimalASTDifferentiabilityWitness(
          context.getModule(), originalFn, desiredParameterIndices,
          desiredResultIndices);
    if (!minimalWitness) {
      // If the function is intentionally marked as being opaque to
      // differentiation, then we should not create a task for it.
      if (originalFn->hasSemanticsAttr("autodiff.opaque")) {
        context.emitNondifferentiabilityError(original, invoker,
            diag::autodiff_opaque_function_not_differentiable);
        return None;
      }
      // Check and diagnose non-differentiable arguments.
      auto originalFnTy = originalFn->getLoweredFunctionType();
      for (unsigned paramIndex : range(originalFnTy->getNumParameters())) {
        if (desiredIndices.isWrtParameter(paramIndex) &&
            !originalFnTy->getParameters()[paramIndex]
                 .getSILStorageInterfaceType()
                 .isDifferentiable(context.getModule())) {
          auto diag = context.emitNondifferentiabilityError(
              original, invoker, diag::autodiff_nondifferentiable_argument);
          return None;
        }
      }
      // Check and diagnose non-differentiable results.
      if (!originalFnTy->getResults()[desiredIndices.source]
               .getSILStorageInterfaceType()
               .isDifferentiable(context.getModule())) {
        context.emitNondifferentiabilityError(
            original, invoker, diag::autodiff_nondifferentiable_result);
        return None;
      }
      // Check and diagnose external declarations.
      if (originalFn->isExternalDeclaration()) {
        context.emitNondifferentiabilityError(
            original, invoker,
            diag::autodiff_external_nondifferentiable_function);
        return None;
      }
      // Sanity check passed. Create a new differentiability witness and
      // canonicalize it.
      GenericSignature contextualDerivativeGenSig = GenericSignature();
      if (invoker.getKind() ==
          DifferentiationInvoker::Kind::IndirectDifferentiation)
        contextualDerivativeGenSig = invoker.getIndirectDifferentiation().second
            ->getDerivativeGenericSignature();
      auto derivativeConstrainedGenSig =
          getConstrainedDerivativeGenericSignature(
              originalFn->getLoweredFunctionType(), desiredParameterIndices,
              contextualDerivativeGenSig);
      minimalWitness = SILDifferentiabilityWitness::createDefinition(
          context.getModule(), SILLinkage::Private, originalFn,
          desiredParameterIndices, desiredResultIndices,
          derivativeConstrainedGenSig, /*jvp*/ nullptr,
          /*vjp*/ nullptr, /*isSerialized*/ false);
      if (transformer.canonicalizeDifferentiabilityWitness(
              originalFn, minimalWitness, invoker, IsNotSerialized))
        return None;
    }
    assert(minimalWitness);
    if (original->getFunction()->isSerialized() &&
        !hasPublicVisibility(minimalWitness->getLinkage())) {
      enum { Inlinable = 0, DefaultArgument = 1 };
      unsigned fragileKind = Inlinable;
      // FIXME: This is not a very robust way of determining if the function is
      // a default argument. Also, we have not exhaustively listed all the kinds
      // of fragility.
      if (original->getFunction()->getLinkage() == SILLinkage::PublicNonABI)
        fragileKind = DefaultArgument;
      context.emitNondifferentiabilityError(
          original, invoker, diag::autodiff_private_derivative_from_fragile,
          fragileKind,
          llvm::isa_and_nonnull<AbstractClosureExpr>(
              originalFRI->getLoc().getAsASTNode<Expr>()));
      return None;
    }
    // TODO(TF-482): Move generic requirement checking logic to
    // `getExactDifferentiabilityWitness` &
    // `getOrCreateMinimalASTDifferentiabilityWitness`.
    // Get the substitution map for checking unmet generic requirements.
    // By default, use the forwarding substitution map of the original function.
    // If the original callee is a `partial_apply` or `apply` instruction, use
    // its substitution map instead.
    auto substMap = original->getFunction()->getForwardingSubstitutionMap();
    if (auto *pai =
            peerThroughFunctionConversions<PartialApplyInst>(original)) {
      substMap = pai->getSubstitutionMap();
    } else if (auto *ai = peerThroughFunctionConversions<ApplyInst>(original)) {
      substMap = ai->getSubstitutionMap();
    }
    if (diagnoseUnsatisfiedRequirements(
            context, minimalWitness->getDerivativeGenericSignature(), substMap,
            invoker, original.getLoc().getSourceLoc()))
      return None;
    DifferentiabilityWitnessFunctionKind witnessKind;
    switch (kind) {
    case AutoDiffDerivativeFunctionKind::JVP:
      witnessKind = DifferentiabilityWitnessFunctionKind::JVP;
      break;
    case AutoDiffDerivativeFunctionKind::VJP:
      witnessKind = DifferentiabilityWitnessFunctionKind::VJP;
      break;
    }
    auto *derivativeFnRef = builder.createDifferentiabilityWitnessFunction(
        loc, witnessKind, minimalWitness);
    auto convertedRef = reapplyFunctionConversion(
        context, derivativeFnRef, originalFRI, original, builder, loc,
        newBuffersToDealloc, desiredIndices.parameters,
        derivativeFnRef->getType()
            .getASTType()
            ->castTo<SILFunctionType>()
            ->getSubstGenericSignature());
    return std::make_pair(
        convertedRef,
        SILAutoDiffIndices(desiredIndices.source,
                           minimalWitness->getParameterIndices()));
  }

  // Find witness method retrieval.
  if (auto *witnessMethod =
          peerThroughFunctionConversions<WitnessMethodInst>(original)) {
    auto loc = witnessMethod->getLoc();
    auto requirementDeclRef = witnessMethod->getMember();
    auto *requirementDecl = requirementDeclRef.getAbstractFunctionDecl();
    // If requirement declaration does not have any `@differentiable`
    // attributes, produce an error.
    if (!requirementDecl->getAttrs().hasAttribute<DifferentiableAttr>()) {
      context.emitNondifferentiabilityError(
          original, invoker, diag::autodiff_protocol_member_not_differentiable);
      return None;
    }
    // Find the minimal derivative configuration: minimal parameter indices and
    // corresponding derivative generic signature. If it does not exist, produce
    // an error.
    IndexSubset *minimalASTParamIndices = nullptr;
    IndexSubset *minimalSILParamIndices = nullptr;
    GenericSignature derivativeGenericSignature;
    if (!findMinimalDerivativeConfiguration(
            requirementDecl, desiredIndices.parameters, minimalASTParamIndices,
            minimalSILParamIndices, derivativeGenericSignature)) {
      context.emitNondifferentiabilityError(
          original, invoker,
          diag::autodiff_member_subset_indices_not_differentiable);
      return None;
    }
    SILAutoDiffIndices minimalIndices(/*source*/ 0, minimalSILParamIndices);
    // Emit a `witness_method` instruction for the derivative function.
    auto originalType = witnessMethod->getType().castTo<SILFunctionType>();
    auto assocType = originalType->getAutoDiffDerivativeFunctionType(
        minimalIndices.parameters, minimalIndices.source,
        kind, context.getTypeConverter(),
        LookUpConformanceInModule(builder.getModule().getSwiftModule()));
    auto *autoDiffFuncId = AutoDiffDerivativeFunctionIdentifier::get(
        kind, minimalASTParamIndices, context.getASTContext());
    auto *ref = builder.createWitnessMethod(
        loc, witnessMethod->getLookupType(), witnessMethod->getConformance(),
        requirementDeclRef.asAutoDiffDerivativeFunction(autoDiffFuncId),
        SILType::getPrimitiveObjectType(assocType));
    auto convertedRef = reapplyFunctionConversion(
        context, ref, witnessMethod, original, builder, loc,
        newBuffersToDealloc, desiredIndices.parameters);
    return std::make_pair(convertedRef, minimalIndices);
  }

  // Find class method.
  if (auto *classMethodInst =
          peerThroughFunctionConversions<ClassMethodInst>(original)) {
    auto loc = classMethodInst->getLoc();
    auto methodDeclRef = classMethodInst->getMember();
    auto *methodDecl = methodDeclRef.getAbstractFunctionDecl();
    // If method declaration does not have any `@differentiable` attributes,
    // produce an error.
    if (!methodDecl->getAttrs().hasAttribute<DifferentiableAttr>()) {
      context.emitNondifferentiabilityError(
          original, invoker, diag::autodiff_class_member_not_differentiable);
      return None;
    }
    // Find the minimal derivative configuration: minimal parameter indices and
    // corresponding derivative generic signature. If it does not exist, produce
    // an error.
    IndexSubset *minimalASTParamIndices = nullptr;
    IndexSubset *minimalSILParamIndices = nullptr;
    GenericSignature derivativeGenericSignature;
    if (!findMinimalDerivativeConfiguration(
            methodDecl, desiredIndices.parameters, minimalASTParamIndices,
            minimalSILParamIndices, derivativeGenericSignature)) {
      context.emitNondifferentiabilityError(
          original, invoker,
          diag::autodiff_member_subset_indices_not_differentiable);
      return None;
    }
    SILAutoDiffIndices minimalIndices(/*source*/ 0, minimalSILParamIndices);
    // Emit a `class_method` instruction for the derivative function.
    auto originalType = classMethodInst->getType().castTo<SILFunctionType>();
    auto assocType = originalType->getAutoDiffDerivativeFunctionType(
        minimalIndices.parameters, minimalIndices.source, kind,
        context.getTypeConverter(),
        LookUpConformanceInModule(builder.getModule().getSwiftModule()));
    auto *autoDiffFuncId = AutoDiffDerivativeFunctionIdentifier::get(
        kind, minimalASTParamIndices, context.getASTContext());
    auto *ref = builder.createClassMethod(
        loc, classMethodInst->getOperand(),
        methodDeclRef.asAutoDiffDerivativeFunction(autoDiffFuncId),
        SILType::getPrimitiveObjectType(assocType));
    auto convertedRef = reapplyFunctionConversion(
        context, ref, classMethodInst, original, builder, loc,
        newBuffersToDealloc, desiredIndices.parameters);
    return std::make_pair(convertedRef, minimalIndices);
  }

  // Emit the general opaque function error.
  context.emitNondifferentiabilityError(original, invoker,
      diag::autodiff_opaque_function_not_differentiable);
  return None;
}

/// Emit a zero value into the given buffer access by calling
/// `AdditiveArithmetic.zero`. The given type must conform to
/// `AdditiveArithmetic`.
static void emitZeroIntoBuffer(
    SILBuilder &builder, CanType type, SILValue bufferAccess,
    SILLocation loc) {
  auto &astCtx = builder.getASTContext();
  auto *swiftMod = builder.getModule().getSwiftModule();
  auto &typeConverter = builder.getModule().Types;
  // Look up conformance to `AdditiveArithmetic`.
  auto *additiveArithmeticProto =
      astCtx.getProtocol(KnownProtocolKind::AdditiveArithmetic);
  auto confRef = swiftMod->lookupConformance(type, additiveArithmeticProto);
  assert(!confRef.isInvalid() && "Missing conformance to `AdditiveArithmetic`");
  // Look up `AdditiveArithmetic.zero.getter`.
  auto zeroDeclLookup = additiveArithmeticProto->lookupDirect(astCtx.Id_zero);
  auto *zeroDecl = cast<VarDecl>(zeroDeclLookup.front());
  assert(zeroDecl->isProtocolRequirement());
  auto *accessorDecl = zeroDecl->getAccessor(AccessorKind::Get);
  SILDeclRef accessorDeclRef(accessorDecl, SILDeclRef::Kind::Func);
  auto silFnType = typeConverter.getConstantType(
      TypeExpansionContext::minimal(), accessorDeclRef);
  // %wm = witness_method ...
  auto *getter = builder.createWitnessMethod(
      loc, type, confRef, accessorDeclRef, silFnType);
  // %metatype = metatype $T
  auto metatypeType = CanMetatypeType::get(
      type, MetatypeRepresentation::Thick);
  auto metatype = builder.createMetatype(
      loc, SILType::getPrimitiveObjectType(metatypeType));
  auto subMap = SubstitutionMap::getProtocolSubstitutions(
      additiveArithmeticProto, type, confRef);
  builder.createApply(loc, getter, subMap, {bufferAccess, metatype},
                      /*isNonThrowing*/ false);
  builder.emitDestroyValueOperation(loc, getter);
}

//===----------------------------------------------------------------------===//
// Thunk helpers
//===----------------------------------------------------------------------===//
// These helpers are copied/adapted from SILGen. They should be refactored and
// moved to a shared location.
//===----------------------------------------------------------------------===//

static CanGenericSignature
buildThunkSignature(SILFunction *fn,
                    bool inheritGenericSig,
                    OpenedArchetypeType *openedExistential,
                    GenericEnvironment *&genericEnv,
                    SubstitutionMap &contextSubs,
                    SubstitutionMap &interfaceSubs,
                    ArchetypeType *&newArchetype) {
  // If there's no opened existential, we just inherit the generic environment
  // from the parent function.
  if (openedExistential == nullptr) {
    auto genericSig = fn->getLoweredFunctionType()->getSubstGenericSignature();
    genericEnv = fn->getGenericEnvironment();
    interfaceSubs = fn->getForwardingSubstitutionMap();
    contextSubs = interfaceSubs;
    return genericSig;
  }

  auto &ctx = fn->getASTContext();
  GenericSignatureBuilder builder(ctx);

  // Add the existing generic signature.
  int depth = 0;
  if (inheritGenericSig) {
    if (auto genericSig =
            fn->getLoweredFunctionType()->getSubstGenericSignature()) {
      builder.addGenericSignature(genericSig);
      depth = genericSig->getGenericParams().back()->getDepth() + 1;
    }
  }

  // Add a new generic parameter to replace the opened existential.
  auto *newGenericParam = GenericTypeParamType::get(depth, 0, ctx);

  builder.addGenericParameter(newGenericParam);
  Requirement newRequirement(RequirementKind::Conformance, newGenericParam,
                             openedExistential->getOpenedExistentialType());
  auto source =
      GenericSignatureBuilder::FloatingRequirementSource::forAbstract();
  builder.addRequirement(newRequirement, source, nullptr);

  auto genericSig = std::move(builder).computeGenericSignature(
      SourceLoc(), /*allowConcreteGenericParams=*/true);
  genericEnv = genericSig->getGenericEnvironment();

  newArchetype = genericEnv->mapTypeIntoContext(newGenericParam)
      ->castTo<ArchetypeType>();

  // Calculate substitutions to map the caller's archetypes to the thunk's
  // archetypes.
  if (auto calleeGenericSig =
          fn->getLoweredFunctionType()->getSubstGenericSignature()) {
    contextSubs = SubstitutionMap::get(
        calleeGenericSig,
        [&](SubstitutableType *type) -> Type {
          return genericEnv->mapTypeIntoContext(type);
        },
        MakeAbstractConformanceForGenericType());
  }

  // Calculate substitutions to map interface types to the caller's archetypes.
  interfaceSubs = SubstitutionMap::get(
      genericSig,
      [&](SubstitutableType *type) -> Type {
        if (type->isEqual(newGenericParam))
          return openedExistential;
        return fn->mapTypeIntoContext(type);
      },
      MakeAbstractConformanceForGenericType());

  return genericSig->getCanonicalSignature();

}

/// The thunk kinds used in the differentiation transform.
enum class DifferentiationThunkKind {
  /// A reabstraction thunk.
  ///
  /// Reabstraction thunks transform a function-typed value to another one with
  /// different parameter/result abstraction patterns. This is identical to the
  /// thunks generated by SILGen.
  Reabstraction,

  /// An index subset thunk.
  ///
  /// An index subset thunk is used transform JVP/VJPs into a version that is
  /// "wrt" fewer differentiation parameters.
  /// - Differentials of thunked JVPs use zero for non-requested differentiation
  //    parameters.
  /// - Pullbacks of thunked VJPs discard results for non-requested
  ///   differentiation parameters.
  IndexSubset
};

/// Build the type of a function transformation thunk.
static CanSILFunctionType buildThunkType(SILFunction *fn,
                                         CanSILFunctionType &sourceType,
                                         CanSILFunctionType &expectedType,
                                         GenericEnvironment *&genericEnv,
                                         SubstitutionMap &interfaceSubs,
                                         bool withoutActuallyEscaping,
                                         DifferentiationThunkKind thunkKind) {
  assert(!expectedType->isPolymorphic());
  assert(!sourceType->isPolymorphic());

  auto &module = fn->getModule();
  auto origType = sourceType;

  // Cannot build a reabstraction thunk without context. Ownership semantics
  // on the result type are required.
  if (thunkKind == DifferentiationThunkKind::Reabstraction)
    assert(expectedType->getExtInfo().hasContext());

  // This may inherit @noescape from the expected type. The `@noescape`
  // attribute is only stripped when using this type to materialize a new decl.
  // Use `@convention(thin)` if:
  // - Building a reabstraction thunk type.
  // - Building an index subset thunk type, where the expected type has context
  //   (i.e. is `@convention(thick)`).
  auto extInfo = expectedType->getExtInfo();
  if (thunkKind == DifferentiationThunkKind::Reabstraction ||
      extInfo.hasContext()) {
    extInfo = extInfo.withRepresentation(
        SILFunctionType::Representation::Thin);
  }
  if (withoutActuallyEscaping)
    extInfo = extInfo.withNoEscape(false);

  // Does the thunk type involve archetypes other than opened existentials?
  bool hasArchetypes = false;
  // Does the thunk type involve an open existential type?
  CanOpenedArchetypeType openedExistential;
  auto archetypeVisitor = [&](CanType t) {
    if (auto archetypeTy = dyn_cast<OpenedArchetypeType>(t)) {
      if (auto opened = dyn_cast<OpenedArchetypeType>(archetypeTy)) {
        assert((openedExistential == CanArchetypeType() ||
                openedExistential == opened) &&
               "one too many open existentials");
        openedExistential = opened;
      } else {
        hasArchetypes = true;
      }
    }
  };

  // Use the generic signature from the context if the thunk involves
  // generic parameters.
  CanGenericSignature genericSig;
  SubstitutionMap contextSubs;
  ArchetypeType *newArchetype = nullptr;

  if (expectedType->hasArchetype() || sourceType->hasArchetype()) {
    expectedType.visit(archetypeVisitor);
    sourceType.visit(archetypeVisitor);
    genericSig = buildThunkSignature(
        fn, hasArchetypes, openedExistential, genericEnv, contextSubs,
        interfaceSubs, newArchetype);
  }

  // Utility function to apply contextSubs, and also replace the
  // opened existential with the new archetype.
  auto substIntoThunkContext = [&](CanType t) -> CanType {
    return t.subst(
        [&](SubstitutableType *type) -> Type {
          if (CanType(type) == openedExistential)
            return newArchetype;
          return Type(type).subst(contextSubs);
        },
        LookUpConformanceInSubstitutionMap(contextSubs),
        SubstFlags::AllowLoweredTypes)->getCanonicalType();
  };

  sourceType = cast<SILFunctionType>(substIntoThunkContext(sourceType));
  expectedType = cast<SILFunctionType>(substIntoThunkContext(expectedType));

  // If our parent function was pseudogeneric, this thunk must also be
  // pseudogeneric, since we have no way to pass generic parameters.
  if (genericSig)
    if (origType->isPseudogeneric())
      extInfo = extInfo.withIsPseudogeneric();

  // Add the function type as the parameter.
  auto contextConvention =
      SILType::getPrimitiveObjectType(sourceType).isTrivial(*fn)
          ? ParameterConvention::Direct_Unowned
          : ParameterConvention::Direct_Guaranteed;
  SmallVector<SILParameterInfo, 4> params;
  params.append(expectedType->getParameters().begin(),
                expectedType->getParameters().end());
  // Add reabstraction function parameter only if building a reabstraction thunk
  // type.
  if (thunkKind == DifferentiationThunkKind::Reabstraction)
    params.push_back({sourceType, sourceType->getExtInfo().hasContext()
                                      ? contextConvention
                                      : ParameterConvention::Direct_Unowned});

  // Map the parameter and expected types out of context to get the interface
  // type of the thunk.
  SmallVector<SILParameterInfo, 4> interfaceParams;
  interfaceParams.reserve(params.size());
  for (auto &param : params) {
    auto paramIfaceTy = param.getInterfaceType()->mapTypeOutOfContext();
    interfaceParams.push_back(SILParameterInfo(
        paramIfaceTy->getCanonicalType(genericSig), param.getConvention()));
  }

  SmallVector<SILYieldInfo, 4> interfaceYields;
  for (auto &yield : expectedType->getYields()) {
    auto yieldIfaceTy = yield.getInterfaceType()->mapTypeOutOfContext();
    auto interfaceYield =
        yield.getWithInterfaceType(yieldIfaceTy->getCanonicalType(genericSig));
    interfaceYields.push_back(interfaceYield);
  }

  SmallVector<SILResultInfo, 4> interfaceResults;
  for (auto &result : expectedType->getResults()) {
    auto resultIfaceTy = result.getInterfaceType()->mapTypeOutOfContext();
    auto interfaceResult =
        result.getWithInterfaceType(resultIfaceTy->getCanonicalType(genericSig));
    interfaceResults.push_back(interfaceResult);
  }

  Optional<SILResultInfo> interfaceErrorResult;
  if (expectedType->hasErrorResult()) {
    auto errorResult = expectedType->getErrorResult();
    auto errorIfaceTy = errorResult.getInterfaceType()->mapTypeOutOfContext();
    interfaceErrorResult =
        SILResultInfo(errorIfaceTy->getCanonicalType(genericSig),
                      expectedType->getErrorResult().getConvention());
  }

  // The type of the thunk function.
  return SILFunctionType::get(
      genericSig, extInfo, expectedType->getCoroutineKind(),
      ParameterConvention::Direct_Unowned, interfaceParams, interfaceYields,
      interfaceResults, interfaceErrorResult, {}, false, module.getASTContext());
}

/// Get or create a reabstraction thunk from `fromType` to `toType`, to be
/// called in `caller`.
static SILFunction *getOrCreateReabstractionThunk(SILOptFunctionBuilder &fb,
                                                  SILModule &module,
                                                  SILLocation loc,
                                                  SILFunction *caller,
                                                  CanSILFunctionType fromType,
                                                  CanSILFunctionType toType) {
  SubstitutionMap interfaceSubs;
  GenericEnvironment *genericEnv = nullptr;
  auto thunkType = buildThunkType(
      caller, fromType, toType, genericEnv, interfaceSubs,
      /*withoutActuallyEscaping*/ false,
      DifferentiationThunkKind::Reabstraction);
  auto thunkDeclType =
      thunkType->getWithExtInfo(thunkType->getExtInfo().withNoEscape(false));

  auto fromInterfaceType = fromType->mapTypeOutOfContext()->getCanonicalType();
  auto toInterfaceType = toType->mapTypeOutOfContext()->getCanonicalType();

  Mangle::ASTMangler mangler;
  std::string name = mangler.mangleReabstractionThunkHelper(
      thunkType, fromInterfaceType, toInterfaceType,
      Type(), module.getSwiftModule());

  // FIXME(TF-989): Mark reabstraction thunks as transparent. This requires
  // generating ossa reabstraction thunks so that they can be inlined during
  // mandatory inlining when `-enable-strip-ownership-after-serialization` is
  // true and ownership model eliminator is not run after differentiation.
  auto *thunk = fb.getOrCreateSharedFunction(
      loc, name, thunkDeclType, IsBare, IsNotTransparent, IsSerialized,
      ProfileCounter(), IsReabstractionThunk, IsNotDynamic);
  if (!thunk->empty())
    return thunk;

  thunk->setGenericEnvironment(genericEnv);
  thunk->setOwnershipEliminated();
  auto *entry = thunk->createBasicBlock();
  SILBuilder builder(entry);
  createEntryArguments(thunk);

  SILFunctionConventions fromConv(fromType, module);
  SILFunctionConventions toConv(toType, module);
  assert(toConv.useLoweredAddresses());

  auto *fnArg = thunk->getArgumentsWithoutIndirectResults().back();

  SmallVector<SILValue, 4> arguments;
  auto toArgIter = thunk->getArguments().begin();
  auto useNextArgument = [&]() {
    arguments.push_back(*toArgIter++);
  };

  SmallVector<AllocStackInst *, 4> localAllocations;
  auto createAllocStack = [&](SILType type) {
    auto *alloc = builder.createAllocStack(loc, type);
    localAllocations.push_back(alloc);
    return alloc;
  };

  // Handle indirect results.
  assert(fromType->getNumResults() == toType->getNumResults());
  for (unsigned resIdx : range(toType->getNumResults())) {
    auto fromRes = fromConv.getResults()[resIdx];
    auto toRes = toConv.getResults()[resIdx];
    // No abstraction mismatch.
    if (fromRes.isFormalIndirect() == toRes.isFormalIndirect()) {
      // If result types are indirect, directly pass as next argument.
      if (toRes.isFormalIndirect())
        useNextArgument();
      continue;
    }
    // Convert indirect result to direct result.
    if (fromRes.isFormalIndirect()) {
      SILType resultTy = fromConv.getSILType(fromRes);
      assert(resultTy.isAddress());
      auto *indRes = createAllocStack(resultTy);
      arguments.push_back(indRes);
      continue;
    }
    // Convert direct result to indirect result.
    // Increment thunk argument iterator; reabstraction handled later.
    toArgIter++;
  }

  // Reabstract parameters.
  assert(toType->getNumParameters() == fromType->getNumParameters());
  for (unsigned paramIdx : range(toType->getNumParameters())) {
    auto fromParam = fromConv.getParameters()[paramIdx];
    auto toParam = toConv.getParameters()[paramIdx];
    // No abstraction mismatch. Directly use next argument.
    if (fromParam.isFormalIndirect() == toParam.isFormalIndirect()) {
      useNextArgument();
      continue;
    }
    // Convert indirect parameter to direct parameter.
    if (fromParam.isFormalIndirect()) {
      auto paramTy = fromConv.getSILType(fromType->getParameters()[paramIdx]);
      if (!paramTy.hasArchetype())
        paramTy = thunk->mapTypeIntoContext(paramTy);
      assert(paramTy.isAddress());
      auto *toArg = *toArgIter++;
      auto *buf = createAllocStack(toArg->getType());
      builder.createStore(loc, toArg, buf,
                          StoreOwnershipQualifier::Unqualified);
      arguments.push_back(buf);
      continue;
    }
    // Convert direct parameter to indirect parameter.
    assert(toParam.isFormalIndirect());
    auto *toArg = *toArgIter++;
    auto *load = builder.createLoad(loc, toArg,
                                    LoadOwnershipQualifier::Unqualified);
    arguments.push_back(load);
  }

  auto *apply = builder.createApply(
      loc, fnArg, SubstitutionMap(), arguments, /*isNonThrowing*/ false);

  // Get return elements.
  SmallVector<SILValue, 4> results;
  // Extract all direct results.
  SmallVector<SILValue, 4> directResults;
  extractAllElements(apply, builder, directResults);

  auto fromDirResultsIter = directResults.begin();
  auto fromIndResultsIter = apply->getIndirectSILResults().begin();
  auto toIndResultsIter = thunk->getIndirectResults().begin();
  // Reabstract results.
  for (unsigned resIdx : range(toType->getNumResults())) {
    auto fromRes = fromConv.getResults()[resIdx];
    auto toRes = toConv.getResults()[resIdx];
    // No abstraction mismatch.
    if (fromRes.isFormalIndirect() == toRes.isFormalIndirect()) {
      // If result types are direct, add call result as direct thunk result.
      if (toRes.isFormalDirect())
        results.push_back(*fromDirResultsIter++);
      // If result types are indirect, increment indirect result iterators.
      else {
        ++fromIndResultsIter;
        ++toIndResultsIter;
      }
      continue;
    }
    // Load direct results from indirect results.
    if (fromRes.isFormalIndirect()) {
      auto indRes = *fromIndResultsIter++;
      auto *load = builder.createLoad(loc, indRes,
                                      LoadOwnershipQualifier::Unqualified);
      results.push_back(load);
      continue;
    }
    // Store direct results to indirect results.
    assert(toRes.isFormalIndirect());
    SILType resultTy = toConv.getSILType(toRes);
    assert(resultTy.isAddress());
    auto indRes = *toIndResultsIter++;
    builder.createStore(loc, *fromDirResultsIter++, indRes,
                        StoreOwnershipQualifier::Unqualified);
  }
  auto retVal = joinElements(results, builder, loc);

  // Deallocate local allocations.
  for (auto *alloc : llvm::reverse(localAllocations))
    builder.createDeallocStack(loc, alloc);

  // Create return.
  builder.createReturn(loc, retVal);

  LLVM_DEBUG(auto &s = getADDebugStream() << "Created reabstraction thunk.\n";
             s << "  From type: " << fromType << '\n';
             s << "  To type: " << toType << '\n';
             s << '\n' << *thunk);

  return thunk;
}

namespace {
class VJPEmitter final
    : public TypeSubstCloner<VJPEmitter, SILOptFunctionBuilder> {
  friend class PullbackEmitter;

private:
  /// The global context.
  ADContext &context;

  /// The original function.
  SILFunction *const original;

  /// The differentiability witness.
  SILDifferentiabilityWitness *const witness;

  /// The VJP function.
  SILFunction *const vjp;

  /// The pullback function.
  SILFunction *pullback;

  /// The differentiation invoker.
  DifferentiationInvoker invoker;

  /// Info from activity analysis on the original function.
  const DifferentiableActivityInfo &activityInfo;

  /// The linear map info.
  LinearMapInfo pullbackInfo;

  /// Caches basic blocks whose phi arguments have been remapped (adding a
  /// predecessor enum argument).
  SmallPtrSet<SILBasicBlock *, 4> remappedBasicBlocks;

  bool errorOccurred = false;

  /// Mapping from original blocks to pullback values. Used to build pullback
  /// struct instances.
  DenseMap<SILBasicBlock *, SmallVector<SILValue, 8>> pullbackValues;

  ASTContext &getASTContext() const { return vjp->getASTContext(); }
  SILModule &getModule() const { return vjp->getModule(); }
  const SILAutoDiffIndices getIndices() const {
    return witness->getSILAutoDiffIndices();
  }

  static SubstitutionMap getSubstitutionMap(SILFunction *original,
                                            SILFunction *vjp) {
    auto substMap = original->getForwardingSubstitutionMap();
    if (auto *vjpGenEnv = vjp->getGenericEnvironment()) {
      auto vjpSubstMap = vjpGenEnv->getForwardingSubstitutionMap();
      substMap = SubstitutionMap::get(
          vjpGenEnv->getGenericSignature(), QuerySubstitutionMap{vjpSubstMap},
          LookUpConformanceInSubstitutionMap(vjpSubstMap));
    }
    return substMap;
  }

  static const DifferentiableActivityInfo &
  getActivityInfo(ADContext &context, SILFunction *original,
                  SILAutoDiffIndices indices, SILFunction *vjp) {
    // Get activity info of the original function.
    auto &passManager = context.getPassManager();
    auto *activityAnalysis =
        passManager.getAnalysis<DifferentiableActivityAnalysis>();
    auto &activityCollection = *activityAnalysis->get(original);
    auto &activityInfo = activityCollection.getActivityInfo(
        vjp->getLoweredFunctionType()->getSubstGenericSignature(),
        AutoDiffDerivativeFunctionKind::VJP);
    LLVM_DEBUG(activityInfo.dump(indices, getADDebugStream()));
    return activityInfo;
  }

public:
  explicit VJPEmitter(ADContext &context, SILFunction *original,
                      SILDifferentiabilityWitness *witness, SILFunction *vjp,
                      DifferentiationInvoker invoker)
      : TypeSubstCloner(*vjp, *original, getSubstitutionMap(original, vjp)),
        context(context), original(original), witness(witness), vjp(vjp),
        invoker(invoker),
        activityInfo(getActivityInfo(context, original,
                                     witness->getSILAutoDiffIndices(), vjp)),
        pullbackInfo(context, AutoDiffLinearMapKind::Pullback, original, vjp,
                     witness->getSILAutoDiffIndices(), activityInfo) {
    // Create empty pullback function.
    pullback = createEmptyPullback();
    context.recordGeneratedFunction(pullback);
  }

  SILFunction *createEmptyPullback() {
    auto &module = context.getModule();
    auto origTy = original->getLoweredFunctionType();
    auto lookupConformance = LookUpConformanceInModule(module.getSwiftModule());

    // RAII that pushes the original function's generic signature to
    // `module.Types` so that the calls to `module.Types.getTypeLowering()`
    // below will know the original function's generic parameter types.
    Lowering::GenericContextScope genericContextScope(
        module.Types, origTy->getSubstGenericSignature());

    // Given a type, returns its formal SIL parameter info.
    auto getTangentParameterInfoForOriginalResult = [&](
        CanType tanType, ResultConvention origResConv) -> SILParameterInfo {
      auto &tl = context.getTypeConverter().getTypeLowering(
          tanType, TypeExpansionContext::minimal());
      ParameterConvention conv;
      switch (origResConv) {
      case ResultConvention::Owned:
      case ResultConvention::Autoreleased:
        conv = tl.isTrivial()
            ? ParameterConvention::Direct_Unowned
            : ParameterConvention::Direct_Guaranteed;
        break;
      case ResultConvention::Unowned:
      case ResultConvention::UnownedInnerPointer:
        conv = ParameterConvention::Direct_Unowned;
        break;
      case ResultConvention::Indirect:
        conv = ParameterConvention::Indirect_In_Guaranteed;
        break;
      }
      return {tanType, conv};
    };

    // Given a type, returns its formal SIL result info.
    auto getTangentResultInfoForOriginalParameter = [&](
        CanType tanType, ParameterConvention origParamConv) -> SILResultInfo {
      auto &tl = context.getTypeConverter().getTypeLowering(
          tanType, TypeExpansionContext::minimal());
      ResultConvention conv;
      switch (origParamConv) {
      case ParameterConvention::Direct_Owned:
      case ParameterConvention::Direct_Guaranteed:
      case ParameterConvention::Direct_Unowned:
        conv = tl.isTrivial()
            ? ResultConvention::Unowned
            : ResultConvention::Owned;
        break;
      case ParameterConvention::Indirect_In:
      case ParameterConvention::Indirect_Inout:
      case ParameterConvention::Indirect_In_Constant:
      case ParameterConvention::Indirect_In_Guaranteed:
      case ParameterConvention::Indirect_InoutAliasable:
        conv = ResultConvention::Indirect;
        break;
      }
      return {tanType, conv};
    };

    // Parameters of the pullback are:
    // - the tangent vectors of the original results, and
    // - a pullback struct.
    // Results of the pullback are in the tangent space of the original
    // parameters.
    SmallVector<SILParameterInfo, 8> pbParams;
    SmallVector<SILResultInfo, 8> adjResults;
    auto origParams = origTy->getParameters();
    auto indices = witness->getSILAutoDiffIndices();

    // Add pullback parameter for the seed.
    auto origResInfo = origTy->getResults()[indices.source];
    pbParams.push_back(getTangentParameterInfoForOriginalResult(
        origResInfo.getInterfaceType()
            ->getAutoDiffAssociatedTangentSpace(lookupConformance)
            ->getCanonicalType(), origResInfo.getConvention()));

    // Accept a pullback struct in the pullback parameter list. This is the
    // returned pullback's closure context.
    auto *origExit = &*original->findReturnBB();
    auto *pbStruct = pullbackInfo.getLinearMapStruct(origExit);
    auto pbStructType = pbStruct->getDeclaredInterfaceType()
        ->getCanonicalType();
    pbParams.push_back({pbStructType, ParameterConvention::Direct_Owned});

    // Add pullback results for the requested wrt parameters.
    for (auto i : indices.parameters->getIndices()) {
      auto origParam = origParams[i];
      adjResults.push_back(getTangentResultInfoForOriginalParameter(
          origParam.getInterfaceType()
              ->getAutoDiffAssociatedTangentSpace(lookupConformance)
              ->getCanonicalType(), origParam.getConvention()));
    }

    Mangle::ASTMangler mangler;
    auto pbName = original->getASTContext().getIdentifier(
        mangler.mangleAutoDiffLinearMapHelper(
            original->getName(), AutoDiffLinearMapKind::Pullback,
            indices)).str();
    auto pbGenericSig = getDerivativeGenericSignature(witness, original);
    auto *pbGenericEnv =
        pbGenericSig ? pbGenericSig->getGenericEnvironment() : nullptr;
    auto pbType = SILFunctionType::get(
        pbGenericSig, origTy->getExtInfo(), origTy->getCoroutineKind(),
        origTy->getCalleeConvention(), pbParams, {}, adjResults, None,
        origTy->getSubstitutions(), origTy->isGenericSignatureImplied(),
        original->getASTContext());

    SILOptFunctionBuilder fb(context.getTransform());
    auto linkage =
        vjp->isSerialized() ? SILLinkage::Public : SILLinkage::Private;
    auto *pullback = fb.createFunction(
        linkage, pbName, pbType, pbGenericEnv, original->getLocation(),
        original->isBare(), IsNotTransparent, vjp->isSerialized(),
        original->isDynamicallyReplaceable());
    pullback->setDebugScope(new (module)
                                SILDebugScope(original->getLocation(),
                                              pullback));
    return pullback;
  }

  /// Run VJP generation. Returns true on error.
  bool run();

  void postProcess(SILInstruction *orig, SILInstruction *cloned) {
    if (errorOccurred)
      return;
    SILClonerWithScopes::postProcess(orig, cloned);
  }

  /// Remap original basic blocks, adding predecessor enum arguments.
  SILBasicBlock *remapBasicBlock(SILBasicBlock *bb) {
    auto *vjpBB = BBMap[bb];
    // If error has occurred, or if block has already been remapped, return
    // remapped, return remapped block.
    if (errorOccurred || remappedBasicBlocks.count(bb))
      return vjpBB;
    // Add predecessor enum argument to the remapped block.
    auto *predEnum = pullbackInfo.getBranchingTraceDecl(bb);
    auto enumTy = getOpASTType(predEnum->getDeclaredInterfaceType()
                                 ->getCanonicalType());
    auto enumLoweredTy = context.getTypeConverter().getLoweredType(
        enumTy, TypeExpansionContext::minimal());
    vjpBB->createPhiArgument(enumLoweredTy, ValueOwnershipKind::Owned);
    remappedBasicBlocks.insert(bb);
    return vjpBB;
  }

  /// General visitor for all instructions. If any error is emitted by previous
  /// visits, bail out.
  void visit(SILInstruction *inst) {
    if (errorOccurred)
      return;
    TypeSubstCloner::visit(inst);
  }

  void visitSILInstruction(SILInstruction *inst) {
    context.emitNondifferentiabilityError(inst, invoker,
        diag::autodiff_expression_not_differentiable_note);
    errorOccurred = true;
  }

private:
  /// Get the lowered SIL type of the given nominal type declaration.
  SILType getNominalDeclLoweredType(NominalTypeDecl *nominal) {
    auto nomType = getOpASTType(
        nominal->getDeclaredInterfaceType()->getCanonicalType());
    auto nomSILType = context.getTypeConverter().getLoweredType(
        nomType, TypeExpansionContext::minimal());
    return nomSILType;
  }

  /// Build a pullback struct value for the original block corresponding to the
  /// given terminator.
  StructInst *buildPullbackValueStructValue(TermInst *termInst) {
    assert(termInst->getFunction() == original);
    auto loc = termInst->getFunction()->getLocation();
    auto *origBB = termInst->getParent();
    auto *vjpBB = BBMap[origBB];
    auto *pbStruct = pullbackInfo.getLinearMapStruct(origBB);
    auto structLoweredTy = getNominalDeclLoweredType(pbStruct);
    auto bbPullbackValues = pullbackValues[origBB];
    if (!origBB->isEntry()) {
      auto *predEnumArg = vjpBB->getArguments().back();
      bbPullbackValues.insert(bbPullbackValues.begin(), predEnumArg);
    }
    return getBuilder().createStruct(loc, structLoweredTy, bbPullbackValues);
  }

  /// Build a predecessor enum instance using the given builder for the given
  /// original predecessor/successor blocks and pullback struct value.
  EnumInst *buildPredecessorEnumValue(SILBuilder &builder,
                                      SILBasicBlock *predBB,
                                      SILBasicBlock *succBB,
                                      SILValue pbStructVal) {
    auto loc = pbStructVal.getLoc();
    auto *succEnum = pullbackInfo.getBranchingTraceDecl(succBB);
    auto enumLoweredTy = getNominalDeclLoweredType(succEnum);
    auto *enumEltDecl =
        pullbackInfo.lookUpBranchingTraceEnumElement(predBB, succBB);
    auto enumEltType = getOpType(enumLoweredTy.getEnumElementType(
        enumEltDecl, getModule(), TypeExpansionContext::minimal()));
    // If the enum element type does not have a box type (i.e. the enum case is
    // not indirect), then directly create an enum.
    auto boxType = dyn_cast<SILBoxType>(enumEltType.getASTType());
    if (!boxType)
      return builder.createEnum(loc, pbStructVal, enumEltDecl, enumLoweredTy);
    // Otherwise, box the pullback struct value and create an enum.
    auto *newBox = builder.createAllocBox(loc, boxType);
    builder.emitScopedBorrowOperation(
        loc, newBox, [&](SILValue borrowedBox) {
      auto *projectBox = builder.createProjectBox(loc, newBox, /*index*/ 0);
      builder.emitStoreValueOperation(loc, pbStructVal, projectBox,
                                      StoreOwnershipQualifier::Init);
    });
    return builder.createEnum(loc, newBox, enumEltDecl, enumLoweredTy);
  }

public:
  void visitReturnInst(ReturnInst *ri) {
    auto loc = ri->getOperand().getLoc();
    auto *origExit = ri->getParent();
    auto &builder = getBuilder();
    auto *pbStructVal = buildPullbackValueStructValue(ri);

    // Get the value in the VJP corresponding to the original result.
    auto *origRetInst = cast<ReturnInst>(origExit->getTerminator());
    auto origResult = getOpValue(origRetInst->getOperand());
    SmallVector<SILValue, 8> origResults;
    extractAllElements(origResult, builder, origResults);

    // Get and partially apply the pullback.
    auto vjpGenericEnv = vjp->getGenericEnvironment();
    auto vjpSubstMap = vjpGenericEnv
        ? vjpGenericEnv->getForwardingSubstitutionMap()
        : vjp->getForwardingSubstitutionMap();
    auto *pullbackRef = builder.createFunctionRef(loc, pullback);
    auto *pullbackPartialApply = builder.createPartialApply(
        loc, pullbackRef, vjpSubstMap, {pbStructVal},
        ParameterConvention::Direct_Guaranteed);

    // Return a tuple of the original result and pullback.
    SmallVector<SILValue, 8> directResults;
    directResults.append(origResults.begin(), origResults.end());
    directResults.push_back(pullbackPartialApply);
    builder.createReturn(
        ri->getLoc(), joinElements(directResults, builder, loc));
  }

  void visitBranchInst(BranchInst *bi) {
    // Build pullback struct value for original block.
    // Build predecessor enum value for destination block.
    auto *origBB = bi->getParent();
    auto *pbStructVal = buildPullbackValueStructValue(bi);
    auto *enumVal = buildPredecessorEnumValue(
        getBuilder(), origBB, bi->getDestBB(), pbStructVal);

    // Remap arguments, appending the new enum values.
    SmallVector<SILValue, 8> args;
    for (auto origArg : bi->getArgs())
      args.push_back(getOpValue(origArg));
    args.push_back(enumVal);

    // Create a new `br` instruction.
    getBuilder().createBranch(
        bi->getLoc(), getOpBasicBlock(bi->getDestBB()), args);
  }

  void visitCondBranchInst(CondBranchInst *cbi) {
    // Build pullback struct value for original block.
    // Build predecessor enum values for true/false blocks.
    auto *origBB = cbi->getParent();
    auto *pbStructVal = buildPullbackValueStructValue(cbi);

    // Creates a trampoline block for given original successor block. The
    // trampoline block has the same arguments as the VJP successor block but
    // drops the last predecessor enum argument. The generated `switch_enum`
    // instruction branches to the trampoline block, and the trampoline block
    // constructs a predecessor enum value and branches to the VJP successor
    // block.
    auto createTrampolineBasicBlock =
        [&](SILBasicBlock *origSuccBB) -> SILBasicBlock * {
      auto *vjpSuccBB = getOpBasicBlock(origSuccBB);
      // Create the trampoline block.
      auto *trampolineBB = vjp->createBasicBlockBefore(vjpSuccBB);
      for (auto *arg : vjpSuccBB->getArguments().drop_back())
        trampolineBB->createPhiArgument(arg->getType(),
                                        arg->getOwnershipKind());
      // Build predecessor enum value for successor block and branch to it.
      SILBuilder trampolineBuilder(trampolineBB);
      auto *succEnumVal = buildPredecessorEnumValue(
          trampolineBuilder, origBB, origSuccBB, pbStructVal);
      SmallVector<SILValue, 4> forwardedArguments(
          trampolineBB->getArguments().begin(),
          trampolineBB->getArguments().end());
      forwardedArguments.push_back(succEnumVal);
      trampolineBuilder.createBranch(cbi->getLoc(), vjpSuccBB,
                                     forwardedArguments);
      return trampolineBB;
    };

    // Create a new `cond_br` instruction.
    getBuilder().createCondBranch(
        cbi->getLoc(), getOpValue(cbi->getCondition()),
        createTrampolineBasicBlock(cbi->getTrueBB()),
        createTrampolineBasicBlock(cbi->getFalseBB()));
  }

  void visitSwitchEnumInst(SwitchEnumInst *sei) {
    // Build pullback struct value for original block.
    auto *origBB = sei->getParent();
    auto *pbStructVal = buildPullbackValueStructValue(sei);

    // Creates a trampoline block for given original successor block. The
    // trampoline block has the same arguments as the VJP successor block but
    // drops the last predecessor enum argument. The generated `switch_enum`
    // instruction branches to the trampoline block, and the trampoline block
    // constructs a predecessor enum value and branches to the VJP successor
    // block.
    auto createTrampolineBasicBlock =
        [&](SILBasicBlock *origSuccBB) -> SILBasicBlock * {
      auto *vjpSuccBB = getOpBasicBlock(origSuccBB);
      // Create the trampoline block.
      auto *trampolineBB = vjp->createBasicBlockBefore(vjpSuccBB);
      for (auto *destArg : vjpSuccBB->getArguments().drop_back())
        trampolineBB->createPhiArgument(
            destArg->getType(), destArg->getOwnershipKind());
      // Build predecessor enum value for successor block and branch to it.
      SILBuilder trampolineBuilder(trampolineBB);
      auto *succEnumVal = buildPredecessorEnumValue(
          trampolineBuilder, origBB, origSuccBB, pbStructVal);
      SmallVector<SILValue, 4> forwardedArguments(
          trampolineBB->getArguments().begin(),
          trampolineBB->getArguments().end());
      forwardedArguments.push_back(succEnumVal);
      trampolineBuilder.createBranch(sei->getLoc(), vjpSuccBB,
                                     forwardedArguments);
      return trampolineBB;
    };

    // Create trampoline successor basic blocks.
    SmallVector<std::pair<EnumElementDecl *, SILBasicBlock *>, 4> caseBBs;
    for (unsigned i : range(sei->getNumCases())) {
      auto caseBB = sei->getCase(i);
      auto *trampolineBB = createTrampolineBasicBlock(caseBB.second);
      caseBBs.push_back({caseBB.first, trampolineBB});
    }
    // Create trampoline default basic block.
    SILBasicBlock *newDefaultBB = nullptr;
    if (auto *defaultBB = sei->getDefaultBBOrNull().getPtrOrNull())
      newDefaultBB = createTrampolineBasicBlock(defaultBB);

    // Create a new `switch_enum` instruction.
    getBuilder().createSwitchEnum(
        sei->getLoc(), getOpValue(sei->getOperand()), newDefaultBB, caseBBs);
  }

  // If an `apply` has active results or active inout arguments, replace it
  // with an `apply` of its VJP.
  void visitApplyInst(ApplyInst *ai) {
    // If the function should not be differentiated or its the array literal
    // initialization intrinsic, just do standard cloning.
    if (!pullbackInfo.shouldDifferentiateApplyInst(ai) ||
        isArrayLiteralIntrinsic(ai)) {
      LLVM_DEBUG(getADDebugStream() << "No active results:\n" << *ai << '\n');
      TypeSubstCloner::visitApplyInst(ai);
      return;
    }

    // Diagnose functions with active inout arguments.
    // TODO(TF-129): Support `inout` argument differentiation.
    for (auto inoutArg : ai->getInoutArguments()) {
      if (activityInfo.isActive(inoutArg, getIndices())) {
        context.emitNondifferentiabilityError(ai, invoker,
            diag::autodiff_cannot_differentiate_through_inout_arguments);
        errorOccurred = true;
        return;
      }
    }

    LLVM_DEBUG(getADDebugStream() << "VJP-transforming:\n" << *ai << '\n');

    // Get the minimal parameter and result indices required for differentiating
    // this `apply`.
    SmallVector<SILValue, 4> allResults;
    SmallVector<unsigned, 8> activeParamIndices;
    SmallVector<unsigned, 8> activeResultIndices;
    collectMinimalIndicesForFunctionCall(ai, getIndices(), activityInfo,
                                         allResults, activeParamIndices,
                                         activeResultIndices);
    assert(!activeParamIndices.empty() && "Parameter indices cannot be empty");
    assert(!activeResultIndices.empty() && "Result indices cannot be empty");
    LLVM_DEBUG(auto &s = getADDebugStream() << "Active indices: params={";
               interleave(activeParamIndices.begin(), activeParamIndices.end(),
                          [&s](unsigned i) { s << i; }, [&s] { s << ", "; });
               s << "}, results={"; interleave(
                   activeResultIndices.begin(), activeResultIndices.end(),
                   [&s](unsigned i) { s << i; }, [&s] { s << ", "; });
               s << "}\n";);
    // Diagnose multiple active results.
    // TODO(TF-983): Support multiple active results.
    if (activeResultIndices.size() > 1) {
      context.emitNondifferentiabilityError(
          ai, invoker,
          diag::autodiff_cannot_differentiate_through_multiple_results);
      errorOccurred = true;
      return;
    }

    // Form expected indices, assuming there's only one result.
    SILAutoDiffIndices indices(
        activeResultIndices.front(),
        IndexSubset::get(
            getASTContext(), ai->getArgumentsWithoutIndirectResults().size(),
            activeParamIndices));

    // Emit the VJP.
    auto loc = ai->getLoc();
    auto &builder = getBuilder();
    auto original = getOpValue(ai->getCallee());
    SILValue vjpValue;
    // If functionSource is a `@differentiable` function, just extract it.
    auto originalFnTy = original->getType().castTo<SILFunctionType>();
    if (originalFnTy->isDifferentiable()) {
      auto paramIndices = originalFnTy->getDifferentiationParameterIndices();
      for (auto i : indices.parameters->getIndices()) {
        if (!paramIndices->contains(i)) {
          context.emitNondifferentiabilityError(original, invoker,
              diag::autodiff_function_nondiff_parameter_not_differentiable);
          errorOccurred = true;
          return;
        }
      }
      auto borrowedDiffFunc = builder.emitBeginBorrowOperation(loc, original);
      vjpValue = builder.createDifferentiableFunctionExtract(
          loc, NormalDifferentiableFunctionTypeComponent::VJP,
          borrowedDiffFunc);
      vjpValue = builder.emitCopyValueOperation(loc, vjpValue);
    }

    // Check and diagnose non-differentiable original function type.
    auto diagnoseNondifferentiableOriginalFunctionType =
        [&](CanSILFunctionType origFnTy) {
          // Check and diagnose non-differentiable arguments.
          for (unsigned paramIndex : range(originalFnTy->getNumParameters())) {
            if (indices.isWrtParameter(paramIndex) &&
                    !originalFnTy->getParameters()[paramIndex]
                    .getSILStorageInterfaceType()
                    .isDifferentiable(getModule())) {
              context.emitNondifferentiabilityError(
                  ai->getArgumentsWithoutIndirectResults()[paramIndex], invoker,
                  diag::autodiff_nondifferentiable_argument);
              errorOccurred = true;
              return true;
            }
          }
          // Check and diagnose non-differentiable results.
          if (!originalFnTy->getResults()[indices.source]
                  .getSILStorageInterfaceType()
                  .isDifferentiable(getModule())) {
            context.emitNondifferentiabilityError(
                original, invoker, diag::autodiff_nondifferentiable_result);
            errorOccurred = true;
            return true;
          }
          return false;
        };
    if (diagnoseNondifferentiableOriginalFunctionType(originalFnTy))
      return;

    // If VJP has not yet been found, emit an `differentiable_function`
    // instruction on the remapped original function operand and
    // an `differentiable_function_extract` instruction to get the VJP.
    // The `differentiable_function` instruction will be canonicalized during
    // the transform main loop.
    if (!vjpValue) {
      // FIXME: Handle indirect differentiation invokers. This may require some
      // redesign: currently, each original function + witness pair is mapped
      // only to one invoker.
      /*
      DifferentiationInvoker indirect(ai, attr);
      auto insertion =
          context.getInvokers().try_emplace({this->original, attr}, indirect);
      auto &invoker = insertion.first->getSecond();
      invoker = indirect;
      */

      // If the original `apply` instruction has a substitution map, then the
      // applied function is specialized.
      // In the VJP, specialization is also necessary for parity. The original
      // function operand is specialized with a remapped version of same
      // substitution map using an argument-less `partial_apply`.
      if (ai->getSubstitutionMap().empty()) {
        original = builder.emitCopyValueOperation(loc, original);
      } else {
        auto substMap = getOpSubstitutionMap(ai->getSubstitutionMap());
        auto vjpPartialApply = getBuilder().createPartialApply(
            ai->getLoc(), original, substMap, {},
            ParameterConvention::Direct_Guaranteed);
        original = vjpPartialApply;
        originalFnTy = original->getType().castTo<SILFunctionType>();
        // Diagnose if new original function type is non-differentiable.
        if (diagnoseNondifferentiableOriginalFunctionType(originalFnTy))
          return;
      }

      auto *diffFuncInst = context.createDifferentiableFunction(
          getBuilder(), loc, indices.parameters, original);

      // Record the `differentiable_function` instruction.
      context.addDifferentiableFunctionInstToWorklist(diffFuncInst);
      // TODO(TF-689): Make `differentiable_function` store result indices and
      // remove `ADContext::resultIndices`.
      context.setResultIndex(diffFuncInst, activeResultIndices.front());

      auto borrowedADFunc =
          builder.emitBeginBorrowOperation(loc, diffFuncInst);
      auto extractedVJP = getBuilder().createDifferentiableFunctionExtract(
          loc, NormalDifferentiableFunctionTypeComponent::VJP,
          borrowedADFunc);
      vjpValue = builder.emitCopyValueOperation(loc, extractedVJP);
      builder.emitEndBorrowOperation(loc, borrowedADFunc);
      builder.emitDestroyValueOperation(loc, diffFuncInst);
    }

    // Record desired/actual VJP indices.
    // Temporarily set original pullback type to `None`.
    NestedApplyInfo info{indices, /*originalPullbackType*/ None};
    auto insertion = context.getNestedApplyInfo().try_emplace(ai, info);
    auto &nestedApplyInfo = insertion.first->getSecond();
    nestedApplyInfo = info;

    // Call the VJP using the original parameters.
    SmallVector<SILValue, 8> vjpArgs;
    auto vjpFnTy = getOpType(vjpValue->getType()).castTo<SILFunctionType>();
    auto numVJPArgs =
        vjpFnTy->getNumParameters() + vjpFnTy->getNumIndirectFormalResults();
    vjpArgs.reserve(numVJPArgs);
    // Collect substituted arguments.
    for (auto origArg : ai->getArguments())
      vjpArgs.push_back(getOpValue(origArg));
    assert(vjpArgs.size() == numVJPArgs);
    // Apply the VJP.
    // The VJP should be specialized, so no substitution map is necessary.
    auto *vjpCall = getBuilder().createApply(loc, vjpValue, SubstitutionMap(),
                                             vjpArgs, ai->isNonThrowing());
    LLVM_DEBUG(getADDebugStream() << "Applied vjp function\n" << *vjpCall);
    builder.emitDestroyValueOperation(loc, vjpValue);

    // Get the VJP results (original results and pullback).
    SmallVector<SILValue, 8> vjpDirectResults;
    extractAllElements(vjpCall, getBuilder(), vjpDirectResults);
    ArrayRef<SILValue> originalDirectResults =
        ArrayRef<SILValue>(vjpDirectResults).drop_back(1);
    SILValue originalDirectResult = joinElements(originalDirectResults,
                                                 getBuilder(),
                                                 vjpCall->getLoc());
    SILValue pullback = vjpDirectResults.back();

    // Store the original result to the value map.
    mapValue(ai, originalDirectResult);

    // Checkpoint the pullback.
    auto *pullbackDecl = pullbackInfo.lookUpLinearMapDecl(ai);

    // If actual pullback type does not match lowered pullback type, reabstract
    // the pullback using a thunk.
    auto actualPullbackType =
        getOpType(pullback->getType()).getAs<SILFunctionType>();
    auto vjpGenSig = SubsMap.getGenericSignature()
        ? SubsMap.getGenericSignature()->getCanonicalSignature()
        : nullptr;
    Lowering::GenericContextScope genericContextScope(
        context.getTypeConverter(), vjpGenSig);
    auto loweredPullbackType =
        getOpType(context.getTypeConverter().getLoweredType(
                      pullbackDecl->getInterfaceType()->getCanonicalType(),
                      TypeExpansionContext::minimal()))
            .castTo<SILFunctionType>();
    if (!loweredPullbackType->isEqual(actualPullbackType)) {
      // Set non-reabstracted original pullback type in nested apply info.
      nestedApplyInfo.originalPullbackType = actualPullbackType;
      SILOptFunctionBuilder fb(context.getTransform());
      auto *thunk = getOrCreateReabstractionThunk(
          fb, getModule(), loc, /*caller*/ vjp, actualPullbackType,
          loweredPullbackType);
      auto *thunkRef = getBuilder().createFunctionRef(loc, thunk);
      pullback = getBuilder().createPartialApply(
          ai->getLoc(), thunkRef,
          getOpSubstitutionMap(thunk->getForwardingSubstitutionMap()),
          {pullback}, actualPullbackType->getCalleeConvention());
    }
    pullbackValues[ai->getParent()].push_back(pullback);

    // Some instructions that produce the callee may have been cloned.
    // If the original callee did not have any users beyond this `apply`,
    // recursively kill the cloned callee.
    if (auto *origCallee = cast_or_null<SingleValueInstruction>(
            ai->getCallee()->getDefiningInstruction()))
      if (origCallee->hasOneUse())
        recursivelyDeleteTriviallyDeadInstructions(
            getOpValue(origCallee)->getDefiningInstruction());
  }

  void visitDifferentiableFunctionInst(DifferentiableFunctionInst *dfi) {
    // Clone `differentiable_function` from original to VJP, then add the cloned
    // instruction to the `differentiable_function` worklist.
    TypeSubstCloner::visitDifferentiableFunctionInst(dfi);
    auto *newDFI = cast<DifferentiableFunctionInst>(getOpValue(dfi));
    context.addDifferentiableFunctionInstToWorklist(newDFI);
  }
};
} // end anonymous namespace

namespace {

class JVPEmitter final
    : public TypeSubstCloner<JVPEmitter, SILOptFunctionBuilder> {
private:
  /// The global context.
  ADContext &context;

  /// The original function.
  SILFunction *const original;

  /// The witness.
  SILDifferentiabilityWitness *const witness;

  /// The JVP function.
  SILFunction *const jvp;

  llvm::BumpPtrAllocator allocator;

  /// The differentiation invoker.
  DifferentiationInvoker invoker;

  /// Info from activity analysis on the original function.
  const DifferentiableActivityInfo &activityInfo;

  /// The differential info.
  LinearMapInfo differentialInfo;

  bool errorOccurred = false;

  //--------------------------------------------------------------------------//
  // Differential generation related fields
  //--------------------------------------------------------------------------//

  /// The builder for the differential function.
  SILBuilder differentialBuilder;

  /// Mapping from original basic blocks to corresponding differential basic
  /// blocks.
  DenseMap<SILBasicBlock *, SILBasicBlock *> diffBBMap;

  /// Mapping from original basic blocks and original values to corresponding
  /// tangent values.
  DenseMap<SILValue, AdjointValue> tangentValueMap;

  /// Mapping from original basic blocks and original buffers to corresponding
  /// tangent buffers.
  DenseMap<std::pair<SILBasicBlock *, SILValue>, SILValue> bufferMap;

  /// Mapping from differential basic blocks to differential struct arguments.
  DenseMap<SILBasicBlock *, SILArgument *> differentialStructArguments;

  /// Mapping from differential struct field declarations to differential struct
  /// elements destructured from the linear map basic block argument. In the
  /// beginning of each differential basic block, the block's differential
  /// struct is destructured into the individual elements stored here.
  DenseMap<VarDecl *, SILValue> differentialStructElements;

  /// An auxiliary differential local allocation builder.
  SILBuilder diffLocalAllocBuilder;

  /// Stack buffers allocated for storing local tangent values.
  SmallVector<SILValue, 8> differentialLocalAllocations;

  /// Mapping from original blocks to differential values. Used to build
  /// differential struct instances.
  DenseMap<SILBasicBlock *, SmallVector<SILValue, 8>> differentialValues;

  //--------------------------------------------------------------------------//
  // Getters
  //--------------------------------------------------------------------------//

  ASTContext &getASTContext() const { return jvp->getASTContext(); }
  SILModule &getModule() const { return jvp->getModule(); }
  const SILAutoDiffIndices getIndices() const {
    return witness->getSILAutoDiffIndices();
  }
  SILBuilder &getDifferentialBuilder() { return differentialBuilder; }
  SILFunction &getDifferential() {
    return differentialBuilder.getFunction();
  }
  SILArgument *getDifferentialStructArgument(SILBasicBlock *origBB) {
#ifndef NDEBUG
    auto *diffStruct = differentialStructArguments[origBB]->getType()
        .getStructOrBoundGenericStruct();
    assert(diffStruct == differentialInfo.getLinearMapStruct(origBB));
#endif
    return differentialStructArguments[origBB];
  }

  //--------------------------------------------------------------------------//
  // Initialization helpers
  //--------------------------------------------------------------------------//

  static SubstitutionMap getSubstitutionMap(SILFunction *original,
                                            SILFunction *jvp) {
    auto substMap = original->getForwardingSubstitutionMap();
    if (auto *jvpGenEnv = jvp->getGenericEnvironment()) {
      auto jvpSubstMap = jvpGenEnv->getForwardingSubstitutionMap();
      substMap = SubstitutionMap::get(
          jvpGenEnv->getGenericSignature(), QuerySubstitutionMap{jvpSubstMap},
          LookUpConformanceInSubstitutionMap(jvpSubstMap));
    }
    return substMap;
  }

  /// Returns the activity info about the SILValues in the original function.
  static const DifferentiableActivityInfo &
  getActivityInfo(ADContext &context, SILFunction *original,
                  SILAutoDiffIndices indices, SILFunction *jvp) {
    // Get activity info of the original function.
    auto &passManager = context.getPassManager();
    auto *activityAnalysis =
        passManager.getAnalysis<DifferentiableActivityAnalysis>();
    auto &activityCollection = *activityAnalysis->get(original);
    auto &activityInfo = activityCollection.getActivityInfo(
        jvp->getLoweredFunctionType()->getSubstGenericSignature(),
        AutoDiffDerivativeFunctionKind::JVP);
    LLVM_DEBUG(activityInfo.dump(indices, getADDebugStream()));
    return activityInfo;
  }

  //--------------------------------------------------------------------------//
  // Differential struct mapping
  //--------------------------------------------------------------------------//

  void initializeDifferentialStructElements(SILBasicBlock *origBB,
                                            SILInstructionResultArray values) {
    auto *diffStructDecl = differentialInfo.getLinearMapStruct(origBB);
    assert(diffStructDecl->getStoredProperties().size() == values.size() &&
           "The number of differential struct fields must equal the number of "
           "differential struct element values");
    for (auto pair : llvm::zip(diffStructDecl->getStoredProperties(), values)) {
      assert(
          std::get<1>(pair).getOwnershipKind() != ValueOwnershipKind::Guaranteed
              && "Differential struct elements must be @owned");
      auto insertion = differentialStructElements.insert({std::get<0>(pair),
                                                          std::get<1>(pair)});
      (void)insertion;
      assert(insertion.second &&
             "A differential struct element mapping already exists!");
    }
  }

  SILValue getDifferentialStructElement(SILBasicBlock *origBB, VarDecl *field) {
    assert(differentialInfo.getLinearMapStruct(origBB) ==
               cast<StructDecl>(field->getDeclContext()));
    assert(differentialStructElements.count(field) &&
           "Differential struct element for this field does not exist!");
    return differentialStructElements.lookup(field);
  }

  //--------------------------------------------------------------------------//
  // General utilities
  //--------------------------------------------------------------------------//

  SILBasicBlock::iterator getNextDifferentialLocalAllocationInsertionPoint() {
    // If there are no local allocations, insert at the beginning of the tangent
    // entry.
    if (differentialLocalAllocations.empty())
      return getDifferential().getEntryBlock()->begin();
    // Otherwise, insert before the last local allocation. Inserting before
    // rather than after ensures that allocation and zero initialization
    // instructions are grouped together.
    auto lastLocalAlloc = differentialLocalAllocations.back();
    auto it = lastLocalAlloc->getDefiningInstruction()->getIterator();
    return it;
  }

  /// Get the lowered SIL type of the given nominal type declaration.
  SILType getNominalDeclLoweredType(NominalTypeDecl *nominal) {
    auto nomType =
        getOpASTType(nominal->getDeclaredInterfaceType()->getCanonicalType());
    auto nomSILType = context.getTypeConverter().getLoweredType(
        nomType, TypeExpansionContext::minimal());
    return nomSILType;
  }

  /// Build a differential struct value for the original block corresponding to
  /// the given terminator.
  StructInst *buildDifferentialValueStructValue(TermInst *termInst) {
    assert(termInst->getFunction() == original);
    auto loc = termInst->getFunction()->getLocation();
    auto *origBB = termInst->getParent();
    auto *jvpBB = BBMap[origBB];
    assert(jvpBB && "Basic block mapping should exist");
    auto *diffStruct = differentialInfo.getLinearMapStruct(origBB);
    assert(diffStruct && "The differential struct should have been declared");
    auto structLoweredTy = getNominalDeclLoweredType(diffStruct);
    auto bbDifferentialValues = differentialValues[origBB];
    if (!origBB->isEntry()) {
      auto *enumArg = jvpBB->getArguments().back();
      bbDifferentialValues.insert(bbDifferentialValues.begin(), enumArg);
    }
    return getBuilder().createStruct(loc, structLoweredTy,
                                     bbDifferentialValues);
  }

  //--------------------------------------------------------------------------//
  // Tangent value factory methods
  //--------------------------------------------------------------------------//

  AdjointValue makeZeroTangentValue(SILType type) {
    return AdjointValue::createZero(
        allocator, remapSILTypeInDifferential(type));
  }

  AdjointValue makeConcreteTangentValue(SILValue value) {
    return AdjointValue::createConcrete(allocator, value);
  }

  //--------------------------------------------------------------------------//
  // Tangent materialization
  //--------------------------------------------------------------------------//

  void emitZeroIndirect(CanType type, SILValue bufferAccess,
                        SILLocation loc) {
    auto builder = getDifferentialBuilder();
    auto tangentSpace = getTangentSpace(type);
    assert(tangentSpace && "No tangent space for this type");
    switch (tangentSpace->getKind()) {
    case VectorSpace::Kind::Vector:
      emitZeroIntoBuffer(builder, type, bufferAccess, loc);
      return;
    case VectorSpace::Kind::Tuple: {
      auto tupleType = tangentSpace->getTuple();
      SmallVector<SILValue, 8> zeroElements;
      for (unsigned i : range(tupleType->getNumElements())) {
        auto eltAddr = builder.createTupleElementAddr(loc, bufferAccess, i);
        emitZeroIndirect(tupleType->getElementType(i)->getCanonicalType(),
                         eltAddr, loc);
      }
      return;
    }
    case VectorSpace::Kind::Function: {
      llvm_unreachable(
          "Unimplemented: Emit thunks for abstracting zero initialization");
    }
    }
  }

  SILValue emitZeroDirect(CanType type, SILLocation loc) {
    auto diffBuilder = getDifferentialBuilder();
    auto silType = getModule().Types.getLoweredLoadableType(
        type, TypeExpansionContext::minimal(), getModule());
    auto *buffer = diffBuilder.createAllocStack(loc, silType);
    emitZeroIndirect(type, buffer, loc);
    auto loaded = diffBuilder.emitLoadValueOperation(
        loc, buffer, LoadOwnershipQualifier::Take);
    diffBuilder.createDeallocStack(loc, buffer);
    return loaded;
  }

  SILValue materializeTangentDirect(AdjointValue val, SILLocation loc) {
    assert(val.getType().isObject());
    LLVM_DEBUG(getADDebugStream()
               << "Materializing tangents for " << val << '\n');
    switch (val.getKind()) {
    case AdjointValueKind::Zero: {
      auto zeroVal = emitZeroDirect(val.getSwiftType(), loc);
      return zeroVal;
    }
    case AdjointValueKind::Aggregate:
      llvm_unreachable(
          "Tuples and structs are not supported in forward mode yet.");
    case AdjointValueKind::Concrete:
      return val.getConcreteValue();
  }
  }

  SILValue materializeTangent(AdjointValue val, SILLocation loc) {
    if (val.isConcrete()) {
      LLVM_DEBUG(getADDebugStream()
                 << "Materializing tangent: Value is concrete.\n");
      return val.getConcreteValue();
    }
    LLVM_DEBUG(getADDebugStream() << "Materializing tangent: Value is "
                                     "non-concrete. Materializing directly.\n");
    return materializeTangentDirect(val, loc);
  }

  //--------------------------------------------------------------------------//
  // Tangent buffer mapping
  //--------------------------------------------------------------------------//

  void setTangentBuffer(SILBasicBlock *origBB, SILValue originalBuffer,
                        SILValue tangentBuffer) {
    assert(originalBuffer->getType().isAddress());
    auto insertion =
        bufferMap.try_emplace({origBB, originalBuffer}, tangentBuffer);
    assert(insertion.second && "tangent buffer already exists.");
    (void)insertion;
  }

  SILValue &getTangentBuffer(SILBasicBlock *origBB, SILValue originalBuffer) {
    assert(originalBuffer->getType().isAddress());
    assert(originalBuffer->getFunction() == original);
    auto insertion = bufferMap.try_emplace({origBB, originalBuffer},
                                           SILValue());
    assert(!insertion.second && "tangent buffer should already exist");
    return insertion.first->getSecond();
  }

  //--------------------------------------------------------------------------//
  // Differential type calculations
  //--------------------------------------------------------------------------//

  /// Substitutes all replacement types of the given substitution map using the
  /// tangent function's substitution map.
  SubstitutionMap remapSubstitutionMapInDifferential(SubstitutionMap substMap) {
    return substMap.subst(getDifferential().getForwardingSubstitutionMap());
  }

  /// Remap any archetypes into the differential function's context.
  Type remapTypeInDifferential(Type ty) {
    if (ty->hasArchetype())
      return getDifferential().mapTypeIntoContext(ty->mapTypeOutOfContext());
    return getDifferential().mapTypeIntoContext(ty);
  }

  /// Remap any archetypes into the differential function's context.
  SILType remapSILTypeInDifferential(SILType ty) {
    if (ty.hasArchetype())
      return getDifferential().mapTypeIntoContext(ty.mapTypeOutOfContext());
    return getDifferential().mapTypeIntoContext(ty);
  }

  /// Find the tangent space of a given canonical type.
  Optional<VectorSpace> getTangentSpace(CanType type) {
    return type->getAutoDiffAssociatedTangentSpace(
        LookUpConformanceInModule(getModule().getSwiftModule()));
  }

  /// Assuming the given type conforms to `Differentiable` after remapping,
  /// returns the associated tangent space SIL type.
  SILType getRemappedTangentType(SILType type) {
    return SILType::getPrimitiveType(
        getTangentSpace(remapSILTypeInDifferential(type).getASTType())
            ->getCanonicalType(),
        type.getCategory());
  }

  //--------------------------------------------------------------------------//
  // Tangent value mapping
  //--------------------------------------------------------------------------//

  /// Get the tangent for an original value. The given value must be in the
  /// original function.
  ///
  /// This method first tries to find an entry in `tangentValueMap`. If an entry
  /// doesn't exist, create a zero tangent.
  AdjointValue getTangentValue(SILValue originalValue) {
    assert(originalValue->getType().isObject());
    assert(originalValue->getFunction() == original);
    auto insertion = tangentValueMap.try_emplace(
        originalValue, makeZeroTangentValue(
        getRemappedTangentType(originalValue->getType())));
    return insertion.first->getSecond();
  }

  /// Map the tangent value to the given original value.
  void setTangentValue(SILBasicBlock *origBB, SILValue originalValue,
                       AdjointValue newTangentValue) {
    if (auto *defInst = originalValue->getDefiningInstruction()) {
      bool isTupleTypedApplyResult =
          isa<ApplyInst>(defInst) && originalValue->getType().is<TupleType>();
      assert(!isTupleTypedApplyResult &&
             "Should not set tangent value for tuple-typed result from `apply` "
             "instruction; use `destructure_tuple` on `apply` result and set "
             "tangent value for `destructure_tuple` results instead.");
    }
    assert(originalValue->getType().isObject());
    assert(newTangentValue.getType().isObject());
    assert(originalValue->getFunction() == original);
    LLVM_DEBUG(getADDebugStream() << "Adding tangent for " << originalValue);
    // The tangent value must be in the tangent space.
    assert(newTangentValue.getType() ==
           getRemappedTangentType(originalValue->getType()));
    auto insertion =
        tangentValueMap.try_emplace(originalValue, newTangentValue);
    auto inserted = insertion.second;
    assert(inserted && "The tangent value should not already exist.");
  }

  //--------------------------------------------------------------------------//
  // Tangent emission helpers
  //--------------------------------------------------------------------------//
public:
#define CLONE_AND_EMIT_TANGENT(INST, ID) \
  void visit##INST##Inst(INST##Inst *inst) { \
    TypeSubstCloner::visit##INST##Inst(inst); \
    if (differentialInfo.shouldDifferentiateInstruction(inst)) \
      emitTangentFor##INST##Inst(inst); \
  } \
  void emitTangentFor##INST##Inst(INST##Inst *(ID))

  CLONE_AND_EMIT_TANGENT(BeginBorrow, bbi) {
    auto &diffBuilder = getDifferentialBuilder();
    auto loc = bbi->getLoc();
    auto tanVal = materializeTangent(getTangentValue(bbi->getOperand()), loc);
    auto tanValBorrow = diffBuilder.emitBeginBorrowOperation(loc, tanVal);
    setTangentValue(bbi->getParent(), bbi,
                    makeConcreteTangentValue(tanValBorrow));
  }

  CLONE_AND_EMIT_TANGENT(EndBorrow, ebi) {
    auto &diffBuilder = getDifferentialBuilder();
    auto loc = ebi->getLoc();
    auto tanVal = materializeTangent(getTangentValue(ebi->getOperand()), loc);
    diffBuilder.emitEndBorrowOperation(loc, tanVal);
  }

  CLONE_AND_EMIT_TANGENT(DestroyValue, dvi) {
    auto &diffBuilder = getDifferentialBuilder();
    auto loc = dvi->getLoc();
    auto tanVal = materializeTangent(getTangentValue(dvi->getOperand()), loc);
    diffBuilder.emitDestroyValue(loc, tanVal);
  }

  CLONE_AND_EMIT_TANGENT(CopyValue, cvi) {
    auto &diffBuilder = getDifferentialBuilder();
    auto tan = getTangentValue(cvi->getOperand());
    auto tanVal = materializeTangent(tan, cvi->getLoc());
    auto tanValCopy = diffBuilder.emitCopyValueOperation(cvi->getLoc(), tanVal);
    setTangentValue(cvi->getParent(), cvi,
                    makeConcreteTangentValue(tanValCopy));
  }

  /// Handle `load` instruction.
  ///   Original: y = load x
  ///    Tangent: tan[y] = load tan[x]
  CLONE_AND_EMIT_TANGENT(Load, li) {
    auto &diffBuilder = getDifferentialBuilder();
    auto *bb = li->getParent();
    auto loc = li->getLoc();
    auto tanBuf = getTangentBuffer(bb, li->getOperand());
    auto tanVal = diffBuilder.emitLoadValueOperation(
        loc, tanBuf, li->getOwnershipQualifier());
    setTangentValue(bb, li, makeConcreteTangentValue(tanVal));
  }

  /// Handle `load_borrow` instruction.
  ///   Original: y = load_borrow x
  ///    Tangent: tan[y] = load_borrow tan[x]
  CLONE_AND_EMIT_TANGENT(LoadBorrow, lbi) {
    auto &diffBuilder = getDifferentialBuilder();
    auto *bb = lbi->getParent();
    auto loc = lbi->getLoc();
    auto tanBuf = getTangentBuffer(bb, lbi->getOperand());
    auto tanVal = diffBuilder.emitLoadBorrowOperation(
        loc, tanBuf);
    setTangentValue(bb, lbi, makeConcreteTangentValue(tanVal));
  }

  /// Handle `store` instruction in the differential.
  ///   Original: store x to y
  ///     Tangent: store tan[x] to tan[y]
  CLONE_AND_EMIT_TANGENT(Store, si) {
    auto &diffBuilder = getDifferentialBuilder();
    auto loc = si->getLoc();
    auto tanValSrc = materializeTangent(getTangentValue(si->getSrc()), loc);
    auto &tanValDest = getTangentBuffer(si->getParent(), si->getDest());
    diffBuilder.emitStoreValueOperation(
        loc, tanValSrc, tanValDest, si->getOwnershipQualifier());
  }

  /// Handle `store_borrow` instruction in the differential.
  ///   Original: store_borrow x to y
  ///    Tangent: store_borrow tan[x] to tan[y]
  CLONE_AND_EMIT_TANGENT(StoreBorrow, sbi) {
     auto &diffBuilder = getDifferentialBuilder();
     auto loc = sbi->getLoc();
     auto tanValSrc = materializeTangent(getTangentValue(sbi->getSrc()), loc);
     auto &tanValDest = getTangentBuffer(sbi->getParent(), sbi->getDest());
    diffBuilder.createStoreBorrow(loc, tanValSrc, tanValDest);
  }

  /// Handle `copy_addr` instruction.
  ///   Original: copy_addr x to y
  ///    Tangent: copy_addr tan[x] to tan[y]
  CLONE_AND_EMIT_TANGENT(CopyAddr, cai) {
    auto *diffGenEnv = getDifferential().getGenericEnvironment();
    auto diffGenSig = diffGenEnv
        ? diffGenEnv->getGenericSignature()->getCanonicalSignature()
        : nullptr;
    Lowering::GenericContextScope genericContextScope(
        context.getTypeConverter(), diffGenSig);

    auto diffBuilder = getDifferentialBuilder();
    auto loc = cai->getLoc();
    auto *bb = cai->getParent();
    auto &tanSrc = getTangentBuffer(bb, cai->getSrc());
    auto tanDest = getTangentBuffer(bb, cai->getDest());

    diffBuilder.createCopyAddr(loc, tanSrc, tanDest, cai->isTakeOfSrc(),
                               cai->isInitializationOfDest());
  }

  /// Handle `unconditional_checked_cast_addr` instruction.
  ///   Original: unconditional_checked_cast_addr $X in x to $Y in y
  ///    Tangent: unconditional_checked_cast_addr $X.Tan in tan[x]
  ///                                          to $Y.Tan in tan[y]
  CLONE_AND_EMIT_TANGENT(UnconditionalCheckedCastAddr, uccai) {
    auto diffBuilder = getDifferentialBuilder();
    auto loc = uccai->getLoc();
    auto *bb = uccai->getParent();
    auto &tanSrc = getTangentBuffer(bb, uccai->getSrc());
    auto tanDest = getTangentBuffer(bb, uccai->getDest());

    diffBuilder.createUnconditionalCheckedCastAddr(
        loc, tanSrc, tanSrc->getType().getASTType(), tanDest,
        tanDest->getType().getASTType());
  }

  /// Handle `begin_access` instruction (and do differentiability checks).
  ///   Original: y = begin_access x
  ///    Tangent: tan[y] = begin_access tan[x]
  CLONE_AND_EMIT_TANGENT(BeginAccess, bai) {
    // Check for non-differentiable writes.
    if (bai->getAccessKind() == SILAccessKind::Modify) {
      if (auto *gai = dyn_cast<GlobalAddrInst>(bai->getSource())) {
        context.emitNondifferentiabilityError(bai, invoker,
            diag::autodiff_cannot_differentiate_writes_to_global_variables);
        errorOccurred = true;
        return;
      }
      if (auto *pbi = dyn_cast<ProjectBoxInst>(bai->getSource())) {
        context.emitNondifferentiabilityError(bai, invoker,
            diag::autodiff_cannot_differentiate_writes_to_mutable_captures);
        errorOccurred = true;
        return;
      }
    }

    auto &diffBuilder = getDifferentialBuilder();
    auto *bb = bai->getParent();

    auto tanSrc = getTangentBuffer(bb, bai->getSource());
    auto *tanDest = diffBuilder.createBeginAccess(
        bai->getLoc(), tanSrc, bai->getAccessKind(), bai->getEnforcement(),
        bai->hasNoNestedConflict(), bai->isFromBuiltin());
    setTangentBuffer(bb, bai, tanDest);
  }

  /// Handle `end_access` instruction.
  ///   Original: begin_access x
  ///    Tangent: end_access tan[x]
  CLONE_AND_EMIT_TANGENT(EndAccess, eai) {
    auto &diffBuilder = getDifferentialBuilder();
    auto *bb = eai->getParent();
    auto loc = eai->getLoc();
    auto tanSrc = getTangentBuffer(bb, eai->getOperand());
    diffBuilder.createEndAccess(loc, tanSrc, eai->isAborting());
  }

  /// Handle `alloc_stack` instruction.
  ///   Original: y = alloc_stack $T
  ///    Tangent: tan[y] = alloc_stack $T.Tangent
  CLONE_AND_EMIT_TANGENT(AllocStack, asi) {
    auto &diffBuilder = getDifferentialBuilder();
    auto *mappedAllocStackInst = diffBuilder.createAllocStack(
        asi->getLoc(), getRemappedTangentType(asi->getElementType()),
        asi->getVarInfo());
    bufferMap.try_emplace({asi->getParent(), asi},
                          mappedAllocStackInst);
  }

  /// Handle `dealloc_stack` instruction.
  ///   Original: dealloc_stack x
  ///    Tangent: dealloc_stack tan[x]
  CLONE_AND_EMIT_TANGENT(DeallocStack, dsi) {
    auto &diffBuilder = getDifferentialBuilder();
    auto tanBuf = getTangentBuffer(dsi->getParent(), dsi->getOperand());
    diffBuilder.createDeallocStack(dsi->getLoc(), tanBuf);
  }

  /// Handle `destroy_addr` instruction.
  ///   Original: destroy_addr x
  ///    Tangent: destroy_addr tan[x]
  CLONE_AND_EMIT_TANGENT(DestroyAddr, dai) {
    auto &diffBuilder = getDifferentialBuilder();
    auto tanBuf = getTangentBuffer(dai->getParent(), dai->getOperand());
    diffBuilder.createDestroyAddr(dai->getLoc(), tanBuf);
  }

  /// Handle `struct` instruction.
  ///   Original: y = struct $T (x0, x1, x2, ...)
  ///    Tangent: tan[y] = struct $T.Tangent (tan[x0], tan[x1], tan[x2], ...)
  CLONE_AND_EMIT_TANGENT(Struct, si) {
    auto &diffBuilder = getDifferentialBuilder();
    SmallVector<SILValue, 4> tangentElements;
    for (auto elem : si->getElements())
      tangentElements.push_back(getTangentValue(elem).getConcreteValue());
    auto tanExtract = diffBuilder.createStruct(
        si->getLoc(), getRemappedTangentType(si->getType()), tangentElements);
    setTangentValue(si->getParent(), si, makeConcreteTangentValue(tanExtract));
  }

  /// Handle `struct_extract` instruction.
  ///   Original: y = struct_extract x, #field
  ///    Tangent: tan[y] = struct_extract tan[x], #field'
  ///                                             ^~~~~~~
  ///                          field in tangent space corresponding to #field
  CLONE_AND_EMIT_TANGENT(StructExtract, sei) {
    assert(!sei->getField()->getAttrs().hasAttribute<NoDerivativeAttr>() &&
           "`struct_extract` with `@noDerivative` field should not be "
           "differentiated; activity analysis should not marked as varied.");

    auto diffBuilder = getDifferentialBuilder();;
    auto tangentVectorTy =
        getRemappedTangentType(sei->getOperand()->getType());
    auto *tangentVectorDecl =
        tangentVectorTy.getStructOrBoundGenericStruct();

    // Find the corresponding field in the tangent space.
    VarDecl *tanField = nullptr;
    // If the tangent space is the original struct, then field is the same.
    if (tangentVectorDecl == sei->getStructDecl())
      tanField = sei->getField();
    // Otherwise, look up the field by name.
    else {
      auto tanFieldLookup =
          tangentVectorDecl->lookupDirect(sei->getField()->getName());
      if (tanFieldLookup.empty()) {
        context.emitNondifferentiabilityError(
            sei, invoker,
            diag::autodiff_stored_property_no_corresponding_tangent,
            sei->getStructDecl()->getNameStr(),
            sei->getField()->getNameStr());
        errorOccurred = true;
        return;
      }
      tanField = cast<VarDecl>(tanFieldLookup.front());
    }
    // Emit tangent `struct_extract`.
    auto tanStruct =
        materializeTangent(getTangentValue(sei->getOperand()), sei->getLoc());
    auto tangentInst =
        diffBuilder.createStructExtract(sei->getLoc(), tanStruct, tanField);
    // Update tangent value mapping for `struct_extract` result.
    auto tangentResult =  makeConcreteTangentValue(tangentInst);
    setTangentValue(sei->getParent(), sei, tangentResult);
  }

  /// Handle `struct_element_addr` instruction.
  ///   Original: y = struct_element_addr x, #field
  ///    Tangent: tan[y] = struct_element_addr tan[x], #field'
  ///                                                  ^~~~~~~
  ///                          field in tangent space corresponding to #field
  CLONE_AND_EMIT_TANGENT(StructElementAddr, seai) {
    assert(!seai->getField()->getAttrs().hasAttribute<NoDerivativeAttr>() &&
           "`struct_element_addr` with `@noDerivative` field should not be "
           "differentiated; activity analysis should not marked as varied.");

    auto diffBuilder = getDifferentialBuilder();
    auto *bb = seai->getParent();
    auto tangentVectorTy =
        getRemappedTangentType(seai->getOperand()->getType());
    auto *tangentVectorDecl =
        tangentVectorTy.getStructOrBoundGenericStruct();

    // Find the corresponding field in the tangent space.
    VarDecl *tanField = nullptr;
    // If the tangent space is the original struct, then field is the same.
    if (tangentVectorDecl == seai->getStructDecl())
      tanField = seai->getField();
    // Otherwise, look up the field by name.
    else {
      auto tanFieldLookup =
          tangentVectorDecl->lookupDirect(seai->getField()->getName());
      if (tanFieldLookup.empty()) {
        context.emitNondifferentiabilityError(
            seai, invoker,
            diag::autodiff_stored_property_no_corresponding_tangent,
            seai->getStructDecl()->getNameStr(),
            seai->getField()->getNameStr());
        errorOccurred = true;
        return;
      }
      tanField = cast<VarDecl>(tanFieldLookup.front());
    }

    // Emit tangent `struct_element_addr`.
    auto tanOperand = getTangentBuffer(bb, seai->getOperand());
    auto tangentInst = diffBuilder.createStructElementAddr(
        seai->getLoc(), tanOperand, tanField);
    // Update tangent buffer map for `struct_element_addr`.
    setTangentBuffer(bb, seai, tangentInst);
  }

  /// Handle `tuple` instruction.
  ///   Original: y = tuple (x0, x1, x2, ...)
  ///    Tangent: tan[y] = tuple (tan[x0], tan[x1], tan[x2], ...)
  ///                                                        ^~~
  ///                                      excluding non-differentiable elements
  CLONE_AND_EMIT_TANGENT(Tuple, ti) {
    auto diffBuilder = getDifferentialBuilder();

    // Get the tangents of all the tuple elements.
    SmallVector<SILValue, 8> tangentTupleElements;
    for (auto elem : ti->getElements()) {
      if (!getTangentSpace(elem->getType().getASTType()))
        continue;
      tangentTupleElements.push_back(
          materializeTangent(getTangentValue(elem), ti->getLoc()));
    }

    // Emit the instruction and add the tangent mapping.
    auto tanTuple =
        joinElements(tangentTupleElements, diffBuilder, ti->getLoc());
    setTangentValue(ti->getParent(), ti, makeConcreteTangentValue(tanTuple));
  }

  /// Handle `tuple_extract` instruction.
  ///   Original: y = tuple_extract x, <n>
  ///    Tangent: tan[y] = tuple_extract tan[x], <n'>
  ///                                            ^~~~
  ///                         tuple tangent space index corresponding to n
  CLONE_AND_EMIT_TANGENT(TupleExtract, tei) {
    auto &diffBuilder = getDifferentialBuilder();
    auto loc = tei->getLoc();
    auto origTupleTy = tei->getOperand()->getType().castTo<TupleType>();
    unsigned tanIndex = 0;
    for (unsigned i : range(tei->getFieldNo())) {
      if (getTangentSpace(
              origTupleTy->getElement(i).getType()->getCanonicalType()))
        ++tanIndex;
    }
    auto tanType = getRemappedTangentType(tei->getType());
    auto tanSource = materializeTangent(
        getTangentValue(tei->getOperand()), loc);
    SILValue tanBuf;
    // If the tangent buffer of the source does not have a tuple type, then
    // it must represent a "single element tuple type". Use it directly.
    if (!tanSource->getType().is<TupleType>()) {
      setTangentValue(tei->getParent(), tei,
                      makeConcreteTangentValue(tanSource));
    } else {
      tanBuf = diffBuilder.createTupleExtract(loc, tanSource, tanIndex, tanType);
      bufferMap.try_emplace({tei->getParent(), tei}, tanBuf);
    }
  }

  /// Handle `tuple_element_addr` instruction.
  ///   Original: y = tuple_element_addr x, <n>
  ///    Tangent: tan[y] = tuple_element_addr tan[x], <n'>
  ///                                                ^~~~
  ///                            tuple tangent space index corresponding to n
  CLONE_AND_EMIT_TANGENT(TupleElementAddr, teai) {
    auto &diffBuilder = getDifferentialBuilder();
    auto origTupleTy = teai->getOperand()->getType().castTo<TupleType>();
    unsigned tanIndex = 0;
    for (unsigned i : range(teai->getFieldNo())) {
      if (getTangentSpace(
              origTupleTy->getElement(i).getType()->getCanonicalType()))
        ++tanIndex;
    }
    auto tanType = getRemappedTangentType(teai->getType());
    auto tanSource = getTangentBuffer(teai->getParent(), teai->getOperand());
    SILValue tanBuf;
    // If the tangent buffer of the source does not have a tuple type, then
    // it must represent a "single element tuple type". Use it directly.
    if (!tanSource->getType().is<TupleType>()) {
      tanBuf = tanSource;
    } else {
      tanBuf = diffBuilder.createTupleElementAddr(
          teai->getLoc(), tanSource, tanIndex, tanType);
    }
    bufferMap.try_emplace({teai->getParent(), teai}, tanBuf);
  }

  /// Handle `destructure_tuple` instruction.
  ///   Original: (y0, y1, ...)  = destructure_tuple x, <n>
  ///    Tangent: (tan[y0], tan[y1], ...) = destructure_tuple tan[x], <n'>
  ///                                                                 ^~~~
  ///                              tuple tangent space index corresponding to n
  CLONE_AND_EMIT_TANGENT(DestructureTuple, dti) {
    assert(llvm::any_of(dti->getResults(),
                        [&](SILValue elt) {
                          return activityInfo.isActive(elt, getIndices());
                        }) &&
           "`destructure_tuple` should have at least one active result");

    auto &diffBuilder = getDifferentialBuilder();
    auto *bb = dti->getParent();
    auto loc = dti->getLoc();

    auto tanTuple =
        materializeTangent(getTangentValue(dti->getOperand()), loc);
    SmallVector<SILValue, 4> tanElts;
    if (tanTuple->getType().is<TupleType>()) {
      auto *tanDti = diffBuilder.createDestructureTuple(loc, tanTuple);
      tanElts.append(tanDti->getResults().begin(), tanDti->getResults().end());
    } else {
      tanElts.push_back(tanTuple);
    }
    unsigned tanIdx = 0;
    for (auto i : range(dti->getNumResults())) {
      auto origElt = dti->getResult(i);
      if (!getTangentSpace(origElt->getType().getASTType()))
        continue;
      setTangentValue(bb, origElt, makeConcreteTangentValue(tanElts[tanIdx++]));
    }
  }

#undef CLONE_AND_EMIT_TANGENT

  /// Handle `apply` instruction.
  ///   Original: y = apply f(x0, x1, ...)
  ///    Tangent: tan[y] = apply diff_f(tan[x0], tan[x1], ...)
  void emitTangentForApplyInst(ApplyInst *ai, SILAutoDiffIndices actualIndices,
                               CanSILFunctionType originalDifferentialType) {
    assert(differentialInfo.shouldDifferentiateApplyInst(ai));
    auto *bb = ai->getParent();
    auto loc = ai->getLoc();
    auto &diffBuilder = getDifferentialBuilder();

    // Get the differential value.
    auto *field = differentialInfo.lookUpLinearMapDecl(ai);
    assert(field);
    SILValue differential = getDifferentialStructElement(bb, field);
    auto differentialType = remapSILTypeInDifferential(differential->getType())
        .castTo<SILFunctionType>();

    // Get the differential arguments.
    SmallVector<SILValue, 8> diffArgs;

    for (auto indRes : ai->getIndirectSILResults())
      diffArgs.push_back(getTangentBuffer(bb, indRes));

    auto paramArgs = ai->getArgumentsWithoutIndirectResults();
    // Get the tangent value of the original arguments.
    for (auto i : indices(paramArgs)) {
      auto origArg = paramArgs[i];
      // If the argument is not active:
      // - Skip the element, if it is not differentiable.
      // - Otherwise, add a zero value to that location.
      if (!activityInfo.isActive(origArg, getIndices())) {
        auto origCalleeType = ai->getSubstCalleeType();
        if (!origCalleeType->isDifferentiable())
          continue;
        auto actualOrigCalleeIndices =
            origCalleeType->getDifferentiationParameterIndices();
        if (actualOrigCalleeIndices->contains(i)) {
          SILValue tanParam;
          if (origArg->getType().isObject()) {
            tanParam = emitZeroDirect(
                getRemappedTangentType(origArg->getType()).getASTType(), loc);
            diffArgs.push_back(tanParam);
          } else {
            tanParam = diffBuilder.createAllocStack(
                loc, getRemappedTangentType(origArg->getType()));
            emitZeroIndirect(
                getRemappedTangentType(origArg->getType()).getASTType(), tanParam,
                loc);
          }
        }
      }
      // Otherwise, if the argument is active, handle the argument normally by
      // getting its tangent value.
      else {
        SILValue tanParam;
        if (origArg->getType().isObject()) {
          tanParam = materializeTangent(getTangentValue(origArg), loc);
        } else {
          tanParam = getTangentBuffer(ai->getParent(), origArg);
        }
        diffArgs.push_back(tanParam);
        if (errorOccurred)
          return;
      }
    }

    // If callee differential was reabstracted in JVP, reabstract the callee
    // differential.
    if (!differentialType->isEqual(originalDifferentialType)) {
      SILOptFunctionBuilder fb(context.getTransform());
      auto *thunk = getOrCreateReabstractionThunk(
          fb, context.getModule(), loc, &getDifferential(),
          differentialType, originalDifferentialType);
      auto *thunkRef = diffBuilder.createFunctionRef(loc, thunk);
      differential = diffBuilder.createPartialApply(
         loc, thunkRef,
         remapSubstitutionMapInDifferential(
             thunk->getForwardingSubstitutionMap()),
         {differential}, differentialType->getCalleeConvention());
    }

    // Call the differential.
    auto *differentialCall = diffBuilder.createApply(
        loc, differential, SubstitutionMap(), diffArgs,
        /*isNonThrowing*/ false);
    diffBuilder.emitDestroyValueOperation(loc, differential);
    assert(differentialCall->getNumResults() == 1 &&
           "Expected differential to return one result");

    // Get the original results of the `apply` instructions.
    SmallVector<SILValue, 8> origDirectResults;
    forEachApplyDirectResult(ai, [&](SILValue directResult) {
      origDirectResults.push_back(directResult);
    });
    SmallVector<SILValue, 8> origAllResults;
    collectAllActualResultsInTypeOrder(ai, origDirectResults, origAllResults);
    auto origResult = origAllResults[actualIndices.source];

    // Get the differential results of the `apply` instructions.
    SmallVector<SILValue, 8> differentialDirectResults;
    forEachApplyDirectResult(differentialCall, [&](SILValue directResult) {
      differentialDirectResults.push_back(directResult);
    });
    SmallVector<SILValue, 8> differentialAllResults;
    collectAllActualResultsInTypeOrder(differentialCall,
                                       differentialDirectResults,
                                       differentialAllResults);
    auto differentialResult = differentialAllResults.front();

    // Add tangent for original result.
    if (origResult->getType().isObject()) {
      if (!origResult->getType().is<TupleType>()) {
        setTangentValue(bb, origResult,
            makeConcreteTangentValue(differentialResult));
      } else if (auto *dti = getSingleDestructureTupleUser(ai)) {
        bool notSetValue = true;
        for (auto result : dti->getResults()) {
          if (activityInfo.isActive(result, getIndices())) {
            assert(notSetValue &&
                   "This was incorrectly set, should only have one active "
                   "result from the tuple.");
            notSetValue = false;
            setTangentValue(bb, result,
                            makeConcreteTangentValue(differentialResult));
          }
        }
      }
    }
  }

  /// Generate a `return` instruction in the current differential basic block.
  void emitReturnInstForDifferential() {
    auto &differential = getDifferential();
    auto diffLoc = differential.getLocation();
    auto &diffBuilder = getDifferentialBuilder();

    SmallVector<SILValue, 2> activeResults;

    // This vector will contain all the materialized return elements.
    SmallVector<SILValue, 8> retElts;
    SmallVector<SILValue, 2> originalResults;
    collectAllDirectResultsInTypeOrder(*original, originalResults);

    // Materializes the return element corresponding to the result
    // `resultIndex` into the `retElts` vector.
    auto addActiveResult = [&](unsigned resultIndex) -> void {
      auto origResult = originalResults[resultIndex];
      assert(origResult->getType().isObject() &&
             "Should only be handling direct results for 'return' "
             "instruction.");
      if (activityInfo.isActive(origResult, getIndices())) {
        activeResults.push_back(origResult);
      }
    };
    // Create an array of the direct tangent values of the original results.
    for (auto i : range(originalResults.size()))
      addActiveResult(i);
    assert(activeResults.size() <= 1);

    if (activeResults.empty() && !originalResults.empty()) {
      // Create zero tangent value for direct result.
      auto origResult = originalResults[getIndices().source];
      assert(origResult->getType().isObject() &&
             "Should only be handling direct results for 'return' "
             "instruction.");
      auto zeroType = origResult->getType().getASTType();
      auto zero =
          emitZeroDirect(getTangentSpace(zeroType)->getCanonicalType(),
                         diffLoc);
      retElts.push_back(zero);
    } else if (!activeResults.empty()) {
      auto diffVal = getTangentValue(activeResults.front());
      auto val = materializeTangent(diffVal, diffLoc);
      retElts.push_back(val);
    }

    diffBuilder.createReturn(
        diffLoc, joinElements(retElts, diffBuilder, diffLoc));
  }

private:

  /// Set up the differential function. This includes:
  /// - Creating all differential blocks.
  /// - Creating differential entry block arguments based on the function type.
  /// - Creating tangent value mapping for original/differential parameters.
  /// - Checking for unvaried result and emitting related warnings.
  void prepareForDifferentialGeneration() {
    // Create differential blocks and arguments.
    auto *diffGenEnv = getDifferential().getGenericEnvironment();
    auto diffGenSig = diffGenEnv
        ? diffGenEnv->getGenericSignature()->getCanonicalSignature()
        : nullptr;
    auto &differential = getDifferential();
    auto *origEntry = original->getEntryBlock();
    for (auto &origBB : *original) {
      auto *diffBB = differential.createBasicBlock();
      diffBBMap.insert({&origBB, diffBB});
      {
        Lowering::GenericContextScope genericContextScope(
            context.getTypeConverter(), diffGenSig);
        auto diffStructLoweredType = remapSILTypeInDifferential(
            differentialInfo.getLinearMapStructLoweredType(&origBB));

        // If the BB is the original entry, then the differential block that we
        // just created must be the differential function's entry. Create
        // differential entry arguments and continue.
        if (&origBB == origEntry) {
          assert(diffBB->isEntry());
          createEntryArguments(&differential);
          auto *lastArg = diffBB->getArguments().back();
          assert(lastArg->getType() == diffStructLoweredType);
          differentialStructArguments[&origBB] = lastArg;
        }
      }

      LLVM_DEBUG({
        auto &s = getADDebugStream()
                  << "Original bb" + std::to_string(origBB.getDebugID())
                  << ": To differentiate or not to differentiate?\n";
        for (auto &inst : origBB) {
          s << (differentialInfo.shouldDifferentiateInstruction(&inst)
                    ? "[x] " : "[ ] ")
            << inst;
        }
      });
    }

    assert(diffBBMap.size() == 1 &&
           "Can only currently handle single basic block functions");

    // The differential function has type:
    // (arg0', ..., argn', entry_df_struct) -> result'.
    auto diffParamArgs =
        differential.getArgumentsWithoutIndirectResults().drop_back();
    assert(diffParamArgs.size() ==
           witness->getSILAutoDiffIndices().parameters->getNumIndices());
    auto origParamArgs = original->getArgumentsWithoutIndirectResults();

    // TODO(TF-788): Re-enable non-varied result warning.
    /*
    // Check if result is not varied.
    SmallVector<SILValue, 8> origFormalResults;
    collectAllFormalResultsInTypeOrder(*original, origFormalResults);
    auto origResult = origFormalResults[getIndices().source];
    // Emit warning if original result is not varied, because it will always
    // have a zero derivative.
    if (!activityInfo.isVaried(origResult, getIndices().parameters)) {
      // Emit fixit if original result has a valid source location.
      auto startLoc = origResult.getLoc().getStartSourceLoc();
      auto endLoc = origResult.getLoc().getEndSourceLoc();
      if (startLoc.isValid() && endLoc.isValid()) {
        context.diagnose(startLoc, diag::autodiff_nonvaried_result_fixit)
            .fixItInsert(startLoc, "withoutDerivative(at:")
            .fixItInsertAfter(endLoc, ")");
      }
    }
    */

    // Initialize tangent mapping for parameters.
    auto diffParamsIt = getIndices().parameters->begin();
    for (auto index : range(diffParamArgs.size())) {
      auto *diffArg = diffParamArgs[index];
      auto *origArg = origParamArgs[*diffParamsIt];
      diffParamsIt++;
      if (diffArg->getType().isAddress()) {
        setTangentBuffer(origEntry, origArg, diffArg);
      } else {
        setTangentValue(
            origEntry, origArg, makeConcreteTangentValue(diffArg));
      }
      LLVM_DEBUG(getADDebugStream()
                 << "Assigned parameter " << *diffArg
                 << " as the tangent of original result " << *origArg);
    }

    // Initialize tangent mapping for indirect results.
    auto origIndResults = original->getIndirectResults();
    auto diffIndResults = differential.getIndirectResults();
    assert(origIndResults.size() == diffIndResults.size());

    for (auto &origBB : *original)
      for (auto i : indices(diffIndResults))
        setTangentBuffer(&origBB, origIndResults[i], diffIndResults[i]);
  }

public:
  explicit JVPEmitter(ADContext &context, SILFunction *original,
                      SILDifferentiabilityWitness *witness, SILFunction *jvp,
                      DifferentiationInvoker invoker)
      : TypeSubstCloner(*jvp, *original, getSubstitutionMap(original, jvp)),
        context(context), original(original), witness(witness), jvp(jvp),
        invoker(invoker),
        activityInfo(getActivityInfo(context, original,
                                     witness->getSILAutoDiffIndices(), jvp)),
        differentialInfo(context, AutoDiffLinearMapKind::Differential, original,
                         jvp, witness->getSILAutoDiffIndices(), activityInfo),
        differentialBuilder(SILBuilder(
            *createEmptyDifferential(context, witness, &differentialInfo))),
        diffLocalAllocBuilder(getDifferential()) {
    // Create empty differential function.
    context.recordGeneratedFunction(&getDifferential());
  }

  static SILFunction *
  createEmptyDifferential(ADContext &context,
                          SILDifferentiabilityWitness *witness,
                          LinearMapInfo *linearMapInfo) {
    auto &module = context.getModule();
    auto *original = witness->getOriginalFunction();
    auto *jvp = witness->getJVP();
    auto origTy = original->getLoweredFunctionType();
    auto lookupConformance = LookUpConformanceInModule(module.getSwiftModule());

    // RAII that pushes the original function's generic signature to
    // `module.Types` so that calls to `module.Types.getTypeLowering()` below
    // will know the original function's generic parameter types.
    Lowering::GenericContextScope genericContextScope(
        module.Types, origTy->getSubstGenericSignature());

    // Parameters of the differential are:
    // - the tangent values of the wrt parameters.
    // - the differential struct for the original entry.
    // Result of the differential is in the tangent space of the original
    // result.
    SmallVector<SILParameterInfo, 8> dfParams;
    SmallVector<SILResultInfo, 8> dfResults;
    auto origParams = origTy->getParameters();
    auto indices = witness->getSILAutoDiffIndices();

    // Add differential results.
    auto origResInfo = origTy->getResults()[indices.source];
    dfResults.push_back(
        SILResultInfo(origResInfo.getInterfaceType()
                          ->getAutoDiffAssociatedTangentSpace(lookupConformance)
                          ->getCanonicalType(),
                      origResInfo.getConvention()));

    // Add differential parameters for the requested wrt parameters.
    for (auto i : indices.parameters->getIndices()) {
      auto origParam = origParams[i];
      dfParams.push_back(SILParameterInfo(
          origParam.getInterfaceType()
              ->getAutoDiffAssociatedTangentSpace(lookupConformance)
              ->getCanonicalType(),
          origParam.getConvention()));
    }

    // Accept a differential struct in the differential parameter list. This is
    // the returned differential's closure context.
    auto *origEntry = original->getEntryBlock();
    auto *dfStruct = linearMapInfo->getLinearMapStruct(origEntry);
    auto dfStructType =
        dfStruct->getDeclaredInterfaceType()->getCanonicalType();
    dfParams.push_back({dfStructType, ParameterConvention::Direct_Owned});

    Mangle::ASTMangler mangler;
    auto diffName = original->getASTContext().getIdentifier(
        mangler.mangleAutoDiffLinearMapHelper(
            original->getName(), AutoDiffLinearMapKind::Differential,
            indices)).str();
    auto diffGenericSig = getDerivativeGenericSignature(witness, original);
    auto *diffGenericEnv =
        diffGenericSig ? diffGenericSig->getGenericEnvironment() : nullptr;
    auto diffType = SILFunctionType::get(
        diffGenericSig, origTy->getExtInfo(), origTy->getCoroutineKind(),
        origTy->getCalleeConvention(), dfParams, {}, dfResults, None,
        origTy->getSubstitutions(), origTy->isGenericSignatureImplied(),
        original->getASTContext());

    SILOptFunctionBuilder fb(context.getTransform());
    auto linkage =
        jvp->isSerialized() ? SILLinkage::Public : SILLinkage::Hidden;
    auto *differential = fb.createFunction(
        linkage, diffName, diffType, diffGenericEnv, original->getLocation(),
        original->isBare(), IsNotTransparent, jvp->isSerialized(),
        original->isDynamicallyReplaceable());
    differential->setDebugScope(
        new (module) SILDebugScope(original->getLocation(), differential));

    return differential;
  }

  /// Run JVP generation. Returns true on error.
  bool run() {
    PrettyStackTraceSILFunction trace("generating JVP and differential for",
                                      original);
    LLVM_DEBUG(getADDebugStream()
               << "Cloning original @" << original->getName()
               << " to jvp @" << jvp->getName() << '\n');
    // Create JVP and differential entry and arguments.
    auto *entry = jvp->createBasicBlock();
    createEntryArguments(jvp);
    prepareForDifferentialGeneration();
    // Clone.
    SmallVector<SILValue, 4> entryArgs(entry->getArguments().begin(),
                                       entry->getArguments().end());
    cloneFunctionBody(original, entry, entryArgs);
    emitReturnInstForDifferential();
    // If errors occurred, back out.
    if (errorOccurred)
      return true;
    LLVM_DEBUG(getADDebugStream() << "Generated JVP for "
               << original->getName() << ":\n" << *jvp);
    LLVM_DEBUG(getADDebugStream() << "Generated differential for "
               << original->getName() << ":\n" << getDifferential());
    return errorOccurred;
  }

  void postProcess(SILInstruction *orig, SILInstruction *cloned) {
    if (errorOccurred)
      return;
    SILClonerWithScopes::postProcess(orig, cloned);
  }

  /// Remap original basic blocks.
  SILBasicBlock *remapBasicBlock(SILBasicBlock *bb) {
    auto *jvpBB = BBMap[bb];
    return jvpBB;
  }

  /// General visitor for all instructions. If any error is emitted by previous
  /// visits, bail out.
  void visit(SILInstruction *inst) {
    auto diffBuilder = getDifferentialBuilder();
    if (errorOccurred)
      return;
    if (differentialInfo.shouldDifferentiateInstruction(inst)) {
      LLVM_DEBUG(getADDebugStream() << "JVPEmitter visited:\n[ORIG]" << *inst);
#ifndef NDEBUG
      auto beforeInsertion = std::prev(diffBuilder.getInsertionPoint());
#endif
      TypeSubstCloner::visit(inst);
      LLVM_DEBUG({
        auto &s = llvm::dbgs() << "[TAN] Emitted in differential:\n";
        auto afterInsertion = diffBuilder.getInsertionPoint();
        for (auto it = ++beforeInsertion; it != afterInsertion; ++it)
          s << *it;
      });
    } else {
      TypeSubstCloner::visit(inst);
    }
  }

  void visitSILInstruction(SILInstruction *inst) {
    context.emitNondifferentiabilityError(inst, invoker,
        diag::autodiff_expression_not_differentiable_note);
    errorOccurred = true;
  }

  void visitInstructionsInBlock(SILBasicBlock *bb) {
    // Destructure the differential struct to get the elements.
    auto &diffBuilder = getDifferentialBuilder();
    auto diffLoc = getDifferential().getLocation();
    auto *diffBB = diffBBMap.lookup(bb);
    auto *mainDifferentialStruct = diffBB->getArguments().back();
    diffBuilder.setInsertionPoint(diffBB);
    auto *dsi = diffBuilder.createDestructureStruct(
        diffLoc, mainDifferentialStruct);
    initializeDifferentialStructElements(bb, dsi->getResults());
    TypeSubstCloner::visitInstructionsInBlock(bb);
  }

  // If an `apply` has active results or active inout parameters, replace it
  // with an `apply` of its JVP.
  void visitApplyInst(ApplyInst *ai) {
    // If the function should not be differentiated or its the array literal
    // initialization intrinsic, just do standard cloning.
    if (!differentialInfo.shouldDifferentiateApplyInst(ai) ||
        isArrayLiteralIntrinsic(ai)) {
      LLVM_DEBUG(getADDebugStream() << "No active results:\n" << *ai << '\n');
      TypeSubstCloner::visitApplyInst(ai);
      return;
    }

    // Diagnose functions with active inout arguments.
    // TODO(TF-129): Support `inout` argument differentiation.
    for (auto inoutArg : ai->getInoutArguments()) {
      if (activityInfo.isActive(inoutArg, getIndices())) {
        context.emitNondifferentiabilityError(ai, invoker,
            diag::autodiff_cannot_differentiate_through_inout_arguments);
        errorOccurred = true;
        return;
      }
    }

    LLVM_DEBUG(getADDebugStream() << "JVP-transforming:\n" << *ai << '\n');

    // Get the minimal parameter and result indices required for differentiating
    // this `apply`.
    SmallVector<SILValue, 4> allResults;
    SmallVector<unsigned, 8> activeParamIndices;
    SmallVector<unsigned, 8> activeResultIndices;
    collectMinimalIndicesForFunctionCall(ai, getIndices(), activityInfo,
                                         allResults, activeParamIndices,
                                         activeResultIndices);
    assert(!activeParamIndices.empty() && "Parameter indices cannot be empty");
    assert(!activeResultIndices.empty() && "Result indices cannot be empty");
    LLVM_DEBUG(auto &s = getADDebugStream() << "Active indices: params={";
               interleave(activeParamIndices.begin(), activeParamIndices.end(),
                          [&s](unsigned i) { s << i; }, [&s] { s << ", "; });
               s << "}, results={"; interleave(
                   activeResultIndices.begin(), activeResultIndices.end(),
                   [&s](unsigned i) { s << i; }, [&s] { s << ", "; });
               s << "}\n";);
    // Diagnose multiple active results.
    // TODO(TF-983): Support multiple active results.
    if (activeResultIndices.size() > 1) {
      context.emitNondifferentiabilityError(
          ai, invoker,
          diag::autodiff_cannot_differentiate_through_multiple_results);
      errorOccurred = true;
      return;
    }

    // Form expected indices, assuming there's only one result.
    SILAutoDiffIndices indices(
        activeResultIndices.front(),
        IndexSubset::get(
            getASTContext(), ai->getArgumentsWithoutIndirectResults().size(),
            activeParamIndices));

    // Emit the JVP.
    auto loc = ai->getLoc();
    auto &builder = getBuilder();
    auto original = getOpValue(ai->getCallee());
    SILValue jvpValue;
    // If functionSource is a `@differentiable` function, just extract it.
    auto originalFnTy = original->getType().castTo<SILFunctionType>();
    if (originalFnTy->isDifferentiable()) {
      auto paramIndices = originalFnTy->getDifferentiationParameterIndices();
      for (auto i : indices.parameters->getIndices()) {
        if (!paramIndices->contains(i)) {
          context.emitNondifferentiabilityError(original, invoker,
              diag::autodiff_function_nondiff_parameter_not_differentiable);
          errorOccurred = true;
          return;
        }
      }
      auto borrowedDiffFunc = builder.emitBeginBorrowOperation(loc, original);
      jvpValue = builder.createDifferentiableFunctionExtract(
          loc, NormalDifferentiableFunctionTypeComponent::JVP,
          borrowedDiffFunc);
      jvpValue = builder.emitCopyValueOperation(loc, jvpValue);
    }

    // If JVP has not yet been found, emit an `differentiable_function`
    // instruction on the remapped original function operand and
    // an `differentiable_function_extract` instruction to get the JVP.
    // The `differentiable_function` instruction will be canonicalized during
    // the transform main loop.
    if (!jvpValue) {
      // FIXME: Handle indirect differentiation invokers. This may require some
      // redesign: currently, each original function + witness pair is mapped
      // only to one invoker.
      /*
       DifferentiationInvoker indirect(ai, attr);
       auto insertion =
           context.getInvokers().try_emplace({this->original, attr}, indirect);
       auto &invoker = insertion.first->getSecond();
       invoker = indirect;
       */

      // If the original `apply` instruction has a substitution map, then the
      // applied function is specialized.
      // In the JVP, specialization is also necessary for parity. The original
      // function operand is specialized with a remapped version of same
      // substitution map using an argument-less `partial_apply`.
      if (ai->getSubstitutionMap().empty()) {
        original = builder.emitCopyValueOperation(loc, original);
      } else {
        auto substMap = getOpSubstitutionMap(ai->getSubstitutionMap());
        auto jvpPartialApply = getBuilder().createPartialApply(
            ai->getLoc(), original, substMap, {},
            ParameterConvention::Direct_Guaranteed);
        original = jvpPartialApply;
      }

      // Check and diagnose non-differentiable original function type.
      auto diagnoseNondifferentiableOriginalFunctionType =
          [&](CanSILFunctionType origFnTy) {
            // Check and diagnose non-differentiable arguments.
            for (unsigned paramIndex : range(originalFnTy->getNumParameters())) {
              if (indices.isWrtParameter(paramIndex) &&
                      !originalFnTy->getParameters()[paramIndex]
                      .getSILStorageInterfaceType()
                      .isDifferentiable(getModule())) {
                context.emitNondifferentiabilityError(
                    ai->getArgumentsWithoutIndirectResults()[paramIndex], invoker,
                    diag::autodiff_nondifferentiable_argument);
                errorOccurred = true;
                return true;
              }
            }
            // Check and diagnose non-differentiable results.
            if (!originalFnTy->getResults()[indices.source]
                    .getSILStorageInterfaceType()
                    .isDifferentiable(getModule())) {
              context.emitNondifferentiabilityError(
                  original, invoker, diag::autodiff_nondifferentiable_result);
              errorOccurred = true;
              return true;
            }
            return false;
          };
      if (diagnoseNondifferentiableOriginalFunctionType(originalFnTy))
        return;

      auto *diffFuncInst = context.createDifferentiableFunction(
          builder, loc, indices.parameters, original);

      // Record the `differentiable_function` instruction.
      context.addDifferentiableFunctionInstToWorklist(diffFuncInst);
      // TODO(TF-689): Make `differentiable_function` store result indices and
      // remove `ADContext::resultIndices`.
      context.setResultIndex(diffFuncInst, activeResultIndices.front());

      auto borrowedADFunc =
          builder.emitBeginBorrowOperation(loc, diffFuncInst);
      auto extractedJVP = builder.createDifferentiableFunctionExtract(
          loc, NormalDifferentiableFunctionTypeComponent::JVP,
          borrowedADFunc);
      jvpValue = builder.emitCopyValueOperation(loc, extractedJVP);
      builder.emitEndBorrowOperation(loc, borrowedADFunc);
      builder.emitDestroyValueOperation(loc, diffFuncInst);
    }

    // Call the JVP using the original parameters.
    SmallVector<SILValue, 8> jvpArgs;
    auto jvpFnTy = getOpType(jvpValue->getType()).castTo<SILFunctionType>();
    auto numJVPArgs =
        jvpFnTy->getNumParameters() + jvpFnTy->getNumIndirectFormalResults();
    jvpArgs.reserve(numJVPArgs);
    // Collect substituted arguments.
    for (auto origArg : ai->getArguments())
      jvpArgs.push_back(getOpValue(origArg));
    assert(jvpArgs.size() == numJVPArgs);
    // Apply the JVP.
    // The JVP should be specialized, so no substitution map is necessary.
    auto *jvpCall = getBuilder().createApply(loc, jvpValue, SubstitutionMap(),
                                             jvpArgs, ai->isNonThrowing());
    LLVM_DEBUG(getADDebugStream() << "Applied jvp function\n" << *jvpCall);

    // Release the differentiable function.
    builder.emitDestroyValueOperation(loc, jvpValue);

    // Get the JVP results (original results and differential).
    SmallVector<SILValue, 8> jvpDirectResults;
    extractAllElements(jvpCall, builder, jvpDirectResults);
    auto originalDirectResults =
        ArrayRef<SILValue>(jvpDirectResults).drop_back(1);
    auto originalDirectResult =
        joinElements(originalDirectResults, getBuilder(), jvpCall->getLoc());

    mapValue(ai, originalDirectResult);

    // Some instructions that produce the callee may have been cloned.
    // If the original callee did not have any users beyond this `apply`,
    // recursively kill the cloned callee.
    if (auto *origCallee = cast_or_null<SingleValueInstruction>(
            ai->getCallee()->getDefiningInstruction()))
      if (origCallee->hasOneUse())
        recursivelyDeleteTriviallyDeadInstructions(
            getOpValue(origCallee)->getDefiningInstruction());

    // Add the differential function for when we create the struct we partially
    // apply to the differential we are generating.
    auto differential = jvpDirectResults.back();
    auto *differentialDecl = differentialInfo.lookUpLinearMapDecl(ai);
    auto originalDifferentialType =
        getOpType(differential->getType()).getAs<SILFunctionType>();
    auto differentialType =
        remapType(differential->getType())
            .castTo<SILFunctionType>();
    auto jvpGenSig = SubsMap.getGenericSignature()
        ? SubsMap.getGenericSignature()->getCanonicalSignature()
        : nullptr;
    Lowering::GenericContextScope genericContextScope(
        context.getTypeConverter(), jvpGenSig);
    auto loweredDifferentialType =
        getOpType(context.getTypeConverter().getLoweredType(
            differentialDecl->getInterfaceType()->getCanonicalType(),
            TypeExpansionContext::minimal()))
            .castTo<SILFunctionType>();
    // If actual differential type does not match lowered differential type,
    // reabstract the differential using a thunk.
    if (!loweredDifferentialType->isEqual(originalDifferentialType)) {
      SILOptFunctionBuilder fb(context.getTransform());
      auto *thunk = getOrCreateReabstractionThunk(
          fb, context.getModule(), loc, &getDifferential(),
          differentialType, loweredDifferentialType);
      auto *thunkRef = builder.createFunctionRef(loc, thunk);
      differential = builder.createPartialApply(
          loc, thunkRef,
          getOpSubstitutionMap(thunk->getForwardingSubstitutionMap()),
          {differential}, differentialType->getCalleeConvention());
    }
    differentialValues[ai->getParent()].push_back(differential);

    // Differential emission.
    emitTangentForApplyInst(ai, indices, originalDifferentialType);
  }

  void visitReturnInst(ReturnInst *ri) {
    auto loc = ri->getOperand().getLoc();
    auto *origExit = ri->getParent();
    auto &builder = getBuilder();
    auto *diffStructVal = buildDifferentialValueStructValue(ri);

    // Get the JVP value corresponding to the original functions's return value.
    auto *origRetInst = cast<ReturnInst>(origExit->getTerminator());
    auto origResult = getOpValue(origRetInst->getOperand());
    SmallVector<SILValue, 8> origResults;
    extractAllElements(origResult, builder, origResults);

    // Get and partially apply the differential.
    auto jvpGenericEnv = jvp->getGenericEnvironment();
    auto jvpSubstMap = jvpGenericEnv
        ? jvpGenericEnv->getForwardingSubstitutionMap()
        : jvp->getForwardingSubstitutionMap();
    auto *differentialRef =
        builder.createFunctionRef(loc, &getDifferential());
    auto *differentialPartialApply = builder.createPartialApply(
        loc, differentialRef, jvpSubstMap, {diffStructVal},
        ParameterConvention::Direct_Guaranteed);

    // Return a tuple of the original result and pullback.
    SmallVector<SILValue, 8> directResults;
    directResults.append(origResults.begin(), origResults.end());
    directResults.push_back(differentialPartialApply);
    builder.createReturn(
        ri->getLoc(), joinElements(directResults, builder, loc));
  }

  void visitBranchInst(BranchInst *bi) {
    llvm_unreachable("Unsupported SIL instruction.");
  }

  void visitCondBranchInst(CondBranchInst *cbi) {
    llvm_unreachable("Unsupported SIL instruction.");
  }

  void visitSwitchEnumInst(SwitchEnumInst *sei) {
    llvm_unreachable("Unsupported SIL instruction.");
  }

  void visitDifferentiableFunctionInst(DifferentiableFunctionInst *dfi) {
    // Clone `differentiable_function` from original to JVP, then add the cloned
    // instruction to the `differentiable_function` worklist.
    TypeSubstCloner::visitDifferentiableFunctionInst(dfi);
    auto *newDFI = cast<DifferentiableFunctionInst>(getOpValue(dfi));
    context.addDifferentiableFunctionInstToWorklist(newDFI);
  }
};
} // end anonymous namespace

//===----------------------------------------------------------------------===//
// PullbackEmitter - visitors on the original function for pullback code
// generation
//===----------------------------------------------------------------------===//

namespace {
class PullbackEmitter final : public SILInstructionVisitor<PullbackEmitter> {
private:
  /// The parent VJP emitter.
  VJPEmitter &vjpEmitter;

  /// Dominance info for the original function.
  DominanceInfo *domInfo = nullptr;

  /// Post-dominance info for the original function.
  PostDominanceInfo *postDomInfo = nullptr;

  /// Post-order info for the original function.
  PostOrderFunctionInfo *postOrderInfo = nullptr;

  /// Mapping from original basic blocks to corresponding pullback basic blocks.
  /// Pullback basic blocks always have the predecessor as the single argument.
  DenseMap<SILBasicBlock *, SILBasicBlock *> pullbackBBMap;

  /// Mapping from original basic blocks and original values to corresponding
  /// adjoint values.
  DenseMap<std::pair<SILBasicBlock *, SILValue>, AdjointValue> valueMap;

  /// Mapping from original basic blocks and original buffers to corresponding
  /// adjoint buffers.
  DenseMap<std::pair<SILBasicBlock *, SILValue>, SILValue> bufferMap;

  /// Mapping from pullback basic blocks to pullback struct arguments.
  DenseMap<SILBasicBlock *, SILArgument *> pullbackStructArguments;

  /// Mapping from pullback struct field declarations to pullback struct
  /// elements destructured from the linear map basic block argument. In the
  /// beginning of each pullback basic block, the block's pullback struct is
  /// destructured into individual elements stored here.
  DenseMap<VarDecl *, SILValue> pullbackStructElements;

  /// Mapping from original basic blocks and successor basic blocks to
  /// corresponding pullback trampoline basic blocks. Trampoline basic blocks
  /// take additional arguments in addition to the predecessor enum argument.
  DenseMap<std::pair<SILBasicBlock *, SILBasicBlock *>, SILBasicBlock *>
      pullbackTrampolineBBMap;

  /// Mapping from original basic blocks to dominated active values.
  DenseMap<SILBasicBlock *, SmallVector<SILValue, 8>> activeValues;

  /// Mapping from original basic blocks and original active values to
  /// corresponding pullback block arguments.
  DenseMap<std::pair<SILBasicBlock *, SILValue>, SILArgument *>
      activeValuePullbackBBArgumentMap;

  /// Mapping from original basic blocks to local temporary values to be cleaned
  /// up. This is populated when pullback emission is run on one basic block and
  /// cleaned before processing another basic block.
  DenseMap<SILBasicBlock *, SmallSetVector<SILValue, 64>> blockTemporaries;

  /// The main builder.
  SILBuilder builder;

  /// An auxiliary local allocation builder.
  SILBuilder localAllocBuilder;

  /// Stack buffers allocated for storing local adjoint values.
  SmallVector<SILValue, 64> functionLocalAllocations;

  /// A set used to remember local allocations that were destroyed.
  llvm::SmallDenseSet<SILValue> destroyedLocalAllocations;

  /// The seed argument in the pullback function.
  SILArgument *seed = nullptr;

  llvm::BumpPtrAllocator allocator;

  bool errorOccurred = false;

  ADContext &getContext() const { return vjpEmitter.context; }
  SILModule &getModule() const { return getContext().getModule(); }
  ASTContext &getASTContext() const { return getPullback().getASTContext(); }
  SILFunction &getOriginal() const { return *vjpEmitter.original; }
  SILFunction &getPullback() const { return *vjpEmitter.pullback; }
  SILDifferentiabilityWitness *getWitness() const { return vjpEmitter.witness; }
  DifferentiationInvoker getInvoker() const { return vjpEmitter.invoker; }
  LinearMapInfo &getPullbackInfo() { return vjpEmitter.pullbackInfo; }
  const SILAutoDiffIndices getIndices() const {
    return vjpEmitter.getIndices();
  }
  const DifferentiableActivityInfo &getActivityInfo() const {
    return vjpEmitter.activityInfo;
  }

public:
  explicit PullbackEmitter(VJPEmitter &vjpEmitter)
      : vjpEmitter(vjpEmitter), builder(getPullback()),
        localAllocBuilder(getPullback()) {
    // Get dominance and post-order info for the original function.
    auto &passManager = getContext().getPassManager();
    auto *domAnalysis = passManager.getAnalysis<DominanceAnalysis>();
    auto *postDomAnalysis = passManager.getAnalysis<PostDominanceAnalysis>();
    auto *postOrderAnalysis = passManager.getAnalysis<PostOrderAnalysis>();
    domInfo = domAnalysis->get(vjpEmitter.original);
    postDomInfo = postDomAnalysis->get(vjpEmitter.original);
    postOrderInfo = postOrderAnalysis->get(vjpEmitter.original);
  }

private:
  //--------------------------------------------------------------------------//
  // Pullback struct mapping
  //--------------------------------------------------------------------------//

  void initializePullbackStructElements(SILBasicBlock *origBB,
                                        SILInstructionResultArray values) {
    auto *pbStructDecl = getPullbackInfo().getLinearMapStruct(origBB);
    assert(pbStructDecl->getStoredProperties().size() == values.size() &&
           "The number of pullback struct fields must equal the number of "
           "pullback struct element values");
    for (auto pair : llvm::zip(pbStructDecl->getStoredProperties(), values)) {
      assert(
          std::get<1>(pair).getOwnershipKind() != ValueOwnershipKind::Guaranteed
              && "Pullback struct elements must be @owned");
      auto insertion =
          pullbackStructElements.insert({std::get<0>(pair), std::get<1>(pair)});
      (void)insertion;
      assert(insertion.second && "A pullback struct element already exists!");
    }
  }

  SILValue getPullbackStructElement(SILBasicBlock *origBB, VarDecl *field) {
    assert(getPullbackInfo().getLinearMapStruct(origBB) ==
               cast<StructDecl>(field->getDeclContext()));
    assert(pullbackStructElements.count(field) &&
           "Pullback struct element for this field does not exist!");
    return pullbackStructElements.lookup(field);
  }

  //--------------------------------------------------------------------------//
  // Adjoint value factory methods
  //--------------------------------------------------------------------------//

  AdjointValue makeZeroAdjointValue(SILType type);

  AdjointValue makeConcreteAdjointValue(SILValue value);

  template<typename EltRange>
  AdjointValue makeAggregateAdjointValue(SILType type, EltRange elements);

  //--------------------------------------------------------------------------//
  // Temporary value management
  //--------------------------------------------------------------------------//

  /// Record a temporary value for cleanup before its block's terminator.
  SILValue recordTemporary(SILValue value) {
    assert(value->getType().isObject());
    assert(value->getFunction() == &getPullback());
    auto inserted = blockTemporaries[value->getParentBlock()].insert(value);
    (void)inserted;
    LLVM_DEBUG(getADDebugStream() << "Recorded temporary " << value);
    assert(inserted && "Temporary already recorded?");
    return value;
  }

  /// Clean up all temporary values for the given pullback block.
  void cleanUpTemporariesForBlock(SILBasicBlock *bb, SILLocation loc) {
    assert(bb->getParent() == &getPullback());
    LLVM_DEBUG(getADDebugStream() << "Cleaning up temporaries for pullback bb"
               << bb->getDebugID() << '\n');
    for (auto temp : blockTemporaries[bb])
      builder.emitDestroyValueOperation(loc, temp);
    blockTemporaries[bb].clear();
  }

  //--------------------------------------------------------------------------//
  // Symbolic value materializers
  //--------------------------------------------------------------------------//

  /// Materialize an adjoint value. The type of the given adjoint value must be
  /// loadable.
  SILValue materializeAdjointDirect(AdjointValue val, SILLocation loc);

  /// Materialize an adjoint value indirectly to a SIL buffer.
  void materializeAdjointIndirect(AdjointValue val, SILValue destBuffer,
                                  SILLocation loc);

  //--------------------------------------------------------------------------//
  // Helpers for symbolic value materializers
  //--------------------------------------------------------------------------//

  /// Emit a zero value by calling `AdditiveArithmetic.zero`. The given type
  /// must conform to `AdditiveArithmetic`.
  void emitZeroIndirect(CanType type, SILValue bufferAccess, SILLocation loc);

  /// Emit a zero value by calling `AdditiveArithmetic.zero`. The given type
  /// must conform to `AdditiveArithmetic` and be loadable in SIL.
  SILValue emitZeroDirect(CanType type, SILLocation loc);

  //--------------------------------------------------------------------------//
  // Accumulator
  //--------------------------------------------------------------------------//

  /// Materialize an adjoint value in the most efficient way.
  SILValue materializeAdjoint(AdjointValue val, SILLocation loc);

  /// Given two adjoint values, accumulate them.
  AdjointValue accumulateAdjointsDirect(AdjointValue lhs, AdjointValue rhs,
                                        SILLocation loc);

  /// Given two materialized adjoint values, accumulate them. These two
  /// adjoints must be objects of loadable type.
  SILValue accumulateDirect(SILValue lhs, SILValue rhs, SILLocation loc);

  /// Given two materialized adjoint values, accumulate them using
  /// `AdditiveArithmetic.+`, depending on the differentiation mode.
  void accumulateIndirect(SILValue resultBufAccess,
                          SILValue lhsBufAccess, SILValue rhsBufAccess,
                          SILLocation loc);

  /// Given two buffers of an `AdditiveArithmetic` type, accumulate the right
  /// hand side into the left hand side using `+=`.
  void accumulateIndirect(SILValue lhsDestAccess, SILValue rhsAccess,
                          SILLocation loc);

  //--------------------------------------------------------------------------//
  // Type transformer
  //--------------------------------------------------------------------------//

  /// Remap any archetypes into the current function's context.
  SILType remapType(SILType ty) {
    if (ty.hasArchetype())
      return getPullback().mapTypeIntoContext(ty.mapTypeOutOfContext());
    return getPullback().mapTypeIntoContext(ty);
  }

  Optional<VectorSpace> getTangentSpace(CanType type) {
    return type->getAutoDiffAssociatedTangentSpace(
        LookUpConformanceInModule(getModule().getSwiftModule()));
  }

  /// Assuming the given type conforms to `Differentiable` after remapping,
  /// returns the associated tangent space type.
  SILType getRemappedTangentType(SILType type) {
    return SILType::getPrimitiveType(
        getTangentSpace(remapType(type).getASTType())->getCanonicalType(),
        type.getCategory());
  }

  /// Substitutes all replacement types of the given substitution map using the
  /// pullback function's substitution map.
  SubstitutionMap remapSubstitutionMap(SubstitutionMap substMap) {
    return substMap.subst(getPullback().getForwardingSubstitutionMap());
  }

  //--------------------------------------------------------------------------//
  // Managed value mapping
  //--------------------------------------------------------------------------//

  /// Returns true if the original value has a corresponding adjoint value.
  bool hasAdjointValue(SILBasicBlock *origBB, SILValue originalValue) const {
    assert(origBB->getParent() == &getOriginal());
    assert(originalValue->getType().isObject());
    return valueMap.count({origBB, originalValue});
  }

  /// Initializes an original value's corresponding adjoint value. It must not
  /// have an adjoint value before this function is called.
  void setAdjointValue(SILBasicBlock *origBB, SILValue originalValue,
                       AdjointValue adjointValue) {
    LLVM_DEBUG(getADDebugStream() << "Setting adjoint value for "
                                  << originalValue);
    assert(origBB->getParent() == &getOriginal());
    assert(originalValue->getType().isObject());
    assert(adjointValue.getType().isObject());
    assert(originalValue->getFunction() == &getOriginal());
    // The adjoint value must be in the tangent space.
    assert(adjointValue.getType() ==
               getRemappedTangentType(originalValue->getType()));
    auto insertion = valueMap.try_emplace({origBB, originalValue},
                                          adjointValue);
    LLVM_DEBUG(getADDebugStream()
                   << "The new adjoint value, replacing the existing one, is: "
                   << insertion.first->getSecond());
    if (!insertion.second)
      insertion.first->getSecond() = adjointValue;
  }

  /// Get the adjoint for an original value. The given value must be in the
  /// original function.
  ///
  /// This method first tries to find an entry in `adjointMap`. If an adjoint
  /// doesn't exist, create a zero adjoint.
  AdjointValue getAdjointValue(SILBasicBlock *origBB, SILValue originalValue) {
    assert(origBB->getParent() == &getOriginal());
    assert(originalValue->getType().isObject());
    assert(originalValue->getFunction() == &getOriginal());
    auto insertion = valueMap.try_emplace(
        {origBB, originalValue}, makeZeroAdjointValue(
            getRemappedTangentType(originalValue->getType())));
    auto it = insertion.first;
    return it->getSecond();
  }

  /// Add an adjoint value for the given original value.
  void addAdjointValue(SILBasicBlock *origBB, SILValue originalValue,
                       AdjointValue newAdjointValue, SILLocation loc) {
    assert(origBB->getParent() == &getOriginal());
    assert(originalValue->getType().isObject());
    assert(newAdjointValue.getType().isObject());
    assert(originalValue->getFunction() == &getOriginal());
    LLVM_DEBUG(getADDebugStream() << "Adding adjoint value for "
                                  << originalValue);
    // The adjoint value must be in the tangent space.
    assert(newAdjointValue.getType() ==
               getRemappedTangentType(originalValue->getType()));
    auto insertion =
        valueMap.try_emplace({origBB, originalValue}, newAdjointValue);
    auto inserted = insertion.second;
    if (inserted)
      return;
    // If adjoint already exists, accumulate the adjoint onto the existing
    // adjoint.
    auto it = insertion.first;
    auto existingValue = it->getSecond();
    valueMap.erase(it);
    auto adjVal = accumulateAdjointsDirect(existingValue, newAdjointValue, loc);
    setAdjointValue(origBB, originalValue, adjVal);
  }

  /// Get the pullback block argument corresponding to the given original block
  /// and active value.
  SILArgument *getActiveValuePullbackBlockArgument(SILBasicBlock *origBB,
                                                   SILValue activeValue) {
    assert(origBB->getParent() == &getOriginal());
    auto pullbackBBArg =
        activeValuePullbackBBArgumentMap[{origBB, activeValue}];
    assert(pullbackBBArg);
    assert(pullbackBBArg->getParent() == getPullbackBlock(origBB));
    return pullbackBBArg;
  }

  //--------------------------------------------------------------------------//
  // Buffer mapping
  //--------------------------------------------------------------------------//

  void setAdjointBuffer(SILBasicBlock *origBB,
                        SILValue originalBuffer,
                        SILValue adjointBuffer) {
    assert(originalBuffer->getType().isAddress());
    auto insertion =
        bufferMap.try_emplace({origBB, originalBuffer}, adjointBuffer);
    assert(insertion.second); (void)insertion;
  }

  SILValue getAdjointProjection(SILBasicBlock *origBB,
                                SILValue originalProjection) {
    // Handle `struct_element_addr`.
    if (auto *seai = dyn_cast<StructElementAddrInst>(originalProjection)) {
      assert(!seai->getField()->getAttrs().hasAttribute<NoDerivativeAttr>() &&
             "`@noDerivative` struct projections should never be active");
      auto adjSource = getAdjointBuffer(origBB, seai->getOperand());
      auto *tangentVectorDecl =
          adjSource->getType().getStructOrBoundGenericStruct();
      auto tanFieldLookup =
          tangentVectorDecl->lookupDirect(seai->getField()->getName());
      assert(tanFieldLookup.size() == 1);
      auto *tanField = cast<VarDecl>(tanFieldLookup.front());
      return builder.createStructElementAddr(
          seai->getLoc(), adjSource, tanField);
    }
    // Handle `tuple_element_addr`.
    if (auto *teai = dyn_cast<TupleElementAddrInst>(originalProjection)) {
      auto source = teai->getOperand();
      auto adjSource = getAdjointBuffer(origBB, source);
      if (!adjSource->getType().is<TupleType>())
        return adjSource;
      auto origTupleTy = source->getType().castTo<TupleType>();
      unsigned adjIndex = 0;
      for (unsigned i : range(teai->getFieldNo())) {
        if (getTangentSpace(
                origTupleTy->getElement(i).getType()->getCanonicalType()))
          ++adjIndex;
      }
      return builder.createTupleElementAddr(
          teai->getLoc(), adjSource, adjIndex);
    }
    // Handle `begin_access`.
    if (auto *bai = dyn_cast<BeginAccessInst>(originalProjection)) {
      auto adjBase = getAdjointBuffer(origBB, bai->getOperand());
      if (errorOccurred)
        return (bufferMap[{origBB, originalProjection}] = SILValue());
      // Return the base buffer's adjoint buffer.
      return adjBase;
    }
    return SILValue();
  }

  SILBasicBlock::iterator getNextFunctionLocalAllocationInsertionPoint() {
    // If there are no local allocations, insert at the pullback entry start.
    if (functionLocalAllocations.empty())
      return getPullback().getEntryBlock()->begin();
    // Otherwise, insert before the last local allocation. Inserting before
    // rather than after ensures that allocation and zero initialization
    // instructions are grouped together.
    auto lastLocalAlloc = functionLocalAllocations.back();
    return lastLocalAlloc->getDefiningInstruction()->getIterator();
  }

  SILValue &getAdjointBuffer(SILBasicBlock *origBB, SILValue originalBuffer) {
    assert(originalBuffer->getType().isAddress());
    assert(originalBuffer->getFunction() == &getOriginal());
    auto insertion = bufferMap.try_emplace({origBB, originalBuffer},
                                           SILValue());
    if (!insertion.second) // not inserted
      return insertion.first->getSecond();

    // If the original buffer is a projection, return a corresponding projection
    // into the adjoint buffer.
    if (auto adjProj = getAdjointProjection(origBB, originalBuffer))
      return (bufferMap[{origBB, originalBuffer}] = adjProj);

    // Set insertion point for local allocation builder: before the last local
    // allocation, or at the start of the pullback function's entry if no local
    // allocations exist yet.
    localAllocBuilder.setInsertionPoint(
        getPullback().getEntryBlock(),
        getNextFunctionLocalAllocationInsertionPoint());
    // Allocate local buffer and initialize to zero.
    auto bufObjectType = getRemappedTangentType(originalBuffer->getType());
    auto *newBuf = localAllocBuilder.createAllocStack(
        RegularLocation::getAutoGeneratedLocation(), bufObjectType);
    // Temporarily change global builder insertion point and emit zero into the
    // local buffer.
    auto insertionPoint = builder.getInsertionBB();
    builder.setInsertionPoint(
        localAllocBuilder.getInsertionBB(),
        localAllocBuilder.getInsertionPoint());
    emitZeroIndirect(bufObjectType.getASTType(), newBuf, newBuf->getLoc());
    builder.setInsertionPoint(insertionPoint);
    // Register the local buffer.
    functionLocalAllocations.push_back(newBuf);
    return (insertion.first->getSecond() = newBuf);
  }

  // Accumulates `rhsBufferAccess` into the adjoint buffer corresponding to
  // `originalBuffer`.
  void addToAdjointBuffer(SILBasicBlock *origBB, SILValue originalBuffer,
                          SILValue rhsBufferAccess, SILLocation loc) {
    assert(originalBuffer->getType().isAddress() &&
           rhsBufferAccess->getType().isAddress());
    assert(originalBuffer->getFunction() == &getOriginal());
    assert(rhsBufferAccess->getFunction() == &getPullback());
    auto adjointBuffer = getAdjointBuffer(origBB, originalBuffer);
    accumulateIndirect(adjointBuffer, rhsBufferAccess, loc);
  }

  //--------------------------------------------------------------------------//
  // CFG mapping
  //--------------------------------------------------------------------------//

  SILBasicBlock *getPullbackBlock(SILBasicBlock *originalBlock) {
    return pullbackBBMap.lookup(originalBlock);
  }

  SILBasicBlock *getPullbackTrampolineBlock(
      SILBasicBlock *originalBlock, SILBasicBlock *successorBlock) {
    return pullbackTrampolineBBMap.lookup({originalBlock, successorBlock});
  }

public:
  //--------------------------------------------------------------------------//
  // Entry point
  //--------------------------------------------------------------------------//

  /// Performs pullback generation on the empty pullback function. Returns true
  /// if any error occurs.
  bool run() {
    PrettyStackTraceSILFunction trace("generating pullback for",
                                      &getOriginal());
    auto &original = getOriginal();
    auto &pullback = getPullback();
    auto pbLoc = getPullback().getLocation();
    LLVM_DEBUG(getADDebugStream() << "Running PullbackEmitter on\n"
                                  << original);

    auto *pbGenEnv = getPullback().getGenericEnvironment();
    auto pbGenSig = pbGenEnv
        ? pbGenEnv->getGenericSignature()->getCanonicalSignature()
        : nullptr;
    Lowering::GenericContextScope genericContextScope(
        getContext().getTypeConverter(), pbGenSig);
    auto origExitIt = original.findReturnBB();
    assert(origExitIt != original.end() &&
           "Functions without returns must have been diagnosed");
    auto *origExit = &*origExitIt;

    SmallVector<SILValue, 8> origFormalResults;
    collectAllFormalResultsInTypeOrder(original, origFormalResults);
    auto origResult = origFormalResults[getIndices().source];

    // If original result is non-varied, it will always have a zero derivative.
    // Skip full pullback generation and simply emit zero derivatives for wrt
    // parameters.
    //
    // NOTE(TF-876): This shortcut is currently necessary for functions
    // returning non-varied result with >1 basic block where some basic blocks
    // have no dominated active values; control flow differentiation does not
    // handle this case. See TF-876 for context.
    if (!getActivityInfo().isVaried(origResult, getIndices().parameters)) {
      emitZeroDerivativesForNonvariedResult(origResult);
      return false;
    }

    // Get dominated active values in original blocks.
    // Adjoint values of dominated active values are passed as pullback block
    // arguments.
    DominanceOrder domOrder(original.getEntryBlock(), domInfo);
    // Keep track of visited values.
    SmallPtrSet<SILValue, 8> visited;
    while (auto *bb = domOrder.getNext()) {
      auto &bbActiveValues = activeValues[bb];
      // If the current block has an immediate dominator, append the immediate
      // dominator block's active values to the current block's active values.
      if (auto *domNode = domInfo->getNode(bb)->getIDom()) {
        auto &domBBActiveValues = activeValues[domNode->getBlock()];
        bbActiveValues.append(domBBActiveValues.begin(),
                              domBBActiveValues.end());
      }
      bool diagnosedActiveEnumValue = false;
      // Mark the activity of a value if it has not yet been visited.
      auto markValueActivity = [&](SILValue v) {
        if (visited.count(v))
          return;
        visited.insert(v);
        // Diagnose active enum values. Differentiation of enum values requires
        // special adjoint value handling and is not yet supported. Diagnose
        // only the first active enum value to prevent too many diagnostics.
        if (!diagnosedActiveEnumValue &&
            v->getType().getEnumOrBoundGenericEnum()) {
          getContext().emitNondifferentiabilityError(
              v, getInvoker(), diag::autodiff_enums_unsupported);
          errorOccurred = true;
          diagnosedActiveEnumValue = true;
        }
        // Skip address projections.
        // Address projections do not need their own adjoint buffers; they
        // become projections into their adjoint base buffer.
        if (Projection::isAddressProjection(v))
          return;
        bbActiveValues.push_back(v);
      };
      // Visit bb arguments and all instruction operands/results.
      for (auto *arg : bb->getArguments())
        if (getActivityInfo().isActive(arg, getIndices()))
          markValueActivity(arg);
      for (auto &inst : *bb) {
        for (auto op : inst.getOperandValues())
          if (getActivityInfo().isActive(op, getIndices()))
            markValueActivity(op);
        for (auto result : inst.getResults())
          if (getActivityInfo().isActive(result, getIndices()))
            markValueActivity(result);
      }
      domOrder.pushChildren(bb);
      if (errorOccurred)
        return true;
    }

    // Create pullback blocks and arguments, visiting original blocks in
    // post-order post-dominance order.
    SmallVector<SILBasicBlock *, 8> postOrderPostDomOrder;
    // Start from the root node, which may have a marker `nullptr` block if
    // there are multiple roots.
    PostOrderPostDominanceOrder postDomOrder(postDomInfo->getRootNode(),
                                             postOrderInfo, original.size());
    while (auto *origNode = postDomOrder.getNext()) {
      auto *origBB = origNode->getBlock();
      postDomOrder.pushChildren(origNode);
      // If node is the `nullptr` marker basic block, do not push it.
      if (!origBB)
        continue;
      postOrderPostDomOrder.push_back(origBB);
    }
    for (auto *origBB : postOrderPostDomOrder) {
      auto *pullbackBB = pullback.createBasicBlock();
      pullbackBBMap.insert({origBB, pullbackBB});
      auto pbStructLoweredType =
          remapType(getPullbackInfo().getLinearMapStructLoweredType(origBB));
      // If the BB is the original exit, then the pullback block that we just
      // created must be the pullback function's entry. For the pullback entry,
      // create entry arguments and continue to the next block.
      if (origBB == origExit) {
        assert(pullbackBB->isEntry());
        createEntryArguments(&pullback);
        auto *mainPullbackStruct = pullbackBB->getArguments().back();
        assert(mainPullbackStruct->getType() == pbStructLoweredType);
        pullbackStructArguments[origBB] = mainPullbackStruct;
        // Destructure the pullback struct to get the elements.
        builder.setInsertionPoint(pullbackBB);
        auto *dsi = builder.createDestructureStruct(pbLoc, mainPullbackStruct);
        initializePullbackStructElements(origBB, dsi->getResults());
        continue;
      }
      // Get all active values in the original block.
      // If the original block has no active values, continue.
      auto &bbActiveValues = activeValues[origBB];
      if (bbActiveValues.empty())
        continue;
      // Otherwise, if the original block has active values:
      // - For each active buffer in the original block, allocate a new local
      //   buffer in the pullback entry. (All adjoint buffers are allocated in
      //   the pullback entry and deallocated in the pullback exit.)
      // - For each active value in the original block, add adjoint value
      //   arguments to the pullback block.
      for (auto activeValue : bbActiveValues) {
        if (activeValue->getType().isAddress()) {
          // Allocate and zero initialize a new local buffer using
          // `getAdjointBuffer`.
          builder.setInsertionPoint(pullback.getEntryBlock());
          getAdjointBuffer(origBB, activeValue);
        } else {
          // Create and register pullback block argument for the active value.
          auto *pullbackArg = pullbackBB->createPhiArgument(
              getRemappedTangentType(activeValue->getType()),
              ValueOwnershipKind::Owned);
          activeValuePullbackBBArgumentMap[{origBB, activeValue}] = pullbackArg;
          recordTemporary(pullbackArg);
        }
      }
      // Add a pullback struct argument.
      auto *pbStructArg = pullbackBB->createPhiArgument(
          pbStructLoweredType, ValueOwnershipKind::Owned);
      pullbackStructArguments[origBB] = pbStructArg;
      // Destructure the pullback struct to get the elements.
      builder.setInsertionPoint(pullbackBB);
      auto *dsi = builder.createDestructureStruct(pbLoc, pbStructArg);
      initializePullbackStructElements(origBB, dsi->getResults());

      // - Create pullback trampoline blocks for each successor block of the
      //   original block. Pullback trampoline blocks only have a pullback
      //   struct argument. They branch from a pullback successor block to the
      //   pullback original block, passing adjoint values of active values.
      for (auto *succBB : origBB->getSuccessorBlocks()) {
        auto *pullbackTrampolineBB =
            pullback.createBasicBlockBefore(pullbackBB);
        pullbackTrampolineBBMap.insert({{origBB, succBB},
                                       pullbackTrampolineBB});
        // Get the enum element type (i.e. the pullback struct type). The enum
        // element type may be boxed if the enum is indirect.
        auto enumLoweredTy =
            getPullbackInfo().getBranchingTraceEnumLoweredType(succBB);
        auto *enumEltDecl =
            getPullbackInfo().lookUpBranchingTraceEnumElement(origBB, succBB);
        auto enumEltType = remapType(enumLoweredTy.getEnumElementType(
            enumEltDecl, getModule(), TypeExpansionContext::minimal()));
        pullbackTrampolineBB->createPhiArgument(enumEltType,
                                                ValueOwnershipKind::Owned);
      }
    }

    auto *pullbackEntry = pullback.getEntryBlock();
    // The pullback function has type (seed, exit_pbs) -> ([arg0], ..., [argn]).
    auto pbParamArgs = pullback.getArgumentsWithoutIndirectResults();
    assert(pbParamArgs.size() == 2);
    seed = pbParamArgs[0];

    // Assign adjoint for original result.
    builder.setInsertionPoint(
        pullbackEntry, getNextFunctionLocalAllocationInsertionPoint());
    if (seed->getType().isAddress()) {
      auto *seedBufCopy = builder.createAllocStack(pbLoc, seed->getType());
      builder.createCopyAddr(pbLoc, seed, seedBufCopy, IsNotTake,
                             IsInitialization);
      setAdjointBuffer(origExit, origResult, seedBufCopy);
      functionLocalAllocations.push_back(seedBufCopy);
      LLVM_DEBUG(getADDebugStream()
                 << "Assigned seed buffer " << seedBufCopy
                 << " as the adjoint of original indirect result "
                 << origResult);
    } else {
      setAdjointValue(origExit, origResult, makeConcreteAdjointValue(seed));
      LLVM_DEBUG(getADDebugStream()
                 << "Assigned seed " << *seed
                 << " as the adjoint of original result " << origResult);
    }

    // Visit original blocks blocks in post-order and perform differentiation
    // in corresponding pullback blocks. If errors occurred, back out.
    for (auto *bb : postOrderPostDomOrder) {
      visitSILBasicBlock(bb);
      if (errorOccurred)
        return true;
    }

    // Prepare and emit a `return` in the pullback exit block.
    auto *origEntry = getOriginal().getEntryBlock();
    auto *pbExit = getPullbackBlock(origEntry);
    builder.setInsertionPoint(pbExit);

    // This vector will contain all the materialized return elements.
    SmallVector<SILValue, 8> retElts;
    // This vector will contain all indirect parameter adjoint buffers.
    SmallVector<SILValue, 4> indParamAdjoints;

    auto origParams = getOriginal().getArgumentsWithoutIndirectResults();

    // Materializes the return element corresponding to the parameter
    // `parameterIndex` into the `retElts` vector.
    auto addRetElt = [&](unsigned parameterIndex) -> void {
      auto origParam = origParams[parameterIndex];
      if (origParam->getType().isObject()) {
        auto pbVal = getAdjointValue(origEntry, origParam);
        auto val = materializeAdjointDirect(pbVal, pbLoc);
        auto newVal = builder.emitCopyValueOperation(pbLoc, val);
        retElts.push_back(newVal);
      } else {
        auto adjBuf = getAdjointBuffer(origEntry, origParam);
        indParamAdjoints.push_back(adjBuf);
      }
    };
    // Collect differentiation parameter adjoints.
    for (auto i : getIndices().parameters->getIndices())
      addRetElt(i);

    // Copy them to adjoint indirect results.
    assert(indParamAdjoints.size() ==
               getPullback().getIndirectResults().size() &&
           "Indirect parameter adjoint count mismatch");
    for (auto pair : zip(indParamAdjoints,
                             getPullback().getIndirectResults())) {
      auto source = std::get<0>(pair);
      auto *dest = std::get<1>(pair);
      builder.createCopyAddr(pbLoc, source, dest, IsTake, IsInitialization);
      // Prevent source buffer from being deallocated, since the underlying
      // value is moved.
      destroyedLocalAllocations.insert(source);
    }

    // Emit cleanups for all local values.
    cleanUpTemporariesForBlock(pbExit, pbLoc);
    // Deallocate local allocations.
    for (auto alloc : functionLocalAllocations) {
      // Assert that local allocations have at least one use.
      // Buffers should not be allocated needlessly.
      assert(!alloc->use_empty());
      if (!destroyedLocalAllocations.count(alloc)) {
        builder.emitDestroyAddrAndFold(pbLoc, alloc);
        destroyedLocalAllocations.insert(alloc);
      }
      builder.createDeallocStack(pbLoc, alloc);
    }
    builder.createReturn(pbLoc, joinElements(retElts, builder, pbLoc));

#ifndef NDEBUG
    bool leakFound = false;
    // Ensure all temporaries have been cleaned up.
    for (auto &bb : pullback) {
      for (auto temp : blockTemporaries[&bb]) {
        if (blockTemporaries[&bb].count(temp)) {
          leakFound = true;
          getADDebugStream() << "Found leaked temporary:\n" << temp;
        }
      }
    }
    // Ensure all local allocations have been cleaned up.
    for (auto localAlloc : functionLocalAllocations) {
      if (!destroyedLocalAllocations.count(localAlloc)) {
        leakFound = true;
        getADDebugStream() << "Found leaked local buffer:\n" << localAlloc;
      }
    }
    assert(!leakFound && "Leaks found!");
#endif

    LLVM_DEBUG(getADDebugStream() << "Generated pullback for "
                                  << original.getName() << ":\n" << pullback);
    return errorOccurred;
  }

  /// If original result is non-varied, it will always have a zero derivative.
  /// Skip full pullback generation and simply emit zero derivatives for wrt
  /// parameters.
  void emitZeroDerivativesForNonvariedResult(SILValue origNonvariedResult) {
    auto &pullback = getPullback();
    auto pbLoc = getPullback().getLocation();
    /*
    // TODO(TF-788): Re-enable non-varied result warning.
    // Emit fixit if original non-varied result has a valid source location.
    auto startLoc = origNonvariedResult.getLoc().getStartSourceLoc();
    auto endLoc = origNonvariedResult.getLoc().getEndSourceLoc();
    if (startLoc.isValid() && endLoc.isValid()) {
      getContext().diagnose(startLoc, diag::autodiff_nonvaried_result_fixit)
          .fixItInsert(startLoc, "withoutDerivative(at:")
          .fixItInsertAfter(endLoc, ")");
    }
    */
    LLVM_DEBUG(getADDebugStream() << getOriginal().getName()
                                  << " has non-varied result, returning zero"
                                     " for all pullback results\n");
    auto *pullbackEntry = pullback.createBasicBlock();
    createEntryArguments(&pullback);
    builder.setInsertionPoint(pullbackEntry);
    // Destroy all owned arguments.
    for (auto *arg : pullbackEntry->getArguments())
      if (arg->getOwnershipKind() == ValueOwnershipKind::Owned)
        builder.emitDestroyOperation(pbLoc, arg);
    // Return zero for each result.
    SmallVector<SILValue, 4> directResults;
    auto indirectResultIt = pullback.getIndirectResults().begin();
    for (auto resultInfo : pullback.getLoweredFunctionType()->getResults()) {
      auto resultType = pullback.mapTypeIntoContext(
          resultInfo.getInterfaceType())->getCanonicalType();
      if (resultInfo.isFormalDirect())
        directResults.push_back(emitZeroDirect(resultType, pbLoc));
      else
        emitZeroIndirect(resultType, *indirectResultIt++, pbLoc);
    }
    builder.createReturn(pbLoc, joinElements(directResults, builder, pbLoc));
    LLVM_DEBUG(getADDebugStream() << "Generated pullback for "
                                  << getOriginal().getName() << ":\n"
                                  << pullback);
  }

  using TrampolineBlockSet = SmallPtrSet<SILBasicBlock *, 4>;

  /// Determine the pullback successor block for a given original block and one
  /// of its predecessors. When a trampoline block is necessary, emit code into
  /// the trampoline block to trampoline the original block's active value's
  /// adjoint values. A dense map `trampolineArgs` will be populated to keep
  /// track of which pullback successor blocks each active value's adjoint value
  /// is used, so that we can release those values in pullback successor blocks
  /// that are not using them.
  SILBasicBlock *buildPullbackSuccessor(
      SILBasicBlock *origBB, SILBasicBlock *origPredBB,
      SmallDenseMap<SILValue, TrampolineBlockSet> &pullbackTrampolineBlockMap) {
    // Get the pullback block and optional pullback trampoline block of the
    // predecessor block.
    auto *pullbackBB = getPullbackBlock(origPredBB);
    auto *pullbackTrampolineBB = getPullbackTrampolineBlock(origPredBB, origBB);
    // If the predecessor block does not have a corresponding pullback
    // trampoline block, then the pullback successor is the pullback block.
    if (!pullbackTrampolineBB)
      return pullbackBB;

    // Otherwise, the pullback successor is the pullback trampoline block,
    // which branches to the pullback block and propagates adjoint values of
    // active values.
    assert(pullbackTrampolineBB->getNumArguments() == 1);
    auto loc = origBB->getParent()->getLocation();
    SmallVector<SILValue, 8> trampolineArguments;
    // Propagate adjoint values/buffers of active values/buffers to
    // predecessor blocks.
    auto &predBBActiveValues = activeValues[origPredBB];
    for (auto activeValue : predBBActiveValues) {
      LLVM_DEBUG(getADDebugStream()
                 << "Propagating adjoint of active value " << activeValue
                 << " to predecessors' pullback blocks\n");
      if (activeValue->getType().isObject()) {
        auto activeValueAdj = getAdjointValue(origBB, activeValue);
        auto concreteActiveValueAdj =
            materializeAdjointDirect(activeValueAdj, loc);

        if (!pullbackTrampolineBlockMap.count(concreteActiveValueAdj)) {
          concreteActiveValueAdj =
              builder.emitCopyValueOperation(loc, concreteActiveValueAdj);
          setAdjointValue(origBB, activeValue,
                          makeConcreteAdjointValue(concreteActiveValueAdj));
        }
        auto insertion = pullbackTrampolineBlockMap.try_emplace(
            concreteActiveValueAdj, TrampolineBlockSet());
        auto &blockSet = insertion.first->getSecond();
        blockSet.insert(pullbackTrampolineBB);
        trampolineArguments.push_back(concreteActiveValueAdj);

        // If the pullback block does not yet have a registered adjoint
        // value for the active value, set the adjoint value to the
        // forwarded adjoint value argument.
        // TODO: Hoist this logic out of loop over predecessor blocks to
        // remove the `hasAdjointValue` check.
        if (!hasAdjointValue(origPredBB, activeValue)) {
          auto *pullbackBBArg =
              getActiveValuePullbackBlockArgument(origPredBB, activeValue);
          auto forwardedArgAdj = makeConcreteAdjointValue(pullbackBBArg);
          setAdjointValue(origPredBB, activeValue, forwardedArgAdj);
        }
      } else {
        // Propagate adjoint buffers using `copy_addr`.
        auto adjBuf = getAdjointBuffer(origBB, activeValue);
        auto predAdjBuf = getAdjointBuffer(origPredBB, activeValue);
        builder.createCopyAddr(
            loc, adjBuf, predAdjBuf, IsNotTake, IsNotInitialization);
      }
    }
    // Propagate pullback struct argument.
    SILBuilder pullbackTrampolineBBBuilder(pullbackTrampolineBB);
    auto *predPBStructVal = pullbackTrampolineBB->getArguments().front();
    auto boxType =
        dyn_cast<SILBoxType>(predPBStructVal->getType().getASTType());
    if (!boxType) {
      trampolineArguments.push_back(predPBStructVal);
    } else {
      auto *projectBox = pullbackTrampolineBBBuilder.createProjectBox(
          loc, predPBStructVal, /*index*/ 0);
      auto loaded = pullbackTrampolineBBBuilder.emitLoadValueOperation(
          loc, projectBox, LoadOwnershipQualifier::Copy);
      pullbackTrampolineBBBuilder.emitDestroyValueOperation(loc,
                                                            predPBStructVal);
      trampolineArguments.push_back(loaded);
    }
    // Branch from pullback trampoline block to pullback block.
    pullbackTrampolineBBBuilder.createBranch(loc, pullbackBB,
                                             trampolineArguments);
    return pullbackTrampolineBB;
  }

  /// Emit pullback code in the corresponding pullback block.
  void visitSILBasicBlock(SILBasicBlock *bb) {
    auto pbLoc = getPullback().getLocation();
    // Get the corresponding pullback basic block.
    auto *pbBB = getPullbackBlock(bb);
    builder.setInsertionPoint(pbBB);

    LLVM_DEBUG({
      auto &s = getADDebugStream()
          << "Original bb" + std::to_string(bb->getDebugID())
          << ": To differentiate or not to differentiate?\n";
      for (auto &inst : llvm::reverse(*bb)) {
        s << (getPullbackInfo().shouldDifferentiateInstruction(&inst)
                  ? "[x] " : "[ ] ")
          << inst;
      }
    });

    // Visit each instruction in reverse order.
    for (auto &inst : llvm::reverse(*bb)) {
      if (!getPullbackInfo().shouldDifferentiateInstruction(&inst))
        continue;
      // Differentiate instruction.
      visit(&inst);
      if (errorOccurred)
        return;
    }

    // Emit a branching terminator for the block.
    // If the original block is the original entry, then the pullback block is
    // the pullback exit. This is handled specially in `PullbackEmitter::run()`,
    // so we leave the block non-terminated.
    if (bb->isEntry())
      return;

    // Otherwise, add a `switch_enum` terminator for non-exit
    // pullback blocks.
    // 1. Get the pullback struct pullback block argument.
    // 2. Extract the predecessor enum value from the pullback struct value.
    auto *predEnum = getPullbackInfo().getBranchingTraceDecl(bb);
    auto *predEnumField =
        getPullbackInfo().lookUpLinearMapStructEnumField(bb);
    auto predEnumVal = getPullbackStructElement(bb, predEnumField);

    // Propagate adjoint values from active basic block arguments to
    // incoming values (predecessor terminator operands).
    for (auto *bbArg : bb->getArguments()) {
      if (!getActivityInfo().isActive(bbArg, getIndices()))
        continue;
      // Get predecessor terminator operands.
      SmallVector<std::pair<SILBasicBlock *, SILValue>, 4> incomingValues;
      bbArg->getSingleTerminatorOperands(incomingValues);
      // Materialize adjoint value of active basic block argument, create a
      // copy, and set copy as adjoint value of incoming values.
      auto bbArgAdj = getAdjointValue(bb, bbArg);
      auto concreteBBArgAdj = materializeAdjoint(bbArgAdj, pbLoc);
      auto concreteBBArgAdjCopy =
          builder.emitCopyValueOperation(pbLoc, concreteBBArgAdj);
      for (auto pair : incomingValues) {
        auto *predBB = std::get<0>(pair);
        auto incomingValue = std::get<1>(pair);
        blockTemporaries[getPullbackBlock(predBB)].insert(concreteBBArgAdjCopy);
        setAdjointValue(predBB, incomingValue,
                        makeConcreteAdjointValue(concreteBBArgAdjCopy));
      }
    }

    // 3. Build the pullback successor cases for the `switch_enum`
    //    instruction. The pullback successors correspond to the predecessors
    //    of the current block.
    SmallVector<std::pair<EnumElementDecl *, SILBasicBlock *>, 4>
        pullbackSuccessorCases;
    // A map from active values' adjoint values to the trampoline blocks that
    // are using them.
    SmallDenseMap<SILValue, TrampolineBlockSet> pullbackTrampolineBlockMap;
    SmallVector<SILBasicBlock *, 8> pullbackSuccBBs;
    for (auto *predBB : bb->getPredecessorBlocks()) {
      auto *pullbackSuccBB = buildPullbackSuccessor(bb, predBB,
                                                    pullbackTrampolineBlockMap);
      pullbackSuccBBs.push_back(pullbackSuccBB);
      auto *enumEltDecl =
          getPullbackInfo().lookUpBranchingTraceEnumElement(predBB, bb);
      pullbackSuccessorCases.push_back({enumEltDecl, pullbackSuccBB});
    }
    // Values are trampolined by only a subset of pullback successor blocks.
    // Other successors blocks should destroy the value to balance the reference
    // count.
    for (auto pair : pullbackTrampolineBlockMap) {
      auto value = pair.getFirst();
      // The set of trampoline BBs that are users of `value`.
      auto &userTrampolineBBSet = pair.getSecond();
      // For each pullback successor block that does not trampoline the value,
      // release the value.
      for (auto *pullbackSuccBB : pullbackSuccBBs) {
        if (userTrampolineBBSet.count(pullbackSuccBB))
          continue;
        SILBuilder builder(pullbackSuccBB->begin());
        builder.emitDestroyValueOperation(pbLoc, value);
      }
    }
    // Emit cleanups for all block-local temporaries.
    cleanUpTemporariesForBlock(pbBB, pbLoc);
    // Branch to pullback successor blocks.
    assert(pullbackSuccessorCases.size() == predEnum->getNumElements());
    builder.createSwitchEnum(
        pbLoc, predEnumVal, /*DefaultBB*/ nullptr, pullbackSuccessorCases);
  }

  void visit(SILInstruction *inst) {
    if (errorOccurred)
      return;

    LLVM_DEBUG(getADDebugStream()
               << "PullbackEmitter visited:\n[ORIG]" << *inst);
#ifndef NDEBUG
    auto beforeInsertion = std::prev(builder.getInsertionPoint());
#endif
    SILInstructionVisitor::visit(inst);
    LLVM_DEBUG({
      auto &s = llvm::dbgs() << "[ADJ] Emitted in pullback:\n";
      auto afterInsertion = builder.getInsertionPoint();
      for (auto it = ++beforeInsertion; it != afterInsertion; ++it)
        s << *it;
    });
  }

  void visitSILInstruction(SILInstruction *inst) {
    LLVM_DEBUG(getADDebugStream()
               << "Unhandled instruction in PullbackEmitter: " << *inst);
    getContext().emitNondifferentiabilityError(inst, getInvoker(),
        diag::autodiff_expression_not_differentiable_note);
    errorOccurred = true;
  }

  /// Given an array adjoint value, array element index and element tangent
  /// type, returns an `alloc_stack` containing the array element adjoint value.
  AllocStackInst *getArrayAdjointElementBuffer(SILValue arrayAdjoint,
                                               int eltIndex, SILType eltTanType,
                                               SILLocation loc) {
    // Get `function_ref` and generic signature of
    // `Array.TangentVector.subscript.getter`.
    auto arrayTanType = arrayAdjoint->getType().getASTType();
    auto *arrayTanStructDecl = arrayTanType->getStructOrBoundGenericStruct();
    auto subscriptLookup =
        arrayTanStructDecl->lookupDirect(DeclBaseName::createSubscript());
    auto *subscriptDecl = cast<SubscriptDecl>(subscriptLookup.front());
    auto *subscriptGetterDecl = subscriptDecl->getAccessor(AccessorKind::Get);
    assert(subscriptGetterDecl && "No `Array.TangentVector.subscript` getter");
    SILOptFunctionBuilder fb(getContext().getTransform());
    auto *subscriptGetterFn = fb.getOrCreateFunction(
        loc, SILDeclRef(subscriptGetterDecl), NotForDefinition);
    // %subscript_fn = function_ref @Array.TangentVector<T>.subscript.getter
    auto *subscriptFnRef = builder.createFunctionRef(loc, subscriptGetterFn);
    auto subscriptFnGenSig =
        subscriptGetterFn->getLoweredFunctionType()->getSubstGenericSignature();
    // Apply `Array.TangentVector.subscript.getter` to get array element adjoint
    // buffer.
    auto &ctx = builder.getASTContext();
    auto eltTanAstType = eltTanType.getASTType();
    // %index_literal = integer_literal $Builtin.Int64, <index>
    auto *eltIndexLiteral = builder.createIntegerLiteral(
        loc, SILType::getBuiltinIntegerType(64, ctx), eltIndex);
    auto intType = SILType::getPrimitiveObjectType(
        ctx.getIntDecl()->getDeclaredType()->getCanonicalType());
    // %index_int = struct $Int (%index_literal)
    auto *eltIndexInt = builder.createStruct(loc, intType, {eltIndexLiteral});
    auto *swiftModule = getModule().getSwiftModule();
    auto *diffProto = ctx.getProtocol(KnownProtocolKind::Differentiable);
    auto diffConf = swiftModule->lookupConformance(eltTanAstType, diffProto);
    assert(!diffConf.isInvalid() && "Missing conformance to `Differentiable`");
    auto *addArithProto =
        ctx.getProtocol(KnownProtocolKind::AdditiveArithmetic);
    auto addArithConf =
        swiftModule->lookupConformance(eltTanAstType, addArithProto);
    assert(!addArithConf.isInvalid() &&
           "Missing conformance to `AdditiveArithmetic`");
    auto subMap = SubstitutionMap::get(subscriptFnGenSig, {eltTanAstType},
                                       {addArithConf, diffConf});
    // %elt_adj = alloc_stack $T.TangentVector
    auto *eltAdjBuffer = builder.createAllocStack(loc, eltTanType);
    // apply %subscript_fn<T.TangentVector>(%elt_adj, %index_int, %array_adj)
    builder.createApply(loc, subscriptFnRef, subMap,
                        {eltAdjBuffer, eltIndexInt, arrayAdjoint});
    return eltAdjBuffer;
  }

  /// Accumulate array element adjoint buffer into `store` source.
  void accumulateArrayElementAdjointDirect(StoreInst *si,
                                           AllocStackInst *eltAdjBuffer) {
    auto eltAdjValue = builder.emitLoadValueOperation(
        si->getLoc(), eltAdjBuffer, LoadOwnershipQualifier::Take);
    recordTemporary(eltAdjValue);
    addAdjointValue(si->getParent(), si->getSrc(),
                    makeConcreteAdjointValue(eltAdjValue), si->getLoc());
    builder.createDeallocStack(si->getLoc(), eltAdjBuffer);
  }

  /// Accumulate array element adjoint buffer into `copy_addr` source.
  void accumulateArrayElementAdjointIndirect(CopyAddrInst *cai,
                                             AllocStackInst *eltAdjBuffer) {
    addToAdjointBuffer(cai->getParent(), cai->getSrc(), eltAdjBuffer,
                       cai->getLoc());
    builder.emitDestroyAddrAndFold(cai->getLoc(), eltAdjBuffer);
    builder.createDeallocStack(cai->getLoc(), eltAdjBuffer);
  }

  /// Given a `store` or `copy_addr` instruction whose destination is an element
  /// address from an `array.uninitialized_intrinsic` application, accumulate
  /// array element adjoint into the source's adjoint.
  void accumulateArrayElementAdjoint(SILInstruction *inst) {
    assert(isa<StoreInst>(inst) || isa<CopyAddrInst>(inst) &&
           "Expected only `store` or `copy_addr` to "
           "`array.uninitialized_intrinsic` result address");
    LLVM_DEBUG(getADDebugStream()
               << "Visiting array initialization element store instruction:\n"
               << *inst);
    // Get the source and destination of the `store` or `copy_addr`.
    SILValue src;
    SILValue dest;
    if (auto *si = dyn_cast<StoreInst>(inst)) {
      src = si->getSrc();
      dest = si->getDest();
    } else if (auto *cai = dyn_cast<CopyAddrInst>(inst)) {
      src = cai->getSrc();
      dest = cai->getDest();
    }
    // Get the array element index of the result address.
    int eltIndex = 0;
    if (auto *iai = dyn_cast<IndexAddrInst>(dest->getDefiningInstruction())) {
      auto *ili = cast<IntegerLiteralInst>(iai->getIndex());
      eltIndex = ili->getValue().getLimitedValue();
    } else {
      assert(isa<PointerToAddressInst>(dest->getDefiningInstruction()));
    }
    // Get the array adjoint value.
    SILValue arrayAdjoint;
    auto *ai = getAllocateUninitializedArrayIntrinsicElementAddress(dest);
    assert(ai && "Expected `array.uninitialized_intrinsic` application");
    for (auto use : ai->getUses()) {
      auto *dti = dyn_cast<DestructureTupleInst>(use->getUser());
      if (!dti)
        continue;
      // The first `destructure_tuple` result is the `Array` value.
      auto arrayValue = dti->getResult(0);
      arrayAdjoint =
          getAdjointValue(ai->getParent(), arrayValue).getConcreteValue();
    }
    assert(arrayAdjoint && "Array does not have adjoint value");
    // Apply `Array.TangentVector.subscript` to get array element adjoint value.
    auto eltTanType = getRemappedTangentType(src->getType());
    auto *eltAdjBuffer = getArrayAdjointElementBuffer(arrayAdjoint, eltIndex,
                                                      eltTanType, ai->getLoc());
    // Accumulate array element adjoint into source's adjoint.
    if (auto *si = dyn_cast<StoreInst>(inst)) {
      accumulateArrayElementAdjointDirect(si, eltAdjBuffer);
    } else if (auto *cai = dyn_cast<CopyAddrInst>(inst)) {
      accumulateArrayElementAdjointIndirect(cai, eltAdjBuffer);
    }
  }

  void visitApplyInst(ApplyInst *ai) {
    assert(getPullbackInfo().shouldDifferentiateApplyInst(ai));
    // Skip `array.uninitialized_intrinsic` intrinsic applications, which have
    // special `store` and `copy_addr` support.
    if (isArrayLiteralIntrinsic(ai))
      return;
    // Replace a call to a function with a call to its pullback.
    auto &nestedApplyInfo = getContext().getNestedApplyInfo();
    auto applyInfoLookup = nestedApplyInfo.find(ai);
    // If no `NestedApplyInfo` was found, then this task doesn't need to be
    // differentiated.
    if (applyInfoLookup == nestedApplyInfo.end()) {
      // Must not be active.
      assert(!getActivityInfo().isActive(ai, getIndices()));
      return;
    }
    auto applyInfo = applyInfoLookup->getSecond();

    // Get the pullback.
    auto *field = getPullbackInfo().lookUpLinearMapDecl(ai);
    assert(field);
    auto loc = ai->getLoc();
    auto pullback = getPullbackStructElement(ai->getParent(), field);

    // Get the original result of the `apply` instruction.
    SmallVector<SILValue, 8> args;
    SmallVector<SILValue, 8> origDirectResults;
    forEachApplyDirectResult(ai, [&](SILValue directResult) {
      origDirectResults.push_back(directResult);
    });
    SmallVector<SILValue, 8> origAllResults;
    collectAllActualResultsInTypeOrder(ai, origDirectResults, origAllResults);
    assert(applyInfo.indices.source < origAllResults.size());
    auto origResult = origAllResults[applyInfo.indices.source];
    assert(origResult);
    auto origNumIndRes = ai->getNumIndirectResults();

    auto pullbackType =
        remapType(pullback->getType()).castTo<SILFunctionType>();

    // Get the seed (i.e. adjoint value of the original result).
    SILValue seed;
    auto *bb = ai->getParent();
    if (origResult->getType().isObject()) {
      // Otherwise, materialize adjoint value of `ai`.
      seed = materializeAdjoint(getAdjointValue(bb, origResult), loc);
    } else {
      seed = getAdjointBuffer(bb, origResult);
    }

    // Create allocations for pullback indirect results.
    SmallVector<AllocStackInst *, 4> pullbackIndirectResults;
    auto actualPullbackType = applyInfo.originalPullbackType
        ? *applyInfo.originalPullbackType
        : pullbackType;
    for (auto indRes : actualPullbackType->getIndirectFormalResults()) {
      auto *alloc = builder.createAllocStack(
          loc, remapType(indRes.getSILStorageInterfaceType()));
      pullbackIndirectResults.push_back(alloc);
      args.push_back(alloc);
    }

    // If callee pullback was reabstracted in VJP, reabstract callee pullback.
    if (applyInfo.originalPullbackType) {
      SILOptFunctionBuilder fb(getContext().getTransform());
      auto *thunk = getOrCreateReabstractionThunk(
          fb, getContext().getModule(), loc, &getPullback(),
          pullbackType, *applyInfo.originalPullbackType);
      auto *thunkRef = builder.createFunctionRef(loc, thunk);
      pullback = builder.createPartialApply(
          loc, thunkRef,
          remapSubstitutionMap(thunk->getForwardingSubstitutionMap()),
          {pullback}, pullbackType->getCalleeConvention());
    }
    args.push_back(seed);

    // Call the callee pullback.
    auto *pullbackCall = builder.createApply(
        loc, pullback, SubstitutionMap(), args, /*isNonThrowing*/ false);
    builder.emitDestroyValueOperation(loc, pullback);

    // Extract all results from `pullbackCall`.
    SmallVector<SILValue, 8> dirResults;
    extractAllElements(pullbackCall, builder, dirResults);
    // Get all results in type-defined order.
    SmallVector<SILValue, 8> allResults;
    collectAllActualResultsInTypeOrder(pullbackCall, dirResults, allResults);
    LLVM_DEBUG({
      auto &s = getADDebugStream();
      s << "All results of the nested pullback call:\n";
      llvm::for_each(allResults, [&](SILValue v) { s << v; });
    });

    // Accumulate adjoints for original differentiation parameters.
    auto allResultsIt = allResults.begin();
    for (unsigned i : applyInfo.indices.parameters->getIndices()) {
      auto origArg = ai->getArgument(origNumIndRes + i);
      auto tan = *allResultsIt++;
      if (tan->getType().isAddress()) {
        addToAdjointBuffer(bb, origArg, tan, loc);
      } else {
        if (origArg->getType().isAddress()) {
          auto *tmpBuf = builder.createAllocStack(loc, tan->getType());
          builder.emitStoreValueOperation(loc, tan, tmpBuf,
                                          StoreOwnershipQualifier::Init);
          addToAdjointBuffer(bb, origArg, tmpBuf, loc);
          builder.emitDestroyAddrAndFold(loc, tmpBuf);
          builder.createDeallocStack(loc, tmpBuf);
        } else {
          recordTemporary(tan);
          addAdjointValue(bb, origArg, makeConcreteAdjointValue(tan), loc);
        }
      }
    }
    // Destroy unused pullback direct results. Needed for pullback results from
    // VJPs extracted from `@differentiable` function callees, where the
    // `@differentiable` function's differentiation parameter indices are a
    // superset of the active `apply` parameter indices.
    while (allResultsIt != allResults.end()) {
      auto unusedPullbackDirectResult = *allResultsIt++;
      if (unusedPullbackDirectResult->getType().isAddress())
        continue;
      builder.emitDestroyValueOperation(loc, unusedPullbackDirectResult);
    }
    // Destroy and deallocate pullback indirect results.
    for (auto *alloc : llvm::reverse(pullbackIndirectResults)) {
      builder.emitDestroyAddrAndFold(loc, alloc);
      builder.createDeallocStack(loc, alloc);
    }
  }

  /// Handle `struct` instruction.
  ///   Original: y = struct (x0, x1, x2, ...)
  ///    Adjoint: adj[x0] += struct_extract adj[y], #x0
  ///             adj[x1] += struct_extract adj[y], #x1
  ///             adj[x2] += struct_extract adj[y], #x2
  ///             ...
  void visitStructInst(StructInst *si) {
    auto *bb = si->getParent();
    auto loc = si->getLoc();
    auto *structDecl = si->getStructDecl();
    auto av = getAdjointValue(bb, si);
    switch (av.getKind()) {
    case AdjointValueKind::Zero:
      for (auto *field : structDecl->getStoredProperties()) {
        auto fv = si->getFieldValue(field);
        addAdjointValue(bb, fv,
            makeZeroAdjointValue(getRemappedTangentType(fv->getType())), loc);
      }
      break;
    case AdjointValueKind::Concrete: {
      auto adjStruct = materializeAdjointDirect(std::move(av), loc);
      // Find the struct `TangentVector` type.
      auto structTy = remapType(si->getType()).getASTType();
      auto tangentVectorTy =
          getTangentSpace(structTy)->getType()->getCanonicalType();
      assert(!getModule().Types.getTypeLowering(
                 tangentVectorTy, TypeExpansionContext::minimal())
                     .isAddressOnly());
      auto *tangentVectorDecl =
          tangentVectorTy->getStructOrBoundGenericStruct();
      assert(tangentVectorDecl);

      auto *dti = builder.createDestructureStruct(si->getLoc(), adjStruct);
      // Accumulate adjoints for the fields of the `struct` operand.
      unsigned fieldIndex = 0;
      for (auto it = structDecl->getStoredProperties().begin();
           it != structDecl->getStoredProperties().end(); ++it, ++fieldIndex) {
        VarDecl *field = *it;
        if (field->getAttrs().hasAttribute<NoDerivativeAttr>())
          continue;
        // Find the corresponding field in the tangent space.
        VarDecl *tanField = nullptr;
        if (tangentVectorDecl == structDecl)
          tanField = field;
        // Otherwise, look up the field by name.
        else {
          auto tanFieldLookup =
          tangentVectorDecl->lookupDirect(field->getName());
          if (tanFieldLookup.empty()) {
            getContext().emitNondifferentiabilityError(
                si, getInvoker(),
                diag::autodiff_stored_property_no_corresponding_tangent,
                tangentVectorDecl->getNameStr(), field->getNameStr());
            errorOccurred = true;
            return;
          }
          tanField = cast<VarDecl>(tanFieldLookup.front());
        }
        assert(tanField);
        auto tanElt = dti->getResult(fieldIndex);
        addAdjointValue(
            bb, si->getFieldValue(field),
            makeConcreteAdjointValue(tanElt), si->getLoc());
      }
      break;
    }
    case AdjointValueKind::Aggregate: {
      // Note: All user-called initializations go through the calls to the
      // initializer, and synthesized initializers only have one level of struct
      // formation which will not result into any aggregate adjoint valeus.
      llvm_unreachable("Aggregate adjoint values should not occur for `struct` "
                       "instructions");
    }
    }
  }

  /// Handle `struct_extract` instruction.
  ///   Original: y = struct_extract x, #field
  ///    Adjoint: adj[x] += struct (0, ..., #field': adj[y], ..., 0)
  ///                                       ^~~~~~~
  ///                     field in tangent space corresponding to #field
  void visitStructExtractInst(StructExtractInst *sei) {
    assert(!sei->getField()->getAttrs().hasAttribute<NoDerivativeAttr>() &&
           "`struct_extract` with `@noDerivative` field should not be "
           "differentiated; activity analysis should not marked as varied");
    auto *bb = sei->getParent();
    auto structTy = remapType(sei->getOperand()->getType()).getASTType();
    auto tangentVectorTy =
        getTangentSpace(structTy)->getType()->getCanonicalType();
    assert(!getModule().Types.getTypeLowering(
               tangentVectorTy, TypeExpansionContext::minimal())
                   .isAddressOnly());
    auto tangentVectorSILTy =
        SILType::getPrimitiveObjectType(tangentVectorTy);
    auto *tangentVectorDecl =
        tangentVectorTy->getStructOrBoundGenericStruct();
    assert(tangentVectorDecl);
    // Find the corresponding field in the tangent space.
    VarDecl *tanField = nullptr;
    // If the tangent space is the original struct, then field is the same.
    if (tangentVectorDecl == sei->getStructDecl())
      tanField = sei->getField();
    // Otherwise, look up the field by name.
    else {
      auto tanFieldLookup =
          tangentVectorDecl->lookupDirect(sei->getField()->getName());
      if (tanFieldLookup.empty()) {
        getContext().emitNondifferentiabilityError(
            sei, getInvoker(),
            diag::autodiff_stored_property_no_corresponding_tangent,
            sei->getStructDecl()->getNameStr(),
            sei->getField()->getNameStr());
        errorOccurred = true;
        return;
      }
      tanField = cast<VarDecl>(tanFieldLookup.front());
    }
    // Accumulate adjoint for the `struct_extract` operand.
    auto av = getAdjointValue(bb, sei);
    switch (av.getKind()) {
    case AdjointValueKind::Zero:
      addAdjointValue(bb, sei->getOperand(),
                      makeZeroAdjointValue(tangentVectorSILTy), sei->getLoc());
      break;
    case AdjointValueKind::Concrete:
    case AdjointValueKind::Aggregate: {
      SmallVector<AdjointValue, 8> eltVals;
      for (auto *field : tangentVectorDecl->getStoredProperties()) {
        if (field == tanField) {
          eltVals.push_back(av);
        } else {
          auto substMap = tangentVectorTy->getMemberSubstitutionMap(
              field->getModuleContext(), field);
          auto fieldTy = field->getType().subst(substMap);
          auto fieldSILTy =
              getContext().getTypeConverter().getLoweredType(
                  fieldTy, TypeExpansionContext::minimal());
          assert(fieldSILTy.isObject());
          eltVals.push_back(makeZeroAdjointValue(fieldSILTy));
        }
      }
      addAdjointValue(bb, sei->getOperand(),
                      makeAggregateAdjointValue(tangentVectorSILTy, eltVals),
                      sei->getLoc());
    }
    }
  }

  /// Handle `tuple` instruction.
  ///   Original: y = tuple (x0, x1, x2, ...)
  ///    Adjoint: (adj[x0], adj[x1], adj[x2], ...) += destructure_tuple adj[y]
  ///                                         ^~~
  ///                         excluding non-differentiable elements
  void visitTupleInst(TupleInst *ti) {
    auto *bb = ti->getParent();
    auto av = getAdjointValue(bb, ti);
    switch (av.getKind()) {
    case AdjointValueKind::Zero:
      for (auto elt : ti->getElements()) {
        if (!getTangentSpace(elt->getType().getASTType()))
          continue;
        addAdjointValue(
            bb, elt,
            makeZeroAdjointValue(getRemappedTangentType(elt->getType())),
            ti->getLoc());
      }
      break;
    case AdjointValueKind::Concrete: {
      auto adjVal = av.getConcreteValue();
      unsigned adjIdx = 0;
      auto adjValCopy = builder.emitCopyValueOperation(ti->getLoc(), adjVal);
      SmallVector<SILValue, 4> adjElts;
      if (!adjVal->getType().getAs<TupleType>()) {
        recordTemporary(adjValCopy);
        adjElts.push_back(adjValCopy);
      } else {
        auto *dti = builder.createDestructureTuple(ti->getLoc(), adjValCopy);
        for (auto adjElt : dti->getResults())
          recordTemporary(adjElt);
        adjElts.append(dti->getResults().begin(), dti->getResults().end());
      }
      // Accumulate adjoints for `tuple` operands, skipping the
      // non-differentiable ones.
      for (auto i : range(ti->getNumOperands())) {
        if (!getTangentSpace(ti->getOperand(i)->getType().getASTType()))
          continue;
        auto adjElt = adjElts[adjIdx++];
        addAdjointValue(bb, ti->getOperand(i), makeConcreteAdjointValue(adjElt),
                        ti->getLoc());
      }
      break;
    }
    case AdjointValueKind::Aggregate:
      unsigned adjIdx = 0;
      for (auto i : range(ti->getElements().size())) {
        if (!getTangentSpace(ti->getElement(i)->getType().getASTType()))
          continue;
        addAdjointValue(bb, ti->getElement(i), av.getAggregateElement(adjIdx++),
                        ti->getLoc());
      }
      break;
    }
  }

  /// Handle `tuple_extract` instruction.
  ///   Original: y = tuple_extract x, <n>
  ///    Adjoint: adj[x] += tuple (0, 0, ..., adj[y], ..., 0, 0)
  ///                                         ^~~~~~
  ///                            n'-th element, where n' is tuple tangent space
  ///                            index corresponding to n
  void visitTupleExtractInst(TupleExtractInst *tei) {
    auto *bb = tei->getParent();
    auto tupleTanTy = getRemappedTangentType(tei->getOperand()->getType());
    auto av = getAdjointValue(bb, tei);
    switch (av.getKind()) {
    case AdjointValueKind::Zero:
      addAdjointValue(bb, tei->getOperand(), makeZeroAdjointValue(tupleTanTy),
                      tei->getLoc());
      break;
    case AdjointValueKind::Aggregate:
    case AdjointValueKind::Concrete: {
      auto tupleTy = tei->getTupleType();
      auto tupleTanTupleTy = tupleTanTy.getAs<TupleType>();
      if (!tupleTanTupleTy) {
        addAdjointValue(bb, tei->getOperand(), av, tei->getLoc());
        break;
      }
      SmallVector<AdjointValue, 8> elements;
      unsigned adjIdx = 0;
      for (unsigned i : range(tupleTy->getNumElements())) {
        if (!getTangentSpace(
                tupleTy->getElement(i).getType()->getCanonicalType()))
          continue;
        if (tei->getFieldNo() == i)
          elements.push_back(av);
        else
          elements.push_back(makeZeroAdjointValue(
              getRemappedTangentType(SILType::getPrimitiveObjectType(
                  tupleTanTupleTy->getElementType(adjIdx++)
                      ->getCanonicalType()))));
      }
      if (elements.size() == 1) {
        addAdjointValue(bb, tei->getOperand(), elements.front(), tei->getLoc());
        break;
      }
      addAdjointValue(bb, tei->getOperand(),
          makeAggregateAdjointValue(tupleTanTy, elements), tei->getLoc());
      break;
    }
    }
  }

  /// Handle `destructure_tuple` instruction.
  ///   Original: (y0, ..., yn) = destructure_tuple x
  ///    Adjoint: adj[x].0 += adj[y0]
  ///             ...
  ///             adj[x].n += adj[yn]
  void visitDestructureTupleInst(DestructureTupleInst *dti) {
    auto *bb = dti->getParent();
    auto tupleTanTy = getRemappedTangentType(dti->getOperand()->getType());
    SmallVector<AdjointValue, 8> adjValues;
    for (auto origElt : dti->getResults()) {
      if (!getTangentSpace(remapType(origElt->getType()).getASTType()))
        continue;
      adjValues.push_back(getAdjointValue(bb, origElt));
    }
    // Handle tuple tangent type.
    // Add adjoints for every tuple element that has a tangent space.
    if (tupleTanTy.is<TupleType>()) {
      assert(adjValues.size() > 1);
      addAdjointValue(bb, dti->getOperand(),
                      makeAggregateAdjointValue(tupleTanTy, adjValues),
                      dti->getLoc());
    }
    // Handle non-tuple tangent type.
    // Add adjoint for the single tuple element that has a tangent space.
    else {
      assert(adjValues.size() == 1);
      addAdjointValue(bb, dti->getOperand(), adjValues.front(), dti->getLoc());
    }
  }

  /// Handle `load` or `load_borrow` instruction
  ///   Original: y = load/load_borrow x
  ///    Adjoint: adj[x] += adj[y]
  void visitLoadOperation(SingleValueInstruction *inst) {
    assert(isa<LoadInst>(inst) || isa<LoadBorrowInst>(inst));
    auto *bb = inst->getParent();
    auto adjVal =
    materializeAdjointDirect(getAdjointValue(bb, inst), inst->getLoc());
    // Allocate a local buffer and store the adjoint value. This buffer will be
    // used for accumulation into the adjoint buffer.
    auto *localBuf = builder.createAllocStack(inst->getLoc(), adjVal->getType());
    auto copy = builder.emitCopyValueOperation(inst->getLoc(), adjVal);
    builder.emitStoreValueOperation(inst->getLoc(), copy, localBuf,
                                    StoreOwnershipQualifier::Init);
    // Accumulate the adjoint value in the local buffer into the adjoint buffer.
    addToAdjointBuffer(bb, inst->getOperand(0), localBuf, inst->getLoc());
    builder.emitDestroyAddr(inst->getLoc(), localBuf);
    builder.createDeallocStack(inst->getLoc(), localBuf);
  }
  void visitLoadInst(LoadInst *li) { visitLoadOperation(li); }
  void visitLoadBorrowInst(LoadBorrowInst *lbi) { visitLoadOperation(lbi); }

  /// Handle `store` or `store_borrow` instruction.
  ///   Original: store/store_borrow x to y
  ///    Adjoint: adj[x] += load adj[y]; adj[y] = 0
  void visitStoreOperation(SILBasicBlock *bb, SILLocation loc,
                           SILValue origSrc, SILValue origDest) {
    auto &adjBuf = getAdjointBuffer(bb, origDest);
    auto bufType = remapType(adjBuf->getType());
    auto adjVal = builder.emitLoadValueOperation(
        loc, adjBuf, LoadOwnershipQualifier::Take);
    recordTemporary(adjVal);
    addAdjointValue(bb, origSrc, makeConcreteAdjointValue(adjVal), loc);
    emitZeroIndirect(bufType.getASTType(), adjBuf, loc);
  }
  void visitStoreInst(StoreInst *si) {
    // Handle `store` to `array.uninitialized_intrinsic` element address
    // specially.
    if (auto *ai = getAllocateUninitializedArrayIntrinsicElementAddress(
            si->getDest())) {
      accumulateArrayElementAdjoint(si);
      return;
    }
    visitStoreOperation(
        si->getParent(), si->getLoc(), si->getSrc(), si->getDest());
  }
  void visitStoreBorrowInst(StoreBorrowInst *sbi) {
    visitStoreOperation(
        sbi->getParent(), sbi->getLoc(), sbi->getSrc(), sbi->getDest());
  }

  /// Handle `copy_addr` instruction.
  ///   Original: copy_addr x to y
  ///    Adjoint: adj[x] += adj[y]; adj[y] = 0
  void visitCopyAddrInst(CopyAddrInst *cai) {
    // Handle `copy_addr` to `array.uninitialized_intrinsic` element address
    // specially.
    if (auto *ai = getAllocateUninitializedArrayIntrinsicElementAddress(
            cai->getDest())) {
      accumulateArrayElementAdjoint(cai);
      return;
    }
    auto *bb = cai->getParent();
    auto &adjDest = getAdjointBuffer(bb, cai->getDest());
    auto destType = remapType(adjDest->getType());
    addToAdjointBuffer(bb, cai->getSrc(), adjDest, cai->getLoc());
    builder.emitDestroyAddrAndFold(cai->getLoc(), adjDest);
    emitZeroIndirect(destType.getASTType(), adjDest, cai->getLoc());
  }

  /// Handle `copy_value` instruction.
  ///   Original: y = copy_value x
  ///    Adjoint: adj[x] += adj[y]
  void visitCopyValueInst(CopyValueInst *cvi) {
    auto *bb = cvi->getParent();
    auto adj = getAdjointValue(bb, cvi);
    addAdjointValue(bb, cvi->getOperand(), adj, cvi->getLoc());
  }

  /// Handle `begin_borrow` instruction.
  ///   Original: y = begin_borrow x
  ///    Adjoint: adj[x] += adj[y]
  void visitBeginBorrowInst(BeginBorrowInst *bbi) {
    auto *bb = bbi->getParent();
    auto adj = getAdjointValue(bb, bbi);
    addAdjointValue(bb, bbi->getOperand(), adj, bbi->getLoc());
  }

  /// Handle `begin_access` instruction.
  ///   Original: y = begin_access x
  ///    Adjoint: nothing
  void visitBeginAccessInst(BeginAccessInst *bai) {
    // Check for non-differentiable writes.
    if (bai->getAccessKind() == SILAccessKind::Modify) {
      if (auto *gai = dyn_cast<GlobalAddrInst>(bai->getSource())) {
        getContext().emitNondifferentiabilityError(bai, getInvoker(),
            diag::autodiff_cannot_differentiate_writes_to_global_variables);
        errorOccurred = true;
        return;
      }
      if (auto *pbi = dyn_cast<ProjectBoxInst>(bai->getSource())) {
        getContext().emitNondifferentiabilityError(bai, getInvoker(),
            diag::autodiff_cannot_differentiate_writes_to_mutable_captures);
        errorOccurred = true;
        return;
      }
    }
  }

  /// Handle `unconditional_checked_cast_addr` instruction.
  ///   Original: y = unconditional_checked_cast_addr x
  ///    Adjoint: adj[x] += unconditional_checked_cast_addr adj[y]
  void visitUnconditionalCheckedCastAddrInst(
      UnconditionalCheckedCastAddrInst *uccai) {
    auto *bb = uccai->getParent();
    auto &adjDest = getAdjointBuffer(bb, uccai->getDest());
    auto &adjSrc = getAdjointBuffer(bb, uccai->getSrc());
    auto destType = remapType(adjDest->getType());
    auto castBuf = builder.createAllocStack(uccai->getLoc(), adjSrc->getType());
    builder.createUnconditionalCheckedCastAddr(
        uccai->getLoc(), adjDest, adjDest->getType().getASTType(), castBuf,
        adjSrc->getType().getASTType());
    addToAdjointBuffer(bb, uccai->getSrc(), castBuf, uccai->getLoc());
    builder.emitDestroyAddrAndFold(uccai->getLoc(), castBuf);
    builder.createDeallocStack(uccai->getLoc(), castBuf);
    emitZeroIndirect(destType.getASTType(), adjDest, uccai->getLoc());
  }

#define NOT_DIFFERENTIABLE(INST, DIAG) \
  void visit##INST##Inst(INST##Inst *inst) { \
    getContext().emitNondifferentiabilityError( \
        inst, getInvoker(), diag::DIAG); \
    errorOccurred = true; \
    return; \
  }
  NOT_DIFFERENTIABLE(RefElementAddr, autodiff_class_property_not_supported)
#undef NOT_DIFFERENTIABLE

#define NO_ADJOINT(INST) \
  void visit##INST##Inst(INST##Inst *inst) {}
  // Terminators.
  NO_ADJOINT(Return)
  NO_ADJOINT(Branch)
  NO_ADJOINT(CondBranch)

  // Address projections.
  NO_ADJOINT(StructElementAddr)
  NO_ADJOINT(TupleElementAddr)

  // Array literal initialization address projections.
  NO_ADJOINT(PointerToAddress)
  NO_ADJOINT(IndexAddr)

  // Memory allocation/access.
  NO_ADJOINT(AllocStack)
  NO_ADJOINT(DeallocStack)
  NO_ADJOINT(EndAccess)

  // Debugging/reference counting instructions.
  NO_ADJOINT(DebugValue)
  NO_ADJOINT(DebugValueAddr)
  NO_ADJOINT(RetainValue)
  NO_ADJOINT(RetainValueAddr)
  NO_ADJOINT(ReleaseValue)
  NO_ADJOINT(ReleaseValueAddr)
  NO_ADJOINT(StrongRetain)
  NO_ADJOINT(StrongRelease)
  NO_ADJOINT(UnownedRetain)
  NO_ADJOINT(UnownedRelease)
  NO_ADJOINT(StrongRetainUnowned)
  NO_ADJOINT(DestroyValue)
  NO_ADJOINT(DestroyAddr)

  // Value ownership.
  NO_ADJOINT(EndBorrow)
#undef NO_DERIVATIVE
};
} // end anonymous namespace

AdjointValue PullbackEmitter::makeZeroAdjointValue(SILType type) {
  return AdjointValue::createZero(allocator, remapType(type));
}

AdjointValue
PullbackEmitter::makeConcreteAdjointValue(SILValue value) {
  return AdjointValue::createConcrete(allocator, value);
}

template<typename EltRange>
AdjointValue PullbackEmitter::makeAggregateAdjointValue(
    SILType type, EltRange elements) {
  AdjointValue *buf = reinterpret_cast<AdjointValue *>(allocator.Allocate(
      elements.size() * sizeof(AdjointValue), alignof(AdjointValue)));
  MutableArrayRef<AdjointValue> elementsCopy(buf, elements.size());
  std::uninitialized_copy(elements.begin(), elements.end(),
                          elementsCopy.begin());
  return AdjointValue::createAggregate(allocator, remapType(type),
                                       elementsCopy);
}

SILValue PullbackEmitter::materializeAdjointDirect(
    AdjointValue val, SILLocation loc) {
  assert(val.getType().isObject());
  LLVM_DEBUG(getADDebugStream() <<
             "Materializing adjoints for " << val << '\n');
  switch (val.getKind()) {
  case AdjointValueKind::Zero:
    return recordTemporary(emitZeroDirect(val.getType().getASTType(), loc));
  case AdjointValueKind::Aggregate: {
    SmallVector<SILValue, 8> elements;
    for (auto i : range(val.getNumAggregateElements())) {
      auto eltVal = materializeAdjointDirect(val.getAggregateElement(i), loc);
      elements.push_back(builder.emitCopyValueOperation(loc, eltVal));
    }
    if (val.getType().is<TupleType>())
      return recordTemporary(
          builder.createTuple(loc, val.getType(), elements));
    else
      return recordTemporary(
          builder.createStruct(loc, val.getType(), elements));
  }
  case AdjointValueKind::Concrete:
    return val.getConcreteValue();
  }
}

SILValue PullbackEmitter::materializeAdjoint(AdjointValue val,
                                             SILLocation loc) {
  if (val.isConcrete()) {
    LLVM_DEBUG(getADDebugStream()
        << "Materializing adjoint: Value is concrete.\n");
    return val.getConcreteValue();
  }
  LLVM_DEBUG(getADDebugStream() << "Materializing adjoint: Value is "
                                   "non-concrete. Materializing directly.\n");
  return materializeAdjointDirect(val, loc);
}

void PullbackEmitter::materializeAdjointIndirect(
    AdjointValue val, SILValue destBufferAccess, SILLocation loc) {
  switch (val.getKind()) {
  /// Given a `%buf : *T, emit instructions that produce a zero or an aggregate
  /// of zeros of the expected type. When `T` conforms to
  /// `AdditiveArithmetic`, we emit a call to `AdditiveArithmetic.zero`. When
  /// `T` is a builtin float, we emit a `float_literal` instruction.
  /// Otherwise, we assert that `T` must be an aggregate where each element
  /// conforms to `AdditiveArithmetic` or is a builtin float. We expect to emit
  /// a zero for each element and use the appropriate aggregate constructor
  /// instruction (in this case, `tuple`) to produce a tuple. But currently,
  /// since we need indirect passing for aggregate instruction, we just use
  /// `tuple_element_addr` to get element buffers and write elements to them.
  case AdjointValueKind::Zero:
    emitZeroIndirect(val.getSwiftType(), destBufferAccess, loc);
    break;
  /// Given a `%buf : *(T0, T1, T2, ...)` or `%buf : *Struct` recursively emit
  /// instructions to materialize the symbolic tuple or struct, filling the
  /// buffer.
  case AdjointValueKind::Aggregate: {
    if (auto *tupTy = val.getSwiftType()->getAs<TupleType>()) {
      for (auto idx : range(val.getNumAggregateElements())) {
        auto eltTy = SILType::getPrimitiveAddressType(
            tupTy->getElementType(idx)->getCanonicalType());
        auto *eltBuf =
            builder.createTupleElementAddr(loc, destBufferAccess, idx, eltTy);
        materializeAdjointIndirect(
            val.getAggregateElement(idx), eltBuf, loc);
      }
    } else if (auto *structDecl =
                   val.getSwiftType()->getStructOrBoundGenericStruct()) {
      auto fieldIt = structDecl->getStoredProperties().begin();
      for (unsigned i = 0; fieldIt != structDecl->getStoredProperties().end();
           ++fieldIt, ++i) {
        auto eltBuf =
            builder.createStructElementAddr(loc, destBufferAccess, *fieldIt);
        materializeAdjointIndirect(
            val.getAggregateElement(i), eltBuf, loc);
      }
    } else {
      llvm_unreachable("Not an aggregate type");
    }
    break;
  }
  /// Value is already materialized!
  case AdjointValueKind::Concrete:
    auto concreteVal = val.getConcreteValue();
    builder.emitStoreValueOperation(loc, concreteVal, destBufferAccess,
                                    StoreOwnershipQualifier::Init);
    break;
  }
}

void PullbackEmitter::emitZeroIndirect(CanType type, SILValue bufferAccess,
                                       SILLocation loc) {
  auto tangentSpace = getTangentSpace(type);
  assert(tangentSpace && "No tangent space for this type");
  switch (tangentSpace->getKind()) {
  case VectorSpace::Kind::Vector:
    emitZeroIntoBuffer(builder, type, bufferAccess, loc);
    return;
  case VectorSpace::Kind::Tuple: {
    auto tupleType = tangentSpace->getTuple();
    SmallVector<SILValue, 8> zeroElements;
    for (unsigned i : range(tupleType->getNumElements())) {
      auto eltAddr = builder.createTupleElementAddr(loc, bufferAccess, i);
      emitZeroIndirect(tupleType->getElementType(i)->getCanonicalType(),
                       eltAddr, loc);
    }
    return;
  }
  case VectorSpace::Kind::Function: {
    llvm_unreachable(
      "Unimplemented: Emit thunks for abstracting zero initialization");
  }
  }
}

SILValue PullbackEmitter::emitZeroDirect(CanType type, SILLocation loc) {
  auto silType = getModule().Types.getLoweredLoadableType(
      type, TypeExpansionContext::minimal(), getModule());
  auto *buffer = builder.createAllocStack(loc, silType);
  emitZeroIndirect(type, buffer, loc);
  auto loaded = builder.emitLoadValueOperation(
      loc, buffer, LoadOwnershipQualifier::Take);
  builder.createDeallocStack(loc, buffer);
  return loaded;
}

AdjointValue
PullbackEmitter::accumulateAdjointsDirect(AdjointValue lhs, AdjointValue rhs,
                                          SILLocation loc) {
  LLVM_DEBUG(getADDebugStream()
             << "Materializing adjoint directly.\nLHS: " << lhs
             << "\nRHS: " << rhs << '\n');

  switch (lhs.getKind()) {
  // x
  case AdjointValueKind::Concrete: {
    auto lhsVal = lhs.getConcreteValue();
    switch (rhs.getKind()) {
    // x + y
    case AdjointValueKind::Concrete: {
      auto rhsVal = rhs.getConcreteValue();
      auto sum = recordTemporary(accumulateDirect(lhsVal, rhsVal, loc));
      return makeConcreteAdjointValue(sum);
    }
    // x + 0 => x
    case AdjointValueKind::Zero:
      return lhs;
    // x + (y, z) => (x.0 + y, x.1 + z)
    case AdjointValueKind::Aggregate:
      SmallVector<AdjointValue, 8> newElements;
      auto lhsTy = lhsVal->getType().getASTType();
      auto lhsValCopy = builder.emitCopyValueOperation(loc, lhsVal);
      if (auto *tupTy = lhsTy->getAs<TupleType>()) {
        auto elts = builder.createDestructureTuple(loc, lhsValCopy);
        llvm::for_each(elts->getResults(),
                       [this](SILValue result) { recordTemporary(result); });
        for (auto i : indices(elts->getResults())) {
          auto rhsElt = rhs.getAggregateElement(i);
          newElements.push_back(accumulateAdjointsDirect(
              makeConcreteAdjointValue(elts->getResult(i)), rhsElt, loc));
        }
      } else if (auto *structDecl = lhsTy->getStructOrBoundGenericStruct()) {
        auto elts =
            builder.createDestructureStruct(lhsVal.getLoc(), lhsValCopy);
        llvm::for_each(elts->getResults(),
                       [this](SILValue result) { recordTemporary(result); });
        for (unsigned i : indices(elts->getResults())) {
          auto rhsElt = rhs.getAggregateElement(i);
          newElements.push_back(
              accumulateAdjointsDirect(
                  makeConcreteAdjointValue(elts->getResult(i)), rhsElt, loc));
        }
      } else {
        llvm_unreachable("Not an aggregate type");
      }
      return makeAggregateAdjointValue(lhsVal->getType(), newElements);
    }
  }
  // 0
  case AdjointValueKind::Zero:
    // 0 + x => x
    return rhs;
  // (x, y)
  case AdjointValueKind::Aggregate:
    switch (rhs.getKind()) {
    // (x, y) + z => (z.0 + x, z.1 + y)
    case AdjointValueKind::Concrete:
      return accumulateAdjointsDirect(rhs, lhs, loc);
    // x + 0 => x
    case AdjointValueKind::Zero:
      return lhs;
    // (x, y) + (z, w) => (x + z, y + w)
    case AdjointValueKind::Aggregate: {
      SmallVector<AdjointValue, 8> newElements;
      for (auto i : range(lhs.getNumAggregateElements()))
        newElements.push_back(
            accumulateAdjointsDirect(lhs.getAggregateElement(i),
                                     rhs.getAggregateElement(i),
                                     loc));
      return makeAggregateAdjointValue(lhs.getType(), newElements);
    }
    }
  }
}

SILValue PullbackEmitter::accumulateDirect(SILValue lhs, SILValue rhs,
                                           SILLocation loc) {
  // TODO: Optimize for the case when lhs == rhs.
  LLVM_DEBUG(getADDebugStream() <<
             "Emitting adjoint accumulation for lhs: " << lhs <<
             " and rhs: " << rhs);
  assert(lhs->getType() == rhs->getType() && "Adjoints must have equal types!");
  assert(lhs->getType().isObject() && rhs->getType().isObject() &&
         "Adjoint types must be both object types!");
  auto adjointTy = lhs->getType();
  auto adjointASTTy = adjointTy.getASTType();
  auto tangentSpace = getTangentSpace(adjointASTTy);
  auto lhsCopy = builder.emitCopyValueOperation(loc, lhs);
  auto rhsCopy = builder.emitCopyValueOperation(loc, rhs);
  assert(tangentSpace && "No tangent space for this type");
  switch (tangentSpace->getKind()) {
  case VectorSpace::Kind::Vector: {
    // Allocate buffers for inputs and output.
    auto *resultBuf = builder.createAllocStack(loc, adjointTy);
    auto *lhsBuf = builder.createAllocStack(loc, adjointTy);
    auto *rhsBuf = builder.createAllocStack(loc, adjointTy);
    // Initialize input buffers.
    builder.emitStoreValueOperation(loc, lhsCopy, lhsBuf,
                                    StoreOwnershipQualifier::Init);
    builder.emitStoreValueOperation(loc, rhsCopy, rhsBuf,
                                    StoreOwnershipQualifier::Init);
    accumulateIndirect(resultBuf, lhsBuf, rhsBuf, loc);
    builder.emitDestroyAddr(loc, lhsBuf);
    builder.emitDestroyAddr(loc, rhsBuf);
    // Deallocate input buffers.
    builder.createDeallocStack(loc, rhsBuf);
    builder.createDeallocStack(loc, lhsBuf);
    auto val = builder.emitLoadValueOperation(
        loc, resultBuf, LoadOwnershipQualifier::Take);
    // Deallocate result buffer.
    builder.createDeallocStack(loc, resultBuf);
    return val;
  }
  case VectorSpace::Kind::Tuple: {
    SmallVector<SILValue, 8> adjElements;
    auto lhsElts = builder.createDestructureTuple(loc, lhsCopy)->getResults();
    auto rhsElts = builder.createDestructureTuple(loc, rhsCopy)->getResults();
    for (auto zipped : llvm::zip(lhsElts, rhsElts))
      adjElements.push_back(
          accumulateDirect(std::get<0>(zipped), std::get<1>(zipped), loc));
    return builder.createTuple(loc, adjointTy, adjElements);
  }
  case VectorSpace::Kind::Function: {
    llvm_unreachable(
        "Unimplemented: Emit thunks for abstracting adjoint accumulation");
  }
  }
}

void PullbackEmitter::accumulateIndirect(
    SILValue resultBufAccess, SILValue lhsBufAccess, SILValue rhsBufAccess,
    SILLocation loc) {
  // TODO: Optimize for the case when lhs == rhs.
  assert(lhsBufAccess->getType() == rhsBufAccess->getType() &&
         "Adjoint values must have same type!");
  assert(lhsBufAccess->getType().isAddress() &&
         rhsBufAccess->getType().isAddress() &&
         "Adjoint values must both have address types!");
  auto adjointTy = lhsBufAccess->getType();
  auto adjointASTTy = adjointTy.getASTType();
  auto *swiftMod = getModule().getSwiftModule();
  auto tangentSpace = adjointASTTy->getAutoDiffAssociatedTangentSpace(
      LookUpConformanceInModule(swiftMod));
  assert(tangentSpace && "No tangent space for this type");
  switch (tangentSpace->getKind()) {
  case VectorSpace::Kind::Vector: {
    auto *proto = getContext().getAdditiveArithmeticProtocol();
    auto *combinerFuncDecl = getContext().getPlusDecl();
    // Call the combiner function and return.
    auto adjointParentModule = tangentSpace->getNominal()
        ? tangentSpace->getNominal()->getModuleContext()
        : getModule().getSwiftModule();
    auto confRef = adjointParentModule->lookupConformance(adjointASTTy,
                                                           proto);
    assert(!confRef.isInvalid() && "Missing conformance to `AdditiveArithmetic`");
    SILDeclRef declRef(combinerFuncDecl, SILDeclRef::Kind::Func);
    auto silFnTy = getContext().getTypeConverter().getConstantType(
        TypeExpansionContext::minimal(), declRef);
    // %0 = witness_method @+
    auto witnessMethod = builder.createWitnessMethod(loc, adjointASTTy,
                                                     confRef, declRef,
                                                     silFnTy);
    auto subMap = SubstitutionMap::getProtocolSubstitutions(
        proto, adjointASTTy, confRef);
    // %1 = metatype $T.Type
    auto metatypeType =
        CanMetatypeType::get(adjointASTTy, MetatypeRepresentation::Thick);
    auto metatypeSILType = SILType::getPrimitiveObjectType(metatypeType);
    auto metatype = builder.createMetatype(loc, metatypeSILType);
    // %2 = apply $0(%result, %new, %old, %1)
    builder.createApply(loc, witnessMethod, subMap,
                        {resultBufAccess, rhsBufAccess, lhsBufAccess, metatype},
                        /*isNonThrowing*/ false);
    builder.emitDestroyValueOperation(loc, witnessMethod);
    return;
  }
  case VectorSpace::Kind::Tuple: {
    auto tupleType = tangentSpace->getTuple();
    for (unsigned i : range(tupleType->getNumElements())) {
      auto *destAddr = builder.createTupleElementAddr(loc, resultBufAccess, i);
      auto *eltAddrLHS = builder.createTupleElementAddr(loc, lhsBufAccess, i);
      auto *eltAddrRHS = builder.createTupleElementAddr(loc, rhsBufAccess, i);
      accumulateIndirect(destAddr, eltAddrLHS, eltAddrRHS, loc);
    }
    return;
  }
  case VectorSpace::Kind::Function: {
    llvm_unreachable(
        "Unimplemented: Emit thunks for abstracting adjoint value "
        "accumulation");
  }
  }
}

void PullbackEmitter::accumulateIndirect(SILValue lhsDestAccess,
                                         SILValue rhsAccess, SILLocation loc) {
  assert(lhsDestAccess->getType().isAddress() &&
         rhsAccess->getType().isAddress());
  assert(lhsDestAccess->getFunction() == &getPullback());
  assert(rhsAccess->getFunction() == &getPullback());
  auto type = lhsDestAccess->getType();
  auto astType = type.getASTType();
  auto *swiftMod = getModule().getSwiftModule();
  auto tangentSpace = astType->getAutoDiffAssociatedTangentSpace(
      LookUpConformanceInModule(swiftMod));
  assert(tangentSpace && "No tangent space for this type");
  switch (tangentSpace->getKind()) {
  case VectorSpace::Kind::Vector: {
    auto *proto = getContext().getAdditiveArithmeticProtocol();
    auto *accumulatorFuncDecl = getContext().getPlusEqualDecl();
    // Call the combiner function and return.
    auto confRef = swiftMod->lookupConformance(astType, proto);
    assert(!confRef.isInvalid() && "Missing conformance to `AdditiveArithmetic`");
    SILDeclRef declRef(accumulatorFuncDecl, SILDeclRef::Kind::Func);
    auto silFnTy = getContext().getTypeConverter().getConstantType(
        TypeExpansionContext::minimal(), declRef);
    // %0 = witness_method @+=
    auto witnessMethod =
        builder.createWitnessMethod(loc, astType, confRef, declRef, silFnTy);
    auto subMap =
        SubstitutionMap::getProtocolSubstitutions(proto, astType, confRef);
    // %1 = metatype $T.Type
    auto metatypeType =
        CanMetatypeType::get(astType, MetatypeRepresentation::Thick);
    auto metatypeSILType = SILType::getPrimitiveObjectType(metatypeType);
    auto metatype = builder.createMetatype(loc, metatypeSILType);
    // %2 = apply $0(%lhs, %rhs, %1)
    builder.createApply(loc, witnessMethod, subMap,
                        {lhsDestAccess, rhsAccess, metatype},
                        /*isNonThrowing*/ false);
    builder.emitDestroyValueOperation(loc, witnessMethod);
    return;
  }
  case VectorSpace::Kind::Tuple: {
    auto tupleType = tangentSpace->getTuple();
    for (unsigned i : range(tupleType->getNumElements())) {
      auto *destAddr = builder.createTupleElementAddr(loc, lhsDestAccess, i);
      auto *eltAddrRHS = builder.createTupleElementAddr(loc, rhsAccess, i);
      accumulateIndirect(destAddr, eltAddrRHS, loc);
    }
    return;
  }
  case VectorSpace::Kind::Function: {
    llvm_unreachable(
        "Unimplemented: Emit thunks for abstracting adjoint value "
        "accumulation");
  }
  }
}

bool VJPEmitter::run() {
  PrettyStackTraceSILFunction trace("generating VJP for", original);
  LLVM_DEBUG(getADDebugStream()
             << "Cloning original @" << original->getName()
             << " to vjp @" << vjp->getName() << '\n');

  // Create entry BB and arguments.
  auto *entry = vjp->createBasicBlock();
  createEntryArguments(vjp);

  // Clone.
  SmallVector<SILValue, 4> entryArgs(entry->getArguments().begin(),
                                     entry->getArguments().end());
  cloneFunctionBody(original, entry, entryArgs);
  // If errors occurred, back out.
  if (errorOccurred)
    return true;

  // Merge VJP basic blocks. This is significant for control flow
  // differentiation: trampoline destination bbs are merged into trampoline bbs.
  // NOTE(TF-990): Merging basic blocks ensures that `@guaranteed` trampoline
  // bb arguments have a lifetime-ending `end_borrow` use, and is robust when
  // `-enable-strip-ownership-after-serialization` is true.
  mergeBasicBlocks(vjp);

  // Generate pullback code.
  PullbackEmitter PullbackEmitter(*this);
  if (PullbackEmitter.run()) {
    errorOccurred = true;
    return true;
  }
  LLVM_DEBUG(getADDebugStream() << "Generated VJP for "
                                << original->getName() << ":\n" << *vjp);
  return errorOccurred;
}

//===----------------------------------------------------------------------===//
// `SILDifferentiabilityWitness` processing
//===----------------------------------------------------------------------===//

static SILFunction *createEmptyVJP(ADContext &context, SILFunction *original,
                                   SILDifferentiabilityWitness *witness,
                                   IsSerialized_t isSerialized) {
  LLVM_DEBUG({
    auto &s = getADDebugStream();
    s << "Creating VJP:\n\t";
    s << "Original type: " << original->getLoweredFunctionType() << "\n\t";
  });

  auto &module = context.getModule();
  auto originalTy = original->getLoweredFunctionType();
  auto indices = witness->getSILAutoDiffIndices();

  // === Create an empty VJP. ===
  Mangle::ASTMangler mangler;
  auto vjpName = original->getASTContext().getIdentifier(
      mangler.mangleAutoDiffDerivativeFunctionHelper(
          original->getName(), AutoDiffDerivativeFunctionKind::VJP, indices))
              .str();
  auto vjpGenericSig = getDerivativeGenericSignature(witness, original);

  // RAII that pushes the original function's generic signature to
  // `module.Types` so that calls to `module.Types.getTypeLowering()` below
  // will know the VJP's generic parameter types.
  Lowering::GenericContextScope genericContextScope(
      module.Types, vjpGenericSig);

  auto *vjpGenericEnv = vjpGenericSig
      ? vjpGenericSig->getGenericEnvironment()
      : nullptr;
  auto vjpType = originalTy->getAutoDiffDerivativeFunctionType(
      indices.parameters, indices.source, AutoDiffDerivativeFunctionKind::VJP,
      module.Types, LookUpConformanceInModule(module.getSwiftModule()),
      vjpGenericSig,
      /*isReabstractionThunk*/ original->isThunk() == IsReabstractionThunk);

  SILOptFunctionBuilder fb(context.getTransform());
  auto *vjp = fb.createFunction(
      witness->getLinkage(), vjpName, vjpType, vjpGenericEnv,
      original->getLocation(), original->isBare(), IsNotTransparent,
      isSerialized, original->isDynamicallyReplaceable());
  vjp->setDebugScope(new (module) SILDebugScope(original->getLocation(), vjp));

  LLVM_DEBUG(llvm::dbgs() << "VJP type: " << vjp->getLoweredFunctionType()
                          << "\n");
  return vjp;
}

static SILFunction *createEmptyJVP(ADContext &context, SILFunction *original,
                                   SILDifferentiabilityWitness *witness,
                                   IsSerialized_t isSerialized) {
  LLVM_DEBUG({
    auto &s = getADDebugStream();
    s << "Creating JVP:\n\t";
    s << "Original type: " << original->getLoweredFunctionType() << "\n\t";
  });

  auto &module = context.getModule();
  auto originalTy = original->getLoweredFunctionType();
  auto indices = witness->getSILAutoDiffIndices();

  // === Create an empty JVP. ===
  Mangle::ASTMangler mangler;
  auto jvpName = original->getASTContext().getIdentifier(
      mangler.mangleAutoDiffDerivativeFunctionHelper(
          original->getName(), AutoDiffDerivativeFunctionKind::JVP, indices))
              .str();
  auto jvpGenericSig = getDerivativeGenericSignature(witness, original);

  // RAII that pushes the original function's generic signature to
  // `module.Types` so that calls to `module.Types.getTypeLowering()` below
  // will know the VJP's generic parameter types.
  Lowering::GenericContextScope genericContextScope(
      module.Types, jvpGenericSig);

  auto *jvpGenericEnv = jvpGenericSig
      ? jvpGenericSig->getGenericEnvironment()
      : nullptr;
  auto jvpType = originalTy->getAutoDiffDerivativeFunctionType(
      indices.parameters, indices.source, AutoDiffDerivativeFunctionKind::JVP,
      module.Types, LookUpConformanceInModule(module.getSwiftModule()),
      jvpGenericSig,
      /*isReabstractionThunk*/ original->isThunk() == IsReabstractionThunk);

  SILOptFunctionBuilder fb(context.getTransform());
  auto *jvp = fb.createFunction(
      witness->getLinkage(), jvpName, jvpType, jvpGenericEnv,
      original->getLocation(), original->isBare(), IsNotTransparent,
      isSerialized, original->isDynamicallyReplaceable());
  jvp->setDebugScope(new (module) SILDebugScope(original->getLocation(), jvp));

  LLVM_DEBUG(llvm::dbgs() << "JVP type: " << jvp->getLoweredFunctionType()
             << "\n");
  return jvp;
}

/// Returns true on error.
bool DifferentiationTransformer::canonicalizeDifferentiabilityWitness(
    SILFunction *original, SILDifferentiabilityWitness *witness,
    DifferentiationInvoker invoker, IsSerialized_t serializeFunctions) {
  std::string traceMessage;
  llvm::raw_string_ostream OS(traceMessage);
  OS << "processing ";
  witness->print(OS);
  OS << " on";
  OS.flush();
  PrettyStackTraceSILFunction trace(traceMessage.c_str(), original);

  assert(witness->isDefinition());

  // If the JVP doesn't exist, need to synthesize it.
  if (!witness->getJVP()) {
    // Diagnose:
    // - Functions with no return.
    // - Functions with unsupported control flow.
    if (context.getASTContext().LangOpts.EnableExperimentalForwardModeDifferentiation &&
        (diagnoseNoReturn(context, original, invoker) ||
         diagnoseUnsupportedControlFlow(context, original, invoker)))
      return true;

    witness->setJVP(
        createEmptyJVP(context, original, witness, serializeFunctions));
    context.recordGeneratedFunction(witness->getJVP());

    // For now, only do JVP generation if the flag is enabled and if custom VJP
    // does not exist. If custom VJP exists but custom JVP does not, skip JVP
    // generation because generated JVP may not match semantics of custom VJP.
    // Instead, create an empty JVP.
    if (context.getASTContext().LangOpts.EnableExperimentalForwardModeDifferentiation &&
        !witness->getVJP()) {
      // JVP and differential generation do not currently support functions with
      // multiple basic blocks.
      if (original->getBlocks().size() > 1) {
        context.emitNondifferentiabilityError(
            original->getLocation().getSourceLoc(), invoker,
            diag::autodiff_jvp_control_flow_not_supported);
        return true;
      }

      JVPEmitter emitter(context, original, witness, witness->getJVP(), invoker);
      if (emitter.run())
        return true;
    } else {
      LLVM_DEBUG(getADDebugStream()
                 << "Generating empty JVP for original @"
                 << original->getName() << '\n');
      // Create empty JVP body since custom VJP exists.
      auto *entry = witness->getJVP()->createBasicBlock();
      createEntryArguments(witness->getJVP());
      SILBuilder builder(entry);
      auto loc = witness->getJVP()->getLocation();

      // Destroy all owned arguments.
      for (auto *arg : entry->getArguments())
        if (arg->getOwnershipKind() == ValueOwnershipKind::Owned)
          builder.emitDestroyOperation(loc, arg);

      // Fatal error in case this JVP is called by the user.
      auto neverResultInfo = SILResultInfo(
        context.getModule().getASTContext().getNeverType(), ResultConvention::Unowned);
      auto fatalErrorJVPType = SILFunctionType::get(
          /*genericSig*/ nullptr,
          SILFunctionType::ExtInfo().withRepresentation(
              SILFunctionTypeRepresentation::Thin),
          SILCoroutineKind::None, ParameterConvention::Direct_Unowned, {},
          /*interfaceYields*/ {}, neverResultInfo,
          /*interfaceErrorResults*/ None, {}, false, context.getASTContext());
      auto fnBuilder = SILOptFunctionBuilder(context.getTransform());
      auto *fatalErrrorJvpFunc = fnBuilder.getOrCreateFunction(
          loc, "_printJVPErrorAndExit", SILLinkage::PublicExternal,
          fatalErrorJVPType, IsNotBare, IsNotTransparent, IsNotSerialized,
          IsNotDynamic, ProfileCounter(), IsNotThunk);
      auto *jvpErrorFuncRef =
          builder.createFunctionRef(loc, fatalErrrorJvpFunc);
      builder.createApply(loc, jvpErrorFuncRef, SubstitutionMap(), {});
      builder.createUnreachable(loc);
      LLVM_DEBUG(getADDebugStream()
                 << "Generated empty JVP for " << original->getName() << ":\n"
                 << *witness->getJVP());
    }
  }

  // If the VJP doesn't exist, need to synthesize it.
  if (!witness->getVJP()) {
    // Diagnose:
    // - Functions with no return.
    // - Functions with unsupported control flow.
    if (diagnoseNoReturn(context, original, invoker) ||
        diagnoseUnsupportedControlFlow(context, original, invoker))
      return true;

    witness->setVJP(
        createEmptyVJP(context, original, witness, serializeFunctions));
    context.recordGeneratedFunction(witness->getVJP());
    VJPEmitter emitter(context, original, witness, witness->getVJP(), invoker);
    return emitter.run();
  }

  return false;
}

//===----------------------------------------------------------------------===//
// Differentiation pass implementation
//===----------------------------------------------------------------------===//

/// The automatic differentiation pass.
namespace {
class Differentiation : public SILModuleTransform {
public:
  Differentiation() : SILModuleTransform() {}
  void run() override;
};
} // end anonymous namespace

std::pair<SILFunction *, SubstitutionMap>
DifferentiationTransformer::getOrCreateSubsetParametersThunkForLinearMap(
    SILFunction *parentThunk, CanSILFunctionType linearMapType,
    CanSILFunctionType targetType, AutoDiffDerivativeFunctionKind kind,
    SILAutoDiffIndices desiredIndices, SILAutoDiffIndices actualIndices) {
  LLVM_DEBUG(getADDebugStream()
             << "Getting a subset parameters thunk for " << linearMapType
             << " from " << actualIndices << " to " << desiredIndices << '\n');

  SubstitutionMap interfaceSubs;
  GenericEnvironment *genericEnv = nullptr;
  auto thunkType = buildThunkType(
      parentThunk, linearMapType, targetType, genericEnv, interfaceSubs,
      /*withoutActuallyEscaping*/ true,
      DifferentiationThunkKind::Reabstraction);

  // TODO(TF-685): Use more principled mangling for thunks.
  std::string thunkName;
  switch (kind) {
    case AutoDiffDerivativeFunctionKind::JVP:
      thunkName = "differential";
      break;
    case AutoDiffDerivativeFunctionKind::VJP:
      thunkName = "pullback";
  }
  Mangle::ASTMangler mangler;
  auto fromInterfaceType =
      linearMapType->mapTypeOutOfContext()->getCanonicalType();
  auto toInterfaceType = targetType->mapTypeOutOfContext()->getCanonicalType();
  CanType dynamicSelfType;
  thunkName = "AD__" + mangler.mangleReabstractionThunkHelper(
      thunkType, fromInterfaceType, toInterfaceType, dynamicSelfType,
      context.getModule().getSwiftModule()) + "_" + desiredIndices.mangle() + "_" +
      thunkName;
  thunkName += "_index_subset_thunk";

  auto loc = parentThunk->getLocation();
  SILOptFunctionBuilder fb(context.getTransform());
  auto *thunk = fb.getOrCreateSharedFunction(
      loc, thunkName, thunkType, IsBare, IsTransparent, IsSerialized,
      ProfileCounter(), IsThunk, IsNotDynamic);

  if (!thunk->empty())
    return {thunk, interfaceSubs};

  thunk->setGenericEnvironment(genericEnv);
  thunk->setOwnershipEliminated();
  auto *entry = thunk->createBasicBlock();
  SILBuilder builder(entry);
  createEntryArguments(thunk);

  // Get arguments.
  SmallVector<SILValue, 4> arguments;
  SmallVector<AllocStackInst *, 4> localAllocations;

  // Build a `.zero` argument for the given `Differentiable`-conforming type.
  auto buildZeroArgument = [&](SILType zeroSILType) {
    auto zeroSILObjType = zeroSILType.getObjectType();
    auto zeroType = zeroSILType.getASTType();
    auto *swiftMod = context.getModule().getSwiftModule();
    auto tangentSpace = zeroType->getAutoDiffAssociatedTangentSpace(
      LookUpConformanceInModule(swiftMod));
    assert(tangentSpace && "No tangent space for this type");
    switch (tangentSpace->getKind()) {
    case VectorSpace::Kind::Vector: {
      auto *buf = builder.createAllocStack(loc, zeroSILObjType);
      localAllocations.push_back(buf);
      emitZeroIntoBuffer(builder, zeroType, buf, loc);
      if (zeroSILType.isAddress())
        arguments.push_back(buf);
      else {
        auto *arg = builder.createLoad(loc, buf,
                                       LoadOwnershipQualifier::Unqualified);
        arguments.push_back(arg);
      }
      break;
    }
    case VectorSpace::Kind::Tuple: {
      llvm_unreachable(
          "Unimplemented: Handle zero initialization for tuples");
    }
    case VectorSpace::Kind::Function:
      llvm_unreachable(
          "Unimplemented: Emit thunks for abstracting zero initialization");
    }
  };

  // `actualIndices` and `desiredIndices` are with respect to the original
  // function. However, the differential parameters and pullback results may
  // already be w.r.t. a subset. We create a map between the original function's
  // actual parameter indices and the linear map's actual indices.
  // Example:
  //   Original: (T0, T1, T2) -> R
  //   Actual indices: 0, 2
  //   Original differential: (T0, T2) -> R
  //   Original pullback: R -> (T0, T2)
  //   Desired indices w.r.t. original: 2
  //   Desired indices w.r.t. linear map: 1
  SmallVector<unsigned, 4> actualParamIndicesMap(
      actualIndices.parameters->getCapacity(), UINT_MAX);
  {
    unsigned indexInBitVec = 0;
    for (auto index : actualIndices.parameters->getIndices()) {
      actualParamIndicesMap[index] = indexInBitVec;
      indexInBitVec++;
    }
  }
  auto mapOriginalParameterIndex = [&](unsigned index) -> unsigned {
    auto mappedIndex = actualParamIndicesMap[index];
    assert(mappedIndex < actualIndices.parameters->getCapacity());
    return mappedIndex;
  };

  switch (kind) {
  // Differential arguments are:
  // - All indirect results, followed by:
  // - An interleaving of:
  //   - Thunk arguments (when parameter index is in both desired and actual
  //     indices).
  //   - Zeros (when parameter is not in desired indices).
  case AutoDiffDerivativeFunctionKind::JVP: {
    // Forward all indirect results.
    arguments.append(thunk->getIndirectResults().begin(),
                     thunk->getIndirectResults().end());
    auto toArgIter = thunk->getArgumentsWithoutIndirectResults().begin();
    auto useNextArgument = [&]() {
      arguments.push_back(*toArgIter++);
    };
    // Iterate over actual indices.
    for (unsigned i : actualIndices.parameters->getIndices()) {
      // If index is desired, use next argument.
      if (desiredIndices.isWrtParameter(i)) {
        useNextArgument();
      }
      // Otherwise, construct and use a zero argument.
      else {
        auto zeroSILType =
            linearMapType->getParameters()[mapOriginalParameterIndex(i)]
                .getSILStorageInterfaceType();
        buildZeroArgument(zeroSILType);
      }
    }
    break;
  }
  // Pullback arguments are:
  // - An interleaving of:
  //   - Thunk indirect results (when parameter index is in both desired and
  //     actual indices).
  //   - Zeros (when parameter is not in desired indices).
  // - All actual arguments.
  case AutoDiffDerivativeFunctionKind::VJP: {
    auto toIndirectResultsIter = thunk->getIndirectResults().begin();
    auto useNextResult = [&]() {
      arguments.push_back(*toIndirectResultsIter++);
    };
    // Iterate over actual indices.
    for (unsigned i : actualIndices.parameters->getIndices()) {
      auto resultInfo =
          linearMapType->getResults()[mapOriginalParameterIndex(i)];
      // Skip direct results. Only indirect results are relevant as arguments.
      if (resultInfo.isFormalDirect())
        continue;
      // If index is desired, use next indirect result.
      if (desiredIndices.isWrtParameter(i)) {
        useNextResult();
        continue;
      }
      // Otherwise, construct and use an uninitialized indirect result.
      auto *indirectResult =
          builder.createAllocStack(loc, resultInfo.getSILStorageInterfaceType());
      localAllocations.push_back(indirectResult);
      arguments.push_back(indirectResult);
    }
    // Foward all actual non-indirect-result arguments.
    arguments.append(thunk->getArgumentsWithoutIndirectResults().begin(),
                     thunk->getArgumentsWithoutIndirectResults().end() - 1);
    break;
  }
  }

  // Get the linear map thunk argument and apply it.
  auto *linearMap = thunk->getArguments().back();
  auto *ai = builder.createApply(
      loc, linearMap, SubstitutionMap(), arguments, /*isNonThrowing*/ false);

  // If differential thunk, deallocate local allocations and directly return
  // `apply` result.
  if (kind == AutoDiffDerivativeFunctionKind::JVP) {
    for (auto *alloc : llvm::reverse(localAllocations))
      builder.createDeallocStack(loc, alloc);
    builder.createReturn(loc, ai);
    return {thunk, interfaceSubs};
  }

  // If pullback thunk, return only the desired results and clean up the
  // undesired results.
  SmallVector<SILValue, 8> pullbackDirectResults;
  extractAllElements(ai, builder, pullbackDirectResults);
  SmallVector<SILValue, 8> allResults;
  collectAllActualResultsInTypeOrder(ai, pullbackDirectResults, allResults);

  SmallVector<SILValue, 8> results;
  for (unsigned i : actualIndices.parameters->getIndices()) {
    // If result is desired:
    // - Do nothing if result is indirect.
    //   (It was already forwarded to the `apply` instruction).
    // - Push it to `results` if result is direct.
    auto result = allResults[mapOriginalParameterIndex(i)];
    if (desiredIndices.isWrtParameter(i)) {
      if (result->getType().isObject())
        results.push_back(result);
    }
    // Otherwise, cleanup the unused results.
    else {
      if (result->getType().isAddress())
        builder.emitDestroyAddrAndFold(loc, result);
      else
        builder.emitDestroyValueOperation(loc, result);
    }
  }
  // Deallocate local allocations and return final direct result.
  for (auto *alloc : llvm::reverse(localAllocations))
    builder.createDeallocStack(loc, alloc);
  auto result = joinElements(results, builder, loc);
  builder.createReturn(loc, result);

  context.recordGeneratedFunction(thunk);
  return {thunk, interfaceSubs};
}

std::pair<SILFunction *, SubstitutionMap>
DifferentiationTransformer::getOrCreateSubsetParametersThunkForDerivativeFunction(
    SILValue origFnOperand, SILValue derivativeFn,
    AutoDiffDerivativeFunctionKind kind, SILAutoDiffIndices desiredIndices,
    SILAutoDiffIndices actualIndices) {
  LLVM_DEBUG(getADDebugStream()
             << "Getting a subset parameters thunk for derivative function "
             << derivativeFn << " of the original function " << origFnOperand
             << " from " << actualIndices << " to " << desiredIndices << '\n');

  auto origFnType = origFnOperand->getType().castTo<SILFunctionType>();
  auto &module = context.getModule();
  auto lookupConformance = LookUpConformanceInModule(module.getSwiftModule());

  // Compute target type for thunking.
  auto derivativeFnType = derivativeFn->getType().castTo<SILFunctionType>();
  auto targetType = origFnType->getAutoDiffDerivativeFunctionType(
      desiredIndices.parameters, desiredIndices.source, kind, module.Types,
      lookupConformance);
  auto *caller = derivativeFn->getFunction();
  if (targetType->hasArchetype()) {
    auto substTargetType = caller->mapTypeIntoContext(
        targetType->mapTypeOutOfContext())->getCanonicalType();
    targetType = SILType::getPrimitiveObjectType(substTargetType)
        .castTo<SILFunctionType>();
  }
  assert(derivativeFnType->getNumParameters() == targetType->getNumParameters());
  assert(derivativeFnType->getNumResults() == targetType->getNumResults());

  // Build thunk type.
  SubstitutionMap interfaceSubs;
  GenericEnvironment *genericEnv = nullptr;
  auto thunkType = buildThunkType(
      derivativeFn->getFunction(), derivativeFnType, targetType, genericEnv,
      interfaceSubs, /*withoutActuallyEscaping*/ false,
      DifferentiationThunkKind::IndexSubset);

  // FIXME: The logic for resolving `assocRef` does not reapply function
  // conversions, which is problematic if `derivativeFn` is a `partial_apply`
  // instruction.
  StringRef origName;
  if (auto *origFnRef =
          peerThroughFunctionConversions<FunctionRefInst>(origFnOperand)) {
    origName = origFnRef->getInitiallyReferencedFunction()->getName();
  } else if (auto *origMethodInst =
                 peerThroughFunctionConversions<MethodInst>(origFnOperand)) {
    origName = origMethodInst->getMember().getAnyFunctionRef()
        ->getAbstractFunctionDecl()->getNameStr();
  }
  assert(!origName.empty() && "Original function name could not be resolved");
  // TODO(TF-685): Use more principled mangling for thunks.
  std::string thunkName;
  switch (kind) {
    case AutoDiffDerivativeFunctionKind::JVP:
      thunkName = "jvp";
      break;
    case AutoDiffDerivativeFunctionKind::VJP:
      thunkName = "vjp";
  }
  Mangle::ASTMangler mangler;
  auto fromInterfaceType =
      derivativeFnType->mapTypeOutOfContext()->getCanonicalType();
  auto toInterfaceType = targetType->mapTypeOutOfContext()->getCanonicalType();
  CanType dynamicSelfType;
  thunkName = "AD__orig_" + origName.str() + "_" +
      mangler.mangleReabstractionThunkHelper(
          thunkType, fromInterfaceType, toInterfaceType, dynamicSelfType,
          module.getSwiftModule()) + "_" + desiredIndices.mangle() + "_" +
          thunkName;
  thunkName += "_subset_parameters_thunk";

  auto loc = origFnOperand.getLoc();
  SILOptFunctionBuilder fb(context.getTransform());
  auto *thunk = fb.getOrCreateSharedFunction(
      loc, thunkName, thunkType, IsBare, IsTransparent, caller->isSerialized(),
      ProfileCounter(), IsThunk, IsNotDynamic);

  if (!thunk->empty())
    return {thunk, interfaceSubs};

  thunk->setOwnershipEliminated();
  thunk->setGenericEnvironment(genericEnv);
  auto *entry = thunk->createBasicBlock();
  SILBuilder builder(entry);
  createEntryArguments(thunk);

  SubstitutionMap assocSubstMap;
  if (auto *partialApply = dyn_cast<PartialApplyInst>(derivativeFn))
    assocSubstMap = partialApply->getSubstitutionMap();

  // FIXME: The logic for resolving `assocRef` does not reapply function
  // conversions, which is problematic if `derivativeFn` is a `partial_apply`
  // instruction.
  SILValue assocRef;
  if (auto *derivativeFnRef =
          peerThroughFunctionConversions<FunctionRefInst>(derivativeFn)) {
    auto *assoc = derivativeFnRef->getReferencedFunctionOrNull();
    assocRef = builder.createFunctionRef(loc, assoc);
  } else if (auto *assocMethodInst =
                 peerThroughFunctionConversions<WitnessMethodInst>(derivativeFn)) {
    assocRef = builder.createWitnessMethod(
        loc, assocMethodInst->getLookupType(),
        assocMethodInst->getConformance(), assocMethodInst->getMember(),
        thunk->mapTypeIntoContext(assocMethodInst->getType()));
  } else if (auto *assocMethodInst =
                 peerThroughFunctionConversions<ClassMethodInst>(derivativeFn)) {
    auto classOperand = thunk->getArgumentsWithoutIndirectResults().back();
    auto classOperandType = assocMethodInst->getOperand()->getType();
    assert(classOperand->getType() == classOperandType);
    assocRef = builder.createClassMethod(
        loc, classOperand, assocMethodInst->getMember(),
        thunk->mapTypeIntoContext(assocMethodInst->getType()));
  } else if (auto *diffWitFn = peerThroughFunctionConversions<
                 DifferentiabilityWitnessFunctionInst>(derivativeFn)) {
    assocRef = builder.createDifferentiabilityWitnessFunction(
        loc, diffWitFn->getWitnessKind(), diffWitFn->getWitness());
  }
  assert(assocRef && "Expected derivative function to be resolved");

  assocSubstMap = assocSubstMap.subst(thunk->getForwardingSubstitutionMap());
  derivativeFnType = assocRef->getType().castTo<SILFunctionType>();

  SmallVector<SILValue, 4> arguments;
  arguments.append(thunk->getArguments().begin(), thunk->getArguments().end());
  assert(arguments.size() == derivativeFnType->getNumParameters() +
                                 derivativeFnType->getNumIndirectFormalResults());
  auto *apply = builder.createApply(
      loc, assocRef, assocSubstMap, arguments, /*isNonThrowing*/ false);

  // Extract all direct results.
  SmallVector<SILValue, 8> directResults;
  extractAllElements(apply, builder, directResults);
  auto originalDirectResults = ArrayRef<SILValue>(directResults).drop_back(1);
  auto originalDirectResult =
      joinElements(originalDirectResults, builder, apply->getLoc());
  auto linearMap = directResults.back();

  auto linearMapType = linearMap->getType().castTo<SILFunctionType>();
  auto linearMapTargetType = targetType->getResults().back().getSILStorageInterfaceType()
      .castTo<SILFunctionType>();

  SILFunction *linearMapThunk;
  SubstitutionMap linearMapSubs;
  std::tie(linearMapThunk, linearMapSubs) =
      getOrCreateSubsetParametersThunkForLinearMap(
          thunk, linearMapType, linearMapTargetType, kind,
          desiredIndices, actualIndices);

  auto *linearMapThunkFRI = builder.createFunctionRef(loc, linearMapThunk);
  auto *thunkedLinearMap = builder.createPartialApply(
      loc, linearMapThunkFRI, linearMapSubs, {linearMap},
      ParameterConvention::Direct_Guaranteed);

  assert(origFnType->getResults().size() == 1);
  if (origFnType->getResults().front().isFormalDirect()) {
    auto result = joinElements(
        {originalDirectResult, thunkedLinearMap}, builder, loc);
    builder.createReturn(loc, result);
  } else {
    builder.createReturn(loc, thunkedLinearMap);
  }

  context.recordGeneratedFunction(thunk);
  return {thunk, interfaceSubs};
}

SILValue DifferentiationTransformer::promoteToDifferentiableFunction(
    DifferentiableFunctionInst *dfi, SILBuilder &builder, SILLocation loc,
    DifferentiationInvoker invoker) {
  auto origFnOperand = dfi->getOriginalFunction();
  auto origFnTy = origFnOperand->getType().castTo<SILFunctionType>();
  auto parameterIndices = dfi->getParameterIndices();
  unsigned resultIndex = context.getResultIndex(dfi);

  // Handle curry thunk applications specially.
  if (auto *ai = dyn_cast<ApplyInst>(origFnOperand)) {
    if (auto *thunkRef = dyn_cast<FunctionRefInst>(ai->getCallee())) {
      // Create a new curry thunk.
      SILAutoDiffIndices desiredIndices(resultIndex, parameterIndices);
      auto *thunk = thunkRef->getReferencedFunctionOrNull();
      // TODO(TF-685): Use more principled mangling for thunks.
      auto newThunkName = "AD__" + thunk->getName().str() +
          "__differentiable_curry_thunk_" + desiredIndices.mangle();

      auto thunkTy = thunk->getLoweredFunctionType();
      auto thunkResult = thunkTy->getSingleResult();
      if (auto resultFnTy = thunkResult.getInterfaceType()->getAs<SILFunctionType>()) {
        // Construct new curry thunk type with `@differentiable` result.
        auto diffableResultFnTy = resultFnTy->getWithExtInfo(
            resultFnTy->getExtInfo()
                .withDifferentiabilityKind(DifferentiabilityKind::Normal));
        auto newThunkResult = thunkResult.getWithInterfaceType(diffableResultFnTy);
        auto thunkType = SILFunctionType::get(
            thunkTy->getSubstGenericSignature(), thunkTy->getExtInfo(),
            thunkTy->getCoroutineKind(), thunkTy->getCalleeConvention(),
            thunkTy->getParameters(), {}, {newThunkResult}, {},
            thunkTy->getSubstitutions(), thunkTy->isGenericSignatureImplied(),
            thunkTy->getASTContext());

        // Construct new curry thunk, returning a `@differentiable` function.
        SILOptFunctionBuilder fb(transform);
        auto *newThunk = fb.getOrCreateFunction(
            loc, newThunkName,
            getSpecializedLinkage(thunk, thunk->getLinkage()), thunkType,
            thunk->isBare(), thunk->isTransparent(), thunk->isSerialized(),
            thunk->isDynamicallyReplaceable(), ProfileCounter(),
            thunk->isThunk());
        // If new thunk is newly created: clone the old thunk body, wrap the
        // returned function value with an `differentiable_function`
        // instruction, and process the `differentiable_function` instruction.
        if (newThunk->empty()) {
          if (auto newThunkGenSig = thunkType->getSubstGenericSignature())
            newThunk->setGenericEnvironment(
                newThunkGenSig->getGenericEnvironment());
          newThunk->setOwnershipEliminated();
          BasicTypeSubstCloner cloner(thunk, newThunk);
          cloner.run();
          auto *retInst =
              cast<ReturnInst>(newThunk->findReturnBB()->getTerminator());
          SILBuilder thunkBuilder(retInst);
          auto *dfi = context.createDifferentiableFunction(thunkBuilder, loc,
                                                   parameterIndices,
                                                   retInst->getOperand());
          context.setResultIndex(dfi, resultIndex);
          thunkBuilder.createReturn(loc, dfi);
          retInst->eraseFromParent();

          context.recordGeneratedFunction(newThunk);
          context.addDifferentiableFunctionInstToWorklist(dfi);
          if (processDifferentiableFunctionInst(dfi))
            return nullptr;
        }

        // Apply the new curry thunk.
        auto *newThunkRef = builder.createFunctionRef(loc, newThunk);
        context.recordGeneratedFunctionReference(newThunkRef);
        SmallVector<SILValue, 8> newArgs;
        SmallVector<SILValue, 8> newArgsToDestroy;
        SmallVector<AllocStackInst *, 1> newBuffersToDealloc;
        copyParameterArgumentsForApply(ai, newArgs, newArgsToDestroy,
                                       newBuffersToDealloc);
        auto *newApply = builder.createApply(
            ai->getLoc(), newThunkRef, ai->getSubstitutionMap(), newArgs,
            ai->isNonThrowing());
        for (auto arg : newArgsToDestroy) {
          if (arg->getType().isObject())
            builder.emitDestroyValueOperation(loc, arg);
          else
            builder.emitDestroyAddr(loc, arg);
        }
        for (auto *alloc : newBuffersToDealloc)
          builder.createDeallocStack(loc, alloc);
        return newApply;
      }
    }
  }

  SILAutoDiffIndices desiredIndices(resultIndex, parameterIndices);
  SmallVector<SILValue, 2> derivativeFns;
  SmallVector<AllocStackInst *, 2> newBuffersToDealloc;
  for (auto derivativeFnKind : {AutoDiffDerivativeFunctionKind::JVP,
                           AutoDiffDerivativeFunctionKind::VJP}) {
    auto derivativeFnAndIndices = emitDerivativeFunctionReference(
        *this, builder, desiredIndices, derivativeFnKind, origFnOperand, invoker,
        newBuffersToDealloc);
    // Show an error at the operator, highlight the argument, and show a note
    // at the definition site of the argument.
    if (!derivativeFnAndIndices)
      return nullptr;

    auto derivativeFn = derivativeFnAndIndices->first;
    context.recordGeneratedFunctionReference(derivativeFn);

    // If desired indices are a subset of actual indices, create a "subset
    // indices thunk" and destroy the emitted derivative function reference.
    // - For JVPs: the thunked JVP returns a differential taking fewer
    //   parameters (using `.zero` for the dropped parameters).
    // - For VJPs: the thunked VJP returns a pullback that drops the unused
    //   tangent values.
    auto actualIndices = derivativeFnAndIndices->second;
    // NOTE: `desiredIndices` may come from a partially-applied function and
    // have smaller capacity than `actualIndices`. We expect this logic to go
    // away when we support `@differentiable` partial apply.
    // if (actualIndices != desiredIndices) { // TODO: Re-enable.
    auto extendedDesiredIndices = desiredIndices.parameters->extendingCapacity(
        context.getASTContext(), actualIndices.parameters->getCapacity());
    if (actualIndices.source != desiredIndices.source ||
        !actualIndices.parameters->equals(extendedDesiredIndices)) {
      // Destroy the already emitted derivative function reference because it
      // is no longer used.
      builder.emitDestroyValueOperation(loc, derivativeFn);
      // Check if underlying original function reference has been partially
      // applied with arguments. If so, produce an error: parameter subset
      // thunks do not yet support this case because partially applied arguments
      // cannot be propagated to parameter subset thunks.
      auto didPartiallyApplyArguments = [](SILValue original) {
        while (auto *pai =
                   peerThroughFunctionConversions<PartialApplyInst>(original)) {
          if (pai->getNumArguments() > 0)
            return true;
          original = pai->getCallee();
        }
        return false;
      };
      if (didPartiallyApplyArguments(origFnOperand)) {
        context.emitNondifferentiabilityError(
            origFnOperand, invoker,
            diag::autodiff_cannot_param_subset_thunk_partially_applied_orig_fn);
        return nullptr;
      }
      // Create the parameter subset thunk.
      assert(actualIndices.parameters->isSupersetOf(extendedDesiredIndices));
      SILFunction *thunk;
      SubstitutionMap interfaceSubs;
      std::tie(thunk, interfaceSubs) =
          getOrCreateSubsetParametersThunkForDerivativeFunction(
              origFnOperand, derivativeFn, derivativeFnKind, desiredIndices,
              actualIndices);
      auto *thunkFRI = builder.createFunctionRef(loc, thunk);
      if (auto genSig =
              thunk->getLoweredFunctionType()->getSubstGenericSignature()) {
        derivativeFn = builder.createPartialApply(
            loc, thunkFRI, interfaceSubs, {},
            ParameterConvention::Direct_Guaranteed);
      } else {
        derivativeFn = thunkFRI;
      }
    }
    auto expectedDerivativeFnTy = origFnTy->getAutoDiffDerivativeFunctionType(
        parameterIndices, resultIndex, derivativeFnKind, context.getTypeConverter(),
        LookUpConformanceInModule(context.getModule().getSwiftModule()));
    // If `derivativeFn` is `@convention(thin)` but is expected to be
    // `@convention(thick)`, emit a `thin_to_thick` instruction.
    if (expectedDerivativeFnTy->getRepresentation()
            == SILFunctionTypeRepresentation::Thick &&
        derivativeFn->getType().castTo<SILFunctionType>()->getRepresentation()
            == SILFunctionTypeRepresentation::Thin) {
      derivativeFn = builder.createThinToThickFunction(
          loc, derivativeFn, SILType::getPrimitiveObjectType(expectedDerivativeFnTy));
    }

    derivativeFns.push_back(derivativeFn);
  }
  // Deallocate temporary buffers used for creating derivative functions.
  for (auto *buf : llvm::reverse(newBuffersToDealloc))
    builder.createDeallocStack(loc, buf);

  auto origFnCopy = builder.emitCopyValueOperation(loc, origFnOperand);
  auto *newDFI = context.createDifferentiableFunction(
      builder, loc, parameterIndices, origFnCopy,
      std::make_pair(derivativeFns[0], derivativeFns[1]));
  context.setResultIndex(dfi, resultIndex);
  context.addDifferentiableFunctionInstToWorklist(dfi);

  return newDFI;
}

/// Fold `differentiable_function_extract` users of the given
/// `differentiable_function` instruction, directly replacing them with
/// `differentiable_function` instruction operands. If the
/// `differentiable_function` instruction has no remaining uses, delete the
/// instruction itself after folding.
///
/// Folding can be disabled by the `SkipFoldingDifferentiableFunctionExtraction`
/// flag for SIL testing purposes.
// FIXME: This function is not correctly detecting the foldable pattern and
// needs to be rewritten.
void DifferentiationTransformer::foldDifferentiableFunctionExtraction(
    DifferentiableFunctionInst *source) {
  // Iterate through all `differentiable_function` instruction uses.
  for (auto use : source->getUses()) {
    auto *dfei = dyn_cast<DifferentiableFunctionExtractInst>(use->getUser());
    // If user is not an `differentiable_function_extract` instruction, set flag
    // to false.
    if (!dfei)
      continue;
    // Fold original function extractors.
    if (dfei->getExtractee() ==
            NormalDifferentiableFunctionTypeComponent::Original) {
      auto originalFnValue = source->getOriginalFunction();
      dfei->replaceAllUsesWith(originalFnValue);
      dfei->eraseFromParent();
      continue;
    }
    // Fold derivative function extractors.
    auto derivativeFnValue =
        source->getDerivativeFunction(dfei->getDerivativeFunctionKind());
    dfei->replaceAllUsesWith(derivativeFnValue);
    dfei->eraseFromParent();
  }
  // If the `differentiable_function` instruction has no remaining uses, erase
  // it.
  if (isInstructionTriviallyDead(source)) {
    SILBuilder builder(source);
    builder.emitDestroyAddrAndFold(source->getLoc(), source->getJVPFunction());
    builder.emitDestroyAddrAndFold(source->getLoc(), source->getVJPFunction());
    source->eraseFromParent();
  }
  // Mark `source` as processed so that it won't be reprocessed after deletion.
  context.markDifferentiableFunctionInstAsProcessed(source);
}

bool DifferentiationTransformer::processDifferentiableFunctionInst(
    DifferentiableFunctionInst *dfi) {
  PrettyStackTraceSILNode dfiTrace("canonicalizing `differentiable_function`",
                                   cast<SILInstruction>(dfi));
  PrettyStackTraceSILFunction fnTrace("...in", dfi->getFunction());
  LLVM_DEBUG({
    auto &s = getADDebugStream() << "Processing DifferentiableFunctionInst:\n";
    dfi->printInContext(s);
  });

  // If `dfi` already has derivative functions, do not process.
  if (dfi->hasDerivativeFunctions())
    return false;

  SILFunction *parent = dfi->getFunction();
  auto loc = dfi->getLoc();
  SILBuilder builder(dfi);
  auto differentiableFnValue =
      promoteToDifferentiableFunction(dfi, builder, loc, dfi);
  // Mark `dfi` as processed so that it won't be reprocessed after deletion.
  context.markDifferentiableFunctionInstAsProcessed(dfi);
  if (!differentiableFnValue)
    return true;
  // Replace all uses of `dfi`.
  dfi->replaceAllUsesWith(differentiableFnValue);
  // Destroy the original operand.
  builder.emitDestroyValueOperation(loc, dfi->getOriginalFunction());
  dfi->eraseFromParent();
  // If the promoted `@differentiable` function-typed value is an
  // `differentiable_function` instruction, fold
  // `differentiable_function_extract` instructions. If
  // `differentiable_function_extract` folding is disabled, return.
  if (!SkipFoldingDifferentiableFunctionExtraction)
    if (auto *newDFI =
            dyn_cast<DifferentiableFunctionInst>(differentiableFnValue))
      foldDifferentiableFunctionExtraction(newDFI);
  transform.invalidateAnalysis(
      parent, SILAnalysis::InvalidationKind::FunctionBody);
  return false;
}

/// AD pass entry.
void Differentiation::run() {
  auto &module = *getModule();
  auto &astCtx = module.getASTContext();
  debugDump(module);

  // A transformation helper.
  DifferentiationTransformer transformer(*this);
  ADContext &context = transformer.getContext();

  bool errorOccurred = false;

  // Register all the `SILDifferentiabilityWitness`es in the module that trigger
  // differentiation.
  for (auto &witness : module.getDifferentiabilityWitnesses()) {
    if (witness.isDeclaration())
      continue;

    context.addInvoker(&witness);
  }

  // Register all the `differentiable_function` instructions in the module that
  // trigger differentiation.
  for (SILFunction &f : module) {
    for (SILBasicBlock &bb : f) {
      for (SILInstruction &i : bb) {
        if (auto *dfi = dyn_cast<DifferentiableFunctionInst>(&i))
          context.addDifferentiableFunctionInstToWorklist(dfi);
        // Reject uncanonical `linear_function` instructions.
        // FIXME(SR-11850): Add support for linear map transposition.
        else if (auto *lfi = dyn_cast<LinearFunctionInst>(&i)) {
          if (!lfi->hasTransposeFunction()) {
            astCtx.Diags.diagnose(
                lfi->getLoc().getSourceLoc(),
                diag::autodiff_conversion_to_linear_function_not_supported);
            errorOccurred = true;
          }
        }
      }
    }
  }

  // If nothing has triggered differentiation, there's nothing to do.
  if (context.getInvokers().empty() &&
      context.isDifferentiableFunctionInstsWorklistEmpty())
    return;

  // AD relies on stdlib (the Swift module). If it's not imported, it's an
  // internal error.
  if (!astCtx.getStdlibModule()) {
    astCtx.Diags.diagnose(SourceLoc(),
                          diag::autodiff_internal_swift_not_imported);
    return;
  }

  // Process all invokers.
  for (auto invokerPair : context.getInvokers()) {
    auto *witness = invokerPair.first;
    auto *original = witness->getOriginalFunction();
    auto invoker = invokerPair.second;

    if (transformer.canonicalizeDifferentiabilityWitness(
            original, witness, invoker, original->isSerialized()))
      errorOccurred = true;
  }

  // Iteratively process `differentiable_function` instruction worklist.
  while (auto *dfi = context.popDifferentiableFunctionInstFromWorklist()) {
    // Skip instructions that have been already been processed.
    if (context.isDifferentiableFunctionInstProcessed(dfi)) continue;
    errorOccurred |= transformer.processDifferentiableFunctionInst(dfi);
  }

  // If any error occurred while processing witnesses or
  // `differentiable_function` instructions, clean up.
  if (errorOccurred) {
    context.cleanUp();
    return;
  }

  LLVM_DEBUG(getADDebugStream() << "All differentiation finished\n");
}

//===----------------------------------------------------------------------===//
// Pass creation
//===----------------------------------------------------------------------===//

SILTransform *swift::createDifferentiation() {
  return new Differentiation;
}
