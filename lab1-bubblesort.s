;
; CS1022 Introduction to Computing II 2019/2020
; Lab 1B - Bubble Sort
;

N	EQU	10

	AREA	globals, DATA, READWRITE

; N word-size values

SORTED	SPACE	N*4		; N words (4 bytes each)


	AREA	RESET, CODE, READONLY
	ENTRY


	;
	; copy the test data into RAM
	;

	LDR	R4, =SORTED
	LDR	R5, =UNSORT
	LDR	R6, =0
whInit	CMP	R6, #N
	BHS	eWhInit
	LDR	R7, [R5, R6, LSL #2]
	STR	R7, [R4, R6, LSL #2]
	ADD	R6, R6, #1
	B	whInit
eWhInit
	
	LDR R0, =SORTED; address of the 
do
	LDR R1, = 0; swapped = false;
	LDR R2, = 1; i = 1
	LDR R3, = 0; (i-1) = 0
for 
	CMP R2, #N ;for(i = 1; i<N;i++)
	BEQ endfor
	LDR R4, [R0, R2, LSL#2]; array[i]
	LDR R5, [R0, R3, LSL#2]; array[i-1]
	CMP R5, R4 ;if(array[i-1]>array[i])
	BLE notif
	STR R4, [R0, R3, LSL#2] ;array[i-i] < - array[i]
	STR R5, [R0, R2, LSL#2] ;array[i] <- array[i-1]
	LDR R1, =1 ;swapped = true;
notif
	ADD R2, R2, #1 ; i + 1
	ADD R3, R3, #1 ;(i-1) + 1
	B for
endfor
	CMP R1, #0
	BNE do

STOP B STOP


UNSORT	DCD	9,3,0,1,6,2,4,7,8,5

	END
