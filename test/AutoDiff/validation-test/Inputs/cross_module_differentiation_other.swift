import _Differentiation

// Test `@differentiable`-function-typed default parameter values.
// TF-1025: Test differentiability witness linkage for `PublicNonABI` original functions.

@differentiable
public func defaultArgument(_ x: Float) -> Float {
  return x
}

@differentiable
public func applyArgument(
  _ x: Float,
  _ f: @differentiable (Float) -> Float = defaultArgument
) -> Float {
  return f(x)
}
