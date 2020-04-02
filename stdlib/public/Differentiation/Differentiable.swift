//===--- Differentiable.swift ---------------------------------*- swift -*-===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2019 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//
//
// This file defines the Differentiable protocol, used by the experimental
// differentiable programming project. This API is not stable and subject to
// change.
//
// Please see forum discussion for more information about the differentiable
// programming project:
// https://forums.swift.org/t/differentiable-programming-mega-proposal/28547
//
//===----------------------------------------------------------------------===//

import Swift

/// A type that mathematically represents a differentiable manifold whose
/// tangent spaces are finite-dimensional.
public protocol Differentiable {
  /// A type representing a differentiable value's derivatives.
  ///
  /// Mathematically, this is equivalent to the tangent bundle of the
  /// differentiable manifold represented by the differentiable type.
  associatedtype TangentVector: Differentiable & AdditiveArithmetic
  where TangentVector.TangentVector == TangentVector

  /// Moves `self` along the given direction. In Riemannian geometry, this is
  /// equivalent to exponential map, which moves `self` on the geodesic surface
  /// along the given tangent vector.
  mutating func move(along direction: TangentVector)
}

extension Differentiable where TangentVector == Self {
  @_alwaysEmitIntoClient
  public mutating func move(along direction: TangentVector) {
    self += direction
  }
}

//===----------------------------------------------------------------------===//
// Floating-point type conformances
//===----------------------------------------------------------------------===//

extension Float: Differentiable {
  public typealias TangentVector = Self
}
extension Double: Differentiable {
  public typealias TangentVector = Self
}
#if (arch(i386) || arch(x86_64)) && !(os(Windows) || os(Android))
  extension Float80: Differentiable {
    public typealias TangentVector = Self
  }
#endif

//===----------------------------------------------------------------------===//
// `Array` conformance
//===----------------------------------------------------------------------===//

// TODO(TF-938): Add 'Element : Differentiable' requirement.
extension Array {
  /// The view of an array as the differentiable product manifold of `Element`
  /// multiplied with itself `count` times.
  @frozen
  public struct DifferentiableView {
    var _base: [Element]
  }
}

extension Array.DifferentiableView: Differentiable
where Element: Differentiable {
  /// The viewed array.
  public var base: [Element] {
    get { return _base }
    _modify { yield &_base }
  }

  @usableFromInline
  @derivative(of: base)
  func _vjpBase() -> (
    value: [Element], pullback: (Array<Element>.TangentVector) -> TangentVector
  ) {
    return (base, { $0 })
  }

  /// Creates a differentiable view of the given array.
  public init(_ base: [Element]) { self._base = base }

  @usableFromInline
  @derivative(of: init(_:))
  static func _vjpInit(_ base: [Element]) -> (
    value: Array.DifferentiableView, pullback: (TangentVector) -> TangentVector
  ) {
    return (Array.DifferentiableView(base), { $0 })
  }

  public typealias TangentVector =
    Array<Element.TangentVector>.DifferentiableView

  public mutating func move(along direction: TangentVector) {
    precondition(
      base.count == direction.base.count,
      "cannot move Array.DifferentiableView with count \(base.count) along "
        + "direction with different count \(direction.base.count)")
    for i in base.indices {
      base[i].move(along: direction.base[i])
    }
  }
}

extension Array.DifferentiableView: Equatable
where Element: Differentiable & Equatable {
  public static func == (
    lhs: Array.DifferentiableView,
    rhs: Array.DifferentiableView
  ) -> Bool {
    return lhs.base == rhs.base
  }
}

extension Array.DifferentiableView: ExpressibleByArrayLiteral
where Element: Differentiable {
  public init(arrayLiteral elements: Element...) {
    self.init(elements)
  }
}

extension Array.DifferentiableView: CustomStringConvertible
where Element: Differentiable {
  public var description: String {
    return base.description
  }
}

