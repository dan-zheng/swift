// RUN: %target-swift-frontend -typecheck -verify %s

// ~~~~~~~~~~~~~ Test top-level functions. ~~~~~~~~~~~~~

func linearFunc(_ x: Float) -> Float {
  return x
}

@transpose(of: linearFunc, wrt: 0)
func linearFuncTranspose(x: Float) -> Float {
  return x
}

func twoParams(_ x: Float, _ y: Double) -> Double {
  return Double(x) + y
}

@transpose(of: twoParams, wrt: 0)
func twoParamsT1(_ y: Double, _ t: Double) -> Float {
  return Float(t + y)
}

@transpose(of: twoParams, wrt: 1)
func twoParamsT2(_ x: Float, _ t: Double) -> Double {
  return Double(x) + t
}

@transpose(of: twoParams, wrt: (0, 1))
func twoParamsT3(_ t: Double) -> (Float, Double) {
  return (Float(t), t)
}

func threeParams(_ x: Float, _ y: Double, _ z: Float) -> Double {
  return Double(x) + y
}

@transpose(of: threeParams, wrt: 0)
func threeParamsT1(_ y: Double, _ z: Float, _ t: Double) -> Float {
  return Float(t + y) + z
}

@transpose(of: threeParams, wrt: 1)
func threeParamsT2(_ x: Float, _ z: Float, _ t: Double) -> Double {
  return Double(x + z) + t
}

@transpose(of: threeParams, wrt: 2)
func threeParamsT3(_ x: Float, _ y: Double, _ t: Double) -> Float {
  return Float(y + t) + x
}

@transpose(of: threeParams, wrt: (0, 1))
func threeParamsT4(_ z: Float, _ t: Double) -> (Float, Double) {
  return (z + Float(t), Double(z) + t)
}

@transpose(of: threeParams, wrt: (0, 2))
func threeParamsT5(_ y: Double, _ t: Double) -> (Float, Float) {
  let ret = Float(y + t)
  return (ret, ret)
}

@transpose(of: threeParams, wrt: (0, 1, 2))
func threeParamsT5(_ t: Double) -> (Float, Double, Float) {
  let ret = Float(t)
  return (ret, t, ret)
}

// Generics
func generic<T: Differentiable>(x: T) -> T where T == T.TangentVector {
  return x
}

@transpose(of: generic, wrt: 0)
func genericT<T: Differentiable>(x: T) -> T where T == T.TangentVector {
  return x
}

func genericThreeParam<
  T: Differentiable & BinaryFloatingPoint,
  U: Differentiable & BinaryFloatingPoint,
  V: Differentiable & BinaryFloatingPoint>(
  t: T, u: U, v: V
) -> T where T == T.TangentVector,
             U == U.TangentVector,
             V == V.TangentVector {
  return t
}

@transpose(of: genericThreeParam, wrt: 1)
func genericThreeParamT2<
  T: Differentiable & BinaryFloatingPoint,
  U: Differentiable & BinaryFloatingPoint,
  V: Differentiable & BinaryFloatingPoint>(
  t: T, v: V, s: T
) -> U where T == T.TangentVector,
             U == U.TangentVector,
             V == V.TangentVector {
  return U(1)
}

@transpose(of: genericThreeParam, wrt: (0, 1, 2))
func genericThreeParamT2<
  T: Differentiable & BinaryFloatingPoint,
  U: Differentiable & BinaryFloatingPoint,
  V: Differentiable & BinaryFloatingPoint>(
  t: T
) -> (T, U, V) where T == T.TangentVector,
                     U == U.TangentVector,
                     V == V.TangentVector {
  return (T(1), U(1), V(1))
}

func genericOneParamFloatOneParam<T: Differentiable & BinaryFloatingPoint>(
  t: T, f: Float
) -> T where T == T.TangentVector {
  return T(f)
}

@transpose(of: genericOneParamFloatOneParam, wrt: 0)
func genericOneParamFloatOneParamT1<T: Differentiable & BinaryFloatingPoint>(
  f: Float, t: T
) -> T where T == T.TangentVector {
  return t
}

@transpose(of: genericOneParamFloatOneParam, wrt: 1)
func genericOneParamFloatOneParamT1<T: Differentiable & BinaryFloatingPoint>(
  t1: T, t2: T
) -> Float where T == T.TangentVector {
  return 1
}

@transpose(of: genericOneParamFloatOneParam, wrt: (0, 1))
func genericOneParamFloatOneParamT1<T: Differentiable & BinaryFloatingPoint>(
  t: T
) -> (T, Float) where T == T.TangentVector {
  return (T(1), 1)
}

