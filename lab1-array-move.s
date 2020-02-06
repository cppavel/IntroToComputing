;
; CS1022 Introduction to Computing II 2018/2019
; Lab 1 - Array Move
;

N	EQU	16		; number of elements

	AREA	globals, DATA, READWRITE

; N word-size values

ARRAY	SPACE	N*4		; N words


	AREA	RESET, CODE, READONLY
	ENTRY

	; for convenience, let's initialise test array [0, 1, 2, ... , N-1]

	LDR	R0, =ARRAY
	LDR	R1, =0
L1	CMP	R1, #N
	BHS	L2
	STR	R1, [R0, R1, LSL #2]
	ADD	R1, R1, #1
	B	L1
L2

	; initialise registers for your program

	LDR	R0, =ARRAY
	LDR	R1, =0 ;old index
	LDR	R2, =15 ;new index
	
	CMP R2, R1; if(new_index>=old_index)
	BLO less	
	LDR R3, [R0, R1, LSL#2]; loading old val 
	ADD R1, R1, #1; incrementing old index
for           ;for(int i = old_index; i <=new_index; i++)
	CMP R1, R2
	BGT endfor
	LDR R4, [R0,R1,LSL#2]; loading current value
	SUB R1, R1, #1; subtracting one from the address
	STR R4, [R0, R1, LSL#2]; storing it back to a lower index
	ADD R1, R1, #2; incrementing the value by two
	B for
endfor
	STR R3, [R0, R2, LSL#2]; storing the old value to a new index
	B STOP
less		;else [new_index<old_index]
	LDR R3, [R0, R1, LSL#2]; 
	SUB R1, R1, #1; decrementing old index

for1		 ;for(int i = old_index; i >=new_index; i--)
	CMP R1, R2
	BLT endfor1
	LDR R4, [R0,R1,LSL#2]
	ADD R1, R1, #1; adding one to the address
	STR R4, [R0, R1, LSL#2]; storing it back to a higher index
	SUB R1, R1, #2; decrementing index by two
	B for1
endfor1
	STR R3, [R0, R2, LSL#2]; storing the old value to a new index
STOP	B	STOP

	END