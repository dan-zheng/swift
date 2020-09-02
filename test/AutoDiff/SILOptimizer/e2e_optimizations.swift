// RUN: %target-swift-frontend -emit-sil -O %s | %FileCheck %s

import _Differentiation

@_silgen_name("blackHole")
@inline(never)
@discardableResult
func blackHole<T>(_ x: T) -> T { x }

func simpleMath(_ x0: Float) -> Float {
  let x1 = x0 * x0
  let x2 = x1 + x1
  let x3 = x2 - x1
  let x4 = x3 / x2
  return x4
}

func simpleMath_mutation(_ x0: Float) -> Float {
  var result = x0 * x0
  result = result + result
  result = result - x0
  result = result / x0
  return result
}

@_silgen_name("test_gradient_apply_simpleMath")
func test_gradient_apply_simpleMath() {
  blackHole(gradient(at: 10, in: simpleMath))
}

// Check that `apply`s are fully inlined.
// CHECK-LABEL: sil hidden @test_gradient_apply_simpleMath : $@convention(thin) () -> ()
// CHECK-NOT: apply
// CHECK: [[GRADIENT_RESULT:%.*]] = struct $Float ({{.*}} : $Builtin.FPIEEE32)
// CHECK: [[FN_REF:%.*]] = function_ref @$s9blackHoleSf_Tg5 : $@convention(thin) (Float) -> Float
// CHECK-NEXT: apply [[FN_REF:%.*]]([[GRADIENT_RESULT]])
// CHECK-NOT: apply
// CHECK-LABEL: } // end sil function 'test_gradient_apply_simpleMath'

@_silgen_name("test_gradient_apply_simpleMath_mutation")
func test_gradient_apply_simpleMath_mutation() {
  blackHole(gradient(at: 10, in: simpleMath_mutation))
}

// Check that `apply`s are fully inlined.
// CHECK-LABEL: sil hidden @test_gradient_apply_simpleMath_mutation : $@convention(thin) () -> ()
// CHECK-NOT: apply
// CHECK: [[GRADIENT_RESULT:%.*]] = struct $Float ({{.*}} : $Builtin.FPIEEE32)
// CHECK: [[FN_REF:%.*]] = function_ref @$s9blackHoleSf_Tg5 : $@convention(thin) (Float) -> Float
// CHECK-NEXT: apply [[FN_REF:%.*]]([[GRADIENT_RESULT]])
// CHECK-NOT: apply
// CHECK-LABEL: } // end sil function 'test_gradient_apply_simpleMath_mutation'
