// RUN: %target-swift-frontend -emit-sil -verify -primary-file %s %S/Inputs/derived_differentiable_attr_other_file.swift -module-name main -o /dev/null

// SR-13310: Test `Differentiable` derived conformances and synthesized
// `@differentiable` attributes on stored properties.

import _Differentiation

@differentiable
func testStructPropertyGetter(_ s: Struct) -> Float {
  return s.x
}

@differentiable
func testStructPropertySetter(_ s: inout Struct, _ newValue: Float) {
  s.x = newValue
}

@differentiable
func testCustomTangentVectorStructPropertyGetter(_ s: CustomTangentVectorStruct) -> Float {
  return s.x
}

@differentiable
func testCustomTangentVectorStructPropertySetter(_ s: inout CustomTangentVectorStruct, _ newValue: Float) {
  s.x = newValue
}

@differentiable
func testClassPropertyGetter(_ c: Class) -> Float {
  return c.x
}

@differentiable
func testClassPropertySetter(_ c: inout Class, _ newValue: Float) {
  c.x = newValue
}

@differentiable
func testCustomTangentVectorClassPropertyGetter(_ c: CustomTangentVectorClass) -> Float {
  // expected-error @+2 {{expression is not differentiable}}
  // expected-note @+1 {{member is not differentiable because the corresponding class member is not '@differentiable'}}
  return c.x
}

@differentiable
func testCustomTangentVectorClassPropertySetter(_ c: inout CustomTangentVectorClass, _ newValue: Float) {
  c.x = newValue
}
