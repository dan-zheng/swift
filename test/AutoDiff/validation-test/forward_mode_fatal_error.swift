// RUN: %target-run-simple-swift
// REQUIRES: executable_test

import StdlibUnittest
import _Differentiation

var ForwardModeFatalErrorTests = TestSuite("ForwardModeDifferentiationFatalError")

@differentiable
func foo(_ x: Float) -> Float { x }

ForwardModeFatalErrorTests.test("FatalError") {
  let message = """
      JVP for foo(_:) does not exist. Use \
      '-Xfrontend -enable-experimental-forward-mode-differentiation' to enable \
      differential-first differentiation APIs.
      """
  expectCrash(withMessage: message) {
    _ = derivative(at: 10, in: foo)
  }
}

runAllTests()
