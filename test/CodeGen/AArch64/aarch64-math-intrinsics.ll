; RUN: llc -O2 -mtriple=aarch64-unknown-linux-gnu < %s | FileCheck %s
; RUN: llc -O2 -mtriple=aarch64-unknown-linux-gnu --fp-contract=fast < %s | FileCheck %s
; RUN: llc -O2 -mtriple=aarch64-unknown-linux-gnu --enable-no-infs-fp-math --enable-no-nans-fp-math < %s | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"


declare double @acos(double) #0
declare float @acosf(float) #0
declare double @llvm.acos.f64(double) #0
declare float @llvm.acos.f32(float) #0

define void @acos_f64(double %x) {
  ; CHECK-LABEL: acos_f64:
  ; CHECK: mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      acos
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      acos
  ; CHECK:  ret
  ;
  entry:
    %0 = call double @acos(double %x)
    %1 = call double @llvm.acos.f64(double %x)
    ret void
}

define void @acos_f32(float %x) {
  ; CHECK-LABEL: acos_f32:
  ; CHECK:  mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      acosf
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      acosf
  ; CHECK:  ret
  ;
  entry:
    %0 = call float @acosf(float %x)
    %1 = call float @llvm.acos.f32(float %x)
    ret void
}

declare double @acosh(double) #0
declare float @acoshf(float) #0
declare double @llvm.acosh.f64(double) #0
declare float @llvm.acosh.f32(float) #0

define void @acosh_f64(double %x) {
  ; CHECK-LABEL: acosh_f64:
  ; CHECK: mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      acosh
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      acosh
  ; CHECK:  ret
  ;
  entry:
    %0 = call double @acosh(double %x)
    %1 = call double @llvm.acosh.f64(double %x)
    ret void
}

define void @acosh_f32(float %x) {
  ; CHECK-LABEL: acosh_f32:
  ; CHECK:  mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      acoshf
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      acoshf
  ; CHECK:  ret
  ;
  entry:
    %0 = call float @acoshf(float %x)
    %1 = call float @llvm.acosh.f32(float %x)
    ret void
}

declare double @asin(double) #0
declare float @asinf(float) #0
declare double @llvm.asin.f64(double) #0
declare float @llvm.asin.f32(float) #0

define void @asin_f64(double %x) {
  ; CHECK-LABEL: asin_f64:
  ; CHECK: mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      asin
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      asin
  ; CHECK:  ret
  ;
  entry:
    %0 = call double @asin(double %x)
    %1 = call double @llvm.asin.f64(double %x)
    ret void
}

define void @asin_f32(float %x) {
  ; CHECK-LABEL: asin_f32:
  ; CHECK:  mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      asinf
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      asinf
  ; CHECK:  ret
  ;
  entry:
    %0 = call float @asinf(float %x)
    %1 = call float @llvm.asin.f32(float %x)
    ret void
}

declare double @asinh(double) #0
declare float @asinhf(float) #0
declare double @llvm.asinh.f64(double) #0
declare float @llvm.asinh.f32(float) #0

define void @asinh_f64(double %x) {
  ; CHECK-LABEL: asinh_f64:
  ; CHECK: mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      asinh
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      asinh
  ; CHECK:  ret
  ;
  entry:
    %0 = call double @asinh(double %x)
    %1 = call double @llvm.asinh.f64(double %x)
    ret void
}

define void @asinh_f32(float %x) {
  ; CHECK-LABEL: asinh_f32:
  ; CHECK:  mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      asinhf
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      asinhf
  ; CHECK:  ret
  ;
  entry:
    %0 = call float @asinhf(float %x)
    %1 = call float @llvm.asinh.f32(float %x)
    ret void
}

declare double @atan(double) #0
declare float @atanf(float) #0
declare double @llvm.atan.f64(double) #0
declare float @llvm.atan.f32(float) #0

define void @atan_f64(double %x) {
  ; CHECK-LABEL: atan_f64:
  ; CHECK: mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      atan
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      atan
  ; CHECK:  ret
  ;
  entry:
    %0 = call double @atan(double %x)
    %1 = call double @llvm.atan.f64(double %x)
    ret void
}

