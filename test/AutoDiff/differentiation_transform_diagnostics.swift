// RUN: %target-swift-frontend -emit-sil -verify %s

// This file tests SIL diagnostics during the differentiation transform.

//===----------------------------------------------------------------------===//
// Basic function
//===----------------------------------------------------------------------===//

func one_to_one_0(_ x: Float) -> Float {
  return x + 2
}

_ = gradient(at: 0, in: one_to_one_0) // okay!

//===----------------------------------------------------------------------===//
// Invalid `TangentVector` associated types
//===----------------------------------------------------------------------===//

// Test struct property with no corresponding `TangentVector` computed property.
struct InvalidTangentVectorComputedProperty: Differentiable {
  var x: Float
  struct TangentVector: Differentiable, AdditiveArithmetic {
    // NOTE(TF-969): `TangentVector` computed property not yet supported.
    var x: Float { 1 }
  }
  mutating func move(along direction: TangentVector) {}
}
// expected-error @+1 {{function is not differentiable}}
@differentiable
// expected-note @+1 {{when differentiating this function definition}}
func TF_696(_ foo: InvalidTangentVectorComputedProperty) -> Float {
  // expected-warning @+1 {{variable 'tmp' was never mutated; consider changing to 'let' constant}}
  var tmp = foo
  // expected-note @+1 {{property cannot be differentiated because 'InvalidTangentVectorComputedProperty.TangentVector' is not a struct with a stored property named 'x' with type 'Float'}}
  return tmp.x + foo.x // `struct_extract` and `struct_element_addr`
}
// expected-error @+1 {{function is not differentiable}}
@differentiable
// expected-note @+1 {{when differentiating this function definition}}
func TF_696_control_flow(_ foo: InvalidTangentVectorComputedProperty, bool: Bool) -> Float {
  if bool {}
  if bool {}
  // expected-warning @+1 {{variable 'tmp' was never mutated; consider changing to 'let' constant}}
  var tmp = foo
  // expected-note @+1 {{property cannot be differentiated because 'InvalidTangentVectorComputedProperty.TangentVector' is not a struct with a stored property named 'x' with type 'Float'}}
  return tmp.x + foo.x // `struct_extract` and `struct_element_addr`
}

struct InvalidTangentVectorComputedPropertyGeneric<T> {
  var x: T
}
extension InvalidTangentVectorComputedPropertyGeneric: Differentiable where T: Differentiable {
  struct TangentVector: Differentiable, AdditiveArithmetic {
    // NOTE(TF-969): `TangentVector` computed property not yet supported.
    var x: T.TangentVector { fatalError() }
  }
  mutating func move(along direction: TangentVector) {}
}
// expected-error @+1 {{function is not differentiable}}
@differentiable(where T: Differentiable)
// expected-note @+1 {{when differentiating this function definition}}
func TF_969_generic<T>(_ foo: InvalidTangentVectorComputedPropertyGeneric<T>) -> T {
  // expected-warning @+1 {{variable 'tmp' was never mutated; consider changing to 'let' constant}}
  var tmp = foo
  // expected-note @+1 {{property cannot be differentiated because 'InvalidTangentVectorComputedProperty.TangentVector' is not a struct with a stored property named 'x' with type 'Float'}}
  return tmp.x // `struct_element_addr`
}

// Test class `TangentVector` associated type.
struct InvalidClassTangentVector: Equatable, Differentiable {
  var x: Float
  final class TangentVector: Differentiable, AdditiveArithmetic {
    var x: Float = 1
    typealias TangentVector = InvalidClassTangentVector.TangentVector
    static func ==(_: TangentVector, _: TangentVector) -> Bool { fatalError() }
    static var zero: TangentVector { fatalError() }
    static func +(_: TangentVector, _: TangentVector) -> TangentVector { fatalError() }
    static func -(_: TangentVector, _: TangentVector) -> TangentVector { fatalError() }
  }
  mutating func move(along direction: TangentVector) {}
}
// expected-error @+1 {{function is not differentiable}}
@differentiable
// expected-note @+1 {{when differentiating this function definition}}
func TF_700_class(_ foo: InvalidClassTangentVector) -> Float {
  // expected-warning @+1 {{variable 'tmp' was never mutated; consider changing to 'let' constant}}
  var tmp = foo
  // expected-note @+1 {{property cannot be differentiated because 'InvalidClassTangentVector.TangentVector' is not a struct with a stored property named 'x' with type 'Float'}}
  return tmp.x + foo.x // `struct_extract` and `struct_element_addr`
}

