//===--- AutoDiff.h - Swift automatic differentiation utilities -----------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2019 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//
//
//  This file defines utilities for automatic differentiation.
//
//===----------------------------------------------------------------------===//

#ifndef SWIFT_AST_AUTODIFF_H
#define SWIFT_AST_AUTODIFF_H

#include <cstdint>

#include "swift/AST/GenericSignature.h"
#include "swift/AST/Identifier.h"
#include "swift/AST/IndexSubset.h"
#include "swift/AST/Type.h"
#include "swift/Basic/Range.h"
#include "swift/Basic/SourceLoc.h"

namespace swift {

class AnyFunctionType;
class SILFunctionType;
class TupleType;

/// A function type differentiability kind.
enum class DifferentiabilityKind : uint8_t {
  NonDifferentiable = 0,
  Normal = 1,
  Linear = 2
};

/// The kind of an linear map.
struct AutoDiffLinearMapKind {
  enum innerty : uint8_t {
    // The differential function.
    Differential = 0,
    // The pullback function.
    Pullback = 1
  } rawValue;

  AutoDiffLinearMapKind() = default;
  AutoDiffLinearMapKind(innerty rawValue) : rawValue(rawValue) {}
  operator innerty() const { return rawValue; }
};

/// The kind of a derivative function.
struct AutoDiffDerivativeFunctionKind {
  enum innerty : uint8_t {
    // The Jacobian-vector products function.
    JVP = 0,
    // The vector-Jacobian products function.
    VJP = 1
  } rawValue;

  AutoDiffDerivativeFunctionKind() = default;
  AutoDiffDerivativeFunctionKind(innerty rawValue) : rawValue(rawValue) {}
  AutoDiffDerivativeFunctionKind(AutoDiffLinearMapKind linMapKind)
      : rawValue(static_cast<innerty>(linMapKind.rawValue)) {}
  explicit AutoDiffDerivativeFunctionKind(StringRef string);
  operator innerty() const { return rawValue; }
  AutoDiffLinearMapKind getLinearMapKind() {
    return (AutoDiffLinearMapKind::innerty)rawValue;
  }
};

/// The kind of a differentiability witness function.
struct DifferentiabilityWitnessFunctionKind {
  enum innerty : uint8_t {
    // The Jacobian-vector products function.
    JVP = 0,
    // The vector-Jacobian products function.
    VJP = 1,
    // The transpose function.
    Transpose = 2
  } rawValue;

  DifferentiabilityWitnessFunctionKind() = default;
  DifferentiabilityWitnessFunctionKind(innerty rawValue) : rawValue(rawValue) {}
  explicit DifferentiabilityWitnessFunctionKind(unsigned rawValue)
      : rawValue(static_cast<innerty>(rawValue)) {}
  explicit DifferentiabilityWitnessFunctionKind(StringRef name);
  operator innerty() const { return rawValue; }

  Optional<AutoDiffDerivativeFunctionKind> getAsDerivativeFunctionKind() const;
};

/// Identifies an autodiff derivative function configuration:
/// - Parameter indices.
/// - Result indices.
/// - Derivative generic signature (optional).
struct AutoDiffConfig {
  IndexSubset *parameterIndices;
  IndexSubset *resultIndices;
  GenericSignature derivativeGenericSignature;

  /*implicit*/ AutoDiffConfig(IndexSubset *parameterIndices,
                              IndexSubset *resultIndices,
                              GenericSignature derivativeGenericSignature)
      : parameterIndices(parameterIndices), resultIndices(resultIndices),
        derivativeGenericSignature(derivativeGenericSignature) {}

  void print(llvm::raw_ostream &s = llvm::outs()) const;
  SWIFT_DEBUG_DUMP;
};

/// A semantic function result type: either a formal function result type or
/// an `inout` parameter. Used in derivative function type calculation.
struct SemanticFunctionResultType {
  Type type;
  bool isInout;
};

class ParsedAutoDiffParameter {
public:
  enum class Kind { Named, Ordered, Self };

private:
  SourceLoc loc;
  Kind kind;
  union Value {
    struct { Identifier name; } Named;
    struct { unsigned index; } Ordered;
    struct {} self;
    Value(Identifier name) : Named({name}) {}
    Value(unsigned index) : Ordered({index}) {}
    Value() {}
  } value;

public:
  ParsedAutoDiffParameter(SourceLoc loc, Kind kind, Value value)
    : loc(loc), kind(kind), value(value) {}

