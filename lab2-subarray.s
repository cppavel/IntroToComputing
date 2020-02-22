;
; CS1022 Introduction to Computing II 2018/2019
; Lab 2 - Subarray
;

N	EQU	7
M	EQU	3		

	AREA	RESET, CODE, READONLY
	ENTRY

	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	;R0 - sub_matrix boolean 
	;R1 - current_dimension
	;R2 - current address
	;R3 - counter_w
	;R4 - counter_h
	;R5 - boolean line_checked
	;R6 - address
	;R7 - element small A
	;R8 - element large A
	;R9 - index i
	;R10 - index j
	MOV R0, #0
	LDR R1, = M
	LDR R2, = N
	MOV R3, #0
	MOV R4, #0
	MOV R5, #0
	
for1
	CMP R9, #N
	BEQ endfor1
	MOV R10, #0
for2
	CMP R10, #N
	BEQ endfor2
	LDR R1, = N
	LDR R2, = LARGE_A
	MUL R6, R9, R1
	ADD R6, R6, R10
	LDR R8, [R2, R6, LSL #2]
	LDR R1, = M
	LDR R2, = SMALL_A
	MUL R6, R3, R1
	ADD R6, R6, R4
	LDR R7, [R2, R6, LSL #2]	
	CMP R7, R8
	BNE elseif1
	ADD R4, R4, #1
	B endif1
elseif1
	MOV R4, #0
endif1
	CMP R4, R1
	BNE notif2
	MOV R4, #0
	MOV R5, #1
	B endfor2
notif2
	ADD R10, R10, #1
	B for2
endfor2
	CMP R5, #1
	BNE notif3
	ADD R3, R3, #1
	MOV R5, #0
	B endif3
notif3
	MOV R3, #1
endif3
	CMP R3, R1
	BNE notif4
	MOV R0, #1
	B STOP
notif4
	ADD R9, R9, #1
	B for1
endfor1


STOP	B	STOP


;
; test data
;

LARGE_A	DCD	 48, 37, 15, 44,  3, 17, 26
	DCD	  2,  9, 12, 18, 14, 33, 16
	DCD	 13, 20,  1, 22,  7, 48, 21
	DCD	 27, 19, 44, 49, 44, 18, 10
	DCD	 29, 17, 22,  4, 46, 43, 41
	DCD	 37, 35, 38, 34, 16, 25,  0
	DCD	 17,  0, 48, 15, 27, 35, 11


SMALL_A	DCD	 49, 44, 18
	DCD	  4, 46, 43
	DCD	 34, 16, 25

	END
