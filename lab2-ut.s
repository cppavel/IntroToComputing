;
; CS1022 Introduction to Computing II 2018/2019
; Lab 2 - Upper Triangular
;

N	EQU	3		

	AREA	RESET, CODE, READONLY
	ENTRY

	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000
	
	
	;R1 - array address
	;R2 - N
	;R3 - i
	;R4 - j
	;R5 - element
	;R6 -address of an element
	LDR R0, = 1; initially consider matrix to be appropriate 
	LDR R1, = ARR_A
	LDR R2, = N
	LDR R3, = 1; i = 1
for1
	CMP R3, #N
	BEQ endfor1
	SUB R4, R3, #1; j = i - 1
for2
	CMP R4, #0
	BLT endfor2
	MUL R6, R3, R2; i * N
	ADD R6, R6, R4; i * N + j
	LDR R5, [R1, R6, LSL #2]
	CMP R5, #0
	BEQ notif
	LDR R0, = 0; matrix is not of upper triangular form
	B STOP
notif
	SUB R4, R4, #1; j = j - 1
	B for2
endfor2
	ADD R3, R3, #1; i = i + 1 
	B for1
endfor1

STOP	B	STOP


;
; test data
;

ARR_A	DCD	 1,  2,  3
		DCD	 0,  6,  7
		DCD	 0,  0,  1

	END