  ParsedAutoDiffParameter(SourceLoc loc, Kind kind, unsigned index)
    : loc(loc), kind(kind), value(index) {}

  static ParsedAutoDiffParameter getNamedParameter(SourceLoc loc,
                                                   Identifier name) {
    return { loc, Kind::Named, name };
  }

  static ParsedAutoDiffParameter getOrderedParameter(SourceLoc loc,
                                                     unsigned index) {
    return { loc, Kind::Ordered, index };
  }

  static ParsedAutoDiffParameter getSelfParameter(SourceLoc loc) {
    return { loc, Kind::Self, {} };
  }

  Identifier getName() const {
    assert(kind == Kind::Named);
    return value.Named.name;
  }

  unsigned getIndex() const {
    return value.Ordered.index;
  }

  Kind getKind() const {
    return kind;
  }

  SourceLoc getLoc() const {
    return loc;
  }

  bool isEqual(const ParsedAutoDiffParameter &other) const {
    if (getKind() != other.getKind())
      return false;
    if (getKind() == Kind::Named)
      return getName() == other.getName();
    return getKind() == Kind::Self;
  }
};

/// The tangent space of a type.
///
/// For `Differentiable`-conforming types:
/// - The tangent space is the `TangentVector` associated type.
///
/// For tuple types:
/// - The tangent space is a tuple of the elements' tangent space types, for the
///   elements that have a tangent space.
///
/// Other types have no tangent space.
class TangentSpace {
public:
  /// A tangent space kind.
  enum class Kind {
    /// The `TangentVector` associated type of a `Differentiable`-conforming
    /// type.
    TangentVector,
    /// A product of tangent spaces as a tuple.
    Tuple
  };

private:
  Kind kind;
  union Value {
    // TangentVector
    Type tangentVectorType;
    // Tuple
    TupleType *tupleType;

    Value(Type tangentVectorType) : tangentVectorType(tangentVectorType) {}
    Value(TupleType *tupleType) : tupleType(tupleType) {}
  } value;

  TangentSpace(Kind kind, Value value) : kind(kind), value(value) {}

public:
  TangentSpace() = delete;

  static TangentSpace getTangentVector(Type tangentVectorType) {
    return {Kind::TangentVector, tangentVectorType};
  }
  static TangentSpace getTuple(TupleType *tupleTy) {
    return {Kind::Tuple, tupleTy};
  }

  bool isTangentVector() const { return kind == Kind::TangentVector; }
  bool isTuple() const { return kind == Kind::Tuple; }

  Kind getKind() const { return kind; }
  Type getTangentVector() const {
    assert(kind == Kind::TangentVector);
    return value.tangentVectorType;
  }
  TupleType *getTuple() const {
    assert(kind == Kind::Tuple);
    return value.tupleType;
  }

  /// Get the tangent space type.
  Type getType() const;

  /// Get the tangent space canonical type.
  CanType getCanonicalType() const;

  /// Get the underlying nominal type declaration of the tangent space type.
  NominalTypeDecl *getNominal() const;
};

/// The key type used for uniquing `SILDifferentiabilityWitness` in
/// `SILModule`: original function name, parameter indices, result indices, and
/// derivative generic signature.
using SILDifferentiabilityWitnessKey = std::pair<StringRef, AutoDiffConfig>;

/// Automatic differentiation utility namespace.
namespace autodiff {

/// Given an original/derivative function type and the original formal result
/// type, return the original semantic result type: either the original formal
/// result type or an `inout` parameter.
///
/// The original/derivative function type may have at most two parameter lists.
///
/// Sets `hasMultipleOriginalSemanticResults` to true iff there are multiple
/// semantic results.
///
/// Remap the original semantic result using `derivativeGenEnv`, if specified.
SemanticFunctionResultType getOriginalFunctionSemanticResultType(
    AnyFunctionType *functionType, Type originalFormalResultType,
    bool &hasMultipleOriginalSemanticResults,
    GenericEnvironment *derivativeGenEnv = nullptr);

/// "Constrained" derivative generic signatures require all differentiability
/// parameters to conform to the `Differentiable` protocol.
///
/// "Constrained" transpose generic signatures additionally require all
/// linearity parameters to satisfy `Self == Self.TangentVector`.
///
/// Returns the "constrained" derivative/transpose generic signature given:
/// - An original SIL function type.
/// - Differentiability parameter indices.
/// - A possibly "unconstrained" derivative generic signature.
GenericSignature getConstrainedDerivativeGenericSignature(
    SILFunctionType *originalFnTy, IndexSubset *diffParamIndices,
    GenericSignature derivativeGenSig, LookupConformanceFn lookupConformance,
    bool isTranspose = false);

} // end namespace autodiff

} // end namespace swift

