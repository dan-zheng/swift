// SR-13263: Debug info crash related to optimizations/LoadableByAddress and `Differentiable` derived conformances.

// RUN: %empty-directory(%t)
// RUN: %target-swiftc_driver -DM -emit-module -emit-module-path %t/M.swiftmodule %s -module-name M
// NOTE: The following command crashes:
// RUN: not --crash %target-swiftc_driver -O -g -I %t -c %s -o /dev/null

// ----------------------------

// The crash does not reproduce under any of the following conditions:

// 1. If Swift optimizations are disabled (`-Onone`).
// RUN: %target-swiftc_driver -g -I %t -c %s -o /dev/null

// 2. If debug info is disabled (no `-g`).
// RUN: %target-swiftc_driver -O -I %t -c %s -o /dev/null

// 3. If LoadableByAddress is disabled.
// RUN: %target-swiftc_driver -O -g -Xllvm -sil-disable-pass='loadable-address' -I %t -c %s -o /dev/null

// 4. If code synthesized by `Differentiable` derived conformances are written out by hand.
// See test/DebugInfo/sr13263-manually-written-conformances.swift.

// 5. If reproducer is compiled as one file instead of two files.
// See test/DebugInfo/sr13263-single-file.swift.

// ----------------------------

// Debugging: the key function to look at is `$s4null1TV4move5alongyAC13TangentVectorV_tF`, which causes the
// LLVM debug info crash.

// - Print SIL before and after all passes, notably before/after LoadableByAddress.
// RUN: %target-swiftc_driver -parse-as-library -O -g -I %t -emit-ir -Xllvm -sil-print-all -Xllvm -sil-print-only-function='$s4main1TV4move5alongyAC13TangentVectorV_tF' %s -o /dev/null -module-name main 2> %S/sr13263.sil-print-all

// - Print LLVM IR.
// RUN: %target-swiftc_driver -parse-as-library -O -g -I %t -emit-ir %s -module-name main -o %S/sr13263.ll

#if M
import _Differentiation

public struct S<T> {
  class C {}
  let c: C
  internal var b: Bool
}

extension S: AdditiveArithmetic {
  public static var zero: S { fatalError() }

  public static func == (_ lhs: S, _ rhs: S) -> Bool { fatalError() }
  public static func + (_ lhs: S, _ rhs: S) -> S { fatalError() }
  public static func - (_ lhs: S, _ rhs: S) -> S { fatalError() }
}

extension S: Differentiable {
  public typealias TangentVector = S
}

#else
import _Differentiation
import M

struct T: Differentiable {
  var u1: U
  var u2: U
}

struct U: Differentiable {
  var s: S<Float>
  var v: V
}

struct V: Differentiable {
  var s: S<Float>
}
#endif

// swift-frontend: swift-dev/llvm-project/llvm/lib/CodeGen/AsmPrinter/DwarfExpression.cpp:572: void llvm::DwarfExpression::addFragmentOffset(const llvm::DIExpression *): Assertion `FragmentOffset >= OffsetInBits && "overlapping or duplicate fragments"' failed.
// Stack dump:
// 1.	Swift version 5.3-dev (LLVM 6d510c802af0d59, Swift 3e090b483352b3c)
// 2.	Running pass 'Function Pass Manager' on module '/dev/null'.
// 3.	Running pass 'X86 Assembly Printer' on function '@"$s4null1TV4move5alongyAC13TangentVectorV_tF"'