func withInt(x: Float, y: Int) -> Float {
  if y >= 0 {
    return x
  } else {
    return x
  }
}

@transpose(of: withInt, wrt: 0)
func withIntT(x: Int, t: Float) -> Float {
  return t
}

func missingDiffSelfRequirement<T: AdditiveArithmetic>(x: T) -> T {
  return x
}

// expected-error @+1 {{'@transpose(of:)' attribute requires original function result 'T' to conform to 'Differentiable'}}
@transpose(of: missingDiffSelfRequirement, wrt: 0)
func missingDiffSelfRequirementT<T: AdditiveArithmetic>(x: T) -> T {
  return x
}

// TODO: error should be "can only transpose with respect to parameters that conform to 'Differentiable' and where 'Int == Int.TangentVector'"
// but currently there is an assertion failure.
/*
func missingSelfRequirement<T: Differentiable>(x: T)
  -> T where T.TangentVector == T {
  return x
}

@transpose(of: missingSelfRequirement, wrt: 0)
func missingSelfRequirementT<T: Differentiable>(x: T) -> T {
  return x
}
*/

func differentGenericConstraint<T: Differentiable & BinaryFloatingPoint>(x: T)
-> T where T == T.TangentVector {
  return x
}

// expected-error @+1 {{could not find function 'differentGenericConstraint' with expected type '<T where T : Differentiable, T == T.TangentVector> (T) -> T'}}
@transpose(of: differentGenericConstraint, wrt: 0)
func differentGenericConstraintT<T: Differentiable>(x: T)
-> T where T == T.TangentVector {
  return x
}

func transposingInt(x: Float, y: Int) -> Float {
  if y >= 0 {
    return x
  } else {
    return x
  }
}

// expected-error @+1 {{can only transpose with respect to parameters that conform to 'Differentiable' and where 'Int == Int.TangentVector'}}
@transpose(of: transposingInt, wrt: 1)
func transposingIntT1(x: Float, t: Float) -> Int {
  return Int(x)
}

// expected-error @+1 {{'@transpose(of:)' attribute requires original function result 'Int' to conform to 'Differentiable'}}
@transpose(of: transposingInt, wrt: 0)
func tangentNotLast(t: Float, y: Int) -> Float {
  return t
}

// ~~~~~~~~~~~~~ Test methods. ~~~~~~~~~~~~~

// // Method no parameters.
extension Float {
  func getDouble() -> Double {
      return Double(self)
  }
}

extension Double {
  @transpose(of: Float.getDouble, wrt: self)
  func structTranspose() -> Float {
    return Float(self)
  }
}

// Method with one parameter.
extension Float {
  func adding(_ double: Double) -> Float {
    return self + Float(double)
  }

  @transpose(of: Float.adding, wrt: 0)
  func addingT1(t: Float) -> Double {
    return Double(self + t)
  }

  @transpose(of: Float.adding, wrt: self)
  func addingT2(_ double: Double) -> Float {
    return self + Float(double)
  }

  @transpose(of: Float.adding, wrt: (self, 0))
  func addingT3() -> (Float, Double) {
    return (self, Double(self))
  }
}

// Different self type/result type.
extension Int {
  func myAdding(_ double: Double) -> Float {
    return Float(double)
  }
}

extension Float {
  @transpose(of: Int.myAdding, wrt: 0)
  func addingT3(t: Int) -> Double {
    return Double(self)
  }

  // expected-error @+1 {{can only transpose with respect to parameters that conform to 'Differentiable' and where 'Int == Int.TangentVector'}}
  @transpose(of: Int.myAdding, wrt: (self, 0))
  func addingT3() -> (Int, Double) {
    return (Int(self), Double(self))
  }
}

// Static methods.
struct A : Differentiable & AdditiveArithmetic {
  typealias TangentVector = A
  var x: Double

  static prefix func -(a: A) -> A {
    return A(x: -a.x)
  }

  @transpose(of: A.-, wrt: 0)
  func negationT(a: A.Type) -> A {
    return A(x: 1)
  }
}

infix operator ++

extension Float {
  static func myMultiply(lhs: Float, rhs: Float) -> Float {
    return lhs * rhs
  }

  @transpose(of: Float.myMultiply, wrt: 0)
  @transpose(of: Float.myMultiply, wrt: 1)
  func myMultiplyT(selfType: Float.Type, param: Float) -> Float {
    return self + param
  }

