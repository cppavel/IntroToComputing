;
; CSU11021 Introduction to Computing I 2019/2020
; Mode
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR R1, =tstvals; address of numbers
	LDR R2, = tstN; address of N
	LDR R3, [R2]; N
	LDR R4, = 4;
	MUL R4, R3, R4; 4*N
	ADD R2, R4, R2; final address = address of numbers + 4*N;
	LDR R6, =0 ; max_counter = 0;
while1
	CMP R1, R2
	BHS endwhile1
	LDR R3, =tstvals ;address for nested_loop
	LDR R4, [R1]; getting_current_elem
	LDR R5, = 0; setting current_counter to zero;
while2
	CMP R3, R2
	BHS endwhile2
	LDR R7, [R3]; getting_comparing_elem
	CMP R7, R4
	BNE notequal
	ADD R5, R5, #1; counter = counter + 1;
notequal
	ADD R3, R3, #4; moving address forward
	B while2
endwhile2
	CMP R5, R6
	BLS notgreater
	MOV R5, R6;
	MOV R0, R4
notgreater
	ADD R1, R1, #4; moving address forward
	B while1
endwhile1
	
	
STOP	B	STOP

tstN	DCD	13			; N (number of numbers)
tstvals	DCD	5, 3, 7, 5, 3, 5, 1, 9, 1, 1, 1, 1, 1	; numbers

	END
