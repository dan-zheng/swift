//===--- ADContext.h - Differentiation Context ----------------*- C++ -*---===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2019 - 2020 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//
//
// Per-module contextual information for the differentiation transform.
//
//===----------------------------------------------------------------------===//

#ifndef SWIFT_SILOPTIMIZER_UTILS_DIFFERENTIATION_ADCONTEXT_H
#define SWIFT_SILOPTIMIZER_UTILS_DIFFERENTIATION_ADCONTEXT_H

#include "swift/SILOptimizer/Differentiation/Common.h"
#include "swift/SILOptimizer/Differentiation/DifferentiationInvoker.h"

#include "swift/AST/DiagnosticsSIL.h"
#include "swift/AST/Expr.h"
#include "swift/AST/SynthesizedFileUnit.h"
#include "swift/SIL/SILBuilder.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/MapVector.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"

namespace swift {

class ASTContext;
class DifferentiableFunctionExpr;
class DifferentiableFunctionInst;
class FuncDecl;
class SILDifferentiabilityWitness;
class SILFunction;
class SILModuleTransform;
class SILModule;
class SILPassManager;

namespace autodiff {

/// Stores `apply` instruction information calculated by VJP generation.
struct NestedApplyInfo {
  /// The differentiation indices that are used to differentiate this `apply`
  /// instruction.
  SILAutoDiffIndices indices;
  /// The original pullback type before reabstraction. `None` if the pullback
  /// type is not reabstracted.
  Optional<CanSILFunctionType> originalPullbackType;
};

/// Per-module contextual information for the Differentiation pass.
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

  /// The worklist (stack) of `differentiable_function` instructions to be
  /// processed.
  llvm::SmallVector<DifferentiableFunctionInst *, 32>
      differentiableFunctionInsts;

  /// The set of `differentiable_function` instructions that have been
  /// processed. Used to avoid reprocessing invalidated instructions.
  /// NOTE(TF-784): if we use `CanonicalizeInstruction` subclass to replace
  /// `ADContext::processDifferentiableFunctionInst`, this field may be removed.
  llvm::SmallPtrSet<DifferentiableFunctionInst *, 32>
      processedDifferentiableFunctionInsts;

  /// Mapping from witnesses to invokers.
  /// `SmallMapVector` is used for deterministic insertion order iteration.
  llvm::SmallMapVector<SILDifferentiabilityWitness *, DifferentiationInvoker,
                       32>
      invokers;

  /// Mapping from original `apply` instructions to their corresponding
  /// `NestedApplyInfo`s.
  llvm::DenseMap<ApplyInst *, NestedApplyInfo> nestedApplyInfo;

  /// List of generated functions (JVPs, VJPs, pullbacks, and thunks).
  /// Saved for deletion during cleanup.
  llvm::SmallVector<SILFunction *, 32> generatedFunctions;

  /// List of references to generated functions.
  /// Saved for deletion during cleanup.
  llvm::SmallVector<SILValue, 32> generatedFunctionReferences;

  /// The AdditiveArithmetic protocol in the standard library.
  ProtocolDecl *additiveArithmeticProtocol =
      astCtx.getProtocol(KnownProtocolKind::AdditiveArithmetic);

  /// `AdditiveArithmetic.+` declaration.
  mutable FuncDecl *cachedPlusFn = nullptr;
  /// `AdditiveArithmetic.+=` declaration.
  mutable FuncDecl *cachedPlusEqualFn = nullptr;

public:
  /// Construct an ADContext for the given module.
  explicit ADContext(SILModuleTransform &transform);

  //--------------------------------------------------------------------------//
  // General utilities
  //--------------------------------------------------------------------------//

  SILModuleTransform &getTransform() const { return transform; }
  SILModule &getModule() const { return module; }
  ASTContext &getASTContext() const { return module.getASTContext(); }
  SILPassManager &getPassManager() const { return passManager; }
  Lowering::TypeConverter &getTypeConverter() { return module.Types; }

  /// Get or create the synthesized file for the given `SILFunction`.
  /// Used by `LinearMapInfo` for adding generated linear map struct and
  /// branching trace enum declarations.
  SynthesizedFileUnit &getOrCreateSynthesizedFile(SILFunction *original);

  /// Returns true if the `differentiable_function` instruction worklist is
  /// empty.
  bool isDifferentiableFunctionInstsWorklistEmpty() const {
    return differentiableFunctionInsts.empty();
  }

  /// Pops and returns a `differentiable_function` instruction from the
  /// worklist. Returns nullptr if the worklist is empty.
  DifferentiableFunctionInst *popDifferentiableFunctionInstFromWorklist() {
    if (differentiableFunctionInsts.empty())
      return nullptr;
    return differentiableFunctionInsts.pop_back_val();
  }

  /// Adds the given `differentiable_function` instruction to the worklist.
  void
  addDifferentiableFunctionInstToWorklist(DifferentiableFunctionInst *dfi) {
    differentiableFunctionInsts.push_back(dfi);
  }

  /// Returns true if the given `differentiable_function` instruction has
  /// already been processed.
  bool
  isDifferentiableFunctionInstProcessed(DifferentiableFunctionInst *dfi) const {
    return processedDifferentiableFunctionInsts.count(dfi);
  }

  /// Adds the given `differentiable_function` instruction to the worklist.
  void
  markDifferentiableFunctionInstAsProcessed(DifferentiableFunctionInst *dfi) {
    processedDifferentiableFunctionInsts.insert(dfi);
  }

  const llvm::SmallMapVector<SILDifferentiabilityWitness *,
                             DifferentiationInvoker, 32> &
  getInvokers() const {
    return invokers;
  }

  void addInvoker(SILDifferentiabilityWitness *witness) {
    assert(!invokers.count(witness) &&
           "Differentiability witness already has an invoker");
    invokers.insert({witness, DifferentiationInvoker(witness)});
  }

  llvm::DenseMap<ApplyInst *, NestedApplyInfo> &getNestedApplyInfo() {
    return nestedApplyInfo;
  }

  void recordGeneratedFunction(SILFunction *function) {
    generatedFunctions.push_back(function);
  }

  void recordGeneratedFunctionReference(SILValue functionRef) {
    generatedFunctionReferences.push_back(functionRef);
  }

  ProtocolDecl *getAdditiveArithmeticProtocol() const {
    return additiveArithmeticProtocol;
  }

  FuncDecl *getPlusDecl() const;
  FuncDecl *getPlusEqualDecl() const;

  /// Cleans up all the internal state.
  void cleanUp();

  /// Creates an `differentiable_function` instruction using the given builder
  /// and arguments. Erase the newly created instruction from the processed set,
  /// if it exists - it may exist in the processed set if it has the same
  /// pointer value as a previously processed and deleted instruction.
  /// TODO(TF-784): The pointer reuse is a real concern and the use of
  /// `CanonicalizeInstruction` may get rid of the need for this workaround.
  DifferentiableFunctionInst *createDifferentiableFunction(
      SILBuilder &builder, SILLocation loc, IndexSubset *parameterIndices,
      IndexSubset *resultIndices, SILValue original,
      Optional<std::pair<SILValue, SILValue>> derivativeFunctions = None);
};

} // end namespace autodiff
} // end namespace swift

#endif // SWIFT_SILOPTIMIZER_UTILS_DIFFERENTIATION_ADCONTEXT_H
