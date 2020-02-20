// RUN: %target-swift-frontend -c %s -verify
// REQUIRES: asserts

// TF-1160: Linker error for internal original function but `@usableFromInline`
// derivative function.

@differentiable
func internalOriginal(_ x: Float) -> Float {
  x
}

// expected-error @+1 {{the original function of a public or '@usableFromInline' derivative function must also be public or '@usableFromInline', but 'internalOriginal' is internal}}
@derivative(of: internalOriginal)
@usableFromInline
func usableFromInlineDerivative(_ x: Float) -> (value: Float, pullback: (Float) -> Float) {
  (x, { $0 })
}

// Original error:
// ```
// error: unexpected error produced: symbol 'AD__$s4main16internalOriginalyS2fF__vjp_src_0_wrt_0' (AD__$s4main16internalOriginalyS2fF__vjp_src_0_wrt_0) is in generated IR file, but not in TBD file
// error: unexpected error produced: please file a radar or open a bug on bugs.swift.org with this code, and add -Xfrontend -validate-tbd-against-ir=none to squash the errors
// ```
//
// After TF-1099, type-checking rejects this program: original and derivative
// functions are required to have the same effective access level.
