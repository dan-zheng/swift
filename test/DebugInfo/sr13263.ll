; ModuleID = '/home/danielzheng/swift-dev/swift/test/DebugInfo/sr13263.ll'
source_filename = "/home/danielzheng/swift-dev/swift/test/DebugInfo/sr13263.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

module asm ".section .swift1_autolink_entries,\220x80000000\22"

%swift.type = type { i64 }
%swift.type_descriptor = type opaque
%swift.full_boxmetadata = type { void (%swift.refcounted*)*, i8**, %swift.type, i32, i8* }
%swift.refcounted = type { %swift.type*, i64 }
%swift.protocol = type { i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i32, i32, i32, i32, i32, i32 }
%swift.protocol_requirement = type { i32, i32 }
%swift.method_descriptor = type { i32, i32 }
%swift.vwtable = type { i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i64, i64, i32, i32 }
%swift.type_metadata_record = type { i32 }
%T4main1UV = type <{ %T1M1SVySfG, [7 x i8], %T4main1VV }>
%T1M1SVySfG = type <{ %T1M1SV1CCySf_G*, %TSb }>
%T1M1SV1CCySf_G = type opaque
%TSb = type <{ i1 }>
%T4main1VV = type <{ %T1M1SVySfG }>
%T4main1TV = type <{ %T4main1UV, [7 x i8], %T4main1UV }>
%T4main1TV13TangentVectorV = type <{ %T4main1UV13TangentVectorV, [7 x i8], %T4main1UV13TangentVectorV }>
%T4main1UV13TangentVectorV = type <{ %T1M1SVySfG, [7 x i8], %T4main1VV13TangentVectorV }>
%T4main1VV13TangentVectorV = type <{ %T1M1SVySfG }>
%T1M1SV1CC = type opaque
%swift.opaque = type opaque
%swift.protocol_conformance_descriptor = type { i32, i32, i32, i32 }
%swift.metadata_response = type { %swift.type*, i64 }

@"$sSfN" = external global %swift.type, align 8
@"$s1M1SVMn" = external global %swift.type_descriptor, align 4
@"got.$s1M1SVMn" = private unnamed_addr constant %swift.type_descriptor* @"$s1M1SVMn"
@"symbolic _____ySfGIego_ 1M1SV" = linkonce_odr hidden constant <{ i8, i32, [9 x i8], i8 }> <{ i8 2, i32 trunc (i64 sub (i64 ptrtoint (%swift.type_descriptor** @"got.$s1M1SVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i32, [9 x i8], i8 }>, <{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV", i32 0, i32 1) to i64)) to i32), [9 x i8] c"ySfGIego_", i8 0 }>, section "swift5_typeref", align 2
@"\01l__swift5_reflection_descriptor" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor" to i8*) }, align 8
@"symbolic _____Iego_ 4main1VV13TangentVectorV" = linkonce_odr hidden constant <{ i8, i32, [5 x i8], i8 }> <{ i8 1, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i32, [5 x i8], i8 }>, <{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1VV13TangentVectorV", i32 0, i32 1) to i64)) to i32), [5 x i8] c"Iego_", i8 0 }>, section "swift5_typeref", align 2
@"\01l__swift5_reflection_descriptor.1" = private constant { i32, i32, i32, i32, i32 } { i32 2, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.1", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.1", i32 0, i32 4) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.3 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.2, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.1" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.4" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.4", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.6 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.5, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.4" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.8" = private constant { i32, i32, i32, i32, i32 } { i32 2, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.8", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.8", i32 0, i32 4) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.10 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.9, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.8" to i8*) }, align 8
@"symbolic _____Iego_ 4main1UV13TangentVectorV" = linkonce_odr hidden constant <{ i8, i32, [5 x i8], i8 }> <{ i8 1, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i32, [5 x i8], i8 }>, <{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1UV13TangentVectorV", i32 0, i32 1) to i64)) to i32), [5 x i8] c"Iego_", i8 0 }>, section "swift5_typeref", align 2
@"\01l__swift5_reflection_descriptor.12" = private constant { i32, i32, i32, i32, i32 } { i32 2, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1UV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.12", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1UV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.12", i32 0, i32 4) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.14 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.13, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.12" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.15" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.15", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.17 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.16, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.15" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.19" = private constant { i32, i32, i32, i32, i32 } { i32 2, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.19", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.19", i32 0, i32 4) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.21 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.20, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.19" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.23" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.23", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.25 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.24, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.23" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.26" = private constant { i32, i32, i32, i32, i32 } { i32 2, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.26", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.26", i32 0, i32 4) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.28 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.27, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.26" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.29" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.29", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.31 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.30, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.29" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.33" = private constant { i32, i32, i32, i32, i32 } { i32 2, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.33", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.33", i32 0, i32 4) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.35 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.34, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.33" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.37" = private constant { i32, i32, i32, i32, i32 } { i32 2, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1UV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.37", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1UV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.37", i32 0, i32 4) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.39 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.38, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.37" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.40" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.40", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.42 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.41, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.40" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.44" = private constant { i32, i32, i32, i32, i32 } { i32 2, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.44", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.44", i32 0, i32 4) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.46 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.45, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.44" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.48" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.48", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.50 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.49, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.48" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.52" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.52", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.54 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.53, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.52" to i8*) }, align 8
@"$s4main1TV13TangentVectorVAEs18AdditiveArithmeticAAWL" = linkonce_odr hidden local_unnamed_addr global i8** null, align 8
@"associated conformance 4main1TV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmetic" = linkonce_odr hidden constant <{ i8, i8, i32, i8 }> <{ i8 -1, i8 7, i32 trunc (i64 sub (i64 ptrtoint (i8** (%swift.type*, %swift.type*, i8**)* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmeticPWT" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1TV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmetic", i32 0, i32 2) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"$s4main1TV13TangentVectorVAE16_Differentiation14DifferentiableAAWL" = linkonce_odr hidden local_unnamed_addr global i8** null, align 8
@"associated conformance 4main1TV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AfG" = linkonce_odr hidden constant <{ i8, i8, i32, i8 }> <{ i8 -1, i8 7, i32 trunc (i64 sub (i64 ptrtoint (i8** (%swift.type*, %swift.type*, i8**)* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AHWT" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1TV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AfG", i32 0, i32 2) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"symbolic _____ 4main1TV13TangentVectorV" = linkonce_odr hidden constant <{ i8, i32, i8 }> <{ i8 1, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i32, i8 }>, <{ i8, i32, i8 }>* @"symbolic _____ 4main1TV13TangentVectorV", i32 0, i32 1) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"symbolic $s16_Differentiation14DifferentiableP" = linkonce_odr hidden constant <{ [37 x i8], i8 }> <{ [37 x i8] c"$s16_Differentiation14DifferentiableP", i8 0 }>, section "swift5_typeref", align 2
@0 = private constant [14 x i8] c"TangentVector\00", section "swift5_reflstr"
@"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMA" = internal constant { i32, i32, i32, i32, i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1TV13TangentVectorV" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMA" to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ [37 x i8], i8 }>* @"symbolic $s16_Differentiation14DifferentiableP" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMA", i32 0, i32 1) to i64)) to i32), i32 1, i32 8, i32 trunc (i64 sub (i64 ptrtoint ([14 x i8]* @0 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMA", i32 0, i32 4) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1TV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMA", i32 0, i32 5) to i64)) to i32) }, section "swift5_assocty", align 4
@"$s16_Differentiation14DifferentiableMp" = external global %swift.protocol, align 4
@"got.$s16_Differentiation14DifferentiableMp" = private unnamed_addr constant %swift.protocol* @"$s16_Differentiation14DifferentiableMp"
@"$s16_Differentiation14DifferentiableP13TangentVectorAC_s18AdditiveArithmeticTn" = external global %swift.protocol_requirement, align 4
@"got.$s16_Differentiation14DifferentiableP13TangentVectorAC_s18AdditiveArithmeticTn" = private unnamed_addr constant %swift.protocol_requirement* @"$s16_Differentiation14DifferentiableP13TangentVectorAC_s18AdditiveArithmeticTn"
@"$s16_Differentiation14DifferentiableP13TangentVectorAC_AaBTn" = external global %swift.protocol_requirement, align 4
@"got.$s16_Differentiation14DifferentiableP13TangentVectorAC_AaBTn" = private unnamed_addr constant %swift.protocol_requirement* @"$s16_Differentiation14DifferentiableP13TangentVectorAC_AaBTn"
@"$s13TangentVector16_Differentiation14DifferentiablePTl" = external global %swift.protocol_requirement, align 4
@"got.$s13TangentVector16_Differentiation14DifferentiablePTl" = private unnamed_addr constant %swift.protocol_requirement* @"$s13TangentVector16_Differentiation14DifferentiablePTl"
@"$s16_Differentiation14DifferentiableP4move5alongy13TangentVectorQz_tFTq" = external global %swift.method_descriptor, align 4
@"got.$s16_Differentiation14DifferentiableP4move5alongy13TangentVectorQz_tFTq" = private unnamed_addr constant %swift.method_descriptor* @"$s16_Differentiation14DifferentiableP4move5alongy13TangentVectorQz_tFTq"
@"$s16_Differentiation14DifferentiableP28zeroTangentVectorInitializer0dE0QzycvgTq" = external global %swift.method_descriptor, align 4
@"got.$s16_Differentiation14DifferentiableP28zeroTangentVectorInitializer0dE0QzycvgTq" = private unnamed_addr constant %swift.method_descriptor* @"$s16_Differentiation14DifferentiableP28zeroTangentVectorInitializer0dE0QzycvgTq"
@"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMcMK" = internal global [16 x i8*] zeroinitializer
@"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc" = hidden constant { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 } { i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol** @"got.$s16_Differentiation14DifferentiableMp" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc" to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 1) to i64)) to i32), i32 0, i32 196608, i32 5, i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s16_Differentiation14DifferentiableP13TangentVectorAC_s18AdditiveArithmeticTn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 5) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr (i8, i8* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1TV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmetic", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 6) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s16_Differentiation14DifferentiableP13TangentVectorAC_AaBTn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 7) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr (i8, i8* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1TV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AfG", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 8) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s13TangentVector16_Differentiation14DifferentiablePTl" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 9) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr inbounds (i8, i8* getelementptr inbounds (<{ i8, i32, i8 }>, <{ i8, i32, i8 }>* @"symbolic _____ 4main1TV13TangentVectorV", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 10) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$s16_Differentiation14DifferentiableP4move5alongy13TangentVectorQz_tFTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 11) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1TV13TangentVectorV*, %T4main1TV13TangentVectorV*, %swift.type*, i8**)* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAafGP4move5alongyADQz_tFTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 12) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$s16_Differentiation14DifferentiableP28zeroTangentVectorInitializer0dE0QzycvgTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 13) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint ({ i8*, %swift.refcounted* } (%T4main1TV13TangentVectorV*, %swift.type*, i8**)* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAafGP04zerobC11InitializerADQzycvgTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 14) to i64)) to i32), i16 0, i16 1, i32 0, i32 trunc (i64 sub (i64 ptrtoint ([16 x i8*]* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMcMK" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 18) to i64)) to i32) }, section ".rodata", align 4
@"$s4main1TV13TangentVectorVAESQAAWL" = linkonce_odr hidden local_unnamed_addr global i8** null, align 8
@"associated conformance 4main1TV13TangentVectorVs18AdditiveArithmeticAASQ" = linkonce_odr hidden constant <{ i8, i8, i32, i8 }> <{ i8 -1, i8 7, i32 trunc (i64 sub (i64 ptrtoint (i8** (%swift.type*, %swift.type*, i8**)* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAASQWb" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1TV13TangentVectorVs18AdditiveArithmeticAASQ", i32 0, i32 2) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"$ss18AdditiveArithmeticMp" = external global %swift.protocol, align 4
@"got.$ss18AdditiveArithmeticMp" = private unnamed_addr constant %swift.protocol* @"$ss18AdditiveArithmeticMp"
@"$ss18AdditiveArithmeticPSQTb" = external global %swift.protocol_requirement, align 4
@"got.$ss18AdditiveArithmeticPSQTb" = private unnamed_addr constant %swift.protocol_requirement* @"$ss18AdditiveArithmeticPSQTb"
@"$ss18AdditiveArithmeticP4zeroxvgZTq" = external global %swift.method_descriptor, align 4
@"got.$ss18AdditiveArithmeticP4zeroxvgZTq" = private unnamed_addr constant %swift.method_descriptor* @"$ss18AdditiveArithmeticP4zeroxvgZTq"
@"$ss18AdditiveArithmeticP1poiyxx_xtFZTq" = external global %swift.method_descriptor, align 4
@"got.$ss18AdditiveArithmeticP1poiyxx_xtFZTq" = private unnamed_addr constant %swift.method_descriptor* @"$ss18AdditiveArithmeticP1poiyxx_xtFZTq"
@"$ss18AdditiveArithmeticP2peoiyyxz_xtFZTq" = external global %swift.method_descriptor, align 4
@"got.$ss18AdditiveArithmeticP2peoiyyxz_xtFZTq" = private unnamed_addr constant %swift.method_descriptor* @"$ss18AdditiveArithmeticP2peoiyyxz_xtFZTq"
@"$ss18AdditiveArithmeticP1soiyxx_xtFZTq" = external global %swift.method_descriptor, align 4
@"got.$ss18AdditiveArithmeticP1soiyxx_xtFZTq" = private unnamed_addr constant %swift.method_descriptor* @"$ss18AdditiveArithmeticP1soiyxx_xtFZTq"
@"$ss18AdditiveArithmeticP2seoiyyxz_xtFZTq" = external global %swift.method_descriptor, align 4
@"got.$ss18AdditiveArithmeticP2seoiyyxz_xtFZTq" = private unnamed_addr constant %swift.method_descriptor* @"$ss18AdditiveArithmeticP2seoiyyxz_xtFZTq"
@"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMcMK" = internal global [16 x i8*] zeroinitializer
@"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc" = hidden constant { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 } { i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol** @"got.$ss18AdditiveArithmeticMp" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc" to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 1) to i64)) to i32), i32 0, i32 196608, i32 6, i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$ss18AdditiveArithmeticPSQTb" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 5) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr (i8, i8* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1TV13TangentVectorVs18AdditiveArithmeticAASQ", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 6) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$ss18AdditiveArithmeticP4zeroxvgZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 7) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1TV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP4zeroxvgZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 8) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$ss18AdditiveArithmeticP1poiyxx_xtFZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 9) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1TV13TangentVectorV*, %T4main1TV13TangentVectorV*, %T4main1TV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 10) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$ss18AdditiveArithmeticP2peoiyyxz_xtFZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 11) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1TV13TangentVectorV*, %T4main1TV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP2peoiyyxz_xtFZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 12) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$ss18AdditiveArithmeticP1soiyxx_xtFZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 13) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1TV13TangentVectorV*, %T4main1TV13TangentVectorV*, %T4main1TV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP1soiyxx_xtFZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 14) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$ss18AdditiveArithmeticP2seoiyyxz_xtFZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 15) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1TV13TangentVectorV*, %T4main1TV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP2seoiyyxz_xtFZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 16) to i64)) to i32), i16 0, i16 1, i32 0, i32 trunc (i64 sub (i64 ptrtoint ([16 x i8*]* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMcMK" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 20) to i64)) to i32) }, section ".rodata", align 4
@"$sSQMp" = external global %swift.protocol, align 4
@"got.$sSQMp" = private unnamed_addr constant %swift.protocol* @"$sSQMp"
@"$sSQ2eeoiySbx_xtFZTq" = external global %swift.method_descriptor, align 4
@"got.$sSQ2eeoiySbx_xtFZTq" = private unnamed_addr constant %swift.method_descriptor* @"$sSQ2eeoiySbx_xtFZTq"
@"$s4main1TV13TangentVectorVSQAAMcMK" = internal global [16 x i8*] zeroinitializer
@"$s4main1TV13TangentVectorVSQAAMc" = hidden constant { i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 } { i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol** @"got.$sSQMp" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVSQAAMc" to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVSQAAMc", i32 0, i32 1) to i64)) to i32), i32 0, i32 196608, i32 1, i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$sSQ2eeoiySbx_xtFZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVSQAAMc", i32 0, i32 5) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i1 (%T4main1TV13TangentVectorV*, %T4main1TV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1TV13TangentVectorVSQAASQ2eeoiySbx_xtFZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVSQAAMc", i32 0, i32 6) to i64)) to i32), i16 0, i16 1, i32 0, i32 trunc (i64 sub (i64 ptrtoint ([16 x i8*]* @"$s4main1TV13TangentVectorVSQAAMcMK" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVSQAAMc", i32 0, i32 10) to i64)) to i32) }, section ".rodata", align 4
@"associated conformance 4main1TV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmetic" = linkonce_odr hidden constant <{ i8, i8, i32, i8 }> <{ i8 -1, i8 7, i32 trunc (i64 sub (i64 ptrtoint (i8** (%swift.type*, %swift.type*, i8**)* @"$s4main1TV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmeticPWT" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1TV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmetic", i32 0, i32 2) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"associated conformance 4main1TV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AdE" = linkonce_odr hidden constant <{ i8, i8, i32, i8 }> <{ i8 -1, i8 7, i32 trunc (i64 sub (i64 ptrtoint (i8** (%swift.type*, %swift.type*, i8**)* @"$s4main1TV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AGWT" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1TV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AdE", i32 0, i32 2) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"symbolic _____ 4main1TV" = linkonce_odr hidden constant <{ i8, i32, i8 }> <{ i8 1, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i32, i8 }>, <{ i8, i32, i8 }>* @"symbolic _____ 4main1TV", i32 0, i32 1) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"$s4main1TV16_Differentiation14DifferentiableAAMA" = internal constant { i32, i32, i32, i32, i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1TV" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMA" to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ [37 x i8], i8 }>* @"symbolic $s16_Differentiation14DifferentiableP" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMA", i32 0, i32 1) to i64)) to i32), i32 1, i32 8, i32 trunc (i64 sub (i64 ptrtoint ([14 x i8]* @0 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMA", i32 0, i32 4) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1TV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMA", i32 0, i32 5) to i64)) to i32) }, section "swift5_assocty", align 4
@"$s4main1TV16_Differentiation14DifferentiableAAMcMK" = internal global [16 x i8*] zeroinitializer
@"$s4main1TV16_Differentiation14DifferentiableAAMc" = hidden constant { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 } { i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol** @"got.$s16_Differentiation14DifferentiableMp" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMc" to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMc", i32 0, i32 1) to i64)) to i32), i32 0, i32 196608, i32 5, i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s16_Differentiation14DifferentiableP13TangentVectorAC_s18AdditiveArithmeticTn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMc", i32 0, i32 5) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr (i8, i8* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1TV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmetic", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMc", i32 0, i32 6) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s16_Differentiation14DifferentiableP13TangentVectorAC_AaBTn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMc", i32 0, i32 7) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr (i8, i8* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1TV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AdE", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMc", i32 0, i32 8) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s13TangentVector16_Differentiation14DifferentiablePTl" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMc", i32 0, i32 9) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr inbounds (i8, i8* getelementptr inbounds (<{ i8, i32, i8 }>, <{ i8, i32, i8 }>* @"symbolic _____ 4main1TV13TangentVectorV", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMc", i32 0, i32 10) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$s16_Differentiation14DifferentiableP4move5alongy13TangentVectorQz_tFTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMc", i32 0, i32 11) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1TV13TangentVectorV*, %T4main1TV*, %swift.type*, i8**)* @"$s4main1TV16_Differentiation14DifferentiableAadEP4move5alongy13TangentVectorQz_tFTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMc", i32 0, i32 12) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$s16_Differentiation14DifferentiableP28zeroTangentVectorInitializer0dE0QzycvgTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMc", i32 0, i32 13) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint ({ i8*, %swift.refcounted* } (%T4main1TV*, %swift.type*, i8**)* @"$s4main1TV16_Differentiation14DifferentiableAadEP28zeroTangentVectorInitializer0eF0QzycvgTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMc", i32 0, i32 14) to i64)) to i32), i16 0, i16 1, i32 0, i32 trunc (i64 sub (i64 ptrtoint ([16 x i8*]* @"$s4main1TV16_Differentiation14DifferentiableAAMcMK" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMc", i32 0, i32 18) to i64)) to i32) }, section ".rodata", align 4
@"$s4main1UV13TangentVectorVAEs18AdditiveArithmeticAAWL" = linkonce_odr hidden local_unnamed_addr global i8** null, align 8
@"associated conformance 4main1UV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmetic" = linkonce_odr hidden constant <{ i8, i8, i32, i8 }> <{ i8 -1, i8 7, i32 trunc (i64 sub (i64 ptrtoint (i8** (%swift.type*, %swift.type*, i8**)* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmeticPWT" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1UV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmetic", i32 0, i32 2) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"$s4main1UV13TangentVectorVAE16_Differentiation14DifferentiableAAWL" = linkonce_odr hidden local_unnamed_addr global i8** null, align 8
@"associated conformance 4main1UV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AfG" = linkonce_odr hidden constant <{ i8, i8, i32, i8 }> <{ i8 -1, i8 7, i32 trunc (i64 sub (i64 ptrtoint (i8** (%swift.type*, %swift.type*, i8**)* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AHWT" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1UV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AfG", i32 0, i32 2) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"symbolic _____ 4main1UV13TangentVectorV" = linkonce_odr hidden constant <{ i8, i32, i8 }> <{ i8 1, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i32, i8 }>, <{ i8, i32, i8 }>* @"symbolic _____ 4main1UV13TangentVectorV", i32 0, i32 1) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMA" = internal constant { i32, i32, i32, i32, i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1UV13TangentVectorV" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMA" to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ [37 x i8], i8 }>* @"symbolic $s16_Differentiation14DifferentiableP" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMA", i32 0, i32 1) to i64)) to i32), i32 1, i32 8, i32 trunc (i64 sub (i64 ptrtoint ([14 x i8]* @0 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMA", i32 0, i32 4) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1UV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMA", i32 0, i32 5) to i64)) to i32) }, section "swift5_assocty", align 4
@"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMcMK" = internal global [16 x i8*] zeroinitializer
@"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc" = hidden constant { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 } { i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol** @"got.$s16_Differentiation14DifferentiableMp" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc" to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 1) to i64)) to i32), i32 0, i32 196608, i32 5, i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s16_Differentiation14DifferentiableP13TangentVectorAC_s18AdditiveArithmeticTn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 5) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr (i8, i8* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1UV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmetic", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 6) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s16_Differentiation14DifferentiableP13TangentVectorAC_AaBTn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 7) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr (i8, i8* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1UV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AfG", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 8) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s13TangentVector16_Differentiation14DifferentiablePTl" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 9) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr inbounds (i8, i8* getelementptr inbounds (<{ i8, i32, i8 }>, <{ i8, i32, i8 }>* @"symbolic _____ 4main1UV13TangentVectorV", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 10) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$s16_Differentiation14DifferentiableP4move5alongy13TangentVectorQz_tFTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 11) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1UV13TangentVectorV*, %T4main1UV13TangentVectorV*, %swift.type*, i8**)* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAafGP4move5alongyADQz_tFTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 12) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$s16_Differentiation14DifferentiableP28zeroTangentVectorInitializer0dE0QzycvgTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 13) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint ({ i8*, %swift.refcounted* } (%T4main1UV13TangentVectorV*, %swift.type*, i8**)* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAafGP04zerobC11InitializerADQzycvgTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 14) to i64)) to i32), i16 0, i16 1, i32 0, i32 trunc (i64 sub (i64 ptrtoint ([16 x i8*]* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMcMK" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 18) to i64)) to i32) }, section ".rodata", align 4
@"$s4main1UV13TangentVectorVAESQAAWL" = linkonce_odr hidden local_unnamed_addr global i8** null, align 8
@"associated conformance 4main1UV13TangentVectorVs18AdditiveArithmeticAASQ" = linkonce_odr hidden constant <{ i8, i8, i32, i8 }> <{ i8 -1, i8 7, i32 trunc (i64 sub (i64 ptrtoint (i8** (%swift.type*, %swift.type*, i8**)* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAASQWb" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1UV13TangentVectorVs18AdditiveArithmeticAASQ", i32 0, i32 2) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMcMK" = internal global [16 x i8*] zeroinitializer
@"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc" = hidden constant { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 } { i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol** @"got.$ss18AdditiveArithmeticMp" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc" to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 1) to i64)) to i32), i32 0, i32 196608, i32 6, i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$ss18AdditiveArithmeticPSQTb" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 5) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr (i8, i8* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1UV13TangentVectorVs18AdditiveArithmeticAASQ", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 6) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$ss18AdditiveArithmeticP4zeroxvgZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 7) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1UV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP4zeroxvgZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 8) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$ss18AdditiveArithmeticP1poiyxx_xtFZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 9) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1UV13TangentVectorV*, %T4main1UV13TangentVectorV*, %T4main1UV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 10) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$ss18AdditiveArithmeticP2peoiyyxz_xtFZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 11) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1UV13TangentVectorV*, %T4main1UV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP2peoiyyxz_xtFZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 12) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$ss18AdditiveArithmeticP1soiyxx_xtFZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 13) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1UV13TangentVectorV*, %T4main1UV13TangentVectorV*, %T4main1UV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP1soiyxx_xtFZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 14) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$ss18AdditiveArithmeticP2seoiyyxz_xtFZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 15) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1UV13TangentVectorV*, %T4main1UV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP2seoiyyxz_xtFZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 16) to i64)) to i32), i16 0, i16 1, i32 0, i32 trunc (i64 sub (i64 ptrtoint ([16 x i8*]* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMcMK" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 20) to i64)) to i32) }, section ".rodata", align 4
@"$s4main1UV13TangentVectorVSQAAMcMK" = internal global [16 x i8*] zeroinitializer
@"$s4main1UV13TangentVectorVSQAAMc" = hidden constant { i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 } { i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol** @"got.$sSQMp" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVSQAAMc" to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVSQAAMc", i32 0, i32 1) to i64)) to i32), i32 0, i32 196608, i32 1, i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$sSQ2eeoiySbx_xtFZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVSQAAMc", i32 0, i32 5) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i1 (%T4main1UV13TangentVectorV*, %T4main1UV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1UV13TangentVectorVSQAASQ2eeoiySbx_xtFZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVSQAAMc", i32 0, i32 6) to i64)) to i32), i16 0, i16 1, i32 0, i32 trunc (i64 sub (i64 ptrtoint ([16 x i8*]* @"$s4main1UV13TangentVectorVSQAAMcMK" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVSQAAMc", i32 0, i32 10) to i64)) to i32) }, section ".rodata", align 4
@"associated conformance 4main1UV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmetic" = linkonce_odr hidden constant <{ i8, i8, i32, i8 }> <{ i8 -1, i8 7, i32 trunc (i64 sub (i64 ptrtoint (i8** (%swift.type*, %swift.type*, i8**)* @"$s4main1UV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmeticPWT" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1UV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmetic", i32 0, i32 2) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"associated conformance 4main1UV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AdE" = linkonce_odr hidden constant <{ i8, i8, i32, i8 }> <{ i8 -1, i8 7, i32 trunc (i64 sub (i64 ptrtoint (i8** (%swift.type*, %swift.type*, i8**)* @"$s4main1UV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AGWT" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1UV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AdE", i32 0, i32 2) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"symbolic _____ 4main1UV" = linkonce_odr hidden constant <{ i8, i32, i8 }> <{ i8 1, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i32, i8 }>, <{ i8, i32, i8 }>* @"symbolic _____ 4main1UV", i32 0, i32 1) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"$s4main1UV16_Differentiation14DifferentiableAAMA" = internal constant { i32, i32, i32, i32, i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1UV" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMA" to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ [37 x i8], i8 }>* @"symbolic $s16_Differentiation14DifferentiableP" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMA", i32 0, i32 1) to i64)) to i32), i32 1, i32 8, i32 trunc (i64 sub (i64 ptrtoint ([14 x i8]* @0 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMA", i32 0, i32 4) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1UV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMA", i32 0, i32 5) to i64)) to i32) }, section "swift5_assocty", align 4
@"$s4main1UV16_Differentiation14DifferentiableAAMcMK" = internal global [16 x i8*] zeroinitializer
@"$s4main1UV16_Differentiation14DifferentiableAAMc" = hidden constant { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 } { i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol** @"got.$s16_Differentiation14DifferentiableMp" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMc" to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMc", i32 0, i32 1) to i64)) to i32), i32 0, i32 196608, i32 5, i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s16_Differentiation14DifferentiableP13TangentVectorAC_s18AdditiveArithmeticTn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMc", i32 0, i32 5) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr (i8, i8* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1UV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmetic", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMc", i32 0, i32 6) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s16_Differentiation14DifferentiableP13TangentVectorAC_AaBTn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMc", i32 0, i32 7) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr (i8, i8* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1UV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AdE", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMc", i32 0, i32 8) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s13TangentVector16_Differentiation14DifferentiablePTl" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMc", i32 0, i32 9) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr inbounds (i8, i8* getelementptr inbounds (<{ i8, i32, i8 }>, <{ i8, i32, i8 }>* @"symbolic _____ 4main1UV13TangentVectorV", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMc", i32 0, i32 10) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$s16_Differentiation14DifferentiableP4move5alongy13TangentVectorQz_tFTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMc", i32 0, i32 11) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1UV13TangentVectorV*, %T4main1UV*, %swift.type*, i8**)* @"$s4main1UV16_Differentiation14DifferentiableAadEP4move5alongy13TangentVectorQz_tFTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMc", i32 0, i32 12) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$s16_Differentiation14DifferentiableP28zeroTangentVectorInitializer0dE0QzycvgTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMc", i32 0, i32 13) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint ({ i8*, %swift.refcounted* } (%T4main1UV*, %swift.type*, i8**)* @"$s4main1UV16_Differentiation14DifferentiableAadEP28zeroTangentVectorInitializer0eF0QzycvgTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMc", i32 0, i32 14) to i64)) to i32), i16 0, i16 1, i32 0, i32 trunc (i64 sub (i64 ptrtoint ([16 x i8*]* @"$s4main1UV16_Differentiation14DifferentiableAAMcMK" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMc", i32 0, i32 18) to i64)) to i32) }, section ".rodata", align 4
@"$s4main1VV13TangentVectorVAEs18AdditiveArithmeticAAWL" = linkonce_odr hidden local_unnamed_addr global i8** null, align 8
@"associated conformance 4main1VV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmetic" = linkonce_odr hidden constant <{ i8, i8, i32, i8 }> <{ i8 -1, i8 7, i32 trunc (i64 sub (i64 ptrtoint (i8** (%swift.type*, %swift.type*, i8**)* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmeticPWT" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1VV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmetic", i32 0, i32 2) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"$s4main1VV13TangentVectorVAE16_Differentiation14DifferentiableAAWL" = linkonce_odr hidden local_unnamed_addr global i8** null, align 8
@"associated conformance 4main1VV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AfG" = linkonce_odr hidden constant <{ i8, i8, i32, i8 }> <{ i8 -1, i8 7, i32 trunc (i64 sub (i64 ptrtoint (i8** (%swift.type*, %swift.type*, i8**)* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AHWT" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1VV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AfG", i32 0, i32 2) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"symbolic _____ 4main1VV13TangentVectorV" = linkonce_odr hidden constant <{ i8, i32, i8 }> <{ i8 1, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i32, i8 }>, <{ i8, i32, i8 }>* @"symbolic _____ 4main1VV13TangentVectorV", i32 0, i32 1) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMA" = internal constant { i32, i32, i32, i32, i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1VV13TangentVectorV" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMA" to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ [37 x i8], i8 }>* @"symbolic $s16_Differentiation14DifferentiableP" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMA", i32 0, i32 1) to i64)) to i32), i32 1, i32 8, i32 trunc (i64 sub (i64 ptrtoint ([14 x i8]* @0 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMA", i32 0, i32 4) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMA", i32 0, i32 5) to i64)) to i32) }, section "swift5_assocty", align 4
@"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMcMK" = internal global [16 x i8*] zeroinitializer
@"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc" = hidden constant { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 } { i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol** @"got.$s16_Differentiation14DifferentiableMp" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc" to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 1) to i64)) to i32), i32 0, i32 196608, i32 5, i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s16_Differentiation14DifferentiableP13TangentVectorAC_s18AdditiveArithmeticTn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 5) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr (i8, i8* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1VV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmetic", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 6) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s16_Differentiation14DifferentiableP13TangentVectorAC_AaBTn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 7) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr (i8, i8* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1VV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AfG", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 8) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s13TangentVector16_Differentiation14DifferentiablePTl" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 9) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr inbounds (i8, i8* getelementptr inbounds (<{ i8, i32, i8 }>, <{ i8, i32, i8 }>* @"symbolic _____ 4main1VV13TangentVectorV", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 10) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$s16_Differentiation14DifferentiableP4move5alongy13TangentVectorQz_tFTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 11) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1VV13TangentVectorV*, %T4main1VV13TangentVectorV*, %swift.type*, i8**)* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAafGP4move5alongyADQz_tFTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 12) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$s16_Differentiation14DifferentiableP28zeroTangentVectorInitializer0dE0QzycvgTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 13) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint ({ i8*, %swift.refcounted* } (%T4main1VV13TangentVectorV*, %swift.type*, i8**)* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAafGP04zerobC11InitializerADQzycvgTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 14) to i64)) to i32), i16 0, i16 1, i32 0, i32 trunc (i64 sub (i64 ptrtoint ([16 x i8*]* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMcMK" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc", i32 0, i32 18) to i64)) to i32) }, section ".rodata", align 4
@"$s4main1VV13TangentVectorVAESQAAWL" = linkonce_odr hidden local_unnamed_addr global i8** null, align 8
@"associated conformance 4main1VV13TangentVectorVs18AdditiveArithmeticAASQ" = linkonce_odr hidden constant <{ i8, i8, i32, i8 }> <{ i8 -1, i8 7, i32 trunc (i64 sub (i64 ptrtoint (i8** (%swift.type*, %swift.type*, i8**)* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAASQWb" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1VV13TangentVectorVs18AdditiveArithmeticAASQ", i32 0, i32 2) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMcMK" = internal global [16 x i8*] zeroinitializer
@"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc" = hidden constant { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 } { i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol** @"got.$ss18AdditiveArithmeticMp" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc" to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 1) to i64)) to i32), i32 0, i32 196608, i32 6, i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$ss18AdditiveArithmeticPSQTb" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 5) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr (i8, i8* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1VV13TangentVectorVs18AdditiveArithmeticAASQ", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 6) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$ss18AdditiveArithmeticP4zeroxvgZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 7) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1VV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP4zeroxvgZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 8) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$ss18AdditiveArithmeticP1poiyxx_xtFZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 9) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1VV13TangentVectorV*, %T4main1VV13TangentVectorV*, %T4main1VV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 10) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$ss18AdditiveArithmeticP2peoiyyxz_xtFZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 11) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1VV13TangentVectorV*, %T4main1VV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP2peoiyyxz_xtFZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 12) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$ss18AdditiveArithmeticP1soiyxx_xtFZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 13) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1VV13TangentVectorV*, %T4main1VV13TangentVectorV*, %T4main1VV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP1soiyxx_xtFZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 14) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$ss18AdditiveArithmeticP2seoiyyxz_xtFZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 15) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1VV13TangentVectorV*, %T4main1VV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP2seoiyyxz_xtFZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 16) to i64)) to i32), i16 0, i16 1, i32 0, i32 trunc (i64 sub (i64 ptrtoint ([16 x i8*]* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMcMK" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc", i32 0, i32 20) to i64)) to i32) }, section ".rodata", align 4
@"$s4main1VV13TangentVectorVSQAAMcMK" = internal global [16 x i8*] zeroinitializer
@"$s4main1VV13TangentVectorVSQAAMc" = hidden constant { i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 } { i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol** @"got.$sSQMp" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVSQAAMc" to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVSQAAMc", i32 0, i32 1) to i64)) to i32), i32 0, i32 196608, i32 1, i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$sSQ2eeoiySbx_xtFZTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVSQAAMc", i32 0, i32 5) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i1 (%T4main1VV13TangentVectorV*, %T4main1VV13TangentVectorV*, %swift.type*, %swift.type*, i8**)* @"$s4main1VV13TangentVectorVSQAASQ2eeoiySbx_xtFZTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVSQAAMc", i32 0, i32 6) to i64)) to i32), i16 0, i16 1, i32 0, i32 trunc (i64 sub (i64 ptrtoint ([16 x i8*]* @"$s4main1VV13TangentVectorVSQAAMcMK" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVSQAAMc", i32 0, i32 10) to i64)) to i32) }, section ".rodata", align 4
@"associated conformance 4main1VV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmetic" = linkonce_odr hidden constant <{ i8, i8, i32, i8 }> <{ i8 -1, i8 7, i32 trunc (i64 sub (i64 ptrtoint (i8** (%swift.type*, %swift.type*, i8**)* @"$s4main1VV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmeticPWT" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1VV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmetic", i32 0, i32 2) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"associated conformance 4main1VV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AdE" = linkonce_odr hidden constant <{ i8, i8, i32, i8 }> <{ i8 -1, i8 7, i32 trunc (i64 sub (i64 ptrtoint (i8** (%swift.type*, %swift.type*, i8**)* @"$s4main1VV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AGWT" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1VV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AdE", i32 0, i32 2) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"symbolic _____ 4main1VV" = linkonce_odr hidden constant <{ i8, i32, i8 }> <{ i8 1, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i32, i8 }>, <{ i8, i32, i8 }>* @"symbolic _____ 4main1VV", i32 0, i32 1) to i64)) to i32), i8 0 }>, section "swift5_typeref", align 2
@"$s4main1VV16_Differentiation14DifferentiableAAMA" = internal constant { i32, i32, i32, i32, i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1VV" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMA" to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ [37 x i8], i8 }>* @"symbolic $s16_Differentiation14DifferentiableP" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMA", i32 0, i32 1) to i64)) to i32), i32 1, i32 8, i32 trunc (i64 sub (i64 ptrtoint ([14 x i8]* @0 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMA", i32 0, i32 4) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMA", i32 0, i32 5) to i64)) to i32) }, section "swift5_assocty", align 4
@"$s4main1VV16_Differentiation14DifferentiableAAMcMK" = internal global [16 x i8*] zeroinitializer
@"$s4main1VV16_Differentiation14DifferentiableAAMc" = hidden constant { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 } { i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol** @"got.$s16_Differentiation14DifferentiableMp" to i64), i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMc" to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMc", i32 0, i32 1) to i64)) to i32), i32 0, i32 196608, i32 5, i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s16_Differentiation14DifferentiableP13TangentVectorAC_s18AdditiveArithmeticTn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMc", i32 0, i32 5) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr (i8, i8* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1VV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmetic", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMc", i32 0, i32 6) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s16_Differentiation14DifferentiableP13TangentVectorAC_AaBTn" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMc", i32 0, i32 7) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr (i8, i8* getelementptr inbounds (<{ i8, i8, i32, i8 }>, <{ i8, i8, i32, i8 }>* @"associated conformance 4main1VV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AdE", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMc", i32 0, i32 8) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_requirement** @"got.$s13TangentVector16_Differentiation14DifferentiablePTl" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMc", i32 0, i32 9) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (i8* getelementptr inbounds (i8, i8* getelementptr inbounds (<{ i8, i32, i8 }>, <{ i8, i32, i8 }>* @"symbolic _____ 4main1VV13TangentVectorV", i32 0, i32 0), i64 1) to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMc", i32 0, i32 10) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$s16_Differentiation14DifferentiableP4move5alongy13TangentVectorQz_tFTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMc", i32 0, i32 11) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint (void (%T4main1VV13TangentVectorV*, %T4main1VV*, %swift.type*, i8**)* @"$s4main1VV16_Differentiation14DifferentiableAadEP4move5alongy13TangentVectorQz_tFTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMc", i32 0, i32 12) to i64)) to i32), i32 add (i32 trunc (i64 sub (i64 ptrtoint (%swift.method_descriptor** @"got.$s16_Differentiation14DifferentiableP28zeroTangentVectorInitializer0dE0QzycvgTq" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMc", i32 0, i32 13) to i64)) to i32), i32 1), i32 trunc (i64 sub (i64 ptrtoint ({ i8*, %swift.refcounted* } (%T4main1VV*, %swift.type*, i8**)* @"$s4main1VV16_Differentiation14DifferentiableAadEP28zeroTangentVectorInitializer0eF0QzycvgTW" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMc", i32 0, i32 14) to i64)) to i32), i16 0, i16 1, i32 0, i32 trunc (i64 sub (i64 ptrtoint ([16 x i8*]* @"$s4main1VV16_Differentiation14DifferentiableAAMcMK" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }, { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMc", i32 0, i32 18) to i64)) to i32) }, section ".rodata", align 4
@"$s4main1TVWV" = internal constant %swift.vwtable { i8* bitcast (%swift.opaque* ([24 x i8]*, [24 x i8]*, %swift.type*)* @"$s4main1TVwCP" to i8*), i8* bitcast (void (%swift.opaque*, %swift.type*)* @"$s4main1TVwxx" to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1TVwcp" to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1TVwca" to i8*), i8* bitcast (i8* (i8*, i8*, %swift.type*)* @__swift_memcpy57_8 to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1TVwta" to i8*), i8* bitcast (i32 (%swift.opaque*, i32, %swift.type*)* @"$s4main1TVwet" to i8*), i8* bitcast (void (%swift.opaque*, i32, i32, %swift.type*)* @"$s4main1TVwst" to i8*), i64 57, i64 64, i32 196615, i32 4096 }, align 8
@1 = private constant [5 x i8] c"main\00"
@"$s4mainMXM" = linkonce_odr hidden constant <{ i32, i32, i32 }> <{ i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint ([5 x i8]* @1 to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32 }>, <{ i32, i32, i32 }>* @"$s4mainMXM", i32 0, i32 2) to i64)) to i32) }>, section ".rodata", align 4
@2 = private constant [2 x i8] c"T\00"
@"$s4main1TVMn" = hidden constant <{ i32, i32, i32, i32, i32, i32, i32 }> <{ i32 81, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32 }>* @"$s4mainMXM" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TVMn", i32 0, i32 1) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([2 x i8]* @2 to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TVMn", i32 0, i32 2) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (%swift.metadata_response (i64)* @"$s4main1TVMa" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TVMn", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1TVMF" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TVMn", i32 0, i32 4) to i64)) to i32), i32 2, i32 2 }>, section ".rodata", align 4
@"$s4main1TVMf" = internal constant <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }> <{ i8** getelementptr inbounds (%swift.vwtable, %swift.vwtable* @"$s4main1TVWV", i32 0, i32 0), i64 512, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TVMn", i32 0, i32 32 }>, align 8
@3 = private constant [3 x i8] c"u1\00", section "swift5_reflstr"
@4 = private constant [3 x i8] c"u2\00", section "swift5_reflstr"
@"$s4main1TVMF" = internal constant { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1TV" to i64), i64 ptrtoint ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1TVMF" to i64)) to i32), i32 0, i16 0, i16 12, i32 2, i32 2, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1UV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1TVMF", i32 0, i32 6) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([3 x i8]* @3 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1TVMF", i32 0, i32 7) to i64)) to i32), i32 2, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1UV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1TVMF", i32 0, i32 9) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([3 x i8]* @4 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1TVMF", i32 0, i32 10) to i64)) to i32) }, section "swift5_fieldmd", align 4
@"$s4main1TV13TangentVectorVWV" = internal constant %swift.vwtable { i8* bitcast (%swift.opaque* ([24 x i8]*, [24 x i8]*, %swift.type*)* @"$s4main1TV13TangentVectorVwCP" to i8*), i8* bitcast (void (%swift.opaque*, %swift.type*)* @"$s4main1TV13TangentVectorVwxx" to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1TV13TangentVectorVwcp" to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1TV13TangentVectorVwca" to i8*), i8* bitcast (i8* (i8*, i8*, %swift.type*)* @__swift_memcpy57_8 to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1TV13TangentVectorVwta" to i8*), i8* bitcast (i32 (%swift.opaque*, i32, %swift.type*)* @"$s4main1TV13TangentVectorVwet" to i8*), i8* bitcast (void (%swift.opaque*, i32, i32, %swift.type*)* @"$s4main1TV13TangentVectorVwst" to i8*), i64 57, i64 64, i32 196615, i32 4096 }, align 8
@5 = private constant [14 x i8] c"TangentVector\00"
@"$s4main1TV13TangentVectorVMn" = hidden constant <{ i32, i32, i32, i32, i32, i32, i32 }> <{ i32 81, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TV13TangentVectorVMn", i32 0, i32 1) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([14 x i8]* @5 to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TV13TangentVectorVMn", i32 0, i32 2) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (%swift.metadata_response (i64)* @"$s4main1TV13TangentVectorVMa" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TV13TangentVectorVMn", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1TV13TangentVectorVMF" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TV13TangentVectorVMn", i32 0, i32 4) to i64)) to i32), i32 2, i32 2 }>, section ".rodata", align 4
@"$s4main1TV13TangentVectorVMf" = internal constant <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }> <{ i8** getelementptr inbounds (%swift.vwtable, %swift.vwtable* @"$s4main1TV13TangentVectorVWV", i32 0, i32 0), i64 512, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TV13TangentVectorVMn", i32 0, i32 32 }>, align 8
@"$s4main1TV13TangentVectorVMF" = internal constant { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1TV13TangentVectorV" to i64), i64 ptrtoint ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1TV13TangentVectorVMF" to i64)) to i32), i32 0, i16 0, i16 12, i32 2, i32 2, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1UV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1TV13TangentVectorVMF", i32 0, i32 6) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([3 x i8]* @3 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1TV13TangentVectorVMF", i32 0, i32 7) to i64)) to i32), i32 2, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1UV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1TV13TangentVectorVMF", i32 0, i32 9) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([3 x i8]* @4 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1TV13TangentVectorVMF", i32 0, i32 10) to i64)) to i32) }, section "swift5_fieldmd", align 4
@"$s4main1UVWV" = internal constant %swift.vwtable { i8* bitcast (%swift.opaque* ([24 x i8]*, [24 x i8]*, %swift.type*)* @"$s4main1UVwCP" to i8*), i8* bitcast (void (%swift.opaque*, %swift.type*)* @"$s4main1UVwxx" to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1UVwcp" to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1UVwca" to i8*), i8* bitcast (i8* (i8*, i8*, %swift.type*)* @__swift_memcpy25_8 to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1UVwta" to i8*), i8* bitcast (i32 (%swift.opaque*, i32, %swift.type*)* @"$s4main1UVwet" to i8*), i8* bitcast (void (%swift.opaque*, i32, i32, %swift.type*)* @"$s4main1UVwst" to i8*), i64 25, i64 32, i32 196615, i32 4096 }, align 8
@6 = private constant [2 x i8] c"U\00"
@"$s4main1UVMn" = hidden constant <{ i32, i32, i32, i32, i32, i32, i32 }> <{ i32 81, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32 }>* @"$s4mainMXM" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UVMn", i32 0, i32 1) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([2 x i8]* @6 to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UVMn", i32 0, i32 2) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (%swift.metadata_response (i64)* @"$s4main1UVMa" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UVMn", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1UVMF" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UVMn", i32 0, i32 4) to i64)) to i32), i32 2, i32 2 }>, section ".rodata", align 4
@"$s4main1UVMf" = internal constant <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }> <{ i8** getelementptr inbounds (%swift.vwtable, %swift.vwtable* @"$s4main1UVWV", i32 0, i32 0), i64 512, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UVMn", i32 0, i32 16 }>, align 8
@"symbolic _____ySfG 1M1SV" = linkonce_odr hidden constant <{ i8, i32, [4 x i8], i8 }> <{ i8 2, i32 trunc (i64 sub (i64 ptrtoint (%swift.type_descriptor** @"got.$s1M1SVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i32, [4 x i8], i8 }>, <{ i8, i32, [4 x i8], i8 }>* @"symbolic _____ySfG 1M1SV", i32 0, i32 1) to i64)) to i32), [4 x i8] c"ySfG", i8 0 }>, section "swift5_typeref", align 2
@7 = private constant [2 x i8] c"s\00", section "swift5_reflstr"
@8 = private constant [2 x i8] c"v\00", section "swift5_reflstr"
@"$s4main1UVMF" = internal constant { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1UV" to i64), i64 ptrtoint ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1UVMF" to i64)) to i32), i32 0, i16 0, i16 12, i32 2, i32 2, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [4 x i8], i8 }>* @"symbolic _____ySfG 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1UVMF", i32 0, i32 6) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([2 x i8]* @7 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1UVMF", i32 0, i32 7) to i64)) to i32), i32 2, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1VV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1UVMF", i32 0, i32 9) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([2 x i8]* @8 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1UVMF", i32 0, i32 10) to i64)) to i32) }, section "swift5_fieldmd", align 4
@"$s4main1UV13TangentVectorVWV" = internal constant %swift.vwtable { i8* bitcast (%swift.opaque* ([24 x i8]*, [24 x i8]*, %swift.type*)* @"$s4main1UV13TangentVectorVwCP" to i8*), i8* bitcast (void (%swift.opaque*, %swift.type*)* @"$s4main1UV13TangentVectorVwxx" to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1UV13TangentVectorVwcp" to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1UV13TangentVectorVwca" to i8*), i8* bitcast (i8* (i8*, i8*, %swift.type*)* @__swift_memcpy25_8 to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1UV13TangentVectorVwta" to i8*), i8* bitcast (i32 (%swift.opaque*, i32, %swift.type*)* @"$s4main1UV13TangentVectorVwet" to i8*), i8* bitcast (void (%swift.opaque*, i32, i32, %swift.type*)* @"$s4main1UV13TangentVectorVwst" to i8*), i64 25, i64 32, i32 196615, i32 4096 }, align 8
@"$s4main1UV13TangentVectorVMn" = hidden constant <{ i32, i32, i32, i32, i32, i32, i32 }> <{ i32 81, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UV13TangentVectorVMn", i32 0, i32 1) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([14 x i8]* @5 to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UV13TangentVectorVMn", i32 0, i32 2) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (%swift.metadata_response (i64)* @"$s4main1UV13TangentVectorVMa" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UV13TangentVectorVMn", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1UV13TangentVectorVMF" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UV13TangentVectorVMn", i32 0, i32 4) to i64)) to i32), i32 2, i32 2 }>, section ".rodata", align 4
@"$s4main1UV13TangentVectorVMf" = internal constant <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }> <{ i8** getelementptr inbounds (%swift.vwtable, %swift.vwtable* @"$s4main1UV13TangentVectorVWV", i32 0, i32 0), i64 512, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UV13TangentVectorVMn", i32 0, i32 16 }>, align 8
@"$s4main1UV13TangentVectorVMF" = internal constant { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1UV13TangentVectorV" to i64), i64 ptrtoint ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1UV13TangentVectorVMF" to i64)) to i32), i32 0, i16 0, i16 12, i32 2, i32 2, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [4 x i8], i8 }>* @"symbolic _____ySfG 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1UV13TangentVectorVMF", i32 0, i32 6) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([2 x i8]* @7 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1UV13TangentVectorVMF", i32 0, i32 7) to i64)) to i32), i32 2, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1UV13TangentVectorVMF", i32 0, i32 9) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([2 x i8]* @8 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1UV13TangentVectorVMF", i32 0, i32 10) to i64)) to i32) }, section "swift5_fieldmd", align 4
@"$s4main1VVWV" = internal constant %swift.vwtable { i8* bitcast (%swift.opaque* ([24 x i8]*, [24 x i8]*, %swift.type*)* @"$s4main1VVwCP" to i8*), i8* bitcast (void (%swift.opaque*, %swift.type*)* @"$s4main1VVwxx" to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1VVwcp" to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1VVwca" to i8*), i8* bitcast (i8* (i8*, i8*, %swift.type*)* @__swift_memcpy9_8 to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1VVwta" to i8*), i8* bitcast (i32 (%swift.opaque*, i32, %swift.type*)* @"$s4main1VVwet" to i8*), i8* bitcast (void (%swift.opaque*, i32, i32, %swift.type*)* @"$s4main1VVwst" to i8*), i64 9, i64 16, i32 65543, i32 4096 }, align 8
@9 = private constant [2 x i8] c"V\00"
@"$s4main1VVMn" = hidden constant <{ i32, i32, i32, i32, i32, i32, i32 }> <{ i32 81, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32 }>* @"$s4mainMXM" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VVMn", i32 0, i32 1) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([2 x i8]* @9 to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VVMn", i32 0, i32 2) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (%swift.metadata_response (i64)* @"$s4main1VVMa" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VVMn", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i16, i16, i32, i32, i32, i32 }* @"$s4main1VVMF" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VVMn", i32 0, i32 4) to i64)) to i32), i32 1, i32 2 }>, section ".rodata", align 4
@"$s4main1VVMf" = internal constant <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, [4 x i8] }> <{ i8** getelementptr inbounds (%swift.vwtable, %swift.vwtable* @"$s4main1VVWV", i32 0, i32 0), i64 512, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VVMn", i32 0, [4 x i8] zeroinitializer }>, align 8
@"$s4main1VVMF" = internal constant { i32, i32, i16, i16, i32, i32, i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1VV" to i64), i64 ptrtoint ({ i32, i32, i16, i16, i32, i32, i32, i32 }* @"$s4main1VVMF" to i64)) to i32), i32 0, i16 0, i16 12, i32 1, i32 2, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [4 x i8], i8 }>* @"symbolic _____ySfG 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32 }* @"$s4main1VVMF", i32 0, i32 6) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([2 x i8]* @7 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32 }* @"$s4main1VVMF", i32 0, i32 7) to i64)) to i32) }, section "swift5_fieldmd", align 4
@"$s4main1VV13TangentVectorVWV" = internal constant %swift.vwtable { i8* bitcast (%swift.opaque* ([24 x i8]*, [24 x i8]*, %swift.type*)* @"$s4main1VV13TangentVectorVwCP" to i8*), i8* bitcast (void (%swift.opaque*, %swift.type*)* @"$s4main1VV13TangentVectorVwxx" to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1VV13TangentVectorVwcp" to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1VV13TangentVectorVwca" to i8*), i8* bitcast (i8* (i8*, i8*, %swift.type*)* @__swift_memcpy9_8 to i8*), i8* bitcast (%swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)* @"$s4main1VV13TangentVectorVwta" to i8*), i8* bitcast (i32 (%swift.opaque*, i32, %swift.type*)* @"$s4main1VV13TangentVectorVwet" to i8*), i8* bitcast (void (%swift.opaque*, i32, i32, %swift.type*)* @"$s4main1VV13TangentVectorVwst" to i8*), i64 9, i64 16, i32 65543, i32 4096 }, align 8
@"$s4main1VV13TangentVectorVMn" = hidden constant <{ i32, i32, i32, i32, i32, i32, i32 }> <{ i32 81, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VV13TangentVectorVMn", i32 0, i32 1) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([14 x i8]* @5 to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VV13TangentVectorVMn", i32 0, i32 2) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (%swift.metadata_response (i64)* @"$s4main1VV13TangentVectorVMa" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VV13TangentVectorVMn", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i16, i16, i32, i32, i32, i32 }* @"$s4main1VV13TangentVectorVMF" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i32, i32, i32, i32, i32, i32, i32 }>, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VV13TangentVectorVMn", i32 0, i32 4) to i64)) to i32), i32 1, i32 2 }>, section ".rodata", align 4
@"$s4main1VV13TangentVectorVMf" = internal constant <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, [4 x i8] }> <{ i8** getelementptr inbounds (%swift.vwtable, %swift.vwtable* @"$s4main1VV13TangentVectorVWV", i32 0, i32 0), i64 512, <{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VV13TangentVectorVMn", i32 0, [4 x i8] zeroinitializer }>, align 8
@"$s4main1VV13TangentVectorVMF" = internal constant { i32, i32, i16, i16, i32, i32, i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, i8 }>* @"symbolic _____ 4main1VV13TangentVectorV" to i64), i64 ptrtoint ({ i32, i32, i16, i16, i32, i32, i32, i32 }* @"$s4main1VV13TangentVectorVMF" to i64)) to i32), i32 0, i16 0, i16 12, i32 1, i32 2, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [4 x i8], i8 }>* @"symbolic _____ySfG 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32 }* @"$s4main1VV13TangentVectorVMF", i32 0, i32 6) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ([2 x i8]* @7 to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i16, i16, i32, i32, i32, i32 }, { i32, i32, i16, i16, i32, i32, i32, i32 }* @"$s4main1VV13TangentVectorVMF", i32 0, i32 7) to i64)) to i32) }, section "swift5_fieldmd", align 4
@"_swift_FORCE_LOAD_$_swiftGlibc_$_main" = weak_odr hidden constant void ()* @"_swift_FORCE_LOAD_$_swiftGlibc"
@"\01l__swift5_reflection_descriptor.56" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.56", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.58 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.57, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.56" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.60" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.60", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.62 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.61, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.60" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.63" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.63", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.65 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.64, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.63" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.67" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.67", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.69 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.68, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.67" to i8*) }, align 8
@"$s16_Differentiation14DifferentiableTL" = external global %swift.protocol_requirement, align 4
@"\01l__swift5_reflection_descriptor.71" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.71", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.73 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.72, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.71" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.75" = private constant { i32, i32, i32, i32, i32 } { i32 2, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.75", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.75", i32 0, i32 4) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.77 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.76, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.75" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.79" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1UV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.79", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.81 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.80, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.79" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.82" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.82", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.84 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.83, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.82" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.86" = private constant { i32, i32, i32, i32, i32 } { i32 2, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.86", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.86", i32 0, i32 4) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.88 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.87, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.86" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.90" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1UV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.90", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.92 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.91, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.90" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.94" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.94", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.96 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.95, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.94" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.98" = private constant { i32, i32, i32, i32, i32 } { i32 2, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.98", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.98", i32 0, i32 4) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.100 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.99, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.98" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.102" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.102", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.104 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.103, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.102" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.106" = private constant { i32, i32, i32, i32, i32 } { i32 2, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.106", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.106", i32 0, i32 4) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.108 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.107, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.106" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.110" = private constant { i32, i32, i32, i32, i32 } { i32 2, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1UV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.110", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1UV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.110", i32 0, i32 4) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.112 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.111, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.110" to i8*) }, align 8
@"symbolic _____Iegr_ 4main1TV13TangentVectorV" = linkonce_odr hidden constant <{ i8, i32, [5 x i8], i8 }> <{ i8 1, i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds (<{ i8, i32, [5 x i8], i8 }>, <{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iegr_ 4main1TV13TangentVectorV", i32 0, i32 1) to i64)) to i32), [5 x i8] c"Iegr_", i8 0 }>, section "swift5_typeref", align 2
@"\01l__swift5_reflection_descriptor.114" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iegr_ 4main1TV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.114", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.116 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.115, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.114" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.117" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.117", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.119 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.118, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.117" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.121" = private constant { i32, i32, i32, i32, i32 } { i32 2, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.121", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.121", i32 0, i32 4) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.123 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.122, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.121" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.125" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.125", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.127 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.126, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.125" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.129" = private constant { i32, i32, i32, i32, i32 } { i32 2, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.129", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1VV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.129", i32 0, i32 4) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.131 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.130, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.129" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.133" = private constant { i32, i32, i32, i32, i32 } { i32 2, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1UV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.133", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1UV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32, i32 }, { i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.133", i32 0, i32 4) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.135 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.134, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.133" to i8*) }, align 8
@"\01l__swift5_reflection_descriptor.137" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iegr_ 4main1TV13TangentVectorV" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.137", i32 0, i32 3) to i64)) to i32) }, section "swift5_capture", align 4
@metadata.139 = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy.138, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.137" to i8*) }, align 8
@"\01l_protocol_conformances" = private constant [12 x i32] [i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc" to i64), i64 ptrtoint ([12 x i32]* @"\01l_protocol_conformances" to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc" to i64), i64 ptrtoint (i32* getelementptr inbounds ([12 x i32], [12 x i32]* @"\01l_protocol_conformances", i32 0, i32 1) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVSQAAMc" to i64), i64 ptrtoint (i32* getelementptr inbounds ([12 x i32], [12 x i32]* @"\01l_protocol_conformances", i32 0, i32 2) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMc" to i64), i64 ptrtoint (i32* getelementptr inbounds ([12 x i32], [12 x i32]* @"\01l_protocol_conformances", i32 0, i32 3) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc" to i64), i64 ptrtoint (i32* getelementptr inbounds ([12 x i32], [12 x i32]* @"\01l_protocol_conformances", i32 0, i32 4) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc" to i64), i64 ptrtoint (i32* getelementptr inbounds ([12 x i32], [12 x i32]* @"\01l_protocol_conformances", i32 0, i32 5) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVSQAAMc" to i64), i64 ptrtoint (i32* getelementptr inbounds ([12 x i32], [12 x i32]* @"\01l_protocol_conformances", i32 0, i32 6) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMc" to i64), i64 ptrtoint (i32* getelementptr inbounds ([12 x i32], [12 x i32]* @"\01l_protocol_conformances", i32 0, i32 7) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc" to i64), i64 ptrtoint (i32* getelementptr inbounds ([12 x i32], [12 x i32]* @"\01l_protocol_conformances", i32 0, i32 8) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc" to i64), i64 ptrtoint (i32* getelementptr inbounds ([12 x i32], [12 x i32]* @"\01l_protocol_conformances", i32 0, i32 9) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVSQAAMc" to i64), i64 ptrtoint (i32* getelementptr inbounds ([12 x i32], [12 x i32]* @"\01l_protocol_conformances", i32 0, i32 10) to i64)) to i32), i32 trunc (i64 sub (i64 ptrtoint ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMc" to i64), i64 ptrtoint (i32* getelementptr inbounds ([12 x i32], [12 x i32]* @"\01l_protocol_conformances", i32 0, i32 11) to i64)) to i32)], section "swift5_protocol_conformances", align 4
@"\01l_type_metadata_table" = private constant [6 x %swift.type_metadata_record] [%swift.type_metadata_record { i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TVMn" to i64), i64 ptrtoint ([6 x %swift.type_metadata_record]* @"\01l_type_metadata_table" to i64)) to i32) }, %swift.type_metadata_record { i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ([6 x %swift.type_metadata_record], [6 x %swift.type_metadata_record]* @"\01l_type_metadata_table", i32 0, i32 1, i32 0) to i64)) to i32) }, %swift.type_metadata_record { i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ([6 x %swift.type_metadata_record], [6 x %swift.type_metadata_record]* @"\01l_type_metadata_table", i32 0, i32 2, i32 0) to i64)) to i32) }, %swift.type_metadata_record { i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ([6 x %swift.type_metadata_record], [6 x %swift.type_metadata_record]* @"\01l_type_metadata_table", i32 0, i32 3, i32 0) to i64)) to i32) }, %swift.type_metadata_record { i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ([6 x %swift.type_metadata_record], [6 x %swift.type_metadata_record]* @"\01l_type_metadata_table", i32 0, i32 4, i32 0) to i64)) to i32) }, %swift.type_metadata_record { i32 trunc (i64 sub (i64 ptrtoint (<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VV13TangentVectorVMn" to i64), i64 ptrtoint (i32* getelementptr inbounds ([6 x %swift.type_metadata_record], [6 x %swift.type_metadata_record]* @"\01l_type_metadata_table", i32 0, i32 5, i32 0) to i64)) to i32) }], section "swift5_type_metadata", align 4
@__swift_reflection_version = linkonce_odr hidden constant i16 3
@_swift1_autolink_entries = private constant [100 x i8] c"-lswift_Differentiation\00-lswiftCore\00-lswiftGlibc\00-lpthread\00-lutil\00-ldl\00-lm\00-lswiftSwiftOnoneSupport\00", section ".swift1_autolink_entries", align 8
@llvm.used = appending global [55 x i8*] [i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.1" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.102" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.106" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.110" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.114" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.117" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.12" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.121" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.125" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.129" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.133" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.137" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.15" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.19" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.23" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.26" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.29" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.33" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.37" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.4" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.40" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.44" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.48" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.52" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.56" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.60" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.63" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.67" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.71" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.75" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.79" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.8" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.82" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.86" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.90" to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.94" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.98" to i8*), i8* bitcast ([12 x i32]* @"\01l_protocol_conformances" to i8*), i8* bitcast ([6 x %swift.type_metadata_record]* @"\01l_type_metadata_table" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMA" to i8*), i8* bitcast ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1TV13TangentVectorVMF" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMA" to i8*), i8* bitcast ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1TVMF" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMA" to i8*), i8* bitcast ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1UV13TangentVectorVMF" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMA" to i8*), i8* bitcast ({ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1UVMF" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMA" to i8*), i8* bitcast ({ i32, i32, i16, i16, i32, i32, i32, i32 }* @"$s4main1VV13TangentVectorVMF" to i8*), i8* bitcast ({ i32, i32, i32, i32, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMA" to i8*), i8* bitcast ({ i32, i32, i16, i16, i32, i32, i32, i32 }* @"$s4main1VVMF" to i8*), i8* bitcast (i16* @__swift_reflection_version to i8*), i8* getelementptr inbounds ([100 x i8], [100 x i8]* @_swift1_autolink_entries, i32 0, i32 0), i8* bitcast (void ()** @"_swift_FORCE_LOAD_$_swiftGlibc_$_main" to i8*)], section "llvm.metadata"

@"$s4main1TVN" = hidden alias %swift.type, bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>* @"$s4main1TVMf", i32 0, i32 1) to %swift.type*)
@"$s4main1TV13TangentVectorVN" = hidden alias %swift.type, bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>* @"$s4main1TV13TangentVectorVMf", i32 0, i32 1) to %swift.type*)
@"$s4main1UVN" = hidden alias %swift.type, bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>* @"$s4main1UVMf", i32 0, i32 1) to %swift.type*)
@"$s4main1UV13TangentVectorVN" = hidden alias %swift.type, bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>* @"$s4main1UV13TangentVectorVMf", i32 0, i32 1) to %swift.type*)
@"$s4main1VVN" = hidden alias %swift.type, bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, [4 x i8] }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, [4 x i8] }>* @"$s4main1VVMf", i32 0, i32 1) to %swift.type*)
@"$s4main1VV13TangentVectorVN" = hidden alias %swift.type, bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, [4 x i8] }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, [4 x i8] }>* @"$s4main1VV13TangentVectorVMf", i32 0, i32 1) to %swift.type*)
; Function Attrs: nounwind
declare %swift.refcounted* @swift_retain(%swift.refcounted* returned) local_unnamed_addr #0
; Function Attrs: nounwind
declare void @swift_release(%swift.refcounted*) local_unnamed_addr #0
; Function Attrs: noinline nounwind
define hidden swiftcc { i8*, %T4main1UV* } @"$s4main1TV2u1AA1UVvM"(i8* noalias dereferenceable(32) %0, %T4main1TV* nocapture swiftself dereferenceable(57) %1) local_unnamed_addr #1 !dbg !126 {
entry:
  %.u1 = getelementptr inbounds %T4main1TV, %T4main1TV* %1, i64 0, i32 0, !dbg !132
  %2 = insertvalue { i8*, %T4main1UV* } { i8* bitcast (void (i8*, i1)* @"$s4main1TV2u1AA1UVvM.resume.0" to i8*), %T4main1UV* undef }, %T4main1UV* %.u1, 1
  ret { i8*, %T4main1UV* } %2
}
define internal swiftcc void @"$s4main1TV2u1AA1UVvM.resume.0"(i8* noalias nonnull align 8 dereferenceable(32) %0, i1 %1) #2 !dbg !135 {
entryresume.0:
  ret void, !dbg !136
}
declare swiftcc void @"$s4main1TVAA1UVIetMAlYl_TC"(i8* noalias dereferenceable(32), i1) #2
; Function Attrs: nofree nounwind
declare noalias i8* @malloc(i64) #3
; Function Attrs: nounwind
declare void @free(i8* nocapture) #0
; Function Attrs: nounwind
declare token @llvm.coro.id.retcon.once(i32, i32, i8*, i8*, i8*, i8*) #0
; Function Attrs: nounwind
declare i8* @llvm.coro.begin(token, i8* writeonly) #0
; Function Attrs: noinline nounwind
define hidden swiftcc { i8*, %T4main1UV* } @"$s4main1TV2u2AA1UVvM"(i8* noalias dereferenceable(32) %0, %T4main1TV* nocapture swiftself dereferenceable(57) %1) local_unnamed_addr #1 !dbg !139 {
entry:
  %.u2 = getelementptr inbounds %T4main1TV, %T4main1TV* %1, i64 0, i32 2, !dbg !140
  %2 = insertvalue { i8*, %T4main1UV* } { i8* bitcast (void (i8*, i1)* @"$s4main1TV2u2AA1UVvM.resume.0" to i8*), %T4main1UV* undef }, %T4main1UV* %.u2, 1
  ret { i8*, %T4main1UV* } %2
}
define internal swiftcc void @"$s4main1TV2u2AA1UVvM.resume.0"(i8* noalias nonnull align 8 dereferenceable(32) %0, i1 %1) #2 !dbg !143 {
entryresume.0:
  ret void, !dbg !144
}
; Function Attrs: nounwind
define hidden swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1TV13TangentVectorV2u1AA1UVADVvg"(%T4main1TV13TangentVectorV* noalias nocapture readonly swiftself dereferenceable(57) %0) local_unnamed_addr #4 !dbg !147 {
entry:
  %.u1.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 0, i32 0, !dbg !153
  %1 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.u1.s.c, align 8, !dbg !153
  %.u1.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 0, i32 1, i32 0, !dbg !153
  %2 = load i1, i1* %.u1.s.b._value, align 8, !dbg !153
  %.u1.v.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, i32 0, !dbg !153
  %3 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.u1.v.s.c, align 8, !dbg !153
  %.u1.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, i32 1, i32 0, !dbg !153
  %4 = load i1, i1* %.u1.v.s.b._value, align 8, !dbg !153
  %5 = bitcast %T1M1SV1CCySf_G* %1 to %swift.refcounted*, !dbg !155
  %6 = bitcast %T1M1SV1CCySf_G* %3 to %swift.refcounted*, !dbg !155
  %7 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } undef, %T1M1SV1CCySf_G* %1, 0, !dbg !153
  %8 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %7, i1 %2, 1, !dbg !153
  %9 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %8, %T1M1SV1CCySf_G* %3, 2, !dbg !153
  %10 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %9, i1 %4, 3, !dbg !153
  %11 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %5) #0, !dbg !155
  %12 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %6) #0, !dbg !155
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %10, !dbg !153
}
; Function Attrs: nounwind
define hidden swiftcc void @"$s4main1TV13TangentVectorV2u1AA1UVADVvs"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3, %T4main1TV13TangentVectorV* nocapture swiftself dereferenceable(57) %4) local_unnamed_addr #4 !dbg !156 {
entry:
  %.u1.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %4, i64 0, i32 0, i32 0, i32 0, !dbg !159
  %5 = bitcast %T4main1TV13TangentVectorV* %4 to %swift.refcounted**, !dbg !159
  %6 = load %swift.refcounted*, %swift.refcounted** %5, align 8, !dbg !159
  %.u1.v.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %4, i64 0, i32 0, i32 2, i32 0, i32 0, !dbg !159
  %7 = bitcast %T1M1SV1CCySf_G** %.u1.v.s.c to %swift.refcounted**, !dbg !159
  %8 = load %swift.refcounted*, %swift.refcounted** %7, align 8, !dbg !159
  store %T1M1SV1CCySf_G* %0, %T1M1SV1CCySf_G** %.u1.s.c, align 8, !dbg !159
  %.u1.s1.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %4, i64 0, i32 0, i32 0, i32 1, i32 0, !dbg !159
  store i1 %1, i1* %.u1.s1.b._value, align 8, !dbg !159
  store %T1M1SV1CCySf_G* %2, %T1M1SV1CCySf_G** %.u1.v.s.c, align 8, !dbg !159
  %.u1.v2.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %4, i64 0, i32 0, i32 2, i32 0, i32 1, i32 0, !dbg !159
  store i1 %3, i1* %.u1.v2.s.b._value, align 8, !dbg !159
  tail call void @swift_release(%swift.refcounted* %8) #0, !dbg !161
  tail call void @swift_release(%swift.refcounted* %6) #0, !dbg !161
  ret void, !dbg !159
}
; Function Attrs: noinline nounwind
define hidden swiftcc { i8*, %T4main1UV13TangentVectorV* } @"$s4main1TV13TangentVectorV2u1AA1UVADVvM"(i8* noalias dereferenceable(32) %0, %T4main1TV13TangentVectorV* nocapture swiftself dereferenceable(57) %1) local_unnamed_addr #1 !dbg !162 {
entry:
  %.u1 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 0, !dbg !165
  %2 = insertvalue { i8*, %T4main1UV13TangentVectorV* } { i8* bitcast (void (i8*, i1)* @"$s4main1TV13TangentVectorV2u1AA1UVADVvM.resume.0" to i8*), %T4main1UV13TangentVectorV* undef }, %T4main1UV13TangentVectorV* %.u1, 1
  ret { i8*, %T4main1UV13TangentVectorV* } %2
}
define internal swiftcc void @"$s4main1TV13TangentVectorV2u1AA1UVADVvM.resume.0"(i8* noalias nonnull align 8 dereferenceable(32) %0, i1 %1) #2 !dbg !167 {
entryresume.0:
  ret void, !dbg !168
}
declare swiftcc void @"$s4main1TV13TangentVectorVAA1UVADVIetMAlYl_TC"(i8* noalias dereferenceable(32), i1) #2
; Function Attrs: nounwind
define hidden swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1TV13TangentVectorV2u2AA1UVADVvg"(%T4main1TV13TangentVectorV* noalias nocapture readonly swiftself dereferenceable(57) %0) local_unnamed_addr #4 !dbg !170 {
entry:
  %.u2.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 0, !dbg !171
  %1 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.u2.s.c, align 8, !dbg !171
  %.u2.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !171
  %2 = load i1, i1* %.u2.s.b._value, align 8, !dbg !171
  %.u2.v.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 0, !dbg !171
  %3 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.u2.v.s.c, align 8, !dbg !171
  %.u2.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !171
  %4 = load i1, i1* %.u2.v.s.b._value, align 8, !dbg !171
  %5 = bitcast %T1M1SV1CCySf_G* %1 to %swift.refcounted*, !dbg !173
  %6 = bitcast %T1M1SV1CCySf_G* %3 to %swift.refcounted*, !dbg !173
  %7 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } undef, %T1M1SV1CCySf_G* %1, 0, !dbg !171
  %8 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %7, i1 %2, 1, !dbg !171
  %9 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %8, %T1M1SV1CCySf_G* %3, 2, !dbg !171
  %10 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %9, i1 %4, 3, !dbg !171
  %11 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %5) #0, !dbg !173
  %12 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %6) #0, !dbg !173
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %10, !dbg !171
}
; Function Attrs: nounwind
define hidden swiftcc void @"$s4main1TV13TangentVectorV2u2AA1UVADVvs"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3, %T4main1TV13TangentVectorV* nocapture swiftself dereferenceable(57) %4) local_unnamed_addr #4 !dbg !174 {
entry:
  %.u2.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %4, i64 0, i32 2, i32 0, i32 0, !dbg !175
  %5 = bitcast %T1M1SV1CCySf_G** %.u2.s.c to %swift.refcounted**, !dbg !175
  %6 = load %swift.refcounted*, %swift.refcounted** %5, align 8, !dbg !175
  %.u2.v.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %4, i64 0, i32 2, i32 2, i32 0, i32 0, !dbg !175
  %7 = bitcast %T1M1SV1CCySf_G** %.u2.v.s.c to %swift.refcounted**, !dbg !175
  %8 = load %swift.refcounted*, %swift.refcounted** %7, align 8, !dbg !175
  store %T1M1SV1CCySf_G* %0, %T1M1SV1CCySf_G** %.u2.s.c, align 8, !dbg !175
  %.u2.s1.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %4, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !175
  store i1 %1, i1* %.u2.s1.b._value, align 8, !dbg !175
  store %T1M1SV1CCySf_G* %2, %T1M1SV1CCySf_G** %.u2.v.s.c, align 8, !dbg !175
  %.u2.v2.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %4, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !175
  store i1 %3, i1* %.u2.v2.s.b._value, align 8, !dbg !175
  tail call void @swift_release(%swift.refcounted* %8) #0, !dbg !177
  tail call void @swift_release(%swift.refcounted* %6) #0, !dbg !177
  ret void, !dbg !175
}
; Function Attrs: noinline nounwind
define hidden swiftcc { i8*, %T4main1UV13TangentVectorV* } @"$s4main1TV13TangentVectorV2u2AA1UVADVvM"(i8* noalias dereferenceable(32) %0, %T4main1TV13TangentVectorV* nocapture swiftself dereferenceable(57) %1) local_unnamed_addr #1 !dbg !178 {
entry:
  %.u2 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, !dbg !179
  %2 = insertvalue { i8*, %T4main1UV13TangentVectorV* } { i8* bitcast (void (i8*, i1)* @"$s4main1TV13TangentVectorV2u2AA1UVADVvM.resume.0" to i8*), %T4main1UV13TangentVectorV* undef }, %T4main1UV13TangentVectorV* %.u2, 1
  ret { i8*, %T4main1UV13TangentVectorV* } %2
}
define internal swiftcc void @"$s4main1TV13TangentVectorV2u2AA1UVADVvM.resume.0"(i8* noalias nonnull align 8 dereferenceable(32) %0, i1 %1) #2 !dbg !181 {
entryresume.0:
  ret void, !dbg !182
}
; Function Attrs: nofree norecurse nounwind writeonly
define hidden swiftcc void @"$s4main1TV13TangentVectorV2u12u2AeA1UVADV_AJtcfC"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %T1M1SV1CCySf_G* %1, i1 %2, %T1M1SV1CCySf_G* %3, i1 %4, %T1M1SV1CCySf_G* %5, i1 %6, %T1M1SV1CCySf_G* %7, i1 %8) local_unnamed_addr #5 !dbg !184 {
entry:
  %.u1.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 0, i32 0, !dbg !188
  store %T1M1SV1CCySf_G* %1, %T1M1SV1CCySf_G** %.u1.s.c, align 8, !dbg !188
  %.u1.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 0, i32 1, i32 0, !dbg !188
  store i1 %2, i1* %.u1.s.b._value, align 8, !dbg !188
  %.u1.v.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, i32 0, !dbg !188
  store %T1M1SV1CCySf_G* %3, %T1M1SV1CCySf_G** %.u1.v.s.c, align 8, !dbg !188
  %.u1.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, i32 1, i32 0, !dbg !188
  store i1 %4, i1* %.u1.v.s.b._value, align 8, !dbg !188
  %.u2.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 0, !dbg !188
  store %T1M1SV1CCySf_G* %5, %T1M1SV1CCySf_G** %.u2.s.c, align 8, !dbg !188
  %.u2.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !188
  store i1 %6, i1* %.u2.s.b._value, align 8, !dbg !188
  %.u2.v.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 0, !dbg !188
  store %T1M1SV1CCySf_G* %7, %T1M1SV1CCySf_G** %.u2.v.s.c, align 8, !dbg !188
  %.u2.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !188
  store i1 %8, i1* %.u2.v.s.b._value, align 8, !dbg !188
  ret void, !dbg !188
}
define hidden swiftcc { i8*, %swift.refcounted* } @"$s4main1TV13TangentVectorV04zerobC11InitializerAEycvg"(%T4main1TV13TangentVectorV* noalias nocapture readonly swiftself dereferenceable(57) %0) local_unnamed_addr #2 !dbg !189 {
entry:
  call void @llvm.dbg.declare(metadata %TSb* undef, metadata !193, metadata !DIExpression(DW_OP_LLVM_fragment, 192, 8)), !dbg !199
  call void @llvm.dbg.declare(metadata %TSb* undef, metadata !193, metadata !DIExpression(DW_OP_LLVM_fragment, 192, 8)), !dbg !199
  call void @llvm.dbg.value(metadata %T4main1TV13TangentVectorV* %0, metadata !203, metadata !DIExpression(DW_OP_deref)), !dbg !205
  %1 = bitcast %T4main1TV13TangentVectorV* %0 to %T1M1SV1CC**, !dbg !200
  %.sroa.052.0.copyload87 = load %T1M1SV1CC*, %T1M1SV1CC** %1, align 8, !dbg !200
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !193, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !199
  %.sroa.454.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 0, i32 1, !dbg !200
  %.sroa.454.0..sroa_cast55 = bitcast %TSb* %.sroa.454.0..sroa_idx to i8*, !dbg !200
  %2 = load i8, i8* %.sroa.454.0..sroa_cast55, align 8, !dbg !200
  call void @llvm.dbg.value(metadata i8 %2, metadata !193, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !199
  %.sroa.5.sroa.376.0..sroa.5.0..sroa_idx58.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, i32 0, !dbg !200
  %3 = bitcast %T1M1SV1CCySf_G** %.sroa.5.sroa.376.0..sroa.5.0..sroa_idx58.sroa_idx to %T1M1SV1CC**, !dbg !200
  %.sroa.5.sroa.376.0.copyload88 = load %T1M1SV1CC*, %T1M1SV1CC** %3, align 1, !dbg !200
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !193, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !199
  %.sroa.5.sroa.478.0..sroa.5.0..sroa_idx58.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, i32 1, !dbg !200
  %.sroa.5.sroa.478.0..sroa.5.0..sroa_idx58.sroa_cast = bitcast %TSb* %.sroa.5.sroa.478.0..sroa.5.0..sroa_idx58.sroa_idx to i8*, !dbg !200
  %4 = load i8, i8* %.sroa.5.sroa.478.0..sroa.5.0..sroa_idx58.sroa_cast, align 1, !dbg !200
  %5 = and i8 %2, 1, !dbg !206
  %6 = icmp ne i8 %5, 0, !dbg !206
  call void @llvm.dbg.value(metadata i1 %6, metadata !193, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !199
  %7 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %.sroa.052.0.copyload87, i1 %6, %swift.type* nonnull @"$sSfN"), !dbg !206
  %8 = extractvalue { i8*, %swift.refcounted* } %7, 0, !dbg !206
  %9 = extractvalue { i8*, %swift.refcounted* } %7, 1, !dbg !206
  call void @llvm.dbg.value(metadata i8* %8, metadata !209, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !206
  call void @llvm.dbg.value(metadata %swift.refcounted* %9, metadata !209, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !206
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !212, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !220
  call void @llvm.dbg.value(metadata i8 %4, metadata !212, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !220
  %10 = and i8 %4, 1, !dbg !221
  %11 = icmp ne i8 %10, 0, !dbg !221
  call void @llvm.dbg.value(metadata i1 %11, metadata !212, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !220
  %12 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %.sroa.5.sroa.376.0.copyload88, i1 %11, %swift.type* nonnull @"$sSfN"), !dbg !221
  %13 = extractvalue { i8*, %swift.refcounted* } %12, 0, !dbg !221
  %14 = extractvalue { i8*, %swift.refcounted* } %12, 1, !dbg !221
  call void @llvm.dbg.value(metadata i8* %13, metadata !224, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !221
  call void @llvm.dbg.value(metadata %swift.refcounted* %14, metadata !224, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !221
  %15 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata, i64 0, i32 2), i64 32, i64 7) #0, !dbg !221
  %16 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %15, i64 1, !dbg !221
  %.fn = bitcast %swift.refcounted* %16 to i8**, !dbg !221
  store i8* %13, i8** %.fn, align 8, !dbg !221
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %15, i64 1, i32 1, !dbg !221
  %17 = bitcast i64* %.data to %swift.refcounted**, !dbg !221
  store %swift.refcounted* %14, %swift.refcounted** %17, align 8, !dbg !221
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA" to i8*), metadata !225, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !206
  call void @llvm.dbg.value(metadata %swift.refcounted* %15, metadata !225, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !206
  %18 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.3, i64 0, i32 2), i64 48, i64 7) #0, !dbg !206
  %19 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %18, i64 1, !dbg !206
  %.fn3 = bitcast %swift.refcounted* %19 to i8**, !dbg !206
  store i8* %8, i8** %.fn3, align 8, !dbg !206
  %.data4 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %18, i64 1, i32 1, !dbg !206
  %20 = bitcast i64* %.data4 to %swift.refcounted**, !dbg !206
  store %swift.refcounted* %9, %swift.refcounted** %20, align 8, !dbg !206
  %21 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %18, i64 2, !dbg !206
  %.fn5 = bitcast %swift.refcounted* %21 to i8**, !dbg !206
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA" to i8*), i8** %.fn5, align 8, !dbg !206
  %.data6 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %18, i64 2, i32 1, !dbg !206
  %22 = bitcast i64* %.data6 to %swift.refcounted**, !dbg !206
  store %swift.refcounted* %15, %swift.refcounted** %22, align 8, !dbg !206
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA" to i8*), metadata !227, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !200
  call void @llvm.dbg.value(metadata %swift.refcounted* %18, metadata !227, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !200
  %.sroa.0.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 0, !dbg !200
  %23 = bitcast %T1M1SV1CCySf_G** %.sroa.0.0..sroa_idx to %T1M1SV1CC**, !dbg !200
  %.sroa.0.0.copyload89 = load %T1M1SV1CC*, %T1M1SV1CC** %23, align 8, !dbg !200
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !193, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !199
  %.sroa.4.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, !dbg !200
  %.sroa.4.0..sroa_cast23 = bitcast %TSb* %.sroa.4.0..sroa_idx to i8*, !dbg !200
  %24 = load i8, i8* %.sroa.4.0..sroa_cast23, align 8, !dbg !200
  call void @llvm.dbg.value(metadata i8 %24, metadata !193, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !199
  %.sroa.5.sroa.3.0..sroa.5.0..sroa_idx26.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 0, !dbg !200
  %25 = bitcast %T1M1SV1CCySf_G** %.sroa.5.sroa.3.0..sroa.5.0..sroa_idx26.sroa_idx to %T1M1SV1CC**, !dbg !200
  %.sroa.5.sroa.3.0.copyload90 = load %T1M1SV1CC*, %T1M1SV1CC** %25, align 1, !dbg !200
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !193, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !199
  %.sroa.5.sroa.4.0..sroa.5.0..sroa_idx26.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 1, !dbg !200
  %.sroa.5.sroa.4.0..sroa.5.0..sroa_idx26.sroa_cast = bitcast %TSb* %.sroa.5.sroa.4.0..sroa.5.0..sroa_idx26.sroa_idx to i8*, !dbg !200
  %26 = load i8, i8* %.sroa.5.sroa.4.0..sroa.5.0..sroa_idx26.sroa_cast, align 1, !dbg !200
  %27 = and i8 %24, 1, !dbg !229
  %28 = icmp ne i8 %27, 0, !dbg !229
  call void @llvm.dbg.value(metadata i1 %28, metadata !193, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !199
  %29 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %.sroa.0.0.copyload89, i1 %28, %swift.type* nonnull @"$sSfN"), !dbg !229
  %30 = extractvalue { i8*, %swift.refcounted* } %29, 0, !dbg !229
  %31 = extractvalue { i8*, %swift.refcounted* } %29, 1, !dbg !229
  call void @llvm.dbg.value(metadata i8* %30, metadata !232, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !229
  call void @llvm.dbg.value(metadata %swift.refcounted* %31, metadata !232, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !229
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !212, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !233
  call void @llvm.dbg.value(metadata i8 %26, metadata !212, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !233
  %32 = and i8 %26, 1, !dbg !234
  %33 = icmp ne i8 %32, 0, !dbg !234
  call void @llvm.dbg.value(metadata i1 %33, metadata !212, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !233
  %34 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %.sroa.5.sroa.3.0.copyload90, i1 %33, %swift.type* nonnull @"$sSfN"), !dbg !234
  %35 = extractvalue { i8*, %swift.refcounted* } %34, 0, !dbg !234
  %36 = extractvalue { i8*, %swift.refcounted* } %34, 1, !dbg !234
  call void @llvm.dbg.value(metadata i8* %35, metadata !237, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !234
  call void @llvm.dbg.value(metadata %swift.refcounted* %36, metadata !237, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !234
  %37 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.6, i64 0, i32 2), i64 32, i64 7) #0, !dbg !234
  %38 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %37, i64 1, !dbg !234
  %.fn12 = bitcast %swift.refcounted* %38 to i8**, !dbg !234
  store i8* %35, i8** %.fn12, align 8, !dbg !234
  %.data13 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %37, i64 1, i32 1, !dbg !234
  %39 = bitcast i64* %.data13 to %swift.refcounted**, !dbg !234
  store %swift.refcounted* %36, %swift.refcounted** %39, align 8, !dbg !234
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.7" to i8*), metadata !238, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !229
  call void @llvm.dbg.value(metadata %swift.refcounted* %37, metadata !238, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !229
  %40 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.10, i64 0, i32 2), i64 48, i64 7) #0, !dbg !229
  %41 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %40, i64 1, !dbg !229
  %.fn14 = bitcast %swift.refcounted* %41 to i8**, !dbg !229
  store i8* %30, i8** %.fn14, align 8, !dbg !229
  %.data15 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %40, i64 1, i32 1, !dbg !229
  %42 = bitcast i64* %.data15 to %swift.refcounted**, !dbg !229
  store %swift.refcounted* %31, %swift.refcounted** %42, align 8, !dbg !229
  %43 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %40, i64 2, !dbg !229
  %.fn16 = bitcast %swift.refcounted* %43 to i8**, !dbg !229
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.7" to i8*), i8** %.fn16, align 8, !dbg !229
  %.data17 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %40, i64 2, i32 1, !dbg !229
  %44 = bitcast i64* %.data17 to %swift.refcounted**, !dbg !229
  store %swift.refcounted* %37, %swift.refcounted** %44, align 8, !dbg !229
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.11" to i8*), metadata !239, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !200
  call void @llvm.dbg.value(metadata %swift.refcounted* %40, metadata !239, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !200
  %45 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.14, i64 0, i32 2), i64 48, i64 7) #0, !dbg !200
  %46 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %45, i64 1, !dbg !200
  %.fn18 = bitcast %swift.refcounted* %46 to i8**, !dbg !200
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA" to i8*), i8** %.fn18, align 8, !dbg !200
  %.data19 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %45, i64 1, i32 1, !dbg !200
  %47 = bitcast i64* %.data19 to %swift.refcounted**, !dbg !200
  store %swift.refcounted* %18, %swift.refcounted** %47, align 8, !dbg !200
  %48 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %45, i64 2, !dbg !200
  %.fn20 = bitcast %swift.refcounted* %48 to i8**, !dbg !200
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.11" to i8*), i8** %.fn20, align 8, !dbg !200
  %.data21 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %45, i64 2, i32 1, !dbg !200
  %49 = bitcast i64* %.data21 to %swift.refcounted**, !dbg !200
  store %swift.refcounted* %40, %swift.refcounted** %49, align 8, !dbg !200
  %50 = insertvalue { i8*, %swift.refcounted* } { i8* bitcast (void (%T4main1TV13TangentVectorV*, %swift.refcounted*)* @"$s4main1TV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA" to i8*), %swift.refcounted* undef }, %swift.refcounted* %45, 1, !dbg !240
  ret { i8*, %swift.refcounted* } %50, !dbg !240
}
; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #6
; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #7
; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #6
define hidden swiftcc { i8*, %swift.refcounted* } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvg"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3) local_unnamed_addr #2 !dbg !194 {
entry:
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %0, metadata !193, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !241
  call void @llvm.dbg.value(metadata i1 %1, metadata !193, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !241
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %2, metadata !193, metadata !DIExpression(DW_OP_LLVM_fragment, 65, 64)), !dbg !241
  call void @llvm.dbg.value(metadata i1 %3, metadata !193, metadata !DIExpression(DW_OP_LLVM_fragment, 129, 1)), !dbg !241
  %.asUnsubstituted = bitcast %T1M1SV1CCySf_G* %0 to %T1M1SV1CC*, !dbg !242
  %4 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %.asUnsubstituted, i1 %1, %swift.type* nonnull @"$sSfN"), !dbg !242
  %5 = extractvalue { i8*, %swift.refcounted* } %4, 0, !dbg !242
  %6 = extractvalue { i8*, %swift.refcounted* } %4, 1, !dbg !242
  call void @llvm.dbg.value(metadata i8* %5, metadata !245, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !242
  call void @llvm.dbg.value(metadata %swift.refcounted* %6, metadata !245, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !242
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %2, metadata !212, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !246
  call void @llvm.dbg.value(metadata i1 %3, metadata !212, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !246
  %.asUnsubstituted1 = bitcast %T1M1SV1CCySf_G* %2 to %T1M1SV1CC*, !dbg !247
  %7 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %.asUnsubstituted1, i1 %3, %swift.type* nonnull @"$sSfN"), !dbg !247
  %8 = extractvalue { i8*, %swift.refcounted* } %7, 0, !dbg !247
  %9 = extractvalue { i8*, %swift.refcounted* } %7, 1, !dbg !247
  call void @llvm.dbg.value(metadata i8* %8, metadata !250, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !247
  call void @llvm.dbg.value(metadata %swift.refcounted* %9, metadata !250, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !247
  %10 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.17, i64 0, i32 2), i64 32, i64 7) #0, !dbg !247
  %11 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %10, i64 1, !dbg !247
  %.fn = bitcast %swift.refcounted* %11 to i8**, !dbg !247
  store i8* %8, i8** %.fn, align 8, !dbg !247
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %10, i64 1, i32 1, !dbg !247
  %12 = bitcast i64* %.data to %swift.refcounted**, !dbg !247
  store %swift.refcounted* %9, %swift.refcounted** %12, align 8, !dbg !247
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.18" to i8*), metadata !251, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !242
  call void @llvm.dbg.value(metadata %swift.refcounted* %10, metadata !251, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !242
  %13 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.21, i64 0, i32 2), i64 48, i64 7) #0, !dbg !242
  %14 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %13, i64 1, !dbg !242
  %.fn2 = bitcast %swift.refcounted* %14 to i8**, !dbg !242
  store i8* %5, i8** %.fn2, align 8, !dbg !242
  %.data3 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %13, i64 1, i32 1, !dbg !242
  %15 = bitcast i64* %.data3 to %swift.refcounted**, !dbg !242
  store %swift.refcounted* %6, %swift.refcounted** %15, align 8, !dbg !242
  %16 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %13, i64 2, !dbg !242
  %.fn4 = bitcast %swift.refcounted* %16 to i8**, !dbg !242
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.18" to i8*), i8** %.fn4, align 8, !dbg !242
  %.data5 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %13, i64 2, i32 1, !dbg !242
  %17 = bitcast i64* %.data5 to %swift.refcounted**, !dbg !242
  store %swift.refcounted* %10, %swift.refcounted** %17, align 8, !dbg !242
  %18 = insertvalue { i8*, %swift.refcounted* } { i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.22" to i8*), %swift.refcounted* undef }, %swift.refcounted* %13, 1, !dbg !252
  ret { i8*, %swift.refcounted* } %18, !dbg !252
}
; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #7
declare swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC*, i1, %swift.type*) local_unnamed_addr #2
define hidden swiftcc void @"$s4main1TV13TangentVectorV4zeroAEvgZ"(%T4main1TV13TangentVectorV* noalias nocapture sret %0) local_unnamed_addr #2 !dbg !253 {
entry:
  %1 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV4zeroACyxGvgZ"(%swift.type* nonnull @"$sSfN"), !dbg !256
  %2 = extractvalue { %T1M1SV1CC*, i1 } %1, 0, !dbg !256
  %3 = extractvalue { %T1M1SV1CC*, i1 } %1, 1, !dbg !256
  %4 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV4zeroACyxGvgZ"(%swift.type* nonnull @"$sSfN"), !dbg !264
  %5 = extractvalue { %T1M1SV1CC*, i1 } %4, 0, !dbg !264
  %6 = extractvalue { %T1M1SV1CC*, i1 } %4, 1, !dbg !264
  %7 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV4zeroACyxGvgZ"(%swift.type* nonnull @"$sSfN"), !dbg !270
  %8 = extractvalue { %T1M1SV1CC*, i1 } %7, 0, !dbg !270
  %9 = extractvalue { %T1M1SV1CC*, i1 } %7, 1, !dbg !270
  %10 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV4zeroACyxGvgZ"(%swift.type* nonnull @"$sSfN"), !dbg !272
  %11 = extractvalue { %T1M1SV1CC*, i1 } %10, 0, !dbg !272
  %12 = extractvalue { %T1M1SV1CC*, i1 } %10, 1, !dbg !272
  %13 = bitcast %T4main1TV13TangentVectorV* %0 to %T1M1SV1CC**, !dbg !262
  store %T1M1SV1CC* %2, %T1M1SV1CC** %13, align 8, !dbg !262
  %.u1.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 0, i32 1, i32 0, !dbg !262
  store i1 %3, i1* %.u1.s.b._value, align 8, !dbg !262
  %.u1.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, !dbg !262
  %14 = bitcast %T1M1SVySfG* %.u1.v.s to %T1M1SV1CC**, !dbg !262
  store %T1M1SV1CC* %5, %T1M1SV1CC** %14, align 8, !dbg !262
  %.u1.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, i32 1, i32 0, !dbg !262
  store i1 %6, i1* %.u1.v.s.b._value, align 8, !dbg !262
  %.u2 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, !dbg !262
  %15 = bitcast %T4main1UV13TangentVectorV* %.u2 to %T1M1SV1CC**, !dbg !262
  store %T1M1SV1CC* %8, %T1M1SV1CC** %15, align 8, !dbg !262
  %.u2.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !262
  store i1 %9, i1* %.u2.s.b._value, align 8, !dbg !262
  %.u2.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, !dbg !262
  %16 = bitcast %T1M1SVySfG* %.u2.v.s to %T1M1SV1CC**, !dbg !262
  store %T1M1SV1CC* %11, %T1M1SV1CC** %16, align 8, !dbg !262
  %.u2.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !262
  store i1 %12, i1* %.u2.v.s.b._value, align 8, !dbg !262
  ret void, !dbg !262
}
define hidden swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV4zeroAEvgZ"() local_unnamed_addr #2 !dbg !258 {
entry:
  %0 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV4zeroACyxGvgZ"(%swift.type* nonnull @"$sSfN"), !dbg !274
  %1 = extractvalue { %T1M1SV1CC*, i1 } %0, 0, !dbg !274
  %2 = extractvalue { %T1M1SV1CC*, i1 } %0, 1, !dbg !274
  %.asSubstituted = bitcast %T1M1SV1CC* %1 to %T1M1SV1CCySf_G*, !dbg !274
  %3 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV4zeroACyxGvgZ"(%swift.type* nonnull @"$sSfN"), !dbg !276
  %4 = extractvalue { %T1M1SV1CC*, i1 } %3, 0, !dbg !276
  %5 = extractvalue { %T1M1SV1CC*, i1 } %3, 1, !dbg !276
  %.asSubstituted1 = bitcast %T1M1SV1CC* %4 to %T1M1SV1CCySf_G*, !dbg !276
  %6 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } undef, %T1M1SV1CCySf_G* %.asSubstituted, 0, !dbg !274
  %7 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %6, i1 %2, 1, !dbg !274
  %8 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %7, %T1M1SV1CCySf_G* %.asSubstituted1, 2, !dbg !274
  %9 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %8, i1 %5, 3, !dbg !274
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %9, !dbg !274
}
define hidden swiftcc void @"$s4main1TV13TangentVectorV1poiyA2E_AEtFZ"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %1, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %2) local_unnamed_addr #2 {
  tail call swiftcc void @"$s4main1TV13TangentVectorV1poiyA2E_AEtFZTm"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %1, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %2, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* @"$s1M1SV1poiyACyxGAE_AEtFZ") #2
  ret void
}
define hidden swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV1poiyA2E_AEtFZ"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3, %T1M1SV1CCySf_G* %4, i1 %5, %T1M1SV1CCySf_G* %6, i1 %7) local_unnamed_addr #2 {
  %9 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV1poiyA2E_AEtFZTm"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3, %T1M1SV1CCySf_G* %4, i1 %5, %T1M1SV1CCySf_G* %6, i1 %7, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* @"$s1M1SV1poiyACyxGAE_AEtFZ") #2
  %10 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %9, 0
  %11 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } undef, %T1M1SV1CCySf_G* %10, 0
  %12 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %9, 1
  %13 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %11, i1 %12, 1
  %14 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %9, 2
  %15 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %13, %T1M1SV1CCySf_G* %14, 2
  %16 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %9, 3
  %17 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %15, i1 %16, 3
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %17
}
define hidden swiftcc void @"$s4main1TV13TangentVectorV1soiyA2E_AEtFZ"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %1, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %2) local_unnamed_addr #2 {
  tail call swiftcc void @"$s4main1TV13TangentVectorV1poiyA2E_AEtFZTm"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %1, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %2, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* @"$s1M1SV1soiyACyxGAE_AEtFZ") #2
  ret void
}
define internal swiftcc void @"$s4main1TV13TangentVectorV1poiyA2E_AEtFZTm"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %1, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %2, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* %3) local_unnamed_addr #2 {
entry:
  call void @llvm.dbg.declare(metadata %TSb* undef, metadata !278, metadata !DIExpression(DW_OP_LLVM_fragment, 192, 8)), !dbg !282
  call void @llvm.dbg.declare(metadata %TSb* undef, metadata !288, metadata !DIExpression(DW_OP_LLVM_fragment, 192, 8)), !dbg !282
  call void @llvm.dbg.declare(metadata %TSb* undef, metadata !278, metadata !DIExpression(DW_OP_LLVM_fragment, 192, 8)), !dbg !282
  call void @llvm.dbg.declare(metadata %TSb* undef, metadata !288, metadata !DIExpression(DW_OP_LLVM_fragment, 192, 8)), !dbg !282
  call void @llvm.dbg.value(metadata %T4main1TV13TangentVectorV* %1, metadata !289, metadata !DIExpression(DW_OP_deref)), !dbg !290
  call void @llvm.dbg.value(metadata %T4main1TV13TangentVectorV* %2, metadata !291, metadata !DIExpression(DW_OP_deref)), !dbg !290
  %4 = bitcast %T4main1TV13TangentVectorV* %1 to %T1M1SV1CC**, !dbg !283
  %.sroa.0125.0.copyload160 = load %T1M1SV1CC*, %T1M1SV1CC** %4, align 8, !dbg !283
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !278, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !282
  %.sroa.4127.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 0, i32 0, i32 1, !dbg !283
  %.sroa.4127.0..sroa_cast128 = bitcast %TSb* %.sroa.4127.0..sroa_idx to i8*, !dbg !283
  %5 = load i8, i8* %.sroa.4127.0..sroa_cast128, align 8, !dbg !283
  call void @llvm.dbg.value(metadata i8 %5, metadata !278, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !282
  %.sroa.5.sroa.3149.0..sroa.5.0..sroa_idx131.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 0, i32 2, i32 0, i32 0, !dbg !283
  %6 = bitcast %T1M1SV1CCySf_G** %.sroa.5.sroa.3149.0..sroa.5.0..sroa_idx131.sroa_idx to %T1M1SV1CC**, !dbg !283
  %.sroa.5.sroa.3149.0.copyload161 = load %T1M1SV1CC*, %T1M1SV1CC** %6, align 1, !dbg !283
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !278, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !282
  %.sroa.5.sroa.4151.0..sroa.5.0..sroa_idx131.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 0, i32 2, i32 0, i32 1, !dbg !283
  %.sroa.5.sroa.4151.0..sroa.5.0..sroa_idx131.sroa_cast = bitcast %TSb* %.sroa.5.sroa.4151.0..sroa.5.0..sroa_idx131.sroa_idx to i8*, !dbg !283
  %7 = load i8, i8* %.sroa.5.sroa.4151.0..sroa.5.0..sroa_idx131.sroa_cast, align 1, !dbg !283
  %8 = bitcast %T4main1TV13TangentVectorV* %2 to %T1M1SV1CC**, !dbg !283
  %.sroa.090.0.copyload162 = load %T1M1SV1CC*, %T1M1SV1CC** %8, align 8, !dbg !283
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !288, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !282
  %.sroa.492.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %2, i64 0, i32 0, i32 0, i32 1, !dbg !283
  %.sroa.492.0..sroa_cast93 = bitcast %TSb* %.sroa.492.0..sroa_idx to i8*, !dbg !283
  %9 = load i8, i8* %.sroa.492.0..sroa_cast93, align 8, !dbg !283
  call void @llvm.dbg.value(metadata i8 %9, metadata !288, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !282
  %.sroa.5.sroa.3114.0..sroa.5.0..sroa_idx96.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %2, i64 0, i32 0, i32 2, i32 0, i32 0, !dbg !283
  %10 = bitcast %T1M1SV1CCySf_G** %.sroa.5.sroa.3114.0..sroa.5.0..sroa_idx96.sroa_idx to %T1M1SV1CC**, !dbg !283
  %.sroa.5.sroa.3114.0.copyload163 = load %T1M1SV1CC*, %T1M1SV1CC** %10, align 1, !dbg !283
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !288, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !282
  %.sroa.5.sroa.4116.0..sroa.5.0..sroa_idx96.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %2, i64 0, i32 0, i32 2, i32 0, i32 1, !dbg !283
  %.sroa.5.sroa.4116.0..sroa.5.0..sroa_idx96.sroa_cast = bitcast %TSb* %.sroa.5.sroa.4116.0..sroa.5.0..sroa_idx96.sroa_idx to i8*, !dbg !283
  %11 = load i8, i8* %.sroa.5.sroa.4116.0..sroa.5.0..sroa_idx96.sroa_cast, align 1, !dbg !283
  %12 = and i8 %5, 1, !dbg !292
  %13 = icmp ne i8 %12, 0, !dbg !292
  call void @llvm.dbg.value(metadata i1 %13, metadata !278, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !282
  %14 = and i8 %9, 1, !dbg !292
  %15 = icmp ne i8 %14, 0, !dbg !292
  call void @llvm.dbg.value(metadata i1 %15, metadata !288, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !282
  %16 = tail call swiftcc { %T1M1SV1CC*, i1 } %3(%T1M1SV1CC* %.sroa.0125.0.copyload160, i1 %13, %T1M1SV1CC* %.sroa.090.0.copyload162, i1 %15, %swift.type* nonnull @"$sSfN"), !dbg !292
  %17 = extractvalue { %T1M1SV1CC*, i1 } %16, 0, !dbg !292
  %18 = extractvalue { %T1M1SV1CC*, i1 } %16, 1, !dbg !292
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !294, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !298
  call void @llvm.dbg.value(metadata i8 %7, metadata !294, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !298
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !299, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !298
  call void @llvm.dbg.value(metadata i8 %11, metadata !299, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !298
  %19 = and i8 %7, 1, !dbg !300
  %20 = icmp ne i8 %19, 0, !dbg !300
  call void @llvm.dbg.value(metadata i1 %20, metadata !294, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !298
  %21 = and i8 %11, 1, !dbg !300
  %22 = icmp ne i8 %21, 0, !dbg !300
  call void @llvm.dbg.value(metadata i1 %22, metadata !299, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !298
  %23 = tail call swiftcc { %T1M1SV1CC*, i1 } %3(%T1M1SV1CC* %.sroa.5.sroa.3149.0.copyload161, i1 %20, %T1M1SV1CC* %.sroa.5.sroa.3114.0.copyload163, i1 %22, %swift.type* nonnull @"$sSfN"), !dbg !300
  %24 = extractvalue { %T1M1SV1CC*, i1 } %23, 0, !dbg !300
  %25 = extractvalue { %T1M1SV1CC*, i1 } %23, 1, !dbg !300
  %.sroa.055.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 0, !dbg !283
  %26 = bitcast %T1M1SV1CCySf_G** %.sroa.055.0..sroa_idx to %T1M1SV1CC**, !dbg !283
  %.sroa.055.0.copyload164 = load %T1M1SV1CC*, %T1M1SV1CC** %26, align 8, !dbg !283
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !278, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !282
  %.sroa.457.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 1, !dbg !283
  %.sroa.457.0..sroa_cast58 = bitcast %TSb* %.sroa.457.0..sroa_idx to i8*, !dbg !283
  %27 = load i8, i8* %.sroa.457.0..sroa_cast58, align 8, !dbg !283
  call void @llvm.dbg.value(metadata i8 %27, metadata !278, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !282
  %.sroa.5.sroa.379.0..sroa.5.0..sroa_idx61.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 2, i32 0, i32 0, !dbg !283
  %28 = bitcast %T1M1SV1CCySf_G** %.sroa.5.sroa.379.0..sroa.5.0..sroa_idx61.sroa_idx to %T1M1SV1CC**, !dbg !283
  %.sroa.5.sroa.379.0.copyload165 = load %T1M1SV1CC*, %T1M1SV1CC** %28, align 1, !dbg !283
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !278, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !282
  %.sroa.5.sroa.481.0..sroa.5.0..sroa_idx61.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 2, i32 0, i32 1, !dbg !283
  %.sroa.5.sroa.481.0..sroa.5.0..sroa_idx61.sroa_cast = bitcast %TSb* %.sroa.5.sroa.481.0..sroa.5.0..sroa_idx61.sroa_idx to i8*, !dbg !283
  %29 = load i8, i8* %.sroa.5.sroa.481.0..sroa.5.0..sroa_idx61.sroa_cast, align 1, !dbg !283
  %.sroa.0.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %2, i64 0, i32 2, i32 0, i32 0, !dbg !283
  %30 = bitcast %T1M1SV1CCySf_G** %.sroa.0.0..sroa_idx to %T1M1SV1CC**, !dbg !283
  %.sroa.0.0.copyload166 = load %T1M1SV1CC*, %T1M1SV1CC** %30, align 8, !dbg !283
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !288, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !282
  %.sroa.4.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %2, i64 0, i32 2, i32 0, i32 1, !dbg !283
  %.sroa.4.0..sroa_cast26 = bitcast %TSb* %.sroa.4.0..sroa_idx to i8*, !dbg !283
  %31 = load i8, i8* %.sroa.4.0..sroa_cast26, align 8, !dbg !283
  call void @llvm.dbg.value(metadata i8 %31, metadata !288, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !282
  %.sroa.5.sroa.3.0..sroa.5.0..sroa_idx29.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %2, i64 0, i32 2, i32 2, i32 0, i32 0, !dbg !283
  %32 = bitcast %T1M1SV1CCySf_G** %.sroa.5.sroa.3.0..sroa.5.0..sroa_idx29.sroa_idx to %T1M1SV1CC**, !dbg !283
  %.sroa.5.sroa.3.0.copyload167 = load %T1M1SV1CC*, %T1M1SV1CC** %32, align 1, !dbg !283
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !288, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !282
  %.sroa.5.sroa.4.0..sroa.5.0..sroa_idx29.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %2, i64 0, i32 2, i32 2, i32 0, i32 1, !dbg !283
  %.sroa.5.sroa.4.0..sroa.5.0..sroa_idx29.sroa_cast = bitcast %TSb* %.sroa.5.sroa.4.0..sroa.5.0..sroa_idx29.sroa_idx to i8*, !dbg !283
  %33 = load i8, i8* %.sroa.5.sroa.4.0..sroa.5.0..sroa_idx29.sroa_cast, align 1, !dbg !283
  %34 = and i8 %27, 1, !dbg !302
  %35 = icmp ne i8 %34, 0, !dbg !302
  call void @llvm.dbg.value(metadata i1 %35, metadata !278, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !282
  %36 = and i8 %31, 1, !dbg !302
  %37 = icmp ne i8 %36, 0, !dbg !302
  call void @llvm.dbg.value(metadata i1 %37, metadata !288, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !282
  %38 = tail call swiftcc { %T1M1SV1CC*, i1 } %3(%T1M1SV1CC* %.sroa.055.0.copyload164, i1 %35, %T1M1SV1CC* %.sroa.0.0.copyload166, i1 %37, %swift.type* nonnull @"$sSfN"), !dbg !302
  %39 = extractvalue { %T1M1SV1CC*, i1 } %38, 0, !dbg !302
  %40 = extractvalue { %T1M1SV1CC*, i1 } %38, 1, !dbg !302
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !294, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !304
  call void @llvm.dbg.value(metadata i8 %29, metadata !294, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !304
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !299, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !304
  call void @llvm.dbg.value(metadata i8 %33, metadata !299, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !304
  %41 = and i8 %29, 1, !dbg !305
  %42 = icmp ne i8 %41, 0, !dbg !305
  call void @llvm.dbg.value(metadata i1 %42, metadata !294, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !304
  %43 = and i8 %33, 1, !dbg !305
  %44 = icmp ne i8 %43, 0, !dbg !305
  call void @llvm.dbg.value(metadata i1 %44, metadata !299, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !304
  %45 = tail call swiftcc { %T1M1SV1CC*, i1 } %3(%T1M1SV1CC* %.sroa.5.sroa.379.0.copyload165, i1 %42, %T1M1SV1CC* %.sroa.5.sroa.3.0.copyload167, i1 %44, %swift.type* nonnull @"$sSfN"), !dbg !305
  %46 = extractvalue { %T1M1SV1CC*, i1 } %45, 0, !dbg !305
  %47 = extractvalue { %T1M1SV1CC*, i1 } %45, 1, !dbg !305
  %48 = bitcast %T4main1TV13TangentVectorV* %0 to %T1M1SV1CC**, !dbg !283
  store %T1M1SV1CC* %17, %T1M1SV1CC** %48, align 8, !dbg !283
  %.u123.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 0, i32 1, i32 0, !dbg !283
  store i1 %18, i1* %.u123.s.b._value, align 8, !dbg !283
  %.u123.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, !dbg !283
  %49 = bitcast %T1M1SVySfG* %.u123.v.s to %T1M1SV1CC**, !dbg !283
  store %T1M1SV1CC* %24, %T1M1SV1CC** %49, align 8, !dbg !283
  %.u123.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, i32 1, i32 0, !dbg !283
  store i1 %25, i1* %.u123.v.s.b._value, align 8, !dbg !283
  %.u224 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, !dbg !283
  %50 = bitcast %T4main1UV13TangentVectorV* %.u224 to %T1M1SV1CC**, !dbg !283
  store %T1M1SV1CC* %39, %T1M1SV1CC** %50, align 8, !dbg !283
  %.u224.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !283
  store i1 %40, i1* %.u224.s.b._value, align 8, !dbg !283
  %.u224.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, !dbg !283
  %51 = bitcast %T1M1SVySfG* %.u224.v.s to %T1M1SV1CC**, !dbg !283
  store %T1M1SV1CC* %46, %T1M1SV1CC** %51, align 8, !dbg !283
  %.u224.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !283
  store i1 %47, i1* %.u224.v.s.b._value, align 8, !dbg !283
  ret void, !dbg !283
}
define hidden swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV1soiyA2E_AEtFZ"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3, %T1M1SV1CCySf_G* %4, i1 %5, %T1M1SV1CCySf_G* %6, i1 %7) local_unnamed_addr #2 {
  %9 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV1poiyA2E_AEtFZTm"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3, %T1M1SV1CCySf_G* %4, i1 %5, %T1M1SV1CCySf_G* %6, i1 %7, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* @"$s1M1SV1soiyACyxGAE_AEtFZ") #2
  %10 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %9, 0
  %11 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } undef, %T1M1SV1CCySf_G* %10, 0
  %12 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %9, 1
  %13 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %11, i1 %12, 1
  %14 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %9, 2
  %15 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %13, %T1M1SV1CCySf_G* %14, 2
  %16 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %9, 3
  %17 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %15, i1 %16, 3
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %17
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV1poiyA2E_AEtFZTm"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3, %T1M1SV1CCySf_G* %4, i1 %5, %T1M1SV1CCySf_G* %6, i1 %7, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* %8) local_unnamed_addr #2 {
entry:
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %0, metadata !278, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !307
  call void @llvm.dbg.value(metadata i1 %1, metadata !278, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !307
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %2, metadata !278, metadata !DIExpression(DW_OP_LLVM_fragment, 65, 64)), !dbg !307
  call void @llvm.dbg.value(metadata i1 %3, metadata !278, metadata !DIExpression(DW_OP_LLVM_fragment, 129, 1)), !dbg !307
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %4, metadata !288, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !307
  call void @llvm.dbg.value(metadata i1 %5, metadata !288, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !307
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %6, metadata !288, metadata !DIExpression(DW_OP_LLVM_fragment, 65, 64)), !dbg !307
  call void @llvm.dbg.value(metadata i1 %7, metadata !288, metadata !DIExpression(DW_OP_LLVM_fragment, 129, 1)), !dbg !307
  %.asUnsubstituted = bitcast %T1M1SV1CCySf_G* %0 to %T1M1SV1CC*, !dbg !308
  %.asUnsubstituted1 = bitcast %T1M1SV1CCySf_G* %4 to %T1M1SV1CC*, !dbg !308
  %9 = tail call swiftcc { %T1M1SV1CC*, i1 } %8(%T1M1SV1CC* %.asUnsubstituted, i1 %1, %T1M1SV1CC* %.asUnsubstituted1, i1 %5, %swift.type* nonnull @"$sSfN"), !dbg !308
  %10 = extractvalue { %T1M1SV1CC*, i1 } %9, 0, !dbg !308
  %11 = extractvalue { %T1M1SV1CC*, i1 } %9, 1, !dbg !308
  %.asSubstituted = bitcast %T1M1SV1CC* %10 to %T1M1SV1CCySf_G*, !dbg !308
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %2, metadata !294, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !310
  call void @llvm.dbg.value(metadata i1 %3, metadata !294, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !310
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %6, metadata !299, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !310
  call void @llvm.dbg.value(metadata i1 %7, metadata !299, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !310
  %.asUnsubstituted2 = bitcast %T1M1SV1CCySf_G* %2 to %T1M1SV1CC*, !dbg !311
  %.asUnsubstituted3 = bitcast %T1M1SV1CCySf_G* %6 to %T1M1SV1CC*, !dbg !311
  %12 = tail call swiftcc { %T1M1SV1CC*, i1 } %8(%T1M1SV1CC* %.asUnsubstituted2, i1 %3, %T1M1SV1CC* %.asUnsubstituted3, i1 %7, %swift.type* nonnull @"$sSfN"), !dbg !311
  %13 = extractvalue { %T1M1SV1CC*, i1 } %12, 0, !dbg !311
  %14 = extractvalue { %T1M1SV1CC*, i1 } %12, 1, !dbg !311
  %.asSubstituted4 = bitcast %T1M1SV1CC* %13 to %T1M1SV1CCySf_G*, !dbg !311
  %15 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } undef, %T1M1SV1CCySf_G* %.asSubstituted, 0, !dbg !308
  %16 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %15, i1 %11, 1, !dbg !308
  %17 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %16, %T1M1SV1CCySf_G* %.asSubstituted4, 2, !dbg !308
  %18 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %17, i1 %14, 3, !dbg !308
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %18, !dbg !308
}
define hidden swiftcc i1 @"$s4main1TV13TangentVectorV23__derived_struct_equalsySbAE_AEtFZ"(%T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %0, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %1) local_unnamed_addr #2 !dbg !313 {
entry:
  call void @llvm.dbg.declare(metadata %TSb* undef, metadata !318, metadata !DIExpression(DW_OP_LLVM_fragment, 192, 8)), !dbg !322
  call void @llvm.dbg.declare(metadata %TSb* undef, metadata !325, metadata !DIExpression(DW_OP_LLVM_fragment, 192, 8)), !dbg !322
  call void @llvm.dbg.declare(metadata %TSb* undef, metadata !318, metadata !DIExpression(DW_OP_LLVM_fragment, 192, 8)), !dbg !322
  call void @llvm.dbg.declare(metadata %TSb* undef, metadata !325, metadata !DIExpression(DW_OP_LLVM_fragment, 192, 8)), !dbg !322
  call void @llvm.dbg.value(metadata %T4main1TV13TangentVectorV* %0, metadata !326, metadata !DIExpression(DW_OP_deref)), !dbg !327
  call void @llvm.dbg.value(metadata %T4main1TV13TangentVectorV* %1, metadata !328, metadata !DIExpression(DW_OP_deref)), !dbg !327
  %2 = bitcast %T4main1TV13TangentVectorV* %0 to %T1M1SV1CC**, !dbg !323
  %.sroa.0120.0.copyload155 = load %T1M1SV1CC*, %T1M1SV1CC** %2, align 8, !dbg !323
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !318, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !322
  %.sroa.4122.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 0, i32 1, !dbg !323
  %.sroa.4122.0..sroa_cast123 = bitcast %TSb* %.sroa.4122.0..sroa_idx to i8*, !dbg !323
  %3 = load i8, i8* %.sroa.4122.0..sroa_cast123, align 8, !dbg !323
  call void @llvm.dbg.value(metadata i8 %3, metadata !318, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !322
  %.sroa.5.sroa.3144.0..sroa.5.0..sroa_idx126.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, i32 0, !dbg !323
  %4 = bitcast %T1M1SV1CCySf_G** %.sroa.5.sroa.3144.0..sroa.5.0..sroa_idx126.sroa_idx to %T1M1SV1CC**, !dbg !323
  %.sroa.5.sroa.3144.0.copyload156 = load %T1M1SV1CC*, %T1M1SV1CC** %4, align 1, !dbg !323
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !318, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !322
  %.sroa.5.sroa.4146.0..sroa.5.0..sroa_idx126.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, i32 1, !dbg !323
  %.sroa.5.sroa.4146.0..sroa.5.0..sroa_idx126.sroa_cast = bitcast %TSb* %.sroa.5.sroa.4146.0..sroa.5.0..sroa_idx126.sroa_idx to i8*, !dbg !323
  %5 = load i8, i8* %.sroa.5.sroa.4146.0..sroa.5.0..sroa_idx126.sroa_cast, align 1, !dbg !323
  %6 = bitcast %T4main1TV13TangentVectorV* %1 to %T1M1SV1CC**, !dbg !323
  %.sroa.085.0.copyload157 = load %T1M1SV1CC*, %T1M1SV1CC** %6, align 8, !dbg !323
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !325, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !322
  %.sroa.487.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 0, i32 0, i32 1, !dbg !323
  %.sroa.487.0..sroa_cast88 = bitcast %TSb* %.sroa.487.0..sroa_idx to i8*, !dbg !323
  %7 = load i8, i8* %.sroa.487.0..sroa_cast88, align 8, !dbg !323
  call void @llvm.dbg.value(metadata i8 %7, metadata !325, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !322
  %.sroa.5.sroa.3109.0..sroa.5.0..sroa_idx91.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 0, i32 2, i32 0, i32 0, !dbg !323
  %8 = bitcast %T1M1SV1CCySf_G** %.sroa.5.sroa.3109.0..sroa.5.0..sroa_idx91.sroa_idx to %T1M1SV1CC**, !dbg !323
  %.sroa.5.sroa.3109.0.copyload158 = load %T1M1SV1CC*, %T1M1SV1CC** %8, align 1, !dbg !323
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !325, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !322
  %.sroa.5.sroa.4111.0..sroa.5.0..sroa_idx91.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 0, i32 2, i32 0, i32 1, !dbg !323
  %.sroa.5.sroa.4111.0..sroa.5.0..sroa_idx91.sroa_cast = bitcast %TSb* %.sroa.5.sroa.4111.0..sroa.5.0..sroa_idx91.sroa_idx to i8*, !dbg !323
  %9 = load i8, i8* %.sroa.5.sroa.4111.0..sroa.5.0..sroa_idx91.sroa_cast, align 1, !dbg !323
  %10 = and i8 %3, 1, !dbg !329
  %11 = icmp ne i8 %10, 0, !dbg !329
  call void @llvm.dbg.value(metadata i1 %11, metadata !318, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !322
  %12 = and i8 %7, 1, !dbg !329
  %13 = icmp ne i8 %12, 0, !dbg !329
  call void @llvm.dbg.value(metadata i1 %13, metadata !325, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !322
  %14 = tail call swiftcc i1 @"$s1M1SV2eeoiySbACyxG_AEtFZ"(%T1M1SV1CC* %.sroa.0120.0.copyload155, i1 %11, %T1M1SV1CC* %.sroa.085.0.copyload157, i1 %13, %swift.type* nonnull @"$sSfN"), !dbg !329
  br i1 %14, label %15, label %42, !dbg !329

15:                                               ; preds = %entry
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !331, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !335
  call void @llvm.dbg.value(metadata i8 %5, metadata !331, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !335
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !336, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !335
  call void @llvm.dbg.value(metadata i8 %9, metadata !336, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !335
  %16 = and i8 %5, 1, !dbg !337
  %17 = icmp ne i8 %16, 0, !dbg !337
  call void @llvm.dbg.value(metadata i1 %17, metadata !331, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !335
  %18 = and i8 %9, 1, !dbg !337
  %19 = icmp ne i8 %18, 0, !dbg !337
  call void @llvm.dbg.value(metadata i1 %19, metadata !336, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !335
  %20 = tail call swiftcc i1 @"$s1M1SV2eeoiySbACyxG_AEtFZ"(%T1M1SV1CC* %.sroa.5.sroa.3144.0.copyload156, i1 %17, %T1M1SV1CC* %.sroa.5.sroa.3109.0.copyload158, i1 %19, %swift.type* nonnull @"$sSfN"), !dbg !337
  br i1 %20, label %21, label %42, !dbg !337

21:                                               ; preds = %15
  %.sroa.050.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 0, !dbg !323
  %22 = bitcast %T1M1SV1CCySf_G** %.sroa.050.0..sroa_idx to %T1M1SV1CC**, !dbg !323
  %.sroa.050.0.copyload159 = load %T1M1SV1CC*, %T1M1SV1CC** %22, align 8, !dbg !323
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !318, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !322
  %.sroa.452.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, !dbg !323
  %.sroa.452.0..sroa_cast54 = bitcast %TSb* %.sroa.452.0..sroa_idx to i8*, !dbg !323
  %23 = load i8, i8* %.sroa.452.0..sroa_cast54, align 8, !dbg !323
  call void @llvm.dbg.value(metadata i8 %23, metadata !318, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !322
  %.sroa.5.sroa.374.0..sroa.5.0..sroa_idx57.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 0, !dbg !323
  %24 = bitcast %T1M1SV1CCySf_G** %.sroa.5.sroa.374.0..sroa.5.0..sroa_idx57.sroa_idx to %T1M1SV1CC**, !dbg !323
  %.sroa.5.sroa.374.0.copyload160 = load %T1M1SV1CC*, %T1M1SV1CC** %24, align 1, !dbg !323
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !318, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !322
  %.sroa.5.sroa.476.0..sroa.5.0..sroa_idx57.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 1, !dbg !323
  %.sroa.5.sroa.476.0..sroa.5.0..sroa_idx57.sroa_cast = bitcast %TSb* %.sroa.5.sroa.476.0..sroa.5.0..sroa_idx57.sroa_idx to i8*, !dbg !323
  %25 = load i8, i8* %.sroa.5.sroa.476.0..sroa.5.0..sroa_idx57.sroa_cast, align 1, !dbg !323
  %.sroa.0.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 0, !dbg !323
  %26 = bitcast %T1M1SV1CCySf_G** %.sroa.0.0..sroa_idx to %T1M1SV1CC**, !dbg !323
  %.sroa.0.0.copyload161 = load %T1M1SV1CC*, %T1M1SV1CC** %26, align 8, !dbg !323
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !325, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !322
  %.sroa.4.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 1, !dbg !323
  %.sroa.4.0..sroa_cast22 = bitcast %TSb* %.sroa.4.0..sroa_idx to i8*, !dbg !323
  %27 = load i8, i8* %.sroa.4.0..sroa_cast22, align 8, !dbg !323
  call void @llvm.dbg.value(metadata i8 %27, metadata !325, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !322
  %.sroa.5.sroa.3.0..sroa.5.0..sroa_idx25.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 2, i32 0, i32 0, !dbg !323
  %28 = bitcast %T1M1SV1CCySf_G** %.sroa.5.sroa.3.0..sroa.5.0..sroa_idx25.sroa_idx to %T1M1SV1CC**, !dbg !323
  %.sroa.5.sroa.3.0.copyload162 = load %T1M1SV1CC*, %T1M1SV1CC** %28, align 1, !dbg !323
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !325, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !322
  %.sroa.5.sroa.4.0..sroa.5.0..sroa_idx25.sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 2, i32 0, i32 1, !dbg !323
  %.sroa.5.sroa.4.0..sroa.5.0..sroa_idx25.sroa_cast = bitcast %TSb* %.sroa.5.sroa.4.0..sroa.5.0..sroa_idx25.sroa_idx to i8*, !dbg !323
  %29 = load i8, i8* %.sroa.5.sroa.4.0..sroa.5.0..sroa_idx25.sroa_cast, align 1, !dbg !323
  %30 = and i8 %23, 1, !dbg !339
  %31 = icmp ne i8 %30, 0, !dbg !339
  call void @llvm.dbg.value(metadata i1 %31, metadata !318, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !322
  %32 = and i8 %27, 1, !dbg !339
  %33 = icmp ne i8 %32, 0, !dbg !339
  call void @llvm.dbg.value(metadata i1 %33, metadata !325, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !322
  %34 = tail call swiftcc i1 @"$s1M1SV2eeoiySbACyxG_AEtFZ"(%T1M1SV1CC* %.sroa.050.0.copyload159, i1 %31, %T1M1SV1CC* %.sroa.0.0.copyload161, i1 %33, %swift.type* nonnull @"$sSfN"), !dbg !339
  br i1 %34, label %35, label %41, !dbg !339

35:                                               ; preds = %21
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !331, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !341
  call void @llvm.dbg.value(metadata i8 %25, metadata !331, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !341
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !336, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !341
  call void @llvm.dbg.value(metadata i8 %29, metadata !336, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !341
  %36 = and i8 %25, 1, !dbg !342
  %37 = icmp ne i8 %36, 0, !dbg !342
  call void @llvm.dbg.value(metadata i1 %37, metadata !331, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !341
  %38 = and i8 %29, 1, !dbg !342
  %39 = icmp ne i8 %38, 0, !dbg !342
  call void @llvm.dbg.value(metadata i1 %39, metadata !336, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !341
  %40 = tail call swiftcc i1 @"$s1M1SV2eeoiySbACyxG_AEtFZ"(%T1M1SV1CC* %.sroa.5.sroa.374.0.copyload160, i1 %37, %T1M1SV1CC* %.sroa.5.sroa.3.0.copyload162, i1 %39, %swift.type* nonnull @"$sSfN"), !dbg !342
  br i1 %40, label %42, label %41, !dbg !342

41:                                               ; preds = %35, %21
  br label %42, !dbg !344

42:                                               ; preds = %entry, %15, %35, %41
  %43 = phi i1 [ false, %41 ], [ true, %35 ], [ false, %15 ], [ false, %entry ], !dbg !323
  ret i1 %43, !dbg !323
}
define hidden swiftcc i1 @"$s4main1UV13TangentVectorV23__derived_struct_equalsySbAE_AEtFZ"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3, %T1M1SV1CCySf_G* %4, i1 %5, %T1M1SV1CCySf_G* %6, i1 %7) local_unnamed_addr #2 !dbg !319 {
entry:
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %0, metadata !318, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !346
  call void @llvm.dbg.value(metadata i1 %1, metadata !318, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !346
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %2, metadata !318, metadata !DIExpression(DW_OP_LLVM_fragment, 65, 64)), !dbg !346
  call void @llvm.dbg.value(metadata i1 %3, metadata !318, metadata !DIExpression(DW_OP_LLVM_fragment, 129, 1)), !dbg !346
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %4, metadata !325, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !346
  call void @llvm.dbg.value(metadata i1 %5, metadata !325, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !346
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %6, metadata !325, metadata !DIExpression(DW_OP_LLVM_fragment, 65, 64)), !dbg !346
  call void @llvm.dbg.value(metadata i1 %7, metadata !325, metadata !DIExpression(DW_OP_LLVM_fragment, 129, 1)), !dbg !346
  %.asUnsubstituted = bitcast %T1M1SV1CCySf_G* %0 to %T1M1SV1CC*, !dbg !347
  %.asUnsubstituted1 = bitcast %T1M1SV1CCySf_G* %4 to %T1M1SV1CC*, !dbg !347
  %8 = tail call swiftcc i1 @"$s1M1SV2eeoiySbACyxG_AEtFZ"(%T1M1SV1CC* %.asUnsubstituted, i1 %1, %T1M1SV1CC* %.asUnsubstituted1, i1 %5, %swift.type* nonnull @"$sSfN"), !dbg !347
  br i1 %8, label %9, label %11, !dbg !347

9:                                                ; preds = %entry
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %2, metadata !331, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !349
  call void @llvm.dbg.value(metadata i1 %3, metadata !331, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !349
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %6, metadata !336, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !349
  call void @llvm.dbg.value(metadata i1 %7, metadata !336, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !349
  %.asUnsubstituted2 = bitcast %T1M1SV1CCySf_G* %2 to %T1M1SV1CC*, !dbg !350
  %.asUnsubstituted3 = bitcast %T1M1SV1CCySf_G* %6 to %T1M1SV1CC*, !dbg !350
  %10 = tail call swiftcc i1 @"$s1M1SV2eeoiySbACyxG_AEtFZ"(%T1M1SV1CC* %.asUnsubstituted2, i1 %3, %T1M1SV1CC* %.asUnsubstituted3, i1 %7, %swift.type* nonnull @"$sSfN"), !dbg !350
  br label %11, !dbg !347

11:                                               ; preds = %entry, %9
  %12 = phi i1 [ %10, %9 ], [ false, %entry ], !dbg !347
  ret i1 %12, !dbg !347
}
define internal swiftcc void @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAafGP4move5alongyADQz_tFTW"(%T4main1TV13TangentVectorV* noalias nocapture dereferenceable(57) %0, %T4main1TV13TangentVectorV* nocapture swiftself dereferenceable(57) %1, %swift.type* %Self, i8** %SelfWitnessTable) #2 !dbg !352 {
entry:
  %2 = bitcast %T4main1TV13TangentVectorV* %0 to %swift.opaque*, !dbg !355
  %3 = bitcast %T4main1TV13TangentVectorV* %1 to %swift.opaque*, !dbg !355
  tail call swiftcc void @"$s16_Differentiation14DifferentiablePAA13TangentVectorACQzRszrlE4move5alongyx_tF"(%swift.opaque* noalias nocapture nonnull %2, %swift.type* %Self, i8** %SelfWitnessTable, %swift.opaque* nocapture nonnull swiftself %3) #16, !dbg !355
  ret void, !dbg !355
}
define linkonce_odr hidden swiftcc void @"$s16_Differentiation14DifferentiablePAA13TangentVectorACQzRszrlE4move5alongyx_tF"(%swift.opaque* noalias nocapture %0, %swift.type* %Self, i8** %Self.Differentiable, %swift.opaque* nocapture swiftself %1) local_unnamed_addr #2 !dbg !356 {
entry:
  call void @llvm.dbg.value(metadata %swift.type* %Self, metadata !360, metadata !DIExpression()), !dbg !364
  %Self.AdditiveArithmetic = tail call swiftcc i8** @swift_getAssociatedConformanceWitness(i8** %Self.Differentiable, %swift.type* %Self, %swift.type* %Self, %swift.protocol_requirement* nonnull @"$s16_Differentiation14DifferentiableTL", %swift.protocol_requirement* nonnull @"$s16_Differentiation14DifferentiableP13TangentVectorAC_s18AdditiveArithmeticTn") #15, !dbg !364
  tail call swiftcc void @"$ss18AdditiveArithmeticP2peoiyyxz_xtFZTj"(%swift.opaque* nocapture %1, %swift.opaque* noalias nocapture %0, %swift.type* swiftself %Self, %swift.type* %Self, i8** %Self.AdditiveArithmetic), !dbg !364
  ret void, !dbg !364
}
define internal swiftcc { i8*, %swift.refcounted* } @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAafGP04zerobC11InitializerADQzycvgTW"(%T4main1TV13TangentVectorV* noalias nocapture readonly swiftself dereferenceable(57) %0, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 !dbg !365 {
entry:
  %1 = bitcast %T4main1TV13TangentVectorV* %0 to %T1M1SV1CC**, !dbg !366
  %2 = load %T1M1SV1CC*, %T1M1SV1CC** %1, align 8, !dbg !366
  %.u1.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 0, i32 1, i32 0, !dbg !366
  %3 = load i1, i1* %.u1.s.b._value, align 8, !dbg !366
  %.u1.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, !dbg !366
  %4 = bitcast %T1M1SVySfG* %.u1.v.s to %T1M1SV1CC**, !dbg !366
  %5 = load %T1M1SV1CC*, %T1M1SV1CC** %4, align 8, !dbg !366
  %.u1.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, i32 1, i32 0, !dbg !366
  %6 = load i1, i1* %.u1.v.s.b._value, align 8, !dbg !366
  %.u2 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, !dbg !366
  %7 = bitcast %T4main1UV13TangentVectorV* %.u2 to %T1M1SV1CC**, !dbg !366
  %8 = load %T1M1SV1CC*, %T1M1SV1CC** %7, align 8, !dbg !366
  %.u2.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !366
  %9 = load i1, i1* %.u2.s.b._value, align 8, !dbg !366
  %.u2.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, !dbg !366
  %10 = bitcast %T1M1SVySfG* %.u2.v.s to %T1M1SV1CC**, !dbg !366
  %11 = load %T1M1SV1CC*, %T1M1SV1CC** %10, align 8, !dbg !366
  %.u2.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !366
  %12 = load i1, i1* %.u2.v.s.b._value, align 8, !dbg !366
  %13 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %2, i1 %3, %swift.type* nonnull @"$sSfN") #16, !dbg !367
  %14 = extractvalue { i8*, %swift.refcounted* } %13, 0, !dbg !367
  %15 = extractvalue { i8*, %swift.refcounted* } %13, 1, !dbg !367
  call void @llvm.dbg.value(metadata i8* %14, metadata !373, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !367
  call void @llvm.dbg.value(metadata %swift.refcounted* %15, metadata !373, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !367
  %16 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %5, i1 %6, %swift.type* nonnull @"$sSfN") #16, !dbg !374
  %17 = extractvalue { i8*, %swift.refcounted* } %16, 0, !dbg !374
  %18 = extractvalue { i8*, %swift.refcounted* } %16, 1, !dbg !374
  call void @llvm.dbg.value(metadata i8* %17, metadata !377, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !374
  call void @llvm.dbg.value(metadata %swift.refcounted* %18, metadata !377, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !374
  %19 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.119, i64 0, i32 2), i64 32, i64 7) #0, !dbg !374
  %20 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %19, i64 1, !dbg !374
  %.fn = bitcast %swift.refcounted* %20 to i8**, !dbg !374
  store i8* %17, i8** %.fn, align 8, !dbg !374
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %19, i64 1, i32 1, !dbg !374
  %21 = bitcast i64* %.data to %swift.refcounted**, !dbg !374
  store %swift.refcounted* %18, %swift.refcounted** %21, align 8, !dbg !374
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.120" to i8*), metadata !378, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !367
  call void @llvm.dbg.value(metadata %swift.refcounted* %19, metadata !378, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !367
  %22 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.123, i64 0, i32 2), i64 48, i64 7) #0, !dbg !367
  %23 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %22, i64 1, !dbg !367
  %.fn2 = bitcast %swift.refcounted* %23 to i8**, !dbg !367
  store i8* %14, i8** %.fn2, align 8, !dbg !367
  %.data3 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %22, i64 1, i32 1, !dbg !367
  %24 = bitcast i64* %.data3 to %swift.refcounted**, !dbg !367
  store %swift.refcounted* %15, %swift.refcounted** %24, align 8, !dbg !367
  %25 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %22, i64 2, !dbg !367
  %.fn4 = bitcast %swift.refcounted* %25 to i8**, !dbg !367
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.120" to i8*), i8** %.fn4, align 8, !dbg !367
  %.data5 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %22, i64 2, i32 1, !dbg !367
  %26 = bitcast i64* %.data5 to %swift.refcounted**, !dbg !367
  store %swift.refcounted* %19, %swift.refcounted** %26, align 8, !dbg !367
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.124" to i8*), metadata !379, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !370
  call void @llvm.dbg.value(metadata %swift.refcounted* %22, metadata !379, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !370
  %27 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %8, i1 %9, %swift.type* nonnull @"$sSfN") #16, !dbg !380
  %28 = extractvalue { i8*, %swift.refcounted* } %27, 0, !dbg !380
  %29 = extractvalue { i8*, %swift.refcounted* } %27, 1, !dbg !380
  call void @llvm.dbg.value(metadata i8* %28, metadata !383, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !380
  call void @llvm.dbg.value(metadata %swift.refcounted* %29, metadata !383, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !380
  %30 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %11, i1 %12, %swift.type* nonnull @"$sSfN") #16, !dbg !384
  %31 = extractvalue { i8*, %swift.refcounted* } %30, 0, !dbg !384
  %32 = extractvalue { i8*, %swift.refcounted* } %30, 1, !dbg !384
  call void @llvm.dbg.value(metadata i8* %31, metadata !387, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !384
  call void @llvm.dbg.value(metadata %swift.refcounted* %32, metadata !387, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !384
  %33 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.127, i64 0, i32 2), i64 32, i64 7) #0, !dbg !384
  %34 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %33, i64 1, !dbg !384
  %.fn8 = bitcast %swift.refcounted* %34 to i8**, !dbg !384
  store i8* %31, i8** %.fn8, align 8, !dbg !384
  %.data9 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %33, i64 1, i32 1, !dbg !384
  %35 = bitcast i64* %.data9 to %swift.refcounted**, !dbg !384
  store %swift.refcounted* %32, %swift.refcounted** %35, align 8, !dbg !384
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.128" to i8*), metadata !388, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !380
  call void @llvm.dbg.value(metadata %swift.refcounted* %33, metadata !388, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !380
  %36 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.131, i64 0, i32 2), i64 48, i64 7) #0, !dbg !380
  %37 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %36, i64 1, !dbg !380
  %.fn10 = bitcast %swift.refcounted* %37 to i8**, !dbg !380
  store i8* %28, i8** %.fn10, align 8, !dbg !380
  %.data11 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %36, i64 1, i32 1, !dbg !380
  %38 = bitcast i64* %.data11 to %swift.refcounted**, !dbg !380
  store %swift.refcounted* %29, %swift.refcounted** %38, align 8, !dbg !380
  %39 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %36, i64 2, !dbg !380
  %.fn12 = bitcast %swift.refcounted* %39 to i8**, !dbg !380
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.128" to i8*), i8** %.fn12, align 8, !dbg !380
  %.data13 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %36, i64 2, i32 1, !dbg !380
  %40 = bitcast i64* %.data13 to %swift.refcounted**, !dbg !380
  store %swift.refcounted* %33, %swift.refcounted** %40, align 8, !dbg !380
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.132" to i8*), metadata !389, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !370
  call void @llvm.dbg.value(metadata %swift.refcounted* %36, metadata !389, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !370
  %41 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.135, i64 0, i32 2), i64 48, i64 7) #0, !dbg !370
  %42 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %41, i64 1, !dbg !370
  %.fn14 = bitcast %swift.refcounted* %42 to i8**, !dbg !370
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.124" to i8*), i8** %.fn14, align 8, !dbg !370
  %.data15 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %41, i64 1, i32 1, !dbg !370
  %43 = bitcast i64* %.data15 to %swift.refcounted**, !dbg !370
  store %swift.refcounted* %22, %swift.refcounted** %43, align 8, !dbg !370
  %44 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %41, i64 2, !dbg !370
  %.fn16 = bitcast %swift.refcounted* %44 to i8**, !dbg !370
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.132" to i8*), i8** %.fn16, align 8, !dbg !370
  %.data17 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %41, i64 2, i32 1, !dbg !370
  %45 = bitcast i64* %.data17 to %swift.refcounted**, !dbg !370
  store %swift.refcounted* %36, %swift.refcounted** %45, align 8, !dbg !370
  %46 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.139, i64 0, i32 2), i64 32, i64 7) #0, !dbg !366
  %47 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %46, i64 1, !dbg !366
  %.fn18 = bitcast %swift.refcounted* %47 to i8**, !dbg !366
  store i8* bitcast (void (%T4main1TV13TangentVectorV*, %swift.refcounted*)* @"$s4main1TV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.136" to i8*), i8** %.fn18, align 8, !dbg !366
  %.data19 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %46, i64 1, i32 1, !dbg !366
  %48 = bitcast i64* %.data19 to %swift.refcounted**, !dbg !366
  store %swift.refcounted* %41, %swift.refcounted** %48, align 8, !dbg !366
  %49 = insertvalue { i8*, %swift.refcounted* } { i8* bitcast (void (%T4main1TV13TangentVectorV*, %swift.refcounted*)* @"$s4main1TV13TangentVectorVIego_AEIegr_TRTA.140" to i8*), %swift.refcounted* undef }, %swift.refcounted* %46, 1, !dbg !366
  ret { i8*, %swift.refcounted* } %49, !dbg !366
}
define internal swiftcc void @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP4zeroxvgZTW"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %swift.type* nocapture readnone swiftself %1, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 !dbg !390 {
entry:
  %2 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV4zeroACyxGvgZ"(%swift.type* nonnull @"$sSfN") #16, !dbg !394
  %3 = extractvalue { %T1M1SV1CC*, i1 } %2, 0, !dbg !394
  %4 = extractvalue { %T1M1SV1CC*, i1 } %2, 1, !dbg !394
  %5 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV4zeroACyxGvgZ"(%swift.type* nonnull @"$sSfN") #16, !dbg !399
  %6 = extractvalue { %T1M1SV1CC*, i1 } %5, 0, !dbg !399
  %7 = extractvalue { %T1M1SV1CC*, i1 } %5, 1, !dbg !399
  %8 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV4zeroACyxGvgZ"(%swift.type* nonnull @"$sSfN") #16, !dbg !401
  %9 = extractvalue { %T1M1SV1CC*, i1 } %8, 0, !dbg !401
  %10 = extractvalue { %T1M1SV1CC*, i1 } %8, 1, !dbg !401
  %11 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV4zeroACyxGvgZ"(%swift.type* nonnull @"$sSfN") #16, !dbg !403
  %12 = extractvalue { %T1M1SV1CC*, i1 } %11, 0, !dbg !403
  %13 = extractvalue { %T1M1SV1CC*, i1 } %11, 1, !dbg !403
  %14 = bitcast %T4main1TV13TangentVectorV* %0 to %T1M1SV1CC**, !dbg !398
  store %T1M1SV1CC* %3, %T1M1SV1CC** %14, align 8, !dbg !398
  %.u1.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 0, i32 1, i32 0, !dbg !398
  store i1 %4, i1* %.u1.s.b._value, align 8, !dbg !398
  %.u1.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, !dbg !398
  %15 = bitcast %T1M1SVySfG* %.u1.v.s to %T1M1SV1CC**, !dbg !398
  store %T1M1SV1CC* %6, %T1M1SV1CC** %15, align 8, !dbg !398
  %.u1.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, i32 1, i32 0, !dbg !398
  store i1 %7, i1* %.u1.v.s.b._value, align 8, !dbg !398
  %.u2 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, !dbg !398
  %16 = bitcast %T4main1UV13TangentVectorV* %.u2 to %T1M1SV1CC**, !dbg !398
  store %T1M1SV1CC* %9, %T1M1SV1CC** %16, align 8, !dbg !398
  %.u2.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !398
  store i1 %10, i1* %.u2.s.b._value, align 8, !dbg !398
  %.u2.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, !dbg !398
  %17 = bitcast %T1M1SVySfG* %.u2.v.s to %T1M1SV1CC**, !dbg !398
  store %T1M1SV1CC* %12, %T1M1SV1CC** %17, align 8, !dbg !398
  %.u2.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !398
  store i1 %13, i1* %.u2.v.s.b._value, align 8, !dbg !398
  ret void, !dbg !398
}
define internal swiftcc void @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTW"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %1, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %2, %swift.type* nocapture readnone swiftself %3, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 {
  tail call swiftcc void @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTWTm"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %1, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %2, %swift.type* nocapture readnone swiftself %3, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* @"$s1M1SV1poiyACyxGAE_AEtFZ") #2
  ret void
}
define internal swiftcc void @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP2peoiyyxz_xtFZTW"(%T4main1TV13TangentVectorV* nocapture dereferenceable(57) %0, %T4main1TV13TangentVectorV* noalias nocapture dereferenceable(57) %1, %swift.type* swiftself %2, %swift.type* %Self, i8** %SelfWitnessTable) #2 !dbg !405 {
entry:
  %3 = bitcast %T4main1TV13TangentVectorV* %0 to %swift.opaque*, !dbg !408
  %4 = bitcast %T4main1TV13TangentVectorV* %1 to %swift.opaque*, !dbg !408
  call swiftcc void @"$ss18AdditiveArithmeticPsE2peoiyyxz_xtFZTm"(%swift.opaque* nocapture %3, %swift.opaque* noalias nocapture %4, %swift.type* %Self, i8** %SelfWitnessTable, %swift.type* swiftself %2, void (%swift.opaque*, %swift.opaque*, %swift.opaque*, %swift.type*, %swift.type*, i8**)* @"$ss18AdditiveArithmeticP1poiyxx_xtFZTj"), !dbg !408
  ret void, !dbg !408
}
define linkonce_odr hidden swiftcc void @"$ss18AdditiveArithmeticPsE2peoiyyxz_xtFZ"(%swift.opaque* nocapture %0, %swift.opaque* noalias nocapture %1, %swift.type* %Self, i8** %Self.AdditiveArithmetic, %swift.type* swiftself %2) local_unnamed_addr #2 {
  tail call swiftcc void @"$ss18AdditiveArithmeticPsE2peoiyyxz_xtFZTm"(%swift.opaque* nocapture %0, %swift.opaque* noalias nocapture %1, %swift.type* %Self, i8** %Self.AdditiveArithmetic, %swift.type* swiftself %2, void (%swift.opaque*, %swift.opaque*, %swift.opaque*, %swift.type*, %swift.type*, i8**)* @"$ss18AdditiveArithmeticP1poiyxx_xtFZTj") #2
  ret void
}
define internal swiftcc void @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP1soiyxx_xtFZTW"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %1, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %2, %swift.type* nocapture readnone swiftself %3, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 {
  tail call swiftcc void @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTWTm"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %1, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %2, %swift.type* nocapture readnone swiftself %3, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* @"$s1M1SV1soiyACyxGAE_AEtFZ") #2
  ret void
}
define internal swiftcc void @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTWTm"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %1, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %2, %swift.type* nocapture readnone swiftself %3, %swift.type* nocapture readnone %4, i8** nocapture readnone %5, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* %6) #2 {
entry:
  %7 = bitcast %T4main1TV13TangentVectorV* %1 to %T1M1SV1CC**, !dbg !409
  %8 = load %T1M1SV1CC*, %T1M1SV1CC** %7, align 8, !dbg !409
  %.u1.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 0, i32 0, i32 1, i32 0, !dbg !409
  %9 = load i1, i1* %.u1.s.b._value, align 8, !dbg !409
  %.u1.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 0, i32 2, i32 0, !dbg !409
  %10 = bitcast %T1M1SVySfG* %.u1.v.s to %T1M1SV1CC**, !dbg !409
  %11 = load %T1M1SV1CC*, %T1M1SV1CC** %10, align 8, !dbg !409
  %.u1.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 0, i32 2, i32 0, i32 1, i32 0, !dbg !409
  %12 = load i1, i1* %.u1.v.s.b._value, align 8, !dbg !409
  %.u2 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, !dbg !409
  %13 = bitcast %T4main1UV13TangentVectorV* %.u2 to %T1M1SV1CC**, !dbg !409
  %14 = load %T1M1SV1CC*, %T1M1SV1CC** %13, align 8, !dbg !409
  %.u2.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !409
  %15 = load i1, i1* %.u2.s.b._value, align 8, !dbg !409
  %.u2.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 2, i32 0, !dbg !409
  %16 = bitcast %T1M1SVySfG* %.u2.v.s to %T1M1SV1CC**, !dbg !409
  %17 = load %T1M1SV1CC*, %T1M1SV1CC** %16, align 8, !dbg !409
  %.u2.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !409
  %18 = load i1, i1* %.u2.v.s.b._value, align 8, !dbg !409
  %19 = bitcast %T4main1TV13TangentVectorV* %2 to %T1M1SV1CC**, !dbg !409
  %20 = load %T1M1SV1CC*, %T1M1SV1CC** %19, align 8, !dbg !409
  %.u11.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %2, i64 0, i32 0, i32 0, i32 1, i32 0, !dbg !409
  %21 = load i1, i1* %.u11.s.b._value, align 8, !dbg !409
  %.u11.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %2, i64 0, i32 0, i32 2, i32 0, !dbg !409
  %22 = bitcast %T1M1SVySfG* %.u11.v.s to %T1M1SV1CC**, !dbg !409
  %23 = load %T1M1SV1CC*, %T1M1SV1CC** %22, align 8, !dbg !409
  %.u11.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %2, i64 0, i32 0, i32 2, i32 0, i32 1, i32 0, !dbg !409
  %24 = load i1, i1* %.u11.v.s.b._value, align 8, !dbg !409
  %.u22 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %2, i64 0, i32 2, !dbg !409
  %25 = bitcast %T4main1UV13TangentVectorV* %.u22 to %T1M1SV1CC**, !dbg !409
  %26 = load %T1M1SV1CC*, %T1M1SV1CC** %25, align 8, !dbg !409
  %.u22.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %2, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !409
  %27 = load i1, i1* %.u22.s.b._value, align 8, !dbg !409
  %.u22.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %2, i64 0, i32 2, i32 2, i32 0, !dbg !409
  %28 = bitcast %T1M1SVySfG* %.u22.v.s to %T1M1SV1CC**, !dbg !409
  %29 = load %T1M1SV1CC*, %T1M1SV1CC** %28, align 8, !dbg !409
  %.u22.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %2, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !409
  %30 = load i1, i1* %.u22.v.s.b._value, align 8, !dbg !409
  %31 = tail call swiftcc { %T1M1SV1CC*, i1 } %6(%T1M1SV1CC* %8, i1 %9, %T1M1SV1CC* %20, i1 %21, %swift.type* nonnull @"$sSfN") #16, !dbg !413
  %32 = extractvalue { %T1M1SV1CC*, i1 } %31, 0, !dbg !413
  %33 = extractvalue { %T1M1SV1CC*, i1 } %31, 1, !dbg !413
  %34 = tail call swiftcc { %T1M1SV1CC*, i1 } %6(%T1M1SV1CC* %11, i1 %12, %T1M1SV1CC* %23, i1 %24, %swift.type* nonnull @"$sSfN") #16, !dbg !417
  %35 = extractvalue { %T1M1SV1CC*, i1 } %34, 0, !dbg !417
  %36 = extractvalue { %T1M1SV1CC*, i1 } %34, 1, !dbg !417
  %37 = tail call swiftcc { %T1M1SV1CC*, i1 } %6(%T1M1SV1CC* %14, i1 %15, %T1M1SV1CC* %26, i1 %27, %swift.type* nonnull @"$sSfN") #16, !dbg !419
  %38 = extractvalue { %T1M1SV1CC*, i1 } %37, 0, !dbg !419
  %39 = extractvalue { %T1M1SV1CC*, i1 } %37, 1, !dbg !419
  %40 = tail call swiftcc { %T1M1SV1CC*, i1 } %6(%T1M1SV1CC* %17, i1 %18, %T1M1SV1CC* %29, i1 %30, %swift.type* nonnull @"$sSfN") #16, !dbg !421
  %41 = extractvalue { %T1M1SV1CC*, i1 } %40, 0, !dbg !421
  %42 = extractvalue { %T1M1SV1CC*, i1 } %40, 1, !dbg !421
  %43 = bitcast %T4main1TV13TangentVectorV* %0 to %T1M1SV1CC**, !dbg !409
  store %T1M1SV1CC* %32, %T1M1SV1CC** %43, align 8, !dbg !409
  %.u113.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 0, i32 1, i32 0, !dbg !409
  store i1 %33, i1* %.u113.s.b._value, align 8, !dbg !409
  %.u113.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, !dbg !409
  %44 = bitcast %T1M1SVySfG* %.u113.v.s to %T1M1SV1CC**, !dbg !409
  store %T1M1SV1CC* %35, %T1M1SV1CC** %44, align 8, !dbg !409
  %.u113.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, i32 1, i32 0, !dbg !409
  store i1 %36, i1* %.u113.v.s.b._value, align 8, !dbg !409
  %.u214 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, !dbg !409
  %45 = bitcast %T4main1UV13TangentVectorV* %.u214 to %T1M1SV1CC**, !dbg !409
  store %T1M1SV1CC* %38, %T1M1SV1CC** %45, align 8, !dbg !409
  %.u214.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !409
  store i1 %39, i1* %.u214.s.b._value, align 8, !dbg !409
  %.u214.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, !dbg !409
  %46 = bitcast %T1M1SVySfG* %.u214.v.s to %T1M1SV1CC**, !dbg !409
  store %T1M1SV1CC* %41, %T1M1SV1CC** %46, align 8, !dbg !409
  %.u214.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !409
  store i1 %42, i1* %.u214.v.s.b._value, align 8, !dbg !409
  ret void, !dbg !409
}
define internal swiftcc void @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP2seoiyyxz_xtFZTW"(%T4main1TV13TangentVectorV* nocapture dereferenceable(57) %0, %T4main1TV13TangentVectorV* noalias nocapture dereferenceable(57) %1, %swift.type* swiftself %2, %swift.type* %Self, i8** %SelfWitnessTable) #2 !dbg !423 {
entry:
  %3 = bitcast %T4main1TV13TangentVectorV* %0 to %swift.opaque*, !dbg !424
  %4 = bitcast %T4main1TV13TangentVectorV* %1 to %swift.opaque*, !dbg !424
  call swiftcc void @"$ss18AdditiveArithmeticPsE2peoiyyxz_xtFZTm"(%swift.opaque* nocapture %3, %swift.opaque* noalias nocapture %4, %swift.type* %Self, i8** %SelfWitnessTable, %swift.type* swiftself %2, void (%swift.opaque*, %swift.opaque*, %swift.opaque*, %swift.type*, %swift.type*, i8**)* @"$ss18AdditiveArithmeticP1soiyxx_xtFZTj"), !dbg !424
  ret void, !dbg !424
}
define linkonce_odr hidden swiftcc void @"$ss18AdditiveArithmeticPsE2seoiyyxz_xtFZ"(%swift.opaque* nocapture %0, %swift.opaque* noalias nocapture %1, %swift.type* %Self, i8** %Self.AdditiveArithmetic, %swift.type* swiftself %2) local_unnamed_addr #2 {
  tail call swiftcc void @"$ss18AdditiveArithmeticPsE2peoiyyxz_xtFZTm"(%swift.opaque* nocapture %0, %swift.opaque* noalias nocapture %1, %swift.type* %Self, i8** %Self.AdditiveArithmetic, %swift.type* swiftself %2, void (%swift.opaque*, %swift.opaque*, %swift.opaque*, %swift.type*, %swift.type*, i8**)* @"$ss18AdditiveArithmeticP1soiyxx_xtFZTj") #2
  ret void
}
define internal swiftcc void @"$ss18AdditiveArithmeticPsE2peoiyyxz_xtFZTm"(%swift.opaque* nocapture %0, %swift.opaque* noalias nocapture %1, %swift.type* %2, i8** %3, %swift.type* swiftself %4, void (%swift.opaque*, %swift.opaque*, %swift.opaque*, %swift.type*, %swift.type*, i8**)* %5) local_unnamed_addr #2 {
entry:
  call void @llvm.dbg.value(metadata %swift.type* %2, metadata !425, metadata !DIExpression()), !dbg !430
  %6 = getelementptr inbounds %swift.type, %swift.type* %2, i64 -1, !dbg !430
  %7 = bitcast %swift.type* %6 to i8***, !dbg !430
  %Self.valueWitnesses = load i8**, i8*** %7, align 8, !dbg !430, !invariant.load !2, !dereferenceable !431
  %8 = getelementptr inbounds i8*, i8** %Self.valueWitnesses, i64 8, !dbg !430
  %9 = bitcast i8** %8 to i64*, !dbg !430
  %size = load i64, i64* %9, align 8, !dbg !430, !invariant.load !2
  %10 = alloca i8, i64 %size, align 16, !dbg !430
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* nonnull %10), !dbg !430
  %11 = bitcast i8* %10 to %swift.opaque*, !dbg !430
  call swiftcc void %5(%swift.opaque* noalias nocapture nonnull sret %11, %swift.opaque* noalias nocapture %0, %swift.opaque* noalias nocapture %1, %swift.type* swiftself %2, %swift.type* %2, i8** %3), !dbg !430
  %12 = getelementptr inbounds i8*, i8** %Self.valueWitnesses, i64 5, !dbg !430
  %13 = bitcast i8** %12 to %swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)**, !dbg !430
  %14 = load %swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)*, %swift.opaque* (%swift.opaque*, %swift.opaque*, %swift.type*)** %13, align 8, !dbg !430, !invariant.load !2
  %15 = call %swift.opaque* %14(%swift.opaque* noalias %0, %swift.opaque* noalias nonnull %11, %swift.type* %2) #0, !dbg !430
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* nonnull %10), !dbg !430
  ret void, !dbg !430
}
define internal swiftcc i1 @"$s4main1TV13TangentVectorVSQAASQ2eeoiySbx_xtFZTW"(%T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %0, %T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %1, %swift.type* nocapture readnone swiftself %2, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 !dbg !432 {
entry:
  %3 = bitcast %T4main1TV13TangentVectorV* %0 to %T1M1SV1CC**, !dbg !435
  %4 = load %T1M1SV1CC*, %T1M1SV1CC** %3, align 8, !dbg !435
  %.u1.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 0, i32 1, i32 0, !dbg !435
  %5 = load i1, i1* %.u1.s.b._value, align 8, !dbg !435
  %.u1.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, !dbg !435
  %6 = bitcast %T1M1SVySfG* %.u1.v.s to %T1M1SV1CC**, !dbg !435
  %7 = load %T1M1SV1CC*, %T1M1SV1CC** %6, align 8, !dbg !435
  %.u1.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, i32 1, i32 0, !dbg !435
  %8 = load i1, i1* %.u1.v.s.b._value, align 8, !dbg !435
  %.u2 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, !dbg !435
  %9 = bitcast %T4main1UV13TangentVectorV* %.u2 to %T1M1SV1CC**, !dbg !435
  %10 = load %T1M1SV1CC*, %T1M1SV1CC** %9, align 8, !dbg !435
  %.u2.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !435
  %11 = load i1, i1* %.u2.s.b._value, align 8, !dbg !435
  %.u2.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, !dbg !435
  %12 = bitcast %T1M1SVySfG* %.u2.v.s to %T1M1SV1CC**, !dbg !435
  %13 = load %T1M1SV1CC*, %T1M1SV1CC** %12, align 8, !dbg !435
  %.u2.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !435
  %14 = load i1, i1* %.u2.v.s.b._value, align 8, !dbg !435
  %15 = bitcast %T4main1TV13TangentVectorV* %1 to %T1M1SV1CC**, !dbg !435
  %16 = load %T1M1SV1CC*, %T1M1SV1CC** %15, align 8, !dbg !435
  %.u11.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 0, i32 0, i32 1, i32 0, !dbg !435
  %17 = load i1, i1* %.u11.s.b._value, align 8, !dbg !435
  %.u11.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 0, i32 2, i32 0, !dbg !435
  %18 = bitcast %T1M1SVySfG* %.u11.v.s to %T1M1SV1CC**, !dbg !435
  %19 = load %T1M1SV1CC*, %T1M1SV1CC** %18, align 8, !dbg !435
  %.u11.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 0, i32 2, i32 0, i32 1, i32 0, !dbg !435
  %20 = load i1, i1* %.u11.v.s.b._value, align 8, !dbg !435
  %.u22 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, !dbg !435
  %21 = bitcast %T4main1UV13TangentVectorV* %.u22 to %T1M1SV1CC**, !dbg !435
  %22 = load %T1M1SV1CC*, %T1M1SV1CC** %21, align 8, !dbg !435
  %.u22.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !435
  %23 = load i1, i1* %.u22.s.b._value, align 8, !dbg !435
  %.u22.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 2, i32 0, !dbg !435
  %24 = bitcast %T1M1SVySfG* %.u22.v.s to %T1M1SV1CC**, !dbg !435
  %25 = load %T1M1SV1CC*, %T1M1SV1CC** %24, align 8, !dbg !435
  %.u22.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !435
  %26 = load i1, i1* %.u22.v.s.b._value, align 8, !dbg !435
  %27 = tail call swiftcc i1 @"$s1M1SV2eeoiySbACyxG_AEtFZ"(%T1M1SV1CC* %4, i1 %5, %T1M1SV1CC* %16, i1 %17, %swift.type* nonnull @"$sSfN") #16, !dbg !436
  br i1 %27, label %28, label %34, !dbg !436

28:                                               ; preds = %entry
  %29 = tail call swiftcc i1 @"$s1M1SV2eeoiySbACyxG_AEtFZ"(%T1M1SV1CC* %7, i1 %8, %T1M1SV1CC* %19, i1 %20, %swift.type* nonnull @"$sSfN") #16, !dbg !440
  br i1 %29, label %30, label %34, !dbg !440

30:                                               ; preds = %28
  %31 = tail call swiftcc i1 @"$s1M1SV2eeoiySbACyxG_AEtFZ"(%T1M1SV1CC* %10, i1 %11, %T1M1SV1CC* %22, i1 %23, %swift.type* nonnull @"$sSfN") #16, !dbg !442
  br i1 %31, label %32, label %36, !dbg !442

32:                                               ; preds = %30
  %33 = tail call swiftcc i1 @"$s1M1SV2eeoiySbACyxG_AEtFZ"(%T1M1SV1CC* %13, i1 %14, %T1M1SV1CC* %25, i1 %26, %swift.type* nonnull @"$sSfN") #16, !dbg !444
  br i1 %33, label %34, label %36, !dbg !444

34:                                               ; preds = %entry, %28, %32, %36
  %35 = phi i1 [ false, %36 ], [ true, %32 ], [ false, %28 ], [ false, %entry ], !dbg !438
  ret i1 %35, !dbg !435

36:                                               ; preds = %32, %30
  br label %34, !dbg !446
}
define hidden swiftcc void @"$s4main1TV4move5alongyAC13TangentVectorV_tF"(%T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %0, %T4main1TV* nocapture swiftself dereferenceable(57) %1) local_unnamed_addr #2 !dbg !448 {
entry:
  %2 = alloca %T4main1VV13TangentVectorV, align 8
  call void @llvm.dbg.declare(metadata %T4main1VV13TangentVectorV* %2, metadata !451, metadata !DIExpression()), !dbg !455
  %.sroa.541 = alloca <{ [7 x i8], %T4main1VV13TangentVectorV }>, align 8
  call void @llvm.dbg.declare(metadata <{ [7 x i8], %T4main1VV13TangentVectorV }>* %.sroa.541, metadata !463, metadata !DIExpression(DW_OP_LLVM_fragment, 72, 128)), !dbg !464
  %3 = alloca %T4main1VV13TangentVectorV, align 8
  call void @llvm.dbg.declare(metadata %T4main1VV13TangentVectorV* %3, metadata !451, metadata !DIExpression()), !dbg !465
  %.sroa.5 = alloca <{ [7 x i8], %T4main1VV13TangentVectorV }>, align 8
  call void @llvm.dbg.declare(metadata <{ [7 x i8], %T4main1VV13TangentVectorV }>* %.sroa.5, metadata !463, metadata !DIExpression(DW_OP_LLVM_fragment, 72, 128)), !dbg !464
  %4 = bitcast %T4main1VV13TangentVectorV* %2 to i8*, !dbg !468
  call void @llvm.lifetime.start.p0i8(i64 9, i8* nonnull %4), !dbg !468
  %.sroa.541.0..sroa_idx46 = getelementptr inbounds <{ [7 x i8], %T4main1VV13TangentVectorV }>, <{ [7 x i8], %T4main1VV13TangentVectorV }>* %.sroa.541, i64 0, i32 0, i64 0, !dbg !468
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %.sroa.541.0..sroa_idx46), !dbg !468
  %5 = bitcast %T4main1VV13TangentVectorV* %3 to i8*, !dbg !468
  call void @llvm.lifetime.start.p0i8(i64 9, i8* nonnull %5), !dbg !468
  %.sroa.5.0..sroa_idx31 = getelementptr inbounds <{ [7 x i8], %T4main1VV13TangentVectorV }>, <{ [7 x i8], %T4main1VV13TangentVectorV }>* %.sroa.5, i64 0, i32 0, i64 0, !dbg !468
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %.sroa.5.0..sroa_idx31), !dbg !468
  call void @llvm.dbg.value(metadata %T4main1TV13TangentVectorV* %0, metadata !469, metadata !DIExpression(DW_OP_deref)), !dbg !468
  call void @llvm.dbg.value(metadata %T4main1TV* %1, metadata !470, metadata !DIExpression(DW_OP_deref)), !dbg !468
  %.sroa.035.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 0, i32 0, !dbg !461
  %.sroa.035.0.copyload = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.sroa.035.0..sroa_idx, align 8, !dbg !461
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %.sroa.035.0.copyload, metadata !463, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !464
  %.sroa.437.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 0, i32 1, !dbg !461
  %.sroa.437.0..sroa_cast38 = bitcast %TSb* %.sroa.437.0..sroa_idx to i8*, !dbg !461
  %6 = load i8, i8* %.sroa.437.0..sroa_cast38, align 8, !dbg !461
  call void @llvm.dbg.value(metadata i8 %6, metadata !463, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !464
  %.sroa.541.0..sroa_idx42 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 1, i64 0, !dbg !461
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 dereferenceable(16) %.sroa.541.0..sroa_idx46, i8* nonnull align 1 dereferenceable(16) %.sroa.541.0..sroa_idx42, i64 16, i1 false), !dbg !461
  call void @llvm.dbg.value(metadata %T4main1TV* %1, metadata !471, metadata !DIExpression(DW_OP_deref)), !dbg !464
  %7 = and i8 %6, 1, !dbg !456
  %8 = icmp ne i8 %7, 0, !dbg !456
  call void @llvm.dbg.value(metadata i1 %8, metadata !463, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !464
  %.u11.s.c = getelementptr inbounds %T4main1TV, %T4main1TV* %1, i64 0, i32 0, i32 0, i32 0, !dbg !472
  %9 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.u11.s.c, align 8, !dbg !472
  %.u11.s.b._value = getelementptr inbounds %T4main1TV, %T4main1TV* %1, i64 0, i32 0, i32 0, i32 1, i32 0, !dbg !472
  %10 = load i1, i1* %.u11.s.b._value, align 8, !dbg !472
  %11 = bitcast %T1M1SV1CCySf_G* %.sroa.035.0.copyload to %swift.refcounted*, !dbg !464
  %.asUnsubstituted = bitcast %T1M1SV1CCySf_G* %9 to %T1M1SV1CC*, !dbg !491
  %.asUnsubstituted2 = bitcast %T1M1SV1CCySf_G* %.sroa.035.0.copyload to %T1M1SV1CC*, !dbg !491
  %12 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %11) #0, !dbg !464
  %13 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV1poiyACyxGAE_AEtFZ"(%T1M1SV1CC* %.asUnsubstituted, i1 %10, %T1M1SV1CC* %.asUnsubstituted2, i1 %8, %swift.type* nonnull @"$sSfN"), !dbg !491
  %14 = extractvalue { %T1M1SV1CC*, i1 } %13, 0, !dbg !491
  %15 = extractvalue { %T1M1SV1CC*, i1 } %13, 1, !dbg !491
  %16 = bitcast %T1M1SV1CCySf_G* %9 to %swift.refcounted*, !dbg !468
  tail call void @swift_release(%swift.refcounted* %16) #0, !dbg !468
  %17 = bitcast %T4main1TV* %1 to %T1M1SV1CC**, !dbg !472
  store %T1M1SV1CC* %14, %T1M1SV1CC** %17, align 8, !dbg !472
  store i1 %15, i1* %.u11.s.b._value, align 8, !dbg !472
  tail call void @swift_release(%swift.refcounted* %11) #0, !dbg !468
  %.sroa.541.16..sroa_idx = getelementptr inbounds <{ [7 x i8], %T4main1VV13TangentVectorV }>, <{ [7 x i8], %T4main1VV13TangentVectorV }>* %.sroa.541, i64 0, i32 1, !dbg !456
  %.sroa.541.16..sroa_cast45 = bitcast %T4main1VV13TangentVectorV* %.sroa.541.16..sroa_idx to i8*, !dbg !456
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 dereferenceable(9) %4, i8* nonnull align 1 dereferenceable(9) %.sroa.541.16..sroa_cast45, i64 9, i1 false), !dbg !456
  call void @llvm.dbg.value(metadata %T4main1TV* %1, metadata !495, metadata !DIExpression(DW_OP_plus_uconst, 16, DW_OP_deref, DW_OP_stack_value)), !dbg !455
  %.s5.c = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %2, i64 0, i32 0, i32 0, !dbg !496
  %18 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.s5.c, align 8, !dbg !496
  %.s5.b._value = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %2, i64 0, i32 0, i32 1, i32 0, !dbg !496
  %19 = load i1, i1* %.s5.b._value, align 8, !dbg !496
  %.u11.v.s.c = getelementptr inbounds %T4main1TV, %T4main1TV* %1, i64 0, i32 0, i32 2, i32 0, i32 0, !dbg !498
  %20 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.u11.v.s.c, align 8, !dbg !498
  %.u11.v.s.b._value = getelementptr inbounds %T4main1TV, %T4main1TV* %1, i64 0, i32 0, i32 2, i32 0, i32 1, i32 0, !dbg !498
  %21 = load i1, i1* %.u11.v.s.b._value, align 8, !dbg !498
  %22 = bitcast %T1M1SV1CCySf_G* %18 to %swift.refcounted*, !dbg !455
  %.asUnsubstituted6 = bitcast %T1M1SV1CCySf_G* %20 to %T1M1SV1CC*, !dbg !501
  %.asUnsubstituted7 = bitcast %T1M1SV1CCySf_G* %18 to %T1M1SV1CC*, !dbg !501
  %23 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %22) #0, !dbg !455
  %24 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV1poiyACyxGAE_AEtFZ"(%T1M1SV1CC* %.asUnsubstituted6, i1 %21, %T1M1SV1CC* %.asUnsubstituted7, i1 %19, %swift.type* nonnull @"$sSfN"), !dbg !501
  %25 = extractvalue { %T1M1SV1CC*, i1 } %24, 0, !dbg !501
  %26 = extractvalue { %T1M1SV1CC*, i1 } %24, 1, !dbg !501
  %27 = bitcast %T1M1SV1CCySf_G* %20 to %swift.refcounted*, !dbg !468
  tail call void @swift_release(%swift.refcounted* %27) #0, !dbg !468
  %28 = call %T4main1VV13TangentVectorV* @"$s4main1VV13TangentVectorVWOs"(%T4main1VV13TangentVectorV* nonnull %2), !dbg !468
  %29 = bitcast %T1M1SV1CCySf_G** %.u11.v.s.c to %T1M1SV1CC**, !dbg !498
  store %T1M1SV1CC* %25, %T1M1SV1CC** %29, align 8, !dbg !498
  store i1 %26, i1* %.u11.v.s.b._value, align 8, !dbg !498
  %.sroa.0.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 0, !dbg !461
  %.sroa.0.0.copyload = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.sroa.0.0..sroa_idx, align 8, !dbg !461
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %.sroa.0.0.copyload, metadata !463, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !464
  %.sroa.4.0..sroa_idx = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, !dbg !461
  %.sroa.4.0..sroa_cast24 = bitcast %TSb* %.sroa.4.0..sroa_idx to i8*, !dbg !461
  %30 = load i8, i8* %.sroa.4.0..sroa_cast24, align 8, !dbg !461
  call void @llvm.dbg.value(metadata i8 %30, metadata !463, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !464
  %.sroa.5.0..sroa_idx27 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 1, i64 0, !dbg !461
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 dereferenceable(16) %.sroa.5.0..sroa_idx31, i8* nonnull align 1 dereferenceable(16) %.sroa.5.0..sroa_idx27, i64 16, i1 false), !dbg !461
  %.u210 = getelementptr inbounds %T4main1TV, %T4main1TV* %1, i64 0, i32 2, !dbg !461
  call void @llvm.dbg.value(metadata %T4main1UV* %.u210, metadata !471, metadata !DIExpression(DW_OP_deref)), !dbg !464
  %31 = and i8 %30, 1, !dbg !466
  %32 = icmp ne i8 %31, 0, !dbg !466
  call void @llvm.dbg.value(metadata i1 %32, metadata !463, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !464
  %.u210.s.c = getelementptr inbounds %T4main1UV, %T4main1UV* %.u210, i64 0, i32 0, i32 0, !dbg !502
  %33 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.u210.s.c, align 8, !dbg !502
  %.u210.s.b._value = getelementptr inbounds %T4main1TV, %T4main1TV* %1, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !502
  %34 = load i1, i1* %.u210.s.b._value, align 8, !dbg !502
  %35 = bitcast %T1M1SV1CCySf_G* %.sroa.0.0.copyload to %swift.refcounted*, !dbg !464
  %.asUnsubstituted12 = bitcast %T1M1SV1CCySf_G* %33 to %T1M1SV1CC*, !dbg !505
  %.asUnsubstituted13 = bitcast %T1M1SV1CCySf_G* %.sroa.0.0.copyload to %T1M1SV1CC*, !dbg !505
  %36 = call %swift.refcounted* @swift_retain(%swift.refcounted* returned %35) #0, !dbg !464
  %37 = call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV1poiyACyxGAE_AEtFZ"(%T1M1SV1CC* %.asUnsubstituted12, i1 %34, %T1M1SV1CC* %.asUnsubstituted13, i1 %32, %swift.type* nonnull @"$sSfN"), !dbg !505
  %38 = extractvalue { %T1M1SV1CC*, i1 } %37, 0, !dbg !505
  %39 = extractvalue { %T1M1SV1CC*, i1 } %37, 1, !dbg !505
  %40 = bitcast %T1M1SV1CCySf_G* %33 to %swift.refcounted*, !dbg !468
  call void @swift_release(%swift.refcounted* %40) #0, !dbg !468
  %41 = bitcast %T4main1UV* %.u210 to %T1M1SV1CC**, !dbg !502
  store %T1M1SV1CC* %38, %T1M1SV1CC** %41, align 8, !dbg !502
  store i1 %39, i1* %.u210.s.b._value, align 8, !dbg !502
  call void @swift_release(%swift.refcounted* %35) #0, !dbg !468
  %.sroa.5.16..sroa_idx = getelementptr inbounds <{ [7 x i8], %T4main1VV13TangentVectorV }>, <{ [7 x i8], %T4main1VV13TangentVectorV }>* %.sroa.5, i64 0, i32 1, !dbg !466
  %.sroa.5.16..sroa_cast30 = bitcast %T4main1VV13TangentVectorV* %.sroa.5.16..sroa_idx to i8*, !dbg !466
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 dereferenceable(9) %5, i8* nonnull align 1 dereferenceable(9) %.sroa.5.16..sroa_cast30, i64 9, i1 false), !dbg !466
  call void @llvm.dbg.value(metadata %T4main1TV* %1, metadata !495, metadata !DIExpression(DW_OP_plus_uconst, 48, DW_OP_deref, DW_OP_stack_value)), !dbg !465
  %.s18.c = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %3, i64 0, i32 0, i32 0, !dbg !506
  %42 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.s18.c, align 8, !dbg !506
  %.s18.b._value = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %3, i64 0, i32 0, i32 1, i32 0, !dbg !506
  %43 = load i1, i1* %.s18.b._value, align 8, !dbg !506
  %.u210.v.s.c = getelementptr inbounds %T4main1TV, %T4main1TV* %1, i64 0, i32 2, i32 2, i32 0, i32 0, !dbg !508
  %44 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.u210.v.s.c, align 8, !dbg !508
  %.u210.v.s.b._value = getelementptr inbounds %T4main1TV, %T4main1TV* %1, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !508
  %45 = load i1, i1* %.u210.v.s.b._value, align 8, !dbg !508
  %46 = bitcast %T1M1SV1CCySf_G* %42 to %swift.refcounted*, !dbg !465
  %.asUnsubstituted19 = bitcast %T1M1SV1CCySf_G* %44 to %T1M1SV1CC*, !dbg !511
  %.asUnsubstituted20 = bitcast %T1M1SV1CCySf_G* %42 to %T1M1SV1CC*, !dbg !511
  %47 = call %swift.refcounted* @swift_retain(%swift.refcounted* returned %46) #0, !dbg !465
  %48 = call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV1poiyACyxGAE_AEtFZ"(%T1M1SV1CC* %.asUnsubstituted19, i1 %45, %T1M1SV1CC* %.asUnsubstituted20, i1 %43, %swift.type* nonnull @"$sSfN"), !dbg !511
  %49 = extractvalue { %T1M1SV1CC*, i1 } %48, 0, !dbg !511
  %50 = extractvalue { %T1M1SV1CC*, i1 } %48, 1, !dbg !511
  %51 = bitcast %T1M1SV1CCySf_G* %44 to %swift.refcounted*, !dbg !468
  call void @swift_release(%swift.refcounted* %51) #0, !dbg !468
  %52 = call %T4main1VV13TangentVectorV* @"$s4main1VV13TangentVectorVWOs"(%T4main1VV13TangentVectorV* nonnull %3), !dbg !468
  %53 = bitcast %T1M1SV1CCySf_G** %.u210.v.s.c to %T1M1SV1CC**, !dbg !508
  store %T1M1SV1CC* %49, %T1M1SV1CC** %53, align 8, !dbg !508
  store i1 %50, i1* %.u210.v.s.b._value, align 8, !dbg !508
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %.sroa.5.0..sroa_idx31), !dbg !461
  call void @llvm.lifetime.end.p0i8(i64 9, i8* nonnull %5), !dbg !461
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %.sroa.541.0..sroa_idx46), !dbg !461
  call void @llvm.lifetime.end.p0i8(i64 9, i8* nonnull %4), !dbg !461
  ret void, !dbg !461
}
define hidden swiftcc void @"$s4main1UV4move5alongyAC13TangentVectorV_tF"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3, %T4main1UV* nocapture swiftself dereferenceable(25) %4) local_unnamed_addr #2 !dbg !458 {
entry:
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %0, metadata !463, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !512
  call void @llvm.dbg.value(metadata i1 %1, metadata !463, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !512
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %2, metadata !463, metadata !DIExpression(DW_OP_LLVM_fragment, 65, 64)), !dbg !512
  call void @llvm.dbg.value(metadata i1 %3, metadata !463, metadata !DIExpression(DW_OP_LLVM_fragment, 129, 1)), !dbg !512
  call void @llvm.dbg.value(metadata %T4main1UV* %4, metadata !471, metadata !DIExpression(DW_OP_deref)), !dbg !512
  %.s.c = getelementptr inbounds %T4main1UV, %T4main1UV* %4, i64 0, i32 0, i32 0, !dbg !513
  %5 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.s.c, align 8, !dbg !513
  %.s.b._value = getelementptr inbounds %T4main1UV, %T4main1UV* %4, i64 0, i32 0, i32 1, i32 0, !dbg !513
  %6 = load i1, i1* %.s.b._value, align 8, !dbg !513
  %7 = bitcast %T1M1SV1CCySf_G* %0 to %swift.refcounted*, !dbg !512
  %.asUnsubstituted = bitcast %T1M1SV1CCySf_G* %5 to %T1M1SV1CC*, !dbg !518
  %.asUnsubstituted1 = bitcast %T1M1SV1CCySf_G* %0 to %T1M1SV1CC*, !dbg !518
  %8 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %7) #0, !dbg !512
  %9 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV1poiyACyxGAE_AEtFZ"(%T1M1SV1CC* %.asUnsubstituted, i1 %6, %T1M1SV1CC* %.asUnsubstituted1, i1 %1, %swift.type* nonnull @"$sSfN"), !dbg !518
  %10 = extractvalue { %T1M1SV1CC*, i1 } %9, 0, !dbg !518
  %11 = extractvalue { %T1M1SV1CC*, i1 } %9, 1, !dbg !518
  %12 = bitcast %T1M1SV1CCySf_G* %5 to %swift.refcounted*, !dbg !512
  tail call void @swift_release(%swift.refcounted* %12) #0, !dbg !512
  %13 = bitcast %T4main1UV* %4 to %T1M1SV1CC**, !dbg !513
  store %T1M1SV1CC* %10, %T1M1SV1CC** %13, align 8, !dbg !513
  store i1 %11, i1* %.s.b._value, align 8, !dbg !513
  tail call void @swift_release(%swift.refcounted* %7) #0, !dbg !512
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %2, metadata !451, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !519
  call void @llvm.dbg.value(metadata i1 %3, metadata !451, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !519
  call void @llvm.dbg.value(metadata %T4main1UV* %4, metadata !495, metadata !DIExpression(DW_OP_plus_uconst, 16, DW_OP_deref, DW_OP_stack_value)), !dbg !519
  %.v.s.c = getelementptr inbounds %T4main1UV, %T4main1UV* %4, i64 0, i32 2, i32 0, i32 0, !dbg !520
  %14 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.v.s.c, align 8, !dbg !520
  %.v.s.b._value = getelementptr inbounds %T4main1UV, %T4main1UV* %4, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !520
  %15 = load i1, i1* %.v.s.b._value, align 8, !dbg !520
  %16 = bitcast %T1M1SV1CCySf_G* %2 to %swift.refcounted*, !dbg !519
  %.asUnsubstituted4 = bitcast %T1M1SV1CCySf_G* %14 to %T1M1SV1CC*, !dbg !525
  %.asUnsubstituted5 = bitcast %T1M1SV1CCySf_G* %2 to %T1M1SV1CC*, !dbg !525
  %17 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %16) #0, !dbg !519
  %18 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV1poiyACyxGAE_AEtFZ"(%T1M1SV1CC* %.asUnsubstituted4, i1 %15, %T1M1SV1CC* %.asUnsubstituted5, i1 %3, %swift.type* nonnull @"$sSfN"), !dbg !525
  tail call void @swift_release(%swift.refcounted* %16) #0, !dbg !512
  %19 = extractvalue { %T1M1SV1CC*, i1 } %18, 0, !dbg !525
  %20 = extractvalue { %T1M1SV1CC*, i1 } %18, 1, !dbg !525
  %21 = bitcast %T1M1SV1CCySf_G* %14 to %swift.refcounted*, !dbg !512
  tail call void @swift_release(%swift.refcounted* %21) #0, !dbg !512
  %22 = bitcast %T1M1SV1CCySf_G** %.v.s.c to %T1M1SV1CC**, !dbg !520
  store %T1M1SV1CC* %19, %T1M1SV1CC** %22, align 8, !dbg !520
  store i1 %20, i1* %.v.s.b._value, align 8, !dbg !520
  ret void, !dbg !516
}
define hidden swiftcc { i8*, %swift.refcounted* } @"$s4main1TV28zeroTangentVectorInitializerAC0cD0Vycvg"(%T4main1TV* noalias nocapture readonly swiftself dereferenceable(57) %0) local_unnamed_addr #2 !dbg !526 {
entry:
  call void @llvm.dbg.declare(metadata %TSb* undef, metadata !529, metadata !DIExpression(DW_OP_LLVM_fragment, 192, 8)), !dbg !534
  call void @llvm.dbg.declare(metadata %TSb* undef, metadata !529, metadata !DIExpression(DW_OP_LLVM_fragment, 192, 8)), !dbg !534
  call void @llvm.dbg.value(metadata %T4main1TV* %0, metadata !538, metadata !DIExpression(DW_OP_deref)), !dbg !540
  %1 = bitcast %T4main1TV* %0 to %T1M1SV1CC**, !dbg !535
  %.sroa.052.0.copyload87 = load %T1M1SV1CC*, %T1M1SV1CC** %1, align 8, !dbg !535
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !529, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !534
  %.sroa.454.0..sroa_idx = getelementptr inbounds %T4main1TV, %T4main1TV* %0, i64 0, i32 0, i32 0, i32 1, !dbg !535
  %.sroa.454.0..sroa_cast55 = bitcast %TSb* %.sroa.454.0..sroa_idx to i8*, !dbg !535
  %2 = load i8, i8* %.sroa.454.0..sroa_cast55, align 8, !dbg !535
  call void @llvm.dbg.value(metadata i8 %2, metadata !529, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !534
  %.sroa.5.sroa.376.0..sroa.5.0..sroa_idx58.sroa_idx = getelementptr inbounds %T4main1TV, %T4main1TV* %0, i64 0, i32 0, i32 2, i32 0, i32 0, !dbg !535
  %3 = bitcast %T1M1SV1CCySf_G** %.sroa.5.sroa.376.0..sroa.5.0..sroa_idx58.sroa_idx to %T1M1SV1CC**, !dbg !535
  %.sroa.5.sroa.376.0.copyload88 = load %T1M1SV1CC*, %T1M1SV1CC** %3, align 1, !dbg !535
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !529, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !534
  %.sroa.5.sroa.478.0..sroa.5.0..sroa_idx58.sroa_idx = getelementptr inbounds %T4main1TV, %T4main1TV* %0, i64 0, i32 0, i32 2, i32 0, i32 1, !dbg !535
  %.sroa.5.sroa.478.0..sroa.5.0..sroa_idx58.sroa_cast = bitcast %TSb* %.sroa.5.sroa.478.0..sroa.5.0..sroa_idx58.sroa_idx to i8*, !dbg !535
  %4 = load i8, i8* %.sroa.5.sroa.478.0..sroa.5.0..sroa_idx58.sroa_cast, align 1, !dbg !535
  %5 = and i8 %2, 1, !dbg !541
  %6 = icmp ne i8 %5, 0, !dbg !541
  call void @llvm.dbg.value(metadata i1 %6, metadata !529, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !534
  %7 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %.sroa.052.0.copyload87, i1 %6, %swift.type* nonnull @"$sSfN"), !dbg !541
  %8 = extractvalue { i8*, %swift.refcounted* } %7, 0, !dbg !541
  %9 = extractvalue { i8*, %swift.refcounted* } %7, 1, !dbg !541
  call void @llvm.dbg.value(metadata i8* %8, metadata !544, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !541
  call void @llvm.dbg.value(metadata %swift.refcounted* %9, metadata !544, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !541
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !545, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !550
  call void @llvm.dbg.value(metadata i8 %4, metadata !545, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !550
  %10 = and i8 %4, 1, !dbg !551
  %11 = icmp ne i8 %10, 0, !dbg !551
  call void @llvm.dbg.value(metadata i1 %11, metadata !545, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !550
  %12 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %.sroa.5.sroa.376.0.copyload88, i1 %11, %swift.type* nonnull @"$sSfN"), !dbg !551
  %13 = extractvalue { i8*, %swift.refcounted* } %12, 0, !dbg !551
  %14 = extractvalue { i8*, %swift.refcounted* } %12, 1, !dbg !551
  call void @llvm.dbg.value(metadata i8* %13, metadata !554, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !551
  call void @llvm.dbg.value(metadata %swift.refcounted* %14, metadata !554, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !551
  %15 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.25, i64 0, i32 2), i64 32, i64 7) #0, !dbg !551
  %16 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %15, i64 1, !dbg !551
  %.fn = bitcast %swift.refcounted* %16 to i8**, !dbg !551
  store i8* %13, i8** %.fn, align 8, !dbg !551
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %15, i64 1, i32 1, !dbg !551
  %17 = bitcast i64* %.data to %swift.refcounted**, !dbg !551
  store %swift.refcounted* %14, %swift.refcounted** %17, align 8, !dbg !551
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA" to i8*), metadata !555, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !541
  call void @llvm.dbg.value(metadata %swift.refcounted* %15, metadata !555, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !541
  %18 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.28, i64 0, i32 2), i64 48, i64 7) #0, !dbg !541
  %19 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %18, i64 1, !dbg !541
  %.fn3 = bitcast %swift.refcounted* %19 to i8**, !dbg !541
  store i8* %8, i8** %.fn3, align 8, !dbg !541
  %.data4 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %18, i64 1, i32 1, !dbg !541
  %20 = bitcast i64* %.data4 to %swift.refcounted**, !dbg !541
  store %swift.refcounted* %9, %swift.refcounted** %20, align 8, !dbg !541
  %21 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %18, i64 2, !dbg !541
  %.fn5 = bitcast %swift.refcounted* %21 to i8**, !dbg !541
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA" to i8*), i8** %.fn5, align 8, !dbg !541
  %.data6 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %18, i64 2, i32 1, !dbg !541
  %22 = bitcast i64* %.data6 to %swift.refcounted**, !dbg !541
  store %swift.refcounted* %15, %swift.refcounted** %22, align 8, !dbg !541
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA" to i8*), metadata !556, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !535
  call void @llvm.dbg.value(metadata %swift.refcounted* %18, metadata !556, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !535
  %.sroa.0.0..sroa_idx = getelementptr inbounds %T4main1TV, %T4main1TV* %0, i64 0, i32 2, i32 0, i32 0, !dbg !535
  %23 = bitcast %T1M1SV1CCySf_G** %.sroa.0.0..sroa_idx to %T1M1SV1CC**, !dbg !535
  %.sroa.0.0.copyload89 = load %T1M1SV1CC*, %T1M1SV1CC** %23, align 8, !dbg !535
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !529, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !534
  %.sroa.4.0..sroa_idx = getelementptr inbounds %T4main1TV, %T4main1TV* %0, i64 0, i32 2, i32 0, i32 1, !dbg !535
  %.sroa.4.0..sroa_cast23 = bitcast %TSb* %.sroa.4.0..sroa_idx to i8*, !dbg !535
  %24 = load i8, i8* %.sroa.4.0..sroa_cast23, align 8, !dbg !535
  call void @llvm.dbg.value(metadata i8 %24, metadata !529, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !534
  %.sroa.5.sroa.3.0..sroa.5.0..sroa_idx26.sroa_idx = getelementptr inbounds %T4main1TV, %T4main1TV* %0, i64 0, i32 2, i32 2, i32 0, i32 0, !dbg !535
  %25 = bitcast %T1M1SV1CCySf_G** %.sroa.5.sroa.3.0..sroa.5.0..sroa_idx26.sroa_idx to %T1M1SV1CC**, !dbg !535
  %.sroa.5.sroa.3.0.copyload90 = load %T1M1SV1CC*, %T1M1SV1CC** %25, align 1, !dbg !535
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !529, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !534
  %.sroa.5.sroa.4.0..sroa.5.0..sroa_idx26.sroa_idx = getelementptr inbounds %T4main1TV, %T4main1TV* %0, i64 0, i32 2, i32 2, i32 0, i32 1, !dbg !535
  %.sroa.5.sroa.4.0..sroa.5.0..sroa_idx26.sroa_cast = bitcast %TSb* %.sroa.5.sroa.4.0..sroa.5.0..sroa_idx26.sroa_idx to i8*, !dbg !535
  %26 = load i8, i8* %.sroa.5.sroa.4.0..sroa.5.0..sroa_idx26.sroa_cast, align 1, !dbg !535
  %27 = and i8 %24, 1, !dbg !557
  %28 = icmp ne i8 %27, 0, !dbg !557
  call void @llvm.dbg.value(metadata i1 %28, metadata !529, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !534
  %29 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %.sroa.0.0.copyload89, i1 %28, %swift.type* nonnull @"$sSfN"), !dbg !557
  %30 = extractvalue { i8*, %swift.refcounted* } %29, 0, !dbg !557
  %31 = extractvalue { i8*, %swift.refcounted* } %29, 1, !dbg !557
  call void @llvm.dbg.value(metadata i8* %30, metadata !560, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !557
  call void @llvm.dbg.value(metadata %swift.refcounted* %31, metadata !560, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !557
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* undef, metadata !545, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !561
  call void @llvm.dbg.value(metadata i8 %26, metadata !545, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !561
  %32 = and i8 %26, 1, !dbg !562
  %33 = icmp ne i8 %32, 0, !dbg !562
  call void @llvm.dbg.value(metadata i1 %33, metadata !545, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 8)), !dbg !561
  %34 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %.sroa.5.sroa.3.0.copyload90, i1 %33, %swift.type* nonnull @"$sSfN"), !dbg !562
  %35 = extractvalue { i8*, %swift.refcounted* } %34, 0, !dbg !562
  %36 = extractvalue { i8*, %swift.refcounted* } %34, 1, !dbg !562
  call void @llvm.dbg.value(metadata i8* %35, metadata !565, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !562
  call void @llvm.dbg.value(metadata %swift.refcounted* %36, metadata !565, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !562
  %37 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.31, i64 0, i32 2), i64 32, i64 7) #0, !dbg !562
  %38 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %37, i64 1, !dbg !562
  %.fn12 = bitcast %swift.refcounted* %38 to i8**, !dbg !562
  store i8* %35, i8** %.fn12, align 8, !dbg !562
  %.data13 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %37, i64 1, i32 1, !dbg !562
  %39 = bitcast i64* %.data13 to %swift.refcounted**, !dbg !562
  store %swift.refcounted* %36, %swift.refcounted** %39, align 8, !dbg !562
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.32" to i8*), metadata !566, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !557
  call void @llvm.dbg.value(metadata %swift.refcounted* %37, metadata !566, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !557
  %40 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.35, i64 0, i32 2), i64 48, i64 7) #0, !dbg !557
  %41 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %40, i64 1, !dbg !557
  %.fn14 = bitcast %swift.refcounted* %41 to i8**, !dbg !557
  store i8* %30, i8** %.fn14, align 8, !dbg !557
  %.data15 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %40, i64 1, i32 1, !dbg !557
  %42 = bitcast i64* %.data15 to %swift.refcounted**, !dbg !557
  store %swift.refcounted* %31, %swift.refcounted** %42, align 8, !dbg !557
  %43 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %40, i64 2, !dbg !557
  %.fn16 = bitcast %swift.refcounted* %43 to i8**, !dbg !557
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.32" to i8*), i8** %.fn16, align 8, !dbg !557
  %.data17 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %40, i64 2, i32 1, !dbg !557
  %44 = bitcast i64* %.data17 to %swift.refcounted**, !dbg !557
  store %swift.refcounted* %37, %swift.refcounted** %44, align 8, !dbg !557
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.36" to i8*), metadata !567, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !535
  call void @llvm.dbg.value(metadata %swift.refcounted* %40, metadata !567, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !535
  %45 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.39, i64 0, i32 2), i64 48, i64 7) #0, !dbg !535
  %46 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %45, i64 1, !dbg !535
  %.fn18 = bitcast %swift.refcounted* %46 to i8**, !dbg !535
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA" to i8*), i8** %.fn18, align 8, !dbg !535
  %.data19 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %45, i64 1, i32 1, !dbg !535
  %47 = bitcast i64* %.data19 to %swift.refcounted**, !dbg !535
  store %swift.refcounted* %18, %swift.refcounted** %47, align 8, !dbg !535
  %48 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %45, i64 2, !dbg !535
  %.fn20 = bitcast %swift.refcounted* %48 to i8**, !dbg !535
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.36" to i8*), i8** %.fn20, align 8, !dbg !535
  %.data21 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %45, i64 2, i32 1, !dbg !535
  %49 = bitcast i64* %.data21 to %swift.refcounted**, !dbg !535
  store %swift.refcounted* %40, %swift.refcounted** %49, align 8, !dbg !535
  %50 = insertvalue { i8*, %swift.refcounted* } { i8* bitcast (void (%T4main1TV13TangentVectorV*, %swift.refcounted*)* @"$s4main1TV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA" to i8*), %swift.refcounted* undef }, %swift.refcounted* %45, 1, !dbg !568
  ret { i8*, %swift.refcounted* } %50, !dbg !568
}
define hidden swiftcc { i8*, %swift.refcounted* } @"$s4main1UV28zeroTangentVectorInitializerAC0cD0Vycvg"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3) local_unnamed_addr #2 !dbg !530 {
entry:
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %0, metadata !529, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !569
  call void @llvm.dbg.value(metadata i1 %1, metadata !529, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !569
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %2, metadata !529, metadata !DIExpression(DW_OP_LLVM_fragment, 65, 64)), !dbg !569
  call void @llvm.dbg.value(metadata i1 %3, metadata !529, metadata !DIExpression(DW_OP_LLVM_fragment, 129, 1)), !dbg !569
  %.asUnsubstituted = bitcast %T1M1SV1CCySf_G* %0 to %T1M1SV1CC*, !dbg !570
  %4 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %.asUnsubstituted, i1 %1, %swift.type* nonnull @"$sSfN"), !dbg !570
  %5 = extractvalue { i8*, %swift.refcounted* } %4, 0, !dbg !570
  %6 = extractvalue { i8*, %swift.refcounted* } %4, 1, !dbg !570
  call void @llvm.dbg.value(metadata i8* %5, metadata !573, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !570
  call void @llvm.dbg.value(metadata %swift.refcounted* %6, metadata !573, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !570
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %2, metadata !545, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !574
  call void @llvm.dbg.value(metadata i1 %3, metadata !545, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !574
  %.asUnsubstituted1 = bitcast %T1M1SV1CCySf_G* %2 to %T1M1SV1CC*, !dbg !575
  %7 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %.asUnsubstituted1, i1 %3, %swift.type* nonnull @"$sSfN"), !dbg !575
  %8 = extractvalue { i8*, %swift.refcounted* } %7, 0, !dbg !575
  %9 = extractvalue { i8*, %swift.refcounted* } %7, 1, !dbg !575
  call void @llvm.dbg.value(metadata i8* %8, metadata !578, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !575
  call void @llvm.dbg.value(metadata %swift.refcounted* %9, metadata !578, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !575
  %10 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.42, i64 0, i32 2), i64 32, i64 7) #0, !dbg !575
  %11 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %10, i64 1, !dbg !575
  %.fn = bitcast %swift.refcounted* %11 to i8**, !dbg !575
  store i8* %8, i8** %.fn, align 8, !dbg !575
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %10, i64 1, i32 1, !dbg !575
  %12 = bitcast i64* %.data to %swift.refcounted**, !dbg !575
  store %swift.refcounted* %9, %swift.refcounted** %12, align 8, !dbg !575
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.43" to i8*), metadata !579, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !570
  call void @llvm.dbg.value(metadata %swift.refcounted* %10, metadata !579, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !570
  %13 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.46, i64 0, i32 2), i64 48, i64 7) #0, !dbg !570
  %14 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %13, i64 1, !dbg !570
  %.fn2 = bitcast %swift.refcounted* %14 to i8**, !dbg !570
  store i8* %5, i8** %.fn2, align 8, !dbg !570
  %.data3 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %13, i64 1, i32 1, !dbg !570
  %15 = bitcast i64* %.data3 to %swift.refcounted**, !dbg !570
  store %swift.refcounted* %6, %swift.refcounted** %15, align 8, !dbg !570
  %16 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %13, i64 2, !dbg !570
  %.fn4 = bitcast %swift.refcounted* %16 to i8**, !dbg !570
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.43" to i8*), i8** %.fn4, align 8, !dbg !570
  %.data5 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %13, i64 2, i32 1, !dbg !570
  %17 = bitcast i64* %.data5 to %swift.refcounted**, !dbg !570
  store %swift.refcounted* %10, %swift.refcounted** %17, align 8, !dbg !570
  %18 = insertvalue { i8*, %swift.refcounted* } { i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.47" to i8*), %swift.refcounted* undef }, %swift.refcounted* %13, 1, !dbg !580
  ret { i8*, %swift.refcounted* } %18, !dbg !580
}
define internal swiftcc void @"$s4main1TV16_Differentiation14DifferentiableAadEP4move5alongy13TangentVectorQz_tFTW"(%T4main1TV13TangentVectorV* noalias nocapture readonly dereferenceable(57) %0, %T4main1TV* nocapture swiftself dereferenceable(57) %1, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 !dbg !581 {
entry:
  %2 = alloca %T4main1TV13TangentVectorV, align 8
  %3 = bitcast %T4main1TV13TangentVectorV* %2 to i8*, !dbg !582
  call void @llvm.lifetime.start.p0i8(i64 57, i8* nonnull %3), !dbg !582
  %4 = bitcast %T4main1TV13TangentVectorV* %0 to i8*, !dbg !582
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 dereferenceable(57) %3, i8* nonnull align 8 dereferenceable(57) %4, i64 57, i1 false), !dbg !582
  call swiftcc void @"$s4main1TV4move5alongyAC13TangentVectorV_tF"(%T4main1TV13TangentVectorV* noalias nocapture nonnull dereferenceable(57) %2, %T4main1TV* nocapture nonnull swiftself dereferenceable(57) %1) #16, !dbg !582
  call void @llvm.lifetime.end.p0i8(i64 57, i8* nonnull %3), !dbg !582
  ret void, !dbg !582
}
define internal swiftcc { i8*, %swift.refcounted* } @"$s4main1TV16_Differentiation14DifferentiableAadEP28zeroTangentVectorInitializer0eF0QzycvgTW"(%T4main1TV* noalias nocapture readonly swiftself dereferenceable(57) %0, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 !dbg !583 {
entry:
  %1 = bitcast %T4main1TV* %0 to %T1M1SV1CC**, !dbg !584
  %2 = load %T1M1SV1CC*, %T1M1SV1CC** %1, align 8, !dbg !584
  %.u1.s.b._value = getelementptr inbounds %T4main1TV, %T4main1TV* %0, i64 0, i32 0, i32 0, i32 1, i32 0, !dbg !584
  %3 = load i1, i1* %.u1.s.b._value, align 8, !dbg !584
  %.u1.v.s = getelementptr inbounds %T4main1TV, %T4main1TV* %0, i64 0, i32 0, i32 2, i32 0, !dbg !584
  %4 = bitcast %T1M1SVySfG* %.u1.v.s to %T1M1SV1CC**, !dbg !584
  %5 = load %T1M1SV1CC*, %T1M1SV1CC** %4, align 8, !dbg !584
  %.u1.v.s.b._value = getelementptr inbounds %T4main1TV, %T4main1TV* %0, i64 0, i32 0, i32 2, i32 0, i32 1, i32 0, !dbg !584
  %6 = load i1, i1* %.u1.v.s.b._value, align 8, !dbg !584
  %.u2 = getelementptr inbounds %T4main1TV, %T4main1TV* %0, i64 0, i32 2, !dbg !584
  %7 = bitcast %T4main1UV* %.u2 to %T1M1SV1CC**, !dbg !584
  %8 = load %T1M1SV1CC*, %T1M1SV1CC** %7, align 8, !dbg !584
  %.u2.s.b._value = getelementptr inbounds %T4main1TV, %T4main1TV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !584
  %9 = load i1, i1* %.u2.s.b._value, align 8, !dbg !584
  %.u2.v.s = getelementptr inbounds %T4main1TV, %T4main1TV* %0, i64 0, i32 2, i32 2, i32 0, !dbg !584
  %10 = bitcast %T1M1SVySfG* %.u2.v.s to %T1M1SV1CC**, !dbg !584
  %11 = load %T1M1SV1CC*, %T1M1SV1CC** %10, align 8, !dbg !584
  %.u2.v.s.b._value = getelementptr inbounds %T4main1TV, %T4main1TV* %0, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !584
  %12 = load i1, i1* %.u2.v.s.b._value, align 8, !dbg !584
  %13 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %2, i1 %3, %swift.type* nonnull @"$sSfN") #16, !dbg !585
  %14 = extractvalue { i8*, %swift.refcounted* } %13, 0, !dbg !585
  %15 = extractvalue { i8*, %swift.refcounted* } %13, 1, !dbg !585
  call void @llvm.dbg.value(metadata i8* %14, metadata !591, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !585
  call void @llvm.dbg.value(metadata %swift.refcounted* %15, metadata !591, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !585
  %16 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %5, i1 %6, %swift.type* nonnull @"$sSfN") #16, !dbg !592
  %17 = extractvalue { i8*, %swift.refcounted* } %16, 0, !dbg !592
  %18 = extractvalue { i8*, %swift.refcounted* } %16, 1, !dbg !592
  call void @llvm.dbg.value(metadata i8* %17, metadata !595, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !592
  call void @llvm.dbg.value(metadata %swift.refcounted* %18, metadata !595, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !592
  %19 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.96, i64 0, i32 2), i64 32, i64 7) #0, !dbg !592
  %20 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %19, i64 1, !dbg !592
  %.fn = bitcast %swift.refcounted* %20 to i8**, !dbg !592
  store i8* %17, i8** %.fn, align 8, !dbg !592
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %19, i64 1, i32 1, !dbg !592
  %21 = bitcast i64* %.data to %swift.refcounted**, !dbg !592
  store %swift.refcounted* %18, %swift.refcounted** %21, align 8, !dbg !592
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.97" to i8*), metadata !596, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !585
  call void @llvm.dbg.value(metadata %swift.refcounted* %19, metadata !596, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !585
  %22 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.100, i64 0, i32 2), i64 48, i64 7) #0, !dbg !585
  %23 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %22, i64 1, !dbg !585
  %.fn2 = bitcast %swift.refcounted* %23 to i8**, !dbg !585
  store i8* %14, i8** %.fn2, align 8, !dbg !585
  %.data3 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %22, i64 1, i32 1, !dbg !585
  %24 = bitcast i64* %.data3 to %swift.refcounted**, !dbg !585
  store %swift.refcounted* %15, %swift.refcounted** %24, align 8, !dbg !585
  %25 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %22, i64 2, !dbg !585
  %.fn4 = bitcast %swift.refcounted* %25 to i8**, !dbg !585
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.97" to i8*), i8** %.fn4, align 8, !dbg !585
  %.data5 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %22, i64 2, i32 1, !dbg !585
  %26 = bitcast i64* %.data5 to %swift.refcounted**, !dbg !585
  store %swift.refcounted* %19, %swift.refcounted** %26, align 8, !dbg !585
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.101" to i8*), metadata !597, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !588
  call void @llvm.dbg.value(metadata %swift.refcounted* %22, metadata !597, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !588
  %27 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %8, i1 %9, %swift.type* nonnull @"$sSfN") #16, !dbg !598
  %28 = extractvalue { i8*, %swift.refcounted* } %27, 0, !dbg !598
  %29 = extractvalue { i8*, %swift.refcounted* } %27, 1, !dbg !598
  call void @llvm.dbg.value(metadata i8* %28, metadata !601, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !598
  call void @llvm.dbg.value(metadata %swift.refcounted* %29, metadata !601, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !598
  %30 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %11, i1 %12, %swift.type* nonnull @"$sSfN") #16, !dbg !602
  %31 = extractvalue { i8*, %swift.refcounted* } %30, 0, !dbg !602
  %32 = extractvalue { i8*, %swift.refcounted* } %30, 1, !dbg !602
  call void @llvm.dbg.value(metadata i8* %31, metadata !605, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !602
  call void @llvm.dbg.value(metadata %swift.refcounted* %32, metadata !605, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !602
  %33 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.104, i64 0, i32 2), i64 32, i64 7) #0, !dbg !602
  %34 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %33, i64 1, !dbg !602
  %.fn8 = bitcast %swift.refcounted* %34 to i8**, !dbg !602
  store i8* %31, i8** %.fn8, align 8, !dbg !602
  %.data9 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %33, i64 1, i32 1, !dbg !602
  %35 = bitcast i64* %.data9 to %swift.refcounted**, !dbg !602
  store %swift.refcounted* %32, %swift.refcounted** %35, align 8, !dbg !602
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.105" to i8*), metadata !606, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !598
  call void @llvm.dbg.value(metadata %swift.refcounted* %33, metadata !606, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !598
  %36 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.108, i64 0, i32 2), i64 48, i64 7) #0, !dbg !598
  %37 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %36, i64 1, !dbg !598
  %.fn10 = bitcast %swift.refcounted* %37 to i8**, !dbg !598
  store i8* %28, i8** %.fn10, align 8, !dbg !598
  %.data11 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %36, i64 1, i32 1, !dbg !598
  %38 = bitcast i64* %.data11 to %swift.refcounted**, !dbg !598
  store %swift.refcounted* %29, %swift.refcounted** %38, align 8, !dbg !598
  %39 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %36, i64 2, !dbg !598
  %.fn12 = bitcast %swift.refcounted* %39 to i8**, !dbg !598
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.105" to i8*), i8** %.fn12, align 8, !dbg !598
  %.data13 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %36, i64 2, i32 1, !dbg !598
  %40 = bitcast i64* %.data13 to %swift.refcounted**, !dbg !598
  store %swift.refcounted* %33, %swift.refcounted** %40, align 8, !dbg !598
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.109" to i8*), metadata !607, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !588
  call void @llvm.dbg.value(metadata %swift.refcounted* %36, metadata !607, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !588
  %41 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.112, i64 0, i32 2), i64 48, i64 7) #0, !dbg !588
  %42 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %41, i64 1, !dbg !588
  %.fn14 = bitcast %swift.refcounted* %42 to i8**, !dbg !588
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.101" to i8*), i8** %.fn14, align 8, !dbg !588
  %.data15 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %41, i64 1, i32 1, !dbg !588
  %43 = bitcast i64* %.data15 to %swift.refcounted**, !dbg !588
  store %swift.refcounted* %22, %swift.refcounted** %43, align 8, !dbg !588
  %44 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %41, i64 2, !dbg !588
  %.fn16 = bitcast %swift.refcounted* %44 to i8**, !dbg !588
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.109" to i8*), i8** %.fn16, align 8, !dbg !588
  %.data17 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %41, i64 2, i32 1, !dbg !588
  %45 = bitcast i64* %.data17 to %swift.refcounted**, !dbg !588
  store %swift.refcounted* %36, %swift.refcounted** %45, align 8, !dbg !588
  %46 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.116, i64 0, i32 2), i64 32, i64 7) #0, !dbg !584
  %47 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %46, i64 1, !dbg !584
  %.fn18 = bitcast %swift.refcounted* %47 to i8**, !dbg !584
  store i8* bitcast (void (%T4main1TV13TangentVectorV*, %swift.refcounted*)* @"$s4main1TV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.113" to i8*), i8** %.fn18, align 8, !dbg !584
  %.data19 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %46, i64 1, i32 1, !dbg !584
  %48 = bitcast i64* %.data19 to %swift.refcounted**, !dbg !584
  store %swift.refcounted* %41, %swift.refcounted** %48, align 8, !dbg !584
  %49 = insertvalue { i8*, %swift.refcounted* } { i8* bitcast (void (%T4main1TV13TangentVectorV*, %swift.refcounted*)* @"$s4main1TV13TangentVectorVIego_AEIegr_TRTA" to i8*), %swift.refcounted* undef }, %swift.refcounted* %46, 1, !dbg !584
  ret { i8*, %swift.refcounted* } %49, !dbg !584
}
; Function Attrs: noinline nounwind
define hidden swiftcc { i8*, %T1M1SVySfG* } @"$s4main1UV1s1M1SVySfGvM"(i8* noalias dereferenceable(32) %0, %T4main1UV* nocapture swiftself dereferenceable(25) %1) local_unnamed_addr #1 !dbg !608 {
entry:
  %.s = getelementptr inbounds %T4main1UV, %T4main1UV* %1, i64 0, i32 0, !dbg !611
  %2 = insertvalue { i8*, %T1M1SVySfG* } { i8* bitcast (void (i8*, i1)* @"$s4main1UV1s1M1SVySfGvM.resume.0" to i8*), %T1M1SVySfG* undef }, %T1M1SVySfG* %.s, 1
  ret { i8*, %T1M1SVySfG* } %2
}
define internal swiftcc void @"$s4main1UV1s1M1SVySfGvM.resume.0"(i8* noalias nonnull align 8 dereferenceable(32) %0, i1 %1) #2 !dbg !614 {
entryresume.0:
  ret void, !dbg !615
}
; Function Attrs: noinline nounwind
define hidden swiftcc { i8*, %T4main1VV* } @"$s4main1UV1vAA1VVvM"(i8* noalias dereferenceable(32) %0, %T4main1UV* nocapture swiftself dereferenceable(25) %1) local_unnamed_addr #1 !dbg !618 {
entry:
  %.v = getelementptr inbounds %T4main1UV, %T4main1UV* %1, i64 0, i32 2, !dbg !619
  %2 = insertvalue { i8*, %T4main1VV* } { i8* bitcast (void (i8*, i1)* @"$s4main1UV1vAA1VVvM.resume.0" to i8*), %T4main1VV* undef }, %T4main1VV* %.v, 1
  ret { i8*, %T4main1VV* } %2
}
define internal swiftcc void @"$s4main1UV1vAA1VVvM.resume.0"(i8* noalias nonnull align 8 dereferenceable(32) %0, i1 %1) #2 !dbg !622 {
entryresume.0:
  ret void, !dbg !623
}
; Function Attrs: nounwind
define hidden swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV1s1M1SVySfGvg"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* nocapture readnone %2, i1 %3) local_unnamed_addr #4 !dbg !626 {
entry:
  %4 = bitcast %T1M1SV1CCySf_G* %0 to %swift.refcounted*, !dbg !629
  %5 = insertvalue { %T1M1SV1CCySf_G*, i1 } undef, %T1M1SV1CCySf_G* %0, 0, !dbg !629
  %6 = insertvalue { %T1M1SV1CCySf_G*, i1 } %5, i1 %1, 1, !dbg !629
  %7 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %4) #0, !dbg !629
  ret { %T1M1SV1CCySf_G*, i1 } %6, !dbg !629
}
; Function Attrs: nounwind
define hidden swiftcc void @"$s4main1UV13TangentVectorV1s1M1SVySfGvs"(%T1M1SV1CCySf_G* %0, i1 %1, %T4main1UV13TangentVectorV* nocapture swiftself dereferenceable(25) %2) local_unnamed_addr #4 !dbg !631 {
entry:
  %.s.c = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %2, i64 0, i32 0, i32 0, !dbg !634
  %3 = bitcast %T4main1UV13TangentVectorV* %2 to %swift.refcounted**, !dbg !634
  %4 = load %swift.refcounted*, %swift.refcounted** %3, align 8, !dbg !634
  store %T1M1SV1CCySf_G* %0, %T1M1SV1CCySf_G** %.s.c, align 8, !dbg !634
  %.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %2, i64 0, i32 0, i32 1, i32 0, !dbg !634
  store i1 %1, i1* %.s.b._value, align 8, !dbg !634
  tail call void @swift_release(%swift.refcounted* %4) #0, !dbg !636
  ret void, !dbg !634
}
; Function Attrs: noinline nounwind
define hidden swiftcc { i8*, %T1M1SVySfG* } @"$s4main1UV13TangentVectorV1s1M1SVySfGvM"(i8* noalias dereferenceable(32) %0, %T4main1UV13TangentVectorV* nocapture swiftself dereferenceable(25) %1) local_unnamed_addr #1 !dbg !637 {
entry:
  %.s = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %1, i64 0, i32 0, !dbg !640
  %2 = insertvalue { i8*, %T1M1SVySfG* } { i8* bitcast (void (i8*, i1)* @"$s4main1UV13TangentVectorV1s1M1SVySfGvM.resume.0" to i8*), %T1M1SVySfG* undef }, %T1M1SVySfG* %.s, 1
  ret { i8*, %T1M1SVySfG* } %2
}
define internal swiftcc void @"$s4main1UV13TangentVectorV1s1M1SVySfGvM.resume.0"(i8* noalias nonnull align 8 dereferenceable(32) %0, i1 %1) #2 !dbg !642 {
entryresume.0:
  ret void, !dbg !643
}
; Function Attrs: nounwind
define hidden swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV1vAA1VVADVvg"(%T1M1SV1CCySf_G* nocapture readnone %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3) local_unnamed_addr #4 !dbg !645 {
entry:
  %4 = bitcast %T1M1SV1CCySf_G* %2 to %swift.refcounted*, !dbg !648
  %5 = insertvalue { %T1M1SV1CCySf_G*, i1 } undef, %T1M1SV1CCySf_G* %2, 0, !dbg !648
  %6 = insertvalue { %T1M1SV1CCySf_G*, i1 } %5, i1 %3, 1, !dbg !648
  %7 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %4) #0, !dbg !648
  ret { %T1M1SV1CCySf_G*, i1 } %6, !dbg !648
}
; Function Attrs: nounwind
define hidden swiftcc void @"$s4main1UV13TangentVectorV1vAA1VVADVvs"(%T1M1SV1CCySf_G* %0, i1 %1, %T4main1UV13TangentVectorV* nocapture swiftself dereferenceable(25) %2) local_unnamed_addr #4 !dbg !650 {
entry:
  %.v.s.c = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %2, i64 0, i32 2, i32 0, i32 0, !dbg !653
  %3 = bitcast %T1M1SV1CCySf_G** %.v.s.c to %swift.refcounted**, !dbg !653
  %4 = load %swift.refcounted*, %swift.refcounted** %3, align 8, !dbg !653
  store %T1M1SV1CCySf_G* %0, %T1M1SV1CCySf_G** %.v.s.c, align 8, !dbg !653
  %.v.s1.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %2, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !653
  store i1 %1, i1* %.v.s1.b._value, align 8, !dbg !653
  tail call void @swift_release(%swift.refcounted* %4) #0, !dbg !655
  ret void, !dbg !653
}
; Function Attrs: noinline nounwind
define hidden swiftcc { i8*, %T4main1VV13TangentVectorV* } @"$s4main1UV13TangentVectorV1vAA1VVADVvM"(i8* noalias dereferenceable(32) %0, %T4main1UV13TangentVectorV* nocapture swiftself dereferenceable(25) %1) local_unnamed_addr #1 !dbg !656 {
entry:
  %.v = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %1, i64 0, i32 2, !dbg !657
  %2 = insertvalue { i8*, %T4main1VV13TangentVectorV* } { i8* bitcast (void (i8*, i1)* @"$s4main1UV13TangentVectorV1vAA1VVADVvM.resume.0" to i8*), %T4main1VV13TangentVectorV* undef }, %T4main1VV13TangentVectorV* %.v, 1
  ret { i8*, %T4main1VV13TangentVectorV* } %2
}
define internal swiftcc void @"$s4main1UV13TangentVectorV1vAA1VVADVvM.resume.0"(i8* noalias nonnull align 8 dereferenceable(32) %0, i1 %1) #2 !dbg !659 {
entryresume.0:
  ret void, !dbg !660
}
; Function Attrs: norecurse nounwind readnone
define hidden swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV1s1vAE1M1SVySfG_AA1VVADVtcfC"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3) local_unnamed_addr #8 !dbg !662 {
entry:
  %4 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } undef, %T1M1SV1CCySf_G* %0, 0, !dbg !665
  %5 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %4, i1 %1, 1, !dbg !665
  %6 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %5, %T1M1SV1CCySf_G* %2, 2, !dbg !665
  %7 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %6, i1 %3, 3, !dbg !665
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %7, !dbg !665
}
define hidden swiftcc { i8*, %swift.refcounted* } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvg"(%T1M1SV1CCySf_G* %0, i1 %1) local_unnamed_addr #2 !dbg !213 {
entry:
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %0, metadata !212, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !666
  call void @llvm.dbg.value(metadata i1 %1, metadata !212, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !666
  %.asUnsubstituted = bitcast %T1M1SV1CCySf_G* %0 to %T1M1SV1CC*, !dbg !667
  %2 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %.asUnsubstituted, i1 %1, %swift.type* nonnull @"$sSfN"), !dbg !667
  %3 = extractvalue { i8*, %swift.refcounted* } %2, 0, !dbg !667
  %4 = extractvalue { i8*, %swift.refcounted* } %2, 1, !dbg !667
  call void @llvm.dbg.value(metadata i8* %3, metadata !670, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !667
  call void @llvm.dbg.value(metadata %swift.refcounted* %4, metadata !670, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !667
  %5 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.50, i64 0, i32 2), i64 32, i64 7) #0, !dbg !667
  %6 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %5, i64 1, !dbg !667
  %.fn = bitcast %swift.refcounted* %6 to i8**, !dbg !667
  store i8* %3, i8** %.fn, align 8, !dbg !667
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %5, i64 1, i32 1, !dbg !667
  %7 = bitcast i64* %.data to %swift.refcounted**, !dbg !667
  store %swift.refcounted* %4, %swift.refcounted** %7, align 8, !dbg !667
  %8 = insertvalue { i8*, %swift.refcounted* } { i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.51" to i8*), %swift.refcounted* undef }, %swift.refcounted* %5, 1, !dbg !671
  ret { i8*, %swift.refcounted* } %8, !dbg !671
}
define hidden swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV4zeroAEvgZ"() local_unnamed_addr #2 !dbg !266 {
entry:
  %0 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV4zeroACyxGvgZ"(%swift.type* nonnull @"$sSfN"), !dbg !672
  %1 = extractvalue { %T1M1SV1CC*, i1 } %0, 0, !dbg !672
  %2 = extractvalue { %T1M1SV1CC*, i1 } %0, 1, !dbg !672
  %.asSubstituted = bitcast %T1M1SV1CC* %1 to %T1M1SV1CCySf_G*, !dbg !672
  %3 = insertvalue { %T1M1SV1CCySf_G*, i1 } undef, %T1M1SV1CCySf_G* %.asSubstituted, 0, !dbg !672
  %4 = insertvalue { %T1M1SV1CCySf_G*, i1 } %3, i1 %2, 1, !dbg !672
  ret { %T1M1SV1CCySf_G*, i1 } %4, !dbg !672
}
define hidden swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV1poiyA2E_AEtFZ"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3) local_unnamed_addr #2 {
  %5 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV1poiyA2E_AEtFZTm"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* @"$s1M1SV1poiyACyxGAE_AEtFZ") #2
  %6 = extractvalue { %T1M1SV1CCySf_G*, i1 } %5, 0
  %7 = insertvalue { %T1M1SV1CCySf_G*, i1 } undef, %T1M1SV1CCySf_G* %6, 0
  %8 = extractvalue { %T1M1SV1CCySf_G*, i1 } %5, 1
  %9 = insertvalue { %T1M1SV1CCySf_G*, i1 } %7, i1 %8, 1
  ret { %T1M1SV1CCySf_G*, i1 } %9
}
define hidden swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV1soiyA2E_AEtFZ"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3) local_unnamed_addr #2 {
  %5 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV1poiyA2E_AEtFZTm"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* @"$s1M1SV1soiyACyxGAE_AEtFZ") #2
  %6 = extractvalue { %T1M1SV1CCySf_G*, i1 } %5, 0
  %7 = insertvalue { %T1M1SV1CCySf_G*, i1 } undef, %T1M1SV1CCySf_G* %6, 0
  %8 = extractvalue { %T1M1SV1CCySf_G*, i1 } %5, 1
  %9 = insertvalue { %T1M1SV1CCySf_G*, i1 } %7, i1 %8, 1
  ret { %T1M1SV1CCySf_G*, i1 } %9
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV1poiyA2E_AEtFZTm"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* %4) local_unnamed_addr #2 {
entry:
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %0, metadata !294, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !674
  call void @llvm.dbg.value(metadata i1 %1, metadata !294, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !674
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %2, metadata !299, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !674
  call void @llvm.dbg.value(metadata i1 %3, metadata !299, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !674
  %.asUnsubstituted = bitcast %T1M1SV1CCySf_G* %0 to %T1M1SV1CC*, !dbg !675
  %.asUnsubstituted1 = bitcast %T1M1SV1CCySf_G* %2 to %T1M1SV1CC*, !dbg !675
  %5 = tail call swiftcc { %T1M1SV1CC*, i1 } %4(%T1M1SV1CC* %.asUnsubstituted, i1 %1, %T1M1SV1CC* %.asUnsubstituted1, i1 %3, %swift.type* nonnull @"$sSfN"), !dbg !675
  %6 = extractvalue { %T1M1SV1CC*, i1 } %5, 0, !dbg !675
  %7 = extractvalue { %T1M1SV1CC*, i1 } %5, 1, !dbg !675
  %.asSubstituted = bitcast %T1M1SV1CC* %6 to %T1M1SV1CCySf_G*, !dbg !675
  %8 = insertvalue { %T1M1SV1CCySf_G*, i1 } undef, %T1M1SV1CCySf_G* %.asSubstituted, 0, !dbg !675
  %9 = insertvalue { %T1M1SV1CCySf_G*, i1 } %8, i1 %7, 1, !dbg !675
  ret { %T1M1SV1CCySf_G*, i1 } %9, !dbg !675
}
define hidden swiftcc i1 @"$s4main1VV13TangentVectorV23__derived_struct_equalsySbAE_AEtFZ"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3) local_unnamed_addr #2 !dbg !332 {
entry:
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %0, metadata !331, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !677
  call void @llvm.dbg.value(metadata i1 %1, metadata !331, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !677
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %2, metadata !336, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !677
  call void @llvm.dbg.value(metadata i1 %3, metadata !336, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !677
  %.asUnsubstituted = bitcast %T1M1SV1CCySf_G* %0 to %T1M1SV1CC*, !dbg !678
  %.asUnsubstituted1 = bitcast %T1M1SV1CCySf_G* %2 to %T1M1SV1CC*, !dbg !678
  %4 = tail call swiftcc i1 @"$s1M1SV2eeoiySbACyxG_AEtFZ"(%T1M1SV1CC* %.asUnsubstituted, i1 %1, %T1M1SV1CC* %.asUnsubstituted1, i1 %3, %swift.type* nonnull @"$sSfN"), !dbg !678
  ret i1 %4, !dbg !678
}
define internal swiftcc void @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAafGP4move5alongyADQz_tFTW"(%T4main1UV13TangentVectorV* noalias nocapture dereferenceable(25) %0, %T4main1UV13TangentVectorV* nocapture swiftself dereferenceable(25) %1, %swift.type* %Self, i8** %SelfWitnessTable) #2 !dbg !680 {
entry:
  %2 = bitcast %T4main1UV13TangentVectorV* %0 to %swift.opaque*, !dbg !683
  %3 = bitcast %T4main1UV13TangentVectorV* %1 to %swift.opaque*, !dbg !683
  tail call swiftcc void @"$s16_Differentiation14DifferentiablePAA13TangentVectorACQzRszrlE4move5alongyx_tF"(%swift.opaque* noalias nocapture nonnull %2, %swift.type* %Self, i8** %SelfWitnessTable, %swift.opaque* nocapture nonnull swiftself %3) #16, !dbg !683
  ret void, !dbg !683
}
define internal swiftcc { i8*, %swift.refcounted* } @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAafGP04zerobC11InitializerADQzycvgTW"(%T4main1UV13TangentVectorV* noalias nocapture readonly swiftself dereferenceable(25) %0, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 !dbg !684 {
entry:
  %1 = bitcast %T4main1UV13TangentVectorV* %0 to %T1M1SV1CC**, !dbg !688
  %2 = load %T1M1SV1CC*, %T1M1SV1CC** %1, align 8, !dbg !688
  %.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 0, i32 1, i32 0, !dbg !688
  %3 = load i1, i1* %.s.b._value, align 8, !dbg !688
  %.v.s = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, !dbg !688
  %4 = bitcast %T1M1SVySfG* %.v.s to %T1M1SV1CC**, !dbg !688
  %5 = load %T1M1SV1CC*, %T1M1SV1CC** %4, align 8, !dbg !688
  %.v.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !688
  %6 = load i1, i1* %.v.s.b._value, align 8, !dbg !688
  %7 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %2, i1 %3, %swift.type* nonnull @"$sSfN") #16, !dbg !689
  %8 = extractvalue { i8*, %swift.refcounted* } %7, 0, !dbg !689
  %9 = extractvalue { i8*, %swift.refcounted* } %7, 1, !dbg !689
  call void @llvm.dbg.value(metadata i8* %8, metadata !692, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !689
  call void @llvm.dbg.value(metadata %swift.refcounted* %9, metadata !692, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !689
  %10 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %5, i1 %6, %swift.type* nonnull @"$sSfN") #16, !dbg !693
  %11 = extractvalue { i8*, %swift.refcounted* } %10, 0, !dbg !693
  %12 = extractvalue { i8*, %swift.refcounted* } %10, 1, !dbg !693
  call void @llvm.dbg.value(metadata i8* %11, metadata !696, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !693
  call void @llvm.dbg.value(metadata %swift.refcounted* %12, metadata !696, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !693
  %13 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.84, i64 0, i32 2), i64 32, i64 7) #0, !dbg !693
  %14 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %13, i64 1, !dbg !693
  %.fn = bitcast %swift.refcounted* %14 to i8**, !dbg !693
  store i8* %11, i8** %.fn, align 8, !dbg !693
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %13, i64 1, i32 1, !dbg !693
  %15 = bitcast i64* %.data to %swift.refcounted**, !dbg !693
  store %swift.refcounted* %12, %swift.refcounted** %15, align 8, !dbg !693
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.85" to i8*), metadata !697, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !689
  call void @llvm.dbg.value(metadata %swift.refcounted* %13, metadata !697, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !689
  %16 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.88, i64 0, i32 2), i64 48, i64 7) #0, !dbg !689
  %17 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %16, i64 1, !dbg !689
  %.fn2 = bitcast %swift.refcounted* %17 to i8**, !dbg !689
  store i8* %8, i8** %.fn2, align 8, !dbg !689
  %.data3 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %16, i64 1, i32 1, !dbg !689
  %18 = bitcast i64* %.data3 to %swift.refcounted**, !dbg !689
  store %swift.refcounted* %9, %swift.refcounted** %18, align 8, !dbg !689
  %19 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %16, i64 2, !dbg !689
  %.fn4 = bitcast %swift.refcounted* %19 to i8**, !dbg !689
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.85" to i8*), i8** %.fn4, align 8, !dbg !689
  %.data5 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %16, i64 2, i32 1, !dbg !689
  %20 = bitcast i64* %.data5 to %swift.refcounted**, !dbg !689
  store %swift.refcounted* %13, %swift.refcounted** %20, align 8, !dbg !689
  %21 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.92, i64 0, i32 2), i64 32, i64 7) #0, !dbg !688
  %22 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %21, i64 1, !dbg !688
  %.fn6 = bitcast %swift.refcounted* %22 to i8**, !dbg !688
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.89" to i8*), i8** %.fn6, align 8, !dbg !688
  %.data7 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %21, i64 1, i32 1, !dbg !688
  %23 = bitcast i64* %.data7 to %swift.refcounted**, !dbg !688
  store %swift.refcounted* %16, %swift.refcounted** %23, align 8, !dbg !688
  %24 = insertvalue { i8*, %swift.refcounted* } { i8* bitcast (void (%T4main1UV13TangentVectorV*, %swift.refcounted*)* @"$s4main1UV13TangentVectorVIego_AEIegr_TRTA.93" to i8*), %swift.refcounted* undef }, %swift.refcounted* %21, 1, !dbg !688
  ret { i8*, %swift.refcounted* } %24, !dbg !688
}
define internal swiftcc void @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP4zeroxvgZTW"(%T4main1UV13TangentVectorV* noalias nocapture sret %0, %swift.type* nocapture readnone swiftself %1, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 !dbg !698 {
entry:
  %2 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV4zeroACyxGvgZ"(%swift.type* nonnull @"$sSfN") #16, !dbg !702
  %3 = extractvalue { %T1M1SV1CC*, i1 } %2, 0, !dbg !702
  %4 = extractvalue { %T1M1SV1CC*, i1 } %2, 1, !dbg !702
  %5 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV4zeroACyxGvgZ"(%swift.type* nonnull @"$sSfN") #16, !dbg !705
  %6 = extractvalue { %T1M1SV1CC*, i1 } %5, 0, !dbg !705
  %7 = extractvalue { %T1M1SV1CC*, i1 } %5, 1, !dbg !705
  %8 = bitcast %T4main1UV13TangentVectorV* %0 to %T1M1SV1CC**, !dbg !704
  store %T1M1SV1CC* %3, %T1M1SV1CC** %8, align 8, !dbg !704
  %.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 0, i32 1, i32 0, !dbg !704
  store i1 %4, i1* %.s.b._value, align 8, !dbg !704
  %.v.s = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, !dbg !704
  %9 = bitcast %T1M1SVySfG* %.v.s to %T1M1SV1CC**, !dbg !704
  store %T1M1SV1CC* %6, %T1M1SV1CC** %9, align 8, !dbg !704
  %.v.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !704
  store i1 %7, i1* %.v.s.b._value, align 8, !dbg !704
  ret void, !dbg !704
}
define internal swiftcc void @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTW"(%T4main1UV13TangentVectorV* noalias nocapture sret %0, %T4main1UV13TangentVectorV* noalias nocapture readonly dereferenceable(25) %1, %T4main1UV13TangentVectorV* noalias nocapture readonly dereferenceable(25) %2, %swift.type* nocapture readnone swiftself %3, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 {
  tail call swiftcc void @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTWTm"(%T4main1UV13TangentVectorV* noalias nocapture sret %0, %T4main1UV13TangentVectorV* noalias nocapture readonly dereferenceable(25) %1, %T4main1UV13TangentVectorV* noalias nocapture readonly dereferenceable(25) %2, %swift.type* nocapture readnone swiftself %3, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* @"$s1M1SV1poiyACyxGAE_AEtFZ") #2
  ret void
}
define internal swiftcc void @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP2peoiyyxz_xtFZTW"(%T4main1UV13TangentVectorV* nocapture dereferenceable(25) %0, %T4main1UV13TangentVectorV* noalias nocapture dereferenceable(25) %1, %swift.type* swiftself %2, %swift.type* %Self, i8** %SelfWitnessTable) #2 !dbg !707 {
entry:
  %3 = bitcast %T4main1UV13TangentVectorV* %0 to %swift.opaque*, !dbg !710
  %4 = bitcast %T4main1UV13TangentVectorV* %1 to %swift.opaque*, !dbg !710
  call swiftcc void @"$ss18AdditiveArithmeticPsE2peoiyyxz_xtFZTm"(%swift.opaque* nocapture %3, %swift.opaque* noalias nocapture %4, %swift.type* %Self, i8** %SelfWitnessTable, %swift.type* swiftself %2, void (%swift.opaque*, %swift.opaque*, %swift.opaque*, %swift.type*, %swift.type*, i8**)* @"$ss18AdditiveArithmeticP1poiyxx_xtFZTj"), !dbg !710
  ret void, !dbg !710
}
define internal swiftcc void @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP1soiyxx_xtFZTW"(%T4main1UV13TangentVectorV* noalias nocapture sret %0, %T4main1UV13TangentVectorV* noalias nocapture readonly dereferenceable(25) %1, %T4main1UV13TangentVectorV* noalias nocapture readonly dereferenceable(25) %2, %swift.type* nocapture readnone swiftself %3, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 {
  tail call swiftcc void @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTWTm"(%T4main1UV13TangentVectorV* noalias nocapture sret %0, %T4main1UV13TangentVectorV* noalias nocapture readonly dereferenceable(25) %1, %T4main1UV13TangentVectorV* noalias nocapture readonly dereferenceable(25) %2, %swift.type* nocapture readnone swiftself %3, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* @"$s1M1SV1soiyACyxGAE_AEtFZ") #2
  ret void
}
define internal swiftcc void @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTWTm"(%T4main1UV13TangentVectorV* noalias nocapture sret %0, %T4main1UV13TangentVectorV* noalias nocapture readonly dereferenceable(25) %1, %T4main1UV13TangentVectorV* noalias nocapture readonly dereferenceable(25) %2, %swift.type* nocapture readnone swiftself %3, %swift.type* nocapture readnone %4, i8** nocapture readnone %5, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* %6) #2 {
entry:
  %7 = bitcast %T4main1UV13TangentVectorV* %1 to %T1M1SV1CC**, !dbg !711
  %8 = load %T1M1SV1CC*, %T1M1SV1CC** %7, align 8, !dbg !711
  %.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %1, i64 0, i32 0, i32 1, i32 0, !dbg !711
  %9 = load i1, i1* %.s.b._value, align 8, !dbg !711
  %.v.s = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %1, i64 0, i32 2, i32 0, !dbg !711
  %10 = bitcast %T1M1SVySfG* %.v.s to %T1M1SV1CC**, !dbg !711
  %11 = load %T1M1SV1CC*, %T1M1SV1CC** %10, align 8, !dbg !711
  %.v.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !711
  %12 = load i1, i1* %.v.s.b._value, align 8, !dbg !711
  %13 = bitcast %T4main1UV13TangentVectorV* %2 to %T1M1SV1CC**, !dbg !711
  %14 = load %T1M1SV1CC*, %T1M1SV1CC** %13, align 8, !dbg !711
  %.s1.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %2, i64 0, i32 0, i32 1, i32 0, !dbg !711
  %15 = load i1, i1* %.s1.b._value, align 8, !dbg !711
  %.v2.s = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %2, i64 0, i32 2, i32 0, !dbg !711
  %16 = bitcast %T1M1SVySfG* %.v2.s to %T1M1SV1CC**, !dbg !711
  %17 = load %T1M1SV1CC*, %T1M1SV1CC** %16, align 8, !dbg !711
  %.v2.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %2, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !711
  %18 = load i1, i1* %.v2.s.b._value, align 8, !dbg !711
  %19 = tail call swiftcc { %T1M1SV1CC*, i1 } %6(%T1M1SV1CC* %8, i1 %9, %T1M1SV1CC* %14, i1 %15, %swift.type* nonnull @"$sSfN") #16, !dbg !715
  %20 = extractvalue { %T1M1SV1CC*, i1 } %19, 0, !dbg !715
  %21 = extractvalue { %T1M1SV1CC*, i1 } %19, 1, !dbg !715
  %22 = tail call swiftcc { %T1M1SV1CC*, i1 } %6(%T1M1SV1CC* %11, i1 %12, %T1M1SV1CC* %17, i1 %18, %swift.type* nonnull @"$sSfN") #16, !dbg !717
  %23 = extractvalue { %T1M1SV1CC*, i1 } %22, 0, !dbg !717
  %24 = extractvalue { %T1M1SV1CC*, i1 } %22, 1, !dbg !717
  %25 = bitcast %T4main1UV13TangentVectorV* %0 to %T1M1SV1CC**, !dbg !711
  store %T1M1SV1CC* %20, %T1M1SV1CC** %25, align 8, !dbg !711
  %.s7.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 0, i32 1, i32 0, !dbg !711
  store i1 %21, i1* %.s7.b._value, align 8, !dbg !711
  %.v8.s = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, !dbg !711
  %26 = bitcast %T1M1SVySfG* %.v8.s to %T1M1SV1CC**, !dbg !711
  store %T1M1SV1CC* %23, %T1M1SV1CC** %26, align 8, !dbg !711
  %.v8.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !711
  store i1 %24, i1* %.v8.s.b._value, align 8, !dbg !711
  ret void, !dbg !711
}
define internal swiftcc void @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP2seoiyyxz_xtFZTW"(%T4main1UV13TangentVectorV* nocapture dereferenceable(25) %0, %T4main1UV13TangentVectorV* noalias nocapture dereferenceable(25) %1, %swift.type* swiftself %2, %swift.type* %Self, i8** %SelfWitnessTable) #2 !dbg !719 {
entry:
  %3 = bitcast %T4main1UV13TangentVectorV* %0 to %swift.opaque*, !dbg !720
  %4 = bitcast %T4main1UV13TangentVectorV* %1 to %swift.opaque*, !dbg !720
  call swiftcc void @"$ss18AdditiveArithmeticPsE2peoiyyxz_xtFZTm"(%swift.opaque* nocapture %3, %swift.opaque* noalias nocapture %4, %swift.type* %Self, i8** %SelfWitnessTable, %swift.type* swiftself %2, void (%swift.opaque*, %swift.opaque*, %swift.opaque*, %swift.type*, %swift.type*, i8**)* @"$ss18AdditiveArithmeticP1soiyxx_xtFZTj"), !dbg !720
  ret void, !dbg !720
}
define internal swiftcc i1 @"$s4main1UV13TangentVectorVSQAASQ2eeoiySbx_xtFZTW"(%T4main1UV13TangentVectorV* noalias nocapture readonly dereferenceable(25) %0, %T4main1UV13TangentVectorV* noalias nocapture readonly dereferenceable(25) %1, %swift.type* nocapture readnone swiftself %2, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 !dbg !721 {
entry:
  %3 = bitcast %T4main1UV13TangentVectorV* %0 to %T1M1SV1CC**, !dbg !724
  %4 = load %T1M1SV1CC*, %T1M1SV1CC** %3, align 8, !dbg !724
  %.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 0, i32 1, i32 0, !dbg !724
  %5 = load i1, i1* %.s.b._value, align 8, !dbg !724
  %.v.s = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, !dbg !724
  %6 = bitcast %T1M1SVySfG* %.v.s to %T1M1SV1CC**, !dbg !724
  %7 = load %T1M1SV1CC*, %T1M1SV1CC** %6, align 8, !dbg !724
  %.v.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !724
  %8 = load i1, i1* %.v.s.b._value, align 8, !dbg !724
  %9 = bitcast %T4main1UV13TangentVectorV* %1 to %T1M1SV1CC**, !dbg !724
  %10 = load %T1M1SV1CC*, %T1M1SV1CC** %9, align 8, !dbg !724
  %.s1.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %1, i64 0, i32 0, i32 1, i32 0, !dbg !724
  %11 = load i1, i1* %.s1.b._value, align 8, !dbg !724
  %.v2.s = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %1, i64 0, i32 2, i32 0, !dbg !724
  %12 = bitcast %T1M1SVySfG* %.v2.s to %T1M1SV1CC**, !dbg !724
  %13 = load %T1M1SV1CC*, %T1M1SV1CC** %12, align 8, !dbg !724
  %.v2.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !724
  %14 = load i1, i1* %.v2.s.b._value, align 8, !dbg !724
  %15 = tail call swiftcc i1 @"$s1M1SV2eeoiySbACyxG_AEtFZ"(%T1M1SV1CC* %4, i1 %5, %T1M1SV1CC* %10, i1 %11, %swift.type* nonnull @"$sSfN") #16, !dbg !725
  br i1 %15, label %16, label %18, !dbg !725

16:                                               ; preds = %entry
  %17 = tail call swiftcc i1 @"$s1M1SV2eeoiySbACyxG_AEtFZ"(%T1M1SV1CC* %7, i1 %8, %T1M1SV1CC* %13, i1 %14, %swift.type* nonnull @"$sSfN") #16, !dbg !727
  br label %18, !dbg !725

18:                                               ; preds = %entry, %16
  %19 = phi i1 [ %17, %16 ], [ false, %entry ], !dbg !725
  ret i1 %19, !dbg !724
}
define hidden swiftcc void @"$s4main1VV4move5alongyAC13TangentVectorV_tF"(%T1M1SV1CCySf_G* %0, i1 %1, %T4main1VV* nocapture swiftself dereferenceable(9) %2) local_unnamed_addr #2 !dbg !452 {
entry:
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %0, metadata !451, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !729
  call void @llvm.dbg.value(metadata i1 %1, metadata !451, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !729
  call void @llvm.dbg.value(metadata %T4main1VV* %2, metadata !495, metadata !DIExpression(DW_OP_deref)), !dbg !729
  %.s.c = getelementptr inbounds %T4main1VV, %T4main1VV* %2, i64 0, i32 0, i32 0, !dbg !730
  %3 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.s.c, align 8, !dbg !730
  %.s.b._value = getelementptr inbounds %T4main1VV, %T4main1VV* %2, i64 0, i32 0, i32 1, i32 0, !dbg !730
  %4 = load i1, i1* %.s.b._value, align 8, !dbg !730
  %5 = bitcast %T1M1SV1CCySf_G* %0 to %swift.refcounted*, !dbg !729
  %.asUnsubstituted = bitcast %T1M1SV1CCySf_G* %3 to %T1M1SV1CC*, !dbg !735
  %.asUnsubstituted1 = bitcast %T1M1SV1CCySf_G* %0 to %T1M1SV1CC*, !dbg !735
  %6 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %5) #0, !dbg !729
  %7 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV1poiyACyxGAE_AEtFZ"(%T1M1SV1CC* %.asUnsubstituted, i1 %4, %T1M1SV1CC* %.asUnsubstituted1, i1 %1, %swift.type* nonnull @"$sSfN"), !dbg !735
  tail call void @swift_release(%swift.refcounted* %5) #0, !dbg !729
  %8 = extractvalue { %T1M1SV1CC*, i1 } %7, 0, !dbg !735
  %9 = extractvalue { %T1M1SV1CC*, i1 } %7, 1, !dbg !735
  %10 = bitcast %T1M1SV1CCySf_G* %3 to %swift.refcounted*, !dbg !729
  tail call void @swift_release(%swift.refcounted* %10) #0, !dbg !729
  %11 = bitcast %T4main1VV* %2 to %T1M1SV1CC**, !dbg !730
  store %T1M1SV1CC* %8, %T1M1SV1CC** %11, align 8, !dbg !730
  store i1 %9, i1* %.s.b._value, align 8, !dbg !730
  ret void, !dbg !733
}
define hidden swiftcc { i8*, %swift.refcounted* } @"$s4main1VV28zeroTangentVectorInitializerAC0cD0Vycvg"(%T1M1SV1CCySf_G* %0, i1 %1) local_unnamed_addr #2 !dbg !546 {
entry:
  call void @llvm.dbg.value(metadata %T1M1SV1CCySf_G* %0, metadata !545, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !736
  call void @llvm.dbg.value(metadata i1 %1, metadata !545, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 1)), !dbg !736
  %.asUnsubstituted = bitcast %T1M1SV1CCySf_G* %0 to %T1M1SV1CC*, !dbg !737
  %2 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %.asUnsubstituted, i1 %1, %swift.type* nonnull @"$sSfN"), !dbg !737
  %3 = extractvalue { i8*, %swift.refcounted* } %2, 0, !dbg !737
  %4 = extractvalue { i8*, %swift.refcounted* } %2, 1, !dbg !737
  call void @llvm.dbg.value(metadata i8* %3, metadata !740, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !737
  call void @llvm.dbg.value(metadata %swift.refcounted* %4, metadata !740, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !737
  %5 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.54, i64 0, i32 2), i64 32, i64 7) #0, !dbg !737
  %6 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %5, i64 1, !dbg !737
  %.fn = bitcast %swift.refcounted* %6 to i8**, !dbg !737
  store i8* %3, i8** %.fn, align 8, !dbg !737
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %5, i64 1, i32 1, !dbg !737
  %7 = bitcast i64* %.data to %swift.refcounted**, !dbg !737
  store %swift.refcounted* %4, %swift.refcounted** %7, align 8, !dbg !737
  %8 = insertvalue { i8*, %swift.refcounted* } { i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.55" to i8*), %swift.refcounted* undef }, %swift.refcounted* %5, 1, !dbg !741
  ret { i8*, %swift.refcounted* } %8, !dbg !741
}
define internal swiftcc void @"$s4main1UV16_Differentiation14DifferentiableAadEP4move5alongy13TangentVectorQz_tFTW"(%T4main1UV13TangentVectorV* noalias nocapture readonly dereferenceable(25) %0, %T4main1UV* nocapture swiftself dereferenceable(25) %1, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 !dbg !742 {
entry:
  %.s.c = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 0, i32 0, !dbg !743
  %2 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.s.c, align 8, !dbg !743
  %.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 0, i32 1, i32 0, !dbg !743
  %3 = load i1, i1* %.s.b._value, align 8, !dbg !743
  %.v.s.c = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 0, !dbg !743
  %4 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.v.s.c, align 8, !dbg !743
  %.v.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !743
  %5 = load i1, i1* %.v.s.b._value, align 8, !dbg !743
  call void @llvm.dbg.value(metadata %T4main1UV* %1, metadata !471, metadata !DIExpression(DW_OP_deref)), !dbg !744
  %.s1.c = getelementptr inbounds %T4main1UV, %T4main1UV* %1, i64 0, i32 0, i32 0, !dbg !745
  %6 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.s1.c, align 8, !dbg !745
  %.s1.b._value = getelementptr inbounds %T4main1UV, %T4main1UV* %1, i64 0, i32 0, i32 1, i32 0, !dbg !745
  %7 = load i1, i1* %.s1.b._value, align 8, !dbg !745
  %8 = bitcast %T1M1SV1CCySf_G* %2 to %swift.refcounted*, !dbg !744
  %.asUnsubstituted = bitcast %T1M1SV1CCySf_G* %6 to %T1M1SV1CC*, !dbg !750
  %.asUnsubstituted2 = bitcast %T1M1SV1CCySf_G* %2 to %T1M1SV1CC*, !dbg !750
  %9 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %8) #0, !dbg !744
  %10 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV1poiyACyxGAE_AEtFZ"(%T1M1SV1CC* %.asUnsubstituted, i1 %7, %T1M1SV1CC* %.asUnsubstituted2, i1 %3, %swift.type* nonnull @"$sSfN") #16, !dbg !750
  %11 = extractvalue { %T1M1SV1CC*, i1 } %10, 0, !dbg !750
  %12 = extractvalue { %T1M1SV1CC*, i1 } %10, 1, !dbg !750
  %13 = bitcast %T1M1SV1CCySf_G* %6 to %swift.refcounted*, !dbg !743
  tail call void @swift_release(%swift.refcounted* %13) #0, !dbg !743
  %14 = bitcast %T4main1UV* %1 to %T1M1SV1CC**, !dbg !745
  store %T1M1SV1CC* %11, %T1M1SV1CC** %14, align 8, !dbg !745
  store i1 %12, i1* %.s1.b._value, align 8, !dbg !745
  tail call void @swift_release(%swift.refcounted* %8) #0, !dbg !743
  call void @llvm.dbg.value(metadata %T4main1UV* %1, metadata !495, metadata !DIExpression(DW_OP_plus_uconst, 16, DW_OP_deref, DW_OP_stack_value)), !dbg !751
  %.v5.s.c = getelementptr inbounds %T4main1UV, %T4main1UV* %1, i64 0, i32 2, i32 0, i32 0, !dbg !752
  %15 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.v5.s.c, align 8, !dbg !752
  %.v5.s.b._value = getelementptr inbounds %T4main1UV, %T4main1UV* %1, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !752
  %16 = load i1, i1* %.v5.s.b._value, align 8, !dbg !752
  %17 = bitcast %T1M1SV1CCySf_G* %4 to %swift.refcounted*, !dbg !751
  %.asUnsubstituted6 = bitcast %T1M1SV1CCySf_G* %15 to %T1M1SV1CC*, !dbg !757
  %.asUnsubstituted7 = bitcast %T1M1SV1CCySf_G* %4 to %T1M1SV1CC*, !dbg !757
  %18 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %17) #0, !dbg !751
  %19 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV1poiyACyxGAE_AEtFZ"(%T1M1SV1CC* %.asUnsubstituted6, i1 %16, %T1M1SV1CC* %.asUnsubstituted7, i1 %5, %swift.type* nonnull @"$sSfN") #16, !dbg !757
  tail call void @swift_release(%swift.refcounted* %17) #0, !dbg !743
  %20 = extractvalue { %T1M1SV1CC*, i1 } %19, 0, !dbg !757
  %21 = extractvalue { %T1M1SV1CC*, i1 } %19, 1, !dbg !757
  %22 = bitcast %T1M1SV1CCySf_G* %15 to %swift.refcounted*, !dbg !743
  tail call void @swift_release(%swift.refcounted* %22) #0, !dbg !743
  %23 = bitcast %T1M1SV1CCySf_G** %.v5.s.c to %T1M1SV1CC**, !dbg !752
  store %T1M1SV1CC* %20, %T1M1SV1CC** %23, align 8, !dbg !752
  store i1 %21, i1* %.v5.s.b._value, align 8, !dbg !752
  ret void, !dbg !743
}
define internal swiftcc { i8*, %swift.refcounted* } @"$s4main1UV16_Differentiation14DifferentiableAadEP28zeroTangentVectorInitializer0eF0QzycvgTW"(%T4main1UV* noalias nocapture readonly swiftself dereferenceable(25) %0, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 !dbg !758 {
entry:
  %1 = bitcast %T4main1UV* %0 to %T1M1SV1CC**, !dbg !761
  %2 = load %T1M1SV1CC*, %T1M1SV1CC** %1, align 8, !dbg !761
  %.s.b._value = getelementptr inbounds %T4main1UV, %T4main1UV* %0, i64 0, i32 0, i32 1, i32 0, !dbg !761
  %3 = load i1, i1* %.s.b._value, align 8, !dbg !761
  %.v.s = getelementptr inbounds %T4main1UV, %T4main1UV* %0, i64 0, i32 2, i32 0, !dbg !761
  %4 = bitcast %T1M1SVySfG* %.v.s to %T1M1SV1CC**, !dbg !761
  %5 = load %T1M1SV1CC*, %T1M1SV1CC** %4, align 8, !dbg !761
  %.v.s.b._value = getelementptr inbounds %T4main1UV, %T4main1UV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !761
  %6 = load i1, i1* %.v.s.b._value, align 8, !dbg !761
  %7 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %2, i1 %3, %swift.type* nonnull @"$sSfN") #16, !dbg !762
  %8 = extractvalue { i8*, %swift.refcounted* } %7, 0, !dbg !762
  %9 = extractvalue { i8*, %swift.refcounted* } %7, 1, !dbg !762
  call void @llvm.dbg.value(metadata i8* %8, metadata !765, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !762
  call void @llvm.dbg.value(metadata %swift.refcounted* %9, metadata !765, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !762
  %10 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %5, i1 %6, %swift.type* nonnull @"$sSfN") #16, !dbg !766
  %11 = extractvalue { i8*, %swift.refcounted* } %10, 0, !dbg !766
  %12 = extractvalue { i8*, %swift.refcounted* } %10, 1, !dbg !766
  call void @llvm.dbg.value(metadata i8* %11, metadata !769, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !766
  call void @llvm.dbg.value(metadata %swift.refcounted* %12, metadata !769, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !766
  %13 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.73, i64 0, i32 2), i64 32, i64 7) #0, !dbg !766
  %14 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %13, i64 1, !dbg !766
  %.fn = bitcast %swift.refcounted* %14 to i8**, !dbg !766
  store i8* %11, i8** %.fn, align 8, !dbg !766
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %13, i64 1, i32 1, !dbg !766
  %15 = bitcast i64* %.data to %swift.refcounted**, !dbg !766
  store %swift.refcounted* %12, %swift.refcounted** %15, align 8, !dbg !766
  call void @llvm.dbg.value(metadata i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.74" to i8*), metadata !770, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !762
  call void @llvm.dbg.value(metadata %swift.refcounted* %13, metadata !770, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !762
  %16 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.77, i64 0, i32 2), i64 48, i64 7) #0, !dbg !762
  %17 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %16, i64 1, !dbg !762
  %.fn2 = bitcast %swift.refcounted* %17 to i8**, !dbg !762
  store i8* %8, i8** %.fn2, align 8, !dbg !762
  %.data3 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %16, i64 1, i32 1, !dbg !762
  %18 = bitcast i64* %.data3 to %swift.refcounted**, !dbg !762
  store %swift.refcounted* %9, %swift.refcounted** %18, align 8, !dbg !762
  %19 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %16, i64 2, !dbg !762
  %.fn4 = bitcast %swift.refcounted* %19 to i8**, !dbg !762
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.74" to i8*), i8** %.fn4, align 8, !dbg !762
  %.data5 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %16, i64 2, i32 1, !dbg !762
  %20 = bitcast i64* %.data5 to %swift.refcounted**, !dbg !762
  store %swift.refcounted* %13, %swift.refcounted** %20, align 8, !dbg !762
  %21 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.81, i64 0, i32 2), i64 32, i64 7) #0, !dbg !761
  %22 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %21, i64 1, !dbg !761
  %.fn6 = bitcast %swift.refcounted* %22 to i8**, !dbg !761
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1UV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.78" to i8*), i8** %.fn6, align 8, !dbg !761
  %.data7 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %21, i64 1, i32 1, !dbg !761
  %23 = bitcast i64* %.data7 to %swift.refcounted**, !dbg !761
  store %swift.refcounted* %16, %swift.refcounted** %23, align 8, !dbg !761
  %24 = insertvalue { i8*, %swift.refcounted* } { i8* bitcast (void (%T4main1UV13TangentVectorV*, %swift.refcounted*)* @"$s4main1UV13TangentVectorVIego_AEIegr_TRTA" to i8*), %swift.refcounted* undef }, %swift.refcounted* %21, 1, !dbg !761
  ret { i8*, %swift.refcounted* } %24, !dbg !761
}
; Function Attrs: noinline nounwind
define hidden swiftcc { i8*, %T1M1SVySfG* } @"$s4main1VV1s1M1SVySfGvM"(i8* noalias dereferenceable(32) %0, %T4main1VV* nocapture swiftself dereferenceable(9) %1) local_unnamed_addr #1 !dbg !771 {
entry:
  %.s = getelementptr inbounds %T4main1VV, %T4main1VV* %1, i64 0, i32 0, !dbg !774
  %2 = insertvalue { i8*, %T1M1SVySfG* } { i8* bitcast (void (i8*, i1)* @"$s4main1VV1s1M1SVySfGvM.resume.0" to i8*), %T1M1SVySfG* undef }, %T1M1SVySfG* %.s, 1
  ret { i8*, %T1M1SVySfG* } %2
}
define internal swiftcc void @"$s4main1VV1s1M1SVySfGvM.resume.0"(i8* noalias nonnull align 8 dereferenceable(32) %0, i1 %1) #2 !dbg !777 {
entryresume.0:
  ret void, !dbg !778
}
; Function Attrs: nounwind
define hidden swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV1s1M1SVySfGvg"(%T1M1SV1CCySf_G* %0, i1 %1) local_unnamed_addr #4 !dbg !781 {
entry:
  %2 = bitcast %T1M1SV1CCySf_G* %0 to %swift.refcounted*, !dbg !784
  %3 = insertvalue { %T1M1SV1CCySf_G*, i1 } undef, %T1M1SV1CCySf_G* %0, 0, !dbg !784
  %4 = insertvalue { %T1M1SV1CCySf_G*, i1 } %3, i1 %1, 1, !dbg !784
  %5 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %2) #0, !dbg !784
  ret { %T1M1SV1CCySf_G*, i1 } %4, !dbg !784
}
; Function Attrs: nounwind
define hidden swiftcc void @"$s4main1VV13TangentVectorV1s1M1SVySfGvs"(%T1M1SV1CCySf_G* %0, i1 %1, %T4main1VV13TangentVectorV* nocapture swiftself dereferenceable(9) %2) local_unnamed_addr #4 !dbg !786 {
entry:
  %.s.c = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %2, i64 0, i32 0, i32 0, !dbg !789
  %3 = bitcast %T4main1VV13TangentVectorV* %2 to %swift.refcounted**, !dbg !789
  %4 = load %swift.refcounted*, %swift.refcounted** %3, align 8, !dbg !789
  tail call void @swift_release(%swift.refcounted* %4) #0, !dbg !791
  store %T1M1SV1CCySf_G* %0, %T1M1SV1CCySf_G** %.s.c, align 8, !dbg !789
  %.s1.b._value = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %2, i64 0, i32 0, i32 1, i32 0, !dbg !789
  store i1 %1, i1* %.s1.b._value, align 8, !dbg !789
  ret void, !dbg !789
}
; Function Attrs: noinline nounwind
define hidden swiftcc { i8*, %T1M1SVySfG* } @"$s4main1VV13TangentVectorV1s1M1SVySfGvM"(i8* noalias dereferenceable(32) %0, %T4main1VV13TangentVectorV* nocapture swiftself dereferenceable(9) %1) local_unnamed_addr #1 !dbg !792 {
entry:
  %.s = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %1, i64 0, i32 0, !dbg !795
  %2 = insertvalue { i8*, %T1M1SVySfG* } { i8* bitcast (void (i8*, i1)* @"$s4main1VV13TangentVectorV1s1M1SVySfGvM.resume.0" to i8*), %T1M1SVySfG* undef }, %T1M1SVySfG* %.s, 1
  ret { i8*, %T1M1SVySfG* } %2
}
define internal swiftcc void @"$s4main1VV13TangentVectorV1s1M1SVySfGvM.resume.0"(i8* noalias nonnull align 8 dereferenceable(32) %0, i1 %1) #2 !dbg !797 {
entryresume.0:
  ret void, !dbg !798
}
; Function Attrs: norecurse nounwind readnone
define hidden swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV1sAE1M1SVySfG_tcfC"(%T1M1SV1CCySf_G* %0, i1 %1) local_unnamed_addr #8 !dbg !800 {
entry:
  %2 = insertvalue { %T1M1SV1CCySf_G*, i1 } undef, %T1M1SV1CCySf_G* %0, 0, !dbg !803
  %3 = insertvalue { %T1M1SV1CCySf_G*, i1 } %2, i1 %1, 1, !dbg !803
  ret { %T1M1SV1CCySf_G*, i1 } %3, !dbg !803
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4 !dbg !804 {
entry:
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %0, i64 1, i32 1, !dbg !806
  %1 = bitcast i64* %.data to %swift.refcounted**, !dbg !806
  %2 = load %swift.refcounted*, %swift.refcounted** %1, align 8, !dbg !806
  tail call void @swift_release(%swift.refcounted* %2) #0, !dbg !806
  tail call void @swift_deallocObject(%swift.refcounted* %0, i64 32, i64 7), !dbg !806
  ret void, !dbg !806
}
; Function Attrs: nounwind
declare void @swift_deallocObject(%swift.refcounted*, i64, i64) local_unnamed_addr #0
; Function Attrs: nounwind
declare %swift.refcounted* @swift_allocObject(%swift.type*, i64, i64) local_unnamed_addr #0
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2 !dbg !807 {
entry:
  %1 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %0, i64 1, !dbg !808
  %2 = bitcast %swift.refcounted* %1 to { %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)**, !dbg !808
  %3 = load { %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)*, { %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)** %2, align 8, !dbg !808
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %0, i64 1, i32 1, !dbg !808
  %4 = bitcast i64* %.data to %swift.refcounted**, !dbg !808
  %5 = load %swift.refcounted*, %swift.refcounted** %4, align 8, !dbg !808
  call void @llvm.dbg.value(metadata i8* undef, metadata !809, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !813
  call void @llvm.dbg.value(metadata %swift.refcounted* %5, metadata !809, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !813
  %6 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } %3(%swift.refcounted* swiftself %5), !dbg !815
  ret { %T1M1SV1CCySf_G*, i1 } %6, !dbg !808
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2 !dbg !817 {
entry:
  %1 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %0, i64 1, !dbg !818
  %2 = bitcast %swift.refcounted* %1 to { %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)**, !dbg !818
  %3 = load { %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)*, { %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)** %2, align 8, !dbg !818
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %0, i64 1, i32 1, !dbg !818
  %4 = bitcast i64* %.data to %swift.refcounted**, !dbg !818
  %5 = load %swift.refcounted*, %swift.refcounted** %4, align 8, !dbg !818
  %6 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %0, i64 2, !dbg !818
  %7 = bitcast %swift.refcounted* %6 to { %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)**, !dbg !818
  %8 = load { %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)*, { %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)** %7, align 8, !dbg !818
  %.data2 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %0, i64 2, i32 1, !dbg !818
  %9 = bitcast i64* %.data2 to %swift.refcounted**, !dbg !818
  %10 = load %swift.refcounted*, %swift.refcounted** %9, align 8, !dbg !818
  call void @llvm.dbg.value(metadata i8* undef, metadata !819, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !823
  call void @llvm.dbg.value(metadata %swift.refcounted* %5, metadata !819, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !823
  call void @llvm.dbg.value(metadata i8* undef, metadata !825, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !823
  call void @llvm.dbg.value(metadata %swift.refcounted* %10, metadata !825, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !823
  %11 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } %3(%swift.refcounted* swiftself %5), !dbg !826
  %12 = extractvalue { %T1M1SV1CCySf_G*, i1 } %11, 0, !dbg !826
  %13 = extractvalue { %T1M1SV1CCySf_G*, i1 } %11, 1, !dbg !826
  %14 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } %8(%swift.refcounted* swiftself %10), !dbg !826
  %15 = extractvalue { %T1M1SV1CCySf_G*, i1 } %14, 0, !dbg !826
  %16 = extractvalue { %T1M1SV1CCySf_G*, i1 } %14, 1, !dbg !826
  %17 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } undef, %T1M1SV1CCySf_G* %12, 0, !dbg !826
  %18 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %17, i1 %13, 1, !dbg !826
  %19 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %18, %T1M1SV1CCySf_G* %15, 2, !dbg !826
  %20 = insertvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %19, i1 %16, 3, !dbg !826
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %20, !dbg !818
}
define internal swiftcc void @"$s4main1TV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %swift.refcounted* nocapture readonly swiftself %1) #2 !dbg !828 {
entry:
  %2 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %1, i64 1, !dbg !829
  %3 = bitcast %swift.refcounted* %2 to { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)**, !dbg !829
  %4 = load { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)*, { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)** %3, align 8, !dbg !829
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %1, i64 1, i32 1, !dbg !829
  %5 = bitcast i64* %.data to %swift.refcounted**, !dbg !829
  %6 = load %swift.refcounted*, %swift.refcounted** %5, align 8, !dbg !829
  %7 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %1, i64 2, !dbg !829
  %8 = bitcast %swift.refcounted* %7 to { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)**, !dbg !829
  %9 = load { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)*, { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)** %8, align 8, !dbg !829
  %.data2 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %1, i64 2, i32 1, !dbg !829
  %10 = bitcast i64* %.data2 to %swift.refcounted**, !dbg !829
  %11 = load %swift.refcounted*, %swift.refcounted** %10, align 8, !dbg !829
  call void @llvm.dbg.value(metadata i8* undef, metadata !830, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !834
  call void @llvm.dbg.value(metadata %swift.refcounted* %6, metadata !830, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !834
  call void @llvm.dbg.value(metadata i8* undef, metadata !836, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !834
  call void @llvm.dbg.value(metadata %swift.refcounted* %11, metadata !836, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !834
  %12 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %4(%swift.refcounted* swiftself %6), !dbg !837, !noalias !839
  %13 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %12, 0, !dbg !837
  %14 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %12, 1, !dbg !837
  %15 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %12, 2, !dbg !837
  %16 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %12, 3, !dbg !837
  %17 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %9(%swift.refcounted* swiftself %11), !dbg !837, !noalias !839
  %18 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %17, 0, !dbg !837
  %19 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %17, 1, !dbg !837
  %20 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %17, 2, !dbg !837
  %21 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %17, 3, !dbg !837
  %.u1.s.c.i = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 0, i32 0, !dbg !837
  store %T1M1SV1CCySf_G* %13, %T1M1SV1CCySf_G** %.u1.s.c.i, align 8, !dbg !837, !alias.scope !839
  %.u1.s.b._value.i = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 0, i32 1, i32 0, !dbg !837
  store i1 %14, i1* %.u1.s.b._value.i, align 8, !dbg !837, !alias.scope !839
  %.u1.v.s.c.i = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, i32 0, !dbg !837
  store %T1M1SV1CCySf_G* %15, %T1M1SV1CCySf_G** %.u1.v.s.c.i, align 8, !dbg !837, !alias.scope !839
  %.u1.v.s.b._value.i = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 0, i32 2, i32 0, i32 1, i32 0, !dbg !837
  store i1 %16, i1* %.u1.v.s.b._value.i, align 8, !dbg !837, !alias.scope !839
  %.u2.s.c.i = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 0, !dbg !837
  store %T1M1SV1CCySf_G* %18, %T1M1SV1CCySf_G** %.u2.s.c.i, align 8, !dbg !837, !alias.scope !839
  %.u2.s.b._value.i = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !837
  store i1 %19, i1* %.u2.s.b._value.i, align 8, !dbg !837, !alias.scope !839
  %.u2.v.s.c.i = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 0, !dbg !837
  store %T1M1SV1CCySf_G* %20, %T1M1SV1CCySf_G** %.u2.v.s.c.i, align 8, !dbg !837, !alias.scope !839
  %.u2.v.s.b._value.i = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !837
  store i1 %21, i1* %.u2.v.s.b._value.i, align 8, !dbg !837, !alias.scope !839
  ret void, !dbg !829
}
; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #6
declare swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV4zeroACyxGvgZ"(%swift.type*) local_unnamed_addr #2
declare swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV1poiyACyxGAE_AEtFZ"(%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*) local_unnamed_addr #2
declare swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV1soiyACyxGAE_AEtFZ"(%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*) local_unnamed_addr #2
declare swiftcc i1 @"$s1M1SV2eeoiySbACyxG_AEtFZ"(%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*) local_unnamed_addr #2
; Function Attrs: noinline nounwind
define linkonce_odr hidden %T4main1VV13TangentVectorV* @"$s4main1VV13TangentVectorVWOs"(%T4main1VV13TangentVectorV* %0) local_unnamed_addr #9 !dbg !842 {
entry:
  %1 = bitcast %T4main1VV13TangentVectorV* %0 to %swift.refcounted**, !dbg !843
  %2 = load %swift.refcounted*, %swift.refcounted** %1, align 8, !dbg !843
  tail call void @swift_release(%swift.refcounted* %2) #0, !dbg !843
  ret %T4main1VV13TangentVectorV* %0, !dbg !843
}
define internal swiftcc void @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAafGP4move5alongyADQz_tFTW"(%T4main1VV13TangentVectorV* noalias nocapture dereferenceable(9) %0, %T4main1VV13TangentVectorV* nocapture swiftself dereferenceable(9) %1, %swift.type* %Self, i8** %SelfWitnessTable) #2 !dbg !844 {
entry:
  %2 = bitcast %T4main1VV13TangentVectorV* %0 to %swift.opaque*, !dbg !847
  %3 = bitcast %T4main1VV13TangentVectorV* %1 to %swift.opaque*, !dbg !847
  tail call swiftcc void @"$s16_Differentiation14DifferentiablePAA13TangentVectorACQzRszrlE4move5alongyx_tF"(%swift.opaque* noalias nocapture nonnull %2, %swift.type* %Self, i8** %SelfWitnessTable, %swift.opaque* nocapture nonnull swiftself %3) #16, !dbg !847
  ret void, !dbg !847
}
define internal swiftcc { i8*, %swift.refcounted* } @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAafGP04zerobC11InitializerADQzycvgTW"(%T4main1VV13TangentVectorV* noalias nocapture readonly swiftself dereferenceable(9) %0, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 !dbg !848 {
entry:
  %1 = bitcast %T4main1VV13TangentVectorV* %0 to %T1M1SV1CC**, !dbg !852
  %2 = load %T1M1SV1CC*, %T1M1SV1CC** %1, align 8, !dbg !852
  %.s.b._value = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %0, i64 0, i32 0, i32 1, i32 0, !dbg !852
  %3 = load i1, i1* %.s.b._value, align 8, !dbg !852
  %4 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %2, i1 %3, %swift.type* nonnull @"$sSfN") #16, !dbg !853
  %5 = extractvalue { i8*, %swift.refcounted* } %4, 0, !dbg !853
  %6 = extractvalue { i8*, %swift.refcounted* } %4, 1, !dbg !853
  call void @llvm.dbg.value(metadata i8* %5, metadata !856, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !853
  call void @llvm.dbg.value(metadata %swift.refcounted* %6, metadata !856, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !853
  %7 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.65, i64 0, i32 2), i64 32, i64 7) #0, !dbg !853
  %8 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %7, i64 1, !dbg !853
  %.fn = bitcast %swift.refcounted* %8 to i8**, !dbg !853
  store i8* %5, i8** %.fn, align 8, !dbg !853
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %7, i64 1, i32 1, !dbg !853
  %9 = bitcast i64* %.data to %swift.refcounted**, !dbg !853
  store %swift.refcounted* %6, %swift.refcounted** %9, align 8, !dbg !853
  %10 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.69, i64 0, i32 2), i64 32, i64 7) #0, !dbg !852
  %11 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %10, i64 1, !dbg !852
  %.fn1 = bitcast %swift.refcounted* %11 to i8**, !dbg !852
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.66" to i8*), i8** %.fn1, align 8, !dbg !852
  %.data2 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %10, i64 1, i32 1, !dbg !852
  %12 = bitcast i64* %.data2 to %swift.refcounted**, !dbg !852
  store %swift.refcounted* %7, %swift.refcounted** %12, align 8, !dbg !852
  %13 = insertvalue { i8*, %swift.refcounted* } { i8* bitcast (void (%T4main1VV13TangentVectorV*, %swift.refcounted*)* @"$s4main1VV13TangentVectorVIego_AEIegr_TRTA.70" to i8*), %swift.refcounted* undef }, %swift.refcounted* %10, 1, !dbg !852
  ret { i8*, %swift.refcounted* } %13, !dbg !852
}
define internal swiftcc void @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP4zeroxvgZTW"(%T4main1VV13TangentVectorV* noalias nocapture sret %0, %swift.type* nocapture readnone swiftself %1, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 !dbg !857 {
entry:
  %2 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV4zeroACyxGvgZ"(%swift.type* nonnull @"$sSfN") #16, !dbg !861
  %3 = extractvalue { %T1M1SV1CC*, i1 } %2, 0, !dbg !861
  %4 = extractvalue { %T1M1SV1CC*, i1 } %2, 1, !dbg !861
  %5 = bitcast %T4main1VV13TangentVectorV* %0 to %T1M1SV1CC**, !dbg !863
  store %T1M1SV1CC* %3, %T1M1SV1CC** %5, align 8, !dbg !863
  %.s.b._value = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %0, i64 0, i32 0, i32 1, i32 0, !dbg !863
  store i1 %4, i1* %.s.b._value, align 8, !dbg !863
  ret void, !dbg !863
}
define internal swiftcc void @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTW"(%T4main1VV13TangentVectorV* noalias nocapture sret %0, %T4main1VV13TangentVectorV* noalias nocapture readonly dereferenceable(9) %1, %T4main1VV13TangentVectorV* noalias nocapture readonly dereferenceable(9) %2, %swift.type* nocapture readnone swiftself %3, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 {
  tail call swiftcc void @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTWTm"(%T4main1VV13TangentVectorV* noalias nocapture sret %0, %T4main1VV13TangentVectorV* noalias nocapture readonly dereferenceable(9) %1, %T4main1VV13TangentVectorV* noalias nocapture readonly dereferenceable(9) %2, %swift.type* nocapture readnone swiftself %3, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* @"$s1M1SV1poiyACyxGAE_AEtFZ") #2
  ret void
}
define internal swiftcc void @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP2peoiyyxz_xtFZTW"(%T4main1VV13TangentVectorV* nocapture dereferenceable(9) %0, %T4main1VV13TangentVectorV* noalias nocapture dereferenceable(9) %1, %swift.type* swiftself %2, %swift.type* %Self, i8** %SelfWitnessTable) #2 !dbg !864 {
entry:
  %3 = bitcast %T4main1VV13TangentVectorV* %0 to %swift.opaque*, !dbg !867
  %4 = bitcast %T4main1VV13TangentVectorV* %1 to %swift.opaque*, !dbg !867
  call swiftcc void @"$ss18AdditiveArithmeticPsE2peoiyyxz_xtFZTm"(%swift.opaque* nocapture %3, %swift.opaque* noalias nocapture %4, %swift.type* %Self, i8** %SelfWitnessTable, %swift.type* swiftself %2, void (%swift.opaque*, %swift.opaque*, %swift.opaque*, %swift.type*, %swift.type*, i8**)* @"$ss18AdditiveArithmeticP1poiyxx_xtFZTj"), !dbg !867
  ret void, !dbg !867
}
define internal swiftcc void @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP1soiyxx_xtFZTW"(%T4main1VV13TangentVectorV* noalias nocapture sret %0, %T4main1VV13TangentVectorV* noalias nocapture readonly dereferenceable(9) %1, %T4main1VV13TangentVectorV* noalias nocapture readonly dereferenceable(9) %2, %swift.type* nocapture readnone swiftself %3, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 {
  tail call swiftcc void @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTWTm"(%T4main1VV13TangentVectorV* noalias nocapture sret %0, %T4main1VV13TangentVectorV* noalias nocapture readonly dereferenceable(9) %1, %T4main1VV13TangentVectorV* noalias nocapture readonly dereferenceable(9) %2, %swift.type* nocapture readnone swiftself %3, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* @"$s1M1SV1soiyACyxGAE_AEtFZ") #2
  ret void
}
define internal swiftcc void @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTWTm"(%T4main1VV13TangentVectorV* noalias nocapture sret %0, %T4main1VV13TangentVectorV* noalias nocapture readonly dereferenceable(9) %1, %T4main1VV13TangentVectorV* noalias nocapture readonly dereferenceable(9) %2, %swift.type* nocapture readnone swiftself %3, %swift.type* nocapture readnone %4, i8** nocapture readnone %5, { %T1M1SV1CC*, i1 } (%T1M1SV1CC*, i1, %T1M1SV1CC*, i1, %swift.type*)* %6) #2 {
entry:
  %7 = bitcast %T4main1VV13TangentVectorV* %1 to %T1M1SV1CC**, !dbg !868
  %8 = load %T1M1SV1CC*, %T1M1SV1CC** %7, align 8, !dbg !868
  %.s.b._value = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %1, i64 0, i32 0, i32 1, i32 0, !dbg !868
  %9 = load i1, i1* %.s.b._value, align 8, !dbg !868
  %10 = bitcast %T4main1VV13TangentVectorV* %2 to %T1M1SV1CC**, !dbg !868
  %11 = load %T1M1SV1CC*, %T1M1SV1CC** %10, align 8, !dbg !868
  %.s1.b._value = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %2, i64 0, i32 0, i32 1, i32 0, !dbg !868
  %12 = load i1, i1* %.s1.b._value, align 8, !dbg !868
  %13 = tail call swiftcc { %T1M1SV1CC*, i1 } %6(%T1M1SV1CC* %8, i1 %9, %T1M1SV1CC* %11, i1 %12, %swift.type* nonnull @"$sSfN") #16, !dbg !872
  %14 = extractvalue { %T1M1SV1CC*, i1 } %13, 0, !dbg !872
  %15 = extractvalue { %T1M1SV1CC*, i1 } %13, 1, !dbg !872
  %16 = bitcast %T4main1VV13TangentVectorV* %0 to %T1M1SV1CC**, !dbg !868
  store %T1M1SV1CC* %14, %T1M1SV1CC** %16, align 8, !dbg !868
  %.s3.b._value = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %0, i64 0, i32 0, i32 1, i32 0, !dbg !868
  store i1 %15, i1* %.s3.b._value, align 8, !dbg !868
  ret void, !dbg !868
}
define internal swiftcc void @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP2seoiyyxz_xtFZTW"(%T4main1VV13TangentVectorV* nocapture dereferenceable(9) %0, %T4main1VV13TangentVectorV* noalias nocapture dereferenceable(9) %1, %swift.type* swiftself %2, %swift.type* %Self, i8** %SelfWitnessTable) #2 !dbg !874 {
entry:
  %3 = bitcast %T4main1VV13TangentVectorV* %0 to %swift.opaque*, !dbg !875
  %4 = bitcast %T4main1VV13TangentVectorV* %1 to %swift.opaque*, !dbg !875
  call swiftcc void @"$ss18AdditiveArithmeticPsE2peoiyyxz_xtFZTm"(%swift.opaque* nocapture %3, %swift.opaque* noalias nocapture %4, %swift.type* %Self, i8** %SelfWitnessTable, %swift.type* swiftself %2, void (%swift.opaque*, %swift.opaque*, %swift.opaque*, %swift.type*, %swift.type*, i8**)* @"$ss18AdditiveArithmeticP1soiyxx_xtFZTj"), !dbg !875
  ret void, !dbg !875
}
define internal swiftcc i1 @"$s4main1VV13TangentVectorVSQAASQ2eeoiySbx_xtFZTW"(%T4main1VV13TangentVectorV* noalias nocapture readonly dereferenceable(9) %0, %T4main1VV13TangentVectorV* noalias nocapture readonly dereferenceable(9) %1, %swift.type* nocapture readnone swiftself %2, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 !dbg !876 {
entry:
  %3 = bitcast %T4main1VV13TangentVectorV* %0 to %T1M1SV1CC**, !dbg !879
  %4 = load %T1M1SV1CC*, %T1M1SV1CC** %3, align 8, !dbg !879
  %.s.b._value = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %0, i64 0, i32 0, i32 1, i32 0, !dbg !879
  %5 = load i1, i1* %.s.b._value, align 8, !dbg !879
  %6 = bitcast %T4main1VV13TangentVectorV* %1 to %T1M1SV1CC**, !dbg !879
  %7 = load %T1M1SV1CC*, %T1M1SV1CC** %6, align 8, !dbg !879
  %.s1.b._value = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %1, i64 0, i32 0, i32 1, i32 0, !dbg !879
  %8 = load i1, i1* %.s1.b._value, align 8, !dbg !879
  %9 = tail call swiftcc i1 @"$s1M1SV2eeoiySbACyxG_AEtFZ"(%T1M1SV1CC* %4, i1 %5, %T1M1SV1CC* %7, i1 %8, %swift.type* nonnull @"$sSfN") #16, !dbg !880
  ret i1 %9, !dbg !879
}
declare swiftcc void @"$s4main1UV1M1SVySfGIetMAlYl_TC"(i8* noalias dereferenceable(32), i1) #2
declare swiftcc void @"$s4main1UVAA1VVIetMAlYl_TC"(i8* noalias dereferenceable(32), i1) #2
declare swiftcc void @"$s4main1UV13TangentVectorV1M1SVySfGIetMAlYl_TC"(i8* noalias dereferenceable(32), i1) #2
declare swiftcc void @"$s4main1UV13TangentVectorVAA1VVADVIetMAlYl_TC"(i8* noalias dereferenceable(32), i1) #2
declare swiftcc void @"$s4main1VV1M1SVySfGIetMAlYl_TC"(i8* noalias dereferenceable(32), i1) #2
declare swiftcc void @"$s4main1VV13TangentVectorV1M1SVySfGIetMAlYl_TC"(i8* noalias dereferenceable(32), i1) #2
; Function Attrs: nounwind readnone
define internal swiftcc i8** @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmeticPWT"(%swift.type* nocapture readnone %T.TangentVector.TangentVector, %swift.type* nocapture readnone %T.TangentVector, i8** nocapture readnone %T.TangentVector.Differentiable) #10 !dbg !882 {
entry:
  %0 = tail call i8** @"$s4main1TV13TangentVectorVAEs18AdditiveArithmeticAAWl"() #15, !dbg !883
  ret i8** %0, !dbg !883
}
; Function Attrs: noinline nounwind readnone
define linkonce_odr hidden i8** @"$s4main1TV13TangentVectorVAEs18AdditiveArithmeticAAWl"() local_unnamed_addr #11 !dbg !884 {
entry:
  %0 = load i8**, i8*** @"$s4main1TV13TangentVectorVAEs18AdditiveArithmeticAAWL", align 8, !dbg !885
  %1 = icmp eq i8** %0, null, !dbg !885
  br i1 %1, label %cacheIsNull, label %cont, !dbg !885

cacheIsNull:                                      ; preds = %entry
  %2 = tail call i8** @swift_getWitnessTable(%swift.protocol_conformance_descriptor* bitcast ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc" to %swift.protocol_conformance_descriptor*), %swift.type* bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>* @"$s4main1TV13TangentVectorVMf", i64 0, i32 1) to %swift.type*), i8*** undef) #0, !dbg !885
  store atomic i8** %2, i8*** @"$s4main1TV13TangentVectorVAEs18AdditiveArithmeticAAWL" release, align 8, !dbg !885
  br label %cont, !dbg !885

cont:                                             ; preds = %cacheIsNull, %entry
  %3 = phi i8** [ %0, %entry ], [ %2, %cacheIsNull ], !dbg !885
  ret i8** %3, !dbg !885
}
; Function Attrs: nounwind readonly
declare i8** @swift_getWitnessTable(%swift.protocol_conformance_descriptor*, %swift.type*, i8***) local_unnamed_addr #12
; Function Attrs: nounwind readnone
define internal swiftcc i8** @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AHWT"(%swift.type* nocapture readnone %T.TangentVector.TangentVector, %swift.type* nocapture readnone %T.TangentVector, i8** nocapture readnone %T.TangentVector.Differentiable) #10 !dbg !886 {
entry:
  %0 = tail call i8** @"$s4main1TV13TangentVectorVAE16_Differentiation14DifferentiableAAWl"() #15, !dbg !887
  ret i8** %0, !dbg !887
}
; Function Attrs: noinline nounwind readnone
define linkonce_odr hidden i8** @"$s4main1TV13TangentVectorVAE16_Differentiation14DifferentiableAAWl"() local_unnamed_addr #11 !dbg !888 {
entry:
  %0 = load i8**, i8*** @"$s4main1TV13TangentVectorVAE16_Differentiation14DifferentiableAAWL", align 8, !dbg !889
  %1 = icmp eq i8** %0, null, !dbg !889
  br i1 %1, label %cacheIsNull, label %cont, !dbg !889

cacheIsNull:                                      ; preds = %entry
  %2 = tail call i8** @swift_getWitnessTable(%swift.protocol_conformance_descriptor* bitcast ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc" to %swift.protocol_conformance_descriptor*), %swift.type* bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>* @"$s4main1TV13TangentVectorVMf", i64 0, i32 1) to %swift.type*), i8*** undef) #0, !dbg !889
  store atomic i8** %2, i8*** @"$s4main1TV13TangentVectorVAE16_Differentiation14DifferentiableAAWL" release, align 8, !dbg !889
  br label %cont, !dbg !889

cont:                                             ; preds = %cacheIsNull, %entry
  %3 = phi i8** [ %0, %entry ], [ %2, %cacheIsNull ], !dbg !889
  ret i8** %3, !dbg !889
}
; Function Attrs: nounwind readnone
define internal swiftcc i8** @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAASQWb"(%swift.type* nocapture readnone %T.TangentVector, %swift.type* nocapture readnone %T.TangentVector1, i8** nocapture readnone %T.TangentVector.AdditiveArithmetic) #10 !dbg !890 {
entry:
  %0 = tail call i8** @"$s4main1TV13TangentVectorVAESQAAWl"() #15, !dbg !891
  ret i8** %0, !dbg !891
}
; Function Attrs: noinline nounwind readnone
define linkonce_odr hidden i8** @"$s4main1TV13TangentVectorVAESQAAWl"() local_unnamed_addr #11 !dbg !892 {
entry:
  %0 = load i8**, i8*** @"$s4main1TV13TangentVectorVAESQAAWL", align 8, !dbg !893
  %1 = icmp eq i8** %0, null, !dbg !893
  br i1 %1, label %cacheIsNull, label %cont, !dbg !893

cacheIsNull:                                      ; preds = %entry
  %2 = tail call i8** @swift_getWitnessTable(%swift.protocol_conformance_descriptor* bitcast ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVSQAAMc" to %swift.protocol_conformance_descriptor*), %swift.type* bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>* @"$s4main1TV13TangentVectorVMf", i64 0, i32 1) to %swift.type*), i8*** undef) #0, !dbg !893
  store atomic i8** %2, i8*** @"$s4main1TV13TangentVectorVAESQAAWL" release, align 8, !dbg !893
  br label %cont, !dbg !893

cont:                                             ; preds = %cacheIsNull, %entry
  %3 = phi i8** [ %0, %entry ], [ %2, %cacheIsNull ], !dbg !893
  ret i8** %3, !dbg !893
}
; Function Attrs: nounwind readnone
define internal swiftcc i8** @"$s4main1TV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmeticPWT"(%swift.type* nocapture readnone %T.TangentVector, %swift.type* nocapture readnone %T, i8** nocapture readnone %T.Differentiable) #10 !dbg !894 {
entry:
  %0 = tail call i8** @"$s4main1TV13TangentVectorVAEs18AdditiveArithmeticAAWl"() #15, !dbg !895
  ret i8** %0, !dbg !895
}
; Function Attrs: nounwind readnone
define internal swiftcc i8** @"$s4main1TV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AGWT"(%swift.type* nocapture readnone %T.TangentVector, %swift.type* nocapture readnone %T, i8** nocapture readnone %T.Differentiable) #10 !dbg !896 {
entry:
  %0 = tail call i8** @"$s4main1TV13TangentVectorVAE16_Differentiation14DifferentiableAAWl"() #15, !dbg !897
  ret i8** %0, !dbg !897
}
; Function Attrs: nounwind readnone
define internal swiftcc i8** @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmeticPWT"(%swift.type* nocapture readnone %U.TangentVector.TangentVector, %swift.type* nocapture readnone %U.TangentVector, i8** nocapture readnone %U.TangentVector.Differentiable) #10 !dbg !898 {
entry:
  %0 = tail call i8** @"$s4main1UV13TangentVectorVAEs18AdditiveArithmeticAAWl"() #15, !dbg !899
  ret i8** %0, !dbg !899
}
; Function Attrs: noinline nounwind readnone
define linkonce_odr hidden i8** @"$s4main1UV13TangentVectorVAEs18AdditiveArithmeticAAWl"() local_unnamed_addr #11 !dbg !900 {
entry:
  %0 = load i8**, i8*** @"$s4main1UV13TangentVectorVAEs18AdditiveArithmeticAAWL", align 8, !dbg !901
  %1 = icmp eq i8** %0, null, !dbg !901
  br i1 %1, label %cacheIsNull, label %cont, !dbg !901

cacheIsNull:                                      ; preds = %entry
  %2 = tail call i8** @swift_getWitnessTable(%swift.protocol_conformance_descriptor* bitcast ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc" to %swift.protocol_conformance_descriptor*), %swift.type* bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>* @"$s4main1UV13TangentVectorVMf", i64 0, i32 1) to %swift.type*), i8*** undef) #0, !dbg !901
  store atomic i8** %2, i8*** @"$s4main1UV13TangentVectorVAEs18AdditiveArithmeticAAWL" release, align 8, !dbg !901
  br label %cont, !dbg !901

cont:                                             ; preds = %cacheIsNull, %entry
  %3 = phi i8** [ %0, %entry ], [ %2, %cacheIsNull ], !dbg !901
  ret i8** %3, !dbg !901
}
; Function Attrs: nounwind readnone
define internal swiftcc i8** @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AHWT"(%swift.type* nocapture readnone %U.TangentVector.TangentVector, %swift.type* nocapture readnone %U.TangentVector, i8** nocapture readnone %U.TangentVector.Differentiable) #10 !dbg !902 {
entry:
  %0 = tail call i8** @"$s4main1UV13TangentVectorVAE16_Differentiation14DifferentiableAAWl"() #15, !dbg !903
  ret i8** %0, !dbg !903
}
; Function Attrs: noinline nounwind readnone
define linkonce_odr hidden i8** @"$s4main1UV13TangentVectorVAE16_Differentiation14DifferentiableAAWl"() local_unnamed_addr #11 !dbg !904 {
entry:
  %0 = load i8**, i8*** @"$s4main1UV13TangentVectorVAE16_Differentiation14DifferentiableAAWL", align 8, !dbg !905
  %1 = icmp eq i8** %0, null, !dbg !905
  br i1 %1, label %cacheIsNull, label %cont, !dbg !905

cacheIsNull:                                      ; preds = %entry
  %2 = tail call i8** @swift_getWitnessTable(%swift.protocol_conformance_descriptor* bitcast ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc" to %swift.protocol_conformance_descriptor*), %swift.type* bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>* @"$s4main1UV13TangentVectorVMf", i64 0, i32 1) to %swift.type*), i8*** undef) #0, !dbg !905
  store atomic i8** %2, i8*** @"$s4main1UV13TangentVectorVAE16_Differentiation14DifferentiableAAWL" release, align 8, !dbg !905
  br label %cont, !dbg !905

cont:                                             ; preds = %cacheIsNull, %entry
  %3 = phi i8** [ %0, %entry ], [ %2, %cacheIsNull ], !dbg !905
  ret i8** %3, !dbg !905
}
; Function Attrs: nounwind readnone
define internal swiftcc i8** @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAASQWb"(%swift.type* nocapture readnone %U.TangentVector, %swift.type* nocapture readnone %U.TangentVector1, i8** nocapture readnone %U.TangentVector.AdditiveArithmetic) #10 !dbg !906 {
entry:
  %0 = tail call i8** @"$s4main1UV13TangentVectorVAESQAAWl"() #15, !dbg !907
  ret i8** %0, !dbg !907
}
; Function Attrs: noinline nounwind readnone
define linkonce_odr hidden i8** @"$s4main1UV13TangentVectorVAESQAAWl"() local_unnamed_addr #11 !dbg !908 {
entry:
  %0 = load i8**, i8*** @"$s4main1UV13TangentVectorVAESQAAWL", align 8, !dbg !909
  %1 = icmp eq i8** %0, null, !dbg !909
  br i1 %1, label %cacheIsNull, label %cont, !dbg !909

cacheIsNull:                                      ; preds = %entry
  %2 = tail call i8** @swift_getWitnessTable(%swift.protocol_conformance_descriptor* bitcast ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVSQAAMc" to %swift.protocol_conformance_descriptor*), %swift.type* bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>* @"$s4main1UV13TangentVectorVMf", i64 0, i32 1) to %swift.type*), i8*** undef) #0, !dbg !909
  store atomic i8** %2, i8*** @"$s4main1UV13TangentVectorVAESQAAWL" release, align 8, !dbg !909
  br label %cont, !dbg !909

cont:                                             ; preds = %cacheIsNull, %entry
  %3 = phi i8** [ %0, %entry ], [ %2, %cacheIsNull ], !dbg !909
  ret i8** %3, !dbg !909
}
; Function Attrs: nounwind readnone
define internal swiftcc i8** @"$s4main1UV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmeticPWT"(%swift.type* nocapture readnone %U.TangentVector, %swift.type* nocapture readnone %U, i8** nocapture readnone %U.Differentiable) #10 !dbg !910 {
entry:
  %0 = tail call i8** @"$s4main1UV13TangentVectorVAEs18AdditiveArithmeticAAWl"() #15, !dbg !911
  ret i8** %0, !dbg !911
}
; Function Attrs: nounwind readnone
define internal swiftcc i8** @"$s4main1UV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AGWT"(%swift.type* nocapture readnone %U.TangentVector, %swift.type* nocapture readnone %U, i8** nocapture readnone %U.Differentiable) #10 !dbg !912 {
entry:
  %0 = tail call i8** @"$s4main1UV13TangentVectorVAE16_Differentiation14DifferentiableAAWl"() #15, !dbg !913
  ret i8** %0, !dbg !913
}
; Function Attrs: nounwind readnone
define internal swiftcc i8** @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmeticPWT"(%swift.type* nocapture readnone %V.TangentVector.TangentVector, %swift.type* nocapture readnone %V.TangentVector, i8** nocapture readnone %V.TangentVector.Differentiable) #10 !dbg !914 {
entry:
  %0 = tail call i8** @"$s4main1VV13TangentVectorVAEs18AdditiveArithmeticAAWl"() #15, !dbg !915
  ret i8** %0, !dbg !915
}
; Function Attrs: noinline nounwind readnone
define linkonce_odr hidden i8** @"$s4main1VV13TangentVectorVAEs18AdditiveArithmeticAAWl"() local_unnamed_addr #11 !dbg !916 {
entry:
  %0 = load i8**, i8*** @"$s4main1VV13TangentVectorVAEs18AdditiveArithmeticAAWL", align 8, !dbg !917
  %1 = icmp eq i8** %0, null, !dbg !917
  br i1 %1, label %cacheIsNull, label %cont, !dbg !917

cacheIsNull:                                      ; preds = %entry
  %2 = tail call i8** @swift_getWitnessTable(%swift.protocol_conformance_descriptor* bitcast ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc" to %swift.protocol_conformance_descriptor*), %swift.type* bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, [4 x i8] }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, [4 x i8] }>* @"$s4main1VV13TangentVectorVMf", i64 0, i32 1) to %swift.type*), i8*** undef) #0, !dbg !917
  store atomic i8** %2, i8*** @"$s4main1VV13TangentVectorVAEs18AdditiveArithmeticAAWL" release, align 8, !dbg !917
  br label %cont, !dbg !917

cont:                                             ; preds = %cacheIsNull, %entry
  %3 = phi i8** [ %0, %entry ], [ %2, %cacheIsNull ], !dbg !917
  ret i8** %3, !dbg !917
}
; Function Attrs: nounwind readnone
define internal swiftcc i8** @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AHWT"(%swift.type* nocapture readnone %V.TangentVector.TangentVector, %swift.type* nocapture readnone %V.TangentVector, i8** nocapture readnone %V.TangentVector.Differentiable) #10 !dbg !918 {
entry:
  %0 = tail call i8** @"$s4main1VV13TangentVectorVAE16_Differentiation14DifferentiableAAWl"() #15, !dbg !919
  ret i8** %0, !dbg !919
}
; Function Attrs: noinline nounwind readnone
define linkonce_odr hidden i8** @"$s4main1VV13TangentVectorVAE16_Differentiation14DifferentiableAAWl"() local_unnamed_addr #11 !dbg !920 {
entry:
  %0 = load i8**, i8*** @"$s4main1VV13TangentVectorVAE16_Differentiation14DifferentiableAAWL", align 8, !dbg !921
  %1 = icmp eq i8** %0, null, !dbg !921
  br i1 %1, label %cacheIsNull, label %cont, !dbg !921

cacheIsNull:                                      ; preds = %entry
  %2 = tail call i8** @swift_getWitnessTable(%swift.protocol_conformance_descriptor* bitcast ({ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc" to %swift.protocol_conformance_descriptor*), %swift.type* bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, [4 x i8] }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, [4 x i8] }>* @"$s4main1VV13TangentVectorVMf", i64 0, i32 1) to %swift.type*), i8*** undef) #0, !dbg !921
  store atomic i8** %2, i8*** @"$s4main1VV13TangentVectorVAE16_Differentiation14DifferentiableAAWL" release, align 8, !dbg !921
  br label %cont, !dbg !921

cont:                                             ; preds = %cacheIsNull, %entry
  %3 = phi i8** [ %0, %entry ], [ %2, %cacheIsNull ], !dbg !921
  ret i8** %3, !dbg !921
}
; Function Attrs: nounwind readnone
define internal swiftcc i8** @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAASQWb"(%swift.type* nocapture readnone %V.TangentVector, %swift.type* nocapture readnone %V.TangentVector1, i8** nocapture readnone %V.TangentVector.AdditiveArithmetic) #10 !dbg !922 {
entry:
  %0 = tail call i8** @"$s4main1VV13TangentVectorVAESQAAWl"() #15, !dbg !923
  ret i8** %0, !dbg !923
}
; Function Attrs: noinline nounwind readnone
define linkonce_odr hidden i8** @"$s4main1VV13TangentVectorVAESQAAWl"() local_unnamed_addr #11 !dbg !924 {
entry:
  %0 = load i8**, i8*** @"$s4main1VV13TangentVectorVAESQAAWL", align 8, !dbg !925
  %1 = icmp eq i8** %0, null, !dbg !925
  br i1 %1, label %cacheIsNull, label %cont, !dbg !925

cacheIsNull:                                      ; preds = %entry
  %2 = tail call i8** @swift_getWitnessTable(%swift.protocol_conformance_descriptor* bitcast ({ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVSQAAMc" to %swift.protocol_conformance_descriptor*), %swift.type* bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, [4 x i8] }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, [4 x i8] }>* @"$s4main1VV13TangentVectorVMf", i64 0, i32 1) to %swift.type*), i8*** undef) #0, !dbg !925
  store atomic i8** %2, i8*** @"$s4main1VV13TangentVectorVAESQAAWL" release, align 8, !dbg !925
  br label %cont, !dbg !925

cont:                                             ; preds = %cacheIsNull, %entry
  %3 = phi i8** [ %0, %entry ], [ %2, %cacheIsNull ], !dbg !925
  ret i8** %3, !dbg !925
}
; Function Attrs: nounwind readnone
define internal swiftcc i8** @"$s4main1VV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmeticPWT"(%swift.type* nocapture readnone %V.TangentVector, %swift.type* nocapture readnone %V, i8** nocapture readnone %V.Differentiable) #10 !dbg !926 {
entry:
  %0 = tail call i8** @"$s4main1VV13TangentVectorVAEs18AdditiveArithmeticAAWl"() #15, !dbg !927
  ret i8** %0, !dbg !927
}
; Function Attrs: nounwind readnone
define internal swiftcc i8** @"$s4main1VV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AGWT"(%swift.type* nocapture readnone %V.TangentVector, %swift.type* nocapture readnone %V, i8** nocapture readnone %V.Differentiable) #10 !dbg !928 {
entry:
  %0 = tail call i8** @"$s4main1VV13TangentVectorVAE16_Differentiation14DifferentiableAAWl"() #15, !dbg !929
  ret i8** %0, !dbg !929
}
define internal swiftcc void @"$s4main1VV16_Differentiation14DifferentiableAadEP4move5alongy13TangentVectorQz_tFTW"(%T4main1VV13TangentVectorV* noalias nocapture readonly dereferenceable(9) %0, %T4main1VV* nocapture swiftself dereferenceable(9) %1, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 !dbg !930 {
entry:
  %.s.c = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %0, i64 0, i32 0, i32 0, !dbg !931
  %2 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.s.c, align 8, !dbg !931
  %.s.b._value = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %0, i64 0, i32 0, i32 1, i32 0, !dbg !931
  %3 = load i1, i1* %.s.b._value, align 8, !dbg !931
  call void @llvm.dbg.value(metadata %T4main1VV* %1, metadata !495, metadata !DIExpression(DW_OP_deref)), !dbg !932
  %.s1.c = getelementptr inbounds %T4main1VV, %T4main1VV* %1, i64 0, i32 0, i32 0, !dbg !933
  %4 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.s1.c, align 8, !dbg !933
  %.s1.b._value = getelementptr inbounds %T4main1VV, %T4main1VV* %1, i64 0, i32 0, i32 1, i32 0, !dbg !933
  %5 = load i1, i1* %.s1.b._value, align 8, !dbg !933
  %6 = bitcast %T1M1SV1CCySf_G* %2 to %swift.refcounted*, !dbg !932
  %.asUnsubstituted = bitcast %T1M1SV1CCySf_G* %4 to %T1M1SV1CC*, !dbg !938
  %.asUnsubstituted2 = bitcast %T1M1SV1CCySf_G* %2 to %T1M1SV1CC*, !dbg !938
  %7 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %6) #0, !dbg !932
  %8 = tail call swiftcc { %T1M1SV1CC*, i1 } @"$s1M1SV1poiyACyxGAE_AEtFZ"(%T1M1SV1CC* %.asUnsubstituted, i1 %5, %T1M1SV1CC* %.asUnsubstituted2, i1 %3, %swift.type* nonnull @"$sSfN") #16, !dbg !938
  tail call void @swift_release(%swift.refcounted* %6) #0, !dbg !931
  %9 = extractvalue { %T1M1SV1CC*, i1 } %8, 0, !dbg !938
  %10 = extractvalue { %T1M1SV1CC*, i1 } %8, 1, !dbg !938
  %11 = bitcast %T1M1SV1CCySf_G* %4 to %swift.refcounted*, !dbg !931
  tail call void @swift_release(%swift.refcounted* %11) #0, !dbg !931
  %12 = bitcast %T4main1VV* %1 to %T1M1SV1CC**, !dbg !933
  store %T1M1SV1CC* %9, %T1M1SV1CC** %12, align 8, !dbg !933
  store i1 %10, i1* %.s1.b._value, align 8, !dbg !933
  ret void, !dbg !931
}
define internal swiftcc { i8*, %swift.refcounted* } @"$s4main1VV16_Differentiation14DifferentiableAadEP28zeroTangentVectorInitializer0eF0QzycvgTW"(%T4main1VV* noalias nocapture readonly swiftself dereferenceable(9) %0, %swift.type* nocapture readnone %Self, i8** nocapture readnone %SelfWitnessTable) #2 !dbg !939 {
entry:
  %1 = bitcast %T4main1VV* %0 to %T1M1SV1CC**, !dbg !942
  %2 = load %T1M1SV1CC*, %T1M1SV1CC** %1, align 8, !dbg !942
  %.s.b._value = getelementptr inbounds %T4main1VV, %T4main1VV* %0, i64 0, i32 0, i32 1, i32 0, !dbg !942
  %3 = load i1, i1* %.s.b._value, align 8, !dbg !942
  %4 = tail call swiftcc { i8*, %swift.refcounted* } @"$s1M1SV28zeroTangentVectorInitializerACyxGycvg"(%T1M1SV1CC* %2, i1 %3, %swift.type* nonnull @"$sSfN") #16, !dbg !943
  %5 = extractvalue { i8*, %swift.refcounted* } %4, 0, !dbg !943
  %6 = extractvalue { i8*, %swift.refcounted* } %4, 1, !dbg !943
  call void @llvm.dbg.value(metadata i8* %5, metadata !946, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !943
  call void @llvm.dbg.value(metadata %swift.refcounted* %6, metadata !946, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !943
  %7 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.58, i64 0, i32 2), i64 32, i64 7) #0, !dbg !943
  %8 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %7, i64 1, !dbg !943
  %.fn = bitcast %swift.refcounted* %8 to i8**, !dbg !943
  store i8* %5, i8** %.fn, align 8, !dbg !943
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %7, i64 1, i32 1, !dbg !943
  %9 = bitcast i64* %.data to %swift.refcounted**, !dbg !943
  store %swift.refcounted* %6, %swift.refcounted** %9, align 8, !dbg !943
  %10 = tail call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata.62, i64 0, i32 2), i64 32, i64 7) #0, !dbg !942
  %11 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %10, i64 1, !dbg !942
  %.fn1 = bitcast %swift.refcounted* %11 to i8**, !dbg !942
  store i8* bitcast ({ %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)* @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.59" to i8*), i8** %.fn1, align 8, !dbg !942
  %.data2 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %10, i64 1, i32 1, !dbg !942
  %12 = bitcast i64* %.data2 to %swift.refcounted**, !dbg !942
  store %swift.refcounted* %7, %swift.refcounted** %12, align 8, !dbg !942
  %13 = insertvalue { i8*, %swift.refcounted* } { i8* bitcast (void (%T4main1VV13TangentVectorV*, %swift.refcounted*)* @"$s4main1VV13TangentVectorVIego_AEIegr_TRTA" to i8*), %swift.refcounted* undef }, %swift.refcounted* %10, 1, !dbg !942
  ret { i8*, %swift.refcounted* } %13, !dbg !942
}
; Function Attrs: nounwind
define linkonce_odr hidden i8* @__swift_memcpy57_8(i8* %0, i8* %1, %swift.type* %2) #0 !dbg !947 {
entry:
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 dereferenceable(57) %0, i8* nonnull align 8 dereferenceable(57) %1, i64 57, i1 false), !dbg !948
  ret i8* %0, !dbg !948
}
; Function Attrs: noinline norecurse nounwind readnone
define hidden swiftcc %swift.metadata_response @"$s4main1TVMa"(i64 %0) #13 !dbg !949 {
entry:
  ret %swift.metadata_response { %swift.type* bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>* @"$s4main1TVMf", i32 0, i32 1) to %swift.type*), i64 0 }, !dbg !950
}
; Function Attrs: nounwind
define internal nonnull %swift.opaque* @"$s4main1TV13TangentVectorVwCP"([24 x i8]* noalias nocapture %dest, [24 x i8]* noalias nocapture readonly %src, %swift.type* nocapture readnone %T.TangentVector) #4 !dbg !951 {
entry:
  %0 = bitcast [24 x i8]* %dest to %swift.refcounted**, !dbg !952
  %1 = bitcast [24 x i8]* %src to %swift.refcounted**, !dbg !952
  %2 = load %swift.refcounted*, %swift.refcounted** %1, align 8, !dbg !952
  store %swift.refcounted* %2, %swift.refcounted** %0, align 8, !dbg !952
  %3 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %2, i64 1, !dbg !952
  %4 = bitcast %swift.refcounted* %3 to %swift.opaque*, !dbg !952
  %5 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %2) #0, !dbg !952
  ret %swift.opaque* %4, !dbg !952
}
; Function Attrs: nounwind
define internal void @"$s4main1TV13TangentVectorVwxx"(%swift.opaque* noalias nocapture readonly %object, %swift.type* nocapture readnone %T.TangentVector) #4 !dbg !953 {
entry:
  %0 = bitcast %swift.opaque* %object to %T4main1TV13TangentVectorV*, !dbg !954
  %.u1 = bitcast %swift.opaque* %object to %T4main1UV13TangentVectorV*, !dbg !954
  %1 = bitcast %swift.opaque* %object to %swift.refcounted**, !dbg !954
  %toDestroy4 = load %swift.refcounted*, %swift.refcounted** %1, align 8, !dbg !954
  tail call void @swift_release(%swift.refcounted* %toDestroy4) #0, !dbg !954
  %.u1.v.s.c = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %.u1, i64 0, i32 2, i32 0, i32 0, !dbg !954
  %2 = bitcast %T1M1SV1CCySf_G** %.u1.v.s.c to %swift.refcounted**, !dbg !954
  %toDestroy15 = load %swift.refcounted*, %swift.refcounted** %2, align 8, !dbg !954
  tail call void @swift_release(%swift.refcounted* %toDestroy15) #0, !dbg !954
  %.u2 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, !dbg !954
  %3 = bitcast %T4main1UV13TangentVectorV* %.u2 to %swift.refcounted**, !dbg !954
  %toDestroy26 = load %swift.refcounted*, %swift.refcounted** %3, align 8, !dbg !954
  tail call void @swift_release(%swift.refcounted* %toDestroy26) #0, !dbg !954
  %.u2.v.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 0, !dbg !954
  %4 = bitcast %T1M1SV1CCySf_G** %.u2.v.s.c to %swift.refcounted**, !dbg !954
  %toDestroy37 = load %swift.refcounted*, %swift.refcounted** %4, align 8, !dbg !954
  tail call void @swift_release(%swift.refcounted* %toDestroy37) #0, !dbg !954
  ret void, !dbg !954
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1TV13TangentVectorVwcp"(%swift.opaque* noalias returned %dest, %swift.opaque* noalias nocapture readonly %src, %swift.type* nocapture readnone %T.TangentVector) #4 !dbg !955 {
entry:
  %0 = bitcast %swift.opaque* %dest to %T4main1TV13TangentVectorV*, !dbg !956
  %1 = bitcast %swift.opaque* %src to %T4main1TV13TangentVectorV*, !dbg !956
  %.u1 = bitcast %swift.opaque* %dest to %T4main1UV13TangentVectorV*, !dbg !956
  %.u11 = bitcast %swift.opaque* %src to %T4main1UV13TangentVectorV*, !dbg !956
  %.u1.s = bitcast %swift.opaque* %dest to %T1M1SVySfG*, !dbg !956
  %.u11.s = bitcast %swift.opaque* %src to %T1M1SVySfG*, !dbg !956
  %.u1.s.c = bitcast %swift.opaque* %dest to %T1M1SV1CCySf_G**, !dbg !956
  %.u11.s.c = bitcast %swift.opaque* %src to %T1M1SV1CCySf_G**, !dbg !956
  %2 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.u11.s.c, align 8, !dbg !956
  %3 = bitcast %T1M1SV1CCySf_G* %2 to %swift.refcounted*, !dbg !956
  store %T1M1SV1CCySf_G* %2, %T1M1SV1CCySf_G** %.u1.s.c, align 8, !dbg !956
  %.u1.s.b = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.u1.s, i64 0, i32 1, !dbg !956
  %.u11.s.b = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.u11.s, i64 0, i32 1, !dbg !956
  %4 = bitcast %TSb* %.u1.s.b to i8*, !dbg !956
  %5 = bitcast %TSb* %.u11.s.b to i8*, !dbg !956
  %6 = load i8, i8* %5, align 8, !dbg !956
  store i8 %6, i8* %4, align 8, !dbg !956
  %.u1.v.s.c = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %.u1, i64 0, i32 2, i32 0, i32 0, !dbg !956
  %.u11.v.s.c = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %.u11, i64 0, i32 2, i32 0, i32 0, !dbg !956
  %7 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.u11.v.s.c, align 8, !dbg !956
  %8 = bitcast %T1M1SV1CCySf_G* %7 to %swift.refcounted*, !dbg !956
  store %T1M1SV1CCySf_G* %7, %T1M1SV1CCySf_G** %.u1.v.s.c, align 8, !dbg !956
  %.u1.v.s.b = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %.u1, i64 0, i32 2, i32 0, i32 1, !dbg !956
  %.u11.v.s.b = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %.u11, i64 0, i32 2, i32 0, i32 1, !dbg !956
  %9 = bitcast %TSb* %.u1.v.s.b to i8*, !dbg !956
  %10 = bitcast %TSb* %.u11.v.s.b to i8*, !dbg !956
  %11 = load i8, i8* %10, align 8, !dbg !956
  store i8 %11, i8* %9, align 8, !dbg !956
  %.u2.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 0, !dbg !956
  %.u22.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 0, !dbg !956
  %12 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.u22.s.c, align 8, !dbg !956
  %13 = bitcast %T1M1SV1CCySf_G* %12 to %swift.refcounted*, !dbg !956
  store %T1M1SV1CCySf_G* %12, %T1M1SV1CCySf_G** %.u2.s.c, align 8, !dbg !956
  %.u2.s.b = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, !dbg !956
  %.u22.s.b = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 1, !dbg !956
  %14 = bitcast %TSb* %.u2.s.b to i8*, !dbg !956
  %15 = bitcast %TSb* %.u22.s.b to i8*, !dbg !956
  %16 = load i8, i8* %15, align 8, !dbg !956
  store i8 %16, i8* %14, align 8, !dbg !956
  %.u2.v.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 0, !dbg !956
  %.u22.v.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 2, i32 0, i32 0, !dbg !956
  %17 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.u22.v.s.c, align 8, !dbg !956
  %18 = bitcast %T1M1SV1CCySf_G* %17 to %swift.refcounted*, !dbg !956
  store %T1M1SV1CCySf_G* %17, %T1M1SV1CCySf_G** %.u2.v.s.c, align 8, !dbg !956
  %.u2.v.s.b = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 1, !dbg !956
  %.u22.v.s.b = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 2, i32 0, i32 1, !dbg !956
  %19 = bitcast %TSb* %.u2.v.s.b to i8*, !dbg !956
  %20 = bitcast %TSb* %.u22.v.s.b to i8*, !dbg !956
  %21 = load i8, i8* %20, align 8, !dbg !956
  store i8 %21, i8* %19, align 8, !dbg !956
  %22 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %3) #0, !dbg !956
  %23 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %8) #0, !dbg !956
  %24 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %13) #0, !dbg !956
  %25 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %18) #0, !dbg !956
  ret %swift.opaque* %dest, !dbg !956
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1TV13TangentVectorVwca"(%swift.opaque* returned %dest, %swift.opaque* nocapture readonly %src, %swift.type* nocapture readnone %T.TangentVector) #4 !dbg !957 {
entry:
  %0 = bitcast %swift.opaque* %dest to %T4main1TV13TangentVectorV*, !dbg !958
  %1 = bitcast %swift.opaque* %src to %T4main1TV13TangentVectorV*, !dbg !958
  %.u1 = bitcast %swift.opaque* %dest to %T4main1UV13TangentVectorV*, !dbg !958
  %.u11 = bitcast %swift.opaque* %src to %T4main1UV13TangentVectorV*, !dbg !958
  %.u1.s = bitcast %swift.opaque* %dest to %T1M1SVySfG*, !dbg !958
  %.u11.s = bitcast %swift.opaque* %src to %T1M1SVySfG*, !dbg !958
  %.u1.s.c = bitcast %swift.opaque* %dest to %T1M1SV1CCySf_G**, !dbg !958
  %.u11.s.c = bitcast %swift.opaque* %src to %T1M1SV1CCySf_G**, !dbg !958
  %2 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.u11.s.c, align 8, !dbg !958
  %3 = bitcast %T1M1SV1CCySf_G* %2 to %swift.refcounted*, !dbg !958
  %4 = bitcast %swift.opaque* %dest to %swift.refcounted**, !dbg !958
  %oldValue6 = load %swift.refcounted*, %swift.refcounted** %4, align 8, !dbg !958
  store %T1M1SV1CCySf_G* %2, %T1M1SV1CCySf_G** %.u1.s.c, align 8, !dbg !958
  %5 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %3) #0, !dbg !958
  tail call void @swift_release(%swift.refcounted* %oldValue6) #0, !dbg !958
  %.u1.s.b._value = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.u1.s, i64 0, i32 1, i32 0, !dbg !958
  %.u11.s.b._value = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.u11.s, i64 0, i32 1, i32 0, !dbg !958
  %6 = load i1, i1* %.u11.s.b._value, align 8, !dbg !958
  store i1 %6, i1* %.u1.s.b._value, align 8, !dbg !958
  %.u1.v.s = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %.u1, i64 0, i32 2, i32 0, !dbg !958
  %.u1.v.s.c = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.u1.v.s, i64 0, i32 0, !dbg !958
  %.u11.v.s.c = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %.u11, i64 0, i32 2, i32 0, i32 0, !dbg !958
  %7 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.u11.v.s.c, align 8, !dbg !958
  %8 = bitcast %T1M1SV1CCySf_G* %7 to %swift.refcounted*, !dbg !958
  %9 = bitcast %T1M1SVySfG* %.u1.v.s to %swift.refcounted**, !dbg !958
  %oldValue27 = load %swift.refcounted*, %swift.refcounted** %9, align 8, !dbg !958
  store %T1M1SV1CCySf_G* %7, %T1M1SV1CCySf_G** %.u1.v.s.c, align 8, !dbg !958
  %10 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %8) #0, !dbg !958
  tail call void @swift_release(%swift.refcounted* %oldValue27) #0, !dbg !958
  %.u1.v.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %.u1, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !958
  %.u11.v.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %.u11, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !958
  %11 = load i1, i1* %.u11.v.s.b._value, align 8, !dbg !958
  store i1 %11, i1* %.u1.v.s.b._value, align 8, !dbg !958
  %.u2 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, !dbg !958
  %.u2.s.c = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %.u2, i64 0, i32 0, i32 0, !dbg !958
  %.u23.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 0, !dbg !958
  %12 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.u23.s.c, align 8, !dbg !958
  %13 = bitcast %T1M1SV1CCySf_G* %12 to %swift.refcounted*, !dbg !958
  %14 = bitcast %T4main1UV13TangentVectorV* %.u2 to %swift.refcounted**, !dbg !958
  %oldValue48 = load %swift.refcounted*, %swift.refcounted** %14, align 8, !dbg !958
  store %T1M1SV1CCySf_G* %12, %T1M1SV1CCySf_G** %.u2.s.c, align 8, !dbg !958
  %15 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %13) #0, !dbg !958
  tail call void @swift_release(%swift.refcounted* %oldValue48) #0, !dbg !958
  %.u2.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !958
  %.u23.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !958
  %16 = load i1, i1* %.u23.s.b._value, align 8, !dbg !958
  store i1 %16, i1* %.u2.s.b._value, align 8, !dbg !958
  %.u2.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, !dbg !958
  %.u2.v.s.c = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.u2.v.s, i64 0, i32 0, !dbg !958
  %.u23.v.s.c = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 2, i32 0, i32 0, !dbg !958
  %17 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.u23.v.s.c, align 8, !dbg !958
  %18 = bitcast %T1M1SV1CCySf_G* %17 to %swift.refcounted*, !dbg !958
  %19 = bitcast %T1M1SVySfG* %.u2.v.s to %swift.refcounted**, !dbg !958
  %oldValue59 = load %swift.refcounted*, %swift.refcounted** %19, align 8, !dbg !958
  store %T1M1SV1CCySf_G* %17, %T1M1SV1CCySf_G** %.u2.v.s.c, align 8, !dbg !958
  %20 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %18) #0, !dbg !958
  tail call void @swift_release(%swift.refcounted* %oldValue59) #0, !dbg !958
  %.u2.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !958
  %.u23.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !958
  %21 = load i1, i1* %.u23.v.s.b._value, align 8, !dbg !958
  store i1 %21, i1* %.u2.v.s.b._value, align 8, !dbg !958
  ret %swift.opaque* %dest, !dbg !958
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1TV13TangentVectorVwta"(%swift.opaque* noalias returned %dest, %swift.opaque* noalias nocapture readonly %src, %swift.type* nocapture readnone %T.TangentVector) #4 !dbg !959 {
entry:
  %0 = bitcast %swift.opaque* %dest to %T4main1TV13TangentVectorV*, !dbg !960
  %1 = bitcast %swift.opaque* %src to %T4main1TV13TangentVectorV*, !dbg !960
  %.u1 = bitcast %swift.opaque* %dest to %T4main1UV13TangentVectorV*, !dbg !960
  %.u11 = bitcast %swift.opaque* %src to %T4main1UV13TangentVectorV*, !dbg !960
  %.u1.s = bitcast %swift.opaque* %dest to %T1M1SVySfG*, !dbg !960
  %.u11.s = bitcast %swift.opaque* %src to %T1M1SVySfG*, !dbg !960
  %2 = bitcast %swift.opaque* %src to i64*, !dbg !960
  %3 = load i64, i64* %2, align 8, !dbg !960
  %4 = bitcast %swift.opaque* %dest to %swift.refcounted**, !dbg !960
  %oldValue6 = load %swift.refcounted*, %swift.refcounted** %4, align 8, !dbg !960
  %5 = bitcast %swift.opaque* %dest to i64*, !dbg !960
  store i64 %3, i64* %5, align 8, !dbg !960
  tail call void @swift_release(%swift.refcounted* %oldValue6) #0, !dbg !960
  %.u1.s.b._value = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.u1.s, i64 0, i32 1, i32 0, !dbg !960
  %.u11.s.b._value = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.u11.s, i64 0, i32 1, i32 0, !dbg !960
  %6 = load i1, i1* %.u11.s.b._value, align 8, !dbg !960
  store i1 %6, i1* %.u1.s.b._value, align 8, !dbg !960
  %.u1.v.s = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %.u1, i64 0, i32 2, i32 0, !dbg !960
  %.u11.v.s = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %.u11, i64 0, i32 2, i32 0, !dbg !960
  %7 = bitcast %T1M1SVySfG* %.u11.v.s to i64*, !dbg !960
  %8 = load i64, i64* %7, align 8, !dbg !960
  %9 = bitcast %T1M1SVySfG* %.u1.v.s to %swift.refcounted**, !dbg !960
  %oldValue27 = load %swift.refcounted*, %swift.refcounted** %9, align 8, !dbg !960
  %10 = bitcast %T1M1SVySfG* %.u1.v.s to i64*, !dbg !960
  store i64 %8, i64* %10, align 8, !dbg !960
  tail call void @swift_release(%swift.refcounted* %oldValue27) #0, !dbg !960
  %.u1.v.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %.u1, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !960
  %.u11.v.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %.u11, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !960
  %11 = load i1, i1* %.u11.v.s.b._value, align 8, !dbg !960
  store i1 %11, i1* %.u1.v.s.b._value, align 8, !dbg !960
  %.u2 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, !dbg !960
  %.u23 = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, !dbg !960
  %12 = bitcast %T4main1UV13TangentVectorV* %.u23 to i64*, !dbg !960
  %13 = load i64, i64* %12, align 8, !dbg !960
  %14 = bitcast %T4main1UV13TangentVectorV* %.u2 to %swift.refcounted**, !dbg !960
  %oldValue48 = load %swift.refcounted*, %swift.refcounted** %14, align 8, !dbg !960
  %15 = bitcast %T4main1UV13TangentVectorV* %.u2 to i64*, !dbg !960
  store i64 %13, i64* %15, align 8, !dbg !960
  tail call void @swift_release(%swift.refcounted* %oldValue48) #0, !dbg !960
  %.u2.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !960
  %.u23.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !960
  %16 = load i1, i1* %.u23.s.b._value, align 8, !dbg !960
  store i1 %16, i1* %.u2.s.b._value, align 8, !dbg !960
  %.u2.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, !dbg !960
  %.u23.v.s = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 2, i32 0, !dbg !960
  %17 = bitcast %T1M1SVySfG* %.u23.v.s to i64*, !dbg !960
  %18 = load i64, i64* %17, align 8, !dbg !960
  %19 = bitcast %T1M1SVySfG* %.u2.v.s to %swift.refcounted**, !dbg !960
  %oldValue59 = load %swift.refcounted*, %swift.refcounted** %19, align 8, !dbg !960
  %20 = bitcast %T1M1SVySfG* %.u2.v.s to i64*, !dbg !960
  store i64 %18, i64* %20, align 8, !dbg !960
  tail call void @swift_release(%swift.refcounted* %oldValue59) #0, !dbg !960
  %.u2.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %0, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !960
  %.u23.v.s.b._value = getelementptr inbounds %T4main1TV13TangentVectorV, %T4main1TV13TangentVectorV* %1, i64 0, i32 2, i32 2, i32 0, i32 1, i32 0, !dbg !960
  %21 = load i1, i1* %.u23.v.s.b._value, align 8, !dbg !960
  store i1 %21, i1* %.u2.v.s.b._value, align 8, !dbg !960
  ret %swift.opaque* %dest, !dbg !960
}
; Function Attrs: norecurse nounwind readonly
define internal i32 @"$s4main1TV13TangentVectorVwet"(%swift.opaque* noalias nocapture readonly %value, i32 %numEmptyCases, %swift.type* nocapture readnone %T.TangentVector) #14 !dbg !961 {
entry:
  %0 = icmp eq i32 %numEmptyCases, 0, !dbg !962
  br i1 %0, label %17, label %1, !dbg !962

1:                                                ; preds = %entry
  %2 = icmp ugt i32 %numEmptyCases, 4096, !dbg !962
  br i1 %2, label %3, label %is-valid-pointer, !dbg !962

3:                                                ; preds = %1
  %4 = bitcast %swift.opaque* %value to i8*, !dbg !962
  %5 = getelementptr inbounds i8, i8* %4, i64 57, !dbg !962
  %6 = load i8, i8* %5, align 1, !dbg !962
  %7 = icmp eq i8 %6, 0, !dbg !962
  br i1 %7, label %is-valid-pointer, label %8, !dbg !962

8:                                                ; preds = %3
  %9 = bitcast %swift.opaque* %value to i456*, !dbg !962
  %10 = load i456, i456* %9, align 1, !dbg !962
  %11 = trunc i456 %10 to i32, !dbg !962
  %12 = add i32 %11, 4096, !dbg !962
  br label %17, !dbg !962

is-valid-pointer:                                 ; preds = %3, %1
  %13 = bitcast %swift.opaque* %value to i64*, !dbg !962
  %14 = load i64, i64* %13, align 8, !dbg !962
  %15 = icmp ugt i64 %14, 4095, !dbg !962
  %16 = trunc i64 %14 to i32, !dbg !962
  %spec.select = select i1 %15, i32 -1, i32 %16, !dbg !962
  br label %17, !dbg !962

17:                                               ; preds = %entry, %is-valid-pointer, %8
  %18 = phi i32 [ %spec.select, %is-valid-pointer ], [ %12, %8 ], [ -1, %entry ], !dbg !962
  %19 = add i32 %18, 1, !dbg !962
  ret i32 %19, !dbg !962
}
; Function Attrs: nofree norecurse nounwind writeonly
define internal void @"$s4main1TV13TangentVectorVwst"(%swift.opaque* noalias nocapture %value, i32 %whichCase, i32 %numEmptyCases, %swift.type* nocapture readnone %T.TangentVector) #5 !dbg !963 {
entry:
  %0 = bitcast %swift.opaque* %value to i8*, !dbg !964
  %1 = getelementptr inbounds i8, i8* %0, i64 57, !dbg !964
  %2 = icmp ugt i32 %numEmptyCases, 4096, !dbg !964
  %3 = icmp ult i32 %whichCase, 4097, !dbg !964
  br i1 %3, label %4, label %12, !dbg !964

4:                                                ; preds = %entry
  br i1 %2, label %5, label %6, !dbg !964

5:                                                ; preds = %4
  store i8 0, i8* %1, align 1, !dbg !964
  br label %6, !dbg !964

6:                                                ; preds = %4, %5
  %7 = icmp eq i32 %whichCase, 0, !dbg !964
  br i1 %7, label %17, label %8, !dbg !964

8:                                                ; preds = %6
  %9 = add nsw i32 %whichCase, -1, !dbg !964
  %10 = zext i32 %9 to i64, !dbg !964
  %11 = bitcast %swift.opaque* %value to i64*, !dbg !964
  store i64 %10, i64* %11, align 8, !dbg !964
  br label %17, !dbg !964

12:                                               ; preds = %entry
  %13 = add i32 %whichCase, -4097, !dbg !964
  %14 = zext i32 %13 to i456, !dbg !964
  %15 = bitcast %swift.opaque* %value to i456*, !dbg !964
  store i456 %14, i456* %15, align 8, !dbg !964
  br i1 %2, label %16, label %17, !dbg !964

16:                                               ; preds = %12
  store i8 1, i8* %1, align 1, !dbg !964
  br label %17, !dbg !964

17:                                               ; preds = %12, %16, %8, %6
  ret void, !dbg !964
}
; Function Attrs: noinline norecurse nounwind readnone
define hidden swiftcc %swift.metadata_response @"$s4main1TV13TangentVectorVMa"(i64 %0) #13 !dbg !965 {
entry:
  ret %swift.metadata_response { %swift.type* bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>* @"$s4main1TV13TangentVectorVMf", i32 0, i32 1) to %swift.type*), i64 0 }, !dbg !966
}
; Function Attrs: nounwind
define linkonce_odr hidden i8* @__swift_memcpy25_8(i8* %0, i8* %1, %swift.type* %2) #0 !dbg !967 {
entry:
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 dereferenceable(25) %0, i8* nonnull align 8 dereferenceable(25) %1, i64 25, i1 false), !dbg !968
  ret i8* %0, !dbg !968
}
; Function Attrs: noinline norecurse nounwind readnone
define hidden swiftcc %swift.metadata_response @"$s4main1UVMa"(i64 %0) #13 !dbg !969 {
entry:
  ret %swift.metadata_response { %swift.type* bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>* @"$s4main1UVMf", i32 0, i32 1) to %swift.type*), i64 0 }, !dbg !970
}
; Function Attrs: nounwind
define internal void @"$s4main1UV13TangentVectorVwxx"(%swift.opaque* noalias nocapture readonly %object, %swift.type* nocapture readnone %U.TangentVector) #4 !dbg !971 {
entry:
  %0 = bitcast %swift.opaque* %object to %T4main1UV13TangentVectorV*, !dbg !972
  %1 = bitcast %swift.opaque* %object to %swift.refcounted**, !dbg !972
  %toDestroy2 = load %swift.refcounted*, %swift.refcounted** %1, align 8, !dbg !972
  tail call void @swift_release(%swift.refcounted* %toDestroy2) #0, !dbg !972
  %.v.s.c = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 0, !dbg !972
  %2 = bitcast %T1M1SV1CCySf_G** %.v.s.c to %swift.refcounted**, !dbg !972
  %toDestroy13 = load %swift.refcounted*, %swift.refcounted** %2, align 8, !dbg !972
  tail call void @swift_release(%swift.refcounted* %toDestroy13) #0, !dbg !972
  ret void, !dbg !972
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1UV13TangentVectorVwcp"(%swift.opaque* noalias returned %dest, %swift.opaque* noalias nocapture readonly %src, %swift.type* nocapture readnone %U.TangentVector) #4 !dbg !973 {
entry:
  %0 = bitcast %swift.opaque* %dest to %T4main1UV13TangentVectorV*, !dbg !974
  %1 = bitcast %swift.opaque* %src to %T4main1UV13TangentVectorV*, !dbg !974
  %.s = bitcast %swift.opaque* %dest to %T1M1SVySfG*, !dbg !974
  %.s1 = bitcast %swift.opaque* %src to %T1M1SVySfG*, !dbg !974
  %.s.c = bitcast %swift.opaque* %dest to %T1M1SV1CCySf_G**, !dbg !974
  %.s1.c = bitcast %swift.opaque* %src to %T1M1SV1CCySf_G**, !dbg !974
  %2 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.s1.c, align 8, !dbg !974
  %3 = bitcast %T1M1SV1CCySf_G* %2 to %swift.refcounted*, !dbg !974
  store %T1M1SV1CCySf_G* %2, %T1M1SV1CCySf_G** %.s.c, align 8, !dbg !974
  %.s.b = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.s, i64 0, i32 1, !dbg !974
  %.s1.b = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.s1, i64 0, i32 1, !dbg !974
  %4 = bitcast %TSb* %.s.b to i8*, !dbg !974
  %5 = bitcast %TSb* %.s1.b to i8*, !dbg !974
  %6 = load i8, i8* %5, align 8, !dbg !974
  store i8 %6, i8* %4, align 8, !dbg !974
  %.v.s.c = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 0, !dbg !974
  %.v2.s.c = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 0, !dbg !974
  %7 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.v2.s.c, align 8, !dbg !974
  %8 = bitcast %T1M1SV1CCySf_G* %7 to %swift.refcounted*, !dbg !974
  store %T1M1SV1CCySf_G* %7, %T1M1SV1CCySf_G** %.v.s.c, align 8, !dbg !974
  %.v.s.b = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, !dbg !974
  %.v2.s.b = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 1, !dbg !974
  %9 = bitcast %TSb* %.v.s.b to i8*, !dbg !974
  %10 = bitcast %TSb* %.v2.s.b to i8*, !dbg !974
  %11 = load i8, i8* %10, align 8, !dbg !974
  store i8 %11, i8* %9, align 8, !dbg !974
  %12 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %3) #0, !dbg !974
  %13 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %8) #0, !dbg !974
  ret %swift.opaque* %dest, !dbg !974
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1UV13TangentVectorVwca"(%swift.opaque* returned %dest, %swift.opaque* nocapture readonly %src, %swift.type* nocapture readnone %U.TangentVector) #4 !dbg !975 {
entry:
  %0 = bitcast %swift.opaque* %dest to %T4main1UV13TangentVectorV*, !dbg !976
  %1 = bitcast %swift.opaque* %src to %T4main1UV13TangentVectorV*, !dbg !976
  %.s = bitcast %swift.opaque* %dest to %T1M1SVySfG*, !dbg !976
  %.s1 = bitcast %swift.opaque* %src to %T1M1SVySfG*, !dbg !976
  %.s.c = bitcast %swift.opaque* %dest to %T1M1SV1CCySf_G**, !dbg !976
  %.s1.c = bitcast %swift.opaque* %src to %T1M1SV1CCySf_G**, !dbg !976
  %2 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.s1.c, align 8, !dbg !976
  %3 = bitcast %T1M1SV1CCySf_G* %2 to %swift.refcounted*, !dbg !976
  %4 = bitcast %swift.opaque* %dest to %swift.refcounted**, !dbg !976
  %oldValue4 = load %swift.refcounted*, %swift.refcounted** %4, align 8, !dbg !976
  store %T1M1SV1CCySf_G* %2, %T1M1SV1CCySf_G** %.s.c, align 8, !dbg !976
  %5 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %3) #0, !dbg !976
  tail call void @swift_release(%swift.refcounted* %oldValue4) #0, !dbg !976
  %.s.b._value = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.s, i64 0, i32 1, i32 0, !dbg !976
  %.s1.b._value = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.s1, i64 0, i32 1, i32 0, !dbg !976
  %6 = load i1, i1* %.s1.b._value, align 8, !dbg !976
  store i1 %6, i1* %.s.b._value, align 8, !dbg !976
  %.v.s = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, !dbg !976
  %.v.s.c = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.v.s, i64 0, i32 0, !dbg !976
  %.v2.s.c = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 0, !dbg !976
  %7 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.v2.s.c, align 8, !dbg !976
  %8 = bitcast %T1M1SV1CCySf_G* %7 to %swift.refcounted*, !dbg !976
  %9 = bitcast %T1M1SVySfG* %.v.s to %swift.refcounted**, !dbg !976
  %oldValue35 = load %swift.refcounted*, %swift.refcounted** %9, align 8, !dbg !976
  store %T1M1SV1CCySf_G* %7, %T1M1SV1CCySf_G** %.v.s.c, align 8, !dbg !976
  %10 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %8) #0, !dbg !976
  tail call void @swift_release(%swift.refcounted* %oldValue35) #0, !dbg !976
  %.v.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !976
  %.v2.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !976
  %11 = load i1, i1* %.v2.s.b._value, align 8, !dbg !976
  store i1 %11, i1* %.v.s.b._value, align 8, !dbg !976
  ret %swift.opaque* %dest, !dbg !976
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1UV13TangentVectorVwta"(%swift.opaque* noalias returned %dest, %swift.opaque* noalias nocapture readonly %src, %swift.type* nocapture readnone %U.TangentVector) #4 !dbg !977 {
entry:
  %0 = bitcast %swift.opaque* %dest to %T4main1UV13TangentVectorV*, !dbg !978
  %1 = bitcast %swift.opaque* %src to %T4main1UV13TangentVectorV*, !dbg !978
  %.s = bitcast %swift.opaque* %dest to %T1M1SVySfG*, !dbg !978
  %.s1 = bitcast %swift.opaque* %src to %T1M1SVySfG*, !dbg !978
  %2 = bitcast %swift.opaque* %src to i64*, !dbg !978
  %3 = load i64, i64* %2, align 8, !dbg !978
  %4 = bitcast %swift.opaque* %dest to %swift.refcounted**, !dbg !978
  %oldValue4 = load %swift.refcounted*, %swift.refcounted** %4, align 8, !dbg !978
  %5 = bitcast %swift.opaque* %dest to i64*, !dbg !978
  store i64 %3, i64* %5, align 8, !dbg !978
  tail call void @swift_release(%swift.refcounted* %oldValue4) #0, !dbg !978
  %.s.b._value = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.s, i64 0, i32 1, i32 0, !dbg !978
  %.s1.b._value = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.s1, i64 0, i32 1, i32 0, !dbg !978
  %6 = load i1, i1* %.s1.b._value, align 8, !dbg !978
  store i1 %6, i1* %.s.b._value, align 8, !dbg !978
  %.v.s = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, !dbg !978
  %.v2.s = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %1, i64 0, i32 2, i32 0, !dbg !978
  %7 = bitcast %T1M1SVySfG* %.v2.s to i64*, !dbg !978
  %8 = load i64, i64* %7, align 8, !dbg !978
  %9 = bitcast %T1M1SVySfG* %.v.s to %swift.refcounted**, !dbg !978
  %oldValue35 = load %swift.refcounted*, %swift.refcounted** %9, align 8, !dbg !978
  %10 = bitcast %T1M1SVySfG* %.v.s to i64*, !dbg !978
  store i64 %8, i64* %10, align 8, !dbg !978
  tail call void @swift_release(%swift.refcounted* %oldValue35) #0, !dbg !978
  %.v.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !978
  %.v2.s.b._value = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %1, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !978
  %11 = load i1, i1* %.v2.s.b._value, align 8, !dbg !978
  store i1 %11, i1* %.v.s.b._value, align 8, !dbg !978
  ret %swift.opaque* %dest, !dbg !978
}
; Function Attrs: norecurse nounwind readonly
define internal i32 @"$s4main1UV13TangentVectorVwet"(%swift.opaque* noalias nocapture readonly %value, i32 %numEmptyCases, %swift.type* nocapture readnone %U.TangentVector) #14 !dbg !979 {
entry:
  %0 = icmp eq i32 %numEmptyCases, 0, !dbg !980
  br i1 %0, label %17, label %1, !dbg !980

1:                                                ; preds = %entry
  %2 = icmp ugt i32 %numEmptyCases, 4096, !dbg !980
  br i1 %2, label %3, label %is-valid-pointer, !dbg !980

3:                                                ; preds = %1
  %4 = bitcast %swift.opaque* %value to i8*, !dbg !980
  %5 = getelementptr inbounds i8, i8* %4, i64 25, !dbg !980
  %6 = load i8, i8* %5, align 1, !dbg !980
  %7 = icmp eq i8 %6, 0, !dbg !980
  br i1 %7, label %is-valid-pointer, label %8, !dbg !980

8:                                                ; preds = %3
  %9 = bitcast %swift.opaque* %value to i200*, !dbg !980
  %10 = load i200, i200* %9, align 1, !dbg !980
  %11 = trunc i200 %10 to i32, !dbg !980
  %12 = add i32 %11, 4096, !dbg !980
  br label %17, !dbg !980

is-valid-pointer:                                 ; preds = %3, %1
  %13 = bitcast %swift.opaque* %value to i64*, !dbg !980
  %14 = load i64, i64* %13, align 8, !dbg !980
  %15 = icmp ugt i64 %14, 4095, !dbg !980
  %16 = trunc i64 %14 to i32, !dbg !980
  %spec.select = select i1 %15, i32 -1, i32 %16, !dbg !980
  br label %17, !dbg !980

17:                                               ; preds = %entry, %is-valid-pointer, %8
  %18 = phi i32 [ %spec.select, %is-valid-pointer ], [ %12, %8 ], [ -1, %entry ], !dbg !980
  %19 = add i32 %18, 1, !dbg !980
  ret i32 %19, !dbg !980
}
; Function Attrs: nofree norecurse nounwind writeonly
define internal void @"$s4main1UV13TangentVectorVwst"(%swift.opaque* noalias nocapture %value, i32 %whichCase, i32 %numEmptyCases, %swift.type* nocapture readnone %U.TangentVector) #5 !dbg !981 {
entry:
  %0 = bitcast %swift.opaque* %value to i8*, !dbg !982
  %1 = getelementptr inbounds i8, i8* %0, i64 25, !dbg !982
  %2 = icmp ugt i32 %numEmptyCases, 4096, !dbg !982
  %3 = icmp ult i32 %whichCase, 4097, !dbg !982
  br i1 %3, label %4, label %12, !dbg !982

4:                                                ; preds = %entry
  br i1 %2, label %5, label %6, !dbg !982

5:                                                ; preds = %4
  store i8 0, i8* %1, align 1, !dbg !982
  br label %6, !dbg !982

6:                                                ; preds = %4, %5
  %7 = icmp eq i32 %whichCase, 0, !dbg !982
  br i1 %7, label %17, label %8, !dbg !982

8:                                                ; preds = %6
  %9 = add nsw i32 %whichCase, -1, !dbg !982
  %10 = zext i32 %9 to i64, !dbg !982
  %11 = bitcast %swift.opaque* %value to i64*, !dbg !982
  store i64 %10, i64* %11, align 8, !dbg !982
  br label %17, !dbg !982

12:                                               ; preds = %entry
  %13 = add i32 %whichCase, -4097, !dbg !982
  %14 = zext i32 %13 to i200, !dbg !982
  %15 = bitcast %swift.opaque* %value to i200*, !dbg !982
  store i200 %14, i200* %15, align 8, !dbg !982
  br i1 %2, label %16, label %17, !dbg !982

16:                                               ; preds = %12
  store i8 1, i8* %1, align 1, !dbg !982
  br label %17, !dbg !982

17:                                               ; preds = %12, %16, %8, %6
  ret void, !dbg !982
}
; Function Attrs: noinline norecurse nounwind readnone
define hidden swiftcc %swift.metadata_response @"$s4main1UV13TangentVectorVMa"(i64 %0) #13 !dbg !983 {
entry:
  ret %swift.metadata_response { %swift.type* bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, i32 }>* @"$s4main1UV13TangentVectorVMf", i32 0, i32 1) to %swift.type*), i64 0 }, !dbg !984
}
; Function Attrs: nounwind
define linkonce_odr hidden i8* @__swift_memcpy9_8(i8* %0, i8* %1, %swift.type* %2) #0 !dbg !985 {
entry:
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 dereferenceable(9) %0, i8* nonnull align 8 dereferenceable(9) %1, i64 9, i1 false), !dbg !986
  ret i8* %0, !dbg !986
}
; Function Attrs: noinline norecurse nounwind readnone
define hidden swiftcc %swift.metadata_response @"$s4main1VVMa"(i64 %0) #13 !dbg !987 {
entry:
  ret %swift.metadata_response { %swift.type* bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, [4 x i8] }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, [4 x i8] }>* @"$s4main1VVMf", i32 0, i32 1) to %swift.type*), i64 0 }, !dbg !988
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1VV13TangentVectorVwCP"([24 x i8]* noalias %dest, [24 x i8]* noalias nocapture readonly %src, %swift.type* nocapture readnone %V.TangentVector) #4 !dbg !989 {
entry:
  %.s.c = bitcast [24 x i8]* %dest to %T1M1SV1CCySf_G**, !dbg !990
  %.s1.c = bitcast [24 x i8]* %src to %T1M1SV1CCySf_G**, !dbg !990
  %0 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.s1.c, align 8, !dbg !990
  %1 = bitcast %T1M1SV1CCySf_G* %0 to %swift.refcounted*, !dbg !990
  store %T1M1SV1CCySf_G* %0, %T1M1SV1CCySf_G** %.s.c, align 8, !dbg !990
  %.s.b = getelementptr inbounds [24 x i8], [24 x i8]* %dest, i64 0, i64 8, !dbg !990
  %.s1.b = getelementptr inbounds [24 x i8], [24 x i8]* %src, i64 0, i64 8, !dbg !990
  %2 = load i8, i8* %.s1.b, align 8, !dbg !990
  store i8 %2, i8* %.s.b, align 8, !dbg !990
  %3 = bitcast [24 x i8]* %dest to %swift.opaque*, !dbg !990
  %4 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %1) #0, !dbg !990
  ret %swift.opaque* %3, !dbg !990
}
; Function Attrs: nounwind
define internal void @"$s4main1VV13TangentVectorVwxx"(%swift.opaque* noalias nocapture readonly %object, %swift.type* nocapture readnone %V.TangentVector) #4 !dbg !991 {
entry:
  %0 = bitcast %swift.opaque* %object to %swift.refcounted**, !dbg !992
  %toDestroy1 = load %swift.refcounted*, %swift.refcounted** %0, align 8, !dbg !992
  tail call void @swift_release(%swift.refcounted* %toDestroy1) #0, !dbg !992
  ret void, !dbg !992
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1VV13TangentVectorVwcp"(%swift.opaque* noalias returned %dest, %swift.opaque* noalias nocapture readonly %src, %swift.type* nocapture readnone %V.TangentVector) #4 !dbg !993 {
entry:
  %.s = bitcast %swift.opaque* %dest to %T1M1SVySfG*, !dbg !994
  %.s1 = bitcast %swift.opaque* %src to %T1M1SVySfG*, !dbg !994
  %.s.c = bitcast %swift.opaque* %dest to %T1M1SV1CCySf_G**, !dbg !994
  %.s1.c = bitcast %swift.opaque* %src to %T1M1SV1CCySf_G**, !dbg !994
  %0 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.s1.c, align 8, !dbg !994
  %1 = bitcast %T1M1SV1CCySf_G* %0 to %swift.refcounted*, !dbg !994
  store %T1M1SV1CCySf_G* %0, %T1M1SV1CCySf_G** %.s.c, align 8, !dbg !994
  %.s.b = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.s, i64 0, i32 1, !dbg !994
  %.s1.b = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.s1, i64 0, i32 1, !dbg !994
  %2 = bitcast %TSb* %.s.b to i8*, !dbg !994
  %3 = bitcast %TSb* %.s1.b to i8*, !dbg !994
  %4 = load i8, i8* %3, align 8, !dbg !994
  store i8 %4, i8* %2, align 8, !dbg !994
  %5 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %1) #0, !dbg !994
  ret %swift.opaque* %dest, !dbg !994
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1VV13TangentVectorVwca"(%swift.opaque* returned %dest, %swift.opaque* nocapture readonly %src, %swift.type* nocapture readnone %V.TangentVector) #4 !dbg !995 {
entry:
  %.s = bitcast %swift.opaque* %dest to %T1M1SVySfG*, !dbg !996
  %.s1 = bitcast %swift.opaque* %src to %T1M1SVySfG*, !dbg !996
  %.s.c = bitcast %swift.opaque* %dest to %T1M1SV1CCySf_G**, !dbg !996
  %.s1.c = bitcast %swift.opaque* %src to %T1M1SV1CCySf_G**, !dbg !996
  %0 = load %T1M1SV1CCySf_G*, %T1M1SV1CCySf_G** %.s1.c, align 8, !dbg !996
  %1 = bitcast %T1M1SV1CCySf_G* %0 to %swift.refcounted*, !dbg !996
  %2 = bitcast %swift.opaque* %dest to %swift.refcounted**, !dbg !996
  %oldValue2 = load %swift.refcounted*, %swift.refcounted** %2, align 8, !dbg !996
  store %T1M1SV1CCySf_G* %0, %T1M1SV1CCySf_G** %.s.c, align 8, !dbg !996
  %3 = tail call %swift.refcounted* @swift_retain(%swift.refcounted* returned %1) #0, !dbg !996
  tail call void @swift_release(%swift.refcounted* %oldValue2) #0, !dbg !996
  %.s.b._value = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.s, i64 0, i32 1, i32 0, !dbg !996
  %.s1.b._value = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.s1, i64 0, i32 1, i32 0, !dbg !996
  %4 = load i1, i1* %.s1.b._value, align 8, !dbg !996
  store i1 %4, i1* %.s.b._value, align 8, !dbg !996
  ret %swift.opaque* %dest, !dbg !996
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1VV13TangentVectorVwta"(%swift.opaque* noalias returned %dest, %swift.opaque* noalias nocapture readonly %src, %swift.type* nocapture readnone %V.TangentVector) #4 !dbg !997 {
entry:
  %.s = bitcast %swift.opaque* %dest to %T1M1SVySfG*, !dbg !998
  %.s1 = bitcast %swift.opaque* %src to %T1M1SVySfG*, !dbg !998
  %0 = bitcast %swift.opaque* %src to i64*, !dbg !998
  %1 = load i64, i64* %0, align 8, !dbg !998
  %2 = bitcast %swift.opaque* %dest to %swift.refcounted**, !dbg !998
  %oldValue2 = load %swift.refcounted*, %swift.refcounted** %2, align 8, !dbg !998
  %3 = bitcast %swift.opaque* %dest to i64*, !dbg !998
  store i64 %1, i64* %3, align 8, !dbg !998
  tail call void @swift_release(%swift.refcounted* %oldValue2) #0, !dbg !998
  %.s.b._value = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.s, i64 0, i32 1, i32 0, !dbg !998
  %.s1.b._value = getelementptr inbounds %T1M1SVySfG, %T1M1SVySfG* %.s1, i64 0, i32 1, i32 0, !dbg !998
  %4 = load i1, i1* %.s1.b._value, align 8, !dbg !998
  store i1 %4, i1* %.s.b._value, align 8, !dbg !998
  ret %swift.opaque* %dest, !dbg !998
}
; Function Attrs: norecurse nounwind readonly
define internal i32 @"$s4main1VV13TangentVectorVwet"(%swift.opaque* noalias nocapture readonly %value, i32 %numEmptyCases, %swift.type* nocapture readnone %V.TangentVector) #14 !dbg !999 {
entry:
  %0 = icmp eq i32 %numEmptyCases, 0, !dbg !1000
  br i1 %0, label %17, label %1, !dbg !1000

1:                                                ; preds = %entry
  %2 = icmp ugt i32 %numEmptyCases, 4096, !dbg !1000
  br i1 %2, label %3, label %is-valid-pointer, !dbg !1000

3:                                                ; preds = %1
  %4 = bitcast %swift.opaque* %value to i8*, !dbg !1000
  %5 = getelementptr inbounds i8, i8* %4, i64 9, !dbg !1000
  %6 = load i8, i8* %5, align 1, !dbg !1000
  %7 = icmp eq i8 %6, 0, !dbg !1000
  br i1 %7, label %is-valid-pointer, label %8, !dbg !1000

8:                                                ; preds = %3
  %9 = bitcast %swift.opaque* %value to i72*, !dbg !1000
  %10 = load i72, i72* %9, align 1, !dbg !1000
  %11 = trunc i72 %10 to i32, !dbg !1000
  %12 = add i32 %11, 4096, !dbg !1000
  br label %17, !dbg !1000

is-valid-pointer:                                 ; preds = %3, %1
  %13 = bitcast %swift.opaque* %value to i64*, !dbg !1000
  %14 = load i64, i64* %13, align 8, !dbg !1000
  %15 = icmp ugt i64 %14, 4095, !dbg !1000
  %16 = trunc i64 %14 to i32, !dbg !1000
  %spec.select = select i1 %15, i32 -1, i32 %16, !dbg !1000
  br label %17, !dbg !1000

17:                                               ; preds = %entry, %is-valid-pointer, %8
  %18 = phi i32 [ %spec.select, %is-valid-pointer ], [ %12, %8 ], [ -1, %entry ], !dbg !1000
  %19 = add i32 %18, 1, !dbg !1000
  ret i32 %19, !dbg !1000
}
; Function Attrs: nofree norecurse nounwind writeonly
define internal void @"$s4main1VV13TangentVectorVwst"(%swift.opaque* noalias nocapture %value, i32 %whichCase, i32 %numEmptyCases, %swift.type* nocapture readnone %V.TangentVector) #5 !dbg !1001 {
entry:
  %0 = bitcast %swift.opaque* %value to i8*, !dbg !1002
  %1 = getelementptr inbounds i8, i8* %0, i64 9, !dbg !1002
  %2 = icmp ugt i32 %numEmptyCases, 4096, !dbg !1002
  %3 = icmp ult i32 %whichCase, 4097, !dbg !1002
  br i1 %3, label %4, label %12, !dbg !1002

4:                                                ; preds = %entry
  br i1 %2, label %5, label %6, !dbg !1002

5:                                                ; preds = %4
  store i8 0, i8* %1, align 1, !dbg !1002
  br label %6, !dbg !1002

6:                                                ; preds = %4, %5
  %7 = icmp eq i32 %whichCase, 0, !dbg !1002
  br i1 %7, label %17, label %8, !dbg !1002

8:                                                ; preds = %6
  %9 = add nsw i32 %whichCase, -1, !dbg !1002
  %10 = zext i32 %9 to i64, !dbg !1002
  %11 = bitcast %swift.opaque* %value to i64*, !dbg !1002
  store i64 %10, i64* %11, align 8, !dbg !1002
  br label %17, !dbg !1002

12:                                               ; preds = %entry
  %13 = add i32 %whichCase, -4097, !dbg !1002
  %14 = zext i32 %13 to i72, !dbg !1002
  %15 = bitcast %swift.opaque* %value to i72*, !dbg !1002
  store i72 %14, i72* %15, align 8, !dbg !1002
  br i1 %2, label %16, label %17, !dbg !1002

16:                                               ; preds = %12
  store i8 1, i8* %1, align 1, !dbg !1002
  br label %17, !dbg !1002

17:                                               ; preds = %12, %16, %8, %6
  ret void, !dbg !1002
}
; Function Attrs: noinline norecurse nounwind readnone
define hidden swiftcc %swift.metadata_response @"$s4main1VV13TangentVectorVMa"(i64 %0) #13 !dbg !1003 {
entry:
  ret %swift.metadata_response { %swift.type* bitcast (i64* getelementptr inbounds (<{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, [4 x i8] }>, <{ i8**, i64, <{ i32, i32, i32, i32, i32, i32, i32 }>*, i32, [4 x i8] }>* @"$s4main1VV13TangentVectorVMf", i32 0, i32 1) to %swift.type*), i64 0 }, !dbg !1004
}
declare extern_weak void @"_swift_FORCE_LOAD_$_swiftGlibc"()
define internal swiftcc void @"$s4main1VV13TangentVectorVIego_AEIegr_TRTA"(%T4main1VV13TangentVectorV* noalias nocapture sret %0, %swift.refcounted* nocapture readonly swiftself %1) #2 !dbg !1005 {
entry:
  %2 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %1, i64 1, !dbg !1006
  %3 = bitcast %swift.refcounted* %2 to { %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)**, !dbg !1006
  %4 = load { %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)*, { %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)** %3, align 8, !dbg !1006
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %1, i64 1, i32 1, !dbg !1006
  %5 = bitcast i64* %.data to %swift.refcounted**, !dbg !1006
  %6 = load %swift.refcounted*, %swift.refcounted** %5, align 8, !dbg !1006
  %7 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } %4(%swift.refcounted* swiftself %6) #16, !dbg !1007, !noalias !1012
  %8 = extractvalue { %T1M1SV1CCySf_G*, i1 } %7, 0, !dbg !1007
  %9 = extractvalue { %T1M1SV1CCySf_G*, i1 } %7, 1, !dbg !1007
  %.s.c.i = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %0, i64 0, i32 0, i32 0, !dbg !1007
  store %T1M1SV1CCySf_G* %8, %T1M1SV1CCySf_G** %.s.c.i, align 8, !dbg !1007, !alias.scope !1012
  %.s.b._value.i = getelementptr inbounds %T4main1VV13TangentVectorV, %T4main1VV13TangentVectorV* %0, i64 0, i32 0, i32 1, i32 0, !dbg !1007
  store i1 %9, i1* %.s.b._value.i, align 8, !dbg !1007, !alias.scope !1012
  ret void, !dbg !1006
}
declare swiftcc void @"$ss18AdditiveArithmeticP1soiyxx_xtFZTj"(%swift.opaque* noalias nocapture sret, %swift.opaque* noalias nocapture, %swift.opaque* noalias nocapture, %swift.type* swiftself, %swift.type*, i8**) local_unnamed_addr #2
declare swiftcc void @"$ss18AdditiveArithmeticP1poiyxx_xtFZTj"(%swift.opaque* noalias nocapture sret, %swift.opaque* noalias nocapture, %swift.opaque* noalias nocapture, %swift.type* swiftself, %swift.type*, i8**) local_unnamed_addr #2
declare swiftcc void @"$ss18AdditiveArithmeticP2peoiyyxz_xtFZTj"(%swift.opaque* nocapture, %swift.opaque* noalias nocapture, %swift.type* swiftself, %swift.type*, i8**) local_unnamed_addr #2
; Function Attrs: nounwind readnone
declare swiftcc i8** @swift_getAssociatedConformanceWitness(i8**, %swift.type*, %swift.type*, %swift.protocol_requirement*, %swift.protocol_requirement*) local_unnamed_addr #15
define internal swiftcc void @"$s4main1UV13TangentVectorVIego_AEIegr_TRTA"(%T4main1UV13TangentVectorV* noalias nocapture sret %0, %swift.refcounted* nocapture readonly swiftself %1) #2 !dbg !1015 {
entry:
  %2 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %1, i64 1, !dbg !1016
  %3 = bitcast %swift.refcounted* %2 to { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)**, !dbg !1016
  %4 = load { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)*, { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } (%swift.refcounted*)** %3, align 8, !dbg !1016
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %1, i64 1, i32 1, !dbg !1016
  %5 = bitcast i64* %.data to %swift.refcounted**, !dbg !1016
  %6 = load %swift.refcounted*, %swift.refcounted** %5, align 8, !dbg !1016
  %7 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %4(%swift.refcounted* swiftself %6) #16, !dbg !1017, !noalias !1022
  %8 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %7, 0, !dbg !1017
  %9 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %7, 1, !dbg !1017
  %10 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %7, 2, !dbg !1017
  %11 = extractvalue { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %7, 3, !dbg !1017
  %.s.c.i = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 0, i32 0, !dbg !1017
  store %T1M1SV1CCySf_G* %8, %T1M1SV1CCySf_G** %.s.c.i, align 8, !dbg !1017, !alias.scope !1022
  %.s.b._value.i = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 0, i32 1, i32 0, !dbg !1017
  store i1 %9, i1* %.s.b._value.i, align 8, !dbg !1017, !alias.scope !1022
  %.v.s.c.i = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 0, !dbg !1017
  store %T1M1SV1CCySf_G* %10, %T1M1SV1CCySf_G** %.v.s.c.i, align 8, !dbg !1017, !alias.scope !1022
  %.v.s.b._value.i = getelementptr inbounds %T4main1UV13TangentVectorV, %T4main1UV13TangentVectorV* %0, i64 0, i32 2, i32 0, i32 1, i32 0, !dbg !1017
  store i1 %11, i1* %.v.s.b._value.i, align 8, !dbg !1017, !alias.scope !1022
  ret void, !dbg !1016
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.107(%swift.refcounted* swiftself %0) #4 !dbg !1025 {
entry:
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %0, i64 1, i32 1, !dbg !1026
  %1 = bitcast i64* %.data to %swift.refcounted**, !dbg !1026
  %2 = load %swift.refcounted*, %swift.refcounted** %1, align 8, !dbg !1026
  tail call void @swift_release(%swift.refcounted* %2) #0, !dbg !1026
  %.data1 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %0, i64 2, i32 1, !dbg !1026
  %3 = bitcast i64* %.data1 to %swift.refcounted**, !dbg !1026
  %4 = load %swift.refcounted*, %swift.refcounted** %3, align 8, !dbg !1026
  tail call void @swift_release(%swift.refcounted* %4) #0, !dbg !1026
  tail call void @swift_deallocObject(%swift.refcounted* %0, i64 48, i64 7), !dbg !1026
  ret void, !dbg !1026
}
define internal swiftcc void @"$s4main1TV13TangentVectorVIego_AEIegr_TRTA"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %swift.refcounted* nocapture readonly swiftself %1) #2 !dbg !1027 {
entry:
  %2 = alloca %T4main1TV13TangentVectorV, align 8
  %3 = getelementptr inbounds %swift.refcounted, %swift.refcounted* %1, i64 1, !dbg !1028
  %4 = bitcast %swift.refcounted* %3 to void (%T4main1TV13TangentVectorV*, %swift.refcounted*)**, !dbg !1028
  %5 = load void (%T4main1TV13TangentVectorV*, %swift.refcounted*)*, void (%T4main1TV13TangentVectorV*, %swift.refcounted*)** %4, align 8, !dbg !1028
  %.data = getelementptr inbounds %swift.refcounted, %swift.refcounted* %1, i64 1, i32 1, !dbg !1028
  %6 = bitcast i64* %.data to %swift.refcounted**, !dbg !1028
  %7 = load %swift.refcounted*, %swift.refcounted** %6, align 8, !dbg !1028
  %8 = bitcast %T4main1TV13TangentVectorV* %2 to i8*, !dbg !1029
  call void @llvm.lifetime.start.p0i8(i64 57, i8* nonnull %8), !dbg !1029, !noalias !1034
  call swiftcc void %5(%T4main1TV13TangentVectorV* noalias nocapture nonnull sret %2, %swift.refcounted* swiftself %7) #16, !dbg !1029, !noalias !1034
  %9 = bitcast %T4main1TV13TangentVectorV* %0 to i8*, !dbg !1029
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 8 dereferenceable(57) %9, i8* nonnull align 8 dereferenceable(57) %8, i64 57, i1 false), !dbg !1029
  call void @llvm.lifetime.end.p0i8(i64 57, i8* nonnull %8), !dbg !1029, !noalias !1034
  ret void, !dbg !1028
}
; Function Attrs: nounwind
define internal void @"$s4main1UVwxx"(%swift.opaque* noalias nocapture readonly %0, %swift.type* nocapture readnone %1) #4 {
  tail call void @"$s4main1UV13TangentVectorVwxx"(%swift.opaque* noalias nocapture readonly %0, %swift.type* nocapture readnone %1) #4
  ret void
}
; Function Attrs: norecurse nounwind readnone
define hidden swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV1s1vAC1M1SVySfG_AA1VVtcfC"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3) local_unnamed_addr #8 {
  %5 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV1s1vAE1M1SVySfG_AA1VVADVtcfC"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3) #8
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %5
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1UVwca"(%swift.opaque* returned %0, %swift.opaque* nocapture readonly %1, %swift.type* nocapture readnone %2) #4 {
  %4 = tail call %swift.opaque* @"$s4main1UV13TangentVectorVwca"(%swift.opaque* returned %0, %swift.opaque* nocapture readonly %1, %swift.type* nocapture readnone %2) #4
  ret %swift.opaque* %4
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.5(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.16(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.24(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.30(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.41(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.49(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.53(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.57(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.61(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.64(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.68(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.72(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.80(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.83(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.91(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.95(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.103(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.115(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.118(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.126(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.138(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: norecurse nounwind readonly
define internal i32 @"$s4main1TVwet"(%swift.opaque* noalias nocapture readonly %0, i32 %1, %swift.type* nocapture readnone %2) #14 {
  %4 = tail call i32 @"$s4main1TV13TangentVectorVwet"(%swift.opaque* noalias nocapture readonly %0, i32 %1, %swift.type* nocapture readnone %2) #14
  ret i32 %4
}
; Function Attrs: norecurse nounwind readonly
define internal i32 @"$s4main1UVwet"(%swift.opaque* noalias nocapture readonly %0, i32 %1, %swift.type* nocapture readnone %2) #14 {
  %4 = tail call i32 @"$s4main1UV13TangentVectorVwet"(%swift.opaque* noalias nocapture readonly %0, i32 %1, %swift.type* nocapture readnone %2) #14
  ret i32 %4
}
; Function Attrs: norecurse nounwind readonly
define internal i32 @"$s4main1VVwet"(%swift.opaque* noalias nocapture readonly %0, i32 %1, %swift.type* nocapture readnone %2) #14 {
  %4 = tail call i32 @"$s4main1VV13TangentVectorVwet"(%swift.opaque* noalias nocapture readonly %0, i32 %1, %swift.type* nocapture readnone %2) #14
  ret i32 %4
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1TVwta"(%swift.opaque* noalias returned %0, %swift.opaque* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4 {
  %4 = tail call %swift.opaque* @"$s4main1TV13TangentVectorVwta"(%swift.opaque* noalias returned %0, %swift.opaque* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4
  ret %swift.opaque* %4
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.7"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.18"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.32"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.43"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.51"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.55"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.59"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.66"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.74"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.85"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.97"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.105"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.120"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.128"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1 } %2
}
; Function Attrs: nounwind
define internal void @"$s4main1VVwxx"(%swift.opaque* noalias nocapture readonly %0, %swift.type* nocapture readnone %1) #4 {
  tail call void @"$s4main1VV13TangentVectorVwxx"(%swift.opaque* noalias nocapture readonly %0, %swift.type* nocapture readnone %1) #4
  ret void
}
; Function Attrs: nounwind
define hidden swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1UV1s1M1SVySfGvg"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* nocapture readnone %2, i1 %3) local_unnamed_addr #4 {
  %5 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV1s1M1SVySfGvg"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* nocapture readnone %2, i1 %3) #4
  ret { %T1M1SV1CCySf_G*, i1 } %5
}
; Function Attrs: nounwind
define hidden swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1UV1vAA1VVvg"(%T1M1SV1CCySf_G* nocapture readnone %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3) local_unnamed_addr #4 {
  %5 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV1vAA1VVADVvg"(%T1M1SV1CCySf_G* nocapture readnone %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3) #4
  ret { %T1M1SV1CCySf_G*, i1 } %5
}
define internal swiftcc void @"$s4main1UV13TangentVectorVIego_AEIegr_TRTA.93"(%T4main1UV13TangentVectorV* noalias nocapture sret %0, %swift.refcounted* nocapture readonly swiftself %1) #2 {
  tail call swiftcc void @"$s4main1UV13TangentVectorVIego_AEIegr_TRTA"(%T4main1UV13TangentVectorV* noalias nocapture sret %0, %swift.refcounted* nocapture readonly swiftself %1) #2
  ret void
}
; Function Attrs: norecurse nounwind readnone
define hidden swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV1sAC1M1SVySfG_tcfC"(%T1M1SV1CCySf_G* %0, i1 %1) local_unnamed_addr #8 {
  %3 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV1sAE1M1SVySfG_tcfC"(%T1M1SV1CCySf_G* %0, i1 %1) #8
  ret { %T1M1SV1CCySf_G*, i1 } %3
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1VVwcp"(%swift.opaque* noalias returned %0, %swift.opaque* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4 {
  %4 = tail call %swift.opaque* @"$s4main1VV13TangentVectorVwcp"(%swift.opaque* noalias returned %0, %swift.opaque* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4
  ret %swift.opaque* %4
}
; Function Attrs: nounwind
define hidden swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV1s1M1SVySfGvg"(%T1M1SV1CCySf_G* %0, i1 %1) local_unnamed_addr #4 {
  %3 = tail call swiftcc { %T1M1SV1CCySf_G*, i1 } @"$s4main1VV13TangentVectorV1s1M1SVySfGvg"(%T1M1SV1CCySf_G* %0, i1 %1) #4
  ret { %T1M1SV1CCySf_G*, i1 } %3
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1VVwta"(%swift.opaque* noalias returned %0, %swift.opaque* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4 {
  %4 = tail call %swift.opaque* @"$s4main1VV13TangentVectorVwta"(%swift.opaque* noalias returned %0, %swift.opaque* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4
  ret %swift.opaque* %4
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1VVwca"(%swift.opaque* returned %0, %swift.opaque* nocapture readonly %1, %swift.type* nocapture readnone %2) #4 {
  %4 = tail call %swift.opaque* @"$s4main1VV13TangentVectorVwca"(%swift.opaque* returned %0, %swift.opaque* nocapture readonly %1, %swift.type* nocapture readnone %2) #4
  ret %swift.opaque* %4
}
define internal swiftcc void @"$s4main1TV13TangentVectorVIego_AEIegr_TRTA.140"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %swift.refcounted* nocapture readonly swiftself %1) #2 {
  tail call swiftcc void @"$s4main1TV13TangentVectorVIego_AEIegr_TRTA"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %swift.refcounted* nocapture readonly swiftself %1) #2
  ret void
}
; Function Attrs: nounwind
define internal void @"$s4main1TVwxx"(%swift.opaque* noalias nocapture readonly %0, %swift.type* nocapture readnone %1) #4 {
  tail call void @"$s4main1TV13TangentVectorVwxx"(%swift.opaque* noalias nocapture readonly %0, %swift.type* nocapture readnone %1) #4
  ret void
}
; Function Attrs: nounwind
define internal nonnull %swift.opaque* @"$s4main1TVwCP"([24 x i8]* noalias nocapture %0, [24 x i8]* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4 {
  %4 = tail call nonnull %swift.opaque* @"$s4main1TV13TangentVectorVwCP"([24 x i8]* noalias nocapture %0, [24 x i8]* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4
  ret %swift.opaque* %4
}
; Function Attrs: nounwind
define internal nonnull %swift.opaque* @"$s4main1UVwCP"([24 x i8]* noalias nocapture %0, [24 x i8]* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4 {
  %4 = tail call nonnull %swift.opaque* @"$s4main1TV13TangentVectorVwCP"([24 x i8]* noalias nocapture %0, [24 x i8]* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4
  ret %swift.opaque* %4
}
; Function Attrs: nounwind
define internal nonnull %swift.opaque* @"$s4main1UV13TangentVectorVwCP"([24 x i8]* noalias nocapture %0, [24 x i8]* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4 {
  %4 = tail call nonnull %swift.opaque* @"$s4main1TV13TangentVectorVwCP"([24 x i8]* noalias nocapture %0, [24 x i8]* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4
  ret %swift.opaque* %4
}
; Function Attrs: nofree norecurse nounwind writeonly
define internal void @"$s4main1TVwst"(%swift.opaque* noalias nocapture %0, i32 %1, i32 %2, %swift.type* nocapture readnone %3) #5 {
  tail call void @"$s4main1TV13TangentVectorVwst"(%swift.opaque* noalias nocapture %0, i32 %1, i32 %2, %swift.type* nocapture readnone %3) #5
  ret void
}
; Function Attrs: nofree norecurse nounwind writeonly
define internal void @"$s4main1UVwst"(%swift.opaque* noalias nocapture %0, i32 %1, i32 %2, %swift.type* nocapture readnone %3) #5 {
  tail call void @"$s4main1UV13TangentVectorVwst"(%swift.opaque* noalias nocapture %0, i32 %1, i32 %2, %swift.type* nocapture readnone %3) #5
  ret void
}
; Function Attrs: nofree norecurse nounwind writeonly
define internal void @"$s4main1VVwst"(%swift.opaque* noalias nocapture %0, i32 %1, i32 %2, %swift.type* nocapture readnone %3) #5 {
  tail call void @"$s4main1VV13TangentVectorVwst"(%swift.opaque* noalias nocapture %0, i32 %1, i32 %2, %swift.type* nocapture readnone %3) #5
  ret void
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1TVwca"(%swift.opaque* returned %0, %swift.opaque* nocapture readonly %1, %swift.type* nocapture readnone %2) #4 {
  %4 = tail call %swift.opaque* @"$s4main1TV13TangentVectorVwca"(%swift.opaque* returned %0, %swift.opaque* nocapture readonly %1, %swift.type* nocapture readnone %2) #4
  ret %swift.opaque* %4
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.9(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy.107(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.2(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy.107(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.20(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy.107(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.27(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy.107(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.34(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy.107(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.38(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy.107(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.45(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy.107(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.76(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy.107(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.87(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy.107(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.99(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy.107(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.13(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy.107(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.111(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy.107(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.122(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy.107(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.130(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy.107(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nounwind
define private swiftcc void @objectdestroy.134(%swift.refcounted* swiftself %0) #4 {
  tail call swiftcc void @objectdestroy.107(%swift.refcounted* swiftself %0) #4
  ret void
}
; Function Attrs: nofree norecurse nounwind writeonly
define hidden swiftcc void @"$s4main1TV2u12u2AcA1UV_AGtcfC"(%T4main1TV* noalias nocapture sret %0, %T1M1SV1CCySf_G* %1, i1 %2, %T1M1SV1CCySf_G* %3, i1 %4, %T1M1SV1CCySf_G* %5, i1 %6, %T1M1SV1CCySf_G* %7, i1 %8) local_unnamed_addr #5 {
  %10 = bitcast %T4main1TV* %0 to %T4main1TV13TangentVectorV*
  tail call swiftcc void @"$s4main1TV13TangentVectorV2u12u2AeA1UVADV_AJtcfC"(%T4main1TV13TangentVectorV* noalias nocapture sret %10, %T1M1SV1CCySf_G* %1, i1 %2, %T1M1SV1CCySf_G* %3, i1 %4, %T1M1SV1CCySf_G* %5, i1 %6, %T1M1SV1CCySf_G* %7, i1 %8) #5
  ret void
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.11"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.22"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.36"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.47"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.78"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.89"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.101"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.109"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.124"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %2
}
define internal swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.132"(%swift.refcounted* nocapture readonly swiftself %0) #2 {
  %2 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%swift.refcounted* nocapture readonly swiftself %0) #2
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %2
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1VVwCP"([24 x i8]* noalias %0, [24 x i8]* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4 {
  %4 = tail call %swift.opaque* @"$s4main1VV13TangentVectorVwCP"([24 x i8]* noalias %0, [24 x i8]* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4
  ret %swift.opaque* %4
}
; Function Attrs: nounwind
define hidden swiftcc void @"$s4main1UV1s1M1SVySfGvs"(%T1M1SV1CCySf_G* %0, i1 %1, %T4main1UV* nocapture swiftself dereferenceable(25) %2) local_unnamed_addr #4 {
  %4 = bitcast %T4main1UV* %2 to %T4main1UV13TangentVectorV*
  tail call swiftcc void @"$s4main1UV13TangentVectorV1s1M1SVySfGvs"(%T1M1SV1CCySf_G* %0, i1 %1, %T4main1UV13TangentVectorV* nocapture swiftself dereferenceable(25) %4) #4
  ret void
}
; Function Attrs: nounwind
define hidden swiftcc void @"$s4main1UV1vAA1VVvs"(%T1M1SV1CCySf_G* %0, i1 %1, %T4main1UV* nocapture swiftself dereferenceable(25) %2) local_unnamed_addr #4 {
  %4 = bitcast %T4main1UV* %2 to %T4main1UV13TangentVectorV*
  tail call swiftcc void @"$s4main1UV13TangentVectorV1vAA1VVADVvs"(%T1M1SV1CCySf_G* %0, i1 %1, %T4main1UV13TangentVectorV* nocapture swiftself dereferenceable(25) %4) #4
  ret void
}
define internal swiftcc void @"$s4main1TV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %swift.refcounted* nocapture readonly swiftself %1) #2 {
  tail call swiftcc void @"$s4main1TV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %swift.refcounted* nocapture readonly swiftself %1) #2
  ret void
}
define internal swiftcc void @"$s4main1TV28zeroTangentVectorInitializerAC0cD0VycvgAFycfU_TA.113"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %swift.refcounted* nocapture readonly swiftself %1) #2 {
  tail call swiftcc void @"$s4main1TV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %swift.refcounted* nocapture readonly swiftself %1) #2
  ret void
}
define internal swiftcc void @"$s4main1TV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA.136"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %swift.refcounted* nocapture readonly swiftself %1) #2 {
  tail call swiftcc void @"$s4main1TV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA"(%T4main1TV13TangentVectorV* noalias nocapture sret %0, %swift.refcounted* nocapture readonly swiftself %1) #2
  ret void
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1UVwta"(%swift.opaque* noalias returned %0, %swift.opaque* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4 {
  %4 = tail call %swift.opaque* @"$s4main1UV13TangentVectorVwta"(%swift.opaque* noalias returned %0, %swift.opaque* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4
  ret %swift.opaque* %4
}
; Function Attrs: nounwind
define hidden swiftcc void @"$s4main1TV2u1AA1UVvs"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3, %T4main1TV* nocapture swiftself dereferenceable(57) %4) local_unnamed_addr #4 {
  %6 = bitcast %T4main1TV* %4 to %T4main1TV13TangentVectorV*
  tail call swiftcc void @"$s4main1TV13TangentVectorV2u1AA1UVADVvs"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3, %T4main1TV13TangentVectorV* nocapture swiftself dereferenceable(57) %6) #4
  ret void
}
; Function Attrs: nounwind
define hidden swiftcc void @"$s4main1TV2u2AA1UVvs"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3, %T4main1TV* nocapture swiftself dereferenceable(57) %4) local_unnamed_addr #4 {
  %6 = bitcast %T4main1TV* %4 to %T4main1TV13TangentVectorV*
  tail call swiftcc void @"$s4main1TV13TangentVectorV2u2AA1UVADVvs"(%T1M1SV1CCySf_G* %0, i1 %1, %T1M1SV1CCySf_G* %2, i1 %3, %T4main1TV13TangentVectorV* nocapture swiftself dereferenceable(57) %6) #4
  ret void
}
; Function Attrs: nounwind
define hidden swiftcc void @"$s4main1VV1s1M1SVySfGvs"(%T1M1SV1CCySf_G* %0, i1 %1, %T4main1VV* nocapture swiftself dereferenceable(9) %2) local_unnamed_addr #4 {
  %4 = bitcast %T4main1VV* %2 to %T4main1VV13TangentVectorV*
  tail call swiftcc void @"$s4main1VV13TangentVectorV1s1M1SVySfGvs"(%T1M1SV1CCySf_G* %0, i1 %1, %T4main1VV13TangentVectorV* nocapture swiftself dereferenceable(9) %4) #4
  ret void
}
define internal swiftcc void @"$s4main1VV13TangentVectorVIego_AEIegr_TRTA.70"(%T4main1VV13TangentVectorV* noalias nocapture sret %0, %swift.refcounted* nocapture readonly swiftself %1) #2 {
  tail call swiftcc void @"$s4main1VV13TangentVectorVIego_AEIegr_TRTA"(%T4main1VV13TangentVectorV* noalias nocapture sret %0, %swift.refcounted* nocapture readonly swiftself %1) #2
  ret void
}
; Function Attrs: nounwind
define hidden swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1TV2u1AA1UVvg"(%T4main1TV* noalias nocapture readonly swiftself dereferenceable(57) %0) local_unnamed_addr #4 {
  %2 = bitcast %T4main1TV* %0 to %T4main1TV13TangentVectorV*
  %3 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1TV13TangentVectorV2u1AA1UVADVvg"(%T4main1TV13TangentVectorV* noalias nocapture readonly swiftself dereferenceable(57) %2) #4
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %3
}
; Function Attrs: nounwind
define hidden swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1TV2u2AA1UVvg"(%T4main1TV* noalias nocapture readonly swiftself dereferenceable(57) %0) local_unnamed_addr #4 {
  %2 = bitcast %T4main1TV* %0 to %T4main1TV13TangentVectorV*
  %3 = tail call swiftcc { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } @"$s4main1TV13TangentVectorV2u2AA1UVADVvg"(%T4main1TV13TangentVectorV* noalias nocapture readonly swiftself dereferenceable(57) %2) #4
  ret { %T1M1SV1CCySf_G*, i1, %T1M1SV1CCySf_G*, i1 } %3
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1UVwcp"(%swift.opaque* noalias returned %0, %swift.opaque* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4 {
  %4 = tail call %swift.opaque* @"$s4main1UV13TangentVectorVwcp"(%swift.opaque* noalias returned %0, %swift.opaque* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4
  ret %swift.opaque* %4
}
; Function Attrs: nounwind
define internal %swift.opaque* @"$s4main1TVwcp"(%swift.opaque* noalias returned %0, %swift.opaque* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4 {
  %4 = tail call %swift.opaque* @"$s4main1TV13TangentVectorVwcp"(%swift.opaque* noalias returned %0, %swift.opaque* noalias nocapture readonly %1, %swift.type* nocapture readnone %2) #4
  ret %swift.opaque* %4
}

attributes #0 = { nounwind }
attributes #1 = { noinline nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nofree nounwind }
attributes #4 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nofree norecurse nounwind writeonly "correctly-rounded-divide-sqrt-fp-math"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { argmemonly nounwind willreturn }
attributes #7 = { nounwind readnone speculatable willreturn }
attributes #8 = { norecurse nounwind readnone "correctly-rounded-divide-sqrt-fp-math"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #9 = { noinline nounwind }
attributes #10 = { nounwind readnone "correctly-rounded-divide-sqrt-fp-math"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #11 = { noinline nounwind readnone "correctly-rounded-divide-sqrt-fp-math"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #12 = { nounwind readonly }
attributes #13 = { noinline norecurse nounwind readnone "correctly-rounded-divide-sqrt-fp-math"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #14 = { norecurse nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #15 = { nounwind readnone }
attributes #16 = { noinline }

!llvm.dbg.cu = !{!0, !12}
!swift.module.flags = !{!14}
!llvm.asan.globals = !{!15, !16, !17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !44, !45, !46, !47, !48, !49, !50, !51, !52, !53, !54, !55, !56, !57, !58, !59, !60, !61, !62, !63, !64, !65, !66, !67, !68, !69, !70, !71, !72, !73, !74, !75, !76, !77, !78, !79, !80, !81, !82, !83, !84, !85, !86, !87, !88, !89, !90, !91, !92, !93, !94, !95, !96, !97, !98, !99, !100, !101, !102, !103, !104, !105, !106, !107, !108, !109, !110, !111, !112, !113, !114, !115, !116, !117, !118, !119}
!llvm.linker.options = !{}
!llvm.module.flags = !{!120, !121, !122, !123, !124, !125}

!0 = distinct !DICompileUnit(language: DW_LANG_Swift, file: !1, producer: "Swift version 5.3-dev (LLVM f8bd914aadc2e7b, Swift d4d5ed508cb7f92)", isOptimized: true, runtimeVersion: 5, emissionKind: FullDebug, enums: !2, imports: !3)
!1 = !DIFile(filename: "/home/danielzheng/swift-dev/swift/test/DebugInfo/sr13263.swift", directory: "/home/danielzheng/swift-dev/build/Ninja-ReleaseAssert/swift-linux-x86_64/test-linux-x86_64/DebugInfo")
!2 = !{}
!3 = !{!4, !6, !8, !10}
!4 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !1, entity: !5, file: !1)
!5 = !DIModule(scope: null, name: "main", includePath: "/home/danielzheng/swift-dev/swift/test/DebugInfo")
!6 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !1, entity: !7, file: !1)
!7 = !DIModule(scope: null, name: "Swift", includePath: "/home/danielzheng/swift-dev/build/Ninja-ReleaseAssert/swift-linux-x86_64/lib/swift/linux/x86_64/Swift.swiftmodule")
!8 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !1, entity: !9, file: !1, line: 60)
!9 = !DIModule(scope: null, name: "_Differentiation", includePath: "/home/danielzheng/swift-dev/build/Ninja-ReleaseAssert/swift-linux-x86_64/lib/swift/linux/x86_64/_Differentiation.swiftmodule")
!10 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !1, entity: !11, file: !1, line: 61)
!11 = !DIModule(scope: null, name: "M", includePath: "/home/danielzheng/swift-dev/build/Ninja-ReleaseAssert/swift-linux-x86_64/test-linux-x86_64/DebugInfo/Output/sr13263.swift.tmp/M.swiftmodule")
!12 = distinct !DICompileUnit(language: DW_LANG_C99, file: !13, producer: "clang version 10.0.0 (https://github.com/apple/llvm-project.git 6df337cdaf5a70eac5ac6001be0edf94cd266eaf)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!13 = !DIFile(filename: "<swift-imported-modules>", directory: "/home/danielzheng/swift-dev/build/Ninja-ReleaseAssert/swift-linux-x86_64/test-linux-x86_64/DebugInfo")
!14 = !{!"standard-library", i1 false}
!15 = !{<{ i8, i32, [9 x i8], i8 }>* @"symbolic _____ySfGIego_ 1M1SV", null, null, i1 false, i1 true}
!16 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor", null, null, i1 false, i1 true}
!17 = !{<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1VV13TangentVectorV", null, null, i1 false, i1 true}
!18 = !{{ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.1", null, null, i1 false, i1 true}
!19 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.4", null, null, i1 false, i1 true}
!20 = !{{ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.8", null, null, i1 false, i1 true}
!21 = !{<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iego_ 4main1UV13TangentVectorV", null, null, i1 false, i1 true}
!22 = !{{ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.12", null, null, i1 false, i1 true}
!23 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.15", null, null, i1 false, i1 true}
!24 = !{{ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.19", null, null, i1 false, i1 true}
!25 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.23", null, null, i1 false, i1 true}
!26 = !{{ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.26", null, null, i1 false, i1 true}
!27 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.29", null, null, i1 false, i1 true}
!28 = !{{ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.33", null, null, i1 false, i1 true}
!29 = !{{ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.37", null, null, i1 false, i1 true}
!30 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.40", null, null, i1 false, i1 true}
!31 = !{{ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.44", null, null, i1 false, i1 true}
!32 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.48", null, null, i1 false, i1 true}
!33 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.52", null, null, i1 false, i1 true}
!34 = !{<{ i8, i8, i32, i8 }>* @"associated conformance 4main1TV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmetic", null, null, i1 false, i1 true}
!35 = !{<{ i8, i8, i32, i8 }>* @"associated conformance 4main1TV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AfG", null, null, i1 false, i1 true}
!36 = !{<{ i8, i32, i8 }>* @"symbolic _____ 4main1TV13TangentVectorV", null, null, i1 false, i1 true}
!37 = !{<{ [37 x i8], i8 }>* @"symbolic $s16_Differentiation14DifferentiableP", null, null, i1 false, i1 true}
!38 = !{[14 x i8]* @0, null, null, i1 false, i1 true}
!39 = !{{ i32, i32, i32, i32, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMA", null, null, i1 false, i1 true}
!40 = !{{ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAAMc", null, null, i1 false, i1 true}
!41 = !{<{ i8, i8, i32, i8 }>* @"associated conformance 4main1TV13TangentVectorVs18AdditiveArithmeticAASQ", null, null, i1 false, i1 true}
!42 = !{{ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVs18AdditiveArithmeticAAMc", null, null, i1 false, i1 true}
!43 = !{{ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV13TangentVectorVSQAAMc", null, null, i1 false, i1 true}
!44 = !{<{ i8, i8, i32, i8 }>* @"associated conformance 4main1TV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmetic", null, null, i1 false, i1 true}
!45 = !{<{ i8, i8, i32, i8 }>* @"associated conformance 4main1TV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AdE", null, null, i1 false, i1 true}
!46 = !{<{ i8, i32, i8 }>* @"symbolic _____ 4main1TV", null, null, i1 false, i1 true}
!47 = !{{ i32, i32, i32, i32, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMA", null, null, i1 false, i1 true}
!48 = !{{ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1TV16_Differentiation14DifferentiableAAMc", null, null, i1 false, i1 true}
!49 = !{<{ i8, i8, i32, i8 }>* @"associated conformance 4main1UV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmetic", null, null, i1 false, i1 true}
!50 = !{<{ i8, i8, i32, i8 }>* @"associated conformance 4main1UV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AfG", null, null, i1 false, i1 true}
!51 = !{<{ i8, i32, i8 }>* @"symbolic _____ 4main1UV13TangentVectorV", null, null, i1 false, i1 true}
!52 = !{{ i32, i32, i32, i32, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMA", null, null, i1 false, i1 true}
!53 = !{{ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAAMc", null, null, i1 false, i1 true}
!54 = !{<{ i8, i8, i32, i8 }>* @"associated conformance 4main1UV13TangentVectorVs18AdditiveArithmeticAASQ", null, null, i1 false, i1 true}
!55 = !{{ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVs18AdditiveArithmeticAAMc", null, null, i1 false, i1 true}
!56 = !{{ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV13TangentVectorVSQAAMc", null, null, i1 false, i1 true}
!57 = !{<{ i8, i8, i32, i8 }>* @"associated conformance 4main1UV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmetic", null, null, i1 false, i1 true}
!58 = !{<{ i8, i8, i32, i8 }>* @"associated conformance 4main1UV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AdE", null, null, i1 false, i1 true}
!59 = !{<{ i8, i32, i8 }>* @"symbolic _____ 4main1UV", null, null, i1 false, i1 true}
!60 = !{{ i32, i32, i32, i32, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMA", null, null, i1 false, i1 true}
!61 = !{{ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1UV16_Differentiation14DifferentiableAAMc", null, null, i1 false, i1 true}
!62 = !{<{ i8, i8, i32, i8 }>* @"associated conformance 4main1VV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmetic", null, null, i1 false, i1 true}
!63 = !{<{ i8, i8, i32, i8 }>* @"associated conformance 4main1VV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AfG", null, null, i1 false, i1 true}
!64 = !{<{ i8, i32, i8 }>* @"symbolic _____ 4main1VV13TangentVectorV", null, null, i1 false, i1 true}
!65 = !{{ i32, i32, i32, i32, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMA", null, null, i1 false, i1 true}
!66 = !{{ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAAMc", null, null, i1 false, i1 true}
!67 = !{<{ i8, i8, i32, i8 }>* @"associated conformance 4main1VV13TangentVectorVs18AdditiveArithmeticAASQ", null, null, i1 false, i1 true}
!68 = !{{ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVs18AdditiveArithmeticAAMc", null, null, i1 false, i1 true}
!69 = !{{ i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV13TangentVectorVSQAAMc", null, null, i1 false, i1 true}
!70 = !{<{ i8, i8, i32, i8 }>* @"associated conformance 4main1VV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmetic", null, null, i1 false, i1 true}
!71 = !{<{ i8, i8, i32, i8 }>* @"associated conformance 4main1VV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AdE", null, null, i1 false, i1 true}
!72 = !{<{ i8, i32, i8 }>* @"symbolic _____ 4main1VV", null, null, i1 false, i1 true}
!73 = !{{ i32, i32, i32, i32, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMA", null, null, i1 false, i1 true}
!74 = !{{ i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i32, i32 }* @"$s4main1VV16_Differentiation14DifferentiableAAMc", null, null, i1 false, i1 true}
!75 = !{<{ i32, i32, i32 }>* @"$s4mainMXM", null, null, i1 false, i1 true}
!76 = !{<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TVMn", null, null, i1 false, i1 true}
!77 = !{[3 x i8]* @3, null, null, i1 false, i1 true}
!78 = !{[3 x i8]* @4, null, null, i1 false, i1 true}
!79 = !{{ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1TVMF", null, null, i1 false, i1 true}
!80 = !{<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1TV13TangentVectorVMn", null, null, i1 false, i1 true}
!81 = !{{ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1TV13TangentVectorVMF", null, null, i1 false, i1 true}
!82 = !{<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UVMn", null, null, i1 false, i1 true}
!83 = !{<{ i8, i32, [4 x i8], i8 }>* @"symbolic _____ySfG 1M1SV", null, null, i1 false, i1 true}
!84 = !{[2 x i8]* @7, null, null, i1 false, i1 true}
!85 = !{[2 x i8]* @8, null, null, i1 false, i1 true}
!86 = !{{ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1UVMF", null, null, i1 false, i1 true}
!87 = !{<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1UV13TangentVectorVMn", null, null, i1 false, i1 true}
!88 = !{{ i32, i32, i16, i16, i32, i32, i32, i32, i32, i32, i32 }* @"$s4main1UV13TangentVectorVMF", null, null, i1 false, i1 true}
!89 = !{<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VVMn", null, null, i1 false, i1 true}
!90 = !{{ i32, i32, i16, i16, i32, i32, i32, i32 }* @"$s4main1VVMF", null, null, i1 false, i1 true}
!91 = !{<{ i32, i32, i32, i32, i32, i32, i32 }>* @"$s4main1VV13TangentVectorVMn", null, null, i1 false, i1 true}
!92 = !{{ i32, i32, i16, i16, i32, i32, i32, i32 }* @"$s4main1VV13TangentVectorVMF", null, null, i1 false, i1 true}
!93 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.56", null, null, i1 false, i1 true}
!94 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.60", null, null, i1 false, i1 true}
!95 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.63", null, null, i1 false, i1 true}
!96 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.67", null, null, i1 false, i1 true}
!97 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.71", null, null, i1 false, i1 true}
!98 = !{{ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.75", null, null, i1 false, i1 true}
!99 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.79", null, null, i1 false, i1 true}
!100 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.82", null, null, i1 false, i1 true}
!101 = !{{ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.86", null, null, i1 false, i1 true}
!102 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.90", null, null, i1 false, i1 true}
!103 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.94", null, null, i1 false, i1 true}
!104 = !{{ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.98", null, null, i1 false, i1 true}
!105 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.102", null, null, i1 false, i1 true}
!106 = !{{ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.106", null, null, i1 false, i1 true}
!107 = !{{ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.110", null, null, i1 false, i1 true}
!108 = !{<{ i8, i32, [5 x i8], i8 }>* @"symbolic _____Iegr_ 4main1TV13TangentVectorV", null, null, i1 false, i1 true}
!109 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.114", null, null, i1 false, i1 true}
!110 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.117", null, null, i1 false, i1 true}
!111 = !{{ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.121", null, null, i1 false, i1 true}
!112 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.125", null, null, i1 false, i1 true}
!113 = !{{ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.129", null, null, i1 false, i1 true}
!114 = !{{ i32, i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.133", null, null, i1 false, i1 true}
!115 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor.137", null, null, i1 false, i1 true}
!116 = !{[12 x i32]* @"\01l_protocol_conformances", null, null, i1 false, i1 true}
!117 = !{[6 x %swift.type_metadata_record]* @"\01l_type_metadata_table", null, null, i1 false, i1 true}
!118 = !{[100 x i8]* @_swift1_autolink_entries, null, null, i1 false, i1 true}
!119 = distinct !{null, null, null, i1 false, i1 true}
!120 = !{i32 7, !"Dwarf Version", i32 4}
!121 = !{i32 2, !"Debug Info Version", i32 3}
!122 = !{i32 1, !"wchar_size", i32 4}
!123 = !{i32 7, !"PIC Level", i32 2}
!124 = !{i32 4, !"Objective-C Garbage Collection", i32 84084480}
!125 = !{i32 1, !"Swift Version", i32 7}
!126 = distinct !DISubprogram(name: "u1.modify", linkageName: "$s4main1TV2u1AA1UVvM", scope: !128, file: !127, type: !129, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!127 = !DIFile(filename: "<compiler-generated>", directory: "")
!128 = !DICompositeType(tag: DW_TAG_structure_type, name: "T", scope: !5, file: !1, size: 456, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$s4main1TVD")
!129 = !DISubroutineType(types: !130)
!130 = !{!131, !128}
!131 = !DICompositeType(tag: DW_TAG_structure_type, name: "$sytD", file: !1, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$sytD")
!132 = !DILocation(line: 0, scope: !133)
!133 = !DILexicalBlockFile(scope: !134, file: !127, discriminator: 0)
!134 = distinct !DILexicalBlock(scope: !126, file: !1, line: 64, column: 7)
!135 = distinct !DISubprogram(name: "u1.modify", linkageName: "$s4main1TV2u1AA1UVvM", scope: !128, file: !127, type: !129, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!136 = !DILocation(line: 0, scope: !137)
!137 = !DILexicalBlockFile(scope: !138, file: !127, discriminator: 0)
!138 = distinct !DILexicalBlock(scope: !135, file: !1, line: 64, column: 7)
!139 = distinct !DISubprogram(name: "u2.modify", linkageName: "$s4main1TV2u2AA1UVvM", scope: !128, file: !127, type: !129, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!140 = !DILocation(line: 0, scope: !141)
!141 = !DILexicalBlockFile(scope: !142, file: !127, discriminator: 0)
!142 = distinct !DILexicalBlock(scope: !139, file: !1, line: 65, column: 7)
!143 = distinct !DISubprogram(name: "u2.modify", linkageName: "$s4main1TV2u2AA1UVvM", scope: !128, file: !127, type: !129, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!144 = !DILocation(line: 0, scope: !145)
!145 = !DILexicalBlockFile(scope: !146, file: !127, discriminator: 0)
!146 = distinct !DILexicalBlock(scope: !143, file: !1, line: 65, column: 7)
!147 = distinct !DISubprogram(name: "u1.get", linkageName: "$s4main1TV13TangentVectorV2u1AA1UVADVvg", scope: !148, file: !127, type: !149, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!148 = !DICompositeType(tag: DW_TAG_structure_type, name: "TangentVector", scope: !128, file: !1, size: 456, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$s4main1TV13TangentVectorVD")
!149 = !DISubroutineType(types: !150)
!150 = !{!151, !148}
!151 = !DICompositeType(tag: DW_TAG_structure_type, name: "TangentVector", scope: !152, file: !1, size: 200, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$s4main1UV13TangentVectorVD")
!152 = !DICompositeType(tag: DW_TAG_structure_type, name: "U", scope: !5, file: !1, size: 200, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$s4main1UVD")
!153 = !DILocation(line: 0, scope: !154)
!154 = distinct !DILexicalBlock(scope: !147, file: !127)
!155 = !DILocation(line: 0, scope: !147)
!156 = distinct !DISubprogram(name: "u1.set", linkageName: "$s4main1TV13TangentVectorV2u1AA1UVADVvs", scope: !148, file: !127, type: !157, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!157 = !DISubroutineType(types: !158)
!158 = !{!131, !151, !148}
!159 = !DILocation(line: 0, scope: !160)
!160 = distinct !DILexicalBlock(scope: !156, file: !127)
!161 = !DILocation(line: 0, scope: !156)
!162 = distinct !DISubprogram(name: "u1.modify", linkageName: "$s4main1TV13TangentVectorV2u1AA1UVADVvM", scope: !148, file: !127, type: !163, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!163 = !DISubroutineType(types: !164)
!164 = !{!131, !148}
!165 = !DILocation(line: 0, scope: !166)
!166 = distinct !DILexicalBlock(scope: !162, file: !127)
!167 = distinct !DISubprogram(name: "u1.modify", linkageName: "$s4main1TV13TangentVectorV2u1AA1UVADVvM", scope: !148, file: !127, type: !163, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!168 = !DILocation(line: 0, scope: !169)
!169 = distinct !DILexicalBlock(scope: !167, file: !127)
!170 = distinct !DISubprogram(name: "u2.get", linkageName: "$s4main1TV13TangentVectorV2u2AA1UVADVvg", scope: !148, file: !127, type: !149, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!171 = !DILocation(line: 0, scope: !172)
!172 = distinct !DILexicalBlock(scope: !170, file: !127)
!173 = !DILocation(line: 0, scope: !170)
!174 = distinct !DISubprogram(name: "u2.set", linkageName: "$s4main1TV13TangentVectorV2u2AA1UVADVvs", scope: !148, file: !127, type: !157, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!175 = !DILocation(line: 0, scope: !176)
!176 = distinct !DILexicalBlock(scope: !174, file: !127)
!177 = !DILocation(line: 0, scope: !174)
!178 = distinct !DISubprogram(name: "u2.modify", linkageName: "$s4main1TV13TangentVectorV2u2AA1UVADVvM", scope: !148, file: !127, type: !163, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!179 = !DILocation(line: 0, scope: !180)
!180 = distinct !DILexicalBlock(scope: !178, file: !127)
!181 = distinct !DISubprogram(name: "u2.modify", linkageName: "$s4main1TV13TangentVectorV2u2AA1UVADVvM", scope: !148, file: !127, type: !163, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!182 = !DILocation(line: 0, scope: !183)
!183 = distinct !DILexicalBlock(scope: !181, file: !127)
!184 = distinct !DISubprogram(name: "init", linkageName: "$s4main1TV13TangentVectorV2u12u2AeA1UVADV_AJtcfC", scope: !148, file: !127, type: !185, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!185 = !DISubroutineType(types: !186)
!186 = !{!148, !151, !151, !187}
!187 = !DICompositeType(tag: DW_TAG_structure_type, name: "$s4main1TV13TangentVectorVXMtD", file: !127, flags: DIFlagArtificial, runtimeLang: DW_LANG_Swift, identifier: "$s4main1TV13TangentVectorVXMtD")
!188 = !DILocation(line: 0, scope: !184)
!189 = distinct !DISubprogram(name: "zeroTangentVectorInitializer.get", linkageName: "$s4main1TV13TangentVectorV04zerobC11InitializerAEycvg", scope: !148, file: !127, type: !190, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!190 = !DISubroutineType(types: !191)
!191 = !{!192, !148}
!192 = !DICompositeType(tag: DW_TAG_structure_type, name: "$s4main1TV13TangentVectorVIegr_D", file: !1, size: 128, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$s4main1TV13TangentVectorVIegr_D")
!193 = !DILocalVariable(name: "self", arg: 1, scope: !194, file: !1, type: !198, flags: DIFlagArtificial)
!194 = distinct !DISubprogram(name: "zeroTangentVectorInitializer.get", linkageName: "$s4main1UV13TangentVectorV04zerobC11InitializerAEycvg", scope: !151, file: !127, type: !195, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!195 = !DISubroutineType(types: !196)
!196 = !{!197, !151}
!197 = !DICompositeType(tag: DW_TAG_structure_type, name: "$s4main1UV13TangentVectorVIego_D", file: !1, size: 128, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$s4main1UV13TangentVectorVIego_D")
!198 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !151)
!199 = !DILocation(line: 0, scope: !194, inlinedAt: !200)
!200 = !DILocation(line: 0, scope: !201)
!201 = distinct !DILexicalBlock(scope: !202, file: !127)
!202 = distinct !DILexicalBlock(scope: !189, file: !127)
!203 = !DILocalVariable(name: "self", arg: 1, scope: !189, file: !1, type: !204, flags: DIFlagArtificial)
!204 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !148)
!205 = !DILocation(line: 0, scope: !189)
!206 = !DILocation(line: 0, scope: !207, inlinedAt: !200)
!207 = distinct !DILexicalBlock(scope: !208, file: !127)
!208 = distinct !DILexicalBlock(scope: !194, file: !127)
!209 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !207, file: !1, type: !210, flags: DIFlagArtificial)
!210 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !211)
!211 = !DICompositeType(tag: DW_TAG_structure_type, name: "$s1M1SVySfGIego_D", file: !1, size: 128, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$s1M1SVySfGIego_D")
!212 = !DILocalVariable(name: "self", arg: 1, scope: !213, file: !1, type: !219, flags: DIFlagArtificial)
!213 = distinct !DISubprogram(name: "zeroTangentVectorInitializer.get", linkageName: "$s4main1VV13TangentVectorV04zerobC11InitializerAEycvg", scope: !214, file: !127, type: !216, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!214 = !DICompositeType(tag: DW_TAG_structure_type, name: "TangentVector", scope: !215, file: !1, size: 72, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$s4main1VV13TangentVectorVD")
!215 = !DICompositeType(tag: DW_TAG_structure_type, name: "V", scope: !5, file: !1, size: 72, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$s4main1VVD")
!216 = !DISubroutineType(types: !217)
!217 = !{!218, !214}
!218 = !DICompositeType(tag: DW_TAG_structure_type, name: "$s4main1VV13TangentVectorVIego_D", file: !1, size: 128, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$s4main1VV13TangentVectorVIego_D")
!219 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !214)
!220 = !DILocation(line: 0, scope: !213, inlinedAt: !206)
!221 = !DILocation(line: 0, scope: !222, inlinedAt: !206)
!222 = distinct !DILexicalBlock(scope: !223, file: !127)
!223 = distinct !DILexicalBlock(scope: !213, file: !127)
!224 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !222, file: !1, type: !210, flags: DIFlagArtificial)
!225 = !DILocalVariable(name: "v_zeroTangentVectorInitializer", scope: !207, file: !1, type: !226, flags: DIFlagArtificial)
!226 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !218)
!227 = !DILocalVariable(name: "u1_zeroTangentVectorInitializer", scope: !201, file: !1, type: !228, flags: DIFlagArtificial)
!228 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !197)
!229 = !DILocation(line: 0, scope: !230, inlinedAt: !200)
!230 = distinct !DILexicalBlock(scope: !231, file: !127)
!231 = distinct !DILexicalBlock(scope: !194, file: !127)
!232 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !230, file: !1, type: !210, flags: DIFlagArtificial)
!233 = !DILocation(line: 0, scope: !213, inlinedAt: !229)
!234 = !DILocation(line: 0, scope: !235, inlinedAt: !229)
!235 = distinct !DILexicalBlock(scope: !236, file: !127)
!236 = distinct !DILexicalBlock(scope: !213, file: !127)
!237 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !235, file: !1, type: !210, flags: DIFlagArtificial)
!238 = !DILocalVariable(name: "v_zeroTangentVectorInitializer", scope: !230, file: !1, type: !226, flags: DIFlagArtificial)
!239 = !DILocalVariable(name: "u2_zeroTangentVectorInitializer", scope: !201, file: !1, type: !228, flags: DIFlagArtificial)
!240 = !DILocation(line: 0, scope: !202)
!241 = !DILocation(line: 0, scope: !194)
!242 = !DILocation(line: 0, scope: !243)
!243 = distinct !DILexicalBlock(scope: !244, file: !127)
!244 = distinct !DILexicalBlock(scope: !194, file: !127)
!245 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !243, file: !1, type: !210, flags: DIFlagArtificial)
!246 = !DILocation(line: 0, scope: !213, inlinedAt: !242)
!247 = !DILocation(line: 0, scope: !248, inlinedAt: !242)
!248 = distinct !DILexicalBlock(scope: !249, file: !127)
!249 = distinct !DILexicalBlock(scope: !213, file: !127)
!250 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !248, file: !1, type: !210, flags: DIFlagArtificial)
!251 = !DILocalVariable(name: "v_zeroTangentVectorInitializer", scope: !243, file: !1, type: !226, flags: DIFlagArtificial)
!252 = !DILocation(line: 0, scope: !244)
!253 = distinct !DISubprogram(name: "zero.get", linkageName: "$s4main1TV13TangentVectorV4zeroAEvgZ", scope: !148, file: !127, type: !254, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!254 = !DISubroutineType(types: !255)
!255 = !{!148, !187}
!256 = !DILocation(line: 0, scope: !257, inlinedAt: !262)
!257 = distinct !DILexicalBlock(scope: !258, file: !127)
!258 = distinct !DISubprogram(name: "zero.get", linkageName: "$s4main1UV13TangentVectorV4zeroAEvgZ", scope: !151, file: !127, type: !259, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!259 = !DISubroutineType(types: !260)
!260 = !{!151, !261}
!261 = !DICompositeType(tag: DW_TAG_structure_type, name: "$s4main1UV13TangentVectorVXMtD", file: !127, flags: DIFlagArtificial, runtimeLang: DW_LANG_Swift, identifier: "$s4main1UV13TangentVectorVXMtD")
!262 = !DILocation(line: 0, scope: !263)
!263 = distinct !DILexicalBlock(scope: !253, file: !127)
!264 = !DILocation(line: 0, scope: !265, inlinedAt: !256)
!265 = distinct !DILexicalBlock(scope: !266, file: !127)
!266 = distinct !DISubprogram(name: "zero.get", linkageName: "$s4main1VV13TangentVectorV4zeroAEvgZ", scope: !214, file: !127, type: !267, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!267 = !DISubroutineType(types: !268)
!268 = !{!214, !269}
!269 = !DICompositeType(tag: DW_TAG_structure_type, name: "$s4main1VV13TangentVectorVXMtD", file: !127, flags: DIFlagArtificial, runtimeLang: DW_LANG_Swift, identifier: "$s4main1VV13TangentVectorVXMtD")
!270 = !DILocation(line: 0, scope: !271, inlinedAt: !262)
!271 = distinct !DILexicalBlock(scope: !258, file: !127)
!272 = !DILocation(line: 0, scope: !273, inlinedAt: !270)
!273 = distinct !DILexicalBlock(scope: !266, file: !127)
!274 = !DILocation(line: 0, scope: !275)
!275 = distinct !DILexicalBlock(scope: !258, file: !127)
!276 = !DILocation(line: 0, scope: !277, inlinedAt: !274)
!277 = distinct !DILexicalBlock(scope: !266, file: !127)
!278 = !DILocalVariable(name: "lhs", arg: 1, scope: !279, file: !1, type: !198, flags: DIFlagArtificial)
!279 = distinct !DISubprogram(name: "+", linkageName: "$s4main1UV13TangentVectorV1poiyA2E_AEtFZ", scope: !151, file: !127, type: !280, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!280 = !DISubroutineType(types: !281)
!281 = !{!151, !151, !151, !261}
!282 = !DILocation(line: 0, scope: !279, inlinedAt: !283)
!283 = !DILocation(line: 0, scope: !284)
!284 = distinct !DILexicalBlock(scope: !285, file: !127)
!285 = distinct !DISubprogram(name: "+", linkageName: "$s4main1TV13TangentVectorV1poiyA2E_AEtFZ", scope: !148, file: !127, type: !286, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!286 = !DISubroutineType(types: !287)
!287 = !{!148, !148, !148, !187}
!288 = !DILocalVariable(name: "rhs", arg: 2, scope: !279, file: !1, type: !198, flags: DIFlagArtificial)
!289 = !DILocalVariable(name: "lhs", arg: 1, scope: !285, file: !1, type: !204, flags: DIFlagArtificial)
!290 = !DILocation(line: 0, scope: !285)
!291 = !DILocalVariable(name: "rhs", arg: 2, scope: !285, file: !1, type: !204, flags: DIFlagArtificial)
!292 = !DILocation(line: 0, scope: !293, inlinedAt: !283)
!293 = distinct !DILexicalBlock(scope: !279, file: !127)
!294 = !DILocalVariable(name: "lhs", arg: 1, scope: !295, file: !1, type: !219, flags: DIFlagArtificial)
!295 = distinct !DISubprogram(name: "+", linkageName: "$s4main1VV13TangentVectorV1poiyA2E_AEtFZ", scope: !214, file: !127, type: !296, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!296 = !DISubroutineType(types: !297)
!297 = !{!214, !214, !214, !269}
!298 = !DILocation(line: 0, scope: !295, inlinedAt: !292)
!299 = !DILocalVariable(name: "rhs", arg: 2, scope: !295, file: !1, type: !219, flags: DIFlagArtificial)
!300 = !DILocation(line: 0, scope: !301, inlinedAt: !292)
!301 = distinct !DILexicalBlock(scope: !295, file: !127)
!302 = !DILocation(line: 0, scope: !303, inlinedAt: !283)
!303 = distinct !DILexicalBlock(scope: !279, file: !127)
!304 = !DILocation(line: 0, scope: !295, inlinedAt: !302)
!305 = !DILocation(line: 0, scope: !306, inlinedAt: !302)
!306 = distinct !DILexicalBlock(scope: !295, file: !127)
!307 = !DILocation(line: 0, scope: !279)
!308 = !DILocation(line: 0, scope: !309)
!309 = distinct !DILexicalBlock(scope: !279, file: !127)
!310 = !DILocation(line: 0, scope: !295, inlinedAt: !308)
!311 = !DILocation(line: 0, scope: !312, inlinedAt: !308)
!312 = distinct !DILexicalBlock(scope: !295, file: !127)
!313 = distinct !DISubprogram(name: "__derived_struct_equals", linkageName: "$s4main1TV13TangentVectorV23__derived_struct_equalsySbAE_AEtFZ", scope: !148, file: !127, type: !314, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!314 = !DISubroutineType(types: !315)
!315 = !{!316, !148, !148, !187}
!316 = !DICompositeType(tag: DW_TAG_structure_type, name: "Bool", scope: !7, file: !317, size: 8, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$sSbD")
!317 = !DIFile(filename: "lib/swift/linux/x86_64/Swift.swiftmodule", directory: "/home/danielzheng/swift-dev/build/Ninja-ReleaseAssert/swift-linux-x86_64")
!318 = !DILocalVariable(name: "a", arg: 1, scope: !319, file: !1, type: !198, flags: DIFlagArtificial)
!319 = distinct !DISubprogram(name: "__derived_struct_equals", linkageName: "$s4main1UV13TangentVectorV23__derived_struct_equalsySbAE_AEtFZ", scope: !151, file: !127, type: !320, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!320 = !DISubroutineType(types: !321)
!321 = !{!316, !151, !151, !261}
!322 = !DILocation(line: 0, scope: !319, inlinedAt: !323)
!323 = !DILocation(line: 0, scope: !324)
!324 = distinct !DILexicalBlock(scope: !313, file: !127)
!325 = !DILocalVariable(name: "b", arg: 2, scope: !319, file: !1, type: !198, flags: DIFlagArtificial)
!326 = !DILocalVariable(name: "a", arg: 1, scope: !313, file: !1, type: !204, flags: DIFlagArtificial)
!327 = !DILocation(line: 0, scope: !313)
!328 = !DILocalVariable(name: "b", arg: 2, scope: !313, file: !1, type: !204, flags: DIFlagArtificial)
!329 = !DILocation(line: 0, scope: !330, inlinedAt: !323)
!330 = distinct !DILexicalBlock(scope: !319, file: !127)
!331 = !DILocalVariable(name: "a", arg: 1, scope: !332, file: !1, type: !219, flags: DIFlagArtificial)
!332 = distinct !DISubprogram(name: "__derived_struct_equals", linkageName: "$s4main1VV13TangentVectorV23__derived_struct_equalsySbAE_AEtFZ", scope: !214, file: !127, type: !333, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!333 = !DISubroutineType(types: !334)
!334 = !{!316, !214, !214, !269}
!335 = !DILocation(line: 0, scope: !332, inlinedAt: !329)
!336 = !DILocalVariable(name: "b", arg: 2, scope: !332, file: !1, type: !219, flags: DIFlagArtificial)
!337 = !DILocation(line: 0, scope: !338, inlinedAt: !329)
!338 = distinct !DILexicalBlock(scope: !332, file: !127)
!339 = !DILocation(line: 0, scope: !340, inlinedAt: !323)
!340 = distinct !DILexicalBlock(scope: !319, file: !127)
!341 = !DILocation(line: 0, scope: !332, inlinedAt: !339)
!342 = !DILocation(line: 0, scope: !343, inlinedAt: !339)
!343 = distinct !DILexicalBlock(scope: !332, file: !127)
!344 = !DILocation(line: 0, scope: !345)
!345 = distinct !DILexicalBlock(scope: !324, file: !127)
!346 = !DILocation(line: 0, scope: !319)
!347 = !DILocation(line: 0, scope: !348)
!348 = distinct !DILexicalBlock(scope: !319, file: !127)
!349 = !DILocation(line: 0, scope: !332, inlinedAt: !347)
!350 = !DILocation(line: 0, scope: !351, inlinedAt: !347)
!351 = distinct !DILexicalBlock(scope: !332, file: !127)
!352 = distinct !DISubprogram(name: "move", linkageName: "$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAafGP4move5alongyADQz_tFTW", scope: !9, file: !127, type: !353, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!353 = !DISubroutineType(types: !354)
!354 = !{!131, !148, !148}
!355 = !DILocation(line: 0, scope: !352)
!356 = distinct !DISubprogram(name: "move", linkageName: "$s16_Differentiation14DifferentiablePAA13TangentVectorACQzRszrlE4move5alongyx_tF", scope: !9, file: !127, type: !357, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!357 = !DISubroutineType(types: !358)
!358 = !{!131, !359, !359}
!359 = !DICompositeType(tag: DW_TAG_structure_type, name: "$sxD", file: !1, runtimeLang: DW_LANG_Swift, identifier: "$sxD")
!360 = !DILocalVariable(name: "$\CF\84_0_0", scope: !356, file: !1, type: !361, flags: DIFlagArtificial)
!361 = !DIDerivedType(tag: DW_TAG_typedef, name: "Self", scope: !362, file: !127, baseType: !363)
!362 = !DIModule(scope: null, name: "Builtin")
!363 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "$sBpD", baseType: null, size: 64)
!364 = !DILocation(line: 0, scope: !356)
!365 = distinct !DISubprogram(name: "zeroTangentVectorInitializer.get", linkageName: "$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAafGP04zerobC11InitializerADQzycvgTW", scope: !148, file: !127, type: !190, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!366 = !DILocation(line: 0, scope: !365)
!367 = !DILocation(line: 0, scope: !368, inlinedAt: !370)
!368 = distinct !DILexicalBlock(scope: !369, file: !127)
!369 = distinct !DILexicalBlock(scope: !194, file: !127)
!370 = !DILocation(line: 0, scope: !371, inlinedAt: !366)
!371 = distinct !DILexicalBlock(scope: !372, file: !127)
!372 = distinct !DILexicalBlock(scope: !189, file: !127)
!373 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !368, file: !1, type: !210, flags: DIFlagArtificial)
!374 = !DILocation(line: 0, scope: !375, inlinedAt: !367)
!375 = distinct !DILexicalBlock(scope: !376, file: !127)
!376 = distinct !DILexicalBlock(scope: !213, file: !127)
!377 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !375, file: !1, type: !210, flags: DIFlagArtificial)
!378 = !DILocalVariable(name: "v_zeroTangentVectorInitializer", scope: !368, file: !1, type: !226, flags: DIFlagArtificial)
!379 = !DILocalVariable(name: "u1_zeroTangentVectorInitializer", scope: !371, file: !1, type: !228, flags: DIFlagArtificial)
!380 = !DILocation(line: 0, scope: !381, inlinedAt: !370)
!381 = distinct !DILexicalBlock(scope: !382, file: !127)
!382 = distinct !DILexicalBlock(scope: !194, file: !127)
!383 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !381, file: !1, type: !210, flags: DIFlagArtificial)
!384 = !DILocation(line: 0, scope: !385, inlinedAt: !380)
!385 = distinct !DILexicalBlock(scope: !386, file: !127)
!386 = distinct !DILexicalBlock(scope: !213, file: !127)
!387 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !385, file: !1, type: !210, flags: DIFlagArtificial)
!388 = !DILocalVariable(name: "v_zeroTangentVectorInitializer", scope: !381, file: !1, type: !226, flags: DIFlagArtificial)
!389 = !DILocalVariable(name: "u2_zeroTangentVectorInitializer", scope: !371, file: !1, type: !228, flags: DIFlagArtificial)
!390 = distinct !DISubprogram(name: "zero.get", linkageName: "$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP4zeroxvgZTW", scope: !148, file: !127, type: !391, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!391 = !DISubroutineType(types: !392)
!392 = !{!148, !393}
!393 = !DICompositeType(tag: DW_TAG_structure_type, name: "$s4main1TV13TangentVectorVXMTD", file: !127, size: 64, flags: DIFlagArtificial, runtimeLang: DW_LANG_Swift, identifier: "$s4main1TV13TangentVectorVXMTD")
!394 = !DILocation(line: 0, scope: !395, inlinedAt: !396)
!395 = distinct !DILexicalBlock(scope: !258, file: !127)
!396 = !DILocation(line: 0, scope: !397, inlinedAt: !398)
!397 = distinct !DILexicalBlock(scope: !253, file: !127)
!398 = !DILocation(line: 0, scope: !390)
!399 = !DILocation(line: 0, scope: !400, inlinedAt: !394)
!400 = distinct !DILexicalBlock(scope: !266, file: !127)
!401 = !DILocation(line: 0, scope: !402, inlinedAt: !396)
!402 = distinct !DILexicalBlock(scope: !258, file: !127)
!403 = !DILocation(line: 0, scope: !404, inlinedAt: !401)
!404 = distinct !DILexicalBlock(scope: !266, file: !127)
!405 = distinct !DISubprogram(name: "+=", linkageName: "$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP2peoiyyxz_xtFZTW", scope: !7, file: !127, type: !406, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!406 = !DISubroutineType(types: !407)
!407 = !{!131, !148, !148, !393}
!408 = !DILocation(line: 0, scope: !405)
!409 = !DILocation(line: 0, scope: !410)
!410 = distinct !DISubprogram(name: "+", linkageName: "$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTW", scope: !148, file: !127, type: !411, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!411 = !DISubroutineType(types: !412)
!412 = !{!148, !148, !148, !393}
!413 = !DILocation(line: 0, scope: !414, inlinedAt: !415)
!414 = distinct !DILexicalBlock(scope: !279, file: !127)
!415 = !DILocation(line: 0, scope: !416, inlinedAt: !409)
!416 = distinct !DILexicalBlock(scope: !285, file: !127)
!417 = !DILocation(line: 0, scope: !418, inlinedAt: !413)
!418 = distinct !DILexicalBlock(scope: !295, file: !127)
!419 = !DILocation(line: 0, scope: !420, inlinedAt: !415)
!420 = distinct !DILexicalBlock(scope: !279, file: !127)
!421 = !DILocation(line: 0, scope: !422, inlinedAt: !419)
!422 = distinct !DILexicalBlock(scope: !295, file: !127)
!423 = distinct !DISubprogram(name: "-=", linkageName: "$s4main1TV13TangentVectorVs18AdditiveArithmeticAAsAFP2seoiyyxz_xtFZTW", scope: !7, file: !127, type: !406, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!424 = !DILocation(line: 0, scope: !423)
!425 = !DILocalVariable(name: "$\CF\84_0_0", scope: !426, file: !1, type: !361, flags: DIFlagArtificial)
!426 = distinct !DISubprogram(name: "+=", linkageName: "$ss18AdditiveArithmeticPsE2peoiyyxz_xtFZ", scope: !7, file: !127, type: !427, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!427 = !DISubroutineType(types: !428)
!428 = !{!131, !359, !359, !429}
!429 = !DICompositeType(tag: DW_TAG_structure_type, name: "$sxXMTD", file: !127, size: 64, flags: DIFlagArtificial, runtimeLang: DW_LANG_Swift, identifier: "$sxXMTD")
!430 = !DILocation(line: 0, scope: !426)
!431 = !{i64 96}
!432 = distinct !DISubprogram(name: "__derived_struct_equals", linkageName: "$s4main1TV13TangentVectorVSQAASQ2eeoiySbx_xtFZTW", scope: !148, file: !127, type: !433, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!433 = !DISubroutineType(types: !434)
!434 = !{!316, !148, !148, !393}
!435 = !DILocation(line: 0, scope: !432)
!436 = !DILocation(line: 0, scope: !437, inlinedAt: !438)
!437 = distinct !DILexicalBlock(scope: !319, file: !127)
!438 = !DILocation(line: 0, scope: !439, inlinedAt: !435)
!439 = distinct !DILexicalBlock(scope: !313, file: !127)
!440 = !DILocation(line: 0, scope: !441, inlinedAt: !436)
!441 = distinct !DILexicalBlock(scope: !332, file: !127)
!442 = !DILocation(line: 0, scope: !443, inlinedAt: !438)
!443 = distinct !DILexicalBlock(scope: !319, file: !127)
!444 = !DILocation(line: 0, scope: !445, inlinedAt: !442)
!445 = distinct !DILexicalBlock(scope: !332, file: !127)
!446 = !DILocation(line: 0, scope: !447, inlinedAt: !435)
!447 = distinct !DILexicalBlock(scope: !439, file: !127)
!448 = distinct !DISubprogram(name: "move", linkageName: "$s4main1TV4move5alongyAC13TangentVectorV_tF", scope: !128, file: !127, type: !449, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!449 = !DISubroutineType(types: !450)
!450 = !{!131, !148, !128}
!451 = !DILocalVariable(name: "direction", arg: 1, scope: !452, file: !1, type: !219, flags: DIFlagArtificial)
!452 = distinct !DISubprogram(name: "move", linkageName: "$s4main1VV4move5alongyAC13TangentVectorV_tF", scope: !215, file: !127, type: !453, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!453 = !DISubroutineType(types: !454)
!454 = !{!131, !214, !215}
!455 = !DILocation(line: 0, scope: !452, inlinedAt: !456)
!456 = !DILocation(line: 0, scope: !457, inlinedAt: !461)
!457 = distinct !DILexicalBlock(scope: !458, file: !127)
!458 = distinct !DISubprogram(name: "move", linkageName: "$s4main1UV4move5alongyAC13TangentVectorV_tF", scope: !152, file: !127, type: !459, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!459 = !DISubroutineType(types: !460)
!460 = !{!131, !151, !152}
!461 = !DILocation(line: 0, scope: !462)
!462 = distinct !DILexicalBlock(scope: !448, file: !127)
!463 = !DILocalVariable(name: "direction", arg: 1, scope: !458, file: !1, type: !198, flags: DIFlagArtificial)
!464 = !DILocation(line: 0, scope: !458, inlinedAt: !461)
!465 = !DILocation(line: 0, scope: !452, inlinedAt: !466)
!466 = !DILocation(line: 0, scope: !467, inlinedAt: !461)
!467 = distinct !DILexicalBlock(scope: !458, file: !127)
!468 = !DILocation(line: 0, scope: !448)
!469 = !DILocalVariable(name: "direction", arg: 1, scope: !448, file: !1, type: !204, flags: DIFlagArtificial)
!470 = !DILocalVariable(name: "self", arg: 2, scope: !448, file: !1, type: !128, flags: DIFlagArtificial)
!471 = !DILocalVariable(name: "self", arg: 2, scope: !458, file: !1, type: !152, flags: DIFlagArtificial)
!472 = !DILocation(line: 0, scope: !473, inlinedAt: !485)
!473 = distinct !DISubprogram(name: "+=", linkageName: "$ss18AdditiveArithmeticPsE2peoiyyxz_xtFZ1M1SVySfG_Tg5", scope: !7, file: !127, type: !474, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!474 = !DISubroutineType(types: !475)
!475 = !{!131, !476, !476, !484}
!476 = !DICompositeType(tag: DW_TAG_structure_type, scope: !11, file: !477, size: 72, elements: !478, runtimeLang: DW_LANG_Swift)
!477 = !DIFile(filename: "Output/sr13263.swift.tmp/M.swiftmodule", directory: "/home/danielzheng/swift-dev/build/Ninja-ReleaseAssert/swift-linux-x86_64/test-linux-x86_64/DebugInfo")
!478 = !{!479}
!479 = !DIDerivedType(tag: DW_TAG_member, scope: !11, file: !477, baseType: !480, size: 72)
!480 = !DICompositeType(tag: DW_TAG_structure_type, name: "S", scope: !11, file: !477, runtimeLang: DW_LANG_Swift, templateParams: !481, identifier: "$s1M1SVySfGD")
!481 = !{!482}
!482 = !DITemplateTypeParameter(type: !483)
!483 = !DICompositeType(tag: DW_TAG_structure_type, name: "$sSfD", scope: !7, flags: DIFlagFwdDecl, runtimeLang: DW_LANG_Swift, identifier: "$sSfD")
!484 = !DICompositeType(tag: DW_TAG_structure_type, name: "$s1M1SVySfGXMTD", file: !127, size: 64, flags: DIFlagArtificial, runtimeLang: DW_LANG_Swift, identifier: "$s1M1SVySfGXMTD")
!485 = !DILocation(line: 0, scope: !486, inlinedAt: !487)
!486 = distinct !DISubprogram(linkageName: "$s1M1SVyxGs18AdditiveArithmeticAAsAEP2peoiyyxz_xtFZTWSf_Tg5", scope: !5, file: !127, type: !474, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!487 = !DILocation(line: 0, scope: !488, inlinedAt: !456)
!488 = distinct !DISubprogram(name: "move", linkageName: "$s16_Differentiation14DifferentiablePAA13TangentVectorACQzRszrlE4move5alongyx_tF1M1SVySfG_Tg5", scope: !9, file: !127, type: !489, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!489 = !DISubroutineType(types: !490)
!490 = !{!131, !476, !476}
!491 = !DILocation(line: 0, scope: !492, inlinedAt: !472)
!492 = distinct !DISubprogram(linkageName: "$s1M1SVyxGs18AdditiveArithmeticAAsAEP1poiyxx_xtFZTWSf_Tg5", scope: !5, file: !127, type: !493, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!493 = !DISubroutineType(types: !494)
!494 = !{!476, !476, !476, !484}
!495 = !DILocalVariable(name: "self", arg: 2, scope: !452, file: !1, type: !215, flags: DIFlagArtificial)
!496 = !DILocation(line: 0, scope: !497, inlinedAt: !456)
!497 = distinct !DILexicalBlock(scope: !452, file: !127)
!498 = !DILocation(line: 0, scope: !473, inlinedAt: !499)
!499 = !DILocation(line: 0, scope: !486, inlinedAt: !500)
!500 = !DILocation(line: 0, scope: !488, inlinedAt: !496)
!501 = !DILocation(line: 0, scope: !492, inlinedAt: !498)
!502 = !DILocation(line: 0, scope: !473, inlinedAt: !503)
!503 = !DILocation(line: 0, scope: !486, inlinedAt: !504)
!504 = !DILocation(line: 0, scope: !488, inlinedAt: !466)
!505 = !DILocation(line: 0, scope: !492, inlinedAt: !502)
!506 = !DILocation(line: 0, scope: !507, inlinedAt: !466)
!507 = distinct !DILexicalBlock(scope: !452, file: !127)
!508 = !DILocation(line: 0, scope: !473, inlinedAt: !509)
!509 = !DILocation(line: 0, scope: !486, inlinedAt: !510)
!510 = !DILocation(line: 0, scope: !488, inlinedAt: !506)
!511 = !DILocation(line: 0, scope: !492, inlinedAt: !508)
!512 = !DILocation(line: 0, scope: !458)
!513 = !DILocation(line: 0, scope: !473, inlinedAt: !514)
!514 = !DILocation(line: 0, scope: !486, inlinedAt: !515)
!515 = !DILocation(line: 0, scope: !488, inlinedAt: !516)
!516 = !DILocation(line: 0, scope: !517)
!517 = distinct !DILexicalBlock(scope: !458, file: !127)
!518 = !DILocation(line: 0, scope: !492, inlinedAt: !513)
!519 = !DILocation(line: 0, scope: !452, inlinedAt: !516)
!520 = !DILocation(line: 0, scope: !473, inlinedAt: !521)
!521 = !DILocation(line: 0, scope: !486, inlinedAt: !522)
!522 = !DILocation(line: 0, scope: !488, inlinedAt: !523)
!523 = !DILocation(line: 0, scope: !524, inlinedAt: !516)
!524 = distinct !DILexicalBlock(scope: !452, file: !127)
!525 = !DILocation(line: 0, scope: !492, inlinedAt: !520)
!526 = distinct !DISubprogram(name: "zeroTangentVectorInitializer.get", linkageName: "$s4main1TV28zeroTangentVectorInitializerAC0cD0Vycvg", scope: !128, file: !127, type: !527, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!527 = !DISubroutineType(types: !528)
!528 = !{!192, !128}
!529 = !DILocalVariable(name: "self", arg: 1, scope: !530, file: !1, type: !533, flags: DIFlagArtificial)
!530 = distinct !DISubprogram(name: "zeroTangentVectorInitializer.get", linkageName: "$s4main1UV28zeroTangentVectorInitializerAC0cD0Vycvg", scope: !152, file: !127, type: !531, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!531 = !DISubroutineType(types: !532)
!532 = !{!197, !152}
!533 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !152)
!534 = !DILocation(line: 0, scope: !530, inlinedAt: !535)
!535 = !DILocation(line: 0, scope: !536)
!536 = distinct !DILexicalBlock(scope: !537, file: !127)
!537 = distinct !DILexicalBlock(scope: !526, file: !127)
!538 = !DILocalVariable(name: "self", arg: 1, scope: !526, file: !1, type: !539, flags: DIFlagArtificial)
!539 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !128)
!540 = !DILocation(line: 0, scope: !526)
!541 = !DILocation(line: 0, scope: !542, inlinedAt: !535)
!542 = distinct !DILexicalBlock(scope: !543, file: !127)
!543 = distinct !DILexicalBlock(scope: !530, file: !127)
!544 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !542, file: !1, type: !210, flags: DIFlagArtificial)
!545 = !DILocalVariable(name: "self", arg: 1, scope: !546, file: !1, type: !549, flags: DIFlagArtificial)
!546 = distinct !DISubprogram(name: "zeroTangentVectorInitializer.get", linkageName: "$s4main1VV28zeroTangentVectorInitializerAC0cD0Vycvg", scope: !215, file: !127, type: !547, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!547 = !DISubroutineType(types: !548)
!548 = !{!218, !215}
!549 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !215)
!550 = !DILocation(line: 0, scope: !546, inlinedAt: !541)
!551 = !DILocation(line: 0, scope: !552, inlinedAt: !541)
!552 = distinct !DILexicalBlock(scope: !553, file: !127)
!553 = distinct !DILexicalBlock(scope: !546, file: !127)
!554 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !552, file: !1, type: !210, flags: DIFlagArtificial)
!555 = !DILocalVariable(name: "v_zeroTangentVectorInitializer", scope: !542, file: !1, type: !226, flags: DIFlagArtificial)
!556 = !DILocalVariable(name: "u1_zeroTangentVectorInitializer", scope: !536, file: !1, type: !228, flags: DIFlagArtificial)
!557 = !DILocation(line: 0, scope: !558, inlinedAt: !535)
!558 = distinct !DILexicalBlock(scope: !559, file: !127)
!559 = distinct !DILexicalBlock(scope: !530, file: !127)
!560 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !558, file: !1, type: !210, flags: DIFlagArtificial)
!561 = !DILocation(line: 0, scope: !546, inlinedAt: !557)
!562 = !DILocation(line: 0, scope: !563, inlinedAt: !557)
!563 = distinct !DILexicalBlock(scope: !564, file: !127)
!564 = distinct !DILexicalBlock(scope: !546, file: !127)
!565 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !563, file: !1, type: !210, flags: DIFlagArtificial)
!566 = !DILocalVariable(name: "v_zeroTangentVectorInitializer", scope: !558, file: !1, type: !226, flags: DIFlagArtificial)
!567 = !DILocalVariable(name: "u2_zeroTangentVectorInitializer", scope: !536, file: !1, type: !228, flags: DIFlagArtificial)
!568 = !DILocation(line: 0, scope: !537)
!569 = !DILocation(line: 0, scope: !530)
!570 = !DILocation(line: 0, scope: !571)
!571 = distinct !DILexicalBlock(scope: !572, file: !127)
!572 = distinct !DILexicalBlock(scope: !530, file: !127)
!573 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !571, file: !1, type: !210, flags: DIFlagArtificial)
!574 = !DILocation(line: 0, scope: !546, inlinedAt: !570)
!575 = !DILocation(line: 0, scope: !576, inlinedAt: !570)
!576 = distinct !DILexicalBlock(scope: !577, file: !127)
!577 = distinct !DILexicalBlock(scope: !546, file: !127)
!578 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !576, file: !1, type: !210, flags: DIFlagArtificial)
!579 = !DILocalVariable(name: "v_zeroTangentVectorInitializer", scope: !571, file: !1, type: !226, flags: DIFlagArtificial)
!580 = !DILocation(line: 0, scope: !572)
!581 = distinct !DISubprogram(name: "move", linkageName: "$s4main1TV16_Differentiation14DifferentiableAadEP4move5alongy13TangentVectorQz_tFTW", scope: !128, file: !127, type: !449, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!582 = !DILocation(line: 0, scope: !581)
!583 = distinct !DISubprogram(name: "zeroTangentVectorInitializer.get", linkageName: "$s4main1TV16_Differentiation14DifferentiableAadEP28zeroTangentVectorInitializer0eF0QzycvgTW", scope: !128, file: !127, type: !527, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!584 = !DILocation(line: 0, scope: !583)
!585 = !DILocation(line: 0, scope: !586, inlinedAt: !588)
!586 = distinct !DILexicalBlock(scope: !587, file: !127)
!587 = distinct !DILexicalBlock(scope: !530, file: !127)
!588 = !DILocation(line: 0, scope: !589, inlinedAt: !584)
!589 = distinct !DILexicalBlock(scope: !590, file: !127)
!590 = distinct !DILexicalBlock(scope: !526, file: !127)
!591 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !586, file: !1, type: !210, flags: DIFlagArtificial)
!592 = !DILocation(line: 0, scope: !593, inlinedAt: !585)
!593 = distinct !DILexicalBlock(scope: !594, file: !127)
!594 = distinct !DILexicalBlock(scope: !546, file: !127)
!595 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !593, file: !1, type: !210, flags: DIFlagArtificial)
!596 = !DILocalVariable(name: "v_zeroTangentVectorInitializer", scope: !586, file: !1, type: !226, flags: DIFlagArtificial)
!597 = !DILocalVariable(name: "u1_zeroTangentVectorInitializer", scope: !589, file: !1, type: !228, flags: DIFlagArtificial)
!598 = !DILocation(line: 0, scope: !599, inlinedAt: !588)
!599 = distinct !DILexicalBlock(scope: !600, file: !127)
!600 = distinct !DILexicalBlock(scope: !530, file: !127)
!601 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !599, file: !1, type: !210, flags: DIFlagArtificial)
!602 = !DILocation(line: 0, scope: !603, inlinedAt: !598)
!603 = distinct !DILexicalBlock(scope: !604, file: !127)
!604 = distinct !DILexicalBlock(scope: !546, file: !127)
!605 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !603, file: !1, type: !210, flags: DIFlagArtificial)
!606 = !DILocalVariable(name: "v_zeroTangentVectorInitializer", scope: !599, file: !1, type: !226, flags: DIFlagArtificial)
!607 = !DILocalVariable(name: "u2_zeroTangentVectorInitializer", scope: !589, file: !1, type: !228, flags: DIFlagArtificial)
!608 = distinct !DISubprogram(name: "s.modify", linkageName: "$s4main1UV1s1M1SVySfGvM", scope: !152, file: !127, type: !609, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!609 = !DISubroutineType(types: !610)
!610 = !{!131, !152}
!611 = !DILocation(line: 0, scope: !612)
!612 = !DILexicalBlockFile(scope: !613, file: !127, discriminator: 0)
!613 = distinct !DILexicalBlock(scope: !608, file: !1, line: 69, column: 7)
!614 = distinct !DISubprogram(name: "s.modify", linkageName: "$s4main1UV1s1M1SVySfGvM", scope: !152, file: !127, type: !609, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!615 = !DILocation(line: 0, scope: !616)
!616 = !DILexicalBlockFile(scope: !617, file: !127, discriminator: 0)
!617 = distinct !DILexicalBlock(scope: !614, file: !1, line: 69, column: 7)
!618 = distinct !DISubprogram(name: "v.modify", linkageName: "$s4main1UV1vAA1VVvM", scope: !152, file: !127, type: !609, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!619 = !DILocation(line: 0, scope: !620)
!620 = !DILexicalBlockFile(scope: !621, file: !127, discriminator: 0)
!621 = distinct !DILexicalBlock(scope: !618, file: !1, line: 70, column: 7)
!622 = distinct !DISubprogram(name: "v.modify", linkageName: "$s4main1UV1vAA1VVvM", scope: !152, file: !127, type: !609, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!623 = !DILocation(line: 0, scope: !624)
!624 = !DILexicalBlockFile(scope: !625, file: !127, discriminator: 0)
!625 = distinct !DILexicalBlock(scope: !622, file: !1, line: 70, column: 7)
!626 = distinct !DISubprogram(name: "s.get", linkageName: "$s4main1UV13TangentVectorV1s1M1SVySfGvg", scope: !151, file: !127, type: !627, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!627 = !DISubroutineType(types: !628)
!628 = !{!476, !151}
!629 = !DILocation(line: 0, scope: !630)
!630 = distinct !DILexicalBlock(scope: !626, file: !127)
!631 = distinct !DISubprogram(name: "s.set", linkageName: "$s4main1UV13TangentVectorV1s1M1SVySfGvs", scope: !151, file: !127, type: !632, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!632 = !DISubroutineType(types: !633)
!633 = !{!131, !476, !151}
!634 = !DILocation(line: 0, scope: !635)
!635 = distinct !DILexicalBlock(scope: !631, file: !127)
!636 = !DILocation(line: 0, scope: !631)
!637 = distinct !DISubprogram(name: "s.modify", linkageName: "$s4main1UV13TangentVectorV1s1M1SVySfGvM", scope: !151, file: !127, type: !638, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!638 = !DISubroutineType(types: !639)
!639 = !{!131, !151}
!640 = !DILocation(line: 0, scope: !641)
!641 = distinct !DILexicalBlock(scope: !637, file: !127)
!642 = distinct !DISubprogram(name: "s.modify", linkageName: "$s4main1UV13TangentVectorV1s1M1SVySfGvM", scope: !151, file: !127, type: !638, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!643 = !DILocation(line: 0, scope: !644)
!644 = distinct !DILexicalBlock(scope: !642, file: !127)
!645 = distinct !DISubprogram(name: "v.get", linkageName: "$s4main1UV13TangentVectorV1vAA1VVADVvg", scope: !151, file: !127, type: !646, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!646 = !DISubroutineType(types: !647)
!647 = !{!214, !151}
!648 = !DILocation(line: 0, scope: !649)
!649 = distinct !DILexicalBlock(scope: !645, file: !127)
!650 = distinct !DISubprogram(name: "v.set", linkageName: "$s4main1UV13TangentVectorV1vAA1VVADVvs", scope: !151, file: !127, type: !651, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!651 = !DISubroutineType(types: !652)
!652 = !{!131, !214, !151}
!653 = !DILocation(line: 0, scope: !654)
!654 = distinct !DILexicalBlock(scope: !650, file: !127)
!655 = !DILocation(line: 0, scope: !650)
!656 = distinct !DISubprogram(name: "v.modify", linkageName: "$s4main1UV13TangentVectorV1vAA1VVADVvM", scope: !151, file: !127, type: !638, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!657 = !DILocation(line: 0, scope: !658)
!658 = distinct !DILexicalBlock(scope: !656, file: !127)
!659 = distinct !DISubprogram(name: "v.modify", linkageName: "$s4main1UV13TangentVectorV1vAA1VVADVvM", scope: !151, file: !127, type: !638, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!660 = !DILocation(line: 0, scope: !661)
!661 = distinct !DILexicalBlock(scope: !659, file: !127)
!662 = distinct !DISubprogram(name: "init", linkageName: "$s4main1UV13TangentVectorV1s1vAE1M1SVySfG_AA1VVADVtcfC", scope: !151, file: !127, type: !663, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!663 = !DISubroutineType(types: !664)
!664 = !{!151, !476, !214, !261}
!665 = !DILocation(line: 0, scope: !662)
!666 = !DILocation(line: 0, scope: !213)
!667 = !DILocation(line: 0, scope: !668)
!668 = distinct !DILexicalBlock(scope: !669, file: !127)
!669 = distinct !DILexicalBlock(scope: !213, file: !127)
!670 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !668, file: !1, type: !210, flags: DIFlagArtificial)
!671 = !DILocation(line: 0, scope: !669)
!672 = !DILocation(line: 0, scope: !673)
!673 = distinct !DILexicalBlock(scope: !266, file: !127)
!674 = !DILocation(line: 0, scope: !295)
!675 = !DILocation(line: 0, scope: !676)
!676 = distinct !DILexicalBlock(scope: !295, file: !127)
!677 = !DILocation(line: 0, scope: !332)
!678 = !DILocation(line: 0, scope: !679)
!679 = distinct !DILexicalBlock(scope: !332, file: !127)
!680 = distinct !DISubprogram(name: "move", linkageName: "$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAafGP4move5alongyADQz_tFTW", scope: !9, file: !127, type: !681, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!681 = !DISubroutineType(types: !682)
!682 = !{!131, !151, !151}
!683 = !DILocation(line: 0, scope: !680)
!684 = distinct !DISubprogram(name: "zeroTangentVectorInitializer.get", linkageName: "$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAafGP04zerobC11InitializerADQzycvgTW", scope: !151, file: !127, type: !685, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!685 = !DISubroutineType(types: !686)
!686 = !{!687, !151}
!687 = !DICompositeType(tag: DW_TAG_structure_type, name: "$s4main1UV13TangentVectorVIegr_D", file: !1, size: 128, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$s4main1UV13TangentVectorVIegr_D")
!688 = !DILocation(line: 0, scope: !684)
!689 = !DILocation(line: 0, scope: !690, inlinedAt: !688)
!690 = distinct !DILexicalBlock(scope: !691, file: !127)
!691 = distinct !DILexicalBlock(scope: !194, file: !127)
!692 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !690, file: !1, type: !210, flags: DIFlagArtificial)
!693 = !DILocation(line: 0, scope: !694, inlinedAt: !689)
!694 = distinct !DILexicalBlock(scope: !695, file: !127)
!695 = distinct !DILexicalBlock(scope: !213, file: !127)
!696 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !694, file: !1, type: !210, flags: DIFlagArtificial)
!697 = !DILocalVariable(name: "v_zeroTangentVectorInitializer", scope: !690, file: !1, type: !226, flags: DIFlagArtificial)
!698 = distinct !DISubprogram(name: "zero.get", linkageName: "$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP4zeroxvgZTW", scope: !151, file: !127, type: !699, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!699 = !DISubroutineType(types: !700)
!700 = !{!151, !701}
!701 = !DICompositeType(tag: DW_TAG_structure_type, name: "$s4main1UV13TangentVectorVXMTD", file: !127, size: 64, flags: DIFlagArtificial, runtimeLang: DW_LANG_Swift, identifier: "$s4main1UV13TangentVectorVXMTD")
!702 = !DILocation(line: 0, scope: !703, inlinedAt: !704)
!703 = distinct !DILexicalBlock(scope: !258, file: !127)
!704 = !DILocation(line: 0, scope: !698)
!705 = !DILocation(line: 0, scope: !706, inlinedAt: !702)
!706 = distinct !DILexicalBlock(scope: !266, file: !127)
!707 = distinct !DISubprogram(name: "+=", linkageName: "$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP2peoiyyxz_xtFZTW", scope: !7, file: !127, type: !708, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!708 = !DISubroutineType(types: !709)
!709 = !{!131, !151, !151, !701}
!710 = !DILocation(line: 0, scope: !707)
!711 = !DILocation(line: 0, scope: !712)
!712 = distinct !DISubprogram(name: "+", linkageName: "$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTW", scope: !151, file: !127, type: !713, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!713 = !DISubroutineType(types: !714)
!714 = !{!151, !151, !151, !701}
!715 = !DILocation(line: 0, scope: !716, inlinedAt: !711)
!716 = distinct !DILexicalBlock(scope: !279, file: !127)
!717 = !DILocation(line: 0, scope: !718, inlinedAt: !715)
!718 = distinct !DILexicalBlock(scope: !295, file: !127)
!719 = distinct !DISubprogram(name: "-=", linkageName: "$s4main1UV13TangentVectorVs18AdditiveArithmeticAAsAFP2seoiyyxz_xtFZTW", scope: !7, file: !127, type: !708, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!720 = !DILocation(line: 0, scope: !719)
!721 = distinct !DISubprogram(name: "__derived_struct_equals", linkageName: "$s4main1UV13TangentVectorVSQAASQ2eeoiySbx_xtFZTW", scope: !151, file: !127, type: !722, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!722 = !DISubroutineType(types: !723)
!723 = !{!316, !151, !151, !701}
!724 = !DILocation(line: 0, scope: !721)
!725 = !DILocation(line: 0, scope: !726, inlinedAt: !724)
!726 = distinct !DILexicalBlock(scope: !319, file: !127)
!727 = !DILocation(line: 0, scope: !728, inlinedAt: !725)
!728 = distinct !DILexicalBlock(scope: !332, file: !127)
!729 = !DILocation(line: 0, scope: !452)
!730 = !DILocation(line: 0, scope: !473, inlinedAt: !731)
!731 = !DILocation(line: 0, scope: !486, inlinedAt: !732)
!732 = !DILocation(line: 0, scope: !488, inlinedAt: !733)
!733 = !DILocation(line: 0, scope: !734)
!734 = distinct !DILexicalBlock(scope: !452, file: !127)
!735 = !DILocation(line: 0, scope: !492, inlinedAt: !730)
!736 = !DILocation(line: 0, scope: !546)
!737 = !DILocation(line: 0, scope: !738)
!738 = distinct !DILexicalBlock(scope: !739, file: !127)
!739 = distinct !DILexicalBlock(scope: !546, file: !127)
!740 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !738, file: !1, type: !210, flags: DIFlagArtificial)
!741 = !DILocation(line: 0, scope: !739)
!742 = distinct !DISubprogram(name: "move", linkageName: "$s4main1UV16_Differentiation14DifferentiableAadEP4move5alongy13TangentVectorQz_tFTW", scope: !152, file: !127, type: !459, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!743 = !DILocation(line: 0, scope: !742)
!744 = !DILocation(line: 0, scope: !458, inlinedAt: !743)
!745 = !DILocation(line: 0, scope: !473, inlinedAt: !746)
!746 = !DILocation(line: 0, scope: !486, inlinedAt: !747)
!747 = !DILocation(line: 0, scope: !488, inlinedAt: !748)
!748 = !DILocation(line: 0, scope: !749, inlinedAt: !743)
!749 = distinct !DILexicalBlock(scope: !458, file: !127)
!750 = !DILocation(line: 0, scope: !492, inlinedAt: !745)
!751 = !DILocation(line: 0, scope: !452, inlinedAt: !748)
!752 = !DILocation(line: 0, scope: !473, inlinedAt: !753)
!753 = !DILocation(line: 0, scope: !486, inlinedAt: !754)
!754 = !DILocation(line: 0, scope: !488, inlinedAt: !755)
!755 = !DILocation(line: 0, scope: !756, inlinedAt: !748)
!756 = distinct !DILexicalBlock(scope: !452, file: !127)
!757 = !DILocation(line: 0, scope: !492, inlinedAt: !752)
!758 = distinct !DISubprogram(name: "zeroTangentVectorInitializer.get", linkageName: "$s4main1UV16_Differentiation14DifferentiableAadEP28zeroTangentVectorInitializer0eF0QzycvgTW", scope: !152, file: !127, type: !759, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!759 = !DISubroutineType(types: !760)
!760 = !{!687, !152}
!761 = !DILocation(line: 0, scope: !758)
!762 = !DILocation(line: 0, scope: !763, inlinedAt: !761)
!763 = distinct !DILexicalBlock(scope: !764, file: !127)
!764 = distinct !DILexicalBlock(scope: !530, file: !127)
!765 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !763, file: !1, type: !210, flags: DIFlagArtificial)
!766 = !DILocation(line: 0, scope: !767, inlinedAt: !762)
!767 = distinct !DILexicalBlock(scope: !768, file: !127)
!768 = distinct !DILexicalBlock(scope: !546, file: !127)
!769 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !767, file: !1, type: !210, flags: DIFlagArtificial)
!770 = !DILocalVariable(name: "v_zeroTangentVectorInitializer", scope: !763, file: !1, type: !226, flags: DIFlagArtificial)
!771 = distinct !DISubprogram(name: "s.modify", linkageName: "$s4main1VV1s1M1SVySfGvM", scope: !215, file: !127, type: !772, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!772 = !DISubroutineType(types: !773)
!773 = !{!131, !215}
!774 = !DILocation(line: 0, scope: !775)
!775 = !DILexicalBlockFile(scope: !776, file: !127, discriminator: 0)
!776 = distinct !DILexicalBlock(scope: !771, file: !1, line: 74, column: 7)
!777 = distinct !DISubprogram(name: "s.modify", linkageName: "$s4main1VV1s1M1SVySfGvM", scope: !215, file: !127, type: !772, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!778 = !DILocation(line: 0, scope: !779)
!779 = !DILexicalBlockFile(scope: !780, file: !127, discriminator: 0)
!780 = distinct !DILexicalBlock(scope: !777, file: !1, line: 74, column: 7)
!781 = distinct !DISubprogram(name: "s.get", linkageName: "$s4main1VV13TangentVectorV1s1M1SVySfGvg", scope: !214, file: !127, type: !782, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!782 = !DISubroutineType(types: !783)
!783 = !{!476, !214}
!784 = !DILocation(line: 0, scope: !785)
!785 = distinct !DILexicalBlock(scope: !781, file: !127)
!786 = distinct !DISubprogram(name: "s.set", linkageName: "$s4main1VV13TangentVectorV1s1M1SVySfGvs", scope: !214, file: !127, type: !787, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!787 = !DISubroutineType(types: !788)
!788 = !{!131, !476, !214}
!789 = !DILocation(line: 0, scope: !790)
!790 = distinct !DILexicalBlock(scope: !786, file: !127)
!791 = !DILocation(line: 0, scope: !786)
!792 = distinct !DISubprogram(name: "s.modify", linkageName: "$s4main1VV13TangentVectorV1s1M1SVySfGvM", scope: !214, file: !127, type: !793, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!793 = !DISubroutineType(types: !794)
!794 = !{!131, !214}
!795 = !DILocation(line: 0, scope: !796)
!796 = distinct !DILexicalBlock(scope: !792, file: !127)
!797 = distinct !DISubprogram(name: "s.modify", linkageName: "$s4main1VV13TangentVectorV1s1M1SVySfGvM", scope: !214, file: !127, type: !793, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!798 = !DILocation(line: 0, scope: !799)
!799 = distinct !DILexicalBlock(scope: !797, file: !127)
!800 = distinct !DISubprogram(name: "init", linkageName: "$s4main1VV13TangentVectorV1sAE1M1SVySfG_tcfC", scope: !214, file: !127, type: !801, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!801 = !DISubroutineType(types: !802)
!802 = !{!214, !476, !269}
!803 = !DILocation(line: 0, scope: !800)
!804 = distinct !DISubprogram(linkageName: "objectdestroy", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!805 = !DISubroutineType(types: null)
!806 = !DILocation(line: 0, scope: !804)
!807 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!808 = !DILocation(line: 0, scope: !807)
!809 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", arg: 1, scope: !810, file: !1, type: !210, flags: DIFlagArtificial)
!810 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_", scope: !213, file: !127, type: !811, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!811 = !DISubroutineType(types: !812)
!812 = !{!214, !211}
!813 = !DILocation(line: 0, scope: !810, inlinedAt: !814)
!814 = distinct !DILocation(line: 0, scope: !807)
!815 = !DILocation(line: 0, scope: !816, inlinedAt: !814)
!816 = distinct !DILexicalBlock(scope: !810, file: !127)
!817 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!818 = !DILocation(line: 0, scope: !817)
!819 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", arg: 1, scope: !820, file: !1, type: !210, flags: DIFlagArtificial)
!820 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_", scope: !194, file: !127, type: !821, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!821 = !DISubroutineType(types: !822)
!822 = !{!151, !211, !218}
!823 = !DILocation(line: 0, scope: !820, inlinedAt: !824)
!824 = distinct !DILocation(line: 0, scope: !817)
!825 = !DILocalVariable(name: "v_zeroTangentVectorInitializer", arg: 2, scope: !820, file: !1, type: !226, flags: DIFlagArtificial)
!826 = !DILocation(line: 0, scope: !827, inlinedAt: !824)
!827 = distinct !DILexicalBlock(scope: !820, file: !127)
!828 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_TA", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!829 = !DILocation(line: 0, scope: !828)
!830 = !DILocalVariable(name: "u1_zeroTangentVectorInitializer", arg: 1, scope: !831, file: !1, type: !228, flags: DIFlagArtificial)
!831 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_", scope: !189, file: !127, type: !832, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!832 = !DISubroutineType(types: !833)
!833 = !{!148, !197, !197}
!834 = !DILocation(line: 0, scope: !831, inlinedAt: !835)
!835 = distinct !DILocation(line: 0, scope: !828)
!836 = !DILocalVariable(name: "u2_zeroTangentVectorInitializer", arg: 2, scope: !831, file: !1, type: !228, flags: DIFlagArtificial)
!837 = !DILocation(line: 0, scope: !838, inlinedAt: !835)
!838 = distinct !DILexicalBlock(scope: !831, file: !127)
!839 = !{!840}
!840 = distinct !{!840, !841, !"$s4main1TV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_: argument 0"}
!841 = distinct !{!841, !"$s4main1TV13TangentVectorV04zerobC11InitializerAEycvgAEycfU_"}
!842 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorVWOs", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!843 = !DILocation(line: 0, scope: !842)
!844 = distinct !DISubprogram(name: "move", linkageName: "$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAafGP4move5alongyADQz_tFTW", scope: !9, file: !127, type: !845, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!845 = !DISubroutineType(types: !846)
!846 = !{!131, !214, !214}
!847 = !DILocation(line: 0, scope: !844)
!848 = distinct !DISubprogram(name: "zeroTangentVectorInitializer.get", linkageName: "$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAafGP04zerobC11InitializerADQzycvgTW", scope: !214, file: !127, type: !849, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!849 = !DISubroutineType(types: !850)
!850 = !{!851, !214}
!851 = !DICompositeType(tag: DW_TAG_structure_type, name: "$s4main1VV13TangentVectorVIegr_D", file: !1, size: 128, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$s4main1VV13TangentVectorVIegr_D")
!852 = !DILocation(line: 0, scope: !848)
!853 = !DILocation(line: 0, scope: !854, inlinedAt: !852)
!854 = distinct !DILexicalBlock(scope: !855, file: !127)
!855 = distinct !DILexicalBlock(scope: !213, file: !127)
!856 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !854, file: !1, type: !210, flags: DIFlagArtificial)
!857 = distinct !DISubprogram(name: "zero.get", linkageName: "$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP4zeroxvgZTW", scope: !214, file: !127, type: !858, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!858 = !DISubroutineType(types: !859)
!859 = !{!214, !860}
!860 = !DICompositeType(tag: DW_TAG_structure_type, name: "$s4main1VV13TangentVectorVXMTD", file: !127, size: 64, flags: DIFlagArtificial, runtimeLang: DW_LANG_Swift, identifier: "$s4main1VV13TangentVectorVXMTD")
!861 = !DILocation(line: 0, scope: !862, inlinedAt: !863)
!862 = distinct !DILexicalBlock(scope: !266, file: !127)
!863 = !DILocation(line: 0, scope: !857)
!864 = distinct !DISubprogram(name: "+=", linkageName: "$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP2peoiyyxz_xtFZTW", scope: !7, file: !127, type: !865, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!865 = !DISubroutineType(types: !866)
!866 = !{!131, !214, !214, !860}
!867 = !DILocation(line: 0, scope: !864)
!868 = !DILocation(line: 0, scope: !869)
!869 = distinct !DISubprogram(name: "+", linkageName: "$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP1poiyxx_xtFZTW", scope: !214, file: !127, type: !870, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!870 = !DISubroutineType(types: !871)
!871 = !{!214, !214, !214, !860}
!872 = !DILocation(line: 0, scope: !873, inlinedAt: !868)
!873 = distinct !DILexicalBlock(scope: !295, file: !127)
!874 = distinct !DISubprogram(name: "-=", linkageName: "$s4main1VV13TangentVectorVs18AdditiveArithmeticAAsAFP2seoiyyxz_xtFZTW", scope: !7, file: !127, type: !865, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!875 = !DILocation(line: 0, scope: !874)
!876 = distinct !DISubprogram(name: "__derived_struct_equals", linkageName: "$s4main1VV13TangentVectorVSQAASQ2eeoiySbx_xtFZTW", scope: !214, file: !127, type: !877, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!877 = !DISubroutineType(types: !878)
!878 = !{!316, !214, !214, !860}
!879 = !DILocation(line: 0, scope: !876)
!880 = !DILocation(line: 0, scope: !881, inlinedAt: !879)
!881 = distinct !DILexicalBlock(scope: !332, file: !127)
!882 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmeticPWT", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!883 = !DILocation(line: 0, scope: !882)
!884 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorVAEs18AdditiveArithmeticAAWl", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!885 = !DILocation(line: 0, scope: !884)
!886 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AHWT", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!887 = !DILocation(line: 0, scope: !886)
!888 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorVAE16_Differentiation14DifferentiableAAWl", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!889 = !DILocation(line: 0, scope: !888)
!890 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorVs18AdditiveArithmeticAASQWb", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!891 = !DILocation(line: 0, scope: !890)
!892 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorVAESQAAWl", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!893 = !DILocation(line: 0, scope: !892)
!894 = distinct !DISubprogram(linkageName: "$s4main1TV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmeticPWT", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!895 = !DILocation(line: 0, scope: !894)
!896 = distinct !DISubprogram(linkageName: "$s4main1TV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AGWT", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!897 = !DILocation(line: 0, scope: !896)
!898 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmeticPWT", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!899 = !DILocation(line: 0, scope: !898)
!900 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorVAEs18AdditiveArithmeticAAWl", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!901 = !DILocation(line: 0, scope: !900)
!902 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AHWT", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!903 = !DILocation(line: 0, scope: !902)
!904 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorVAE16_Differentiation14DifferentiableAAWl", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!905 = !DILocation(line: 0, scope: !904)
!906 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorVs18AdditiveArithmeticAASQWb", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!907 = !DILocation(line: 0, scope: !906)
!908 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorVAESQAAWl", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!909 = !DILocation(line: 0, scope: !908)
!910 = distinct !DISubprogram(linkageName: "$s4main1UV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmeticPWT", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!911 = !DILocation(line: 0, scope: !910)
!912 = distinct !DISubprogram(linkageName: "$s4main1UV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AGWT", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!913 = !DILocation(line: 0, scope: !912)
!914 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAadfGP_s18AdditiveArithmeticPWT", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!915 = !DILocation(line: 0, scope: !914)
!916 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorVAEs18AdditiveArithmeticAAWl", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!917 = !DILocation(line: 0, scope: !916)
!918 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorV16_Differentiation14DifferentiableAadfGP_AHWT", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!919 = !DILocation(line: 0, scope: !918)
!920 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorVAE16_Differentiation14DifferentiableAAWl", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!921 = !DILocation(line: 0, scope: !920)
!922 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorVs18AdditiveArithmeticAASQWb", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!923 = !DILocation(line: 0, scope: !922)
!924 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorVAESQAAWl", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!925 = !DILocation(line: 0, scope: !924)
!926 = distinct !DISubprogram(linkageName: "$s4main1VV16_Differentiation14DifferentiableAA13TangentVectorAdEP_s18AdditiveArithmeticPWT", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!927 = !DILocation(line: 0, scope: !926)
!928 = distinct !DISubprogram(linkageName: "$s4main1VV16_Differentiation14DifferentiableAA13TangentVectorAdEP_AGWT", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!929 = !DILocation(line: 0, scope: !928)
!930 = distinct !DISubprogram(name: "move", linkageName: "$s4main1VV16_Differentiation14DifferentiableAadEP4move5alongy13TangentVectorQz_tFTW", scope: !215, file: !127, type: !453, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!931 = !DILocation(line: 0, scope: !930)
!932 = !DILocation(line: 0, scope: !452, inlinedAt: !931)
!933 = !DILocation(line: 0, scope: !473, inlinedAt: !934)
!934 = !DILocation(line: 0, scope: !486, inlinedAt: !935)
!935 = !DILocation(line: 0, scope: !488, inlinedAt: !936)
!936 = !DILocation(line: 0, scope: !937, inlinedAt: !931)
!937 = distinct !DILexicalBlock(scope: !452, file: !127)
!938 = !DILocation(line: 0, scope: !492, inlinedAt: !933)
!939 = distinct !DISubprogram(name: "zeroTangentVectorInitializer.get", linkageName: "$s4main1VV16_Differentiation14DifferentiableAadEP28zeroTangentVectorInitializer0eF0QzycvgTW", scope: !215, file: !127, type: !940, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!940 = !DISubroutineType(types: !941)
!941 = !{!851, !215}
!942 = !DILocation(line: 0, scope: !939)
!943 = !DILocation(line: 0, scope: !944, inlinedAt: !942)
!944 = distinct !DILexicalBlock(scope: !945, file: !127)
!945 = distinct !DILexicalBlock(scope: !546, file: !127)
!946 = !DILocalVariable(name: "s_zeroTangentVectorInitializer", scope: !944, file: !1, type: !210, flags: DIFlagArtificial)
!947 = distinct !DISubprogram(linkageName: "__swift_memcpy57_8", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!948 = !DILocation(line: 0, scope: !947)
!949 = distinct !DISubprogram(linkageName: "$s4main1TVMa", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!950 = !DILocation(line: 0, scope: !949)
!951 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorVwCP", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!952 = !DILocation(line: 0, scope: !951)
!953 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorVwxx", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!954 = !DILocation(line: 0, scope: !953)
!955 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorVwcp", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!956 = !DILocation(line: 0, scope: !955)
!957 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorVwca", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!958 = !DILocation(line: 0, scope: !957)
!959 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorVwta", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!960 = !DILocation(line: 0, scope: !959)
!961 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorVwet", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!962 = !DILocation(line: 0, scope: !961)
!963 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorVwst", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!964 = !DILocation(line: 0, scope: !963)
!965 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorVMa", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!966 = !DILocation(line: 0, scope: !965)
!967 = distinct !DISubprogram(linkageName: "__swift_memcpy25_8", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!968 = !DILocation(line: 0, scope: !967)
!969 = distinct !DISubprogram(linkageName: "$s4main1UVMa", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!970 = !DILocation(line: 0, scope: !969)
!971 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorVwxx", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!972 = !DILocation(line: 0, scope: !971)
!973 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorVwcp", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!974 = !DILocation(line: 0, scope: !973)
!975 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorVwca", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!976 = !DILocation(line: 0, scope: !975)
!977 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorVwta", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!978 = !DILocation(line: 0, scope: !977)
!979 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorVwet", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!980 = !DILocation(line: 0, scope: !979)
!981 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorVwst", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!982 = !DILocation(line: 0, scope: !981)
!983 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorVMa", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!984 = !DILocation(line: 0, scope: !983)
!985 = distinct !DISubprogram(linkageName: "__swift_memcpy9_8", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!986 = !DILocation(line: 0, scope: !985)
!987 = distinct !DISubprogram(linkageName: "$s4main1VVMa", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!988 = !DILocation(line: 0, scope: !987)
!989 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorVwCP", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!990 = !DILocation(line: 0, scope: !989)
!991 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorVwxx", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!992 = !DILocation(line: 0, scope: !991)
!993 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorVwcp", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!994 = !DILocation(line: 0, scope: !993)
!995 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorVwca", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!996 = !DILocation(line: 0, scope: !995)
!997 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorVwta", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!998 = !DILocation(line: 0, scope: !997)
!999 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorVwet", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!1000 = !DILocation(line: 0, scope: !999)
!1001 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorVwst", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!1002 = !DILocation(line: 0, scope: !1001)
!1003 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorVMa", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!1004 = !DILocation(line: 0, scope: !1003)
!1005 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorVIego_AEIegr_TRTA", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!1006 = !DILocation(line: 0, scope: !1005)
!1007 = !DILocation(line: 0, scope: !1008, inlinedAt: !1011)
!1008 = distinct !DISubprogram(linkageName: "$s4main1VV13TangentVectorVIego_AEIegr_TR", scope: !5, file: !127, type: !1009, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!1009 = !DISubroutineType(types: !1010)
!1010 = !{!214, !218}
!1011 = distinct !DILocation(line: 0, scope: !1005)
!1012 = !{!1013}
!1013 = distinct !{!1013, !1014, !"$s4main1VV13TangentVectorVIego_AEIegr_TR: argument 0"}
!1014 = distinct !{!1014, !"$s4main1VV13TangentVectorVIego_AEIegr_TR"}
!1015 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorVIego_AEIegr_TRTA", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!1016 = !DILocation(line: 0, scope: !1015)
!1017 = !DILocation(line: 0, scope: !1018, inlinedAt: !1021)
!1018 = distinct !DISubprogram(linkageName: "$s4main1UV13TangentVectorVIego_AEIegr_TR", scope: !5, file: !127, type: !1019, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!1019 = !DISubroutineType(types: !1020)
!1020 = !{!151, !197}
!1021 = distinct !DILocation(line: 0, scope: !1015)
!1022 = !{!1023}
!1023 = distinct !{!1023, !1024, !"$s4main1UV13TangentVectorVIego_AEIegr_TR: argument 0"}
!1024 = distinct !{!1024, !"$s4main1UV13TangentVectorVIego_AEIegr_TR"}
!1025 = distinct !DISubprogram(linkageName: "objectdestroy.107", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!1026 = !DILocation(line: 0, scope: !1025)
!1027 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorVIego_AEIegr_TRTA", scope: !5, file: !127, type: !805, flags: DIFlagArtificial, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!1028 = !DILocation(line: 0, scope: !1027)
!1029 = !DILocation(line: 0, scope: !1030, inlinedAt: !1033)
!1030 = distinct !DISubprogram(linkageName: "$s4main1TV13TangentVectorVIego_AEIegr_TR", scope: !5, file: !127, type: !1031, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!1031 = !DISubroutineType(types: !1032)
!1032 = !{!148, !192}
!1033 = distinct !DILocation(line: 0, scope: !1027)
!1034 = !{!1035}
!1035 = distinct !{!1035, !1036, !"$s4main1TV13TangentVectorVIego_AEIegr_TR: argument 0"}
!1036 = distinct !{!1036, !"$s4main1TV13TangentVectorVIego_AEIegr_TR"}
