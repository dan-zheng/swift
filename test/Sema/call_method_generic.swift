// RUN: %target-typecheck-verify-swift

protocol P0 {
  func callFunction(x: Self)
}

struct ConcreteType {
  func callFunction<T, U>(_ x: T, _ y: U) -> (T, U) {
    return (x, y)
  }

  func callFunction<T, U>(_ fn: @escaping (T) -> U) -> (T) -> U {
    return fn
  }
}

let concrete = ConcreteType()
_ = concrete(1, 3.0)
_ = concrete(concrete, concrete.callFunction as ([Int], Float) -> ([Int], Float))

func generic<T, U>(_ x: T, _ y: U) {
  _ = concrete(x, x)
  _ = concrete(x, y)
}

struct GenericType<T : Collection> {
  let collection: T
  func callFunction<U>(_ x: U) -> Bool where U == T.Element, U : Equatable {
    return collection.contains(x)
  }
}

// Test conditional conformance.
extension GenericType where T.Element : Numeric {
  func callFunction(initialValue: T.Element) -> T.Element {
    return collection.reduce(initialValue, +)
  }
}

let genericString = GenericType<[String]>(collection: ["Hello", "world", "!"])
_ = genericString("Hello")
let genericInt = GenericType<Set<Int>>(collection: [1, 2, 3])
_ = genericInt(initialValue: 1)
