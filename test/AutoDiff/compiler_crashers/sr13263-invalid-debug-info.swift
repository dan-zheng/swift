// RUN: %empty-directory(%t)
// RUN: %target-swiftc_driver -DM -parse-as-library -emit-module -emit-module-path %t/M.swiftmodule %s -module-name M
// UN: not --crash %target-swiftc_driver -parse-as-library -O -g -I %t -c %s -o /dev/null -module-name main
// UN: %target-swiftc_driver -parse-as-library -O -g -I %t -c %s -o /dev/null -module-name main

// UN: %target-swiftc_driver -parse-as-library -O -g -I %t -emit-ir %s -o /tmp/reduced-bad.ll -module-name main

// Test debug info.
// RUN: %target-swiftc_driver -parse-as-library -O -g -I %t -emit-ir -Xfrontend -disable-llvm-optzns %s -o /tmp/reduced-bad.ll -module-name main
// RUN: %target-swiftc_driver -DN -parse-as-library -O -g -I %t -emit-ir %s -o /tmp/reduced-ok.ll -module-name main
// UN: git diff /tmp/reduced-bad.ll /tmp/reduced-ok.ll > /tmp/reduced.diff || true

// Test debug info (SIL).
// RUN: %target-swiftc_driver -parse-as-library -O -g -I %t -emit-sil %s -o /tmp/reduced-bad.sil -module-name main
// RUN: %target-swiftc_driver -parse-as-library -O -g -I %t -emit-ir -Xllvm -sil-print-after=loadable-address -Xllvm -sil-print-only-function='$s4main1TV4move5alongyAC13TangentVectorV_tF' %s -o /dev/null -module-name main 2>/tmp/reduced-bad-lba.sil
// RUN: %target-swiftc_driver -parse-as-library -O -g -I %t -emit-ir -Xllvm -sil-print-all -Xllvm -sil-print-only-function='$s4main1TV4move5alongyAC13TangentVectorV_tF' %s -o /dev/null -module-name main 2>/tmp/reduced-bad-all.sil
// RUN: %target-swiftc_driver -parse-as-library -O -g -I %t -emit-ir -Xllvm -sil-print-all -Xllvm -sil-print-only-function='$s4main1TV4move5alongyAC13TangentVectorV_tF' -Xllvm -sil-disable-pass='loadable-address' %s -o /dev/null -module-name main 2>/tmp/reduced-bad-all-nolba.sil
// RUN: %target-swiftc_driver -parse-as-library -O -g -I %t -emit-ir -Xllvm -sil-print-all -Xllvm -sil-print-only-function='$s4main1TV4move5alongyAC13TangentVectorV_tF' %s -o /dev/null -module-name main 2>/tmp/reduced-bad-all.sil
// RUN: %target-swiftc_driver -DN -parse-as-library -O -g -I %t -emit-sil %s -o /tmp/reduced-ok.sil -module-name main
// UN: git diff /tmp/reduced-bad.ll /tmp/reduced-ok.ll > /tmp/reduced.diff || true

// Test no debug info.
// UN: %target-swiftc_driver -parse-as-library -O -I %t -emit-ir %s -o /tmp/reduced-bad-nodebug.ll -module-name main
// UN: %target-swiftc_driver -DN -parse-as-library -O -I %t -emit-ir %s -o /tmp/reduced-ok-nodebug.ll -module-name main
// UN: git diff /tmp/reduced-bad-nodebug.ll /tmp/reduced-ok-nodebug.ll > /tmp/reduced-nodebug.diff || true

// Crash reproducer below.
// RUN: %target-swiftc_driver -Xllvm -sil-disable-pass='loadable-address' -O -g -I %t -c %s -o /dev/null

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

#if N
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
    u1.move(along: direction.u2)
  }
#endif
}

struct U: Differentiable {
  var s: S<Float>
  var v: V

/*
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
*/
}

struct V: Differentiable {
  var s: S<Float>

/*
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
*/
}
#endif