define void @atan_f32(float %x) {
  ; CHECK-LABEL: atan_f32:
  ; CHECK:  mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      atanf
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      atanf
  ; CHECK:  ret
  ;
  entry:
    %0 = call float @atanf(float %x)
    %1 = call float @llvm.atan.f32(float %x)
    ret void
}

declare double @atanh(double) #0
declare float @atanhf(float) #0
declare double @llvm.atanh.f64(double) #0
declare float @llvm.atanh.f32(float) #0

define void @atanh_f64(double %x) {
  ; CHECK-LABEL: atanh_f64:
  ; CHECK: mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      atanh
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      atanh
  ; CHECK:  ret
  ;
  entry:
    %0 = call double @atanh(double %x)
    %1 = call double @llvm.atanh.f64(double %x)
    ret void
}

define void @atanh_f32(float %x) {
  ; CHECK-LABEL: atanh_f32:
  ; CHECK:  mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      atanhf
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      atanhf
  ; CHECK:  ret
  ;
  entry:
    %0 = call float @atanhf(float %x)
    %1 = call float @llvm.atanh.f32(float %x)
    ret void
}

declare double @cosh(double) #0
declare float @coshf(float) #0
declare double @llvm.cosh.f64(double) #0
declare float @llvm.cosh.f32(float) #0

define void @cosh_f64(double %x) {
  ; CHECK-LABEL: cosh_f64:
  ; CHECK: mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      cosh
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      cosh
  ; CHECK:  ret
  ;
  entry:
    %0 = call double @cosh(double %x)
    %1 = call double @llvm.cosh.f64(double %x)
    ret void
}

define void @cosh_f32(float %x) {
  ; CHECK-LABEL: cosh_f32:
  ; CHECK:  mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      coshf
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      coshf
  ; CHECK:  ret
  ;
  entry:
    %0 = call float @coshf(float %x)
    %1 = call float @llvm.cosh.f32(float %x)
    ret void
}

declare double @exp10(double) #0
declare float @exp10f(float) #0
declare double @llvm.exp10.f64(double) #0
declare float @llvm.exp10.f32(float) #0

define void @exp10_f64(double %x) {
  ; CHECK-LABEL: exp10_f64:
  ; CHECK: mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      exp10
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      exp10
  ; CHECK:  ret
  ;
  entry:
    %0 = call double @exp10(double %x)
    %1 = call double @llvm.exp10.f64(double %x)
    ret void
}

define void @exp10_f32(float %x) {
  ; CHECK-LABEL: exp10_f32:
  ; CHECK:  mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      exp10f
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      exp10f
  ; CHECK:  ret
  ;
  entry:
    %0 = call float @exp10f(float %x)
    %1 = call float @llvm.exp10.f32(float %x)
    ret void
}

declare double @sinh(double) #0
declare float @sinhf(float) #0
declare double @llvm.sinh.f64(double) #0
declare float @llvm.sinh.f32(float) #0

define void @sinh_f64(double %x) {
  ; CHECK-LABEL: sinh_f64:
  ; CHECK: mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      sinh
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      sinh
  ; CHECK:  ret
  ;
  entry:
    %0 = call double @sinh(double %x)
    %1 = call double @llvm.sinh.f64(double %x)
    ret void
}

define void @sinh_f32(float %x) {
  ; CHECK-LABEL: sinh_f32:
  ; CHECK:  mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      sinhf
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      sinhf
  ; CHECK:  ret
  ;
  entry:
    %0 = call float @sinhf(float %x)
    %1 = call float @llvm.sinh.f32(float %x)
    ret void
}

declare double @tan(double) #0
declare float @tanf(float) #0
declare double @llvm.tan.f64(double) #0
declare float @llvm.tan.f32(float) #0

define void @tan_f64(double %x) {
  ; CHECK-LABEL: tan_f64:
  ; CHECK: mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      tan
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      tan
  ; CHECK:  ret
  ;
  entry:
    %0 = call double @tan(double %x)
    %1 = call double @llvm.tan.f64(double %x)
    ret void
}

define void @tan_f32(float %x) {
  ; CHECK-LABEL: tan_f32:
  ; CHECK:  mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      tanf
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      tanf
  ; CHECK:  ret
  ;
  entry:
    %0 = call float @tanf(float %x)
    %1 = call float @llvm.tan.f32(float %x)
    ret void
}

