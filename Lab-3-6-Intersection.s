;
; CSU11021 Introduction to Computing I 2019/2020
; Intersection
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R0, =0x40000000	; address of sizeC
	LDR	R1, =0x40000004	; address of elemsC
	
	LDR R2, =sizeA
	LDR R3, [R2]; R3 = sizeA
	LDR R5, = 4;
	MUL R5, R3, R5; 4*sizeA
	LDR R4, =elemsA; R4 = start_pos_elem_A
	ADD R4, R4, R5; R4 = end_pos_elem_A
	
	LDR R2, =sizeB
	LDR R3, [R2]; R3 = sizeB
	LDR R6, = 4
	MUL R6, R3, R6 ;4*sizeB
	LDR R5, = elemsB; R5 = start_pos_elem_B
	ADD R5, R6, R5; R5 = end_pos_elem_B
	
	LDR R2, = elemsA; R2 = start_pos_elem_A
	LDR R3, = elemsB; R3 = start_pos_elem_B
	
	LDR R6, = 0; sizeC = 0
	
while1
	CMP R2, R4
	BHS endwhile1
	LDR R7, [R2] ; loading_current_element
while2
	CMP R3, R5
	BHS endwhile2
	LDR R8, [R3]; loading element for comparison
	CMP R7, R8
	BNE notequal
	ADD R6, R6, #1; sizeC = sizeC + 1
	STR R7, [R1]; loading current element into C
	ADD R1, R1, #4; moving address of C
	B endwhile2
notequal
	ADD R3, R3, #4; moving address forward
	B while2
endwhile2
	LDR R3, = elemsB ;initialising R3 with start address of elemB
	ADD R2, R2, #4; moving address forward
	B while1
endwhile1
	STR R6, [R0]; storing sizeC
	
STOP	B	STOP

sizeA	DCD	7
elemsA	DCD	7, 14, 6, 3,898989898, 17,81

sizeB	DCD	11
elemsB	DCD	81, 20, 11, 14, 5, 17, 2, 9, 12, 7,898989898

	END