// Test enum `TangentVector` associated type.
struct InvalidEnumTangentVector: Equatable, Differentiable {
  var x: Float
  enum TangentVector: Differentiable, AdditiveArithmetic {
    case unit
    typealias TangentVector = Self
    static func ==(_: Self, _: Self) -> Bool { fatalError() }
    static var zero: Self { fatalError() }
    static func +(_: Self, _: Self) -> Self { fatalError() }
    static func -(_: Self, _: Self) -> Self { fatalError() }
  }
  mutating func move(along direction: TangentVector) {}
}
// expected-error @+1 {{function is not differentiable}}
@differentiable
// expected-note @+1 {{when differentiating this function definition}}
func TF_700_enum(_ foo: InvalidEnumTangentVector) -> Float {
  // expected-warning @+1 {{variable 'tmp' was never mutated; consider changing to 'let' constant}}
  var tmp = foo
  // expected-note @+1 {{property cannot be differentiated because 'InvalidEnumTangentVector.TangentVector' is not a struct with a stored property named 'x' with type 'Float'}}
  return tmp.x + foo.x // `struct_extract` and `struct_element_addr`
}

//===----------------------------------------------------------------------===//
// Non-differentiable stored properties
//===----------------------------------------------------------------------===//

struct S {
  var p: Float
}
extension S : Differentiable, AdditiveArithmetic {
  // Test custom `TangentVector` type with non-matching stored property name.
  struct TangentVector: Differentiable, AdditiveArithmetic {
    var dp: Float
  }
  typealias AllDifferentiableVariables = S
  static var zero: S { return S(p: 0) }
  typealias Scalar = Float
  static func + (lhs: S, rhs: S) -> S { return S(p: lhs.p + rhs.p) }
  static func - (lhs: S, rhs: S) -> S { return S(p: lhs.p - rhs.p) }
  static func * (lhs: Float, rhs: S) -> S { return S(p: lhs * rhs.p) }

  mutating func move(along direction: TangentVector) {
    p.move(along: direction.dp)
  }
}

// expected-error @+2 {{function is not differentiable}}
// expected-note @+1 {{property cannot be differentiated because 'S.TangentVector' is not a struct with a stored property named 'p' with type 'Float'}}
_ = gradient(at: S(p: 0)) { s in 2 * s.p }

struct NoDerivativeProperty : Differentiable {
  var x: Float
  @noDerivative var y: Float
}
_ = gradient(at: NoDerivativeProperty(x: 1, y: 1)) { s -> Float in
  var tmp = s
  tmp.y = tmp.x // No diagnostics expected.
  return tmp.x
}
_ = gradient(at: NoDerivativeProperty(x: 1, y: 1)) { s in
  // TODO(TF-788): Re-enable non-varied result warning.
  // xpected-warning @+1 {{result does not depend on differentiation arguments and will always have a zero derivative; do you want to use 'withoutDerivative(at:)'?}} {{10-10=withoutDerivative(at:}} {{13-13=)}}
  return s.y
}
_ = gradient(at: NoDerivativeProperty(x: 1, y: 1)) {
  // TODO(TF-788): Re-enable non-varied result warning.
  // xpected-warning @+1 {{result does not depend on differentiation arguments and will always have a zero derivative; do you want to use 'withoutDerivative(at:)'?}} {{3-3=withoutDerivative(at:}} {{7-7=)}}
  $0.y
}

//===----------------------------------------------------------------------===//
// Function composition
//===----------------------------------------------------------------------===//

func uses_optionals(_ x: Float) -> Float {
  // expected-note @+1 {{differentiating enum values is not yet supported}}
  var maybe: Float? = 10
  maybe = x
  return maybe!
}

// expected-error @+1 {{function is not differentiable}}
_ = gradient(at: 0, in: uses_optionals)

func base(_ x: Float) -> Float {
  // expected-error @+2 {{expression is not differentiable}}
  // expected-note @+1 {{cannot differentiate through a non-differentiable result; do you want to use 'withoutDerivative(at:)'?}}
  return Float(Int(x))
}

// TODO: Fix nested differentiation diagnostics. Need to fix indirect differentiation invokers.
func nested(_ x: Float) -> Float {
  // xpected-note @+1 {{when differentiating this function call}}
  return base(x)
}

