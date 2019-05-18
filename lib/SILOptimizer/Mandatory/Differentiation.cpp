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
// This file implements reverse-mode automatic differentiation.
//
// NOTE: Although the AD feature is developed as part of the Swift for
// TensorFlow project, it is completely independent from TensorFlow support.
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "differentiation"

#include "swift/AST/AnyFunctionRef.h"
#include "swift/AST/ASTMangler.h"
#include "swift/AST/ASTPrinter.h"
#include "swift/AST/AutoDiff.h"
#include "swift/AST/Builtins.h"
#include "swift/AST/DeclContext.h"
#include "swift/AST/DiagnosticsSIL.h"
#include "swift/AST/Expr.h"
#include "swift/AST/GenericEnvironment.h"
#include "swift/AST/GenericSignatureBuilder.h"
#include "swift/AST/Module.h"
#include "swift/AST/ParameterList.h"
#include "swift/AST/SubstitutionMap.h"
#include "swift/SIL/FormalLinkage.h"
#include "swift/SIL/LoopInfo.h"
#include "swift/SIL/Projection.h"
#include "swift/SIL/SILBuilder.h"
#include "swift/SIL/TypeSubstCloner.h"
#include "swift/SILOptimizer/Analysis/DominanceAnalysis.h"
#include "swift/SILOptimizer/Analysis/LoopAnalysis.h"
#include "swift/SILOptimizer/PassManager/Passes.h"
#include "swift/SILOptimizer/PassManager/Transforms.h"
#include "swift/SILOptimizer/Utils/Local.h"
#include "swift/SILOptimizer/Utils/LoopUtils.h"
#include "swift/SILOptimizer/Utils/SILOptFunctionBuilder.h"
#include "llvm/ADT/APSInt.h"
#include "llvm/ADT/BreadthFirstIterator.h"
#include "llvm/ADT/DenseSet.h"

using namespace swift;
using llvm::DenseMap;
using llvm::SmallDenseMap;
using llvm::SmallDenseSet;
using llvm::SmallSet;

// This flag is used to disable `autodiff_function_extract` instruction folding
// for SIL testing purposes.
static llvm::cl::opt<bool> SkipFoldingAutoDiffFunctionExtraction(
    "differentiation-skip-folding-autodiff-function-extraction",
    llvm::cl::init(false));

//===----------------------------------------------------------------------===//
// Helpers
//===----------------------------------------------------------------------===//

/// Prints an "[AD] " prefix to `llvm::dbgs()` and returns the debug stream.
/// This is being used to print short debug messages within the AD pass.
static raw_ostream &getADDebugStream() { return llvm::dbgs() << "[AD] "; }

/// Given a dumpable value, dumps it to `llvm::dbgs()`.
template <typename T> static inline void debugDump(T &v) {
  LLVM_DEBUG(llvm::dbgs() << "\n==== BEGIN DEBUG DUMP ====\n"
                          << v << "\n==== END DEBUG DUMP ====\n");
}

/// Creates arguments in the entry block based on the function type.
static void createEntryArguments(SILFunction *f) {
  auto *entry = f->getEntryBlock();
  auto conv = f->getConventions();
  auto &ctx = f->getASTContext();
  auto moduleDecl = f->getModule().getSwiftModule();
  assert((entry->getNumArguments() == 0 || conv.getNumSILArguments() == 0) &&
         "Entry already has arguments?!");
  auto createFunctionArgument = [&](SILType type) {
    // Create a dummy parameter declaration.
    // Necessary to prevent crash during argument explosion optimization.
    auto loc = f->getLocation().getSourceLoc();
    auto *decl = new (ctx)
        ParamDecl(VarDecl::Specifier::Default, loc, loc, Identifier(), loc,
                  Identifier(), moduleDecl);
    decl->setType(type.getASTType());
    entry->createFunctionArgument(type, decl);
  };
  for (auto indResTy : conv.getIndirectSILResultTypes())
    createFunctionArgument(f->mapTypeIntoContext(indResTy).getAddressType());
  for (auto paramTy : conv.getParameterSILTypes())
    createFunctionArgument(f->mapTypeIntoContext(paramTy));
}

static bool isWithoutDerivative(SILValue v) {
  if (auto *fnRef = dyn_cast<FunctionRefInst>(v))
    return fnRef->getReferencedFunction()->hasSemanticsAttr(
        "autodiff.nonvarying");
  return false;
}

/// Given a function, gather all of its formal results (both direct and
/// indirect) in an order defined by its result type. Note that "formal results"
/// refer to result values in the body of the function, not at call sites.
static void
collectAllFormalResultsInTypeOrder(SILFunction &function,
                                   SmallVectorImpl<SILValue> &results) {
  SILFunctionConventions convs(function.getLoweredFunctionType(),
                               function.getModule());
  auto indResults = function.getIndirectResults();
  auto *retInst = cast<ReturnInst>(function.findReturnBB()->getTerminator());
  auto retVal = retInst->getOperand();
  SmallVector<SILValue, 8> dirResults;
  if (auto *tupleInst =
          dyn_cast_or_null<TupleInst>(retVal->getDefiningInstruction()))
    dirResults.append(tupleInst->getElements().begin(),
                      tupleInst->getElements().end());
  else
    dirResults.push_back(retVal);
  unsigned indResIdx = 0, dirResIdx = 0;
  for (auto &resInfo : convs.getResults())
    results.push_back(resInfo.isFormalDirect() ? dirResults[dirResIdx++]
                                               : indResults[indResIdx++]);
}

/// Given a function call site, gather all of its actual results (both direct
/// and indirect) in an order defined by its result type.
template <typename IndResRange>
static void collectAllActualResultsInTypeOrder(
    ApplyInst *ai, ArrayRef<SILValue> extractedDirectResults,
    IndResRange &&indirectResults, SmallVectorImpl<SILValue> &results) {
  auto callee = ai->getCallee();
  SILFunctionConventions calleeConvs(
      callee->getType().castTo<SILFunctionType>(), ai->getModule());
  unsigned indResIdx = 0, dirResIdx = 0;
  for (auto &resInfo : calleeConvs.getResults()) {
    results.push_back(resInfo.isFormalDirect()
                          ? extractedDirectResults[dirResIdx++]
                          : indirectResults[indResIdx++]);
  }
}

/// Given a range of types, joins these into a single type. If there's exactly
/// one element type, returns that element type. Otherwise, creates a tuple type
/// of all element types.
template <typename TypeRange>
static CanType joinElementTypes(TypeRange &&range, const ASTContext &ctx) {
  if (range.size() == 1)
    return range.front();
  auto typeElts =
      map<SmallVector<TupleTypeElt, 8>>(range, [&](Type type) { return type; });
  return TupleType::get(typeElts, ctx);
}

/// Given a range of SIL values, retrieves the canonical types of these values,
/// and joins these types into a single type.
template <typename SILValueRange>
static CanType joinElementTypesFromValues(SILValueRange &&range,
                                          const ASTContext &ctx) {
  if (range.size() == 1)
    return range.front()->getType().getASTType();
  SmallVector<TupleTypeElt, 8> elts;
  transform(range, elts.begin(),
            [&](SILValue val) { return val->getType().getASTType(); });
  return TupleType::get(elts, ctx)->getCanonicalType();
}

/// Given an operator name, such as '+', and a protocol, returns the '+'
/// operator. If the operator does not exist in the protocol, returns null.
static FuncDecl *findOperatorDeclInProtocol(DeclName operatorName,
                                            ProtocolDecl *protocol) {
  assert(operatorName.isOperator());
  // Find the operator requirement in the `VectorNumeric` protocol
  // declaration and cache it.
  auto opLookup = protocol->lookupDirect(operatorName);
  // Find the `+` with type siguature `(Self, Self) -> Self`.
  for (auto *decl : opLookup) {
    auto *fd = dyn_cast<FuncDecl>(decl);
    if (!fd || !fd->isStatic() || !fd->isOperator())
      continue;
    return fd;
  }
  // Not found.
  return nullptr;
}

/// Assuming the buffer is for indirect passing, returns the store ownership
/// qualifier for creating a `store` instruction into the buffer.
static StoreOwnershipQualifier getBufferSOQ(Type type, SILFunction &fn) {
  if (fn.hasOwnership())
    return fn.getModule().Types.getTypeLowering(
        type, ResilienceExpansion::Minimal).isTrivial()
            ? StoreOwnershipQualifier::Trivial
            : StoreOwnershipQualifier::Init;
  return StoreOwnershipQualifier::Unqualified;
}

/// Assuming the buffer is for indirect passing, returns the load ownership
/// qualified for creating a `load` instruction from the buffer.
static LoadOwnershipQualifier getBufferLOQ(Type type, SILFunction &fn) {
  if (fn.hasOwnership())
    return fn.getModule().Types.getTypeLowering(
        type, ResilienceExpansion::Minimal).isTrivial()
            ? LoadOwnershipQualifier::Trivial
            : LoadOwnershipQualifier::Take;
  return LoadOwnershipQualifier::Unqualified;
}

// Return the expected generic signature for autodiff associated functions given
// a SILDifferentiableAttr. The expected generic signature is built from the
// original generic signature and the attribute's requirements.
static CanGenericSignature
getAssociatedFunctionGenericSignature(SILDifferentiableAttr *attr,
                                      SILFunction *original) {
  auto originalGenSig =
      original->getLoweredFunctionType()->getGenericSignature();
  if (!originalGenSig)
    return nullptr;
  GenericSignatureBuilder builder(original->getASTContext());
  // Add original generic signature.
  builder.addGenericSignature(originalGenSig);
  // Add where clause requirements.
  auto source =
      GenericSignatureBuilder::FloatingRequirementSource::forAbstract();
  for (auto &req : attr->getRequirements())
    builder.addRequirement(req, source, original->getModule().getSwiftModule());
  return std::move(builder)
      .computeGenericSignature(SourceLoc(), /*allowConcreteGenericParams=*/true)
      ->getCanonicalSignature();
}

// Clone the generic parameters of the given generic signature and return a new
// `GenericParamList`.
static GenericParamList *cloneGenericParameters(ASTContext &ctx,
                                                DeclContext *dc,
                                                CanGenericSignature sig) {
  SmallVector<GenericTypeParamDecl *, 2> clonedParams;
  for (auto paramType : sig->getGenericParams()) {
    auto clonedParam = new (ctx) GenericTypeParamDecl(dc, paramType->getName(),
                                                      SourceLoc(),
                                                      paramType->getDepth(),
                                                      paramType->getIndex());
    clonedParam->setDeclContext(dc);
    clonedParam->setImplicit(true);
    clonedParams.push_back(clonedParam);
  }
  return GenericParamList::create(ctx, SourceLoc(), clonedParams, SourceLoc());
}

static ReturnInst *getSingleReturn(SILFunction *f) {
  return cast<ReturnInst>(f->findReturnBB()->getTerminator());
}

/// Given an `autodiff_function` instruction, find the corresponding
/// differential operator used in the AST. If no differential operator is found,
/// return nullptr.
static AutoDiffFunctionExpr *
findDifferentialOperator(AutoDiffFunctionInst *inst) {
  return inst->getLoc().getAsASTNode<AutoDiffFunctionExpr>();
}

/// Returns the underlying instruction for the given SILValue, if it exists,
/// peering through function conversion instructions.
template<class Inst>
static Inst *peerThroughFunctionConversions(SILValue value) {
  if (auto *inst = dyn_cast<Inst>(value))
    return inst;
  if (auto *thinToThick = dyn_cast<ThinToThickFunctionInst>(value))
    return peerThroughFunctionConversions<Inst>(thinToThick->getOperand());
  if (auto *convertFn = dyn_cast<ConvertFunctionInst>(value))
    return peerThroughFunctionConversions<Inst>(convertFn->getOperand());
  if (auto *convertFn = dyn_cast<ConvertEscapeToNoEscapeInst>(value))
    return peerThroughFunctionConversions<Inst>(convertFn->getOperand());
  if (auto *partialApply = dyn_cast<PartialApplyInst>(value))
    return peerThroughFunctionConversions<Inst>(partialApply->getCallee());
  return nullptr;
}

//===----------------------------------------------------------------------===//
// Auxiliary data structures
//===----------------------------------------------------------------------===//

namespace {
class ADContext;

/// The invoker of a differentiation task. It can be some user syntax, e.g.
/// `AutoDiffFunctionExpr` expression, the differentiation pass, or nothing at
/// all. This will be used to emit informative diagnostics.
struct DifferentiationInvoker {
public:
  /// The kind of the invoker of a differentiation task.
  enum class Kind {
    // No known invoker. This is the case when the differentiation is requested
    // from SIL source via a `autodiff_function` instruction **without** being
    // linked to a Swift AST node.
    AutoDiffFunctionInst,

    // Invoked by the indirect application of differentiation. This case has an
    // associated original `apply` instruction and `[differentiable]` attribute.
    IndirectDifferentiation,

    // Invoked by function conversion from a non-differentiable function to a
    // differentiable one. The corresponding AST node is an
    // `AutoDiffFunctionExpr`.
    // TODO(TF-505): Remove this case and merge into `AutoDiffFunctionInst`.
    FunctionConversion,

    // Invoker by a `[differentiable]` attribute in SIL **without** being linked
    // to a Swift AST attribute. This case has an associated `[differentiable]`
    // attribute.
    SILDifferentiableAttribute
  };

private:
  Kind kind;
  union Value {
    /// The instruction associated with the `AutoDiffFunctionInst` case.
    AutoDiffFunctionInst *adFuncInst;
    Value(AutoDiffFunctionInst *inst) : adFuncInst(inst) {}

    /// The parent `apply` instruction and `[differentiable]` attribute
    /// associated with the `IndirectDifferentiation` case.
    std::pair<ApplyInst *, SILDifferentiableAttr *>
        indirectDifferentiation;
    Value(ApplyInst *applyInst, SILDifferentiableAttr *attr)
        : indirectDifferentiation({applyInst, attr}) {}

    /// The conversion expression associated with the `FunctionConversion` case.
    AutoDiffFunctionExpr *functionConversion;
    Value(AutoDiffFunctionExpr *expr) : functionConversion(expr) {}

    /// The `[differentiable]` attribute associated with the
    /// `SILDifferentiableAttribute` case.
    SILDifferentiableAttr *silDifferentiableAttribute;
    Value(SILDifferentiableAttr *attr) : silDifferentiableAttribute(attr) {}
  } value;

  /*implicit*/
  DifferentiationInvoker(Kind kind, Value value) : kind(kind), value(value) {}

public:
  DifferentiationInvoker(AutoDiffFunctionInst *inst)
      : kind(Kind::AutoDiffFunctionInst), value(inst) {}
  DifferentiationInvoker(ApplyInst *applyInst, SILDifferentiableAttr *attr)
      : kind(Kind::IndirectDifferentiation),
        value({applyInst, attr}) {}
  DifferentiationInvoker(AutoDiffFunctionExpr *expr)
      : kind(Kind::FunctionConversion), value(expr) {}
  DifferentiationInvoker(SILDifferentiableAttr *attr)
      : kind(Kind::SILDifferentiableAttribute), value(attr) {}

  Kind getKind() const { return kind; }

  AutoDiffFunctionInst *getAutoDiffFunctionInst() const {
    assert(kind == Kind::AutoDiffFunctionInst);
    return value.adFuncInst;
  }

  std::pair<ApplyInst *, SILDifferentiableAttr *>
  getIndirectDifferentiation() const {
    assert(kind == Kind::IndirectDifferentiation);
    return value.indirectDifferentiation;
  }

  AutoDiffFunctionExpr *getFunctionConversion() const {
    assert(kind == Kind::FunctionConversion);
    return value.functionConversion;
  }

  SILDifferentiableAttr *getSILDifferentiableAttribute() const {
    assert(kind == Kind::SILDifferentiableAttribute);
    return value.silDifferentiableAttribute;
  }

  SourceLoc getLocation() const {
    switch (kind) {
    case Kind::AutoDiffFunctionInst:
      return getAutoDiffFunctionInst()->getLoc().getSourceLoc();
    case Kind::IndirectDifferentiation:
      return getIndirectDifferentiation().first->getLoc().getSourceLoc();
    case Kind::FunctionConversion:
      return getFunctionConversion()->getLoc();
    case Kind::SILDifferentiableAttribute:
      return getSILDifferentiableAttribute()->getOriginal()
          ->getLocation().getSourceLoc();
    }
  }

  void print(llvm::raw_ostream &os) const;
};

/// Information about the VJP function produced by VJPGen, e.g. mappings from
/// the original values to their corresponding ones in the primal value struct
/// produced by the VJP function.
///
/// A primal value struct is an aggregate value containing intermediate values
/// checkpointed during the primal computation. During VJPGen, such a struct
/// will be generated for each function being differentiated, and each primal
/// function will return such a struct value for the adjoint function to
/// consume.
class PrimalInfo {
private:
  /// The primal value struct declaration.
  StructDecl *primalValueStruct = nullptr;

  /// Mapping from `apply` and `struct_extract` instructions in the original
  /// function to the corresponding pullback decl in the primal struct.
  DenseMap<SILInstruction *, VarDecl *> pullbackValueMap;

private:
  VarDecl *addVarDecl(StringRef name, Type type) {
    auto &ctx = primalValueStruct->getASTContext();
    auto id = ctx.getIdentifier(name);
    auto *varDecl = new (ctx) VarDecl(
        /*IsStatic*/ false, VarDecl::Specifier::Var,
        /*IsCaptureList*/ false, SourceLoc(), id, primalValueStruct);
    varDecl->setAccess(primalValueStruct->getEffectiveAccess());
    if (type->hasArchetype())
      varDecl->setInterfaceType(type->mapTypeOutOfContext());
    else
      varDecl->setInterfaceType(type);
    primalValueStruct->addMember(varDecl);
    return varDecl;
  }

public:
  PrimalInfo(const PrimalInfo &) = delete;
  PrimalInfo &operator=(const PrimalInfo &) = delete;

  explicit PrimalInfo(StructDecl *primalValueStruct)
      : primalValueStruct(&*primalValueStruct) {}

  /// Returns the primal value struct that the primal info is established
  /// around.
  StructDecl *getPrimalValueStruct() const { return primalValueStruct; }

  /// Add a pullback to the primal value struct.
  VarDecl *addPullbackDecl(SILInstruction *inst, SILType pullbackType) {
    // IRGen requires decls to have AST types (not `SILFunctionType`), so we
    // convert the `SILFunctionType` of the pullback to a `FunctionType` with
    // the same parameters and results.
    auto silFnTy = pullbackType.castTo<SILFunctionType>();
    SmallVector<AnyFunctionType::Param, 8> params;
    for (auto &param : silFnTy->getParameters())
      params.push_back(AnyFunctionType::Param(param.getType()));
    AnyFunctionType *astFnTy;
    if (auto genSig = silFnTy->getGenericSignature())
      astFnTy = GenericFunctionType::get(
          genSig, params, silFnTy->getAllResultsType().getASTType());
    else
      astFnTy = FunctionType::get(
          params, silFnTy->getAllResultsType().getASTType());

    auto *decl = addVarDecl("pullback_" + llvm::itostr(pullbackValueMap.size()),
                            astFnTy);
    pullbackValueMap.insert({inst, decl});
    return decl;
  }

  /// Finds the pullback decl in the primal value struct for an `apply` or
  /// `struct_extract` in the original function.
  VarDecl *lookUpPullbackDecl(SILInstruction *inst) {
    auto lookup = pullbackValueMap.find(inst);
    return lookup == pullbackValueMap.end() ? nullptr
                                            : lookup->getSecond();
  }
};

/// Stores `apply` instruction information calculated by `PrimalGen`.
struct NestedApplyInfo {
  /// The differentiation indices that are used to differentiate this `apply`
  /// instruction.
  SILAutoDiffIndices indices;
  /// The original pullback type before reabstraction. `None` if the pullback
  /// type is not reabstracted.
  Optional<CanSILFunctionType> originalPullbackType;
};

/// Specifies how we should differentiate a `struct_extract` instruction.
enum class StructExtractDifferentiationStrategy {
  // The `struct_extract` is not active, so do not differentiate it.
  Inactive,

  // The `struct_extract` is extracting a field from a Differentiable struct
  // with @_fieldwiseProductSpace tangent space. Therefore, differentiate the
  // `struct_extract` by setting the adjoint to a vector in the tangent space
  // that is zero except along the direction of the corresponding field.
  //
  // Fields correspond by matching name.
  Fieldwise,

  // Differentiate the `struct_extract` by looking up the corresponding getter
  // and using its VJP.
  Getter
};

static inline llvm::raw_ostream &operator<<(llvm::raw_ostream &os,
                                            DifferentiationInvoker invoker) {
  invoker.print(os);
  return os;
}

void DifferentiationInvoker::print(llvm::raw_ostream &os) const {
  os << "(differentiation_invoker ";
  switch (kind) {
  case Kind::AutoDiffFunctionInst:
    os << "autodiff_function_inst=(" << *getAutoDiffFunctionInst() << ")";
    break;
  case Kind::IndirectDifferentiation: {
    auto indDiff = getIndirectDifferentiation();
    os << "indirect_differentiation=(" << *std::get<0>(indDiff) << ')';
    // TODO: Enable printing parent invokers.
    // May require storing a `DifferentiableInvoker *` in the
    // `IndirectDifferentiation` case.
    /*
    SILInstruction *inst;
    SILDifferentiableAttr *attr;
    std::tie(inst, attr) = getIndirectDifferentiation();
    auto invokerLookup = invokers.find(attr); // No access to ADContext?
    assert(invokerLookup != invokers.end() && "Expected parent invoker");
    */
    break;
  }
  case Kind::FunctionConversion: {
    StreamPrinter printer(os);
    PrintOptions options;
    os << "differential_operator=(";
    getFunctionConversion()->print(printer, options);
    os << ')';
    break;
  }
  case Kind::SILDifferentiableAttribute: {
    auto diffAttr = getSILDifferentiableAttribute();
    os << "sil_differentiable_attribute=(attr=(";
    diffAttr->print(os);
    os << ") function=" << diffAttr->getOriginal()->getName();
    break;
  }
  }
  os << ')';
}

// Check whether the given requirements are satisfied, with the given
// subsitution map and in the given module.
static bool checkRequirementsSatisfied(
    ArrayRef<Requirement> requirements, SubstitutionMap substMap,
    ModuleDecl *swiftModule) {
  if (requirements.empty())
    return true;
  // Jointly iterate through associated function requirements/conformances.
  // Check whether all requirements are satisfied.
  auto *genSig = substMap.getGenericSignature();
  GenericSignatureBuilder builder(swiftModule->getASTContext());
  builder.addGenericSignature(genSig);
  auto source =
  GenericSignatureBuilder::FloatingRequirementSource::forAbstract();
  // builder.addRequirement(req, source, nullptr);
  for (auto req : requirements)
    builder.addRequirement(req, source, swiftModule);
  llvm::errs() << "BUILT NEW GEN SIG\n";
  auto *newGenSig = std::move(builder).computeGenericSignature(
      SourceLoc(), /*allowConcreteGenericParams=*/true);
  newGenSig->dump();
  
  SmallVector<Requirement, 2> unsatisfiedRequirements;
  for (auto req : requirements) {
    llvm::errs() << "\nNEW REQ\n";
    req.dump();
    auto firstType = req.getFirstType();
    auto secondType = req.getSecondType();
    switch (req.getKind()) {
    // Check same type requirements.
    case RequirementKind::SameType: {
      if (auto origFirstType = firstType.subst(substMap))
        firstType = origFirstType;
      if (auto origSecondType = secondType.subst(substMap))
        secondType = origSecondType;
      // If the second type is a dependent member type, try to resolve it
      // using the first type as the base type.
      // TODO: Add checks verifying that first type can be the base type.
      if (auto depMemType = secondType->getAs<DependentMemberType>()) {
        if (!firstType->hasTypeParameter())
          if (auto substType = depMemType->substBaseType(
                  firstType, LookUpConformanceInModule(swiftModule)))
            secondType = substType->getCanonicalType();
      }
      if (!firstType->isEqual(secondType))
        unsatisfiedRequirements.push_back(req);
      continue;
    }
    // Check conformance requirements.
    case RequirementKind::Conformance: {
      auto protocolType = req.getSecondType()->castTo<ProtocolType>();
      auto protocol = protocolType->getDecl();
      assert(protocol && "Expected protocol in generic signature requirement");
      // Try substituting requirement type using original substutition map.
      // If the result type is known to conform to protocol in the current
      // module, continue.
      // This handles cases where the primal caller is non-generic
      // (specialized with concrete types) but the associated derivative
      // callee is generic.
      llvm::errs() << "FIRST TYPE\n";
      firstType.dump();
      llvm::errs() << "SECOND TYPE\n";
      secondType.dump();
      llvm::errs() << "SUBST MAP\n";
      substMap.dump();


      if (auto depMemType = firstType->getAs<DependentMemberType>()) {
        if (auto substType = depMemType->substBaseType(
                firstType, LookUpConformanceInModule(swiftModule)))
          secondType = substType->getCanonicalType();
      }
      /*
      if (!firstType->hasUnboundGenericType()) {
        llvm::errs() << "YAY WE FOUND CONCRETE FIRST TYPE\n";
      }
      */
      // firstType->hasUnboundGenericType()
      for (auto type : substMap.getReplacementTypes()) {
        llvm::errs() << "SUBST MAP REPLACEMENT TYPE\n";
        type->dump();
      }
      if (auto origFirstType = firstType.subst(substMap)) {
        llvm::errs() << "ORIG FIRST TYPE\n";
        origFirstType.dump();
        llvm::errs() << "LOOK UP CONFORMANCE!\n";
        // swiftModule->lookupConformance(origFirstType, protocol)->dump();
        // substMap.lookupConformance(origFirstType->getCanonicalType(), protocol)->dump();
        if (!origFirstType->hasError() &&
            swiftModule->lookupConformance(origFirstType, protocol)) {
          continue;
        }
        if (!origFirstType->hasError() &&
            substMap.lookupConformance(origFirstType->getCanonicalType(), protocol)) {
          continue;
        }
      } else {
        llvm::errs() << "NO ORIG FIRST TYPE, UH OH\n";
      }
      llvm::errs() << "FAILING REQUIREMENT\n";
      auto conf = swiftModule->lookupConformance(firstType->getCanonicalType(),
                                                 protocol);
      llvm::errs() << "SWIFT MODULE REQ? " << (bool) conf << "\n";
      if (conf)
        conf->dump();

      // Otherwise, try to look up conformance in substitution maps.
      if (newGenSig->lookupConformance(firstType->getCanonicalType(),
                                       protocol)) {
        continue;
      }
      if (swiftModule->lookupConformance(firstType->getCanonicalType(),
                                         protocol)) {
        continue;
      }
      auto isConformanceMet = substMap.lookupConformance(
          firstType->getCanonicalType(), protocol);
      if (!isConformanceMet)
        unsatisfiedRequirements.push_back(req);
      continue;
    }
    // Ignore other requirements (superclass and layout).
    default:
      continue;
    }
  }
  // Diagnose unsatisfied requirements.
  for (auto req : unsatisfiedRequirements) {
    LLVM_DEBUG(auto &s = getADDebugStream() << "Unsatisfied requirement:\n";
               req.print(s, PrintOptions());
               s << '\n');
  }
  return unsatisfiedRequirements.empty();
}

//===----------------------------------------------------------------------===//
// ADContext - Per-module contextual information for the Differentiation pass.
//===----------------------------------------------------------------------===//

class ADContext {
private:
  /// Reference to the main transform.
  SILModuleTransform &transform;

  /// The module where Differentiation is performed on.
  SILModule &module;

  /// AST context.
  ASTContext &astCtx = module.getASTContext();

  /// Shared pass manager.
  SILPassManager &passManager;

  /// The worklist (stack) of `autodiff_function` instructions to be processed.
  SmallVector<AutoDiffFunctionInst *, 32> autoDiffFunctionInsts;

  /// Mapping from `[differentiable]` attributes to invokers.
  DenseMap<SILDifferentiableAttr *, DifferentiationInvoker> invokers;

  /// Mapping from `autodiff_function` instructions to result indices.
  DenseMap<AutoDiffFunctionInst *, unsigned> resultIndices;

  /// Mapping from original `apply` instructions to their corresponding
  /// `NestedApplyInfo`s.
  DenseMap<ApplyInst *, NestedApplyInfo> nestedApplyInfo;

  /// Mapping from original `struct_extract` and `struct_element_addr`
  /// instructions to their strategies.
  DenseMap<SILInstruction *, StructExtractDifferentiationStrategy>
  structExtractDifferentiationStrategies;

