// RUN: %empty-directory(%t)
// RUN: %target-build-swift-dylib(%t/%target-library-name(cross_module_differentiation_other_new)) %S/Inputs/cross_module_differentiation_other_new.swift -emit-module -emit-module-path %t/cross_module_differentiation_other_new.swiftmodule -module-name cross_module_differentiation_other_new
// RUN: %target-build-swift -I %t -O -emit-module %s

import _Differentiation
import cross_module_differentiation_other_new

public func foo(
  body: @escaping @differentiable (Struct<Float>) -> Struct<Float> = bar
) {
  fatalError()
}