declare double @tanh(double) #0
declare float @tanhf(float) #0
declare double @llvm.tanh.f64(double) #0
declare float @llvm.tanh.f32(float) #0

define void @tanh_f64(double %x) {
  ; CHECK-LABEL: tanh_f64:
  ; CHECK: mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      tanh
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      tanh
  ; CHECK:  ret
  ;
  entry:
    %0 = call double @tanh(double %x)
    %1 = call double @llvm.tanh.f64(double %x)
    ret void
}

define void @tanh_f32(float %x) {
  ; CHECK-LABEL: tanh_f32:
  ; CHECK:  mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      tanhf
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      tanhf
  ; CHECK:  ret
  ;
  entry:
    %0 = call float @tanhf(float %x)
    %1 = call float @llvm.tanh.f32(float %x)
    ret void
}

declare double @lgamma(double) #0
declare float @lgammaf(float) #0
declare double @llvm.lgamma.f64(double) #0
declare float @llvm.lgamma.f32(float) #0

define void @lgamma_f64(double %x) {
  ; CHECK-LABEL: lgamma_f64:
  ; CHECK: mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      lgamma
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      lgamma
  ; CHECK:  ret
  ;
  entry:
    %0 = call double @lgamma(double %x)
    %1 = call double @llvm.lgamma.f64(double %x)
    ret void
}

define void @lgamma_f32(float %x) {
  ; CHECK-LABEL: lgamma_f32:
  ; CHECK:  mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      lgammaf
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      lgammaf
  ; CHECK:  ret
  ;
  entry:
    %0 = call float @lgammaf(float %x)
    %1 = call float @llvm.lgamma.f32(float %x)
    ret void
}

declare double @tgamma(double) #0
declare float @tgammaf(float) #0
declare double @llvm.tgamma.f64(double) #0
declare float @llvm.tgamma.f32(float) #0

define void @tgamma_f64(double %x) {
  ; CHECK-LABEL: tgamma_f64:
  ; CHECK: mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      tgamma
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      tgamma
  ; CHECK:  ret
  ;
  entry:
    %0 = call double @tgamma(double %x)
    %1 = call double @llvm.tgamma.f64(double %x)
    ret void
}

define void @tgamma_f32(float %x) {
  ; CHECK-LABEL: tgamma_f32:
  ; CHECK:  mov     v8.16b, v0.16b
  ; CHECK-NEXT:  bl      tgammaf
  ; CHECK-NEXT:  mov     v0.16b, v8.16b
  ; CHECK-NEXT:  bl      tgammaf
  ; CHECK:  ret
  ;
  entry:
    %0 = call float @tgammaf(float %x)
    %1 = call float @llvm.tgamma.f32(float %x)
    ret void
}

declare double @atan2(double, double) #0
declare float @atan2f(float, float) #0
declare double @llvm.atan2.f64(double, double) #0
declare float @llvm.atan2.f32(float, float) #0

define void @atan2_f64(double %x, double %y) {
  ; CHECK-LABEL: atan2_f64:
  ; CHECK:  mov     v8.16b, v1.16b
  ; CHECK-NEXT:  mov     v9.16b, v0.16b
  ; CHECK-NEXT:  bl      atan2
  ; CHECK-NEXT:  mov     v0.16b, v9.16b
  ; CHECK-NEXT:  mov     v1.16b, v8.16b
  ; CHECK-NEXT:  bl      atan2
  ; CHECK:  ret
  ;
  entry:
    %0 = call double @atan2(double %x, double %y)
    %1 = call double @llvm.atan2.f64(double %x, double %y)
    ret void
}

define void @atan2_f32(float %x, float %y) {
  ; CHECK-LABEL: atan2_f32:
  ; CHECK:  mov     v8.16b, v1.16b
  ; CHECK-NEXT:  mov     v9.16b, v0.16b
  ; CHECK-NEXT:  bl      atan2f
  ; CHECK-NEXT:  mov     v0.16b, v9.16b
  ; CHECK-NEXT:  mov     v1.16b, v8.16b
  ; CHECK-NEXT:  bl      atan2f
  ; CHECK:  ret
  ;
  entry:
    %0 = call float @atan2f(float %x, float %y)
    %1 = call float @llvm.atan2.f32(float %x, float %y)
    ret void
}

