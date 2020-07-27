// SR-13263: Debug info crash related to optimizations/LoadableByAddress and `Differentiable` derived conformances.
// This test is a copy of test/DebugInfo/sr13263.swift where `Differentiable` derived conformances are manually written.
// The crash does not reproduce if the `T: Differentiable` derived conformance is written out by hand.

// RUN: %empty-directory(%t)
// RUN: %target-swiftc_driver -DM -emit-module -emit-module-path %t/M.swiftmodule %s -module-name M
// NOTE: The following command crashes:
// RUN: not --crash %target-swiftc_driver -O -g -I %t -c %s -o /dev/null

#if M
import _Differentiation

public struct S<T> {
  class C {}
  let c: C
  internal var b: Bool
}

extension S: AdditiveArithmetic {
  public static var zero: S { fatalError() }

  public static func == (_ lhs: S, _ rhs: S) -> Bool { fatalError() }
  public static func + (_ lhs: S, _ rhs: S) -> S { fatalError() }
  public static func - (_ lhs: S, _ rhs: S) -> S { fatalError() }
}

extension S: Differentiable {
  public typealias TangentVector = S
}

#else
import _Differentiation
import M

struct T: Differentiable {
  var u1: U
  var u2: U

  // NOTE: The crash does not reproduce if the `T: Differentiable` derived conformance is written out by hand.
  /*
  struct TangentVector: Differentiable, AdditiveArithmetic {
    var u1: U.TangentVector
    var u2: U.TangentVector
    typealias TangentVector = Self

    static func + (lhs: Self, rhs: Self) -> Self { Self(u1: lhs.u1 + rhs.u1, u2: lhs.u2 + rhs.u2) }
    static func - (lhs: Self, rhs: Self) -> Self { Self(u1: lhs.u1 - rhs.u1, u2: lhs.u2 - rhs.u2) }
    static var zero: Self { Self(u1: .zero, u2: .zero) }
  }

  mutating func move(along direction: TangentVector) {
    u1.move(along: direction.u1)
    u2.move(along: direction.u2)
  }
  */
}

struct U: Differentiable {
  var s: S<Float>
  var v: V

  // NOTE: Code below is a manually written version of compiler-synthesized code
  // for `Differentiable` derived conformances.
  struct TangentVector: Differentiable, AdditiveArithmetic {
    var s: S<Float>.TangentVector
    var v: V.TangentVector
    typealias TangentVector = Self

    static func + (lhs: Self, rhs: Self) -> Self { Self(s: lhs.s + rhs.s, v: lhs.v + rhs.v) }
    static func - (lhs: Self, rhs: Self) -> Self { Self(s: lhs.s - rhs.s, v: lhs.v - rhs.v) }
    static var zero: Self { Self(s: .zero, v: .zero) }
  }

  mutating func move(along direction: TangentVector) {
    s.move(along: direction.s)
    v.move(along: direction.v)
  }
}

struct V: Differentiable {
  var s: S<Float>

  // NOTE: Code below is a manually written version of compiler-synthesized code
  // for `Differentiable` derived conformances.
  struct TangentVector: Differentiable, AdditiveArithmetic {
    var s: S<Float>.TangentVector
    typealias TangentVector = Self

    static func + (lhs: Self, rhs: Self) -> Self { Self(s: lhs.s + rhs.s) }
    static func - (lhs: Self, rhs: Self) -> Self { Self(s: lhs.s - rhs.s) }
    static var zero: Self { Self(s: .zero) }
  }

  mutating func move(along direction: TangentVector) {
    s.move(along: direction.s)
  }
}
#endif

// swift-frontend: swift-dev/llvm-project/llvm/lib/CodeGen/AsmPrinter/DwarfExpression.cpp:572: void llvm::DwarfExpression::addFragmentOffset(const llvm::DIExpression *): Assertion `FragmentOffset >= OffsetInBits && "overlapping or duplicate fragments"' failed.
// Stack dump:
// 1.	Swift version 5.3-dev (LLVM 6d510c802af0d59, Swift 3e090b483352b3c)
// 2.	Running pass 'Function Pass Manager' on module '/dev/null'.
// 3.	Running pass 'X86 Assembly Printer' on function '@"$s4null1TV4move5alongyAC13TangentVectorV_tF"'