  /// List of generated functions (JVPs, VJPs, adjoints, and thunks).
  /// Saved for deletion during cleanup.
  SmallVector<SILFunction *, 32> generatedFunctions;

  /// List of associated function references, generated via
  /// `emitAssociatedFunctionReference`.
  /// Saved for deletion during cleanup.
  SmallVector<SILValue, 32> generatedAssociatedFunctionReferences;

  /// The VectorNumeric protocol in the standard library.
  ProtocolDecl *vectorNumericProtocol =
      astCtx.getProtocol(KnownProtocolKind::VectorNumeric);
  /// The Numeric protocol in the standard library.
  ProtocolDecl *numericProtocol =
      astCtx.getProtocol(KnownProtocolKind::Numeric);
  /// The AdditiveArithmetic protocol in the standard library.
  ProtocolDecl *additiveArithmeticProtocol =
    astCtx.getProtocol(KnownProtocolKind::AdditiveArithmetic);
  /// The FloatingPoint protocol in the stanard library.
  ProtocolDecl *floatingPointProtocol =
      astCtx.getProtocol(KnownProtocolKind::FloatingPoint);

  /// `AdditiveArithmetic.+` declaration.
  mutable FuncDecl *cachedPlusFn = nullptr;
  /// `AdditiveArithmetic.+=` declaration.
  mutable FuncDecl *cachedPlusEqualFn = nullptr;

public:
  /// Construct an ADContext for the given module.
  explicit ADContext(SILModuleTransform &transform);

  SILModuleTransform &getTransform() const { return transform; }
  SILModule &getModule() const { return module; }
  ASTContext &getASTContext() const { return module.getASTContext(); }
  SILPassManager &getPassManager() const { return passManager; }
  Lowering::TypeConverter &getTypeConverter() { return module.Types; }

  SmallVectorImpl<AutoDiffFunctionInst *> &getAutoDiffFunctionInsts() {
    return autoDiffFunctionInsts;
  }

  DenseMap<SILDifferentiableAttr *, DifferentiationInvoker> &getInvokers() {
    return invokers;
  }

  DenseMap<AutoDiffFunctionInst *, unsigned> &getResultIndices() {
    return resultIndices;
  }

  DenseMap<ApplyInst *, NestedApplyInfo> &getNestedApplyInfo() {
    return nestedApplyInfo;
  }

  DenseMap<SILInstruction *, StructExtractDifferentiationStrategy>
  &getStructExtractDifferentiationStrategies() {
    return structExtractDifferentiationStrategies;
  }

  SmallVector<SILFunction *, 32> &getGeneratedFunctions() {
    return generatedFunctions;
  }

  SmallVector<SILValue, 32> &getGeneratedAssociatedFunctionReferences() {
    return generatedAssociatedFunctionReferences;
  }

  ProtocolDecl *getVectorNumericProtocol() const {
    return vectorNumericProtocol;
  }

  ProtocolDecl *getNumericProtocol() const {
    return numericProtocol;
  }

  ProtocolDecl *getAdditiveArithmeticProtocol() const {
    return additiveArithmeticProtocol;
  }

  ProtocolDecl *getFloatingPointProtocol() const {
    return floatingPointProtocol;
  }

  FuncDecl *getPlusDecl() const {
    if (!cachedPlusFn) {
      cachedPlusFn = findOperatorDeclInProtocol(
          astCtx.getIdentifier("+"), additiveArithmeticProtocol);
      assert(cachedPlusFn && "AdditiveArithmetic.+ not found");
    }
    return cachedPlusFn;
  }

  FuncDecl *getPlusEqualDecl() const {
    if (!cachedPlusEqualFn) {
      cachedPlusEqualFn = findOperatorDeclInProtocol(
          astCtx.getIdentifier("+="), additiveArithmeticProtocol);
      assert(cachedPlusEqualFn && "AdditiveArithmetic.+= not found");
    }
    return cachedPlusEqualFn;
  }

  void cleanUp() {
    for (auto invokerInfo : invokers) {
      auto *attr = invokerInfo.getFirst();
      auto *original = attr->getOriginal();
      LLVM_DEBUG(getADDebugStream()
                 << "Removing [differentiable] attribute for "
                 << original->getName() << '\n');
      original->removeDifferentiableAttr(attr);
    }
    // Delete all references to generated functions.
    for (auto assocFn : generatedAssociatedFunctionReferences) {
      if (auto *fnRef =
              peerThroughFunctionConversions<FunctionRefInst>(assocFn)) {
        LLVM_DEBUG(getADDebugStream()
                   << "Deleting generated associated function reference:\n"
                   << *fnRef);
        fnRef->replaceAllUsesWithUndef();
        fnRef->eraseFromParent();
      }
    }
    // Delete all generated functions.
    for (auto *generatedFunction : generatedFunctions) {
      LLVM_DEBUG(getADDebugStream()
                 << "Deleting generated function "
                 << generatedFunction->getName() << '\n');
      generatedFunction->dropAllReferences();
      transform.notifyWillDeleteFunction(generatedFunction);
      module.eraseFunction(generatedFunction);
    }
  }

  /// Retrieves the file unit that contains implicit declarations in the
  /// current Swift module. If it does not exist, create one.
  ///
  // FIXME: Currently it defaults to the file containing `origFn`, if it can be
  // determined. Otherwise, it defaults to any file unit in the module. To
  // handle this more properly, we should make a DerivedFileUnit class to
  // contain all synthesized implicit type declarations.
  SourceFile &getPrimalValueDeclContainer(SILFunction *origFn) {
    if (origFn->hasLocation())
      if (auto *declContext = origFn->getLocation().getAsDeclContext())
        if (auto *parentSourceFile = declContext->getParentSourceFile())
          return *parentSourceFile;
    for (auto *file : module.getSwiftModule()->getFiles())
      if (auto *src = dyn_cast<SourceFile>(file))
        return *src;
    llvm_unreachable("No files?");
  }

  /// Creates a struct declaration (without contents) for storing primal values
  /// of a function. The newly created struct will have the same generic
  /// signature as the given primal generic signature.
  StructDecl *createPrimalValueStruct(SILFunction *original,
                                      SILAutoDiffIndices indices,
                                      CanGenericSignature primalGenericSig);

  /// Finds the `[differentiable]` attribute on the specified original function
  /// corresponding to the specified parameter indices. Returns nullptr if it
  /// does not exist.
  SILDifferentiableAttr *lookUpDifferentiableAttr(
      SILFunction *original, const SILAutoDiffIndices &indices) const {
    for (auto *attr : original->getDifferentiableAttrs())
      if (attr->getIndices() == indices)
        return attr;
    return nullptr;
  }

  /// Finds the `[differentiable]` attribute on the specified original function
  /// corresponding to the specified parameter indices. Returns nullptr if it
  /// does not exist.
  SILDifferentiableAttr *lookUpMinimalDifferentiableAttr(
      SILFunction *original, const SILAutoDiffIndices &indices) const {
    auto *superset = AutoDiffIndexSubset::getDefault(
        getASTContext(),
        original->getLoweredFunctionType()->getNumParameters(), false);
    auto *indexSet = indices.parameters;
    if (auto *exactAttr = lookUpDifferentiableAttr(original, indices))
      return exactAttr;
    SILDifferentiableAttr *minimalAttr = nullptr;
    for (auto *rda : original->getDifferentiableAttrs()) {
      if (rda->getIndices().source != indices.source)
        continue;
      auto *rdaIndexSet = rda->getIndices().parameters;
      // If all indices in `indexSet` are in `rdaIndexSet`, and it has fewer
      // indices than our current candidate and a primitive VJP, then `rda` is
      // our new candidate.
      //
      // NOTE: `rda` may come from a un-partial-applied function and have larger
      // capacity than the desired indices. We expect this logic to go away when
      // we support `@differentiable` partial apply.
      if (rdaIndexSet->isSupersetOf(
              indexSet->extendingCapacity(getASTContext(),
                                          rdaIndexSet->getCapacity())) &&
          // fewer parameters than before
          (superset->isEmpty() ||
           rdaIndexSet->getNumIndices() < superset->getNumIndices())) {
        superset = rda->getIndices().parameters;
        minimalAttr = rda;
      }
    }
    return minimalAttr;
  }

  /// Creates a `[differentiable]` attribute on the specified original function
  /// with the specified parameter indices.
  SILDifferentiableAttr *createDifferentiableAttr(
      SILFunction *original, const SILAutoDiffIndices &indices,
      ArrayRef<Requirement> contextualRequirements) const {
    assert(!lookUpDifferentiableAttr(original, indices));
    auto *attr = SILDifferentiableAttr::create(getModule(), indices,
                                               contextualRequirements);
    original->addDifferentiableAttr(attr);
    return attr;
  }

  /// Finds or creates a `[differentiable]` attribute on the specified
  /// original function corresponding to the specified parameter indices.
  SILDifferentiableAttr *getOrCreateDifferentiableAttr(
      SILFunction *original, const SILAutoDiffIndices &indices,
      ArrayRef<Requirement> contextualRequirements) {
    if (auto *attr = lookUpDifferentiableAttr(original, indices))
      return attr;
    assert(original->isDefinition());
    return createDifferentiableAttr(original, indices, contextualRequirements);
  }

private:
  /// Promotes the given `autodiff_function` instruction to a valid
  /// `@differentiable` function-typed value.
  SILValue promoteToDifferentiableFunction(
      AutoDiffFunctionInst *inst, SILBuilder &builder, SILLocation loc,
      DifferentiationInvoker invoker);

public:
  /// Process the given `[differentiable]` attribute, filling in JVP/VJPs if
  /// missing.
  bool processDifferentiableAttribute(
      SILFunction *original, SILDifferentiableAttr *attr,
      DifferentiationInvoker invoker);

  /// Process the given `autodiff_function` instruction, filling in missing
  /// associated functions if necessary.
  bool processAutoDiffFunctionInst(AutoDiffFunctionInst *adfi);

  /// Get or create an associated function index subset thunk from
  /// `actualIndices` to `desiredIndices` for the given associated function
  /// value and original function operand.
  /// Calls `getOrCreateSubsetParametersThunkForLinearMap` to thunk the linear
  /// map returned by the associated function.
  std::pair<SILFunction *, SubstitutionMap>
  getOrCreateSubsetParametersThunkForAssociatedFunction(
      SILValue origFnOperand, SILValue assocFn,
      AutoDiffAssociatedFunctionKind kind, SILAutoDiffIndices desiredIndices,
      SILAutoDiffIndices actualIndices);

  /// Get or create an associated function index subset thunk from
  /// `actualIndices` to `desiredIndices` for the given associated function
  /// value and original function operand.
  SILFunction *getOrCreateSubsetParametersThunkForLinearMap(
      SILFunction *assocFn, CanSILFunctionType linearMapType,
      CanSILFunctionType targetType, AutoDiffAssociatedFunctionKind kind,
      SILAutoDiffIndices desiredIndices, SILAutoDiffIndices actualIndices);

public:
  /// Declare an external reference to an associated function of `original`,
  /// given a `[differentiable]` attribute of `original` and the associated
  /// function kind.
  SILFunction *
  declareExternalAssociatedFunction(SILFunction *original,
                                    SILDifferentiableAttr *attr, StringRef name,
                                    AutoDiffAssociatedFunctionKind kind);

  template <typename... T, typename... U>
  InFlightDiagnostic diagnose(SourceLoc loc, Diag<T...> diag,
                              U &&... args) const {
    return getASTContext().Diags.diagnose(loc, diag, std::forward<U>(args)...);
  }

  /// Given an instruction and a differentiation task associated with the
  /// parent function, emits a "not differentiable" error based on the task. If
  /// the task is indirect, emits notes all the way up to the outermost task,
  /// and emits an error at the outer task. Otherwise, emits an error directly.
  InFlightDiagnostic emitNondifferentiabilityError(
      SILInstruction *inst, DifferentiationInvoker invoker,
      Optional<Diag<>> diag = None);

  /// Given a value and a differentiation task associated with the parent
  /// function, emits a "not differentiable" error based on the task. If the
  /// task is indirect, emits notes all the way up to the outermost task, and
  /// emits an error at the outer task. Otherwise, emits an error directly.
  InFlightDiagnostic emitNondifferentiabilityError(
      SILValue value, DifferentiationInvoker invoker,
      Optional<Diag<>> diag = None);

  /// Emit a "not differentiable" error based on the given differentiation task
  /// and diagnostic.
  InFlightDiagnostic emitNondifferentiabilityError(
      SourceLoc loc, DifferentiationInvoker invoker,
      Optional<Diag<>> diag = None);
};
} // end anonymous namespace

ADContext::ADContext(SILModuleTransform &transform)
    : transform(transform), module(*transform.getModule()),
      passManager(*transform.getPassManager()) {}

InFlightDiagnostic
ADContext::emitNondifferentiabilityError(SILValue value,
                                         DifferentiationInvoker invoker,
                                         Optional<Diag<>> diag) {
  LLVM_DEBUG({
    getADDebugStream() << "Diagnosing non-differentiability.\n";
    getADDebugStream() << "For value:\n" << value;
    getADDebugStream() << "With invoker:\n" << invoker << '\n';
  });
  auto valueLoc = value.getLoc().getSourceLoc();
  return emitNondifferentiabilityError(valueLoc, invoker, diag);
}

InFlightDiagnostic
ADContext::emitNondifferentiabilityError(SILInstruction *inst,
                                         DifferentiationInvoker invoker,
                                         Optional<Diag<>> diag) {
  LLVM_DEBUG({
    getADDebugStream() << "Diagnosing non-differentiability.\n";
    getADDebugStream() << "For instruction:\n" << *inst;
    getADDebugStream() << "With invoker:\n" << invoker << '\n';
  });
  auto instLoc = inst->getLoc().getSourceLoc();
  return emitNondifferentiabilityError(instLoc, invoker, diag);
}

InFlightDiagnostic
ADContext::emitNondifferentiabilityError(SourceLoc loc,
                                         DifferentiationInvoker invoker,
                                         Optional<Diag<>> diag) {
  switch (invoker.getKind()) {
  // For `autodiff_function` instructions: if the `autodiff_function`
  // instruction comes from a differential operator, emit an error on the
  // expression and a note on the non-differentiable operation. Otherwise, emit
  // both an error and note on the non-differentiation operation.
  case DifferentiationInvoker::Kind::AutoDiffFunctionInst: {
    auto *inst = invoker.getAutoDiffFunctionInst();
    if (auto *expr = findDifferentialOperator(inst)) {
      diagnose(expr->getLoc(), diag::autodiff_function_not_differentiable_error)
          .highlight(expr->getSubExpr()->getSourceRange());
      return diagnose(loc,
          diag.getValueOr(diag::autodiff_expression_not_differentiable_note));
    }
    diagnose(loc, diag::autodiff_expression_not_differentiable_error);
    return diagnose(loc,
        diag.getValueOr(diag::autodiff_expression_not_differentiable_note));
  }

  // For `[differentiable]` attributes, try to find an AST function declaration
  // and `@differentiable` attribute. If they are found, emit an error on the
  // `@differentiable` attribute; otherwise, emit an error on the SIL function.
  // Emit a note at the non-differentiable operation.
  case DifferentiationInvoker::Kind::SILDifferentiableAttribute: {
    auto *attr = invoker.getSILDifferentiableAttribute();
    auto *original = attr->getOriginal();
    bool foundAttr = false;
    if (auto *declContext = original->getDeclContext()) {
      if (auto *fnDecl = declContext->getInnermostDeclarationDeclContext()) {
        if (auto *diffAttr =
                fnDecl->getAttrs().getAttribute<DifferentiableAttr>()) {
          diagnose(diffAttr->getLocation(),
                   diag::autodiff_function_not_differentiable_error)
              .highlight(diffAttr->getRangeWithAt());
          diagnose(original->getLocation().getSourceLoc(),
                   diag::autodiff_when_differentiating_function_definition);
          foundAttr = true;
        }
      }
    }
    // Fallback if we cannot find the expected attribute.
    if (!foundAttr)
      diagnose(original->getLocation().getSourceLoc(),
               diag::autodiff_function_not_differentiable_error);
    return diagnose(loc,
        diag.getValueOr(diag::autodiff_expression_not_differentiable_note));
  }

  // For indirect differentiation, emit a "not differentiable" note on the
  // expression first. Then emit an error at the source invoker of
  // differentiation, and a "when differentiating this" note at each indirect
  // invoker.
  case DifferentiationInvoker::Kind::IndirectDifferentiation: {
    SILInstruction *inst;
    SILDifferentiableAttr *attr;
    std::tie(inst, attr) = invoker.getIndirectDifferentiation();
    auto invokerLookup = invokers.find(attr);
    assert(invokerLookup != invokers.end() && "Expected parent invoker");
    emitNondifferentiabilityError(inst, invokerLookup->second, None);
    return diagnose(loc,
        diag.getValueOr(diag::autodiff_when_differentiating_function_call));
  }

  // For a function conversion, emit a "not differentiable" error on the
  // attribute first and a note on the non-differentiable operation.
  case DifferentiationInvoker::Kind::FunctionConversion: {
    auto *expr = invoker.getFunctionConversion();
    diagnose(expr->getLoc(), diag::autodiff_function_not_differentiable_error)
        .highlight(expr->getSubExpr()->getSourceRange());
    return diagnose(loc,
        diag.getValueOr(diag::autodiff_expression_not_differentiable_note));
  }
  }
}

//===----------------------------------------------------------------------===//
// Activity Analysis
//===----------------------------------------------------------------------===//

namespace {
class DifferentiableActivityCollection;

/// In many real situations, the end-users of AD need only the derivatives of
/// some selected outputs of `P` with respect to some selected inputs of `P`.
/// Whatever the differentiation mode (tangent, reverse,...), these restrictions
/// allow the AD tool to produce a much more efficient differentiated program.
/// Essentially, fixing some inputs and neglecting some outputs allows AD to
/// just forget about several intermediate differentiated variables.
///
/// Activity analysis is the specific analysis that detects these situations,
/// therefore allowing for a better differentiated code. Activity analysis is
/// present in all transformation-based AD tools.
///
/// To begin with, the end-user specifies that only some output variables (the
/// “dependent”) must be differentiated with respect to only some input
/// variables (the “independent”). We say that variable `y` depends on `x` when
/// the derivative of `y` with respect to `x` is not trivially null. We say that
/// a variable is “varied” if it depends on at least one independent. Conversely
/// we say that a variable is “useful” if at least one dependent depends on it.
/// Finally, we say that a variable is “active” if it is at the same time varied
/// and useful. In the special case of the tangent mode, it is easy to check
/// that when variable `v` is not varied at some place in the program, then its
/// derivative `v̇` at this place is certainly null. Conversely when variable `v`
/// is not useful, then whatever the value of `v̇`, this value does not matter
/// for the final result. Symmetric reasoning applies for the reverse mode of
/// AD: observing that differentiated variables go upstream, we see that a
/// useless variable has a null derivative, in other words the partial
/// derivative of the output with respect to this variable is null. Conversely
/// when variable `v` is not varied, then whatever the value of `v`, this value
/// does not matter for the final result.
///
/// Reference:
/// Laurent Hascoët. Automatic Differentiation by Program Transformation. 2007.
class DifferentiableActivityAnalysis
    : public FunctionAnalysisBase<DifferentiableActivityCollection> {
private:
  DominanceAnalysis *dominanceAnalysis = nullptr;
  PostDominanceAnalysis *postDominanceAnalysis = nullptr;

public:
  explicit DifferentiableActivityAnalysis()
      : FunctionAnalysisBase(SILAnalysisKind::DifferentiableActivity) {}

  static bool classof(const SILAnalysis *s) {
    return s->getKind() == SILAnalysisKind::DifferentiableActivity;
  }

  virtual bool shouldInvalidate(SILAnalysis::InvalidationKind k) override {
    return k & InvalidationKind::Everything;
  }

  virtual std::unique_ptr<DifferentiableActivityCollection>
  newFunctionAnalysis(SILFunction *f) override;

  virtual void initialize(SILPassManager *pm) override;
};
} // end anonymous namespace

namespace {
/// Represents the differentiation activity associated with a SIL value.
enum class ActivityFlags : unsigned {
  /// The value depends on a function parameter.
  Varied = 1 << 1,
  /// The value contributes to a result.
  Useful = 1 << 2,
  /// The value is both varied and useful.
  Active = Varied | Useful,
};

using Activity = OptionSet<ActivityFlags>;

/// Result of activity analysis on a function. Accepts queries for whether a
/// value is "varied", "useful" or "active" against certain differentiation
/// indices.
class DifferentiableActivityInfo {
private:
  DifferentiableActivityCollection &parent;
  GenericSignature *assocGenSig = nullptr;

  /// Input values, i.e. parameters (both direct and indirect).
  SmallVector<SILValue, 4> inputValues;
  /// Output values, i.e. individual values (not the final tuple) being returned
  /// by the `return` instruction.
  SmallVector<SILValue, 4> outputValues;

  /// The set of useful variables, indexed by the corresponding dependent value
  /// (output) index.
  SmallVector<SmallDenseSet<SILValue>, 4> usefulValueSets;
  /// The set of useful variables, indexed by the corresponding independent
  /// value (input) index.
  SmallVector<SmallDenseSet<SILValue>, 4> variedValueSets;

  /// The original function.
  SILFunction &getFunction();

  /// Perform analysis and populate sets.
  void analyze(DominanceInfo *di, PostDominanceInfo *pdi);

  void setVaried(SILValue value, unsigned independentVariableIndex);
  void setUseful(SILValue value, unsigned dependentVariableIndex);
  void recursivelySetVaried(SILValue value, unsigned independentVariableIndex);
  void propagateUsefulThroughBuffer(SILValue value,
                                    unsigned dependentVariableIndex);

public:
  explicit DifferentiableActivityInfo(
      DifferentiableActivityCollection &parent, GenericSignature *assocGenSig);

  bool isVaried(SILValue value, unsigned independentVariableIndex) const;
  bool isUseful(SILValue value, unsigned dependentVariableIndex) const;
  bool isVaried(SILValue value, AutoDiffIndexSubset *parameterIndices) const;
  bool isActive(SILValue value, const SILAutoDiffIndices &indices) const;

  Activity getActivity(SILValue value,
                       const SILAutoDiffIndices &indices) const;
  Activity getActivity(SILInstruction *inst,
                       const SILAutoDiffIndices &indices) const;
};

class DifferentiableActivityCollection {
public:
  SmallDenseMap<GenericSignature *, DifferentiableActivityInfo> activityInfoMap;
  SILFunction &function;
  DominanceInfo *domInfo;
  PostDominanceInfo *postDomInfo;

  DifferentiableActivityInfo &getActivityInfo(GenericSignature *assocGenSig) {
    auto activityInfoLookup = activityInfoMap.find(assocGenSig);
    if (activityInfoLookup != activityInfoMap.end())
      return activityInfoLookup->getSecond();
    auto insertion = activityInfoMap.insert(
        {assocGenSig, DifferentiableActivityInfo(*this, assocGenSig)});
    return insertion.first->getSecond();
  }

  explicit DifferentiableActivityCollection(SILFunction &f,
                                            DominanceInfo *di,
                                            PostDominanceInfo *pdi);
};

} // end anonymous namespace

std::unique_ptr<DifferentiableActivityCollection>
DifferentiableActivityAnalysis::newFunctionAnalysis(SILFunction *f) {
  assert(dominanceAnalysis && "Expect a valid dominance anaysis");
  assert(postDominanceAnalysis && "Expect a valid post-dominance anaysis");
  return llvm::make_unique<DifferentiableActivityCollection>(
      *f, dominanceAnalysis->get(f), postDominanceAnalysis->get(f));
}

void DifferentiableActivityAnalysis::initialize(SILPassManager *pm) {
  dominanceAnalysis = pm->getAnalysis<DominanceAnalysis>();
  postDominanceAnalysis = pm->getAnalysis<PostDominanceAnalysis>();
}

SILAnalysis *swift::createDifferentiableActivityAnalysis(SILModule *m) {
  return new DifferentiableActivityAnalysis();
}

DifferentiableActivityCollection::DifferentiableActivityCollection(
    SILFunction &f, DominanceInfo *di, PostDominanceInfo *pdi)
    : function(f), domInfo(di), postDomInfo(pdi) {}

DifferentiableActivityInfo::DifferentiableActivityInfo(
    DifferentiableActivityCollection &parent, GenericSignature *assocGenSig)
    : parent(parent), assocGenSig(assocGenSig) {
  analyze(parent.domInfo, parent.postDomInfo);
}

void DifferentiableActivityInfo::analyze(DominanceInfo *di,
                                         PostDominanceInfo *pdi) {
  auto &function = parent.function;
  LLVM_DEBUG(getADDebugStream()
             << "Running activity analysis on @" << function.getName() << '\n');
  // Inputs are just function's arguments, count `n`.
  auto paramArgs = function.getArgumentsWithoutIndirectResults();
  for (auto value : paramArgs)
    inputValues.push_back(value);
  LLVM_DEBUG({
    auto &s = getADDebugStream();
    s << "Inputs in @" << function.getName() << ":\n";
    for (auto val : inputValues)
      s << val << '\n';
  });
  // Outputs are indirect result buffers and return values, count `m`.
  collectAllFormalResultsInTypeOrder(function, outputValues);
  LLVM_DEBUG({
    auto &s = getADDebugStream();
    s << "Outputs in @" << function.getName() << ":\n";
    for (auto val : outputValues)
      s << val << '\n';
  });

  // Mark inputs as varied.
  assert(variedValueSets.empty());
  for (auto input : inputValues)
    variedValueSets.push_back({input});
  // Propagate varied-ness through the function in dominance order.
  DominanceOrder domOrder(function.getEntryBlock(), di);
  while (auto *block = domOrder.getNext()) {
    for (auto &inst : *block) {
      for (auto i : indices(inputValues)) {
        // Handle `apply`.
        if (auto *ai = dyn_cast<ApplyInst>(&inst)) {
          if (isWithoutDerivative(ai->getCallee()))
            continue;
          for (auto arg : ai->getArgumentsWithoutIndirectResults()) {
            if (isVaried(arg, i)) {
              for (auto indRes : ai->getIndirectSILResults())
                setVaried(indRes, i);
              for (auto dirRes : ai->getResults())
                setVaried(dirRes, i);
            }
          }
        }
        // Handle `store`.
        else if (auto *si = dyn_cast<StoreInst>(&inst)) {
          if (isVaried(si->getSrc(), i))
            recursivelySetVaried(si->getDest(), i);
        }
        // Handle `copy_addr`.
        else if (auto *cai = dyn_cast<CopyAddrInst>(&inst)) {
          if (isVaried(cai->getSrc(), i))
            recursivelySetVaried(cai->getDest(), i);
        }
        // Handle `tuple_element_addr`.
        else if (auto *teai = dyn_cast<TupleElementAddrInst>(&inst)) {
          if (isVaried(teai->getOperand(), i)) {
            auto projType = teai->getType().getASTType();
            if (assocGenSig && projType->hasArchetype())
              projType = assocGenSig->getCanonicalTypeInContext(
                  projType->mapTypeOutOfContext());
            if (projType->getAutoDiffAssociatedTangentSpace(
                LookUpConformanceInSignature(*assocGenSig)))
              setVaried(teai, i);
          }
        }

// Handle `struct_extract` and `struct_element_addr` instructions.
// - If the field is marked `@noDerivative` and belongs to a
//   `@_fieldwiseDifferentiable` struct, do not set the result as varied because
//   it is not in the set of differentiable variables.
// - Otherwise, propagate variedness from operand to result as usual.
#define PROPAGATE_VARIED_FOR_STRUCT_EXTRACTION(INST) \
  else if (auto *sei = dyn_cast<INST##Inst>(&inst)) { \
    if (isVaried(sei->getOperand(), i)) { \
      auto hasNoDeriv = sei->getField()->getAttrs() \
          .hasAttribute<NoDerivativeAttr>(); \
      auto structIsFieldwiseDiffable = sei->getStructDecl()->getAttrs() \
          .hasAttribute<FieldwiseDifferentiableAttr>(); \
      if (!(hasNoDeriv && structIsFieldwiseDiffable)) \
        setVaried(sei, i); \
    } \
  }
  PROPAGATE_VARIED_FOR_STRUCT_EXTRACTION(StructExtract)
  PROPAGATE_VARIED_FOR_STRUCT_EXTRACTION(StructElementAddr)
#undef VISIT_STRUCT_ELEMENT_INNS

        // Handle everything else.
        else {
          for (auto &op : inst.getAllOperands())
            if (isVaried(op.get(), i))
              for (auto result : inst.getResults())
                setVaried(result, i);
        }
      }
    }
    domOrder.pushChildren(block);
  }

  // Mark differentiable outputs as useful.
  assert(usefulValueSets.empty());
  for (auto output : outputValues) {
    usefulValueSets.push_back({});
    // If the output has an address type, propagate usefulness recursively.
    if (output->getType().isAddress())
      propagateUsefulThroughBuffer(output, usefulValueSets.size() - 1);
    // Otherwise, just mark the output as useful.
    else
      setUseful(output, usefulValueSets.size() - 1);
  }
  // Propagate usefulness through the function in post-dominance order.
  PostDominanceOrder postDomOrder(&*function.findReturnBB(), pdi);
  while (auto *block = postDomOrder.getNext()) {
    for (auto &inst : reversed(*block)) {
      for (auto i : indices(outputValues)) {
        // Handle indirect results in `apply`.
        if (auto *ai = dyn_cast<ApplyInst>(&inst)) {
          if (isWithoutDerivative(ai->getCallee()))
            continue;
          auto checkAndSetUseful = [&](SILValue res) {
            if (isUseful(res, i))
              for (auto arg : ai->getArgumentsWithoutIndirectResults())
                setUseful(arg, i);
          };
          for (auto dirRes : ai->getResults())
            checkAndSetUseful(dirRes);
          for (auto indRes : ai->getIndirectSILResults())
            checkAndSetUseful(indRes);
          auto paramInfos = ai->getSubstCalleeConv().getParameters();
          for (auto i : indices(paramInfos))
            if (paramInfos[i].isIndirectInOut())
              checkAndSetUseful(ai->getArgumentsWithoutIndirectResults()[i]);
        }
        // Handle `store`.
        else if (auto *si = dyn_cast<StoreInst>(&inst)) {
          if (isUseful(si->getDest(), i))
            setUseful(si->getSrc(), i);
        }
        // Handle `copy_addr`.
        else if (auto *cai = dyn_cast<CopyAddrInst>(&inst)) {
          if (isUseful(cai->getDest(), i))
            propagateUsefulThroughBuffer(cai->getSrc(), i);
        }
        // Handle reads.
        else if (inst.mayReadFromMemory()) {
          if (llvm::any_of(inst.getResults(),
                           [&](SILValue res) { return isUseful(res, i); }))
            for (auto &op : inst.getAllOperands())
              if (op.get()->getType().isAddress())
                propagateUsefulThroughBuffer(op.get(), i);
        }
        // Handle everything else.
        else {
          for (auto result : inst.getResults())
            if (isUseful(result, i))
              for (auto &op : inst.getAllOperands())
                setUseful(op.get(), i);
        }
      }
    }
    postDomOrder.pushChildren(block);
  }
}