func middle(_ x: Float) -> Float {
  // xpected-note @+1 {{when differentiating this function call}}
  return nested(x)
}

func middle2(_ x: Float) -> Float {
  // xpected-note @+1 {{when differentiating this function call}}
  return middle(x)
}

func func_to_diff(_ x: Float) -> Float {
  // xpected-note @+1 {{expression is not differentiable}}
  return middle2(x)
}

func calls_grad_of_nested(_ x: Float) -> Float {
  // xpected-error @+1 {{function is not differentiable}}
  return gradient(at: x, in: func_to_diff)
}

//===----------------------------------------------------------------------===//
// Control flow
//===----------------------------------------------------------------------===//

func if_else(_ x: Float, _ flag: Bool) -> Float {
  let y: Float
  if flag {
    y = x + 1
  } else {
    y = x
  }
  return y
}

_ = gradient(at: 0) { x in if_else(x, true) }

//===----------------------------------------------------------------------===//
// @differentiable attributes
//===----------------------------------------------------------------------===//

var a: Float = 3.0
protocol P {
  @differentiable(wrt: x)
  func foo(x: Float) -> Float
}

enum T : P {
  // expected-note @+2 {{when differentiating this function definition}}
  // expected-error @+1 {{function is not differentiable}}
  @differentiable(wrt: x) func foo(x: Float) -> Float {
    // expected-note @+1 {{cannot differentiate writes to global variables}}
    a = a + x
    return a
  }
}

// expected-note @+2 {{when differentiating this function definition}}
// expected-error @+1 {{function is not differentiable}}
@differentiable(wrt: x) func foo(x: Float) -> Float {
  // expected-note @+1 {{cannot differentiate writes to global variables}}
  a = a + x
  return a
}

// Test `@differentiable` on initializer with assignments.
struct TF_305 : Differentiable {
  var filter: Float
  var bias: Float
  typealias Activation = @differentiable (Float) -> Float
  @noDerivative let activation: Activation
  @noDerivative let strides: (Int, Int)

  @differentiable
  public init(
    filter: Float,
    bias: Float,
    activation: @escaping Activation,
    strides: (Int, Int)
  ) {
    self.filter = filter
    self.bias = bias
    self.activation = activation
    self.strides = strides
  }
}

// TF-676: Test differentiation of protocol requirement with multiple
// `@differentiable` attributes.
protocol MultipleDiffAttrsProto : Differentiable {
  @differentiable(wrt: (self, x))
  @differentiable(wrt: x)
  func f(_ x: Float) -> Float
}
func testMultipleDiffAttrsProto<P: MultipleDiffAttrsProto>(_ p: P, _ x: Float) {
  _ = gradient(at: p, x) { p, x in p.f(x) }
  _ = gradient(at: x) { x in p.f(x) }
}

// TF-676: Test differentiation of class method with multiple `@differentiable`
// attributes.
class MultipleDiffAttrsClass : Differentiable {
  @differentiable(wrt: (self, x))
  @differentiable(wrt: x)
  func f(_ x: Float) -> Float { x }
}
func testMultipleDiffAttrsClass<C: MultipleDiffAttrsClass>(_ c: C, _ x: Float) {
  // TODO(TF-647): Handle differentiation of `upcast` instruction.
  // expected-error @+2 {{function is not differentiable}}
  // expected-note @+1 {{expression is not differentiable}}
  _ = gradient(at: c, x) { c, x in c.f(x) }
  _ = gradient(at: x) { x in c.f(x) }
}

//===----------------------------------------------------------------------===//
// Classes
//===----------------------------------------------------------------------===//

class Foo : Differentiable {
  @differentiable
  // expected-note @+1 {{cannot convert a direct method reference to a '@differentiable' function; use an explicit closure instead}}
  func method(_ x: Float) -> Float {
    return x
  }

  // Not marked with `@differentiable`.
  func method2(_ x: Float) -> Float {
    return x
  }

  var base: Float = 1

  // TODO(TF-645): Remove when differentiation supports `ref_element_addr`.
  @differentiable
  func usesRefElementAddr(_ x: Float) -> Float {
    // expected-error @+2 {{expression is not differentiable}}
    // expected-note @+1 {{member is not differentiable because the corresponding class member is not '@differentiable'}}
    return base * x
  }
}

