// SR-13263: Debug info crash related to optimizations/LoadableByAddress and `Differentiable` derived conformances.
// This test is a copy of test/DebugInfo/sr13263.swift except it's a single file test case instead of a multi-file one.
// The crash does not reproduce.

// RUN: %empty-directory(%t)
// RUN: %target-swiftc_driver -DM -emit-module -emit-module-path %t/M.swiftmodule %s -module-name M
// NOTE: The following command does not crash:
// RUN: %target-swiftc_driver -O -g -I %t -c %s -o /dev/null

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

import _Differentiation
import M

struct T: Differentiable {
  var u1: U
  var u2: U
}

struct U: Differentiable {
  var s: S<Float>
  var v: V
}

struct V: Differentiable {
  var s: S<Float>
}