void DifferentiableActivityInfo::setVaried(SILValue value,
                                           unsigned independentVariableIndex) {
  variedValueSets[independentVariableIndex].insert(value);
}

void DifferentiableActivityInfo::setUseful(SILValue value,
                                           unsigned dependentVariableIndex) {
  usefulValueSets[dependentVariableIndex].insert(value);
}

void DifferentiableActivityInfo::recursivelySetVaried(
    SILValue value, unsigned independentVariableIndex) {
  setVaried(value, independentVariableIndex);
  if (auto *inst = value->getDefiningInstruction())
    for (auto &op : inst->getAllOperands())
      recursivelySetVaried(op.get(), independentVariableIndex);
}

void DifferentiableActivityInfo::propagateUsefulThroughBuffer(
    SILValue value, unsigned dependentVariableIndex) {
  assert(value->getType().isAddress());
  // Check whether value is already useful to prevent infinite recursion.
  if (isUseful(value, dependentVariableIndex))
    return;
  setUseful(value, dependentVariableIndex);
  if (auto *inst = value->getDefiningInstruction())
    for (auto &operand : inst->getAllOperands())
      if (operand.get()->getType().isAddress())
        propagateUsefulThroughBuffer(operand.get(), dependentVariableIndex);
  // Recursively propagate usefulness through users that are projections or
  // `begin_access` instructions.
  for (auto use : value->getUses())
    for (auto res : use->getUser()->getResults())
      if (Projection::isAddressProjection(res) || isa<BeginAccessInst>(res))
        propagateUsefulThroughBuffer(res, dependentVariableIndex);
}

bool DifferentiableActivityInfo::isVaried(
    SILValue value, unsigned independentVariableIndex) const {
  auto &set = variedValueSets[independentVariableIndex];
  return set.count(value);
}

bool DifferentiableActivityInfo::isVaried(
    SILValue value, AutoDiffIndexSubset *parameterIndices) const {
  for (auto paramIdx : parameterIndices->getIndices())
    if (isVaried(value, paramIdx))
      return true;
  return false;
}

bool DifferentiableActivityInfo::isUseful(
    SILValue value, unsigned dependentVariableIndex) const {
  auto &set = usefulValueSets[dependentVariableIndex];
  return set.count(value);
}

bool DifferentiableActivityInfo::isActive(
    SILValue value, const SILAutoDiffIndices &indices) const {
  return isVaried(value, indices.parameters) && isUseful(value, indices.source);
}

Activity DifferentiableActivityInfo::getActivity(
    SILValue value, const SILAutoDiffIndices &indices) const {
  Activity activity;
  if (isVaried(value, indices.parameters))
    activity |= ActivityFlags::Varied;
  if (isUseful(value, indices.source))
    activity |= ActivityFlags::Useful;
  return activity;
}

Activity DifferentiableActivityInfo::getActivity(
    SILInstruction *inst, const SILAutoDiffIndices &indices) const {
  Activity activity;
  for (auto result : inst->getResults())
    activity |= getActivity(result, indices);
  return activity;
}

static void dumpActivityInfo(SILValue value,
                             const SILAutoDiffIndices &indices,
                             const DifferentiableActivityInfo &activityInfo,
                             llvm::raw_ostream &s = llvm::dbgs()) {
  s << '[';
  auto activity = activityInfo.getActivity(value, indices);
  switch (activity.toRaw()) {
  case 0: s << "NONE"; break;
  case (unsigned)ActivityFlags::Varied: s << "VARIED"; break;
  case (unsigned)ActivityFlags::Useful: s << "USEFUL"; break;
  case (unsigned)ActivityFlags::Active: s << "ACTIVE"; break;
  }
  s << "] " << value;
}

static void dumpActivityInfo(SILFunction &fn,
                             const SILAutoDiffIndices &indices,
                             DifferentiableActivityInfo &activityInfo,
                             llvm::raw_ostream &s = llvm::dbgs()) {
  s << "Activity info for " << fn.getName() << " at " << indices << '\n';
  for (auto &bb : fn) {
    for (auto *arg : bb.getArguments())
      dumpActivityInfo(arg, indices, activityInfo, s);
    for (auto &inst : bb)
      for (auto res : inst.getResults())
        dumpActivityInfo(res, indices, activityInfo, s);
  }
}

/// If the original function doesn't have a return, it cannot be differentiated.
static bool diagnoseNoReturn(ADContext &context, SILFunction *original,
                             DifferentiationInvoker invoker) {
  if (original->findReturnBB() != original->end())
    return false;
  context.emitNondifferentiabilityError(
      original->getLocation().getEndSourceLoc(), invoker,
      diag::autodiff_missing_return);
  return true;
}

/// If the original function in the differentiation task has more than one basic
/// blocks, emit a "control flow unsupported" error at appropriate source
/// locations. Returns true if error is emitted.
static bool diagnoseUnsupportedControlFlow(ADContext &context,
                                           SILFunction *original,
                                           DifferentiationInvoker invoker) {
  if (original->getBlocks().size() <= 1)
    return false;
  // Find any control flow node and diagnose.
  for (auto &bb : *original) {
    auto *term = bb.getTerminator();
    if (term->isBranch()) {
      context.emitNondifferentiabilityError(
          term, invoker, diag::autodiff_control_flow_not_supported);
      return true;
    }
  }
  return false;
}

//===----------------------------------------------------------------------===//
// Code emission utilities
//===----------------------------------------------------------------------===//

/// Given a value, collect all `tuple_extract` users in `result` if value is a
/// tuple. Otherwise, add the value directly to `result`.
static void collectAllExtractedElements(SILValue val,
                                        SmallVectorImpl<SILValue> &result) {
  if (auto tupleType = val->getType().getAs<TupleType>()) {
    result.resize(tupleType->getNumElements(), SILValue());
    for (auto *use : val->getUses())
      if (auto *tupleExtract = dyn_cast<TupleExtractInst>(use->getUser()))
        result[tupleExtract->getFieldNo()] = tupleExtract;
  }
  else
    result.push_back(val);
}

/// Given a value, extracts all elements to `result` from this value if it's a
/// tuple. Otherwise, add this value directly to `result`.
static void extractAllElements(SILValue val, SILBuilder &builder,
                               SmallVectorImpl<SILValue> &result) {
  if (auto tupleType = val->getType().getAs<TupleType>())
    for (auto i : range(tupleType->getNumElements()))
      result.push_back(builder.createTupleExtract(val.getLoc(), val, i));
  else
    result.push_back(val);
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

// Emits a release based on the value's type category (address or object).
static void emitCleanup(SILBuilder &builder, SILLocation loc, SILValue v) {
  if (v->getType().isAddress())
    builder.createDestroyAddr(loc, v);
  else
    builder.createReleaseValue(loc, v, builder.getDefaultAtomicity());
}

/// When a function value is used in an instruction (usually `apply`), there's
/// some conversion instruction in between, e.g. `thin_to_thick_function`. Given
/// a new function value and an old function value, this helper function
/// recursively converts the new function just like how the old function is
/// converted. If the new function's generic signature is specified, it is used
/// to create substitution maps for reapplied `partial_apply` instructions.
static SILValue
reapplyFunctionConversion(SILValue newFunc, SILValue oldFunc,
                          SILValue oldConvertedFunc, SILBuilder &builder,
                          SILLocation loc,
                          GenericSignature* newFuncGenSig = nullptr,
                          std::function<SILValue(SILValue)> substituteOperand =
                              [](SILValue v) { return v; }) {
  // If the old func is the new func, then there's no conversion.
  if (oldFunc == oldConvertedFunc)
    return newFunc;
  // Handle a few instruction cases.
  // thin_to_thick_function
  if (auto *tttfi = dyn_cast<ThinToThickFunctionInst>(oldConvertedFunc)) {
    auto innerNewFunc = reapplyFunctionConversion(
        newFunc, oldFunc, tttfi->getOperand(), builder, loc, newFuncGenSig,
        substituteOperand);
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
    for (auto arg : pai->getArguments())
      newArgs.push_back(substituteOperand(arg));
    auto innerNewFunc = reapplyFunctionConversion(
        newFunc, oldFunc, pai->getCallee(), builder, loc, newFuncGenSig,
        substituteOperand);
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
  // convert_escape_to_noescape
  if (auto *cetn = dyn_cast<ConvertEscapeToNoEscapeInst>(oldConvertedFunc)) {
    auto innerNewFunc = reapplyFunctionConversion(newFunc, oldFunc,
                                                  cetn->getOperand(), builder,
                                                  loc, newFuncGenSig,
                                                  substituteOperand);
    auto operandFnTy = innerNewFunc->getType().castTo<SILFunctionType>();
    auto noEscapeType = operandFnTy->getWithExtInfo(
        operandFnTy->getExtInfo().withNoEscape());
    auto silTy = SILType::getPrimitiveObjectType(noEscapeType);
    return builder.createConvertEscapeToNoEscape(
        loc, innerNewFunc, silTy,
        cetn->isLifetimeGuaranteed());
  }
  // convert_function
  if (auto *cfi = dyn_cast<ConvertFunctionInst>(oldConvertedFunc)) {
    // `convert_function` does not have a fixed typing rule because it can
    // convert between function types as long as they are ABI-compatible. Here
    // we match specific patterns.
    auto origTargetFnTy = cfi->getType().castTo<SILFunctionType>();
    auto origSourceFnTy =
        cfi->getOperand()->getType().castTo<SILFunctionType>();
    auto innerNewFunc = reapplyFunctionConversion(newFunc, oldFunc,
                                                  cfi->getOperand(), builder,
                                                  loc, newFuncGenSig,
                                                  substituteOperand);
    // Match a conversion from escaping to `@noescape`
    CanSILFunctionType targetType;
    if (!origSourceFnTy->isNoEscape() && origTargetFnTy->isNoEscape() &&
        origSourceFnTy == origTargetFnTy->getWithExtInfo(
            origTargetFnTy->getExtInfo().withNoEscape(false))) {
      auto operandFnTy = innerNewFunc->getType().castTo<SILFunctionType>();
      targetType = operandFnTy->getWithExtInfo(
          operandFnTy->getExtInfo().withNoEscape(true));
    }
    assert(targetType && "Unhandled convert_function pattern");
    auto silTy = SILType::getPrimitiveObjectType(targetType);
    return builder.createConvertFunction(loc, innerNewFunc, silTy,
                                         cfi->withoutActuallyEscaping());
  }
  llvm_unreachable("Unhandled function convertion instruction");
}

static SubstitutionMap getSubstitutionMap(
    SILValue value, SubstitutionMap substMap = SubstitutionMap()) {
  if (auto *thinToThick = dyn_cast<ThinToThickFunctionInst>(value))
    return getSubstitutionMap(thinToThick->getOperand(), substMap);
  if (auto *convertFn = dyn_cast<ConvertFunctionInst>(value))
    return getSubstitutionMap(convertFn->getOperand(), substMap);
  if (auto *convertFn = dyn_cast<ConvertEscapeToNoEscapeInst>(value))
    return getSubstitutionMap(convertFn->getOperand(), substMap);
  if (auto *partialApply = dyn_cast<PartialApplyInst>(value)) {
    auto appliedSubstMap = partialApply->getSubstitutionMap();
    // TODO: Combine argument `substMap` with `appliedSubstMap`.
    return getSubstitutionMap(partialApply->getCallee(), appliedSubstMap);
  }
  if (auto *apply = dyn_cast<ApplyInst>(value)) {
    auto appliedSubstMap = apply->getSubstitutionMap();
    // TODO: Combine argument `substMap` with `appliedSubstMap`.
    return getSubstitutionMap(apply->getCallee(), appliedSubstMap);
  }
  return substMap;
}

/// Emits a reference to an associated function of `original`, differentiated
/// with respect to a superset of `desiredIndices`. Returns the `SILValue` for
/// the associated function and the actual indices that the associated function
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
emitAssociatedFunctionReference(
    ADContext &context, SILBuilder &builder, SILAutoDiffIndices desiredIndices,
    AutoDiffAssociatedFunctionKind kind, SILValue original,
    DifferentiationInvoker invoker) {

  SILValue functionSource = original;

  // If `original` is itself an `AutoDiffFunctionExtractInst` whose kind matches
  // the given kind and desired differentiation parameter indices, simply
  // extract the associated function of its function operand, retain the
  // associated function, and return it.
  if (auto *inst = original->getDefiningInstruction())
    if (auto *adfei = dyn_cast<AutoDiffFunctionExtractInst>(inst))
      if (adfei->getExtractee() == AutoDiffFunctionExtractee::Original)
        functionSource = adfei->getFunctionOperand();

  // If `functionSource` is a `@differentiable` function, just extract the
  // associated function.
  if (auto diffableFnType = original->getType().castTo<SILFunctionType>()) {
    if (diffableFnType->isDifferentiable()) {
      auto paramIndices = diffableFnType->getDifferentiationParameterIndices();
      for (auto i : desiredIndices.parameters->getIndices()) {
        if (!paramIndices->contains(i)) {
          context.emitNondifferentiabilityError(original, invoker,
              diag::autodiff_function_nondiff_parameter_not_differentiable);
          return None;
        }
      }
      SILValue assocFn = builder.createAutoDiffFunctionExtract(
          original.getLoc(), kind, /*differentiationOrder*/ 1, functionSource);
      SILAutoDiffIndices indices(0, desiredIndices.parameters);
      return std::make_pair(assocFn, indices);
    }
  }

  // Find local function reference.
  if (auto *originalFRI =
          peerThroughFunctionConversions<FunctionRefInst>(original)) {
    auto loc = originalFRI->getLoc();
    auto *originalFn = originalFRI->getReferencedFunction();
    auto substMap = getSubstitutionMap(original);
    // Attempt to look up a `[differentiable]` attribute that minimally
    // satisfies the specified indices.
    auto *minimalAttr =
        context.lookUpMinimalDifferentiableAttr(originalFn, desiredIndices);
    if (!minimalAttr) {
      // If the function is intentionally marked as being opauqe to
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
                 .getSILStorageType()
                 .isDifferentiable(context.getModule())) {
          auto diag = context.emitNondifferentiabilityError(
              original, invoker, diag::autodiff_nondifferentiable_argument);
          return None;
        }
      }
      // Check and diagnose non-differentiable results.
      if (!originalFnTy->getResults()[desiredIndices.source]
               .getSILStorageType()
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
      // Sanity check passed. Create a new `[differentiable]` attribute and
      // process it it.
      ArrayRef<Requirement> contextualRequirements;
      if (invoker.getKind() ==
          DifferentiationInvoker::Kind::IndirectDifferentiation)
        contextualRequirements =
            invoker.getIndirectDifferentiation().second->getRequirements();
      auto *newAttr = context.getOrCreateDifferentiableAttr(
          originalFn, desiredIndices, contextualRequirements);
      if (context.processDifferentiableAttribute(originalFn, newAttr, invoker))
        return None;
      minimalAttr = newAttr;
    }
    assert(minimalAttr);
    // TODO(TF-482): Change `lookupMinimalDifferentiableAttr`.
    llvm::errs() << "EMIT ASSOC ORIGINAL FN OPERAND:\n";
    original->dump();
    llvm::errs() << "EMIT ASSOC SUBST MAP:\n";
    substMap.dump();
    if (!checkRequirementsSatisfied(
            minimalAttr->getRequirements(),
            substMap, context.getModule().getSwiftModule())) {
      context.emitNondifferentiabilityError(original, invoker,
          diag::autodiff_function_assoc_func_requirements_unmet);
      return None;
    }
    SILFunction *assocFn = nullptr;
    switch (kind) {
    case AutoDiffAssociatedFunctionKind::JVP:
      assert(!minimalAttr->getJVPName().empty() && "Expected JVP name");
      assocFn = context.getModule().lookUpFunction(minimalAttr->getJVPName());
      break;
    case AutoDiffAssociatedFunctionKind::VJP:
      assert(!minimalAttr->getVJPName().empty() && "Expected VJP name");
      assocFn = context.getModule().lookUpFunction(minimalAttr->getVJPName());
      break;
    }
    auto *assocFnRef = builder.createFunctionRef(loc, assocFn);
    // FIXME(TF-201): Handle direct differentiation of reabstraction thunks.
    // Tentative solution: clone a new reabstraction thunk where function
    // argument has a `@differentiable` function type.
    if (originalFn->isThunk() == IsReabstractionThunk) {
      // Handle here.
    }
    auto convertedRef = reapplyFunctionConversion(
        assocFnRef, originalFRI, original, builder, loc,
        assocFn->getLoweredFunctionType()->getGenericSignature());
    return std::make_pair(convertedRef, minimalAttr->getIndices());
  }

  // Find global `let` closure.
  if (auto *load = peerThroughFunctionConversions<LoadInst>(original)) {
    FunctionRefInst *initialFnRef = nullptr;
    SILValue initVal;
    if (auto *globalAddr = dyn_cast<GlobalAddrInst>(load->getOperand())) {
      // Search for the original function used to initialize this `let`
      // constant.
      if (auto *global = globalAddr->getReferencedGlobal()) {
        if (!global->isLet()) {
          context.emitNondifferentiabilityError(original, invoker,
              diag::autodiff_cannot_differentiate_global_var_closures);
          return None;
        }
        // FIXME: In LLDB REPL, "main" will not be the function we should look
        // for.
        if (auto *mainFn = global->getModule().lookUpFunction("main")) {
          if (mainFn->isDefinition())
            for (auto &inst : mainFn->front())
              if (auto *globalAddrInMain = dyn_cast<GlobalAddrInst>(&inst))
                if (globalAddrInMain->getReferencedGlobal() == global)
                  for (auto *use : globalAddrInMain->getUses())
                    if (auto *store = dyn_cast<StoreInst>(use->getUser()))
                      if (store->getDest() == globalAddrInMain)
                        initialFnRef = peerThroughFunctionConversions
                            <FunctionRefInst>((initVal = store->getSrc()));
        }
      }
    }
    if (initialFnRef) {
      assert(initVal);
      auto *initialFn = initialFnRef->getReferencedFunction();
      auto *minimalAttr =
          context.lookUpMinimalDifferentiableAttr(initialFn, desiredIndices);
      if (!minimalAttr) {
        if (initialFn->isExternalDeclaration()) {
          context.emitNondifferentiabilityError(
              original, invoker,
              diag::autodiff_global_let_closure_not_differentiable);
          return None;
        }
        ArrayRef<Requirement> contextualRequirements;
        if (invoker.getKind() ==
            DifferentiationInvoker::Kind::IndirectDifferentiation)
          contextualRequirements =
              invoker.getIndirectDifferentiation().second->getRequirements();
        auto *newAttr = context.getOrCreateDifferentiableAttr(
            initialFn, desiredIndices, contextualRequirements);
        bool error = context.processDifferentiableAttribute(
            initialFn, newAttr, invoker);
        if (error)
          return None;
        minimalAttr = newAttr;
      }
      auto loc = original.getLoc();
      SILFunction *assocFn = nullptr;
      switch (kind) {
      case AutoDiffAssociatedFunctionKind::JVP:
        assert(!minimalAttr->getJVPName().empty() && "Expected JVP name");
        assocFn = context.getModule().lookUpFunction(minimalAttr->getJVPName());
        break;
      case AutoDiffAssociatedFunctionKind::VJP:
        assert(!minimalAttr->getVJPName().empty() && "Expected VJP name");
        assocFn = context.getModule().lookUpFunction(minimalAttr->getVJPName());
        break;
      }
      assert(assocFn && "Associated function must be resolved");
      auto assocFnGenSig =
          assocFn->getLoweredFunctionType()->getGenericSignature();
      auto *initialVJPRef = builder.createFunctionRef(loc, assocFn);
      auto converted =
          reapplyFunctionConversion(initialVJPRef, initialFnRef, initVal,
                                    builder, loc, assocFnGenSig);
      converted =
          reapplyFunctionConversion(converted, load, original,
                                    builder, loc, assocFnGenSig);
      return std::make_pair(converted, minimalAttr->getIndices());
    }
  }

  // Find witness method retrieval.
  if (auto *witnessMethod =
          peerThroughFunctionConversions<WitnessMethodInst>(original)) {
    auto loc = witnessMethod->getLoc();
    auto requirement = witnessMethod->getMember();
    auto *requirementDecl = requirement.getDecl();
    auto *diffAttr =
        requirementDecl->getAttrs().getAttribute<DifferentiableAttr>();
    if (!diffAttr) {
      context.emitNondifferentiabilityError(original, invoker,
          diag::autodiff_protocol_member_not_differentiable);
      return None;
    }

    // Check that the requirement indices are the same as the desired indices.
    auto *requirementParameterIndices = diffAttr->getParameterIndices();
    auto loweredRequirementIndices = requirementParameterIndices->getLowered(
        context.getASTContext(),
        requirementDecl->getInterfaceType()->castTo<AnyFunctionType>());
    SILAutoDiffIndices requirementIndices(/*source*/ 0,
                                          loweredRequirementIndices);

    // NOTE: We need to extend the capacity of desired parameter indices to
    // requirement parameter indices, because there's a argument count mismatch.
    // When `@differentiable` partial apply is supported, this problem will go
    // away.
    if (desiredIndices.source != requirementIndices.source ||
        !desiredIndices.parameters->extendingCapacity(
            context.getASTContext(),
            requirementIndices.parameters->getCapacity())
                ->isSubsetOf(requirementIndices.parameters)) {
      context.emitNondifferentiabilityError(original, invoker,
          diag::autodiff_protocol_member_subset_indices_not_differentiable);
      return None;
    }

    auto originalType = witnessMethod->getType().castTo<SILFunctionType>();
    auto assocType = originalType->getAutoDiffAssociatedFunctionType(
        requirementIndices.parameters, requirementIndices.source,
        /*differentiationOrder*/ 1, kind, builder.getModule(),
        LookUpConformanceInModule(builder.getModule().getSwiftModule()));

    // Emit a witness_method instruction pointing at the associated function.
    auto *autoDiffFuncId = AutoDiffAssociatedFunctionIdentifier::get(
        kind, /*differentiationOrder*/ 1, requirementParameterIndices,
        context.getASTContext());
    auto *ref = builder.createWitnessMethod(
        loc, witnessMethod->getLookupType(), witnessMethod->getConformance(),
        requirement.asAutoDiffAssociatedFunction(autoDiffFuncId),
        SILType::getPrimitiveObjectType(assocType));
    auto convertedRef =
        reapplyFunctionConversion(ref, witnessMethod, original, builder, loc);
    return std::make_pair(convertedRef, requirementIndices);
  }

  // Reject class methods.
  if (auto *classMethod =
          peerThroughFunctionConversions<ClassMethodInst>(original)) {
    context.emitNondifferentiabilityError(original, invoker,
        diag::autodiff_class_member_not_supported);
    return None;
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
  assert(confRef.hasValue() && "Missing conformance to `AdditiveArithmetic`");
  // Look up `AdditiveArithmetic.zero.getter`.
  auto zeroDeclLookup = additiveArithmeticProto->lookupDirect(astCtx.Id_zero);
  auto *zeroDecl = cast<VarDecl>(zeroDeclLookup.front());
  assert(zeroDecl->isProtocolRequirement());
  auto *accessorDecl = zeroDecl->getAccessor(AccessorKind::Get);
  SILDeclRef accessorDeclRef(accessorDecl, SILDeclRef::Kind::Func);
  auto silFnType = typeConverter.getConstantType(accessorDeclRef);
  // %wm = witness_method ...
  auto *getter = builder.createWitnessMethod(
      loc, type, *confRef, accessorDeclRef, silFnType);
  // %metatype = metatype $T
  auto metatypeType = CanMetatypeType::get(
      type, MetatypeRepresentation::Thick);
  auto metatype = builder.createMetatype(
      loc, SILType::getPrimitiveObjectType(metatypeType));
  auto subMap = SubstitutionMap::getProtocolSubstitutions(
      additiveArithmeticProto, type, *confRef);
  builder.createApply(loc, getter, subMap, {bufferAccess, metatype},
                      /*isNonThrowing*/ false);
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
    auto genericSig = fn->getLoweredFunctionType()->getGenericSignature();
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
            fn->getLoweredFunctionType()->getGenericSignature()) {
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

  auto *genericSig = std::move(builder).computeGenericSignature(
      SourceLoc(), /*allowConcreteGenericParams=*/true);
  genericEnv = genericSig->createGenericEnvironment();

  newArchetype = genericEnv->mapTypeIntoContext(newGenericParam)
      ->castTo<ArchetypeType>();

  // Calculate substitutions to map the caller's archetypes to the thunk's
  // archetypes.
  if (auto calleeGenericSig =
          fn->getLoweredFunctionType()->getGenericSignature()) {
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
    auto paramIfaceTy = param.getType()->mapTypeOutOfContext();
    interfaceParams.push_back(SILParameterInfo(
        paramIfaceTy->getCanonicalType(genericSig), param.getConvention()));
  }

  SmallVector<SILYieldInfo, 4> interfaceYields;
  for (auto &yield : expectedType->getYields()) {
    auto yieldIfaceTy = yield.getType()->mapTypeOutOfContext();
    auto interfaceYield =
        yield.getWithType(yieldIfaceTy->getCanonicalType(genericSig));
    interfaceYields.push_back(interfaceYield);
  }

  SmallVector<SILResultInfo, 4> interfaceResults;
  for (auto &result : expectedType->getResults()) {
    auto resultIfaceTy = result.getType()->mapTypeOutOfContext();
    auto interfaceResult =
        result.getWithType(resultIfaceTy->getCanonicalType(genericSig));
    interfaceResults.push_back(interfaceResult);
  }

  Optional<SILResultInfo> interfaceErrorResult;
  if (expectedType->hasErrorResult()) {
    auto errorResult = expectedType->getErrorResult();
    auto errorIfaceTy = errorResult.getType()->mapTypeOutOfContext();
    interfaceErrorResult =
        SILResultInfo(errorIfaceTy->getCanonicalType(genericSig),
                      expectedType->getErrorResult().getConvention());
  }

  // The type of the thunk function.
  return SILFunctionType::get(
      genericSig, extInfo, expectedType->getCoroutineKind(),
      ParameterConvention::Direct_Unowned, interfaceParams, interfaceYields,
      interfaceResults, interfaceErrorResult, module.getASTContext());
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

  auto *thunk = fb.getOrCreateSharedFunction(
      loc, name, thunkDeclType, IsBare, IsTransparent, IsSerialized,
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
          getBufferSOQ(toArg->getType().getASTType(), *thunk));
      arguments.push_back(buf);
      continue;
    }
    // Convert direct parameter to indirect parameter.
    assert(toParam.isFormalIndirect());
    auto *toArg = *toArgIter++;
    auto *load = builder.createLoad(loc, toArg,
        getBufferLOQ(toArg->getType().getASTType(), *thunk));
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
          getBufferLOQ(indRes->getType().getASTType(), *thunk));
      results.push_back(load);
      continue;
    }
    // Store direct results to indirect results.
    assert(toRes.isFormalIndirect());
    SILType resultTy = toConv.getSILType(toRes);
    assert(resultTy.isAddress());
    auto indRes = *toIndResultsIter++;
    builder.createStore(loc, *fromDirResultsIter++, indRes,
                        getBufferSOQ(indRes->getType().getASTType(), *thunk));
  }
  auto retVal = joinElements(results, builder, loc);

  // Deallocate local allocations.
  for (auto *alloc : reversed(localAllocations))
    builder.createDeallocStack(loc, alloc);

  // Create return.
  builder.createReturn(loc, retVal);

  LLVM_DEBUG(auto &s = getADDebugStream() << "Created reabstraction thunk.\n";
             s << "  From type: " << fromType << '\n';
             s << "  To type: " << toType << '\n';
             s << '\n' << *thunk);

  return thunk;
}

