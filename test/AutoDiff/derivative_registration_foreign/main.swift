// RUN: %empty-directory(%t)
// RUN: %target-swift-frontend -emit-module %S/Inputs/Foreign.swift -I %S/Inputs -o %t/Foreign.swiftmodule
// RUN: %target-swift-emit-silgen -Xllvm -enable-experimental-cross-file-derivative-registration -I %S/Inputs -I %t %s | %FileCheck %s --check-prefix=CHECK-SILGEN
// RUN: %target-swift-emit-sil -Xllvm -enable-experimental-cross-file-derivative-registration -I %S/Inputs -I %t %s | %FileCheck %s --check-prefix=CHECK-SIL
// RUN: %target-build-swift -Xllvm -enable-experimental-cross-file-derivative-registration -I %S/Inputs -I %t %s

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
import Darwin
#elseif os(Linux) || os(FreeBSD) || os(PS4) || os(Android) || os(Cygwin) || os(Haiku)
import Glibc
#elseif os(Windows)
import MSVCRT
#endif

import CForeign
import Foreign

// TF-1087: Test derivative registration for foreign declaration (Clang-imported).
// Original SILDeclRef must have `isForeign` bit set correctly.

// CHECK-SILGEN-LABEL: // differentiability witness for cFunction
// CHECK-SILGEN: sil_differentiability_witness [serialized] [parameters 0] [results 0] @cFunction : $@convention(c) (Float) -> Float {
// CHECK-SILGEN:   vjp: @AD__$sSo9cFunctionyS2fFTO__vjp_src_0_wrt_0 : $@convention(thin) (Float) -> (Float, @owned @callee_guaranteed (Float) -> Float)
// CHECK-SILGEN: }

// CHECK-SIL-LABEL: // differentiability witness for cFunction
// CHECK-SIL: sil_differentiability_witness [serialized] [parameters 0] [results 0] @cFunction : $@convention(c) (Float) -> Float {
// CHECK-SIL:   jvp: @AD__cFunction__jvp_src_0_wrt_0 : $@convention(thin) (Float) -> (Float, @owned @callee_guaranteed (Float) -> Float)
// CHECK-SIL:   vjp: @AD__$sSo9cFunctionyS2fFTO__vjp_src_0_wrt_0 : $@convention(thin) (Float) -> (Float, @owned @callee_guaranteed (Float) -> Float)
// CHECK-SIL: }

// Check that original SIL function is correct.

// CHECK: sil [serializable] [clang cFunction] @cFunction : $@convention(c) (Float) -> Float

@derivative(of: cFunction)
@inlinable
func vjpCFunction(_ x: Float) -> (value: Float, pullback: (Float) -> Float) {
  (cFunction(x), { $0 })
}

@derivative(of: swiftFunction)
@inlinable
func vjpSwiftFunction(_ x: Float) -> (value: Float, pullback: (Float) -> Float) {
  (swiftFunction(x), { $0 })
}

// Verify no linker errors.

@differentiable
func testDerivatives(_ x: Float) -> Float {
  var result = cFunction(x)
  result = swiftFunction(result)
  return result
}
