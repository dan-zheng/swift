// RUN: %target-swift-frontend -typecheck -verify %s

// If the original function is "exported" (public or @usableFromInline), then
// its JVP/VJP must also be exported.

// Ok: all public.
public func foo1(_ x: Float) -> Float { x }
@derivative(of: foo1)
public func dfoo1(x: Float) -> (value: Float, pullback: (Float) -> Float) { fatalError() }

// Ok: all internal.
struct CheckpointsFoo {}
func foo2(_ x: Float) -> Float { x }
@derivative(of: foo2)
func dfoo2(_ x: Float) -> (value: Float, pullback: (Float) -> Float) { fatalError() }

// Ok: all private.
private func foo3(_ x: Float) -> Float { x }
@derivative(of: foo3)
private func dfoo3(_ x: Float) -> (value: Float, pullback: (Float) -> Float) { fatalError() }

// Error: vjp not exported.
public func bar1(_ x: Float) -> Float { x }
// expected-error @+1 {{derivative functions for public or '@usableFromInline' original function 'bar1' must also be public or '@usableFromInline', but 'dbar1' is private}}
@derivative(of: bar1)
private func dbar1(_ x: Float) -> (value: Float, pullback: (Float) -> Float) { fatalError() }
