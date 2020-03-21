;
; CS1022 Introduction to Computing II 2018/2019
; Lab 3 - Floating-Point
;

	AREA	RESET, CODE, READONLY
	ENTRY

;
; Test Data
;
FP_B	EQU	0x41C40000
FP_A	EQU	0x00000000


	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	LDR R0, = FP_A
	BL fpfrac
	MOV R1, R0
	LDR R0, = FP_A
	BL fpexp
	MOV R2, R0
	
	MOV R0, R1
	MOV R1, R2
	
	BL fpencode

stop	B	stop


;
; fpfrac
; decodes an IEEE 754 floating point value to the signed (2's complement)
; fraction
; parameters:
;	r0 - ieee 754 float
; return:
;	r0 - fraction (signed 2's complement word)
;
fpfrac
	PUSH {lr,R4-R8}
	LDR R4, =0x80000000 ;mask for getting the sign
	LDR R5, =0x007FFFFF ;mask for getting the fraction
	LDR R6, =0x00800000 ;mask for setting the leading 1
	
	AND R7, R0, R4 ; sign
	AND R8, R0, R5 ; fraction with no leading 1
	ORR R8, R8, R6 ; fraction with a leading 1
	CMP R7, #0	   ;if(number is negative)
	BEQ positive
	NEG R8, R8 ; R8 = - R8
positive
	MOV R0, R8	; returning the fraction
	POP {pc,R4-R8}



;
; fpexp
; decodes an IEEE 754 floating point value to the signed (2's complement)
; exponent
; parameters:
;	r0 - ieee 754 float
; return:
;	r0 - exponent (signed 2's complement word)
;
fpexp

	PUSH {lr,R4-R6}
	LDR R4, =0x7F800000;  mask for getting the exponent
	LDR R6, =127; exponent bias
	AND R5, R0, R4; getting the exponent
	MOV R5, R5, LSR #23;  shifting the exponent to the right
	SUB R5, R5, R6; converting the exponent to 2's complement value
	MOV R0, R5; returning the exponent
	POP {pc,R4-R6}



;
; fpencode
; encodes an IEEE 754 value using a specified fraction and exponent
; parameters:
;	r0 - fraction (signed 2's complement word)
;	r1 - exponent (signed 2's complement word)
; result:
;	r0 - ieee 754 float
;
fpencode
	
	PUSH {lr, R4-R7}
	
	MOV R4, #0 ; sign flag
	CMP R0, #0 ; if(fraction is negative)
	BGE notif
	NEG R0, R0
	MOV R4, #1 ; negative
notif
	LDR R5, =0x00800000 ;mask for setting the leading 1
	BIC R0, R0, R5; clearing the leading 1	
	MOV R4, R4, LSL #31; moving the sign bit so we can set it
	ORR R0, R0, R4; setting the sign bit
	
	LDR R6, =127; exponent bias
	ADD R1, R1, R6; getting the exponent into its usual form
	MOV R1, R1, LSL #23; shifting the exponent to the left
	LDR R7, =0x7F800000;  mask for getting the exponent
	BIC R0, R0, R7; clearing the bits where the exponent should be
	ORR R0, R0, R1; copying the mask to the return register
	
	POP {pc, R4-R7}
	
	END
