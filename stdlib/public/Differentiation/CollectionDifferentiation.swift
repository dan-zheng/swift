//===--- CollectionDifferentiation.swift ----------------------*- swift -*-===//
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

import Swift

// public struct CollectionTangentVector<Base: RangeReplaceableCollection>
// where Base: Equatable, Base.Element: Differentiable & AdditiveArithmetic {

public struct CollectionTangentVector<Base: RangeReplaceableCollection>
where Base.Element: Differentiable & AdditiveArithmetic {
  public var base: Base
  public init(_ base: Base) {
    self.base = base
  }
}

extension CollectionTangentVector: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.base.elementsEqual(rhs.base)
  }
}

extension CollectionTangentVector: AdditiveArithmetic {
  public static var zero: Self { Self(Base()) }

  public static func + (
    lhs: Self,
    rhs: Self
  ) -> Self {
    precondition(
      lhs.base.count == 0 || rhs.base.count == 0
        || lhs.base.count == rhs.base.count,
      "cannot add Selfs with different counts: "
        + "\(lhs.base.count) and \(rhs.base.count)")
    if lhs.base.count == 0 {
      return rhs
    }
    if rhs.base.count == 0 {
      return lhs
    }
    return Self(Base(zip(lhs.base, rhs.base).map(+)))
  }

  public static func - (
    lhs: Self,
    rhs: Self
  ) -> Self {
    precondition(
      lhs.base.count == 0 || rhs.base.count == 0
        || lhs.base.count == rhs.base.count,
      "cannot add Selfs with different counts: "
        + "\(lhs.base.count) and \(rhs.base.count)")
    if lhs.base.count == 0 {
      return rhs
    }
    if rhs.base.count == 0 {
      return lhs
    }
    return Self(Base(zip(lhs.base, rhs.base).map(+)))
  }
}

extension CollectionTangentVector: Differentiable {
  public typealias TangentVector = Self
}

extension CollectionTangentVector: Collection {
  public typealias Element = Base.Element
  public typealias Index = Base.Index
  public typealias Iterator = IndexingIterator<Self>

  public var startIndex: Index { base.startIndex }
  public var endIndex: Index { base.endIndex }
  public func index(after i: Index) -> Index { base.index(after: i) }
  public subscript(index: Index) -> Element {
    get { base[index] }
  }
}

extension CollectionTangentVector: BidirectionalCollection
where Base: BidirectionalCollection {
   public func index(before i: Index) -> Index { base.index(before: i) }
}

extension CollectionTangentVector: RandomAccessCollection
where Base: RandomAccessCollection {}

extension CollectionTangentVector: MutableCollection where Base: MutableCollection {
  public subscript(index: Index) -> Element {
    get { base[index] }
    set { base[index] = newValue }
  }
}

/*
extension CollectionTangentVector: ExpressibleByArrayLiteral
where Base: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: Base.ArrayLiteralElement...) {
    self.init(Base(arrayLiteral: elements))
  }
}
*/

extension CollectionTangentVector: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: Element...) {
    self.init(Base(elements))
  }
}

// Note: `CollectionTangentVector` cannot conform to
// `RangeReplaceableCollection` because `RangeReplaceableCollection.+(_:_:)`
// conflicts with `AdditiveArithmetic.+(_:_:)`.
extension CollectionTangentVector where Base: RangeReplaceableCollection {
  public init() { self.init(Base()) }

  public mutating func replaceSubrange<C>(
    _ subrange: Range<Index>,
    with newElements: __owned C
  ) where C: Collection, C.Element == Element {
    base.replaceSubrange(subrange, with: newElements)
  }

  public init<S>(_ elements: S) where S: Sequence, Element == S.Element {
    self.init(Base(elements))
  }
}

extension Array: Differentiable where Element: Differentiable {
  public typealias TangentVector = CollectionTangentVector<Array<Element.TangentVector>>
  public mutating func move(along direction: TangentVector) {
    precondition(
      count == direction.count,
      "cannot move Array.DifferentiableView with count \(count) along "
        + "direction with different count \(direction.count)")
    for i in indices {
      self[i].move(along: direction[i])
    }
  }
  public var zeroTangentVectorInitializer: () -> TangentVector {
    { [zeroInits = map(\.zeroTangentVectorInitializer)] in
      // TangentVector(ContiguousArray(zeroInits.map { $0() }))
      TangentVector()
    }
  }
}

