// RUN: %target-swift-frontend -emit-sib -primary-file %s

import _Differentiation

// Test AST serialization of differentiation generated structs/enums.
@differentiable
func TF_623(_ x: Float) -> Float {
   if x > 0 {}
   return x
}