StructDecl *
ADContext::createPrimalValueStruct(SILFunction *original,
                                   const SILAutoDiffIndices indices,
                                   CanGenericSignature primalGenericSig) {
  auto *function = original;
  assert(&function->getModule() == &module &&
         "The function must be in the same module");
  auto &file = getPrimalValueDeclContainer(function);
  // Create a `_<fn_name>__Type` struct.
  std::string pvStructName =
      "_AD__" + function->getName().str() + "__Type__" + indices.mangle();
  auto structId = astCtx.getIdentifier(pvStructName);
  SourceLoc loc = function->getLocation().getSourceLoc();
  auto pvStruct =
      new (astCtx) StructDecl(/*StructLoc*/ loc, /*Name*/ structId,
                              /*NameLoc*/ loc, /*Inherited*/ {},
                              /*GenericParams*/ nullptr, // to be set later
                              /*DC*/ &file);
  // Set braces so that `pvStruct` can be dumped.
  pvStruct->setBraces(loc);
  if (primalGenericSig) {
    auto genericParams =
        cloneGenericParameters(astCtx, pvStruct, primalGenericSig);
    pvStruct->setGenericParams(genericParams);
    pvStruct->setGenericEnvironment(
        primalGenericSig->createGenericEnvironment());
  }
  switch (function->getEffectiveSymbolLinkage()) {
  case swift::SILLinkage::Public:
  case swift::SILLinkage::PublicNonABI:
    pvStruct->setAccess(AccessLevel::Internal);
    pvStruct->getAttrs().add(
        new (astCtx) UsableFromInlineAttr(/*Implicit*/ true));
    break;
  case swift::SILLinkage::Hidden:
  case swift::SILLinkage::Shared:
    pvStruct->setAccess(AccessLevel::Internal);
    break;
  case swift::SILLinkage::Private:
    pvStruct->setAccess(AccessLevel::FilePrivate);
    break;
  default:
    // When the original function has external linkage, we create an internal
    // struct for use by our own module. This is neccessary for cross-cell
    // differentiation in Jupyter.
    // TODO: Add a test in the compiler that exercises a similar situation as
    // cross-cell differentiation in Jupyter.
    pvStruct->setAccess(AccessLevel::Internal);
  }
  pvStruct->computeType();
  assert(pvStruct->hasInterfaceType());
  file.addVisibleDecl(pvStruct);
  LLVM_DEBUG({
    auto &s = getADDebugStream();
    s << "Primal value struct created for function " << function->getName()
      << '\n';
    pvStruct->print(s);
    s << '\n';
  });
  return pvStruct;
}

/// Given an parameter argument (not indirect result) and some differentiation
/// indices, figure out whether the parent function is being differentiated with
/// respect to this parameter, according to the indices.
static bool isDifferentiationParameter(SILArgument *argument,
                                       AutoDiffIndexSubset *indices) {
  if (!argument) return false;
  auto *function = argument->getFunction();
  auto paramArgs = function->getArgumentsWithoutIndirectResults();
  for (unsigned i : indices->getIndices())
    if (paramArgs[i] == argument)
      return true;
  return false;
}

/// For a nested function call that has results active on the differentiation
/// path, compute the set of minimal indices for differentiating this function
/// as required by the data flow.
static void collectMinimalIndicesForFunctionCall(
    ApplyInst *ai, SmallVectorImpl<SILValue> &results,
    const SILAutoDiffIndices &parentIndices,
    const DifferentiableActivityInfo &activityInfo,
    SmallVectorImpl<unsigned> &paramIndices,
    SmallVectorImpl<unsigned> &resultIndices) {
  // Make sure the function call has active results.
  assert(llvm::any_of(results, [&](SILValue result) {
    return activityInfo.isActive(result, parentIndices);
  }));
  auto fnTy = ai->getCallee()->getType().castTo<SILFunctionType>();
  SILFunctionConventions convs(fnTy, ai->getModule());
  auto arguments = ai->getArgumentOperands();
  // Parameter indices are indices (in the type signature) of parameter
  // arguments that are varied or are arguments.
  unsigned currentParamIdx = 0;
  for (auto applyArg : ai->getArgumentsWithoutIndirectResults()) {
    if (activityInfo.isVaried(applyArg, parentIndices.parameters) ||
        isDifferentiationParameter(dyn_cast<SILArgument>(applyArg),
                                   parentIndices.parameters))
      paramIndices.push_back(currentParamIdx);
    ++currentParamIdx;
  }
  // Result indices are indices (in the type signature) of results that are
  // useful.
  //
  // If the function returns only one result, then we just see if that is
  // useful.
  if (fnTy->getNumDirectFormalResults() == 1) {
    if (activityInfo.isUseful(ai, parentIndices.source))
      resultIndices.push_back(0);
    return;
  }
  // If the function returns more than 1 results, the return type is a tuple. We
  // need to find all `tuple_extract`s on that tuple, and determine if each
  // found extracted element is useful.
  // Collect direct results being retrieved using `tuple_extract`.
  SmallVector<SILValue, 8> usedDirectResults(convs.getNumDirectSILResults());
  for (auto *use : ai->getUses())
    if (auto *tei = dyn_cast<TupleExtractInst>(use->getUser()))
      usedDirectResults[tei->getFieldNo()] = tei;
  // Add differentiation indices based on activity analysis.
  unsigned dirResIdx = 0;
  unsigned indResIdx = convs.getSILArgIndexOfFirstIndirectResult();
  for (auto &resAndIdx : enumerate(convs.getResults())) {
    auto &res = resAndIdx.value();
    unsigned idx = resAndIdx.index();
    if (res.isFormalDirect()) {
      if (auto dirRes = usedDirectResults[dirResIdx])
        if (dirRes && activityInfo.isUseful(dirRes, parentIndices.source))
          resultIndices.push_back(idx);
      ++dirResIdx;
    } else {
      if (activityInfo.isUseful(arguments[indResIdx].get(),
                                parentIndices.source))
        resultIndices.push_back(idx);
      ++indResIdx;
    }
  }
}

// Returns the associated function with name `assocFnName`. If the function
// cannot be found, returns a reference to an external asssociated function
// declaration.
static SILFunction *getAssociatedFunction(
    ADContext &context, SILFunction *original, SILDifferentiableAttr *attr,
    AutoDiffAssociatedFunctionKind kind, StringRef assocFnName) {
  auto &module = context.getModule();
  auto *assocFn = module.lookUpFunction(assocFnName);
  if (!assocFn)
    assocFn = context.declareExternalAssociatedFunction(
       original, attr, assocFnName, kind);
  return assocFn;
}

namespace {
class VJPEmitter final
    : public TypeSubstCloner<VJPEmitter, SILOptFunctionBuilder> {
private:
  /// The global context.
  ADContext &context;

  /// The original function.
  SILFunction *original;

  /// The `[differentiable]` attribute.
  SILDifferentiableAttr *attr;

  /// The VJP function.
  SILFunction *vjp;

  /// The primal info.
  std::unique_ptr<PrimalInfo> primalInfo = nullptr;

  /// The differentiation invoker.
  DifferentiationInvoker invoker;

  /// Info from activity analysis on the original function.
  const DifferentiableActivityInfo &activityInfo;

  bool errorOccurred = false;

  /// Global context.
  ADContext &getContext() { return context; }

  SmallVector<SILValue, 8> primalValues;

  ASTContext &getASTContext() const {
    return vjp->getASTContext();
  }

  SILFunction *getOriginal() const { return original; }
  SILFunction *getVJP() const { return vjp; }

  const SILAutoDiffIndices &getIndices() const { return attr->getIndices(); }

  DifferentiationInvoker getInvoker() const { return invoker; }

  PrimalInfo &getPrimalInfo() const {
    return *primalInfo.get();
  }

  static SubstitutionMap getSubstitutionMap(SILFunction *original,
                                            SILFunction *vjp) {
    auto substMap = original->getForwardingSubstitutionMap();
    if (auto *vjpGenEnv = vjp->getGenericEnvironment())
      substMap = substMap.subst(vjpGenEnv->getForwardingSubstitutionMap());
    return substMap;
  }

  static const DifferentiableActivityInfo &getActivityInfo(
      ADContext &context, SILFunction *original,
      const SILAutoDiffIndices &indices, SILFunction *vjp) {
    // Get activity info of the original function.
    auto &passManager = context.getPassManager();
    auto *activityAnalysis =
        passManager.getAnalysis<DifferentiableActivityAnalysis>();
    auto &activityCollection = *activityAnalysis->get(original);
    auto &activityInfo = activityCollection.getActivityInfo(
        vjp->getLoweredFunctionType()->getGenericSignature());
    LLVM_DEBUG(dumpActivityInfo(*original, indices, activityInfo,
                                getADDebugStream()));
    return activityInfo;
  }

public:
  explicit VJPEmitter(ADContext &context,
                      SILFunction *original,
                      SILDifferentiableAttr *attr,
                      SILFunction *vjp,
                      DifferentiationInvoker invoker)
      : TypeSubstCloner(*vjp, *original, getSubstitutionMap(original, vjp)),
        context(context), original(original), attr(attr), vjp(vjp),
        invoker(invoker),
        activityInfo(
            getActivityInfo(context, original, attr->getIndices(), vjp)) {}

  SILFunction *createEmptyAdjoint() {
    auto &module = context.getModule();
    auto origTy = original->getLoweredFunctionType();
    auto lookupConformance = LookUpConformanceInModule(module.getSwiftModule());

    // RAII that pushes the original function's generic signature to
    // `module.Types` so that the calls `module.Types.getTypeLowering()` below
    // will know the original function's generic parameter types.
    Lowering::GenericContextScope genericContextScope(
        module.Types, origTy->getGenericSignature());

    // Given a type, returns its formal SIL parameter info.
    auto getTangentParameterInfoForOriginalResult = [&](
        CanType tanType, ResultConvention origResConv) -> SILParameterInfo {
      auto &tl = context.getTypeConverter().getTypeLowering(
          tanType, ResilienceExpansion::Minimal);
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
          tanType, ResilienceExpansion::Minimal);
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

    // Parameters of the adjoint are:
    // - a seed,
    // - a primal value struct,
    // - original results, and
    // - the original parameters.
    // Results of the adjoint are in the tangent space of the original
    // parameters.
    SmallVector<SILParameterInfo, 8> adjParams;
    SmallVector<SILResultInfo, 8> adjResults;
    auto origParams = origTy->getParameters();
    auto indices = attr->getIndices();

    // Add adjoint parameter for the seed.
    auto origResInfo = origTy->getResults()[indices.source];
    adjParams.push_back(getTangentParameterInfoForOriginalResult(
        origResInfo.getType()
            ->getAutoDiffAssociatedTangentSpace(lookupConformance)
            ->getCanonicalType(), origResInfo.getConvention()));

    // Accept a primal value struct in the adjoint parameter list. This is the
    // pullback's closure context.
    auto pvType = primalInfo->getPrimalValueStruct()
        ->getDeclaredInterfaceType()->getCanonicalType();
    adjParams.push_back({pvType, ParameterConvention::Direct_Guaranteed});

    // Add adjoint results for the requested wrt parameters.
    for (auto i : indices.parameters->getIndices()) {
      auto origParam = origParams[i];
      adjResults.push_back(getTangentResultInfoForOriginalParameter(
          origParam.getType()
              ->getAutoDiffAssociatedTangentSpace(lookupConformance)
              ->getCanonicalType(), origParam.getConvention()));
    }

    auto adjName = original->getASTContext()
                       .getIdentifier("AD__" + original->getName().str() +
                                      "__adjoint_" + indices.mangle())
                       .str();
    auto adjGenericSig = getAssociatedFunctionGenericSignature(attr, original);
    auto *adjGenericEnv = adjGenericSig
        ? adjGenericSig->createGenericEnvironment()
        : nullptr;
    auto adjType = SILFunctionType::get(
        adjGenericSig, origTy->getExtInfo(), origTy->getCoroutineKind(),
        origTy->getCalleeConvention(), adjParams, {}, adjResults, None,
        original->getASTContext());

    SILOptFunctionBuilder fb(context.getTransform());
    // We set generated adjoint linkage to Hidden because generated adjoints are
    // never called cross-module in VJP mode: all cross-module calls to associated
    // functions call the VJP.
    auto linkage = SILLinkage::Hidden;
    auto *adjoint = fb.createFunction(
        linkage, adjName, adjType, adjGenericEnv, original->getLocation(),
        original->isBare(), IsNotTransparent, original->isSerialized(),
        original->isDynamicallyReplaceable());
    adjoint->setOwnershipEliminated();
    adjoint->setDebugScope(new (module)
                               SILDebugScope(original->getLocation(), adjoint));
    return adjoint;
  }

  // Run VJP generation. Returns true on error.
  bool run();

  void postProcess(SILInstruction *orig, SILInstruction *cloned) {
    if (errorOccurred)
      return;
    SILClonerWithScopes::postProcess(orig, cloned);
  }

  /// General visitor for all instruction. If there is any error emitted by
  /// previous visits, bail out.
  void visit(SILInstruction *inst) {
    if (errorOccurred)
      return;
    TypeSubstCloner::visit(inst);
  }

  void visitSILInstruction(SILInstruction *inst) {
    getContext().emitNondifferentiabilityError(inst, invoker);
    errorOccurred = true;
  }

  void visitReturnInst(ReturnInst *ri) {
    // The original return is not to be cloned.
    return;
  }

  void visitStructExtractInst(StructExtractInst *sei) {
    auto &strategies = context.getStructExtractDifferentiationStrategies();
    // Special handling logic only applies when the `struct_extract` is active.
    // If not, just do standard cloning.
    if (!activityInfo.isActive(sei, getIndices())) {
      LLVM_DEBUG(getADDebugStream() << "Not active:\n" << *sei << '\n');
      strategies.insert(
          {sei, StructExtractDifferentiationStrategy::Inactive});
      SILClonerWithScopes::visitStructExtractInst(sei);
      return;
    }
    // This instruction is active. Determine the appropriate differentiation
    // strategy, and use it.
    auto *structDecl = sei->getStructDecl();
    if (structDecl->getAttrs().hasAttribute<FieldwiseDifferentiableAttr>()) {
      strategies[sei] = StructExtractDifferentiationStrategy::Fieldwise;
      SILClonerWithScopes::visitStructExtractInst(sei);
      return;
    }
    // The FieldwiseProductSpace strategy is not appropriate, so use the Getter
    // strategy.
    strategies[sei] = StructExtractDifferentiationStrategy::Getter;
    // Find the corresponding getter and its VJP.
    auto *getterDecl = sei->getField()->getGetter();
    assert(getterDecl);
    auto *getterFn = getContext().getModule().lookUpFunction(
        SILDeclRef(getterDecl, SILDeclRef::Kind::Func));
    if (!getterFn) {
      getContext().emitNondifferentiabilityError(
          sei, invoker, diag::autodiff_property_not_differentiable);
      errorOccurred = true;
      return;
    }
    SILAutoDiffIndices indices(/*source*/ 0,
        AutoDiffIndexSubset::getDefault(getASTContext(), 1, true));
    auto *attr = getContext().lookUpDifferentiableAttr(getterFn, indices);
    if (!attr) {
      getContext().emitNondifferentiabilityError(
          sei, invoker, diag::autodiff_property_not_differentiable);
      errorOccurred = true;
      return;
    }
    // Reference and apply the VJP.
    auto loc = sei->getLoc();
    auto *getterVJP = getAssociatedFunction(
        context, getterFn, attr, AutoDiffAssociatedFunctionKind::VJP,
        attr->getVJPName());
    assert(getterVJP && "Expected to find getter VJP");
    auto *getterVJPRef = getBuilder().createFunctionRef(loc, getterVJP);
    auto *getterVJPApply = getBuilder().createApply(
        loc, getterVJPRef,
        getOpSubstitutionMap(getterVJP->getForwardingSubstitutionMap()),
        /*args*/ {getOpValue(sei->getOperand())}, /*isNonThrowing*/ false);
    // Extract direct results from `getterVJPApply`.
    SmallVector<SILValue, 8> vjpDirectResults;
    extractAllElements(getterVJPApply, getBuilder(), vjpDirectResults);
    // Map original result.
    auto originalDirectResults =
        ArrayRef<SILValue>(vjpDirectResults).drop_back(1);
    auto originalDirectResult = joinElements(originalDirectResults,
                                             getBuilder(),
                                             getterVJPApply->getLoc());
    mapValue(sei, originalDirectResult);
    // Checkpoint the pullback.
    SILValue pullback = vjpDirectResults.back();
    // TODO: Check whether it's necessary to reabstract getter pullbacks.
    getPrimalInfo().addPullbackDecl(sei, getOpType(pullback->getType()));
    primalValues.push_back(pullback);
  }

  void visitStructElementAddrInst(StructElementAddrInst *seai) {
    auto &strategies = context.getStructExtractDifferentiationStrategies();
    // Special handling logic only applies when the `struct_element_addr` is
    // active. If not, just do standard cloning.
    if (!activityInfo.isActive(seai, getIndices())) {
      LLVM_DEBUG(getADDebugStream() << "Not active:\n" << *seai << '\n');
      strategies[seai] =StructExtractDifferentiationStrategy::Inactive;
      SILClonerWithScopes::visitStructElementAddrInst(seai);
      return;
    }
    // This instruction is active. Determine the appropriate differentiation
    // strategy, and use it.
    auto *structDecl = seai->getStructDecl();
    if (structDecl->getAttrs().hasAttribute<FieldwiseDifferentiableAttr>()) {
      strategies[seai] = StructExtractDifferentiationStrategy::Fieldwise;
      SILClonerWithScopes::visitStructElementAddrInst(seai);
      return;
    }
    // The FieldwiseProductSpace strategy is not appropriate, so use the Getter
    // strategy.
    strategies[seai] = StructExtractDifferentiationStrategy::Getter;
    // Find the corresponding getter and its VJP.
    auto *getterDecl = seai->getField()->getGetter();
    assert(getterDecl);
    auto *getterFn = getContext().getModule().lookUpFunction(
        SILDeclRef(getterDecl, SILDeclRef::Kind::Func));
    if (!getterFn) {
      getContext().emitNondifferentiabilityError(
          seai, invoker, diag::autodiff_property_not_differentiable);
      errorOccurred = true;
      return;
    }
    SILAutoDiffIndices indices(/*source*/ 0,
        AutoDiffIndexSubset::getDefault(getASTContext(), 1, true));
    auto *attr = getContext().lookUpDifferentiableAttr(getterFn, indices);
    if (!attr) {
      getContext().emitNondifferentiabilityError(
          seai, invoker, diag::autodiff_property_not_differentiable);
      errorOccurred = true;
      return;
    }
    // Set generic context scope before getting VJP function type.
    auto canGenSig = SubsMap.getGenericSignature()
        ? SubsMap.getGenericSignature()->getCanonicalSignature()
        : nullptr;
    Lowering::GenericContextScope genericContextScope(
        getContext().getTypeConverter(), canGenSig);
    // Reference the getter VJP.
    auto loc = seai->getLoc();
    auto *getterVJP = context.getModule().lookUpFunction(attr->getVJPName());
    assert(getterVJP && "Expected to find getter VJP");
    auto vjpFnTy = getterVJP->getLoweredFunctionType();
    auto *getterVJPRef = getBuilder().createFunctionRef(loc, getterVJP);
    // Store getter VJP arguments and indirect result buffers.
    SmallVector<SILValue, 8> vjpArgs;
    SmallVector<AllocStackInst *, 8> vjpIndirectResults;
    for (auto indRes : vjpFnTy->getIndirectFormalResults()) {
      auto *alloc = getBuilder().createAllocStack(
          loc, getOpType(indRes.getSILStorageType()));
      vjpArgs.push_back(alloc);
      vjpIndirectResults.push_back(alloc);
    }
    vjpArgs.push_back(getOpValue(seai->getOperand()));
    // Apply the getter VJP.
    auto *getterVJPApply = getBuilder().createApply(
        loc, getterVJPRef,
        getOpSubstitutionMap(getterVJP->getForwardingSubstitutionMap()),
        vjpArgs, /*isNonThrowing*/ false);
    // Collect all results from `getterVJPApply` in type-defined order.
    SmallVector<SILValue, 8> vjpDirectResults;
    extractAllElements(getterVJPApply, getBuilder(), vjpDirectResults);
    SmallVector<SILValue, 8> allResults;
    collectAllActualResultsInTypeOrder(
        getterVJPApply, vjpDirectResults,
        getterVJPApply->getIndirectSILResults(), allResults);
    // Deallocate VJP indirect results.
    for (auto alloc : vjpIndirectResults)
      getBuilder().createDeallocStack(loc, alloc);
    auto originalDirectResult = allResults[indices.source];
    // Map original result.
    mapValue(seai, originalDirectResult);
    // Checkpoint the pullback.
    SILValue pullback = vjpDirectResults.back();
    // TODO: Check whether it's necessary to reabstract getter pullbacks.
    getPrimalInfo().addPullbackDecl(seai, getOpType(pullback->getType()));
    primalValues.push_back(pullback);
  }

  // If an `apply` has active results or active inout parameters, replace it
  // with an `apply` of its VJP.
  void visitApplyInst(ApplyInst *ai) {
    auto &context = getContext();
    // Special handling logic only applies when `apply` has active results or
    // active arguments at an active 'inout' parameter position. If not, just do
    // standard cloning.
    SmallVector<SILValue, 4> allResults;
    allResults.push_back(ai);
    allResults.append(ai->getIndirectSILResults().begin(),
                      ai->getIndirectSILResults().end());
    auto hasActiveResults = llvm::any_of(allResults, [&](SILValue result) {
      return activityInfo.isActive(result, getIndices());
    });
    // Check for active 'inout' arguments.
    auto paramInfos = ai->getSubstCalleeConv().getParameters();
    bool hasActiveInoutParams = false;
    for (unsigned i : swift::indices(paramInfos))
      if (paramInfos[i].isIndirectInOut() &&
          activityInfo.isActive(ai->getArgumentsWithoutIndirectResults()[i],
                                getIndices()))
        hasActiveInoutParams = true;
    // Reject functions with active inout arguments. It's not yet supported.
    if (hasActiveInoutParams) {
      context.emitNondifferentiabilityError(ai, invoker,
          diag::autodiff_cannot_differentiate_through_inout_arguments);
      errorOccurred = true;
      return;
    }
    // If there's no active results, this function should not be differentiated.
    // Do standard cloning.
    if (!hasActiveResults) {
      LLVM_DEBUG(getADDebugStream() << "No active results:\n" << *ai << '\n');
      SILClonerWithScopes::visitApplyInst(ai);
      return;
    }

    // Get the parameter indices required for differentiating this function.
    LLVM_DEBUG(getADDebugStream() << "VJP-transforming:\n" << *ai << '\n');
    SmallVector<unsigned, 8> activeParamIndices;
    SmallVector<unsigned, 8> activeResultIndices;
    collectMinimalIndicesForFunctionCall(ai, allResults, getIndices(),
                                         activityInfo, activeParamIndices,
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
    // FIXME: We don't support multiple active results yet.
    if (activeResultIndices.size() > 1) {
      context.emitNondifferentiabilityError(ai, invoker);
      errorOccurred = true;
      return;
    }
    // Form expected indices by assuming there's only one result.
    SILAutoDiffIndices indices(activeResultIndices.front(),
        AutoDiffIndexSubset::get(
            getASTContext(),
            ai->getArgumentsWithoutIndirectResults().size(),
            activeParamIndices));

    // Emit the VJP.
    auto loc = ai->getLoc();
    auto &builder = getBuilder();
    auto original = getOpValue(ai->getCallee());
    auto functionSource = original;
    SILValue vjp;
    // If functionSource is a @differentiable function, just extract it.
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
      vjp = builder.createAutoDiffFunctionExtract(
          original.getLoc(), AutoDiffFunctionExtractInst::Extractee::VJP,
          /*differentiationOrder*/ 1, functionSource);
    }

    // Check and diagnose non-differentiable arguments.
    for (unsigned paramIndex : range(originalFnTy->getNumParameters())) {
      if (indices.isWrtParameter(paramIndex) &&
              !originalFnTy->getParameters()[paramIndex]
              .getSILStorageType()
              .isDifferentiable(context.getModule())) {
        context.emitNondifferentiabilityError(
            original, invoker, diag::autodiff_nondifferentiable_argument);
        errorOccurred = true;
        return;
      }
    }
    // Check and diagnose non-differentiable results.
    if (!originalFnTy->getResults()[indices.source]
            .getSILStorageType()
            .isDifferentiable(context.getModule())) {
      context.emitNondifferentiabilityError(
          original, invoker, diag::autodiff_nondifferentiable_result);
      errorOccurred = true;
      return;
    }
    // If VJP has not yet been found, emit an `autodiff_function` instruction
    // on the remapped original function operand and `autodiff_function_extract`
    // the VJP. The actual JVP/VJP functions will be populated in the
    // `autodiff_function` during the transform main loop.
    if (!vjp) {
      // FIXME: Handle indirect differentiation invokers. This may require some
      // redesign: currently, each original function + attribute pair is mapped
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
      if (!ai->getSubstitutionMap().empty()) {
        auto substMap = getOpSubstitutionMap(ai->getSubstitutionMap());
        auto vjpPartialApply = getBuilder().createPartialApply(
            ai->getLoc(), original, substMap, {},
            ParameterConvention::Direct_Guaranteed);
        original = vjpPartialApply;
      }

      auto *autoDiffFuncInst = getBuilder().createAutoDiffFunction(
          loc, indices.parameters, /*differentiationOrder*/ 1, original);

      // Record the `autodiff_function` instruction.
      context.getAutoDiffFunctionInsts().push_back(autoDiffFuncInst);
      context.getResultIndices()[autoDiffFuncInst] =
          activeResultIndices.front();

      vjp = getBuilder().createAutoDiffFunctionExtract(
          loc, AutoDiffFunctionExtractInst::Extractee::VJP,
          /*differentiationOrder*/ 1, autoDiffFuncInst);
    }

    // Record desired/actual VJP indices.
    // Temporarily set original pullback type to `None`.
    NestedApplyInfo info{indices, /*originalPullbackType*/ None};
    auto insertion = context.getNestedApplyInfo().try_emplace(ai, info);
    auto &nestedApplyInfo = insertion.first->getSecond();
    nestedApplyInfo = info;

    // Call the VJP using the original parameters.
    SmallVector<SILValue, 8> vjpArgs;
    auto vjpFnTy = getOpType(vjp->getType()).castTo<SILFunctionType>();
    auto numVJPArgs =
        vjpFnTy->getNumParameters() + vjpFnTy->getNumIndirectFormalResults();
    vjpArgs.reserve(numVJPArgs);
    // Collect substituted arguments.
    for (auto origArg : ai->getArguments())
      vjpArgs.push_back(getOpValue(origArg));
    assert(vjpArgs.size() == numVJPArgs);
    // Apply the VJP.
    // The VJP should be specialized, so no substitution map is necessary.
    auto *vjpCall = getBuilder().createApply(loc, vjp, SubstitutionMap(),
                                             vjpArgs, ai->isNonThrowing());
    LLVM_DEBUG(getADDebugStream() << "Applied vjp function\n" << *vjpCall);

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
    auto *pullbackDecl =
        getPrimalInfo().addPullbackDecl(ai, getOpType(pullback->getType()));

    // If actual pullback type does not match lowered pullback type, reabstract
    // the pullback using a thunk.
    auto actualPullbackType =
        getOpType(pullback->getType()).getAs<SILFunctionType>();
    auto canGenSig = SubsMap.getGenericSignature()
        ? SubsMap.getGenericSignature()->getCanonicalSignature()
        : nullptr;
    Lowering::GenericContextScope genericContextScope(
        context.getTypeConverter(), canGenSig);
    auto loweredPullbackType =
        getOpType(context.getTypeConverter().getLoweredType(
                      pullbackDecl->getInterfaceType()->getCanonicalType(),
                      ResilienceExpansion::Minimal))
            .castTo<SILFunctionType>();
    if (!loweredPullbackType->isEqual(actualPullbackType)) {
      // Set non-reabstracted original pullback type in nested apply info.
      nestedApplyInfo.originalPullbackType = actualPullbackType;
      SILOptFunctionBuilder fb(getContext().getTransform());
      auto *thunk = getOrCreateReabstractionThunk(
          fb, getContext().getModule(), loc, /*caller*/ getVJP(),
          actualPullbackType, loweredPullbackType);
      auto *thunkRef = getBuilder().createFunctionRef(loc, thunk);
      pullback = getBuilder().createPartialApply(
          ai->getLoc(), thunkRef, thunk->getForwardingSubstitutionMap(),
          {pullback}, actualPullbackType->getCalleeConvention());
    }
    primalValues.push_back(pullback);

    // Some instructions that produce the callee may have been cloned.
    // If the original callee did not have any users beyond this `apply`,
    // recursively kill the cloned callee.
    if (auto *origCallee = cast_or_null<SingleValueInstruction>(
            ai->getCallee()->getDefiningInstruction()))
      if (origCallee->hasOneUse())
        recursivelyDeleteTriviallyDeadInstructions(
            getOpValue(origCallee)->getDefiningInstruction());
  }
};
} // end anonymous namespace