namespace llvm {

using swift::AutoDiffConfig;
using swift::AutoDiffDerivativeFunctionKind;
using swift::GenericSignature;
using swift::IndexSubset;

template <typename T> struct DenseMapInfo;

template <> struct DenseMapInfo<AutoDiffConfig> {
  static AutoDiffConfig getEmptyKey() {
    auto *ptr = llvm::DenseMapInfo<void *>::getEmptyKey();
    // The `derivativeGenericSignature` component must be `nullptr` so that
    // `getHashValue` and `isEqual` do not try to call
    // `GenericSignatureImpl::getCanonicalSignature()` on an invalid pointer.
    return {static_cast<IndexSubset *>(ptr), static_cast<IndexSubset *>(ptr),
            nullptr};
  }

  static AutoDiffConfig getTombstoneKey() {
    auto *ptr = llvm::DenseMapInfo<void *>::getTombstoneKey();
    // The `derivativeGenericSignature` component must be `nullptr` so that
    // `getHashValue` and `isEqual` do not try to call
    // `GenericSignatureImpl::getCanonicalSignature()` on an invalid pointer.
    return {static_cast<IndexSubset *>(ptr), static_cast<IndexSubset *>(ptr),
            nullptr};
  }

  static unsigned getHashValue(const AutoDiffConfig &Val) {
    auto canGenSig =
        Val.derivativeGenericSignature
            ? Val.derivativeGenericSignature->getCanonicalSignature()
            : nullptr;
    unsigned combinedHash = hash_combine(
        ~1U, DenseMapInfo<void *>::getHashValue(Val.parameterIndices),
        DenseMapInfo<void *>::getHashValue(Val.resultIndices),
        DenseMapInfo<GenericSignature>::getHashValue(canGenSig));
    return combinedHash;
  }

  static bool isEqual(const AutoDiffConfig &LHS, const AutoDiffConfig &RHS) {
    auto lhsCanGenSig =
        LHS.derivativeGenericSignature
            ? LHS.derivativeGenericSignature->getCanonicalSignature()
            : nullptr;
    auto rhsCanGenSig =
        RHS.derivativeGenericSignature
            ? RHS.derivativeGenericSignature->getCanonicalSignature()
            : nullptr;
    return LHS.parameterIndices == RHS.parameterIndices &&
           LHS.resultIndices == RHS.resultIndices &&
           DenseMapInfo<GenericSignature>::isEqual(lhsCanGenSig, rhsCanGenSig);
  }
};

template <> struct DenseMapInfo<AutoDiffDerivativeFunctionKind> {
  static AutoDiffDerivativeFunctionKind getEmptyKey() {
    return static_cast<AutoDiffDerivativeFunctionKind::innerty>(
        DenseMapInfo<unsigned>::getEmptyKey());
  }

  static AutoDiffDerivativeFunctionKind getTombstoneKey() {
    return static_cast<AutoDiffDerivativeFunctionKind::innerty>(
        DenseMapInfo<unsigned>::getTombstoneKey());
  }

  static unsigned getHashValue(const AutoDiffDerivativeFunctionKind &Val) {
    return DenseMapInfo<unsigned>::getHashValue(Val);
  }

  static bool isEqual(const AutoDiffDerivativeFunctionKind &LHS,
                      const AutoDiffDerivativeFunctionKind &RHS) {
    return static_cast<AutoDiffDerivativeFunctionKind::innerty>(LHS) ==
        static_cast<AutoDiffDerivativeFunctionKind::innerty>(RHS);
  }
};

} // end namespace llvm

#endif // SWIFT_AST_AUTODIFF_H
