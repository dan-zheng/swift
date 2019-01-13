// RUN: %target-run-simple-swift
// REQUIRES: executable_test

import StdlibUnittest

var MethodTests = TestSuite("Method")

// ==== Tests with generated adjoint ====

struct Parameter : Equatable {
  @differentiable(wrt: (self), vjp: vjpX)
  let x: Float

  func vjpX() -> (Float, (Float) -> Parameter) {
    return (x, { dx in Parameter(x: dx) } )
  }
}

extension Parameter {
  func squared() -> Float {
    return x * x
  }

  static func squared(p: Parameter) -> Float {
    return p.x * p.x
  }

  func multiplied(with other: Float) -> Float {
    return x * other
  }

  static func * (_ a: Parameter, _ b: Parameter) -> Float {
    return a.x * b.x
  }
}

extension Parameter : Differentiable, VectorNumeric {
  typealias TangentVector = Parameter
  typealias CotangentVector = Parameter
  typealias Scalar = Float
  typealias Shape = ()
  init(repeating repeatedValue: Float, shape: ()) {
    self.init(x: repeatedValue)
  }
  static func + (lhs: Parameter, rhs: Parameter) -> Parameter {
    return Parameter(x: lhs.x + rhs.x)
  }
  static func - (lhs: Parameter, rhs: Parameter) -> Parameter {
    return Parameter(x: lhs.x - rhs.x)
  }
  static func * (lhs: Scalar, rhs: Parameter) -> Parameter {
    return Parameter(x: lhs * rhs.x)
  }
  static var zero: Parameter { return Parameter(x: 0) }
}

MethodTests.test("instance method with generated adjoint, called from differentated func") {
  func f(_ p: Parameter) -> Float {
    return 100 * p.squared()
  }
  expectEqual(Parameter(x: 4 * 100), gradient(at: Parameter(x: 2), in: f))
  expectEqual(Parameter(x: 40 * 100), gradient(at: Parameter(x: 20), in: f))
}

MethodTests.test("instance method with generated adjoint, differentiated directly") {
  // This is our current syntax for taking gradients of instance methods
  // directly. If/when we develop nicer syntax for this, change this test.
  let g = { (p: Parameter) in p.squared() }
  expectEqual(Parameter(x: 4), gradient(at: Parameter(x: 2), in: g))
  expectEqual(Parameter(x: 40), gradient(at: Parameter(x: 20), in: g))
}

MethodTests.test("instance method with generated adjoint, wrt only self") {
  func f(_ p: Parameter) -> Float {
    return 100 * p.multiplied(with: 200)
  }
  expectEqual(Parameter(x: 100 * 200), gradient(at: Parameter(x: 1), in: f))
  expectEqual(Parameter(x: 100 * 200), gradient(at: Parameter(x: 2), in: f))
}

MethodTests.test("instance method with generated adjoint, wrt only non-self") {
  func f(_ other: Float) -> Float {
    return 100 * Parameter(x: 200).multiplied(with: other)
  }
  expectEqual(100 * 200, gradient(at: 1, in: f))
  expectEqual(100 * 200, gradient(at: 2, in: f))
}

// FIXME: Add a binary differential operator.
//
// MethodTests.test("instance method with generated adjoint, wrt self and non-self") {
//   let g = #gradient({ (p: Parameter, o: Float) in p.multiplied(with: o) })
//   expectEqual((Parameter(x: 100), 200), g(Parameter(x: 200), 100))
//   expectEqual((Parameter(x: 200), 100), g(Parameter(x: 100), 200))
// }

MethodTests.test("static method with generated adjoint, called from differentiated func") {
  func f(_ p: Parameter) -> Float {
    return 100 * Parameter.squared(p: p)
  }
  expectEqual(Parameter(x: 4 * 100), gradient(at: Parameter(x: 2), in: f))
  expectEqual(Parameter(x: 40 * 100), gradient(at: Parameter(x: 20), in: f))
}

// TODO(SR-8699): Fix this test.
// MethodTests.test("static method with generated adjoint, differentiated directly") {
//   let grad = #gradient(Parameter.squared(p:))
//   expectEqual(Parameter(x: 4), grad(Parameter(x: 2)))
//   expectEqual(Parameter(x: 40), grad(Parameter(x: 20)))
// }

MethodTests.test("static method with generated adjoint, wrt only first param") {
  func f(_ p: Parameter) -> Float {
    return 100 * (p * Parameter(x: 200))
  }
  expectEqual(Parameter(x: 100 * 200), gradient(at: Parameter(x: 1), in: f))
  expectEqual(Parameter(x: 100 * 200), gradient(at: Parameter(x: 2), in: f))
}

MethodTests.test("static method with generated adjoint, wrt only second param") {
  func f(_ p: Parameter) -> Float {
    return 100 * (Parameter(x: 200) * p)
  }
  expectEqual(Parameter(x: 100 * 200), gradient(at: Parameter(x: 1), in: f))
  expectEqual(Parameter(x: 100 * 200), gradient(at: Parameter(x: 2), in: f))
}

