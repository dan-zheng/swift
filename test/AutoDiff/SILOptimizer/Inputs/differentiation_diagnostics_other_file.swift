import _Differentiation

protocol Protocol: Differentiable {
  // Test cross-file `@differentiable` attribute.
  @differentiable(wrt: self)
  func identityDifferentiableAttr() -> Self

  // Test `@differentiable` propagation from storage declaration to accessors.
  @differentiable
  var property: Float { get set }

  // Test `@differentiable` propagation from storage declaration to accessors.
  @differentiable
  subscript() -> Float { get set }
}

extension Protocol {
  func identityDerivativeAttr() -> Self { self }

  // Test cross-file `@derivative` attribute.
  @derivative(of: identityDerivativeAttr)
  func vjpIdentityDerivativeAttr() -> (
    value: Self, pullback: (TangentVector) -> TangentVector
  ) {
    fatalError()
  }
}

class Class: Differentiable {
  // Test `@differentiable` propagation from storage declaration to accessors.
  @differentiable
  var property: Float {
    get { 1 }
    set {}
  }

  // Test `@differentiable` propagation from storage declaration to accessors.
  @differentiable
  subscript() -> Float {
    get { 1 }
    set {}
  }
}

struct S: Differentiable {
  var value: Float
}

extension Array where Element == S {
  @differentiable
  func sum() -> Float {
    return 0
  }
}

// Test `Differentiable` derived conformances and synthesized `@differentiable`
// attributes on stored properties.

struct Struct: Differentiable {
  var x, y: Float

  init(x: Float, y: Float) {
    self.x = x
    self.y = y
  }
}

class Class: Differentiable {
  var x, y: Float

  init(x: Float, y: Float) {
    self.x = x
    self.y = y
  }
}

// Test struct with custom `TangentVector`.
// `Differentiable` derived conformances does not add `@differentiable`
// attributes to stored properties for such structs.
struct StructCustomTangentVector: Differentiable {
  var x, y: Float

  init(x: Float, y: Float) {
    self.x = x
    self.y = y
  }

  struct TangentVector: Differentiable & AdditiveArithmetic {
    var x, y: Float

    init(x: Float, y: Float) {
      self.x = x
      self.y = y
    }
  }

  mutating func move(along direction: TangentVector) {
    x.move(along: direction.x)
    y.move(along: direction.y)
  }
}

// Test class with custom `TangentVector`.
// `Differentiable` derived conformances does not add `@differentiable`
// attributes to stored properties for such classes.
class ClassCustomTangentVector: Differentiable {
  var x, y: Float

  init(x: Float, y: Float) {
    self.x = x
    self.y = y
  }

  struct TangentVector: Differentiable & AdditiveArithmetic {
    var x, y: Float

    init(x: Float, y: Float) {
      self.x = x
      self.y = y
    }
  }

  func move(along direction: TangentVector) {
    x.move(along: direction.x)
    y.move(along: direction.y)
  }
}