//===----------------------------------------------------------------------===//
// AdjointValue - a symbolic representation for adjoint values that allows
// for efficient differentiation of aggregates.
//===----------------------------------------------------------------------===//

namespace {
class AdjointEmitter;
class AdjointValue;

class Cleanup {
public:
  using Func = void(*)(SILBuilder &, SILLocation, SILValue);

private:
  SILValue value;
  Func func;
  unsigned numChildren;

  Cleanup **getChildrenData() {
    return reinterpret_cast<Cleanup **>(this + 1);
  }

  Cleanup(SILValue value, Func func, ArrayRef<Cleanup *> children)
      : value(value), func(func), numChildren(children.size()) {
    assert(((func && value) || !func) &&
           "Value must be non-null when the function is non-null");
    assert(llvm::all_of(children, [](Cleanup *c) { return (bool)c; }));
    LLVM_DEBUG(getADDebugStream() << "Creating a cleanup with " << numChildren
               << " children.\n");
    std::uninitialized_copy(children.begin(), children.end(),
                            getChildrenData());
    assert(llvm::all_of(llvm::zip(children, getChildren()),
                        [](std::tuple<Cleanup *, Cleanup *> pair) {
      return std::get<0>(pair) == std::get<1>(pair);
    }));
  }

public:
  Cleanup() = delete;
  Cleanup(Cleanup &) = delete;
  Cleanup &operator=(const Cleanup &) = delete;

  static Cleanup *create(llvm::BumpPtrAllocator &allocator, SILValue value,
                         Func func, ArrayRef<Cleanup *> children) {
    auto *buf = allocator.Allocate(
        sizeof(Cleanup) + sizeof(Cleanup *) * children.size(),
        alignof(Cleanup));
    return new (buf) Cleanup(value, func, children);
  }

  unsigned getNumChildren() const {
    return numChildren;
  }

  ArrayRef<Cleanup *> getChildren() const {
    return {const_cast<Cleanup *>(this)->getChildrenData(), numChildren};
  }

  /// Disable this cleanup and makes its application a no-op.
  void disable() {
    func = nullptr;
  }

  /// Apply and invaliate the cleanup.
  void apply(SILBuilder &builder, SILLocation loc) {
    if (!func) return;
    assert(value);
    LLVM_DEBUG(getADDebugStream() << "Running `Cleanup::apply` for " << value);
    func(builder, loc, value);
    func = nullptr;
  }

  /// Apply the cleanup and its children recursively and invalidate them.
  void applyRecursively(SILBuilder &builder, SILLocation loc) {
    apply(builder, loc);
    for (auto *child : getChildren()) {
      assert(child);
      child->applyRecursively(builder, loc);
    }
  }
};

class ValueWithCleanup {
private:
  SILValue value;
  Cleanup *cleanup;

public:
  explicit ValueWithCleanup(SILValue value = SILValue(),
                            Cleanup *cleanup = nullptr)
      : value(value), cleanup(cleanup) {}
  ValueWithCleanup(const ValueWithCleanup &) = default;

public:
  SILValue getValue() const { return value; }
  operator SILValue() const { return getValue(); }
  void setValue(SILValue value) { this->value = value; }
  Cleanup *getCleanup() const { return cleanup; }
  void setCleanup(Cleanup *cleanup) { this->cleanup = cleanup; }

  SILLocation getLoc() const { return value.getLoc(); }
  SILType getType() const { return value->getType(); }
};

enum AdjointValueKind {
  /// An empty adjoint, i.e. zero. This case exists due to its special
  /// mathematical properties: `0 + x = x`. This is a guaranteed optimization
  /// when we combine a zero adjoint with another (e.g. differentiating a
  /// fanout).
  Zero,

  /// An aggregate of adjoint values.
  Aggregate,

  /// A concrete SIL value.
  Concrete,
};

class AdjointValueBase {
  friend class AdjointValue;

  /// The kind of this adjoint value.
  AdjointValueKind kind;

  /// The type of this value as if it were materialized as a SIL value.
  SILType type;

  /// The underlying value.
  union Value {
    MutableArrayRef<AdjointValue> aggregate;
    ValueWithCleanup concrete;
    Value(MutableArrayRef<AdjointValue> v) : aggregate(v) {}
    Value(ValueWithCleanup v) : concrete(v) {}
    Value() {}
  } value;

  explicit AdjointValueBase(SILType type,
                            MutableArrayRef<AdjointValue> aggregate)
      : kind(AdjointValueKind::Aggregate), type(type), value(aggregate) {}

  explicit AdjointValueBase(ValueWithCleanup v)
      : kind(AdjointValueKind::Concrete), type(v.getType()), value(v) {}

  explicit AdjointValueBase(SILType type)
      : kind(AdjointValueKind::Zero), type(type) {}
};

/// A symbolic adjoint value that is capable of representing zero value 0 and
/// 1, in addition to a materialized SILValue. This is expected to be passed
/// around by value in most cases, as it's two words long.
class AdjointValue final {
  friend class AdjointEmitter;

private:
  /// The kind of this adjoint value.
  AdjointValueBase *base;
  /*implicit*/ AdjointValue(AdjointValueBase *base = nullptr) : base(base) {}

public:
  AdjointValue(const AdjointValue &) = delete;
  AdjointValue &operator=(const AdjointValue &) = delete;
  AdjointValue(AdjointValue &&val) = default;
  AdjointValue &operator=(AdjointValue &&) = default;

  AdjointValueBase *operator->() const { return base; }
  AdjointValueBase &operator*() const { return *base; }

  static AdjointValue createConcrete(llvm::BumpPtrAllocator &allocator,
                                     ValueWithCleanup value) {
    return new (allocator.Allocate<AdjointValueBase>()) AdjointValueBase(value);
  }

  template<typename EltMoveRange>
  static AdjointValue createAggregate(llvm::BumpPtrAllocator &allocator,
                                      SILType type, EltMoveRange &&elements) {
    AdjointValue *buf = reinterpret_cast<AdjointValue *>(allocator.Allocate(
        elements.size() * sizeof(AdjointValue), alignof(AdjointValue)));
    MutableArrayRef<AdjointValue> elementsCopy(buf, elements.size());
    std::move(elements.begin(), elements.end(), elementsCopy.begin());
    return new (allocator.Allocate<AdjointValueBase>())
        AdjointValueBase(type, elementsCopy);
  }

  static AdjointValue createZero(llvm::BumpPtrAllocator &allocator,
                                 SILType type) {
    return new (allocator.Allocate<AdjointValueBase>()) AdjointValueBase(type);
  }

  AdjointValueKind getKind() const { return base->kind; }
  SILType getType() const { return base->type; }
  CanType getSwiftType() const { return getType().getASTType(); }

  NominalTypeDecl *getAnyNominal() const {
    return getSwiftType()->getAnyNominal();
  }

  bool isZero() const { return getKind() == AdjointValueKind::Zero; }
  bool isAggregate() const { return getKind() == AdjointValueKind::Aggregate; }
  bool isConcrete() const { return getKind() == AdjointValueKind::Concrete; }

  unsigned getNumAggregateElements() const {
    assert(isAggregate());
    return base->value.aggregate.size();
  }

  AdjointValue takeAggregateElement(unsigned i) {
    assert(isAggregate());
    return std::move(base->value.aggregate[i]);
  }

  ValueWithCleanup getConcreteValue() const {
    assert(isConcrete());
    return base->value.concrete;
  }

  void print(llvm::raw_ostream &s) const {
    switch (getKind()) {
    case AdjointValueKind::Zero:
      s << "Zero";
      break;
    case AdjointValueKind::Aggregate:
      s << "Aggregate<";
      if (auto *decl =
            getType().getASTType()->getStructOrBoundGenericStruct()) {
        s << "Struct>(";
        interleave(llvm::zip(decl->getStoredProperties(),
                             base->value.aggregate),
                             [&s](std::tuple<VarDecl *,
                                             const AdjointValue &> elt) {
                               s << std::get<0>(elt)->getName() << ": ";
                               std::get<1>(elt).print(s);
                             }, [&s] { s << ", "; });
      } else if (auto tupleType = getType().getAs<TupleType>()) {
        s << "Tuple>(";
        interleave(base->value.aggregate,
                   [&s](const AdjointValue &elt) { elt.print(s); },
                   [&s] { s << ", "; });
      } else {
        llvm_unreachable("Invalid aggregate");
      }
      s << ')';
      break;
    case AdjointValueKind::Concrete:
      s << "Concrete(" << base->value.concrete.getValue() << ')';
      break;
    }
  }
};

inline llvm::raw_ostream &operator<<(llvm::raw_ostream &os,
                                     const AdjointValue &adjVal) {
  adjVal.print(os);
  return os;
}

} // end anonymous namespace

//===----------------------------------------------------------------------===//
// AdjointEmitter - visitors on the original function for adjoint code
// generation
//===----------------------------------------------------------------------===//

namespace {
class AdjointEmitter final : public SILInstructionVisitor<AdjointEmitter> {
private:
  /// The global AD context.
  ADContext &context;

  /// The `[differentiable]` attribute.
  SILDifferentiableAttr *attr;

  /// The original function.
  SILFunction *original;

  /// The adjoint function.
  SILFunction *adjoint;

  /// The VJP function.
  SILFunction *vjp;

  /// The primal info.
  PrimalInfo &primalInfo;

  /// The differentiation invoker.
  DifferentiationInvoker invoker;

  /// Info from activity analysis on the original function.
  const DifferentiableActivityInfo &activityInfo;

  /// Post-dominance info.
  const PostDominanceInfo &postDomInfo;

  /// Mapping from original values to their corresponding adjoint values.
  DenseMap<SILValue, AdjointValue> valueMap;

  /// Mapping from original buffers to their corresponding adjoint buffers.
  DenseMap<SILValue, ValueWithCleanup> bufferMap;

  /// Mapping from original basic blocks to their corresponding adjoint basic
  /// blocks.
  DenseMap<SILBasicBlock *, SILBasicBlock *> adjointBBMap;

  /// Local stack allocations.
  SmallVector<ValueWithCleanup, 8> localAllocations;

  /// The primal value aggregate passed to the adjoint function.
  SILArgument *primalValueAggregateInAdj = nullptr;

  /// The seed argument in the adjoint function.
  SILArgument *seed = nullptr;

  /// The main builder.
  SILBuilder builder;

  /// An auxiliary local allocation builder.
  SILBuilder localAllocBuilder;

  llvm::BumpPtrAllocator allocator;

  bool errorOccurred = false;

  ADContext &getContext() const { return context; }

  SILModule &getModule() const { return getContext().getModule(); }

  ASTContext &getASTContext() const {
    return adjoint->getASTContext();
  }

  PrimalInfo &getPrimalInfo() {
    return primalInfo;
  }

  SILFunction &getOriginal() const { return *original; }
  SILFunction &getAdjoint() const { return *adjoint; }

  const SILAutoDiffIndices &getIndices() const { return attr->getIndices(); }

public:
  explicit AdjointEmitter(ADContext &context,
                          SILFunction *original,
                          SILDifferentiableAttr *attr,
                          SILFunction *adjoint,
                          SILFunction *vjp,
                          PrimalInfo &primalInfo,
                          DifferentiationInvoker invoker,
                          const DifferentiableActivityInfo &activityInfo,
                          PostDominanceInfo &postDomInfo)
      : context(context), attr(attr), original(original), adjoint(adjoint),
        vjp(vjp), primalInfo(primalInfo), invoker(invoker),
        activityInfo(activityInfo), postDomInfo(postDomInfo),
        builder(getAdjoint()), localAllocBuilder(getAdjoint()) {}

private:
  //--------------------------------------------------------------------------//
  // Managed value factory methods
  //--------------------------------------------------------------------------//

  Cleanup *makeCleanup(SILValue value, Cleanup::Func func,
                       ArrayRef<Cleanup *> children = {});

  Cleanup *makeCleanupFromChildren(ArrayRef<Cleanup *> children);

  AdjointValue makeZeroAdjointValue(SILType type);

  AdjointValue makeConcreteAdjointValue(SILValue value);

  AdjointValue makeConcreteAdjointValue(ValueWithCleanup value);

  template<typename EltMoveRange>
  AdjointValue makeAggregateAdjointValue(SILType type, EltMoveRange &&elements);

  //--------------------------------------------------------------------------//
  // Managed value materializers
  //--------------------------------------------------------------------------//

  /// Materialize an adjoint value. The type of the given adjoint value must be
  /// loadable.
  ValueWithCleanup materializeAdjointDirect(AdjointValue &&val,
                                            SILLocation loc);

  /// Materialize an adjoint value indirectly to a SIL buffer.
  void materializeAdjointIndirect(
      AdjointValue &&val, ValueWithCleanup &destBuffer);

  /// Materialize the given adjoint value indirectly to the specified buffer.
  /// The root address derivation of `seedBufAccess` must be the result of
  /// a `begin_access`.
  void materializeAdjointIndirectHelper(
      AdjointValue &&val, ValueWithCleanup &destBufferAccess);

  //--------------------------------------------------------------------------//
  // Helpers for managed value materializers
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
  ValueWithCleanup materializeAdjoint(AdjointValue &&val, SILLocation loc);

  /// Given two adjoint values, accumulate them.
  AdjointValue accumulateAdjointsDirect(AdjointValue &&lhs, AdjointValue &&rhs);

  /// Given two materialized adjoint values, accumulate them. These two
  /// adjoints must be objects of loadable type.
  SILValue accumulateDirect(SILValue lhs, SILValue rhs);

  /// Given two materialized adjoint values, accumulate them using
  /// `AdditiveArithmetic.+`, depending on the differentiation mode.
  void accumulateIndirect(SILValue resultBufAccess,
                          SILValue lhsBufAccess, SILValue rhsBufAccess);

  /// Given two buffers of an `AdditiveArithmetic` type, accumulate the right
  /// hand side into the left hand side using `+=`.
  void accumulateIndirect(SILValue lhsDestAccess, SILValue rhsAccess);

  //--------------------------------------------------------------------------//
  // Type transformer
  //--------------------------------------------------------------------------//

  /// Remap any archetypes into the current function's context.
  SILType remapType(SILType ty) {
    if (!ty.hasArchetype())
      return ty;
    auto *adjointGenEnv = getAdjoint().getGenericEnvironment();
    if (!adjointGenEnv)
      return ty;
    return ty.subst(getAdjoint().getModule(),
                    adjointGenEnv->getForwardingSubstitutionMap());
  }

  Optional<VectorSpace> getTangentSpace(CanType type) {
    return type->getAutoDiffAssociatedTangentSpace(
        LookUpConformanceInModule(getModule().getSwiftModule()));
  }

  /// Assuming the given type conforms to `Differentiable` after remapping,
  /// returns the associated tangent space type.
  SILType getRemappedTangentType(SILType type) {
    return SILType::getPrimitiveObjectType(
        getTangentSpace(remapType(type).getASTType())->getCanonicalType());
  }

  //--------------------------------------------------------------------------//
  // Managed value mapping
  //--------------------------------------------------------------------------//

  /// Returns true if the original value has a corresponding adjoint value.
  bool hasAdjointValue(SILValue originalValue) const {
    assert(originalValue->getType().isObject());
    return valueMap.count(originalValue);
  }

  /// Initializes an original value's corresponding adjoint value. Its adjoint
  /// value must not be present before this function is called.
  void initializeAdjointValue(SILValue originalValue,
                              AdjointValue &&adjointValue) {
    auto insertion =
        valueMap.try_emplace(originalValue, std::move(adjointValue));
    assert(insertion.second && "Adjoint value inserted before");
  }

  /// Get the adjoint for an original value. The given value must be in the
  /// original function.
  ///
  /// This method first tries to find an entry in `adjointMap`. If an adjoint
  /// doesn't exist, create a zero adjoint.
  AdjointValue takeAdjointValue(SILValue originalValue) {
    assert(originalValue->getType().isObject());
    assert(originalValue->getFunction() == &getOriginal());
    auto insertion = valueMap.try_emplace(
        originalValue, makeZeroAdjointValue(
            getRemappedTangentType(originalValue->getType())));
    auto it = insertion.first;
    SWIFT_DEFER { valueMap.erase(it); };
    return std::move(it->getSecond());
  }

  /// Add an adjoint value for the given original value.
  void addAdjointValue(SILValue originalValue, AdjointValue &&newAdjointValue) {
    assert(originalValue->getType().isObject());
    assert(newAdjointValue.getType().isObject());
    assert(originalValue->getFunction() == &getOriginal());
    LLVM_DEBUG(getADDebugStream() << "Adding adjoint for " << originalValue);
#ifndef NDEBUG
    auto origTy = remapType(originalValue->getType()).getASTType();
    auto tanSpace = origTy->getAutoDiffAssociatedTangentSpace(
        LookUpConformanceInModule(getModule().getSwiftModule()));
    // The adjoint value must be in the tangent space.
    assert(tanSpace && newAdjointValue.getType().getASTType()->isEqual(
               tanSpace->getCanonicalType()));
#endif
    auto insertion =
        valueMap.try_emplace(originalValue, std::move(newAdjointValue));
    auto inserted = insertion.second;
    if (inserted)
      return;
    // If adjoint already exists, accumulate the adjoint onto the existing
    // adjoint.
    auto it = insertion.first;
    auto &&existingValue = it->getSecond();
    valueMap.erase(it);
    initializeAdjointValue(originalValue,
        accumulateAdjointsDirect(std::move(existingValue),
                                 std::move(newAdjointValue)));
  }

  //--------------------------------------------------------------------------//
  // Buffer mapping
  //--------------------------------------------------------------------------//

  void setAdjointBuffer(SILValue originalBuffer,
                        ValueWithCleanup adjointBuffer) {
    assert(originalBuffer->getType().isAddress());
    auto insertion = bufferMap.try_emplace(originalBuffer, adjointBuffer);
    assert(insertion.second); (void)insertion;
  }

  SILValue getAdjointProjection(SILValue originalProjection) {
    // Handle `struct_element_addr`.
    if (auto *seai = dyn_cast<StructElementAddrInst>(originalProjection)) {
      auto adjSource = getAdjointBuffer(seai->getOperand());
      auto *tangentVectorDecl =
          adjSource.getType().getStructOrBoundGenericStruct();
      auto tanFieldLookup =
          tangentVectorDecl->lookupDirect(seai->getField()->getName());
      assert(tanFieldLookup.size() == 1);
      auto *tanField = cast<VarDecl>(tanFieldLookup.front());
      return builder.createStructElementAddr(
         seai->getLoc(), adjSource.getValue(), tanField);
    }
    // Handle `tuple_element_addr`.
    if (auto *teai = dyn_cast<TupleElementAddrInst>(originalProjection)) {
      auto source = teai->getOperand();
      auto adjSource = getAdjointBuffer(source);
      if (!adjSource.getType().is<TupleType>())
        return adjSource;
      auto origTupleTy = source->getType().castTo<TupleType>();
      unsigned adjIndex = 0;
      for (unsigned i : range(teai->getFieldNo())) {
        if (getTangentSpace(
                origTupleTy->getElement(i).getType()->getCanonicalType()))
          ++adjIndex;
      }
      return builder.createTupleElementAddr(
          teai->getLoc(), adjSource.getValue(), adjIndex);
    }
    // Handle `begin_access`.
    if (auto *bai = dyn_cast<BeginAccessInst>(originalProjection)) {
      auto adjBase = getAdjointBuffer(bai->getOperand());
      if (errorOccurred)
        return (bufferMap[originalProjection] = ValueWithCleanup());
      return builder.createBeginAccess(
          bai->getLoc(), adjBase, bai->getAccessKind(), bai->getEnforcement(),
          /*noNestedConflict*/ false, /*fromBuiltin*/ false);
    }
    return SILValue();
  }

  ValueWithCleanup &getAdjointBuffer(SILValue originalBuffer) {
    assert(originalBuffer->getType().isAddress());
    assert(originalBuffer->getFunction() == &getOriginal());
    auto insertion = bufferMap.try_emplace(originalBuffer,
                                           ValueWithCleanup(SILValue()));
    if (!insertion.second) // not inserted
      return insertion.first->getSecond();

    // Diagnose `struct_element_addr` instructions to `@noDerivative` fields.
    if (auto *seai = dyn_cast<StructElementAddrInst>(originalBuffer)) {
      if (seai->getField()->getAttrs().hasAttribute<NoDerivativeAttr>()) {
        getContext().emitNondifferentiabilityError(
            originalBuffer, invoker,
            diag::autodiff_noderivative_stored_property);
        errorOccurred = true;
        return (bufferMap[originalBuffer] = ValueWithCleanup());
      }
    }

    // If the original buffer is a projection, return a corresponding projection
    // into the adjoint buffer.
    if (auto adjProj = getAdjointProjection(originalBuffer)) {
      ValueWithCleanup projWithCleanup(
          adjProj, makeCleanup(adjProj, /*cleanup*/ nullptr));
      return (bufferMap[originalBuffer] = projWithCleanup);
    }

    // Set insertion point for local allocation builder: before the last local
    // allocation, or at the start of the adjoint entry BB if no local
    // allocations exist yet.
    if (localAllocations.empty())
      localAllocBuilder.setInsertionPoint(
          getAdjoint().getEntryBlock(), getAdjoint().getEntryBlock()->begin());
    else
      localAllocBuilder.setInsertionPoint(
          localAllocations.back().getValue()->getDefiningInstruction());
    // Allocate local buffer and initialize to zero.
    auto *newBuf = localAllocBuilder.createAllocStack(
        originalBuffer.getLoc(),
        getRemappedTangentType(originalBuffer->getType()));
    auto *access = localAllocBuilder.createBeginAccess(
        newBuf->getLoc(), newBuf, SILAccessKind::Init,
        SILAccessEnforcement::Static, /*noNestedConflict*/ true,
        /*fromBuiltin*/ false);
    // Temporarily change global builder insertion point and emit zero into the
    // local buffer.
    auto insertionPoint = builder.getInsertionBB();
    builder.setInsertionPoint(localAllocBuilder.getInsertionPoint());
    emitZeroIndirect(access->getType().getASTType(), access, access->getLoc());
    builder.setInsertionPoint(insertionPoint);
    localAllocBuilder.createEndAccess(
        access->getLoc(), access, /*aborted*/ false);
    // Create cleanup for local buffer.
    ValueWithCleanup bufWithCleanup(newBuf, makeCleanup(newBuf, emitCleanup));
    localAllocations.push_back(bufWithCleanup);
    return (insertion.first->getSecond() = bufWithCleanup);
  }

  // Accumulates `rhsBufferAccess` into the adjoint buffer corresponding to
  // `originalBuffer`.
  void addToAdjointBuffer(SILValue originalBuffer,
                          SILValue rhsBufferAccess) {
    assert(originalBuffer->getType().isAddress() &&
           rhsBufferAccess->getType().isAddress());
    assert(originalBuffer->getFunction() == &getOriginal());
    assert(rhsBufferAccess->getFunction() == &getAdjoint());
    auto adjointBuffer = getAdjointBuffer(originalBuffer);
    if (errorOccurred)
      return;
    auto *destAccess = builder.createBeginAccess(
        rhsBufferAccess.getLoc(), adjointBuffer, SILAccessKind::Modify,
        SILAccessEnforcement::Static, /*noNestedConflict*/ true,
        /*fromBuiltin*/ false);
    accumulateIndirect(destAccess, rhsBufferAccess);
    builder.createEndAccess(
        destAccess->getLoc(), destAccess, /*aborted*/ false);
  }

  //--------------------------------------------------------------------------//
  // CFG mapping
  //--------------------------------------------------------------------------//

  SILBasicBlock *getAdjointBlock(SILBasicBlock *originalBlock) {
    return adjointBBMap.lookup(originalBlock);
  }

  //--------------------------------------------------------------------------//
  // Other utilities
  //--------------------------------------------------------------------------//
  
