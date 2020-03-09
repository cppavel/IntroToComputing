;
; CS1022 Introduction to Computing II 2019/2020
; Sample eTest Q2
;

	AREA	globals, DATA, READWRITE

array	SPACE	1024


	AREA	RESET, CODE, READONLY
	ENTRY

	;
	; initialise the system stack pointer
	;
	LDR	SP, =0x40010000

	;
	; initialise array in RAM by copying from init_array
	;

	LDR	R0, =array	; destination in RAM		
	LDR	R1, =init_array	; source in ROM
	LDR	R4, =N
	LDR	R2, [R4]	; size of array
	BL	copy_arr	; initialise
	
	LDR	R4, =N
	LDR R1, [R4]
	BL sort


STOP	B	STOP

;
; Initial data
;
init_array
	DCD	6, 2, 7, 9, 1, 3, 2, 6, 9, 1, 109,90,-10,8	; test array elements

N	DCD	14			; test array size (in words)

;
; Your subroutine goes here
;
; swap subroutine
;	R0 - start address of array
;	R1 - length of the array

sort
	PUSH {R4-R9,lr}
	MOV R9, R1
do
	LDR R4, = 0; swapped = false;
	LDR R5, = 1; i = 1;
	LDR R6, = 0;
for 
	CMP R5, R9
	BEQ endfor
	LDR R7, [R0, R5, LSL #2]
	LDR R8, [R0, R6, LSL #2]
	CMP R8, R7
	BGE notif
	MOV R1, R5
	MOV R2, R6
	BL swap
	LDR R4, = 1
notif
	ADD R5, R5, #1
	ADD R6, R6, #1
	B for
endfor
	CMP R4, #1
	BEQ do
	
	POP {R4-R9,pc}


; swap subroutine
; Swaps two elements in an array of word size values
; Parameters:
;   R0 - start address of array
;   R1 - index of first element to swap
;   R2 - index of second element to swap
; Return Value:
;   none
swap
	PUSH	{R4, R5}
	LDR	R4, [R0, R1, LSL #2]
	LDR	R5, [R0, R2, LSL #2]
	STR	R5, [R0, R1, LSL #2]
	STR	R4, [R0, R2, LSL #2]
	POP	{R4, R5}
	BX	LR


; copy_arr subroutine
; Copies an array of words in memory
; Parameters:
;   R0 - destination address
;   R1 - source address
;   R2 - number of words to copy
; Return Value:
;   none
copy_arr
	PUSH	{R4-R5}
	LDR	R4, =0
wh_copy_arr
	CMP	R4, R2
	BHS	ewh_copy_arr
	LDR	R5, [R1, R4, LSL #2]
	STR	R5, [R0, R4, LSL #2]
	ADD	R4, R4, #1
	B	wh_copy_arr
ewh_copy_arr
	POP	{R4-R5}
	BX	LR

	END
