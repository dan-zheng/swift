import _Differentiation

public struct Struct<Scalar>: Differentiable {}

@differentiable
public func foo<Scalar>(_ x: Struct<Scalar>) -> Struct<Scalar> { x }

@inlinable
@differentiable
public func bar<Scalar>(_ x: Struct<Scalar>) -> Struct<Scalar> {
  foo(x)
}

// gelu_vjp calls pow_vjp, which contains a differentiable_function_extract instruction