  bool shouldBeDifferentiated(SILInstruction *inst,
                              const SILAutoDiffIndices &indices) {
    // Anything with an active result should be differentiated.
    if (llvm::any_of(inst->getResults(),
            [&](SILValue val) { return activityInfo.isActive(val, indices); }))
      return true;
    if (auto *ai = dyn_cast<ApplyInst>(inst)) {
      // Function applications with an active indirect result should be
      // differentiated.
      for (auto indRes : ai->getIndirectSILResults())
        if (activityInfo.isActive(indRes, indices))
          return true;
      // Function applications with an inout argument should be differentiated.
      auto paramInfos = ai->getSubstCalleeConv().getParameters();
      for (auto i : swift::indices(paramInfos))
        if (paramInfos[i].isIndirectInOut() &&
            activityInfo.isActive(
                ai->getArgumentsWithoutIndirectResults()[i], indices))
          return true;
    }
    // Instructions that may write to memory and has an active operand should
    // be differentiated.
    if (inst->mayWriteToMemory())
      for (auto &op : inst->getAllOperands())
        if (activityInfo.isActive(op.get(), indices))
          return true;
    return false;
  }

public:
  /// Performs adjoint synthesis on the empty adjoint function. Returns true if
  /// any error occurs.
  bool run() {
    auto &original = getOriginal();
    auto &adjoint = getAdjoint();
    auto adjLoc = getAdjoint().getLocation();
    LLVM_DEBUG(getADDebugStream() << "Running AdjointGen on\n" << original);
    // Create entry BB and arguments.
    auto *adjointEntry = adjoint.createBasicBlock();
    createEntryArguments(&adjoint);
    auto *origRet = getSingleReturn(&original);
    auto *origRetBB = origRet->getParent();
    adjointBBMap.insert({origRetBB, adjointEntry});
    // The adjoint function has type (seed, pv) -> ([arg0], ..., [argn]).
    auto adjParamArgs = adjoint.getArgumentsWithoutIndirectResults();
    seed = adjParamArgs[0];
    primalValueAggregateInAdj = adjParamArgs[1];

    // Assign adjoint for original result.
    SmallVector<SILValue, 8> origFormalResults;
    collectAllFormalResultsInTypeOrder(original, origFormalResults);
    auto origResult = origFormalResults[getIndices().source];
    // Emit warning if original result is not varied, because it will always
    // have a zero derivative.
    if (!activityInfo.isVaried(origResult, getIndices().parameters)) {
      // Emit fixit if original result has a valid source location.
      auto sourceLoc = origResult.getLoc().getEndSourceLoc();
      if (sourceLoc.isValid()) {
        getContext()
            .diagnose(sourceLoc, diag::autodiff_nonvaried_result_fixit)
            .fixItInsertAfter(sourceLoc, ".withoutDerivative()");
      }
    }

    builder.setInsertionPoint(adjointEntry);
    if (seed->getType().isAddress()) {
      if (seed->getType().isLoadable(builder.getFunction())) {
        builder.createRetainValueAddr(adjLoc, seed,
                                      builder.getDefaultAtomicity());
      }
      setAdjointBuffer(origResult,
                       ValueWithCleanup(seed, makeCleanup(seed, emitCleanup)));
    } else {
      builder.createRetainValue(adjLoc, seed, builder.getDefaultAtomicity());
      initializeAdjointValue(origResult, makeConcreteAdjointValue(
          ValueWithCleanup(seed, makeCleanup(seed, emitCleanup))));
    }
    LLVM_DEBUG(getADDebugStream()
               << "Assigned seed " << *seed
               << " as the adjoint of original result " << origResult);

    // From the original exit, emit a reverse control flow graph and perform
    // differentiation in each block.
    // NOTE: For now we just assume single basic block.
    for (auto *bb : llvm::breadth_first(origRetBB)) {
      if (errorOccurred)
        break;
      // Get the corresponding adjoint basic block.
      auto adjBB = getAdjointBlock(bb);
      builder.setInsertionPoint(adjBB);
      LLVM_DEBUG({
        auto &s = getADDebugStream()
            << "To differentiate or not to differentiate?\n";
        for (auto &inst : reversed(*bb)) {
          s << (shouldBeDifferentiated(&inst, getIndices()) ? "[∂] " : "[ ] ")
            << inst;
        }
      });
      // Visit each instruction in reverse order.
      for (auto &inst : reversed(*bb)) {
        if (!shouldBeDifferentiated(&inst, getIndices()))
          continue;
        // Differentiate instruction.
        visit(&inst);
        if (errorOccurred)
          return true;
      }
    }

    // If errors occurred, back out.
    if (errorOccurred)
      return true;

    // Place the builder at the adjoint block corresponding to the original
    // entry. This block is going to be our exit block and we emit a `return`
    // there.
    builder.setInsertionPoint(getAdjointBlock(original.getEntryBlock()));

    // This vector will contain all the materialized return elements.
    SmallVector<SILValue, 8> retElts;
    // This vector will contain all indirect parameter adjoint buffers.
    SmallVector<ValueWithCleanup, 4> indParamAdjoints;

    auto origParams = original.getArgumentsWithoutIndirectResults();

    // Materializes the return element corresponding to the parameter
    // `parameterIndex` into the `retElts` vector.
    auto addRetElt = [&](unsigned parameterIndex) -> void {
      auto origParam = origParams[parameterIndex];
      if (origParam->getType().isObject()) {
        auto adjVal = takeAdjointValue(origParam);
        auto val = materializeAdjointDirect(std::move(adjVal), adjLoc);
        if (auto *cleanup = val.getCleanup()) {
          LLVM_DEBUG(getADDebugStream() << "Disabling cleanup for "
                     << val.getValue() << "for return\n");
          cleanup->disable();
          LLVM_DEBUG(getADDebugStream() << "Applying "
                     << cleanup->getNumChildren() << " child cleanups\n");
          cleanup->applyRecursively(builder, adjLoc);
        }
        retElts.push_back(val);
      } else {
        auto adjBuf = getAdjointBuffer(origParam);
        if (errorOccurred)
          return;
        indParamAdjoints.push_back(adjBuf);
      }
    };
    // Accumulate differentiation parameter adjoints.
    for (auto i : getIndices().parameters->getIndices())
      addRetElt(i);

    // Disable cleanup for original indirect parameter adjoint buffers.
    // Copy them to adjoint indirect results.
    assert(indParamAdjoints.size() == adjoint.getIndirectResults().size() &&
           "Indirect parameter adjoint count mismatch");
    for (auto pair : zip(indParamAdjoints, adjoint.getIndirectResults())) {
      auto &source = std::get<0>(pair);
      auto &dest = std::get<1>(pair);
      builder.createCopyAddr(adjLoc, source, dest, IsTake, IsInitialization);
      if (auto *cleanup = source.getCleanup())
        cleanup->disable();
    }

    // Deallocate local allocations.
    for (auto alloc : localAllocations) {
      // Assert that local allocations have at least one use.
      // Buffers should not be allocated needlessly.
      assert(!alloc.getValue()->use_empty());
      if (auto *cleanup = alloc.getCleanup())
        cleanup->applyRecursively(builder, adjLoc);
      builder.createDeallocStack(adjLoc, alloc);
    }

    builder.createReturn(adjLoc, joinElements(retElts, builder, adjLoc));

    LLVM_DEBUG(getADDebugStream() << "Generated adjoint:\n" << adjoint);
    return errorOccurred;
  }

  void visit(SILInstruction *inst) {
    if (errorOccurred)
      return;

    LLVM_DEBUG(getADDebugStream() << "AdjointEmitter visited:\n[ORIG]"
               << *inst);
#ifndef NDEBUG
    auto beforeInsertion = std::prev(builder.getInsertionPoint());
#endif
    SILInstructionVisitor::visit(inst);
    LLVM_DEBUG({
      auto &s = llvm::dbgs() << "[ADJ] Emitted:\n";
      auto afterInsertion = builder.getInsertionPoint();
      for (auto it = ++beforeInsertion; it != afterInsertion; ++it)
        s << *it;
    });
  }

  void visitSILInstruction(SILInstruction *inst) {
    LLVM_DEBUG(getADDebugStream()
               << "Unhandled instruction in adjoint emitter: " << *inst);
    getContext().emitNondifferentiabilityError(inst, invoker);
    errorOccurred = true;
  }

  void visitApplyInst(ApplyInst *ai) {
    // Replace a call to a function with a call to its pullback.
    auto &nestedApplyInfo = context.getNestedApplyInfo();
    auto applyInfoLookup = nestedApplyInfo.find(ai);
    // If no `NestedApplyInfo` was found, then this task doesn't need to be
    // differentiated.
    if (applyInfoLookup == nestedApplyInfo.end()) {
      // Must not be active.
      assert(!activityInfo.isActive(ai, getIndices()));
      return;
    }
    auto applyInfo = applyInfoLookup->getSecond();

    // Get the pullback.
    auto *field = getPrimalInfo().lookUpPullbackDecl(ai);
    assert(field);
    auto loc = ai->getLoc();
    SILValue pullback =
        builder.createStructExtract(loc, primalValueAggregateInAdj, field);

    // Get the original result of the `apply` instruction.
    SmallVector<SILValue, 8> args;
    SmallVector<SILValue, 8> origDirResults;
    collectAllExtractedElements(ai, origDirResults);
    SmallVector<SILValue, 8> origAllResults;
    collectAllActualResultsInTypeOrder(
        ai, origDirResults, ai->getIndirectSILResults(),
        origAllResults);
    auto origResult = origAllResults[applyInfo.indices.source];
    auto origNumIndRes = ai->getNumIndirectResults();

    auto pullbackType =
        remapType(pullback->getType()).castTo<SILFunctionType>();

    // Get the seed (i.e. adjoint value of the original result).
    ValueWithCleanup seed;
    if (origResult->getType().isObject()) {
      // If original result is a `tuple_extract`, materialize adjoint value of
      // `ai` and extract the corresponding element adjoint value.
      if (auto *tupleExtract = dyn_cast<TupleExtractInst>(origResult)) {
        auto adjointTuple = materializeAdjoint(takeAdjointValue(ai), loc);
        auto seedVal = builder.emitTupleExtract(loc, adjointTuple,
                                                tupleExtract->getFieldNo());
        seed = ValueWithCleanup(seedVal, makeCleanup(seedVal, emitCleanup));
      }
      // Otherwise, materialize adjoint value of `ai`.
      else {
        seed = materializeAdjoint(takeAdjointValue(origResult), loc);
      }
    } else {
      seed = getAdjointBuffer(origResult);
      if (errorOccurred)
        return;
    }

    // Create allocations for pullback indirect results.
    SmallVector<AllocStackInst *, 4> pullbackIndirectResults;
    auto actualPullbackType = applyInfo.originalPullbackType
        ? *applyInfo.originalPullbackType
        : pullbackType;
    for (auto indRes : actualPullbackType->getIndirectFormalResults()) {
      auto *alloc =
          builder.createAllocStack(loc, remapType(indRes.getSILStorageType()));
      pullbackIndirectResults.push_back(alloc);
      args.push_back(alloc);
    }

    // If pullback was reabstracted in primal, reabstract pullback in adjoint.
    if (applyInfo.originalPullbackType) {
      SILOptFunctionBuilder fb(getContext().getTransform());
      auto *thunk = getOrCreateReabstractionThunk(
          fb, getContext().getModule(), loc, &getAdjoint(),
          pullbackType, *applyInfo.originalPullbackType);
      auto *thunkRef = builder.createFunctionRef(loc, thunk);
      pullback = builder.createPartialApply(
          loc, thunkRef, thunk->getForwardingSubstitutionMap(),
          {pullback}, pullbackType->getCalleeConvention());
    }
    args.push_back(seed);

    // Call the pullback.
    auto *pullbackCall = builder.createApply(
        loc, pullback, SubstitutionMap(), args, /*isNonThrowing*/ false);

    // Extract all results from `pullbackCall`.
    SmallVector<SILValue, 8> dirResults;
    extractAllElements(pullbackCall, builder, dirResults);
    // Get all results in type-defined order.
    SmallVector<SILValue, 8> allResults;
    collectAllActualResultsInTypeOrder(
        pullbackCall, dirResults, pullbackCall->getIndirectSILResults(),
        allResults);
    LLVM_DEBUG({
      auto &s = getADDebugStream();
      s << "All direct results of the nested pullback call:\n";
      llvm::for_each(dirResults, [&](SILValue v) { s << v; });
      s << "All indirect results of the nested pullback call:\n";
      llvm::for_each(pullbackCall->getIndirectSILResults(),
                     [&](SILValue v) { s << v; });
      s << "All results of the nested pullback call:\n";
      llvm::for_each(allResults, [&](SILValue v) { s << v; });
    });

    // Accumulate adjoints for original differentiation parameters.
    auto allResultsIt = allResults.begin();
    for (unsigned i : applyInfo.indices.parameters->getIndices()) {
      auto origArg = ai->getArgument(origNumIndRes + i);
      auto tan = *allResultsIt++;
      if (tan->getType().isAddress()) {
        addToAdjointBuffer(origArg, tan);
        emitCleanup(builder, loc, tan);
      } else {
        if (origArg->getType().isAddress()) {
          auto adjBuf = getAdjointBuffer(origArg);
          if (errorOccurred)
            return;
          auto *tmpBuf = builder.createAllocStack(loc, tan->getType());
          builder.createStore(loc, tan, tmpBuf,
              getBufferSOQ(tmpBuf->getType().getASTType(), getAdjoint()));
          auto *readAccess = builder.createBeginAccess(
              loc, tmpBuf, SILAccessKind::Read, SILAccessEnforcement::Static,
              /*noNestedConflict*/ true, /*fromBuiltin*/ false);
          accumulateIndirect(adjBuf, readAccess);
          builder.createEndAccess(loc, readAccess, /*aborted*/ false);
          emitCleanup(builder, loc, tmpBuf);
          builder.createDeallocStack(loc, tmpBuf);
        }
        else
          addAdjointValue(origArg, makeConcreteAdjointValue(ValueWithCleanup(
              tan, makeCleanup(tan, emitCleanup, {seed.getCleanup()}))));
      }
    }
    // Deallocate pullback indirect results.
    for (auto *alloc : reversed(pullbackIndirectResults))
      builder.createDeallocStack(loc, alloc);
  }

  /// Handle `struct` instruction.
  ///   y = struct (x0, x1, x2, ...)
  ///   adj[x0] += struct_extract adj[y], #x0
  ///   adj[x1] += struct_extract adj[y], #x1
  ///   adj[x2] += struct_extract adj[y], #x2
  ///   ...
  void visitStructInst(StructInst *si) {
    auto loc = si->getLoc();
    auto *structDecl = si->getStructDecl();
    auto av = takeAdjointValue(si);
    switch (av.getKind()) {
    case AdjointValueKind::Zero:
      for (auto *field : structDecl->getStoredProperties()) {
        auto fv = si->getFieldValue(field);
        addAdjointValue(fv, makeZeroAdjointValue(
            getRemappedTangentType(fv->getType())));
      }
      break;
    case AdjointValueKind::Concrete: {
      auto adjStruct = materializeAdjointDirect(std::move(av), loc);
      if (structDecl->getAttrs().hasAttribute<FieldwiseDifferentiableAttr>()) {
        // Find the struct `TangentVector` type.
        auto structTy = remapType(si->getType()).getASTType();
        auto tangentVectorTy = structTy->getAutoDiffAssociatedTangentSpace(
            LookUpConformanceInModule(getModule().getSwiftModule()))
                ->getType()->getCanonicalType();
        assert(!getModule().Types.getTypeLowering(
                   tangentVectorTy, ResilienceExpansion::Minimal)
                       .isAddressOnly());
        auto *tangentVectorDecl =
            tangentVectorTy->getStructOrBoundGenericStruct();
        assert(tangentVectorDecl);

        // Accumulate adjoints for the fields of the `struct` operand.
        for (auto *field : structDecl->getStoredProperties()) {
          // There does not exist a corresponding tangent field for original
          // fields with `@noDerivative` attribute. Emit an error.
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
            assert(tanFieldLookup.size() == 1);
            tanField = cast<VarDecl>(tanFieldLookup.front());
          }
          auto *adjStructElt =
              builder.createStructExtract(loc, adjStruct, tanField);
          addAdjointValue(
              si->getFieldValue(field),
              makeConcreteAdjointValue(ValueWithCleanup(
                  adjStructElt, makeCleanup(adjStructElt, emitCleanup))));
        }
      } else {
        // FIXME(TF-21): If `TangentVector` is not marked
        // `@_fieldwiseProductSpace`, call the VJP of the memberwise initializer.
        llvm_unreachable("Unhandled. Are you trying to differentiate a "
                         "memberwise initializer?");
      }
      break;
    }
    case AdjointValueKind::Aggregate: {
      // FIXME(TF-21): If `TangentVector` is not marked
      // `@_fieldwiseProductSpace`, call the VJP of the memberwise initializer.
      // for (auto pair : llvm::zip(si->getElements(), av.getAggregateElements()))
      //   addAdjointValue(std::get<0>(pair), std::get<1>(pair));
      llvm_unreachable("Unhandled. Are you trying to differentiate a "
                       "memberwise initializer?");
    }
    }
  }

  void visitStructExtractInst(StructExtractInst *sei) {
    assert(!sei->getField()->getAttrs().hasAttribute<NoDerivativeAttr>() &&
           "`struct_extract` with `@noDerivative` field should not be "
           "differentiated; activity analysis should not marked as varied");
    auto loc = sei->getLoc();
    auto &differentiationStrategies =
        context.getStructExtractDifferentiationStrategies();
    auto strategy = differentiationStrategies.lookup(sei);
    switch (strategy) {
    case StructExtractDifferentiationStrategy::Inactive:
      assert(!activityInfo.isActive(sei, getIndices()));
      return;
    case StructExtractDifferentiationStrategy::Fieldwise: {
      // Compute adjoint as follows:
      //   y = struct_extract x, #key
      //   adj[x] += struct (0, ..., #key': adj[y], ..., 0)
      // where `#key'` is the field in the tangent space corresponding to
      // `#key`.
      auto structTy = remapType(sei->getOperand()->getType()).getASTType();
      auto tangentVectorTy = structTy->getAutoDiffAssociatedTangentSpace(
          LookUpConformanceInModule(getModule().getSwiftModule()))
              ->getType()->getCanonicalType();
      assert(!getModule().Types.getTypeLowering(
                 tangentVectorTy, ResilienceExpansion::Minimal)
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
        assert(tanFieldLookup.size() == 1);
        tanField = cast<VarDecl>(tanFieldLookup.front());
      }
      // Accumulate adjoint for the `struct_extract` operand.
      auto av = takeAdjointValue(sei);
      switch (av.getKind()) {
      case AdjointValueKind::Zero:
        addAdjointValue(sei->getOperand(),
                        makeZeroAdjointValue(tangentVectorSILTy));
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
                    fieldTy, ResilienceExpansion::Minimal);
            assert(fieldSILTy.isObject());
            eltVals.push_back(makeZeroAdjointValue(fieldSILTy));
          }
        }
        addAdjointValue(sei->getOperand(),
            makeAggregateAdjointValue(tangentVectorSILTy, eltVals));
      }
      }
      return;
    }
    case StructExtractDifferentiationStrategy::Getter: {
      // Get the pullback.
      auto *pullbackField = getPrimalInfo().lookUpPullbackDecl(sei);
      assert(pullbackField);
      auto pullback = builder.createStructExtract(
          loc, primalValueAggregateInAdj, pullbackField);

      // Construct the pullback arguments.
      auto av = takeAdjointValue(sei);
      auto vector = materializeAdjointDirect(std::move(av), loc);

      // Call the pullback.
      auto *pullbackCall = builder.createApply(
          loc, pullback, SubstitutionMap(), {vector}, /*isNonThrowing*/ false);
      assert(!pullbackCall->hasIndirectResults());

      // Accumulate adjoint for the `struct_extract` operand.
      addAdjointValue(sei->getOperand(),
          makeConcreteAdjointValue(
              ValueWithCleanup(pullbackCall, vector.getCleanup())));
      break;
    }
    }
  }

  /// Handle `tuple` instruction.
  ///   y = tuple (x0, x1, x2, ...)
  ///   adj[x0] += tuple_extract adj[y], 0
  ///   ...
  void visitTupleInst(TupleInst *ti) {
    auto av = takeAdjointValue(ti);
    switch (av.getKind()) {
    case AdjointValueKind::Zero:
      for (auto eltVal : ti->getElements()) {
        if (!getTangentSpace(eltVal->getType().getASTType()))
          continue;
        addAdjointValue(eltVal, makeZeroAdjointValue(
            getRemappedTangentType(eltVal->getType())));
      }
      break;
    case AdjointValueKind::Concrete: {
      auto val = av.getConcreteValue();
      unsigned adjIdx = 0;
      for (auto i : range(ti->getNumOperands())) {
        if (!getTangentSpace(ti->getOperand(i)->getType().getASTType()))
          continue;
        auto adjElt = val;
        if (val.getType().is<TupleType>())
          adjElt = ValueWithCleanup(builder.createTupleExtract(
              ti->getLoc(), val, adjIdx++), val.getCleanup());
        addAdjointValue(ti->getOperand(i), makeConcreteAdjointValue(adjElt));
      }
      break;
    }
    case AdjointValueKind::Aggregate:
      unsigned adjIdx = 0;
      for (auto i : range(ti->getElements().size())) {
        if (!getTangentSpace(ti->getElement(i)->getType().getASTType()))
          continue;
        addAdjointValue(ti->getElement(i), av.takeAggregateElement(adjIdx++));
      }
      break;
    }
  }

  /// Handle `tuple_extract` instruction.
  ///   y = tuple_extract x, <n>
  ///                         |--- n-th element
  ///   adj[x] += tuple (0, 0, ..., adj[y], ..., 0, 0)
  void visitTupleExtractInst(TupleExtractInst *tei) {
    auto tupleTanTy = getRemappedTangentType(tei->getOperand()->getType());
    auto av = takeAdjointValue(tei);
    switch (av.getKind()) {
    case AdjointValueKind::Zero:
      addAdjointValue(tei->getOperand(), makeZeroAdjointValue(tupleTanTy));
      break;
    case AdjointValueKind::Aggregate:
    case AdjointValueKind::Concrete: {
      auto tupleTy = tei->getTupleType();
      auto tupleTanTupleTy = tupleTanTy.getAs<TupleType>();
      if (!tupleTanTupleTy) {
        addAdjointValue(tei->getOperand(), std::move(av));
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
        addAdjointValue(tei->getOperand(), std::move(elements.front()));
        break;
      }
      addAdjointValue(tei->getOperand(),
          makeAggregateAdjointValue(tupleTanTy, elements));
      break;
    }
    }
  }

  // Handle `alloc_stack` instruction.
  //   Original: y = alloc_stack $T
  //    Adjoint: dealloc_stack adj[y]
  void visitAllocStackInst(AllocStackInst *asi) {
    auto adjBuf = getAdjointBuffer(asi);
    if (errorOccurred)
      return;
    if (auto *cleanup = adjBuf.getCleanup())
      cleanup->applyRecursively(builder, asi->getLoc());
    builder.createDeallocStack(asi->getLoc(), adjBuf);
  }

  // Handle `dealloc_stack` instruction.
  //   Original: dealloc_stack y
  //    Adjoint: adj[y] = alloc_stack $T.TangentVector
  void visitDeallocStackInst(DeallocStackInst *dsi) {
    auto bufType = getRemappedTangentType(dsi->getOperand()->getType());
    auto *adjBuf = builder.createAllocStack(dsi->getLoc(), bufType);
    auto *access = builder.createBeginAccess(dsi->getLoc(), adjBuf,
                                             SILAccessKind::Init,
                                             SILAccessEnforcement::Static,
                                             /*noNestedConflict*/ true,
                                             /*fromBuiltin*/ false);
    emitZeroIndirect(bufType.getASTType(), access, dsi->getLoc());
    builder.createEndAccess(dsi->getLoc(), access, /*aborted*/ false);
    setAdjointBuffer(dsi->getOperand(),
        ValueWithCleanup(adjBuf, makeCleanup(adjBuf, emitCleanup)));
  }

  // Handle `load` instruction.
  //   Original: y = load x
  //    Adjoint: adj[x] += adj[y]
  void visitLoadInst(LoadInst *li) {
    auto adjVal = materializeAdjointDirect(takeAdjointValue(li), li->getLoc());
    // Allocate a local buffer and store the adjoint value. This buffer will be
    // used for accumulation into the adjoint buffer.
    auto *localBuf = builder.createAllocStack(li->getLoc(), adjVal.getType());
    auto *initAccess = builder.createBeginAccess(
        li->getLoc(), localBuf, SILAccessKind::Init,
        SILAccessEnforcement::Static, /*noNestedConflict*/ true,
        /*fromBuiltin*/ false);
    builder.createStore(li->getLoc(), adjVal, initAccess,
        getBufferSOQ(localBuf->getType().getASTType(), getAdjoint()));
    builder.createEndAccess(li->getLoc(), initAccess, /*aborted*/ false);
    // Get the adjoint buffer.
    auto &adjBuf = getAdjointBuffer(li->getOperand());
    if (errorOccurred)
      return;
    // Accumulate the adjoint value in the local buffer into the adjoint buffer.
    auto *readAccess = builder.createBeginAccess(
        li->getLoc(), localBuf, SILAccessKind::Read,
        SILAccessEnforcement::Static, /*noNestedConflict*/ true,
        /*fromBuiltin*/ false);
    accumulateIndirect(adjBuf, readAccess);
    // Combine the adjoint buffer's original child cleanups with the adjoint
    // value's cleanup.
    adjBuf.setCleanup(makeCleanupFromChildren({adjBuf.getCleanup(),
                                               adjVal.getCleanup()}));
    builder.createEndAccess(li->getLoc(), readAccess, /*aborted*/ false);
    builder.createDeallocStack(li->getLoc(), localBuf);
  }

  // Handle `store` instruction.
  //   Original: store x to y
  //    Adjoint: adj[x] += load adj[y]; adj[y] = 0
  void visitStoreInst(StoreInst *si) {
    auto &adjBuf = getAdjointBuffer(si->getDest());
    if (errorOccurred)
      return;
    auto bufType = remapType(adjBuf.getType());
    auto adjVal = builder.createLoad(si->getLoc(), adjBuf,
        getBufferLOQ(bufType.getASTType(), getAdjoint()));
    // Disable the buffer's top-level cleanup (which is supposed to operate on
    // the buffer), create a cleanup for the value that carrys all child
    // cleanups.
    auto valueCleanup = makeCleanup(adjVal, emitCleanup,
        adjBuf.getCleanup()
            ? adjBuf.getCleanup()->getChildren() : ArrayRef<Cleanup *>());
    addAdjointValue(si->getSrc(), makeConcreteAdjointValue(
        ValueWithCleanup(adjVal, valueCleanup)));
    // Set the buffer to zero, with a cleanup.
    auto *bai = dyn_cast<BeginAccessInst>(adjBuf.getValue());
    if (bai && !(bai->getAccessKind() == SILAccessKind::Modify ||
                 bai->getAccessKind() == SILAccessKind::Init)) {
      auto *modifyAccess = builder.createBeginAccess(
          si->getLoc(), bai->getSource(), SILAccessKind::Modify,
          SILAccessEnforcement::Static, /*noNestedConflict*/ true,
          /*fromBuiltin*/ false);
      emitZeroIndirect(bufType.getASTType(), modifyAccess, si->getLoc());
      builder.createEndAccess(si->getLoc(), modifyAccess, /*aborted*/ false);
    } else {
      emitZeroIndirect(bufType.getASTType(), adjBuf, si->getLoc());
    }
  }

  // Handle `copy_addr` instruction.
  //   Original: copy_addr x to y
  //    Adjoint: adj[x] += adj[y]; adj[y] = 0
  void visitCopyAddrInst(CopyAddrInst *cai) {
    auto &adjDest = getAdjointBuffer(cai->getDest());
    if (errorOccurred)
      return;
    auto destType = remapType(adjDest.getType());
    // Disable the buffer's top-level cleanup (which is supposed to operate on
    // the buffer), create a cleanup for the value that carrys all child
    // cleanups.
    auto valueCleanup = makeCleanup(adjDest, emitCleanup,
        adjDest.getCleanup()
            ? adjDest.getCleanup()->getChildren() : ArrayRef<Cleanup *>());
    adjDest.setCleanup(valueCleanup);
    auto *readAccess = builder.createBeginAccess(
        cai->getLoc(), adjDest, SILAccessKind::Read,
        SILAccessEnforcement::Static, /*noNestedConflict*/ true,
        /*fromBuiltin*/ false);
    addToAdjointBuffer(cai->getSrc(), readAccess);
    builder.createEndAccess(cai->getLoc(), readAccess, /*aborted*/ false);
    // Set the buffer to zero, with a cleanup.
    auto *bai = dyn_cast<BeginAccessInst>(adjDest.getValue());
    if (bai && !(bai->getAccessKind() == SILAccessKind::Modify ||
                 bai->getAccessKind() == SILAccessKind::Init)) {
      auto *modifyAccess = builder.createBeginAccess(
          cai->getLoc(), bai->getSource(), SILAccessKind::Modify,
          SILAccessEnforcement::Static, /*noNestedConflict*/ true,
          /*fromBuiltin*/ false);
      emitZeroIndirect(destType.getASTType(), modifyAccess, cai->getLoc());
      builder.createEndAccess(cai->getLoc(), modifyAccess, /*aborted*/ false);
    } else {
      emitZeroIndirect(destType.getASTType(), adjDest, cai->getLoc());
    }
    auto cleanup = makeCleanup(adjDest, emitCleanup);
    adjDest.setCleanup(cleanup);
  }

  // Handle `begin_access` instruction.
  //   Original: y = begin_access x
  //    Adjoint: end_access adj[y]
  void visitBeginAccessInst(BeginAccessInst *bai) {
    // Check for non-differentiable writes.
    if (bai->getAccessKind() == SILAccessKind::Modify) {
      if (auto *gai = dyn_cast<GlobalAddrInst>(bai->getSource())) {
        getContext()
            .emitNondifferentiabilityError(bai, invoker,
                diag::autodiff_cannot_differentiate_writes_to_global_variables);
        errorOccurred = true;
        return;
      }
      if (auto *pbi = dyn_cast<ProjectBoxInst>(bai->getSource())) {
        getContext()
            .emitNondifferentiabilityError(bai, invoker,
                diag::autodiff_cannot_differentiate_writes_to_mutable_captures);
        errorOccurred = true;
        return;
      }
    }
    auto accessBuf = getAdjointBuffer(bai);
    auto &sourceBuf = getAdjointBuffer(bai->getSource());
    sourceBuf.setCleanup(makeCleanupFromChildren({sourceBuf.getCleanup(),
                                                  accessBuf.getCleanup()}));
    if (errorOccurred)
      return;
    builder.createEndAccess(bai->getLoc(), accessBuf, /*aborted*/ false);
  }

  // Handle `end_access` instruction.
  //   Original: end_access y, where y = begin_access x
  //    Adjoint: adj[y] = begin_access inverse(access_kind) adj[x]
  void visitEndAccessInst(EndAccessInst *eai) {
    auto adjBuf = getAdjointBuffer(eai->getSource());
    if (errorOccurred)
      return;
    SILAccessKind kind;
    switch (eai->getBeginAccess()->getAccessKind()) {
    case SILAccessKind::Read: kind = SILAccessKind::Modify; break;
    case SILAccessKind::Modify: kind = SILAccessKind::Read; break;
    case SILAccessKind::Init: kind = SILAccessKind::Deinit; break;
    case SILAccessKind::Deinit: kind = SILAccessKind::Init; break;
    }
    auto adjAccess = builder.createBeginAccess(
        eai->getLoc(), adjBuf, kind, eai->getBeginAccess()->getEnforcement(),
        eai->getBeginAccess()->hasNoNestedConflict(),
        eai->getBeginAccess()->isFromBuiltin());
    setAdjointBuffer(eai->getOperand(),
                     ValueWithCleanup(adjAccess, makeCleanupFromChildren({})));
  }

