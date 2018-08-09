//===-- Parameterized.swift ----------------------------------*- swift -*-===//
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
// This file defines the Parameterized and ParameterAggregate protocols.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// ParameterAggregate
//===----------------------------------------------------------------------===//

/// A type representing an aggregate of parameters.
public protocol ParameterAggregate {
  /// The parameter type.
  associatedtype Parameter

  /// Update parameters with their gradient values, using an updater function.
  mutating func update(
    withGradients gradients: Self,
    _ updater: (inout Parameter, Parameter) -> Void
  )

  /// A collection of keypaths to all parameters of this type.
  static var allKeyPaths: [WritableKeyPath<Self, Parameter>] { get }
}

//===----------------------------------------------------------------------===//
// Parameterized
//===----------------------------------------------------------------------===//

/// A type whose values have parameters.
///
/// Instances of `Parameterized` types have parameters, represented as stored
/// properties marked with the `@TFParameter` attribute.
///
/// For types that conform to `Parameterized`, the Swift compiler can
/// synthesize a member struct type `Parameters`, which includes all of the
/// marked properties, and a computed instance `allParameters`.
///
/// If all parameters have the same type, the compiler also synthesizes a
/// conformance of `Parameters` to `ParameterAggregate`.
///
public protocol Parameterized {
  /// The type representing all parameters, synthesized from stored properties
  /// marked with `@TFParameter`.
  associatedtype Parameters

  /// A synthesized instance of `Parameters`.
  var allParameters: Parameters { get set }
}

public extension Parameterized where Parameters : ParameterAggregate {
  /// Update parameters with their gradient values, using an updater function.
  @inlinable
  mutating func updateParameters(
    withGradients gradients: Parameters,
    _ updater: (inout Parameters.Parameter, Parameters.Parameter) -> Void
  ) {
    allParameters.update(withGradients: gradients, updater)
  }
}
