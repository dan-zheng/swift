public struct Wrapper : Differentiable, AdditiveArithmetic {
  public var x: Float
  public init(_ x: Float) {
    self.x = x
  }

  @inlinable
  public static func + (lhs: Wrapper, rhs: Wrapper) -> Wrapper {
    return Wrapper(lhs.x + rhs.x)
  }

  @differentiating(+)
  public static func vjpAdd(lhs: Wrapper, rhs: Wrapper)
    -> (value: Wrapper, pullback: (Wrapper) -> (Wrapper, Wrapper)) {
    return (lhs + rhs, { v in (v, v) })
  }

  // @inlinable
  @_semantics("asdf")
  public static func * (lhs: Wrapper, rhs: Wrapper) -> Wrapper {
    return Wrapper(lhs.x * rhs.x)
  }

  @differentiating(*)
  public static func jvpMultiply(lhs: Wrapper, rhs: Wrapper)
    -> (value: Wrapper, differential: (Wrapper, Wrapper) -> Wrapper) {
    return (lhs * rhs, { dlhs, drhs in dlhs * rhs + lhs * drhs })
  }

  @differentiating(*)
  public static func vjpMultiply(lhs: Wrapper, rhs: Wrapper)
    -> (value: Wrapper, pullback: (Wrapper) -> (Wrapper, Wrapper)) {
    return (lhs * rhs, { v in (v * rhs, v * lhs) })
  }
}
