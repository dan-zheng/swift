// RUN: %target-run-simple-swift
// NOTE(TF-1254): support and test forward-mode differentiation.
// %target-run-simple-swift(-Xfrontend -enable-experimental-forward-mode-differentiation)
// REQUIRES: executable_test

import StdlibUnittest
import DifferentiationUnittest

var PropertyWrapperTests = TestSuite("PropertyWrapperDifferentiation")

@propertyWrapper
struct Wrapper<Value> {
  var wrappedValue: Value

  init(wrappedValue: Value) {
    self.wrappedValue = wrappedValue
  }

  subscript<T>(dynamicMemberLookup keyPath: WritableKeyPath<Value, T>) -> T {
    get { wrappedValue[keyPath: keyPath] }
    set { wrappedValue[keyPath: keyPath] = newValue }
  }
}

struct Struct: Differentiable {
  @Wrapper @Wrapper var x: Float = 10
  @Wrapper var y: Float = 20
  var z: Float = 30
}

PropertyWrapperTests.test("Simple") {
  func foo(_ s: Struct) -> Float {
    var s = s
    return s.x
  }
  let s = Struct()
  expectEqual(.init(x: 1, y: 0, z: 0), gradient(at: s, in: foo))
}

struct Generic<T> {
  @Wrapper var x: Float = 10
  @Wrapper @Wrapper @Wrapper var y: T
  var z: Float = 30
}
extension Generic: Differentiable where T: Differentiable {}

PropertyWrapperTests.test("Generic") {
  func bar<T>(_ s: Generic<T>) -> T {
    var s = s
    // s.x = 3
    return s.y
  }
  
  func bar2<T>(_ s: Generic<T>) -> Float {
    var s = s
    return s.x
  }

  let generic = Generic<Float>(y: 1)
  expectEqual(.init(x: 0, y: 1, z: 0), gradient(at: generic, in: bar))
  expectEqual(.init(x: 1, y: 0, z: 0), gradient(at: generic, in: bar2))
}

runAllTests()
