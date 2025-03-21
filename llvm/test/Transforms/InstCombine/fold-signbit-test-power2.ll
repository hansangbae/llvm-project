; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

declare void @use(i8)
declare void @use_i1(i1)
declare void @use_i1_vec(<2 x i1>)

; (X & -X) < 0 --> X == MinSignC
; (X & X) > -1 --> X != MinSignC

define i1 @pow2_or_zero_is_negative(i8 %x) {
; CHECK-LABEL: @pow2_or_zero_is_negative(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[X:%.*]], -128
; CHECK-NEXT:    [[CMP_2:%.*]] = icmp eq i8 [[X]], -128
; CHECK-NEXT:    call void @use_i1(i1 [[CMP_2]])
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg = sub i8 0, %x
  %pow2_or_zero = and i8 %x, %neg
  %cmp = icmp slt i8 %pow2_or_zero, 0
  %cmp.2 = icmp ugt i8 %pow2_or_zero, 127
  call void @use_i1(i1 %cmp.2)
  ret i1 %cmp
}

define i1 @pow2_or_zero_is_negative_commute(i8 %A) {
; CHECK-LABEL: @pow2_or_zero_is_negative_commute(
; CHECK-NEXT:    [[X:%.*]] = mul i8 [[A:%.*]], 42
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[X]], -128
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %x = mul i8 42, %A ; thwart complexity-based canonicalization
  %neg = sub i8 0, %x
  %pow2_or_zero = and i8 %neg, %x
  %cmp = icmp slt i8 %pow2_or_zero, 0
  ret i1 %cmp
}

define <2 x i1> @pow2_or_zero_is_negative_vec(<2 x i8> %x) {
; CHECK-LABEL: @pow2_or_zero_is_negative_vec(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <2 x i8> [[X:%.*]], splat (i8 -128)
; CHECK-NEXT:    [[CMP_2:%.*]] = icmp eq <2 x i8> [[X]], splat (i8 -128)
; CHECK-NEXT:    call void @use_i1_vec(<2 x i1> [[CMP_2]])
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %neg = sub <2 x i8> <i8 0, i8 0>, %x
  %pow2_or_zero = and <2 x i8> %x, %neg
  %cmp = icmp slt <2 x i8> %pow2_or_zero, <i8 0, i8 0>
  %cmp.2 = icmp ugt <2 x i8> %pow2_or_zero, <i8 127, i8 127>
  call void @use_i1_vec(<2 x i1> %cmp.2)
  ret <2 x i1> %cmp
}

define <2 x i1> @pow2_or_zero_is_negative_vec_commute(<2 x i8> %A) {
; CHECK-LABEL: @pow2_or_zero_is_negative_vec_commute(
; CHECK-NEXT:    [[X:%.*]] = mul <2 x i8> [[A:%.*]], splat (i8 42)
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <2 x i8> [[X]], splat (i8 -128)
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %x = mul <2 x i8> <i8 42, i8 42>, %A ; thwart complexity-based canonicalization
  %neg = sub <2 x i8> <i8 0, i8 0>, %x
  %pow2_or_zero = and <2 x i8> %neg, %x
  %cmp = icmp slt <2 x i8> %pow2_or_zero, <i8 0, i8 0>
  ret <2 x i1> %cmp
}

define i1 @pow2_or_zero_is_not_negative(i8 %x) {
; CHECK-LABEL: @pow2_or_zero_is_not_negative(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i8 [[X:%.*]], -128
; CHECK-NEXT:    [[CMP_2:%.*]] = icmp ne i8 [[X]], -128
; CHECK-NEXT:    call void @use_i1(i1 [[CMP_2]])
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg = sub i8 0, %x
  %pow2_or_zero = and i8 %x, %neg
  %cmp = icmp sgt i8 %pow2_or_zero, -1
  %cmp.2 = icmp ult i8 %pow2_or_zero, -128
  call void @use_i1(i1 %cmp.2)
  ret i1 %cmp
}

define i1 @pow2_or_zero_is_not_negative_commute(i8 %A) {
; CHECK-LABEL: @pow2_or_zero_is_not_negative_commute(
; CHECK-NEXT:    [[X:%.*]] = mul i8 [[A:%.*]], 42
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i8 [[X]], -128
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %x = mul i8 42, %A ; thwart complexity-based canonicalization
  %neg = sub i8 0, %x
  %pow2_or_zero = and i8 %neg, %x
  %cmp = icmp sgt i8 %pow2_or_zero, -1
  ret i1 %cmp
}

define <2 x i1> @pow2_or_zero_is_not_negative_vec(<2 x i8> %x) {
; CHECK-LABEL: @pow2_or_zero_is_not_negative_vec(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne <2 x i8> [[X:%.*]], splat (i8 -128)
; CHECK-NEXT:    [[CMP_2:%.*]] = icmp ne <2 x i8> [[X]], splat (i8 -128)
; CHECK-NEXT:    call void @use_i1_vec(<2 x i1> [[CMP_2]])
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %neg = sub <2 x i8> <i8 0, i8 0>, %x
  %pow2_or_zero = and <2 x i8> %x, %neg
  %cmp = icmp sgt <2 x i8> %pow2_or_zero, <i8 -1, i8 -1>
  %cmp.2 = icmp ult <2 x i8> %pow2_or_zero, <i8 -128, i8 -128>
  call void @use_i1_vec(<2 x i1> %cmp.2)
  ret <2 x i1> %cmp
}

define <2 x i1> @pow2_or_zero_is_not_negative_vec_commute(<2 x i8> %A) {
; CHECK-LABEL: @pow2_or_zero_is_not_negative_vec_commute(
; CHECK-NEXT:    [[X:%.*]] = mul <2 x i8> [[A:%.*]], splat (i8 42)
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne <2 x i8> [[X]], splat (i8 -128)
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %x = mul <2 x i8> <i8 42, i8 42>, %A ; thwart complexity-based canonicalization
  %neg = sub <2 x i8> <i8 0, i8 0>, %x
  %pow2_or_zero = and <2 x i8> %neg, %x
  %cmp = icmp sgt <2 x i8> %pow2_or_zero, <i8 -1, i8 -1>
  ret <2 x i1> %cmp
}

define i1 @pow2_or_zero_is_negative_extra_use(i8 %x) {
; CHECK-LABEL: @pow2_or_zero_is_negative_extra_use(
; CHECK-NEXT:    [[NEG:%.*]] = sub i8 0, [[X:%.*]]
; CHECK-NEXT:    call void @use(i8 [[NEG]])
; CHECK-NEXT:    [[POW2_OR_ZERO:%.*]] = and i8 [[X]], [[NEG]]
; CHECK-NEXT:    call void @use(i8 [[POW2_OR_ZERO]])
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[X]], -128
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg = sub i8 0, %x
  call void @use(i8 %neg)
  %pow2_or_zero = and i8 %x, %neg
  call void @use(i8 %pow2_or_zero)
  %cmp = icmp slt i8 %pow2_or_zero, 0
  ret i1 %cmp
}