MethodTests.test("static method with generated adjoint, wrt all params") {
  let g = { (a: Parameter, b: Parameter) in a * b }
  expectEqual((Parameter(x: 100), Parameter(x: 200)),
              gradient(at: Parameter(x: 200), Parameter(x: 100), in: g))
  expectEqual((Parameter(x: 200), Parameter(x: 100)),
              gradient(at: Parameter(x: 100), Parameter(x: 200), in: g))
}

// ==== Tests with custom adjoint ====

struct CustomParameter : Equatable {
  @differentiable(wrt: (self), vjp: vjpX)
  let x: Float

  func vjpX() -> (Float, (Float) -> CustomParameter) {
    return (x, { dx in CustomParameter(x: dx) })
  }
}

extension CustomParameter : Differentiable, VectorNumeric {
  typealias TangentVector = CustomParameter
  typealias CotangentVector = CustomParameter
  typealias Scalar = Float
  typealias Shape = ()
  init(repeating repeatedValue: Float, shape: ()) {
    self.init(x: repeatedValue)
  }
  static func + (lhs: CustomParameter, rhs: CustomParameter) -> CustomParameter {
    return CustomParameter(x: lhs.x + rhs.x)
  }
  static func - (lhs: CustomParameter, rhs: CustomParameter) -> CustomParameter {
    return CustomParameter(x: lhs.x - rhs.x)
  }
  static func * (lhs: Scalar, rhs: CustomParameter) -> CustomParameter {
    return CustomParameter(x: lhs * rhs.x)
  }
  static var zero: CustomParameter { return CustomParameter(x: 0) }
}

extension Float {
  func clamped(to limits: ClosedRange<Float>) -> Float {
    return min(max(self, limits.lowerBound), limits.upperBound)
  }
}

extension CustomParameter {
  @differentiable(wrt: (self), adjoint: dSquared)
  func squared() -> Float {
    return x * x
  }

  func dSquared(seed: Float, origVal: Float) -> CustomParameter {
    return CustomParameter(x: (2 * x).clamped(to: -10.0...10.0) * seed)
  }

  @differentiable(adjoint: dSquared)
  static func squared(p: CustomParameter) -> Float {
    return p.x * p.x
  }

  static func dSquared(_ seed: Float, _ origVal: Float, _ p: CustomParameter)
      -> CustomParameter {
     return CustomParameter(x: (2 * p.x).clamped(to: -10.0...10.0) * seed)
  }

  // There is currently no way to define multiple custom adjoints wrt different
  // parameters on the same func, so we define a copy of this func per adjoint.

  @differentiable(wrt: (self, .0), adjoint: dMultiplied_wrtAll)
  func multiplied(with other: Float) -> Float {
    return x * other
  }

  @differentiable(wrt: (.0), adjoint: dMultiplied_wrtOther)
  func multiplied_constSelf(with other: Float) -> Float {
    return x * other
  }

  @differentiable(wrt: (self), adjoint: dMultiplied_wrtSelf)
  func multiplied_constOther(with other: Float) -> Float {
    return x * other
  }

  func dMultiplied_wrtAll(seed: Float, origVal: Float, with other: Float)
      -> (CustomParameter, Float) {
    return (CustomParameter(x: other.clamped(to: -10.0...10.0) * seed),
            x.clamped(to: -10.0...10.0) * seed)
  }

  func dMultiplied_wrtOther(seed: Float, origVal: Float, with other: Float)
      -> Float {
    return dMultiplied_wrtAll(seed: seed, origVal: origVal, with: other).1
  }

  func dMultiplied_wrtSelf(seed: Float, origVal: Float, with other: Float)
      -> CustomParameter {
    return dMultiplied_wrtAll(seed: seed, origVal: origVal, with: other).0
  }

  @differentiable(adjoint: dMultiply_wrtAll)
  static func multiply(_ lhs: CustomParameter, _ rhs: CustomParameter)
      -> Float {
    return lhs.x * rhs.x
  }

  @differentiable(wrt: (.1), adjoint: dMultiply_wrtRhs)
  static func multiply_constLhs(_ lhs: CustomParameter, _ rhs: CustomParameter)
      -> Float {
    return lhs.x * rhs.x
  }

  @differentiable(wrt: (.0), adjoint: dMultiply_wrtLhs)
  static func multiply_constRhs(_ lhs: CustomParameter, _ rhs: CustomParameter)
      -> Float {
    return lhs.x * rhs.x
  }

  static func dMultiply_wrtAll(_ seed: Float, _ origVal: Float,
                               _ lhs: CustomParameter,_ rhs: CustomParameter)
      -> (CustomParameter, CustomParameter) {
    return (CustomParameter(x: rhs.x.clamped(to: -10.0...10.0) * seed),
            CustomParameter(x: lhs.x.clamped(to: -10.0...10.0) * seed))
  }

