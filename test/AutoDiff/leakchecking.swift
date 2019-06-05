// RUN: %target-run-simple-swift
// REQUIRES: executable_test

// Test differentiation-related memory leaks.

import StdlibUnittest
import DifferentiationUnittest

var LeakCheckingTests = TestSuite("LeakChecking")

/// Execute body, check expected leak count, and reset global leak count.
func testWithLeakChecking(
  expectedLeakCount: Int = 0, file: String = #file, line: UInt = #line,
  _ body: () -> Void
) {
  body()
  expectEqual(
    expectedLeakCount, _GlobalLeakCount.count, "Leak detected.",
    file: file, line: line)
  _GlobalLeakCount.count = 0
}

struct ExampleLeakModel : Differentiable {
  var bias: Tracked<Float> = 2.0
  func applied(to input: Tracked<Float>) -> Tracked<Float> {
    var v = input + bias
    return v
  }
}

struct FloatPair : Differentiable & AdditiveArithmetic {
  var first, second: Tracked<Float>
  init(_ first: Tracked<Float>, _ second: Tracked<Float>) {
    self.first = first
    self.second = second
  }
}

struct Pair<T : Differentiable, U : Differentiable> : Differentiable
  where T == T.AllDifferentiableVariables, T == T.TangentVector,
        U == U.AllDifferentiableVariables, U == U.TangentVector
{
  var first: Tracked<T>
  var second: Tracked<U>
  init(_ first: Tracked<T>, _ second: Tracked<U>) {
    self.first = first
    self.second = second
  }
}

LeakCheckingTests.test("BasicVarLeakChecking") {
  testWithLeakChecking {
    var model = ExampleLeakModel()
    let x: Tracked<Float> = 1.0
    _ = model.gradient(at: x) { m, x in m.applied(to: x) }
  }

  testWithLeakChecking {
    var model = ExampleLeakModel()
    let x: Tracked<Float> = 1.0

    _ = model.gradient { m in m.applied(to: x) }
    for _ in 0..<10 {
      _ = model.gradient { m in m.applied(to: x) }
    }
  }

  testWithLeakChecking {
    var model = ExampleLeakModel()
    var x: Tracked<Float> = 1.0
    _ = model.gradient { m in
      x = x + x
      var y = x + Tracked<Float>(x.value)
      return m.applied(to: y)
    }
  }

  // TODO: Fix memory leak.
  testWithLeakChecking(expectedLeakCount: 1) {
    var model = ExampleLeakModel()
    let x: Tracked<Float> = 1.0
    _ = model.gradient { m in
      var model = m
      // Next line causes leak.
      model.bias = x
      return model.applied(to: x)
    }
  }
}

LeakCheckingTests.test("ControlFlow") {
  // FIXME: Fix control flow AD memory leaks.
  // See related FIXME comments in adjoint value/buffer propagation in
  // lib/SILOptimizer/Mandatory/Differentiation.cpp.
  testWithLeakChecking(expectedLeakCount: 105) {
    func cond_nestedtuple_var(_ x: Tracked<Float>) -> Tracked<Float> {
      // Convoluted function returning `x + x`.
      var y = (x + x, x - x)
      var z = (y, x)
      if x > 0 {
        var w = (x, x)
        y.0 = w.1
        y.1 = w.0
        z.0.0 = z.0.0 - y.0
        z.0.1 = z.0.1 + y.0
      } else {
        z = ((y.0 - x, y.1 + x), x)
      }
      return y.0 + y.1 - z.0.0 + z.0.1
    }
    expectEqual((8, 2), Tracked<Float>(4).valueWithGradient(in: cond_nestedtuple_var))
    expectEqual((-20, 2), Tracked<Float>(-10).valueWithGradient(in: cond_nestedtuple_var))
    expectEqual((-2674, 2), Tracked<Float>(-1337).valueWithGradient(in: cond_nestedtuple_var))
  }

  // FIXME: Fix control flow AD memory leaks.
  // See related FIXME comments in adjoint value/buffer propagation in
  // lib/SILOptimizer/Mandatory/Differentiation.cpp.
  testWithLeakChecking(expectedLeakCount: 379) {
    func cond_nestedstruct_var(_ x: Tracked<Float>) -> Tracked<Float> {
      // Convoluted function returning `x + x`.
      var y = FloatPair(x + x, x - x)
      var z = Pair(Tracked(y), x)
      if x > 0 {
        var w = FloatPair(x, x)
        y.first = w.second
        y.second = w.first
        z.first = Tracked(FloatPair(z.first.value.first - y.first,
                                    z.first.value.second + y.first))
      } else {
        z = Pair(Tracked(FloatPair(y.first - x, y.second + x)), x)
      }
      return y.first + y.second - z.first.value.first + z.first.value.second
    }
    expectEqual((8, 2), Tracked<Float>(4).valueWithGradient(in: cond_nestedstruct_var))
    expectEqual((-20, 2), Tracked<Float>(-10).valueWithGradient(in: cond_nestedstruct_var))
    expectEqual((-2674, 2), Tracked<Float>(-1337).valueWithGradient(in: cond_nestedstruct_var))
  }

  // FIXME: Fix control flow AD memory leaks.
  // See related FIXME comments in adjoint value/buffer propagation in
  // lib/SILOptimizer/Mandatory/Differentiation.cpp.
  testWithLeakChecking(expectedLeakCount: 9) {
    var model = ExampleLeakModel()
    let x: Tracked<Float> = 1.0
    _ = model.gradient(at: x) { m, x in
      let result: Tracked<Float>
      if x > 0 {
        result = m.applied(to: x)
      } else {
        result = x
      }
      return result
    }
  }

  // FIXME: Fix control flow AD memory leaks.
  // See related FIXME comments in adjoint value/buffer propagation in
  // lib/SILOptimizer/Mandatory/Differentiation.cpp.
  testWithLeakChecking(expectedLeakCount: 14) {
    var model = ExampleLeakModel()
    let x: Tracked<Float> = 1.0
    _ = model.gradient(at: x) { m, x in
      var result: Tracked<Float> = x
      if x > 0 {
        result = result + m.applied(to: x)
      }
      return result
    }
  }
}

runAllTests()
