// RUN: %empty-directory(%t)
// RUN: %target-build-swift-dylib(%t/%target-library-name(cross_module_differentiation_other_new)) -emit-module -emit-module-path %t/cross_module_differentiation_other_new.swiftmodule -module-name cross_module_differentiation_other_new -DLIBRARY %s
// RUN: %target-build-swift -I %t -O -emit-module %s

#if LIBRARY

import _Differentiation

public struct Struct<Scalar>: Differentiable {}

@differentiable
public func foo<Scalar>(_ x: Struct<Scalar>) -> Struct<Scalar> { x }

@inlinable
@differentiable
public func bar<Scalar>(_ x: Struct<Scalar>) -> Struct<Scalar> {
  foo(x)
}

#else

import _Differentiation
import cross_module_differentiation_other_new

public func foo(
  body: @differentiable (Struct<Float>) -> Struct<Float> = bar
) {
  fatalError()
}

#endif