#define PROPAGATE_BUFFER_CLEANUP(INST) \
  void visit##INST##Inst(INST##Inst *inst) { \
    auto &adjBase = getAdjointBuffer(inst->getOperand()); \
    auto &adjProj = getAdjointBuffer(inst); \
    adjProj.setCleanup(makeCleanupFromChildren( \
        {adjProj.getCleanup(), adjBase.getCleanup()})); \
  }
  PROPAGATE_BUFFER_CLEANUP(StructElementAddr)
  PROPAGATE_BUFFER_CLEANUP(TupleElementAddr)
#undef PROPAGATE_CLEANUP

#define NOT_DIFFERENTIABLE(INST, DIAG) \
  void visit##INST##Inst(INST##Inst *inst) { \
    getContext().emitNondifferentiabilityError( \
        inst, getDifferentiationTask(), DIAG); \
    errorOccurred = true; \
    return; \
  }
#undef NOT_DIFFERENTIABLE

#define NO_ADJOINT(INST) \
  void visit##INST##Inst(INST##Inst *inst) {}
  NO_ADJOINT(Return)
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
#undef NO_DERIVATIVE
};
} // end anonymous namespace

Cleanup *AdjointEmitter::makeCleanup(SILValue value, Cleanup::Func func,
                                     ArrayRef<Cleanup *> children) {
  SmallVector<Cleanup *, 2> nonnullChildren;
  for (auto *c : children)
    if (c) nonnullChildren.push_back(c);
  return Cleanup::create(allocator, value, func, nonnullChildren);
}

Cleanup *AdjointEmitter::makeCleanupFromChildren(ArrayRef<Cleanup *> children) {
  if (children.empty())
    return nullptr;
  if (children.size() == 1)
    return children.front();
  SmallSetVector<Cleanup *, 8> uniqued(children.begin(), children.end());
  return makeCleanup(SILValue(), /*func*/ nullptr, uniqued.getArrayRef());
}

AdjointValue AdjointEmitter::makeZeroAdjointValue(SILType type) {
  return AdjointValue::createZero(allocator, remapType(type));
}

AdjointValue
AdjointEmitter::makeConcreteAdjointValue(ValueWithCleanup value) {
  return AdjointValue::createConcrete(allocator, value);
}

template<typename EltMoveRange>
AdjointValue AdjointEmitter::makeAggregateAdjointValue(
    SILType type, EltMoveRange &&elements) {
  return AdjointValue::createAggregate(
      allocator, remapType(type), std::move(elements));
}

ValueWithCleanup AdjointEmitter::materializeAdjointDirect(
    AdjointValue &&val, SILLocation loc) {
  assert(val.getType().isObject());
  LLVM_DEBUG(getADDebugStream() <<
             "Materializing adjoints for " << val << '\n');
  switch (val.getKind()) {
  case AdjointValueKind::Zero: {
    auto zeroVal = emitZeroDirect(val.getSwiftType(), loc);
    return ValueWithCleanup(zeroVal, nullptr);
  }
  case AdjointValueKind::Aggregate: {
    SmallVector<SILValue, 8> elements;
    SmallVector<Cleanup *, 8> cleanups;
    for (auto i : range(val.getNumAggregateElements())) {
      auto eltVal = materializeAdjointDirect(val.takeAggregateElement(i), loc);
      elements.push_back(eltVal.getValue());
      cleanups.push_back(eltVal.getCleanup());
    }
    if (val.getType().is<TupleType>())
      return ValueWithCleanup(
          builder.createTuple(loc, val.getType(), elements),
                              makeCleanupFromChildren(cleanups));
    else {
      auto *adj = builder.createStruct(loc, val.getType(), elements);
      builder.createRetainValue(loc, adj, builder.getDefaultAtomicity());
      auto cleanupFn = [](SILBuilder &b, SILLocation l, SILValue v) {
        b.createReleaseValue(l, v, b.getDefaultAtomicity());
      };
      return ValueWithCleanup(adj, makeCleanup(adj, cleanupFn, cleanups));
    }
  }
  case AdjointValueKind::Concrete:
    return val.getConcreteValue();
  }
}

void AdjointEmitter::materializeAdjointIndirect(
    AdjointValue &&val, ValueWithCleanup &destBuffer) {
  ValueWithCleanup access(
      builder.createBeginAccess(
          destBuffer.getLoc(), destBuffer, SILAccessKind::Init,
          SILAccessEnforcement::Static, /*noNestedConflict*/ true,
          /*fromBuiltin*/ false),
          /*cleanup*/ nullptr);
  materializeAdjointIndirectHelper(std::move(val), access);
  destBuffer.setCleanup(access.getCleanup());
  builder.createEndAccess(access.getLoc(), access, /*aborted*/ false);
}

ValueWithCleanup AdjointEmitter::materializeAdjoint(AdjointValue &&val,
                                                    SILLocation loc) {
  if (val.isConcrete()) {
    LLVM_DEBUG(getADDebugStream()
        << "Materializing adjoint: Value is concrete.\n");
    return val.getConcreteValue();
  }
  LLVM_DEBUG(getADDebugStream() << "Materializing adjoint: Value is "
                                   "non-concrete. Materializing directly.\n");
  return materializeAdjointDirect(std::move(val), loc);
}

void AdjointEmitter::materializeAdjointIndirectHelper(
    AdjointValue &&val, ValueWithCleanup &destBufferAccess) {
  auto loc = destBufferAccess.getLoc();
  auto soq = getBufferSOQ(val.getType().getASTType(), builder.getFunction());
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
        ValueWithCleanup eltBuf(
            builder.createTupleElementAddr(loc, destBufferAccess, idx, eltTy),
            /*cleanup*/ nullptr);
        materializeAdjointIndirectHelper(val.takeAggregateElement(idx), eltBuf);
        destBufferAccess.setCleanup(makeCleanupFromChildren(
            {destBufferAccess.getCleanup(), eltBuf.getCleanup()}));
      }
    } else if (auto *structDecl =
                   val.getSwiftType()->getStructOrBoundGenericStruct()) {
      auto fieldIt = structDecl->getStoredProperties().begin();
      for (unsigned i = 0; fieldIt != structDecl->getStoredProperties().end();
           ++fieldIt, ++i) {
        ValueWithCleanup eltBuf(
            builder.createStructElementAddr(loc, destBufferAccess, *fieldIt),
            /*cleanup*/ nullptr);
        materializeAdjointIndirectHelper(val.takeAggregateElement(i), eltBuf);
        destBufferAccess.setCleanup(makeCleanupFromChildren(
            {destBufferAccess.getCleanup(), eltBuf.getCleanup()}));
      }
    } else {
      llvm_unreachable("Not an aggregate type");
    }
    break;
  }
  /// Value is already materialized!
  case AdjointValueKind::Concrete:
    auto concreteVal = val.getConcreteValue();
    builder.createStore(loc, concreteVal, destBufferAccess, soq);
    destBufferAccess.setCleanup(makeCleanupFromChildren(
        {destBufferAccess.getCleanup(), concreteVal.getCleanup()}));
    break;
  }
}

void AdjointEmitter::emitZeroIndirect(CanType type, SILValue bufferAccess,
                                      SILLocation loc) {
  auto *swiftMod = getModule().getSwiftModule();
  auto tangentSpace = type->getAutoDiffAssociatedTangentSpace(
      LookUpConformanceInModule(swiftMod));
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

SILValue AdjointEmitter::emitZeroDirect(CanType type, SILLocation loc) {
  auto silType = getModule().Types.getLoweredLoadableType(
      type, ResilienceExpansion::Minimal);
  auto *buffer = builder.createAllocStack(loc, silType);
  auto *initAccess = builder.createBeginAccess(loc, buffer, SILAccessKind::Init,
                                               SILAccessEnforcement::Static,
                                               /*noNestedConflict*/ true,
                                               /*fromBuiltin*/ false);
  emitZeroIndirect(type, initAccess, loc);
  builder.createEndAccess(loc, initAccess, /*aborted*/ false);
  auto readAccess = builder.createBeginAccess(loc, buffer, SILAccessKind::Read,
                                              SILAccessEnforcement::Static,
                                              /*noNestedConflict*/ true,
                                              /*fromBuiltin*/ false);
  auto *loaded = builder.createLoad(loc, readAccess,
                                    getBufferLOQ(type, getAdjoint()));
  builder.createEndAccess(loc, readAccess, /*aborted*/ false);
  builder.createDeallocStack(loc, buffer);
  return loaded;
}

AdjointValue
AdjointEmitter::accumulateAdjointsDirect(AdjointValue &&lhs,
                                         AdjointValue &&rhs) {
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
      auto sum = accumulateDirect(lhsVal, rhsVal);
      return makeConcreteAdjointValue(ValueWithCleanup(
          sum, makeCleanup(sum, emitCleanup, {lhsVal.getCleanup(),
                                              rhsVal.getCleanup()})));
    }
    // x + 0 => x
    case AdjointValueKind::Zero:
      return std::move(lhs);
    // x + (y, z) => (x.0 + y, x.1 + z)
    case AdjointValueKind::Aggregate:
      SmallVector<AdjointValue, 8> newElements;
      auto lhsTy = lhsVal.getValue()->getType().getASTType();
      if (auto *tupTy = lhsTy->getAs<TupleType>()) {
        for (auto idx : range(rhs.getNumAggregateElements())) {
          auto lhsElt = builder.createTupleExtract(
              lhsVal.getLoc(), lhsVal, idx);
          auto rhsElt = rhs.takeAggregateElement(idx);
          newElements.push_back(accumulateAdjointsDirect(
              makeConcreteAdjointValue(
                  ValueWithCleanup(lhsElt, lhsVal.getCleanup())),
              std::move(rhsElt)));
        }
      } else if (auto *structDecl = lhsTy->getStructOrBoundGenericStruct()) {
        auto fieldIt = structDecl->getStoredProperties().begin();
        for (unsigned i = 0; fieldIt != structDecl->getStoredProperties().end();
             ++fieldIt, ++i) {
          auto lhsElt = builder.createStructExtract(
              lhsVal.getLoc(), lhsVal, *fieldIt);
          auto rhsElt = rhs.takeAggregateElement(i);
          newElements.push_back(accumulateAdjointsDirect(
              makeConcreteAdjointValue(
                  ValueWithCleanup(lhsElt, lhsVal.getCleanup())),
              std::move(rhsElt)));
        }
      } else {
        llvm_unreachable("Not an aggregate type");
      }
      return makeAggregateAdjointValue(lhsVal.getType(), newElements);
    }
  }
  // 0
  case AdjointValueKind::Zero:
    // 0 + x => x
    return std::move(rhs);
  // (x, y)
  case AdjointValueKind::Aggregate:
    switch (rhs.getKind()) {
    // (x, y) + z => (x + z.0, y + z.1)
    case AdjointValueKind::Concrete:
    // x + 0 => x
    case AdjointValueKind::Zero:
      return std::move(lhs);
    // (x, y) + (z, w) => (x + z, y + w)
    case AdjointValueKind::Aggregate: {
      SmallVector<AdjointValue, 8> newElements;
      for (auto i : range(lhs.getNumAggregateElements()))
        newElements.push_back(
            accumulateAdjointsDirect(lhs.takeAggregateElement(i),
                                     rhs.takeAggregateElement(i)));
      return makeAggregateAdjointValue(lhs.getType(), newElements);
    }
    }
  }
}

SILValue AdjointEmitter::accumulateDirect(SILValue lhs, SILValue rhs) {
  // TODO: Optimize for the case when lhs == rhs.
  LLVM_DEBUG(getADDebugStream() <<
             "Emitting adjoint accumulation for lhs: " << lhs <<
             " and rhs: " << rhs << "\n");
  assert(lhs->getType() == rhs->getType() && "Adjoints must have equal types!");
  assert(lhs->getType().isObject() && rhs->getType().isObject() &&
         "Adjoint types must be both object types!");
  auto adjointTy = lhs->getType();
  auto adjointASTTy = adjointTy.getASTType();
  auto loc = lhs.getLoc();
  auto *swiftMod = getModule().getSwiftModule();
  auto tangentSpace = adjointASTTy->getAutoDiffAssociatedTangentSpace(
      LookUpConformanceInModule(swiftMod));
  assert(tangentSpace && "No tangent space for this type");
  switch (tangentSpace->getKind()) {
  case VectorSpace::Kind::Vector: {
    // Allocate buffers for inputs and output.
    auto *resultBuf = builder.createAllocStack(loc, adjointTy);
    auto *lhsBuf = builder.createAllocStack(loc, adjointTy);
    auto *rhsBuf = builder.createAllocStack(loc, adjointTy);
    // Initialize input buffers.
    auto *lhsBufInitAccess = builder.createBeginAccess(
        loc, lhsBuf, SILAccessKind::Init, SILAccessEnforcement::Static,
        /*noNestedConflict*/ true, /*fromBuiltin*/ false);
    auto *rhsBufInitAccess = builder.createBeginAccess(
        loc, rhsBuf, SILAccessKind::Init, SILAccessEnforcement::Static,
        /*noNestedConflict*/ true, /*fromBuiltin*/ false);
    builder.createStore(loc, lhs, lhsBufInitAccess,
                        getBufferSOQ(adjointASTTy, getAdjoint()));
    builder.createStore(loc, rhs, rhsBufInitAccess,
                        getBufferSOQ(adjointASTTy, getAdjoint()));
    builder.createEndAccess(loc, lhsBufInitAccess, /*aborted*/ false);
    builder.createEndAccess(loc, rhsBufInitAccess, /*aborted*/ false);
    // Accumulate the adjoints.
    auto *resultBufAccess = builder.createBeginAccess(
        loc, resultBuf, SILAccessKind::Init, SILAccessEnforcement::Static,
        /*noNestedConflict*/ true, /*fromBuiltin*/ false);
    auto *lhsBufReadAccess = builder.createBeginAccess(loc, lhsBuf,
        SILAccessKind::Read, SILAccessEnforcement::Static,
        /*noNestedConflict*/ true, /*fromBuiltin*/ false);
    auto *rhsBufReadAccess = builder.createBeginAccess(loc, rhsBuf,
        SILAccessKind::Read, SILAccessEnforcement::Static,
        /*noNestedConflict*/ true, /*fromBuiltin*/ false);
    accumulateIndirect(resultBufAccess, lhsBufReadAccess, rhsBufReadAccess);
    builder.createEndAccess(loc, resultBufAccess, /*aborted*/ false);
    builder.createEndAccess(loc, rhsBufReadAccess, /*aborted*/ false);
    builder.createEndAccess(loc, lhsBufReadAccess, /*aborted*/ false);
    // Deallocate input buffers.
    builder.createDeallocStack(loc, rhsBuf);
    builder.createDeallocStack(loc, lhsBuf);
    // Load result.
    resultBufAccess = builder.createBeginAccess(loc, resultBuf,
        SILAccessKind::Read, SILAccessEnforcement::Static,
        /*noNestedConflict*/ true, /*fromBuiltin*/ false);
    auto val = builder.createLoad(loc, resultBufAccess,
        getBufferLOQ(lhs->getType().getASTType(), getAdjoint()));
    builder.createEndAccess(loc, resultBufAccess, /*aborted*/ false);
    // Deallocate result buffer.
    builder.createDeallocStack(loc, resultBuf);
    return val;
  }
  case VectorSpace::Kind::Tuple: {
    auto tupleType = tangentSpace->getTuple();
    SmallVector<SILValue, 8> adjElements;
    for (unsigned i : range(tupleType->getNumElements())) {
      auto *eltLHS = builder.createTupleExtract(loc, lhs, i);
      auto *eltRHS = builder.createTupleExtract(loc, rhs, i);
      adjElements.push_back(accumulateDirect(eltLHS, eltRHS));
    }
    return builder.createTuple(loc, adjointTy, adjElements);
  }
  case VectorSpace::Kind::Function: {
    llvm_unreachable(
      "Unimplemented: Emit thunks for abstracting adjoint accumulation");
  }
  }
}

void AdjointEmitter::accumulateIndirect(
    SILValue resultBufAccess, SILValue lhsBufAccess, SILValue rhsBufAccess) {
  // TODO: Optimize for the case when lhs == rhs.
  assert(lhsBufAccess->getType() == rhsBufAccess->getType()
         && "Adjoints must have equal types!");
  assert(lhsBufAccess->getType().isAddress() &&
         rhsBufAccess->getType().isAddress()
         && "Adjoint types must be both address types!");
  auto loc = resultBufAccess.getLoc();
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
    auto confRef = adjointParentModule->lookupConformance(adjointASTTy, proto);
    assert(confRef.hasValue() && "Missing conformance to `AdditiveArithmetic`");
    SILDeclRef declRef(combinerFuncDecl, SILDeclRef::Kind::Func);
    auto silFnTy = getContext().getTypeConverter().getConstantType(declRef);
    // %0 = witness_method @+
    auto witnessMethod = builder.createWitnessMethod(loc, adjointASTTy,
                                                     *confRef, declRef,
                                                     silFnTy);
    auto subMap = SubstitutionMap::getProtocolSubstitutions(
        proto, adjointASTTy, *confRef);
    // %1 = metatype $T.Type
    auto metatypeType =
        CanMetatypeType::get(adjointASTTy, MetatypeRepresentation::Thick);
    auto metatypeSILType = SILType::getPrimitiveObjectType(metatypeType);
    auto metatype = builder.createMetatype(loc, metatypeSILType);
    // %2 = apply $0(%result, %new, %old, %1)
    builder.createApply(loc, witnessMethod, subMap,
                        {resultBufAccess, rhsBufAccess, lhsBufAccess, metatype},
                        /*isNonThrowing*/ false);
    return;
  }
  case VectorSpace::Kind::Tuple: {
    auto tupleType = tangentSpace->getTuple();
    for (unsigned i : range(tupleType->getNumElements())) {
      auto *destAddr = builder.createTupleElementAddr(loc, resultBufAccess, i);
      auto *eltAddrLHS = builder.createTupleElementAddr(loc, lhsBufAccess, i);
      auto *eltAddrRHS = builder.createTupleElementAddr(loc, rhsBufAccess, i);
      accumulateIndirect(destAddr, eltAddrLHS, eltAddrRHS);
    }
    return;
  }
  case VectorSpace::Kind::Function: {
    llvm_unreachable(
        "Unimplemented: Emit thunks for abstracting adjoint accumulation");
  }
  }
}

void AdjointEmitter::accumulateIndirect(SILValue lhsDestAccess,
                                        SILValue rhsAccess) {
  assert(lhsDestAccess->getType().isAddress() &&
         rhsAccess->getType().isAddress());
  assert(lhsDestAccess->getFunction() == &getAdjoint());
  assert(rhsAccess->getFunction() == &getAdjoint());
  auto loc = lhsDestAccess.getLoc();
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
    assert(confRef.hasValue() && "Missing conformance to `AdditiveArithmetic`");
    SILDeclRef declRef(accumulatorFuncDecl, SILDeclRef::Kind::Func);
    auto silFnTy = getContext().getTypeConverter().getConstantType(declRef);
    // %0 = witness_method @+=
    auto witnessMethod =
        builder.createWitnessMethod(loc, astType, *confRef, declRef, silFnTy);
    auto subMap =
        SubstitutionMap::getProtocolSubstitutions(proto, astType, *confRef);
    // %1 = metatype $T.Type
    auto metatypeType =
        CanMetatypeType::get(astType, MetatypeRepresentation::Thick);
    auto metatypeSILType = SILType::getPrimitiveObjectType(metatypeType);
    auto metatype = builder.createMetatype(loc, metatypeSILType);
    // %2 = apply $0(%lhs, %rhs, %1)
    builder.createApply(loc, witnessMethod, subMap,
                        {lhsDestAccess, rhsAccess, metatype},
                        /*isNonThrowing*/ false);
    return;
  }
  case VectorSpace::Kind::Tuple: {
    auto tupleType = tangentSpace->getTuple();
    for (unsigned i : range(tupleType->getNumElements())) {
      auto *destAddr = builder.createTupleElementAddr(loc, lhsDestAccess, i);
      auto *eltAddrRHS = builder.createTupleElementAddr(loc, rhsAccess, i);
      accumulateIndirect(destAddr, eltAddrRHS);
    }
    return;
  }
  case VectorSpace::Kind::Function: {
    llvm_unreachable(
        "Unimplemented: Emit thunks for abstracting adjoint accumulation");
  }
  }
}

bool VJPEmitter::run() {
  auto *original = getOriginal();
  auto *vjp = getVJP();
  LLVM_DEBUG(getADDebugStream()
             << "Cloning original @" << original->getName()
             << " to vjp @" << vjp->getName() << '\n');
  // Create entry BB and arguments.
  auto *entry = vjp->createBasicBlock();
  createEntryArguments(vjp);
  SmallVector<SILValue, 4> entryArgs(entry->getArguments().begin(),
                                     entry->getArguments().end());

  auto vjpGenericSig = vjp->getLoweredFunctionType()->getGenericSignature();
  auto *primalValueStructDecl =
      context.createPrimalValueStruct(original, getIndices(), vjpGenericSig);
  primalInfo =
      std::unique_ptr<PrimalInfo>(new PrimalInfo(primalValueStructDecl));

  // Clone.
  cloneFunctionBody(original, entry, entryArgs);
  // If errors occurred, back out.
  if (errorOccurred)
    return true;
  auto *origExit = &*original->findReturnBB();
  auto *exit = BBMap.lookup(origExit);
  assert(exit->getParent() == getVJP());
  // Get the original's return value's corresponding value in the vjp.
  auto *origRetInst = cast<ReturnInst>(origExit->getTerminator());
  auto origResult = getOpValue(origRetInst->getOperand());

  // Create a primal value struct containing all static primal values and
  // tapes.
  auto loc = getVJP()->getLocation();
  auto structTy = getOpASTType(getPrimalInfo()
                                   .getPrimalValueStruct()
                                   ->getDeclaredInterfaceType()
                                   ->getCanonicalType());
  auto &builder = getBuilder();
  builder.setInsertionPoint(exit);
  auto structLoweredTy = getContext().getTypeConverter().getLoweredType(
      structTy, ResilienceExpansion::Minimal);
  auto primValsVal = builder.createStruct(loc, structLoweredTy, primalValues);
  // If the original result was a tuple, return a tuple of all elements in the
  // original result tuple and the primal value struct value.
  SmallVector<SILValue, 8> origResults;
  extractAllElements(origResult, builder, origResults);
  LLVM_DEBUG({
    auto &s = getADDebugStream()
              << "Primal values in $"
              << getPrimalInfo().getPrimalValueStruct()->getName() << ":\n";
    for (auto *var : getPrimalInfo().getPrimalValueStruct()->getMembers())
      var->dump(s);
  });

  // Generate adjoint code.
  auto &passManager = context.getPassManager();
  auto *postDomAnalysis =
      passManager.getAnalysis<PostDominanceAnalysis>();
  SILFunction *adjoint = createEmptyAdjoint();
  context.getGeneratedFunctions().push_back(adjoint);
  AdjointEmitter adjointEmitter(context, original, attr, adjoint, getVJP(),
                                *primalInfo.get(), invoker, activityInfo,
                                *postDomAnalysis->get(original));
  // Run the adjoint emitter.
  if (adjointEmitter.run()) {
    errorOccurred = true;
    return true;
  }
  // Get and partially apply the adjoint.
  auto vjpGenericEnv = vjp->getGenericEnvironment();
  auto vjpSubstMap = vjpGenericEnv
      ? vjpGenericEnv->getForwardingSubstitutionMap()
      : vjp->getForwardingSubstitutionMap();
  auto *adjointRef = builder.createFunctionRef(loc, adjoint);
  auto *adjointPartialApply = builder.createPartialApply(
      loc, adjointRef, vjpSubstMap, {primValsVal},
      ParameterConvention::Direct_Guaranteed);

  // Return the direct results. Note that indirect results have already been
  // filled in by the application of the primal.
  SmallVector<SILValue, 8> directResults;
  directResults.append(origResults.begin(), origResults.end());
  directResults.push_back(adjointPartialApply);
  builder.createReturn(loc, joinElements(directResults, builder, loc));

  LLVM_DEBUG(getADDebugStream() << "Finished VJPGen for function "
                                << original->getName() << ":\n"
                                << *getVJP());
  debugDump(*getVJP());
  return errorOccurred;
}

//===----------------------------------------------------------------------===//
// `[differentiable]` attribute processing
//===----------------------------------------------------------------------===//

SILFunction *
ADContext::declareExternalAssociatedFunction(
    SILFunction *original, SILDifferentiableAttr *attr, StringRef name,
    AutoDiffAssociatedFunctionKind kind) {
  auto &module = getModule();
  auto &indices = attr->getIndices();
  auto originalTy = original->getLoweredFunctionType();
  auto originalLoc = original->getLocation();
  auto assocGenSig = getAssociatedFunctionGenericSignature(attr, original);
  auto assocFnTy = originalTy->getAutoDiffAssociatedFunctionType(
      indices.parameters, indices.source, /*differentiationOrder*/ 1, kind,
      module, LookUpConformanceInModule(module.getSwiftModule()), assocGenSig);
  SILOptFunctionBuilder fb(getTransform());
  // Create external function declaration.
  auto *assocFn = fb.createFunction(
      SILLinkage::PublicExternal, name, assocFnTy,
      /*genericEnv*/ nullptr, originalLoc, original->isBare(), IsNotTransparent,
      original->isSerialized(), original->isDynamicallyReplaceable());
  // NOTE: Setting debug scope is necessary to prevent crash in TFPartition.
  assocFn->setDebugScope(new (module) SILDebugScope(originalLoc, assocFn));
  return assocFn;
}

static SILFunction* createJVP(
    ADContext &context, SILFunction *original, SILDifferentiableAttr *attr,
    bool isExported) {
  auto &module = context.getModule();
  auto &indices = attr->getIndices();
  auto originalTy = original->getLoweredFunctionType();

  // === Create an empty JVP. ===
  auto jvpName = original->getASTContext()
                     .getIdentifier("AD__" + original->getName().str() +
                                    "__jvp_" + indices.mangle())
                     .str();
  auto jvpGenericSig = getAssociatedFunctionGenericSignature(attr, original);
  auto *jvpGenericEnv = jvpGenericSig
      ? jvpGenericSig->createGenericEnvironment()
      : nullptr;

  // RAII that pushes the original function's generic signature to
  // `module.Types` so that the calls `module.Types.getTypeLowering()` below
  // will know the JVP's generic parameter types.
  Lowering::GenericContextScope genericContextScope(
      module.Types, jvpGenericSig);

  auto jvpType = originalTy->getAutoDiffAssociatedFunctionType(
      indices.parameters, indices.source, /*differentiationOrder*/ 1,
      AutoDiffAssociatedFunctionKind::JVP, module,
      LookUpConformanceInModule(module.getSwiftModule()),
      jvpGenericSig);

  SILOptFunctionBuilder fb(context.getTransform());
  auto linkage = autodiff::getAutoDiffAssociatedFunctionLinkage(
      original->getLinkage(), isExported);
  auto *jvp = fb.createFunction(linkage, jvpName, jvpType, jvpGenericEnv,
                                original->getLocation(), original->isBare(),
                                IsNotTransparent, original->isSerialized(),
                                // IsNotTransparent, IsNotSerialized,
                                original->isDynamicallyReplaceable());
  jvp->setOwnershipEliminated();
  jvp->setDebugScope(new (module) SILDebugScope(original->getLocation(), jvp));
  attr->setJVPName(jvpName);

  // Create JVP entry BB and arguments.
  auto jvpConv = jvp->getConventions();
  auto *entry = jvp->createBasicBlock();
  createEntryArguments(jvp);
  // Return undef.
  SILBuilder builder(entry);
  auto loc = jvp->getLocation();
  builder.createReturn(
      loc, SILUndef::get(jvp->mapTypeIntoContext(jvpConv.getSILResultType()),
                         *jvp));
  return jvp;
}

