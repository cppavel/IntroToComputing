;
; CS1022 Introduction to Computing II 2019/2020
; Sample eTest Q1
;

N	EQU	5


	AREA	globals, DATA, READWRITE

array	SPACE	1024


	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R4, =array
	LDR	R5, =N	
	
	MOV R6, #0 ;i

	MOV R9, #0 ;zero value for storing

for1
	CMP R6, #N
	BEQ endfor1
	MOV R7, #0 ;j
for2
	CMP R7, #N
	BEQ endfor2
	
	MUL R8, R6, R5
	ADD R8, R8, R7
	
	CMP R6, R7
	BNE notif1
	STR R9, [R4, R8, LSL #2]
	B endifelse
notif1
	BLE notif2
	SUB R10, R6, R7
	STR R10, [R4, R8, LSL #2]
	B endifelse
notif2
	SUB R10, R7, R6
	STR R10, [R4, R8, LSL #2]
endifelse
	ADD R7, R7, #1
	B for2
endfor2
	ADD R6, R6, #1 
	B for1
endfor1


STOP	B	STOP


	END