/// Makes `Array.DifferentiableView` additive as the product space.
///
/// Note that `Array.DifferentiableView([])` is the zero in the product spaces
/// of all counts.
extension Array.DifferentiableView: AdditiveArithmetic
where Element: AdditiveArithmetic & Differentiable {

  public static var zero: Array.DifferentiableView {
    return Array.DifferentiableView([])
  }

  public static func + (
    lhs: Array.DifferentiableView,
    rhs: Array.DifferentiableView
  ) -> Array.DifferentiableView {
    precondition(
      lhs.base.count == 0 || rhs.base.count == 0
        || lhs.base.count == rhs.base.count,
      "cannot add Array.DifferentiableViews with different counts: "
        + "\(lhs.base.count) and \(rhs.base.count)")
    if lhs.base.count == 0 {
      return rhs
    }
    if rhs.base.count == 0 {
      return lhs
    }
    return Array.DifferentiableView(zip(lhs.base, rhs.base).map(+))
  }

  public static func - (
    lhs: Array.DifferentiableView,
    rhs: Array.DifferentiableView
  ) -> Array.DifferentiableView {
    precondition(
      lhs.base.count == 0 || rhs.base.count == 0
        || lhs.base.count == rhs.base.count,
      "cannot subtract Array.DifferentiableViews with different counts: "
        + "\(lhs.base.count) and \(rhs.base.count)")
    if lhs.base.count == 0 {
      return rhs
    }
    if rhs.base.count == 0 {
      return lhs
    }
    return Array.DifferentiableView(zip(lhs.base, rhs.base).map(-))
  }

  @inlinable
  public subscript(_ index: Int) -> Element {
    if index < base.count {
      return base[index]
    } else {
      return Element.zero
    }
  }
}

/// Makes `Array` differentiable as the product manifold of `Element`
/// multiplied with itself `count` times.
extension Array: Differentiable where Element: Differentiable {
  // In an ideal world, `TangentVector` would be `[Element.TangentVector]`.
  // Unfortunately, we cannot conform `Array` to `AdditiveArithmetic` for
  // `TangentVector` because `Array` already has a static `+` method with
  // different semantics from `AdditiveArithmetic.+`. So we use
  // `Array.DifferentiableView` for all these associated types.
  public typealias TangentVector =
    Array<Element.TangentVector>.DifferentiableView

  public mutating func move(along direction: TangentVector) {
    var view = DifferentiableView(self)
    view.move(along: direction)
    self = view.base
  }

  /// A closure that produces a `TangentVector` of zeros with the same
  /// `count` as `self`.
  public var zeroTangentVectorInitializer: () -> TangentVector {
    { [count = self.count] in
      TangentVector(.init(repeating: .zero, count: count))
    }
  }
}

extension Array where Element: Differentiable {
  @usableFromInline
  @derivative(of: subscript)
  func _vjpSubscript(index: Int) -> (
    value: Element, pullback: (Element.TangentVector) -> TangentVector
  ) {
    func pullback(_ gradientIn: Element.TangentVector) -> TangentVector {
      var gradientOut = [Element.TangentVector](
        repeating: .zero,
        count: count)
      gradientOut[index] = gradientIn
      return TangentVector(gradientOut)
    }
    return (self[index], pullback)
  }

  @usableFromInline
  @derivative(of: +)
  static func _vjpConcatenate(_ lhs: [Element], _ rhs: [Element]) -> (
    value: [Element],
    pullback: (TangentVector) -> (TangentVector, TangentVector)
  ) {
    func pullback(_ gradientIn: TangentVector) -> (TangentVector, TangentVector)
    {
      precondition(
        gradientIn.base.count == lhs.count + rhs.count,
        "+ should receive gradient with count equal to sum of operand "
          + "counts, but counts are: gradient \(gradientIn.base.count), "
          + "lhs \(lhs.count), rhs \(rhs.count)")
      return (
        TangentVector(
          [Element.TangentVector](
            gradientIn.base[0..<lhs.count])),
        TangentVector(
          [Element.TangentVector](
            gradientIn.base[lhs.count...]))
      )
    }
    return (lhs + rhs, pullback)
  }
}

extension Array where Element: Differentiable {
  @usableFromInline
  @derivative(of: append)
  mutating func _vjpAppend(_ element: Element) -> (
    value: Void, pullback: (inout TangentVector) -> Element.TangentVector
  ) {
    let appendedElementIndex = count
    defer { append(element) }
    return ((), { dself in dself.base[appendedElementIndex] })
  }

  @usableFromInline
  @derivative(of: append)
  mutating func _jvpAppend(_ element: Element) -> (
    value: Void,
    differential: (inout TangentVector, Element.TangentVector) -> Void
  ) {
    append(element)
    return ((), { $0.base.append($1) })
  }
}

extension Array where Element: Differentiable {
  @usableFromInline
  @derivative(of: init(repeating:count:))
  static func _vjpInit(repeating repeatedValue: Element, count: Int) -> (
    value: Self, pullback: (TangentVector) -> Element.TangentVector
  ) {
    (
      value: Self(repeating: repeatedValue, count: count),
      pullback: { v in
        v.base.reduce(.zero, +)
      }
    )
  }
}
