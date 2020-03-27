;
; CS1022 Introduction to Computing II 2018/2019
; Lab 3 - Floating-Point
;

	AREA	RESET, CODE, READONLY
	ENTRY

;
; Test Data
;
FP_A	EQU	0xc37a0000
FP_B	EQU	0x437a0000


	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000
	
	LDR R0, =FP_A			;loading the first test value
	LDR R1, =FP_B			;loading the second test value
	BL fpadd

	



stop	B	stop



;fpadd
;adds two IEEE 754 floating point values and returns them as a new IEEE 754 floating point value
;parameters
;	r0 - first floating point number
;   r1 - second floating point number
;return
;	r0 - sum of the values returned as an IEEE 754 floating point value

;special cases: 20.5-20.5, 12412521512-0.421044242 all considering errors

fpadd
	PUSH{lr, R4-R10}
	
	PUSH{R0-R1}				;saving the subroutine parameters
	BL fpfrac				;getting the fraction from ieee 754 float
	MOV R4, R0				;saving the fraction into another register
	POP{R0-R1}				;restoring the subroutine parameters
	

	PUSH{R0-R1}				;saving the subroutine parameters
	BL fpexp 				;getting the exponent from ieee 754 float
	MOV R5, R0 				;saving the exponenent into another register
	POP{R0-R1}				;restoring the subroutine parameters
	
	PUSH{R0-R1}				;saving the subroutine parameters
	MOV R0, R1				;moving the second value to R0 so as to use the subroutine properly
	BL fpfrac				;getting the fraction from ieee 754 float
	MOV R6, R0				;saving the fraction into another register
	POP{R0-R1}				;restoring the subroutine parameters
	

	PUSH{R0-R1}				;saving the subroutine parameters
	MOV R0, R1				;moving the second value to R0 so as to use the subroutine properly
	BL fpexp 				;getting the exponent from ieee 754 float
	MOV R7, R0 				;saving the exponenent into another register
	POP{R0-R1}				;restoring the subroutine parameters
	
	;now we have R4, R5 - the fraction and exponent of the first value and R6, R7 - the fraction and exponent of the second value
	
	CMP R5, R7 				;if(exponent_1 < exponent_2)
	BGE add_notif1
	SUB R8, R7, R5			;calculating the offset
	MOV R4, R4, ASR R8		;shifting the smaller value accordingly
	MOV R9, R7 				;saving the larger exponent
	B add_endif1
add_notif1
	SUB R8, R5, R7			;calculating the offset
	MOV R6, R6, ASR R8 		;shifting the smaller value accordingly
	MOV R9, R5				;saving the larger exponent
add_endif1

	ADD R8, R4, R6			;adding the fractions	
	LDR R5, =0x80000000 	;mask for finding the leading one
	LDR R6, = 31			;leading one position
	MOV R4, #0				;sign flag = 0
	CMP R8, #0
	BGE add_positive		;if(result<0)
	NEG R8, R8				;R8 = - R8
	MOV R4, #1				;sign flag = 1
add_positive
add_while
	AND R10, R8, R5 		;getting the current bit
	CMP R10, #0 		 	;while(bit==0&&mask!=0)
	BNE add_endwhile
	CMP R5, #0	
	BEQ add_endwhile
	MOV R5, R5, LSR #1		;moving the mask
	SUB R6, R6, #1			;moving the counter	
	B add_while
add_endwhile
	SUB R5, R6, #23			;offset
	CMP R5,#0				;if(offset<0)
	BGE add_notif2
	NEG R5, R5				;offset = -offset
	MOV R8, R8, LSL R5		;moving the value accordingly
	SUB R9, R9, R5			;changing the exponent
	B add_endif2
add_notif2
	MOV R8, R8, LSR R5		;moving the value accordingly
	ADD R9, R9, R5			;changing the exponent
add_endif2
	MOV R0, R8				;storing the fraction for encoding
	CMP R4, #1				;if (sign flag == 1)
	BNE add_positive_1
	NEG R0, R0				;R0 = - R0
add_positive_1
	MOV R1, R9				;storing the exponent for encoding
	BL fpencode				;after that subroutine R0 contains the sum of given floats as a IEEE 754 floating point number
	
	POP{pc, R4-R10}					
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
	LDR R4, =0x80000000 				;mask for getting the sign
	LDR R5, =0x007FFFFF 				;mask for getting the fraction
	LDR R6, =0x00800000 				;mask for setting the leading 1
	
	AND R7, R0, R4 						;sign
	AND R8, R0, R5 						;fraction with no leading 1
	ORR R8, R8, R6 						;fraction with a leading 1
	CMP R7, #0	   						;if(number is negative)
	BEQ positive
	NEG R8, R8 							;R8 = - R8
positive
	MOV R0, R8							;returning the fraction
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
	LDR R4, =0x7F800000					;mask for getting the exponent
	LDR R6, =127						;exponent bias
	AND R5, R0, R4						;getting the exponent
	MOV R5, R5, LSR #23					;shifting the exponent to the right
	SUB R5, R5, R6						;converting the exponent to 2's complement value
	MOV R0, R5							;returning the exponent
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
	
	PUSH {lr, R4-R9}
	
	MOV R4, #0 							;sign flag
	CMP R0, #0 							;if(fraction is negative)
	BGE notif
	NEG R0, R0
	MOV R4, #1 							;negative
notif
	LDR R5, =0x80000000 				;mask for finding the leading one
	LDR R8, = 31						;leading one position
while
	AND R9, R0, R5 						;getting the current bit
	CMP R9, #0 							;while(bit==0&&mask!=0)
	BNE endwhile
	CMP R5, #0
	BEQ endwhile
	MOV R5, R5, LSR #1					;moving the mask
	SUB R8, R8, #1						;moving the counter	
	B while
endwhile

	LDR R5, =23							;the index where leading 1 resides, when value is normalized
	SUB R8, R8, R5						;offset
	CMP R8, #0							;if(offset is negative)
	BGE notif0
	NEG R9, R8 							;converting offset to be positive
	MOV R0, R0, LSL R9 					;shifting left instead of right
	B endelse0
notif0
	MOV R0, R0, LSR R8 					;moving the value so as to make it normalized
endelse0	

	LDR R5, =0x00800000 				;mask for clearing the leading 1
	BIC R0, R0, R5						;clearing the leading 1	
	MOV R4, R4, LSL #31					;moving the sign bit so we can set it
	ORR R0, R0, R4						;setting the sign bit
	
	LDR R6, =127						;exponent bias
	ADD R1, R1, R6						;getting the exponent into its usual form
	ADD R1, R1, R8						;adding the offset to exponent
	CMP R1, #255 						;if(exponent>128)
	BLE notif1
	MOV R1, #255						;setting the exponent to be 128 if it turns out to be greater than it.
notif1
	CMP R1, #0  						;if(exponent < -127)
	BGE notif2
	MOV R1, #0 							;setting the exponent to be -127
notif2
	MOV R1, R1, LSL #23					;shifting the exponent to the left
	LDR R7, =0x7F800000					;mask for clearing the place for the exponent
	BIC R0, R0, R7						;clearing the bits where the exponent should be
	ORR R0, R0, R1						;copying the mask to the return register
	
	POP {pc, R4-R9}
	
	END