@differentiable
func differentiateClassMethod(x: Float) -> Float {
  return Foo().method(x)
}

@differentiable
func differentiateClassMethod2(x: Float) -> Float {
  // expected-error @+2 {{expression is not differentiable}}
  // expected-note @+1 {{member is not differentiable because the corresponding class member is not '@differentiable'}}
  return Foo().method2(x)
}

let _: @differentiable (Float) -> Float = Foo().method

// expected-error @+1 {{function is not differentiable}}
_ = gradient(at: .zero, in: Foo().method)

//===----------------------------------------------------------------------===//
// Unreachable
//===----------------------------------------------------------------------===//

// expected-error @+1 {{function is not differentiable}}
let no_return: @differentiable (Float) -> Float = { x in
  let _ = x + 1
// expected-error @+2 {{missing return in a closure expected to return 'Float'}}
// expected-note @+1 {{missing return for differentiation}}
}

//===----------------------------------------------------------------------===//
// Non-differentiable arguments and results
//===----------------------------------------------------------------------===//

// expected-error @+1 {{function is not differentiable}}
@differentiable
// expected-note @+1 {{when differentiating this function definition}}
func roundingGivesError(x: Float) -> Float {
  // expected-note @+1 {{cannot differentiate through a non-differentiable result; do you want to use 'withoutDerivative(at:)'?}}
  return Float(Int(x))
}

//===----------------------------------------------------------------------===//
// Inout arguments
//===----------------------------------------------------------------------===//

func activeInoutArg(_ x: Float) -> Float {
  var a = x
  // expected-note @+1 {{cannot differentiate through 'inout' arguments}}
  a += x
  return a
}
// expected-error @+1 {{function is not differentiable}}
_ = pullback(at: .zero, in: activeInoutArg(_:))

func activeInoutArgTuple(_ x: Float) -> Float {
  var tuple = (x, x)
  // expected-note @+1 {{cannot differentiate through 'inout' arguments}}
  tuple.0 *= x
  return x * tuple.0
}
// expected-error @+1 {{function is not differentiable}}
_ = pullback(at: .zero, in: activeInoutArgTuple(_:))

//===----------------------------------------------------------------------===//
// Non-varied results
//===----------------------------------------------------------------------===//

func one() -> Float {
  return 1
}
@differentiable
func nonVariedResult(_ x: Float) -> Float {
  // TODO(TF-788): Re-enable non-varied result warning.
  // xpected-warning @+1 {{result does not depend on differentiation arguments and will always have a zero derivative; do you want to use 'withoutDerivative(at:)'?}} {{10-10=withoutDerivative(at:}} {{15-15=)}}
  return one()
}

// Check that `withoutDerivative(at:)` silences the warning.

struct TF_775: Differentiable {
  @differentiable(wrt: (self))
  func nonVariedResult(_ input: Float) -> Float {
    withoutDerivative(at: input)
  }
}

//===----------------------------------------------------------------------===//
// Subset parameters
//===----------------------------------------------------------------------===//

func nondiff(_ f: @differentiable (Float, @nondiff Float) -> Float) -> Float {
  // expected-note @+2 {{cannot differentiate with respect to a '@nondiff' parameter}}
  // expected-error @+1 {{function is not differentiable}}
  return gradient(at: 2) { x in f(x * x, x) }
}

// Test parameter subset thunk + partially-applied original function.
struct TF_675 : Differentiable {
  @differentiable
  // expected-note @+1 {{cannot convert a direct method reference to a '@differentiable' function; use an explicit closure instead}}
  func method(_ x: Float) -> Float {
    return x
  }
}
// expected-error @+1 {{function is not differentiable}}
let _: @differentiable (Float) -> Float = TF_675().method

// TF-918: test parameter subset thunk + partially-applied original function.
// expected-error @+2 {{function is not differentiable}}
// expected-note @+1 {{cannot convert a direct method reference to a '@differentiable' function; use an explicit closure instead}}
_ = gradient(at: Float(1), Float(2), in: (+) as @differentiable (Float, @nondiff Float) -> Float)

//===----------------------------------------------------------------------===//
// Conversion to `@differentiable(linear)` (not yet supported)
//===----------------------------------------------------------------------===//

// expected-error @+1 {{conversion to '@differentiable(linear)' function type is not yet supported}}
let _: @differentiable(linear) (Float) -> Float = { x in x }