extension ContiguousArray: Differentiable where Element: Differentiable {
  public typealias TangentVector = CollectionTangentVector<ContiguousArray<Element.TangentVector>>
  public mutating func move(along direction: TangentVector) {
    precondition(
      count == direction.count,
      "cannot move Array.DifferentiableView with count \(count) along "
        + "direction with different count \(direction.count)")
    for i in indices {
      self[i].move(along: direction[i])
    }
  }
  public var zeroTangentVectorInitializer: () -> TangentVector {
    { [zeroInits = map(\.zeroTangentVectorInitializer)] in
      // TangentVector(ContiguousArray(zeroInits.map { $0() }))
      TangentVector()
    }
  }
}

extension ArraySlice: Differentiable where Element: Differentiable {
  public typealias TangentVector = CollectionTangentVector<ArraySlice<Element.TangentVector>>
  public mutating func move(along direction: TangentVector) {
    precondition(
      count == direction.count,
      "cannot move Array.DifferentiableView with count \(count) along "
        + "direction with different count \(direction.count)")
    for i in indices {
      self[i].move(along: direction[i])
    }
  }
  public var zeroTangentVectorInitializer: () -> TangentVector {
    { [zeroInits = map(\.zeroTangentVectorInitializer)] in
      // TangentVector(ContiguousArray(zeroInits.map { $0() }))
      TangentVector()
    }
  }
}

/*
func foo<Base>(_ base: Base)
where Base: RangeReplaceableCollection, Base: Equatable, Base.Element: Differentiable & AdditiveArithmetic
{
  let tan = CollectionTangentVector(base)
  print(tan)
  print(tan + tan)
}

func foo2<Base: Differentiable>(_ base: Base) {
  let tan = pullback(at: base, in: { $0 })(Base.TangentVector.zero)
  print(tan)
  print(tan + tan)
}

foo([1, 2, 3])
foo([1, 2, 3] as ContiguousArray<Double>)
foo([1, 2, 3] as ArraySlice<Double>)
*/

//===----------------------------------------------------------------------===//
// Derivatives
//===----------------------------------------------------------------------===//

extension Array where Element: Differentiable {
  @usableFromInline
  @derivative(of: subscript)
  func _vjpSubscript(index: Int) -> (
    value: Element, pullback: (Element.TangentVector) -> TangentVector
  ) {
    func pullback(_ v: Element.TangentVector) -> TangentVector {
      var dSelf = [Element.TangentVector](
        repeating: .zero,
        count: count)
      dSelf[index] = v
      return TangentVector(dSelf)
    }
    return (self[index], pullback)
  }

