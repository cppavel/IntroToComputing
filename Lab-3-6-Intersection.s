;
; CSU11021 Introduction to Computing I 2019/2020
; Intersection
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R0, =0x40000000	; address of sizeC
	LDR	R1, =0x40000004	; address of elemsC
	
	LDR	R6, =sizeA	; address of sizeA
	LDR	R2, [R6]	; load sizeA
	LDR	R3, =elemsA	; address of elemsA
	
	LDR	R6, =sizeB	; address of sizeB
	LDR	R4, [R6]	; load sizeB
	LDR	R5, =elemsB	; address of elemsB

	;R7 -elemA
	;R8 -elemB
	;R9 -finaladdressofA
	;R10 - finaladdressofB
	;R11 -size of C
	LDR R7, = 4 
	MUL R9, R7, R2 ; 4*sizeA
	ADD R9, R9, R3 ; finaladdressofA = address of elemsA + 4*sizeA
	MUL R10, R7, R4; 4*sizeB
	ADD R10, R10, R5; finaladressofB = address of elemsB + 4*sizeB
	LDR R11, = 0; size C = 0;
while1
	CMP R3, R9
	BHS endwhile1
	LDR R7, [R3] ; load current elem of A
while2
	CMP R5, R10
	BHS endwhile2
	LDR R8, [R5]; load current elem of B
	CMP R8, R7
	BNE notcontained
	ADD R11, R11, #1; size = size + 1 
	STR R7, [R1]; 
	ADD R1, R1, #4; move address of elem C
	B endwhile2
notcontained
	ADD R5, R5, #4 ; move address of elem B
	B while2
endwhile2
	LDR R5, =elemsB
	ADD R3, R3, #4; move address of elem A
	B while1
endwhile1

	STR R11, [R0]; load size into memory
	
STOP	B	STOP

sizeA	DCD	6
elemsA	DCD	7, 14, 6, 3,898989898, 17

sizeB	DCD	10
elemsB	DCD	20, 11, 14, 5, 17, 2, 9, 12, 7,898989898

	END
