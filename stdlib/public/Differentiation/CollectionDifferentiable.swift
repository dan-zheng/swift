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
  init(_ base: Base) {
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

extension Collection
where
  Self: Differentiable, Element: Differentiable,
  TangentVector: RangeReplaceableCollection,
  TangentVector.Element == Element.TangentVector
{
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
      pullback: { tangent in
        var selfTangent = TangentVector()
        var resultTangent = tangent
        var index = selfTangent.startIndex
        for pullback in pullbacks.reversed() {
          let (newResultTangent, elementTangent) = pullback(resultTangent)
          resultTangent = newResultTangent
          selfTangent.append(elementTangent)
          index = selfTangent.index(after: index)
        }
        return (selfTangent, resultTangent)
      }
    )
  }
}