  static func threeParamsStatic(_ x: Float, _ y: Double, _ z: Float) -> Double {
    return Double(x + z) + y
  }

  static func ++ (lhs: Float, rhs: Float) -> Float {
    return lhs + rhs
  }

  @transpose(of: Float.++, wrt: 0)
  @transpose(of: Float.++, wrt: 1)
  func myMultiplyTranspose(selfType: Float.Type, param: Float) -> Float {
    return self + param
  }
}

extension Double {
  @transpose(of: Float.threeParamsStatic, wrt: (0, 1, 2))
  func threeParamsT12(staticSelf: Float.Type) -> (Float, Double, Float) {
    return (Float(self), self, Float(self))
  }

  @transpose(of: Float.threeParamsStatic, wrt: (0, 2))
  func threeParamsT12(staticSelf: Float.Type, _ y: Double) -> (Float, Float) {
    let ret = Float(self + y)
    return (ret, ret)
  }

  @transpose(of: Float.threeParamsStatic, wrt: 1)
  func threeParamsT12(staticSelf: Float.Type, _ x: Float, _ z: Float) -> Double {
    return self + Double(x + z)
  }
}

// Method with 3 parameters.
extension Float {
  func threeParams(_ x: Float, _ y: Double, _ z: Float) -> Double {
    return Double(self + x + z) + y
  }
}

extension Double {
  @transpose(of: Float.threeParams, wrt: 0)
  func threeParamsT1(_ s: Float, _ y: Double, _ z: Float) -> Float {
    return Float(self + y) + s + z
  }

  @transpose(of: Float.threeParams, wrt: 1)
  func threeParamsT2(_ s: Float, _ x: Float, _ y: Float) -> Double {
    return self + Double(x + s + y)
  }

  @transpose(of: Float.threeParams, wrt: 2)
  func threeParamsT3(_ s: Float, _ x: Float, _ y: Double) -> Float {
    return s + x + Float(self + y)
  }

  @transpose(of: Float.threeParams, wrt: (0, 1))
  func threeParamsT4(_ s: Float, _ z: Float) -> (Float, Double) {
    return (Float(self) + s + z, self + Double(s + z))
  }

  @transpose(of: Float.threeParams, wrt: (0, 2))
  func threeParamsT5(_ s: Float, _ y: Double) -> (Float, Float) {
    let ret = Float(self + y) + s
    return (ret, ret)
  }

  @transpose(of: Float.threeParams, wrt: (0, 1, 2))
  func threeParamsT6(s: Float) -> (Float, Double, Float) {
    return (s + Float(self), Double(s) + self, s + Float(self))
  }

  @transpose(of: Float.threeParams, wrt: self)
  func threeParamsT6(_ x: Float, _ y: Double, _ z: Float) -> Float {
    return Float(self + y) + x
  }

  @transpose(of: Float.threeParams, wrt: (self, 0))
  func threeParamsT7(_ y: Double, _ z: Float) -> (Float, Float) {
    let ret = Float(self) + Float(y) + z
    return (ret, ret)
  }

  @transpose(of: Float.threeParams, wrt: (self, 1))
  func threeParamsT7(_ x: Float, _ z: Float) -> (Float, Double) {
    return (Float(self) + x + z, self + Double(x + z))
  }

  @transpose(of: Float.threeParams, wrt: (self, 2))
  func threeParamsT9(_ x: Float, _ y: Double) -> (Float, Float) {
    let ret = Float(self + y) + x
    return (ret, ret)
  }

  @transpose(of: Float.threeParams, wrt: (self, 0, 1))
  func threeParamsT10(_ z: Float) -> (Float, Float, Double) {
    let retF = Float(self) + z
    return (retF, retF, self + Double(z))
  }

  @transpose(of: Float.threeParams, wrt: (self, 0, 2))
  func threeParamsT11(_ y: Double) -> (Float, Float, Float) {
    let ret = Float(self + y)
    return (ret, ret, ret)
  }

  @transpose(of: Float.threeParams, wrt: (self, 0, 1, 2))
  func threeParamsT12() -> (Float, Float, Double, Float) {
    return (Float(self), Float(self), self, Float(self))
  }
}

// Nested struct
struct level1 {
  struct level2: Differentiable & AdditiveArithmetic {
    func foo(x: Float) -> Float {
      return x
    }
  }
  struct level2_nondiff {
    func foo(x: Float) -> Float {
      return x
    }
  }
}

extension Float {
  @transpose(of: level1.level2.foo, wrt: 0)
  func t(x: level1.level2) -> Float {
    return self
  }

