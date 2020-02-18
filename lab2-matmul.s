;
; CS1022 Introduction to Computing II 2018/2019
; Lab 2 - Matrix Multiplication
;

N	EQU	4		

	AREA	globals, DATA, READWRITE

; result array
ARR_R	SPACE	N*N*4		; N*N words (4 bytes each)


	AREA	RESET, CODE, READONLY
	ENTRY

	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000
	
	; R1 - i
	; R2 - j
	; R3 - k
	; R4 - r
	; R5 - matrix A element
	; R6 - matrix B element
	; R7 - index to get an element
	; R8 - address of A
	; R9 - address of B
	; R10 - address of result
	; R11 - N 
	
	LDR R8, = ARR_A
	LDR R9, = ARR_B
	LDR R10, = ARR_R
	LDR R11, = N
	LDR R1, = 0 ;i = 0;
for1 
	CMP R1, #N
	BEQ endfor1
	LDR R2, = 0; j = 0;
for2
	CMP R2, #N
	BEQ endfor2
	LDR R4, = 0; r = 0
	LDR R3, = 0; k = 0;
for3
	CMP R3, #N
	BEQ endfor3
	MUL R7, R1, R11 ; i * N
	ADD R7, R7, R3; i * N + k
	LDR R5, [R8, R7, LSL #2]; element A
	MUL R7, R3, R11;k * N
	ADD R7, R7, R2; k * N + j
	LDR R6, [R9, R7, LSL #2]; element B
	MUL R7, R5, R6; element A * element B
	ADD R4, R4, R7; r = r + element A * element B
	ADD R3, R3, #1; k = k + 1
	B for3
endfor3
	MUL R7, R1, R11; i * N
	ADD R7, R7, R2; i * N + j
	STR R4, [R10, R7, LSL #2]; storing the value in resulting matrix
	ADD R2, R2, #1 ; j = j + 1
	B for2
endfor2
	ADD R1, R1, #1 ; i = i + 1
	B for1
endfor1



	STOP	B	STOP


;
; test data
;

ARR_A	DCD	 1,  2,  3,  4
	DCD	 5,  6,  7,  8
	DCD	 9, 10, 11, 12
	DCD	13, 14, 15, 16

ARR_B	DCD	 1,  2,  3,  4
	DCD	 5,  6,  7,  8
	DCD	 9, 10, 11, 12
	DCD	13, 14, 15, 16

	END
