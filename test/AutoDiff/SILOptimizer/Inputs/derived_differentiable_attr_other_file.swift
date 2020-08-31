import _Differentiation

// SR-13310: Test `Differentiable` derived conformances and synthesized
// `@differentiable` attributes on stored properties.

// MARK: Synthesized stored property `@differentiable` attributes

// `Differentiable` derived conformances synthesizes `TangentVector`,
// `@differentiable` attributes are added to stored properties.

struct Struct: Differentiable {
  var x, y: Float
}

class Class: Differentiable {
  var x, y: Float
}

// MARK: No synthesized stored property `@differentiable` attributes

// When `Differentiable` derived conformances does not trigger,
// `@differentiable` attributes are not added to stored properties.

struct CustomTangentVectorStruct: Differentiable {
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

class CustomTangentVectorClass: Differentiable {
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
