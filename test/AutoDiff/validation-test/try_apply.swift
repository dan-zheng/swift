import _Differentiation

do {
  @_silgen_name("rethrowing")
  func rethrowing(_ x: () throws -> Void) rethrows -> Void {}

  @_silgen_name("foo")
  @differentiable
  func foo(_ x: Float) -> Float {
    rethrowing({})
    return x
  }
  print(gradient(at: 3, in: foo))
}

do {
  @_silgen_name("throwing")
  @differentiable
  func throwing(_ x: Float) throws -> Float {
    return x
  }

  @_silgen_name("foo")
  @differentiable
  func foo(_ x: Float, bool: Bool) -> Float {
    return try! throwing(x)
  /*
    if bool && bool {
      return x + x
    }
    return x * x
  */
  }
  // print(gradient(at: 10, in: { x in foo(x, bool: true) }))
  // print(gradient(at: 10, in: { x in foo(x, bool: false) }))
}

// Test active
do {
  @_silgen_name("throwing")
  @differentiable
  func throwing(_ x: Float) throws -> Float {
    return x
  }

  @_silgen_name("foo")
  @differentiable
  func foo(_ x: Float, bool: Bool) -> Float {
    do {
      return try throwing(x)
    } catch let e {
      fatalError("Error: \(e)")
    }
  /*
    if bool && bool {
      return x + x
    }
    return x * x
  */
  }
  print(gradient(at: 10, in: { x in foo(x, bool: true) }))
  print(gradient(at: 10, in: { x in foo(x, bool: false) }))
}