  @usableFromInline
  @derivative(of: +)
  static func _vjpConcatenate(_ lhs: Self, _ rhs: Self) -> (
    value: Self,
    pullback: (TangentVector) -> (TangentVector, TangentVector)
  ) {
    func pullback(_ v: TangentVector) -> (TangentVector, TangentVector) {
      precondition(
        v.base.count == lhs.count + rhs.count, """
          Tangent vector with invalid count; expected to equal the sum of \
          operand counts \(lhs.count) and \(rhs.count)
          """)
      return (
        TangentVector([Element.TangentVector](v.base[0..<lhs.count])),
        TangentVector([Element.TangentVector](v.base[lhs.count...]))
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
    append(element)
    return ((), { v in
      defer { v.base.removeLast() }
      return v.base[appendedElementIndex]
    })
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
  @derivative(of: +=)
  static func _vjpAppend(_ lhs: inout Self, _ rhs: Self) -> (
    value: Void, pullback: (inout TangentVector) -> TangentVector
  ) {
    let lhsCount = lhs.count
    lhs += rhs
    return ((), { v in
      let drhs =
        TangentVector(.init(v.base.dropFirst(lhsCount)))
      let rhsCount = drhs.base.count
      v.base.removeLast(rhsCount)
      return drhs
    })
  }

  @usableFromInline
  @derivative(of: +=)
  static func _jvpAppend(_ lhs: inout Self, _ rhs: Self) -> (
    value: Void, differential: (inout TangentVector, TangentVector) -> Void
  ) {
    lhs += rhs
    return ((), { $0.base += $1.base })
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

//===----------------------------------------------------------------------===//
// Differentiable higher order functions for collections
//===----------------------------------------------------------------------===//

extension Array where Element: Differentiable {
  @inlinable
  @differentiable(wrt: self)
  public func differentiableMap<Result: Differentiable>(
    _ body: @differentiable (Element) -> Result
  ) -> [Result] {
    map(body)
  }

  @inlinable
  @derivative(of: differentiableMap)
  internal func _vjpDifferentiableMap<Result: Differentiable>(
    _ body: @differentiable (Element) -> Result
  ) -> (
    value: [Result],
    pullback: (Array<Result>.TangentVector) -> Array.TangentVector
  ) {
    var values: [Result] = []
    var pullbacks: [(Result.TangentVector) -> Element.TangentVector] = []
    for x in self {
      let (y, pb) = valueWithPullback(at: x, in: body)
      values.append(y)
      pullbacks.append(pb)
    }
    func pullback(_ tans: Array<Result>.TangentVector) -> Array.TangentVector {
      .init(zip(tans.base, pullbacks).map { tan, pb in pb(tan) })
    }
    return (value: values, pullback: pullback)
  }
}

extension Array where Element: Differentiable {
  @inlinable
  @differentiable(wrt: (self, initialResult))
  public func differentiableReduce<Result: Differentiable>(
    _ initialResult: Result,
    _ nextPartialResult: @differentiable (Result, Element) -> Result
  ) -> Result {
    reduce(initialResult, nextPartialResult)
  }

  @inlinable
  @derivative(of: differentiableReduce)
  internal func _vjpDifferentiableReduce<Result: Differentiable>(
    _ initialResult: Result,
    _ nextPartialResult: @differentiable (Result, Element) -> Result
  ) -> (
    value: Result,
    pullback: (Result.TangentVector)
      -> (Array.TangentVector, Result.TangentVector)
  ) {
    var pullbacks:
      [(Result.TangentVector) -> (Result.TangentVector, Element.TangentVector)] =
        []
    let count = self.count
    pullbacks.reserveCapacity(count)
    var result = initialResult
    for element in self {
      let (y, pb) =
        valueWithPullback(at: result, element, in: nextPartialResult)
      result = y
      pullbacks.append(pb)
    }
    return (
      value: result,
      pullback: { tangent in
        var resultTangent = tangent
        var elementTangents = TangentVector([])
        elementTangents.base.reserveCapacity(count)
        for pullback in pullbacks.reversed() {
          let (newResultTangent, elementTangent) = pullback(resultTangent)
          resultTangent = newResultTangent
          elementTangents.base.append(elementTangent)
        }
        return (TangentVector(elementTangents.base.reversed()), resultTangent)
      }
    )
  }
}

extension Collection
where
  Self: Differentiable, Element: Differentiable,
  TangentVector: MutableCollection,
  TangentVector.Element == Element.TangentVector
{
  @inlinable
  @differentiable(wrt: (self, initialResult))
  public func differentiableReduce2<Result: Differentiable>(
    _ initialResult: Result,
    _ nextPartialResult: @differentiable (Result, Element) -> Result
  ) -> Result {
    reduce(initialResult, nextPartialResult)
  }

  @inlinable
  @derivative(of: differentiableReduce2)
  internal func _vjpDifferentiableReduce<Result: Differentiable>(
    _ initialResult: Result,
    _ nextPartialResult: @differentiable (Result, Element) -> Result
  ) -> (
    value: Result,
    pullback: (Result.TangentVector)
      -> (TangentVector, Result.TangentVector)
  ) {
    var pullbacks:
      [(Result.TangentVector) -> (Result.TangentVector, Element.TangentVector)] =
        []
    let count = self.count
    pullbacks.reserveCapacity(count)
    var result = initialResult
    for element in self {
      let (y, pb) =
        valueWithPullback(at: result, element, in: nextPartialResult)
      result = y
      pullbacks.append(pb)
    }
    return (
      value: result,
      pullback: { [selfZeroTanInit = zeroTangentVectorInitializer] v in
        var selfTangent = selfZeroTanInit()
        var resultTangent = v
        var index = selfTangent.startIndex
        for pullback in pullbacks.reversed() {
          let (newResultTangent, elementTangent) = pullback(resultTangent)
          resultTangent = newResultTangent
          selfTangent[index] = elementTangent
          index = selfTangent.index(after: index)
        }
        return (selfTangent, resultTangent)
      }
    )
  }
}
