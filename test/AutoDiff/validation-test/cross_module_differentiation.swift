// RUN: %empty-directory(%t)
// RUN: %target-build-swift-dylib(%t/%target-library-name(cross_module_differentiation_other)) %S/Inputs/cross_module_differentiation_other.swift -emit-module -emit-module-path %t/cross_module_differentiation_other.swiftmodule -module-name cross_module_differentiation_other
// RUN: %target-build-swift -I%t -L%t %s -o %t/a.out -lcross_module_differentiation_other %target-rpath(%t)
// RUN: %target-codesign %t/a.out
// RUN: %target-codesign %t/%target-library-name(cross_module_differentiation_other)
// RUN: %target-run %t/a.out %t/%target-library-name(cross_module_differentiation_other)
// REQUIRES: executable_test

import cross_module_differentiation_other
import _Differentiation
import StdlibUnittest

var CrossModuleTests = TestSuite("E2ECrossModuleDifferentiation")

// TF-1025: Test differentiability witness linkage for `PublicNonABI` original functions.
// TF-1239: Test `SynthesizedFileUnit` TBDGen.

CrossModuleTests.test("differentiable function default argument") {
  let actualGrad = gradient(at: 0) { applyArgument($0) }
  let expectedGrad: Float = 1
  expectEqual(actualGrad, expectedGrad)
}

CrossModuleTests.test("differentiable function specified default argument") {
  let actualGrad = gradient(at: 0) { applyArgument($0, { $0 }) }
  let expectedGrad: Float = 1
  expectEqual(actualGrad, expectedGrad)
}

// SR-13310: Test cross-module differentiation of stored property accessor differentiation.

CrossModuleTests.test("StructStoredPropertyDifferentiation") {
  do {
    let s = Struct(x: 3, y: 4)
    let actualGrad = gradient(at: s) { s in s.x * s.y }
    let expectedGrad = Struct.TangentVector(x: 4, y: 3)
    expectEqual(actualGrad, expectedGrad)
  }

  do {
    let s = StructCustomTangentVector(x: 3, y: 4)
    let actualGrad = gradient(at: s) { s in s.x * s.y }
    let expectedGrad = StructCustomTangentVector.TangentVector(x: 4, y: 3)
    expectEqual(actualGrad, expectedGrad)
  }
}

CrossModuleTests.test("ClassStoredPropertyDifferentiation") {
  /*
  do {
    let c = Class(x: 3, y: 4)
    let actualGrad = gradient(at: c) { c in c.x * c.y }
    let expectedGrad = Class.TangentVector(x: 4, y: 3)
    expectEqual(actualGrad, expectedGrad)
  }
  */

  do {
    let c = ClassCustomTangentVector(x: 3, y: 4)
    let actualGrad = gradient(at: c) { c in c.x * c.y }
    let expectedGrad = ClassCustomTangentVector.TangentVector(x: 4, y: 3)
    expectEqual(actualGrad, expectedGrad)
  }
}

runAllTests()