  static func dMultiply_wrtLhs(_ seed: Float, _ origVal: Float,
                               _ lhs: CustomParameter, _ rhs: CustomParameter)
      -> CustomParameter {
    return dMultiply_wrtAll(seed, origVal, lhs, rhs).0
  }

  static func dMultiply_wrtRhs(_ seed: Float, _ origVal: Float,
                               _ lhs: CustomParameter, _ rhs: CustomParameter)
      -> CustomParameter {
    return dMultiply_wrtAll(seed, origVal, lhs, rhs).1
  }
}

MethodTests.test("instance method with custom adjoint, called from differentated func") {
  func f(_ p: CustomParameter) -> Float {
    return 100 * p.squared()
  }
  expectEqual(CustomParameter(x: 4 * 100), gradient(at: CustomParameter(x: 2), in: f))
  expectEqual(CustomParameter(x: 10 * 100), gradient(at: CustomParameter(x: 20), in: f))
}

MethodTests.test("instance method with generated adjoint, differentated directly") {
  // This is our current syntax for taking gradients of instance methods
  // directly. If/when we develop nicer syntax for this, change this test.
  let g = { (p: CustomParameter) in p.squared() }
  expectEqual(CustomParameter(x: 4), gradient(at: CustomParameter(x: 2), in: g))
  expectEqual(CustomParameter(x: 10), gradient(at: CustomParameter(x: 20), in: g))
}

MethodTests.test("static method with custom adjoint, called from differentated func") {
  func f(_ p: CustomParameter) -> Float {
    return 100 * CustomParameter.squared(p: p)
  }
  expectEqual(CustomParameter(x: 4 * 100), gradient(at: CustomParameter(x: 2), in: f))
  expectEqual(CustomParameter(x: 10 * 100), gradient(at: CustomParameter(x: 20), in: f))
}

// TODO(SR-8699): Fix this test.
// MethodTests.test("static method with custom adjoint, differentiated directly") {
//   let grad = #gradient(CustomParameter.squared(p:))
//   expectEqual(CustomParameter(x: 4), grad(CustomParameter(x: 2)))
//   expectEqual(CustomParameter(x: 10), grad(CustomParameter(x: 20)))
// }

MethodTests.test("instance method with custom adjoint, wrt only self") {
  func f(_ p: CustomParameter) -> Float {
    return 100 * p.multiplied_constOther(with: 200)
  }
  expectEqual(CustomParameter(x: 100 * 10), gradient(at: CustomParameter(x: 1), in: f))
  expectEqual(CustomParameter(x: 100 * 10), gradient(at: CustomParameter(x: 2), in: f))
}

MethodTests.test("instance method with custom adjoint, wrt only non-self") {
  func f(_ other: Float) -> Float {
    return 100 * CustomParameter(x: 200).multiplied_constSelf(with: other)
  }
  expectEqual(100 * 10, gradient(at: 1, in: f))
  expectEqual(100 * 10, gradient(at: 2, in: f))
}

MethodTests.test("instance method with custom adjoint, wrt self and non-self") {
  let g = { (p: CustomParameter, o: Float) in p.multiplied(with: o) }
  expectEqual((CustomParameter(x: 5), 10), gradient(at: CustomParameter(x: 100), 5, in: g))
  expectEqual((CustomParameter(x: 10), 5), gradient(at: CustomParameter(x: 5), 100, in: g))
}

MethodTests.test("static method with custom adjoint, wrt only lhs") {
  func f(_ p: CustomParameter) -> Float {
    return 100 * CustomParameter.multiply_constRhs(p, CustomParameter(x: 200))
  }
  expectEqual(CustomParameter(x: 100 * 10), gradient(at: CustomParameter(x: 1), in: f))
  expectEqual(CustomParameter(x: 100 * 10), gradient(at: CustomParameter(x: 2), in: f))
}

MethodTests.test("static method with custom adjoint, wrt only rhs") {
  func f(_ p: CustomParameter) -> Float {
    return 100 * CustomParameter.multiply_constLhs(CustomParameter(x: 200), p)
  }
  expectEqual(CustomParameter(x: 100 * 10), gradient(at: CustomParameter(x: 1), in: f))
  expectEqual(CustomParameter(x: 100 * 10), gradient(at: CustomParameter(x: 2), in: f))
}

MethodTests.test("static method with custom adjoint, wrt all") {
  func f(_ a: CustomParameter, _ b: CustomParameter) -> Float {
    return CustomParameter.multiply(a, b)
  }
  expectEqual((CustomParameter(x: 5), CustomParameter(x: 10)),
              gradient(at: CustomParameter(x: 100), CustomParameter(x: 5), in: f))
  expectEqual((CustomParameter(x: 10), CustomParameter(x: 5)),
              gradient(at: CustomParameter(x: 5), CustomParameter(x: 100), in: f))
}

runAllTests()
