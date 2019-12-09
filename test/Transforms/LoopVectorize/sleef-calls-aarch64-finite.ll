; RUN: opt -mcpu=thunderx2t99 -vector-library=SLEEF -tli-max-vector-width-for-target=128 -tli-use-finite-math-only=true --enable-no-infs-fp-math=true --enable-no-nans-fp-math=true --enable-no-trapping-fp-math=true -loop-vectorize -S < %s | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

declare double @acos(double) #0
declare float @acosf(float) #0
declare double @llvm.acos.f64(double) #0
declare float @llvm.acos.f32(float) #0

define void @acos_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @acos_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v___acos_finite(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @acos(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @acos_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @acos_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v___acosf_finite(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @acosf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @asin(double) #0
declare float @asinf(float) #0
declare double @llvm.asin.f64(double) #0
declare float @llvm.asin.f32(float) #0

define void @asin_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @asin_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v___asin_finite(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @asin(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @asin_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @asin_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v___asinf_finite(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @asinf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @atan(double) #0
declare float @atanf(float) #0
declare double @llvm.atan.f64(double) #0
declare float @llvm.atan.f32(float) #0

define void @atan_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @atan_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v_atan(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @atan(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @atan_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @atan_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v_atanf(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @atanf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @atan2(double) #0
declare float @atan2f(float) #0
declare double @llvm.atan2.f64(double) #0
declare float @llvm.atan2.f32(float) #0

define void @atan2_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @atan2_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2vv___atan2_finite(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @atan2(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @atan2_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @atan2_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4vv___atan2f_finite(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @atan2f(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @atanh(double) #0
declare float @atanhf(float) #0
declare double @llvm.atanh.f64(double) #0
declare float @llvm.atanh.f32(float) #0

define void @atanh_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @atanh_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v___atanh_finite(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @atanh(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @atanh_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @atanh_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v___atanhf_finite(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @atanhf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @cos(double) #0
declare float @cosf(float) #0
declare double @llvm.cos.f64(double) #0
declare float @llvm.cos.f32(float) #0

define void @cos_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @cos_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v_cos(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @cos(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @cos_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @cos_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v_cosf(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @cosf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @cosh(double) #0
declare float @coshf(float) #0
declare double @llvm.cosh.f64(double) #0
declare float @llvm.cosh.f32(float) #0

define void @cosh_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @cosh_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v___cosh_finite(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @cosh(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @cosh_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @cosh_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v___coshf_finite(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @coshf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @exp(double) #0
declare float @expf(float) #0
declare double @llvm.exp.f64(double) #0
declare float @llvm.exp.f32(float) #0

define void @exp_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @exp_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v___exp_finite(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @exp(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @exp_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @exp_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v___expf_finite(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @expf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @exp2(double) #0
declare float @exp2f(float) #0
declare double @llvm.exp2.f64(double) #0
declare float @llvm.exp2.f32(float) #0

define void @exp2_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @exp2_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v___exp2_finite(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @exp2(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @exp2_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @exp2_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v___exp2f_finite(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @exp2f(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @exp10(double) #0
declare float @exp10f(float) #0
declare double @llvm.exp10.f64(double) #0
declare float @llvm.exp10.f32(float) #0

define void @exp10_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @exp10_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v___exp10_finite(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @exp10(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @exp10_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @exp10_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v___exp10f_finite(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @exp10f(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @lgamma(double) #0
declare float @lgammaf(float) #0
declare double @llvm.lgamma.f64(double) #0
declare float @llvm.lgamma.f32(float) #0

define void @lgamma_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @lgamma_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v___lgamma_finite(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @lgamma(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @lgamma_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @lgamma_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v___lgammaf_finite(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @lgammaf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @log10(double) #0
declare float @log10f(float) #0
declare double @llvm.log10.f64(double) #0
declare float @llvm.log10.f32(float) #0

define void @log10_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @log10_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v___log10_finite(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @log10(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @log10_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @log10_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v___log10f_finite(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @log10f(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @log2(double) #0
declare float @log2f(float) #0
declare double @llvm.log2.f64(double) #0
declare float @llvm.log2.f32(float) #0

define void @log2_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @log2_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v_log2(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @log2(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @log2_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @log2_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v_log2f(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @log2f(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @log(double) #0
declare float @logf(float) #0
declare double @llvm.log.f64(double) #0
declare float @llvm.log.f32(float) #0

define void @log_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @log_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v___log_finite(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @log(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @log_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @log_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v___logf_finite(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @logf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @pow(double) #0
declare float @powf(float) #0
declare double @llvm.pow.f64(double) #0
declare float @llvm.pow.f32(float) #0

define void @pow_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @pow_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2vv___pow_finite(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @pow(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @pow_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @pow_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4vv___powf_finite(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @powf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @sin(double) #0
declare float @sinf(float) #0
declare double @llvm.sin.f64(double) #0
declare float @llvm.sin.f32(float) #0

define void @sin_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @sin_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v_sin(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @sin(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @sin_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @sin_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v_sinf(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @sinf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @sinh(double) #0
declare float @sinhf(float) #0
declare double @llvm.sinh.f64(double) #0
declare float @llvm.sinh.f32(float) #0

define void @sinh_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @sinh_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v___sinh_finite(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @sinh(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @sinh_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @sinh_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v___sinhf_finite(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @sinhf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @sqrt(double) #0
declare float @sqrtf(float) #0
declare double @llvm.sqrt.f64(double) #0
declare float @llvm.sqrt.f32(float) #0

define void @sqrt_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @sqrt_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v___sqrt_finite(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @sqrt(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @sqrt_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @sqrt_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v___sqrtf_finite(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @sqrtf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @tan(double) #0
declare float @tanf(float) #0
declare double @llvm.tan.f64(double) #0
declare float @llvm.tan.f32(float) #0

define void @tan_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @tan_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v_tan_u35(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @tan(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @tan_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @tan_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v_tanf_u35(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @tanf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @tanh(double) #0
declare float @tanhf(float) #0
declare double @llvm.tanh.f64(double) #0
declare float @llvm.tanh.f32(float) #0

define void @tanh_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @tanh_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v_tanh_u35(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @tanh(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @tanh_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @tanh_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v_tanhf(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @tanhf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

declare double @tgamma(double) #0
declare float @tgammaf(float) #0
declare double @llvm.tgamma.f64(double) #0
declare float @llvm.tgamma.f32(float) #0

define void @tgamma_f64(double* nocapture %varray) {
  ; CHECK-LABEL: @tgamma_f64(
  ; CHECK:    [[TMP5:%.*]] = call fast <2 x double> @_ZGVnN2v___tgamma_finite(<2 x double> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to double
  %call = call fast double @tgamma(double %conv)
  %arrayidx = getelementptr inbounds double, double* %varray, i64 %iv
  store double %call, double* %arrayidx, align 8
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

define void @tgamma_f32(float* nocapture %varray) {
  ; CHECK-LABEL: @tgamma_f32(
  ; CHECK:    [[TMP5:%.*]] = call fast <4 x float> @_ZGVnN4v___tgammaf_finite(<4 x float> [[TMP4:%.*]])
  ; CHECK:    ret void
  ;
  entry:
  br label %for.body

  for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = call fast float @tgammaf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

  for.end:
  ret void
}

