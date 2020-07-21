// RUN: %empty-directory(%t)
// RUN: %target-swiftc_driver -DM -parse-as-library -emit-module -emit-module-path %t/M.swiftmodule %s -module-name M
// UN: not --crash %target-swiftc_driver -parse-as-library -O -g -I %t -c %s -o /dev/null -module-name main
// RUN: %target-swiftc_driver -parse-as-library -O -g -I %t -c %s -o /dev/null -module-name main

#if M
import _Differentiation

public struct S<T> {
  class C {}
  let c: C
  internal var b: Bool
}

func f<T>(_ x: S<T>, _ y: S<T>) -> S<T> { fatalError() }

extension S: AdditiveArithmetic {
  public static var zero: S { fatalError() }

  public static func == (_ lhs: S, _ rhs: S) -> Bool { fatalError() }

  public static func + (_ lhs: S, _ rhs: S) -> S { f(lhs, rhs) }
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
}

struct U: Differentiable {
  var s: S<Float>
  var v: V
}

struct V: Differentiable {
  var s: S<Float>
}
#endif