  @transpose(of: level1.level2.foo, wrt: (self, 0))
  func t() -> (level1.level2, Float) {
    return (level1.level2(), self)
  }

  // expected-error @+1 {{can only transpose with respect to parameters that conform to 'Differentiable' and where 'level1.level2_nondiff == level1.level2_nondiff.TangentVector'}}
  @transpose(of: level1.level2_nondiff.foo, wrt: (self, 0))
  func t() -> (level1.level2_nondiff, Float) {
    return (level1.level2_nondiff(), self)
  }
}

// Generics
extension Float {
  func genericOneParamFloatOneParam<T: Differentiable & BinaryFloatingPoint>(
    t: T, f: Float
  ) -> Float where T == T.TangentVector {
    return f
  }

  @transpose(of: Float.genericOneParamFloatOneParam, wrt: 0)
  func genericOneParamFloatOneParamT1<T: Differentiable & BinaryFloatingPoint>(
    f1: Float, f2: Float
  ) -> T where T == T.TangentVector {
    return T(1)
  }

  @transpose(of: Float.genericOneParamFloatOneParam, wrt: (0, 1))
  func genericOneParamFloatOneParamT2<T: Differentiable & BinaryFloatingPoint>(
    f1: Float
  ) -> (T, Float) where T == T.TangentVector {
    return (T(1), 1)
  }

  @transpose(of: Float.genericOneParamFloatOneParam, wrt: (self, 1))
  func genericOneParamFloatOneParamT1<T: Differentiable & BinaryFloatingPoint>(
    t: T
  ) -> (Float, Float) where T == T.TangentVector {
    return (1, 1)
  }

  @transpose(of: Float.genericOneParamFloatOneParam, wrt: (self, 0, 1))
  func genericOneParamFloatOneParamT1<
    T: Differentiable & BinaryFloatingPoint
  >() -> (Float, T, Float) where T == T.TangentVector {
    return (1, T(1), 1)
  }
}

// Test non-`func` original declarations.

struct Struct<T> {}
extension Struct: Equatable where T: Equatable {}
extension Struct: Differentiable & AdditiveArithmetic
where T: Differentiable & AdditiveArithmetic {}

// Test computed properties.
extension Struct {
  var computedProperty: Struct { self }
}
extension Struct where T: Differentiable & AdditiveArithmetic {
  @transpose(of: computedProperty, wrt: self)
  func transposeProperty() -> Self {
    self
  }
}

// Test initializers.
extension Struct {
  init(_ x: Float) {}
  init(_ x: T, y: Float) {}
}

extension Struct where T: Differentiable & AdditiveArithmetic {
  // TODO(TF-997): Support `@transpose` attribute with initializer original declaration.
  // expected-error @+1 {{'@transpose(of:)' attribute requires original function result 'Struct<T>.Type' to conform to 'Differentiable'}}
  @transpose(of: init, wrt: 0)
  static func vjpInit(_ x: Self) -> Float {
    fatalError()
  }

  // TODO(TF-997): Support `@transpose` attribute with initializer original declaration.
  // expected-error @+1 {{'@transpose(of:)' attribute requires original function result 'Struct<T>.Type' to conform to 'Differentiable'}}
  @transpose(of: init(_:y:), wrt: (0, 1))
  static func vjpInit2(_ x: Self) -> (T, Float) {
    fatalError()
  }
}

// Test subscripts.
extension Struct {
  subscript() -> Self {
    get { self }
    set {}
  }
  subscript(float float: Float) -> Self { self }
  subscript<U: Differentiable>(x: U) -> Self { self }
}

extension Struct where T: Differentiable & AdditiveArithmetic {
  @transpose(of: subscript, wrt: self)
  func vjpSubscript() -> Self {
    self
  }

  @transpose(of: subscript(float:), wrt: self)
  func vjpSubscriptLabelled(_ float: Float) -> Self {
    self
  }

  @transpose(of: subscript(_:), wrt: self)
  func vjpSubscriptGeneric<U: Differentiable>(x: U) -> Self {
    self
  }
}

// Check that `@transpose` attribute rejects stored property original declarations.

struct StoredProperty: Differentiable {
  var stored: Float

  // Note: `@transpose` support for instance members is currently too limited
  // to properly register a transpose for a non-`Self`-typed member.

  // expected-error @+1 {{could not find function 'stored' with expected type '(StoredProperty) -> () -> StoredProperty'}}
  @transpose(of: stored, wrt: self)
  func vjpStored() -> Self {
    fatalError()
  }
}