static SILFunction *createEmptyVJP(
    ADContext &context, SILFunction *original, SILDifferentiableAttr *attr,
    bool isExported) {
  LLVM_DEBUG({
    auto &s = getADDebugStream();
    s << "Creating VJP:\n\t";
    s << "Original type: " << original->getLoweredFunctionType() << "\n\t";
  });

  auto &module = context.getModule();
  auto originalTy = original->getLoweredFunctionType();
  auto indices = attr->getIndices();

  // === Create an empty VJP. ===
  auto vjpName = original->getASTContext()
                     .getIdentifier("AD__" + original->getName().str() +
                                    "__vjp_" + indices.mangle())
                     .str();
  auto vjpGenericSig = getAssociatedFunctionGenericSignature(attr, original);

  // RAII that pushes the original function's generic signature to
  // `module.Types` so that the calls `module.Types.getTypeLowering()` below
  // will know the VJP's generic parameter types.
  Lowering::GenericContextScope genericContextScope(
      module.Types, vjpGenericSig);

  auto *vjpGenericEnv = vjpGenericSig
      ? vjpGenericSig->createGenericEnvironment()
      : nullptr;
  auto vjpType = originalTy->getAutoDiffAssociatedFunctionType(
      indices.parameters, indices.source, /*differentiationOrder*/ 1,
      AutoDiffAssociatedFunctionKind::VJP, module,
      LookUpConformanceInModule(module.getSwiftModule()), vjpGenericSig);

  SILOptFunctionBuilder fb(context.getTransform());
  auto linkage = autodiff::getAutoDiffAssociatedFunctionLinkage(
      original->getLinkage(), isExported);
  auto *vjp = fb.createFunction(linkage, vjpName, vjpType, vjpGenericEnv,
                                original->getLocation(), original->isBare(),
                                IsNotTransparent, original->isSerialized(),
                                original->isDynamicallyReplaceable());
  vjp->setOwnershipEliminated();
  vjp->setDebugScope(new (module) SILDebugScope(original->getLocation(), vjp));
  attr->setVJPName(vjpName);

  LLVM_DEBUG(llvm::dbgs() << "VJP type: " << vjp->getLoweredFunctionType()
                          << "\n");
  return vjp;
}

/// Returns true on error.
bool ADContext::processDifferentiableAttribute(
    SILFunction *original, SILDifferentiableAttr *attr,
    DifferentiationInvoker invoker) {
  auto &module = getModule();
  // Try to look up JVP only if attribute specifies JVP name or if original
  // function is an external declaration. If JVP function cannot be found,
  // create an external JVP reference.
  StringRef jvpName;
  SILFunction *jvp = nullptr;
  SILFunction *vjp = nullptr;
  if (attr->hasJVP()) {
    jvpName = attr->getJVPName();
  } else if (original->isExternalDeclaration()) {
    jvpName = original->getASTContext()
                  .getIdentifier("AD__" + original->getName().str() +
                                 "__jvp_" + attr->getIndices().mangle())
                  .str();
  }
  if (!jvpName.empty()) {
    jvp = module.lookUpFunction(jvpName);
    if (!jvp)
      jvp = declareExternalAssociatedFunction(
          original, attr, jvpName, AutoDiffAssociatedFunctionKind::JVP);
    attr->setJVPName(jvpName);
  }

  // Try to look up VJP only if attribute specifies VJP name or if original
  // function is an external declaration. If VJP function cannot be found,
  // create an external VJP reference.
  StringRef vjpName;
  if (attr->hasVJP()) {
    vjpName = attr->getVJPName();
  } else if (original->isExternalDeclaration()) {
    vjpName = original->getASTContext()
                  .getIdentifier("AD__" + original->getName().str() +
				                         "__vjp_" + attr->getIndices().mangle())
                  .str();
  }
  if (!vjpName.empty()) {
    vjp = module.lookUpFunction(vjpName);
    if (!vjp)
      vjp = declareExternalAssociatedFunction(
          original, attr, vjpName, AutoDiffAssociatedFunctionKind::VJP);
    attr->setVJPName(vjpName);
  }

  // If differentiation is triggered by `[differentiable]`, associated function
  // should share linkage of original function.
  auto isAssocFnExported =
      invoker.getKind() ==
          DifferentiationInvoker::Kind::SILDifferentiableAttribute;

  // Create empty JVP, if it does not exist.
  if (!jvp)
    createJVP(*this, original, attr, isAssocFnExported);

  // If the VJP exists, then no synthesis is needed.
  if (vjp)
    return false;

  // TODO(TF-384): If the original function has multiple basic blocks, bail out
  // since AD does not support control flow yet.
  if (diagnoseNoReturn(*this, original, invoker) ||
      diagnoseUnsupportedControlFlow(*this, original, invoker)) {
    return true;
  }

  vjp = createEmptyVJP(*this, original, attr, isAssocFnExported);
  getGeneratedFunctions().push_back(vjp);
  VJPEmitter emitter(*this, original, attr, vjp, invoker);
  return emitter.run();
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

SILFunction *
ADContext::getOrCreateSubsetParametersThunkForLinearMap(
    SILFunction *parentThunk, CanSILFunctionType linearMapType,
    CanSILFunctionType targetType, AutoDiffAssociatedFunctionKind kind,
    SILAutoDiffIndices desiredIndices, SILAutoDiffIndices actualIndices) {
  SubstitutionMap interfaceSubs = parentThunk->getForwardingSubstitutionMap();
  GenericEnvironment *genericEnv = parentThunk->getGenericEnvironment();
  auto thunkType = buildThunkType(
      parentThunk, linearMapType, targetType, genericEnv, interfaceSubs,
      /*withoutActuallyEscaping*/ true,
      DifferentiationThunkKind::Reabstraction);

  // TODO: Use more principled mangling.
  std::string thunkName;
  switch (kind) {
    case AutoDiffAssociatedFunctionKind::JVP:
      thunkName = "differential";
      break;
    case AutoDiffAssociatedFunctionKind::VJP:
      thunkName = "pullback";
  }
  Mangle::ASTMangler mangler;
  auto fromInterfaceType =
      linearMapType->mapTypeOutOfContext()->getCanonicalType();
  auto toInterfaceType = targetType->mapTypeOutOfContext()->getCanonicalType();
  CanType dynamicSelfType;
  thunkName = "AD__" + mangler.mangleReabstractionThunkHelper(
      thunkType, fromInterfaceType, toInterfaceType, dynamicSelfType,
      module.getSwiftModule()) + "_" + desiredIndices.mangle() + "_" +
      thunkName;
  thunkName += "_thunk";

  auto loc = parentThunk->getLocation();
  SILOptFunctionBuilder fb(getTransform());
  auto *thunk = fb.getOrCreateSharedFunction(
      loc, thunkName, thunkType, IsBare, IsTransparent, IsSerialized,
      ProfileCounter(), IsThunk, IsNotDynamic);

  if (!thunk->empty())
    return thunk;

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
    auto *swiftMod = getModule().getSwiftModule();
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
        auto loq = getBufferLOQ(buf->getType().getASTType(), *thunk);
        auto *arg = builder.createLoad(loc, buf, loq);
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

  switch (kind) {
  // Differential arguments are:
  // - All indirect results, followed by:
  // - An interleaving of:
  //   - Thunk arguments (when parameter index is in both desired and actual
  //     indices).
  //   - Zeros (when parameter is not in desired indices).
  case AutoDiffAssociatedFunctionKind::JVP: {
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
            linearMapType->getParameters()[i].getSILStorageType();
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
  case AutoDiffAssociatedFunctionKind::VJP: {
    auto toIndirectResultsIter = thunk->getIndirectResults().begin();
    auto useNextResult = [&]() {
      arguments.push_back(*toIndirectResultsIter++);
    };
    // Iterate over actual indices.
    for (unsigned i : actualIndices.parameters->getIndices()) {
      auto resultInfo = linearMapType->getResults()[i];
      // Skip direct results. Only indirect results are relevant as arguments.
      if (resultInfo.isFormalDirect())
        continue;
      // If index is desired, use next indirect result.
      if (desiredIndices.isWrtParameter(i)) {
        useNextResult();
        continue;
      }
      // Otherwise, construct and use a zero indirect result.
      buildZeroArgument(resultInfo.getSILStorageType());
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
  if (kind == AutoDiffAssociatedFunctionKind::JVP) {
    for (auto *alloc : reversed(localAllocations))
      builder.createDeallocStack(loc, alloc);
    builder.createReturn(loc, ai);
    return thunk;
  }

  // If pullback thunk, return only the desired results and clean up the
  // undesired results.
  SmallVector<SILValue, 8> pullbackDirectResults;
  extractAllElements(ai, builder, pullbackDirectResults);
  SmallVector<SILValue, 8> allResults;
  collectAllActualResultsInTypeOrder(
      ai, pullbackDirectResults,
      ai->getIndirectSILResults(), allResults);

  SmallVector<SILValue, 8> results;
  for (unsigned i : actualIndices.parameters->getIndices()) {
    // If result is desired:
    // - Do nothing if result is indirect.
    //   (It was already forwarded to the `apply` instruction).
    // - Push it to `results` if result is direct.
    if (desiredIndices.isWrtParameter(i)) {
      if (allResults[i]->getType().isAddress())
        continue;
      results.push_back(allResults[i]);
    }
    // Otherwise, cleanup the unused results.
    else {
      emitCleanup(builder, loc, allResults[i]);
    }
  }
  // Deallocate local allocations and return final direct result.
  for (auto *alloc : reversed(localAllocations))
    builder.createDeallocStack(loc, alloc);
  auto result = joinElements(results, builder, loc);
  builder.createReturn(loc, result);

  getGeneratedFunctions().push_back(thunk);
  return thunk;
}

std::pair<SILFunction *, SubstitutionMap>
ADContext::getOrCreateSubsetParametersThunkForAssociatedFunction(
    SILValue origFnOperand, SILValue assocFn,
    AutoDiffAssociatedFunctionKind kind, SILAutoDiffIndices desiredIndices,
    SILAutoDiffIndices actualIndices) {
  auto origFnType = origFnOperand->getType().castTo<SILFunctionType>();
  auto &module = getModule();
  auto lookupConformance = LookUpConformanceInModule(module.getSwiftModule());

  // Compute target type for thunking.
  auto assocFnType = assocFn->getType().castTo<SILFunctionType>();
  auto targetType = origFnType->getAutoDiffAssociatedFunctionType(
      desiredIndices.parameters, desiredIndices.source,
      /*differentiationOrder*/ 1, kind, module, lookupConformance);
  auto *caller = assocFn->getFunction();
  if (targetType->hasArchetype()) {
    auto substTargetType = caller->mapTypeIntoContext(
        targetType->mapTypeOutOfContext())->getCanonicalType();
    targetType = SILType::getPrimitiveObjectType(substTargetType)
        .castTo<SILFunctionType>();
  }
  assert(assocFnType->getNumParameters() == targetType->getNumParameters());
  assert(assocFnType->getNumResults() == targetType->getNumResults());

  // Build thunk type.
  SubstitutionMap interfaceSubs;
  GenericEnvironment *genericEnv = nullptr;
  auto thunkType = buildThunkType(
      assocFn->getFunction(), assocFnType, targetType, genericEnv,
      interfaceSubs, /*withoutActuallyEscaping*/ false,
      DifferentiationThunkKind::IndexSubset);

  // FIXME: The logic for resolving `assocRef` does not reapply function
  // conversions, which is problematic if `assocFn` is a `partial_apply`
  // instruction.
  StringRef origName;
  if (auto *origFnRef =
          peerThroughFunctionConversions<FunctionRefInst>(origFnOperand)) {
    origName = origFnRef->getReferencedFunction()->getName();
  } else if (auto *origMethodInst =
                 peerThroughFunctionConversions<MethodInst>(origFnOperand)) {
    origName = origMethodInst->getMember().getAnyFunctionRef()
        ->getAbstractFunctionDecl()->getNameStr();
  }
  assert(!origName.empty() && "Original function name could not be resolved");
  // TODO: Use more principled mangling.
  std::string thunkName;
  switch (kind) {
    case AutoDiffAssociatedFunctionKind::JVP:
      thunkName = "jvp";
      break;
    case AutoDiffAssociatedFunctionKind::VJP:
      thunkName = "vjp";
  }
  Mangle::ASTMangler mangler;
  auto fromInterfaceType =
      assocFnType->mapTypeOutOfContext()->getCanonicalType();
  auto toInterfaceType = targetType->mapTypeOutOfContext()->getCanonicalType();
  CanType dynamicSelfType;
  thunkName = "AD__orig_" + origName.str() + "_" +
      mangler.mangleReabstractionThunkHelper(
          thunkType, fromInterfaceType, toInterfaceType, dynamicSelfType,
          module.getSwiftModule()) + "_" + desiredIndices.mangle() + "_" +
          thunkName;
  thunkName += "_thunk";

  auto loc = origFnOperand.getLoc();
  SILOptFunctionBuilder fb(getTransform());
  auto *thunk = fb.getOrCreateFunction(
      loc, thunkName, SILLinkage::Hidden, thunkType, IsBare, IsTransparent,
      caller->isSerialized(), IsNotDynamic, ProfileCounter(), IsThunk);

  if (!thunk->empty())
    return {thunk, interfaceSubs};

  thunk->setOwnershipEliminated();
  thunk->setGenericEnvironment(genericEnv);
  auto *entry = thunk->createBasicBlock();
  SILBuilder builder(entry);
  createEntryArguments(thunk);

  SubstitutionMap assocSubstMap;
  if (auto *partialApply = dyn_cast<PartialApplyInst>(assocFn))
    assocSubstMap = partialApply->getSubstitutionMap();

  // FIXME: The logic for resolving `assocRef` does not reapply function
  // conversions, which is problematic if `assocFn` is a `partial_apply`
  // instruction.
  SILValue assocRef;
  if (auto *assocFnRef =
          peerThroughFunctionConversions<FunctionRefInst>(assocFn)) {
    auto *assoc = assocFnRef->getReferencedFunction();
    assocRef = builder.createFunctionRef(loc, assoc);
  } else if (auto *assocMethodInst =
                 peerThroughFunctionConversions<WitnessMethodInst>(assocFn)) {
    assocRef = builder.createWitnessMethod(
        loc, assocMethodInst->getLookupType(),
        assocMethodInst->getConformance(), assocMethodInst->getMember(),
        thunk->mapTypeIntoContext(assocMethodInst->getType()));
  }
  assert(assocRef && "Expected associated function to be resolved");

  assocSubstMap = assocSubstMap.subst(thunk->getForwardingSubstitutionMap());
  assocFnType = assocRef->getType().castTo<SILFunctionType>();

  SmallVector<SILValue, 4> arguments;
  arguments.append(thunk->getArguments().begin(), thunk->getArguments().end());
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
  auto linearMapTargetType = targetType->getResults().back().getSILStorageType()
      .castTo<SILFunctionType>();

  auto *innerThunk = getOrCreateSubsetParametersThunkForLinearMap(
      thunk, linearMapType, linearMapTargetType, kind,
      desiredIndices, actualIndices);

  auto *innerThunkFRI = builder.createFunctionRef(loc, innerThunk);
  auto *newDerivative = builder.createPartialApply(
      loc, innerThunkFRI, thunk->getForwardingSubstitutionMap(), {linearMap},
      ParameterConvention::Direct_Guaranteed);

  assert(origFnType->getResults().size() == 1);
  if (origFnType->getResults().front().isFormalDirect()) {
    auto result = joinElements(
        {originalDirectResult, newDerivative}, builder, loc);
    builder.createReturn(loc, result);
  } else {
    builder.createReturn(loc, newDerivative);
  }

  getGeneratedFunctions().push_back(thunk);
  return {thunk, interfaceSubs};
}

SILValue ADContext::promoteToDifferentiableFunction(
    AutoDiffFunctionInst *inst, SILBuilder &builder, SILLocation loc,
    DifferentiationInvoker invoker) {
  auto origFnOperand = inst->getOriginalFunction();
  auto origFnTy = origFnOperand->getType().castTo<SILFunctionType>();
  auto parameterIndices = inst->getParameterIndices();
  unsigned resultIndex = resultIndices[inst];
  unsigned differentiationOrder = inst->getDifferentiationOrder();

  // Handle curry thunk applications specially.
  if (auto *ai = dyn_cast<ApplyInst>(origFnOperand)) {
    if (auto *thunkRef = dyn_cast<FunctionRefInst>(ai->getCallee())) {
      SILAutoDiffIndices desiredIndices(resultIndex, parameterIndices);
      auto *thunk = thunkRef->getReferencedFunction();
      auto newThunkName = "AD__" + thunk->getName().str() +
          "__cloned_curry_thunk_" + desiredIndices.mangle();

      auto thunkTy = thunk->getLoweredFunctionType();
      auto thunkResult = thunkTy->getSingleResult();
      if (auto resultFnTy = thunkResult.getType()->getAs<SILFunctionType>()) {
        // Construct new curry thunk type with `@differentiable` result.
        auto diffableResultFnTy = resultFnTy->getWithExtInfo(
            resultFnTy->getExtInfo().withDifferentiable(true));
        auto newThunkResult = thunkResult.getWithType(diffableResultFnTy);
        auto thunkType = SILFunctionType::get(
            thunkTy->getGenericSignature(), thunkTy->getExtInfo(),
            thunkTy->getCoroutineKind(), thunkTy->getCalleeConvention(),
            thunkTy->getParameters(), {}, {newThunkResult}, {},
            thunkTy->getASTContext());

        // Construct new curry think.
        SILOptFunctionBuilder fb(transform);
        auto *newThunk = fb.getOrCreateFunction(
            loc, newThunkName,
            getSpecializedLinkage(thunk, thunk->getLinkage()), thunkType,
            thunk->isBare(), thunk->isTransparent(), thunk->isSerialized(),
            thunk->isDynamicallyReplaceable(), ProfileCounter(),
            thunk->isThunk());
        if (newThunk->empty()) {
          newThunk->setOwnershipEliminated();
          SILFunctionCloner cloner(newThunk);
          cloner.cloneFunction(thunk);
        }

        auto *retInst =
            cast<ReturnInst>(newThunk->findReturnBB()->getTerminator());
        AutoDiffFunctionInst *adfi;
        {
          SILBuilder builder(retInst);
          adfi = builder.createAutoDiffFunction(loc, parameterIndices,
                                                differentiationOrder,
                                                retInst->getOperand());
          resultIndices[adfi] = resultIndex;
          builder.createReturn(loc, adfi);
        }
        retInst->eraseFromParent();

        getAutoDiffFunctionInsts().push_back(adfi);
        if (processAutoDiffFunctionInst(adfi))
          return nullptr;

        auto *newThunkRef = builder.createFunctionRef(loc, newThunk);
        SmallVector<SILValue, 8> arguments(ai->getArguments().begin(),
                                           ai->getArguments().end());
        auto *newApply = builder.createApply(
            ai->getLoc(), newThunkRef, ai->getSubstitutionMap(), arguments,
            ai->isNonThrowing());
        return newApply;
      }
    }
  }

  SILAutoDiffIndices desiredIndices(resultIndex, parameterIndices);
  SmallVector<SILValue, 2> assocFns;
  for (auto assocFnKind : {AutoDiffAssociatedFunctionKind::JVP,
                           AutoDiffAssociatedFunctionKind::VJP}) {
    auto assocFnAndIndices = emitAssociatedFunctionReference(
        *this, builder, desiredIndices, assocFnKind,
        origFnOperand, invoker);
    // Show an error at the operator, highlight the argument, and show a note
    // at the definition site of the argument.
    if (!assocFnAndIndices)
      return nullptr;

    auto assocFn = assocFnAndIndices->first;
    getGeneratedAssociatedFunctionReferences().push_back(assocFn);

    // If desired indices are a subset of actual indices, create a "subset
    // indices thunk".
    // - For JVPs: the thunked JVP returns a differential taking fewer
    //   parameters (using `.zero` for the dropped parameters).
    // - For VJPs: the thunked VJP returns a pullback that drops the unused
    //   tangent values.
    auto actualIndices = assocFnAndIndices->second;
    // NOTE: `desiredIndices` may come from a partially-applied function and
    // have smaller capacity than `actualIndices`. We expect this logic to go
    // away when we support `@differentiable` partial apply.
    // if (actualIndices != desiredIndices) { // TODO: Re-enable.
    if (actualIndices.source != desiredIndices.source ||
        !actualIndices.parameters->equals(
            desiredIndices.parameters->extendingCapacity(getASTContext(),
                actualIndices.parameters->getCapacity()))) {
      assert(actualIndices.parameters->isSupersetOf(desiredIndices.parameters));
      SILFunction *thunk;
      SubstitutionMap interfaceSubs;
      std::tie(thunk, interfaceSubs) =
          getOrCreateSubsetParametersThunkForAssociatedFunction(
              origFnOperand, assocFn, assocFnKind, desiredIndices,
              actualIndices);
      auto *thunkFRI = builder.createFunctionRef(loc, thunk);
      if (auto genSig =
              thunk->getLoweredFunctionType()->getGenericSignature()) {
        assocFn = builder.createPartialApply(
            loc, thunkFRI, interfaceSubs, {},
            ParameterConvention::Direct_Guaranteed);
      } else {
        assocFn = thunkFRI;
      }
    }
    auto expectedAssocFnTy = origFnTy->getAutoDiffAssociatedFunctionType(
        parameterIndices, resultIndex, differentiationOrder,
        assocFnKind, getModule(),
        LookUpConformanceInModule(getModule().getSwiftModule()));
    // If `assocFn` is `@convention(thin)` but is expected to be
    // `@convention(thick)`, emit a `thin_to_thick` instruction.
    if (expectedAssocFnTy->getRepresentation()
            == SILFunctionTypeRepresentation::Thick &&
        assocFn->getType().castTo<SILFunctionType>()->getRepresentation()
            == SILFunctionTypeRepresentation::Thin) {
      assocFn = builder.createThinToThickFunction(
          loc, assocFn, SILType::getPrimitiveObjectType(expectedAssocFnTy));
    }

    builder.createRetainValue(loc, assocFn, builder.getDefaultAtomicity());
    assocFns.push_back(assocFn);
  }

  auto *adfi = builder.createAutoDiffFunction(
      loc, parameterIndices, differentiationOrder, origFnOperand, assocFns);
  resultIndices[adfi] = resultIndex;
  getAutoDiffFunctionInsts().push_back(adfi);
  return adfi;
}

/// Fold `autodiff_function_extract` users of the given `autodiff_function`
/// instruction, directly replacing them with `autodiff_function` instruction
/// operands. If the `autodiff_function` instruction has no
/// non-`autodiff_function_extract` users, delete the instruction itself after
/// folding.
///
/// Folding can be disabled by the `SkipFoldingAutoDiffFunctionExtraction` flag
/// for SIL testing purposes.
static void foldAutoDiffFunctionExtraction(AutoDiffFunctionInst *source) {
  // Iterate through all `autodiff_function_extract` users of the
  // `autodiff_function` instruction.
  for (auto use : source->getUses()) {
    auto *adfei = dyn_cast<AutoDiffFunctionExtractInst>(use->getUser());
    if (!adfei)
      continue;
    // Fold original function extractors.
    if (adfei->getExtractee() == AutoDiffFunctionExtractee::Original) {
      auto originalFnValue = source->getOriginalFunction();
      adfei->replaceAllUsesWith(originalFnValue);
      adfei->eraseFromParent();
      continue;
    }
    // Fold associated function extractors.
    auto assocFnValue = source->getAssociatedFunction(
        adfei->getDifferentiationOrder(), adfei->getAssociatedFunctionKind());
    adfei->replaceAllUsesWith(assocFnValue);
    adfei->eraseFromParent();
  }
  // If the `autodiff_function` instruction has no remaining uses, erase it.
  if (isInstructionTriviallyDead(source))
    source->eraseFromParent();
}

bool ADContext::processAutoDiffFunctionInst(AutoDiffFunctionInst *adfi) {
  if (adfi->getNumAssociatedFunctions() ==
      autodiff::getNumAutoDiffAssociatedFunctions(
          adfi->getDifferentiationOrder()))
    return false;
  assert(adfi->getNumAssociatedFunctions() == 0 &&
         "some functions are already filled in but not all of them");

  SILFunction *parent = adfi->getFunction();
  auto loc = parent->getLocation();
  SILBuilder builder(adfi);

  auto getInvoker = [&](AutoDiffFunctionInst *inst) -> DifferentiationInvoker {
    if (auto *expr = findDifferentialOperator(inst))
      return expr;
    return inst;
  };
  auto invoker = getInvoker(adfi);
  auto differentiableFnValue =
      promoteToDifferentiableFunction(adfi, builder, loc, invoker);
  if (!differentiableFnValue)
    return true;
  // Delete all worklist occurrences of `adfi` by setting them to nullptr.
  // This is more efficient than APIs like `llvm::erase_if`.
  for (auto &inst : getAutoDiffFunctionInsts())
    if (inst == adfi)
      inst = nullptr;
  // Replace all uses of `adfi`.
  adfi->replaceAllUsesWith(differentiableFnValue);
  adfi->eraseFromParent();
  // If the promoted `@differentiable` function-typed value is an
  // `autodiff_function` instruction, fold `autodiff_function_extract`
  // instructions.
  // If `autodiff_function_extract` folding is disabled, return.
  if (!SkipFoldingAutoDiffFunctionExtraction)
    if (auto *newADFI = dyn_cast<AutoDiffFunctionInst>(differentiableFnValue))
      foldAutoDiffFunctionExtraction(newADFI);
  transform.invalidateAnalysis(
      parent, SILAnalysis::InvalidationKind::FunctionBody);
  return false;
}

/// AD pass entry.
void Differentiation::run() {
  auto &module = *getModule();
  auto &astCtx = module.getASTContext();
  debugDump(module);

  // A global differentiation context.
  ADContext context(*this);

  // Handle all the instructions and attributes in the module that trigger
  // differentiation.
  for (SILFunction &f : module) {
    // If `f` has a `[differentiable]` attribute, register `f` and the attribute
    // with an invoker.
    for (auto *diffAttr : f.getDifferentiableAttrs()) {
      DifferentiationInvoker invoker(diffAttr);
      auto insertion =
          context.getInvokers().try_emplace(diffAttr, invoker);
      assert(insertion.second &&
             "[differentiable] attribute already has an invoker");
      continue;
    }
    for (SILBasicBlock &bb : f)
      for (SILInstruction &i : bb)
        if (auto *adfi = dyn_cast<AutoDiffFunctionInst>(&i))
          context.getAutoDiffFunctionInsts().push_back(adfi);
  }

  // If nothing has triggered differentiation, there's nothing to do.
  if (context.getInvokers().empty() &&
      context.getAutoDiffFunctionInsts().empty())
    return;

  // AD relies on stdlib (the Swift module). If it's not imported, it's an
  // internal error.
  if (!astCtx.getStdlibModule()) {
    astCtx.Diags.diagnose(SourceLoc(),
                          diag::autodiff_internal_swift_not_imported);
    return;
  }

  bool errorOccurred = false;

  // Process all `[differentiable]` attributes.
  for (auto invokerInfo : context.getInvokers()) {
    auto *attr = invokerInfo.first;
    auto *original = attr->getOriginal();
    auto invoker = invokerInfo.second;
    errorOccurred |=
        context.processDifferentiableAttribute(original, attr, invoker);
  }

  // Iteratively process `autodiff_function` instruction worklist.
  while (!context.getAutoDiffFunctionInsts().empty()) {
    auto *adfi = context.getAutoDiffFunctionInsts().back();
    context.getAutoDiffFunctionInsts().pop_back();
    // Skip instructions that have been set to nullptr by
    // `processAutoDiffFunctionInst`.
    if (!adfi) continue;
    errorOccurred |= context.processAutoDiffFunctionInst(adfi);
  }

  // If any error occurred while processing `[differentiable]` attributes or
  // `autodiff_function` instructions, clean up.
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
