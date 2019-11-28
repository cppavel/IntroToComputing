;
; CSU11021 Introduction to Computing I 2019/2020
; Pseudo-random number generator
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R0, =0x40000000	; start address for pseudo-random sequence
	LDR	R1, =64		; number of pseudo-random values to generate
	
	; Linear congruential generator
	; x_{n} = (a*x_{n-1} + c)mod m
	; I consider m to be 2^32, which means I don't need to write special code so as to find modulus of the number, as
	; assembly arithmetics is already implemented in 2^32 modulus way.
	; a and c are the standard values for Borland C/C++
	; https://en.wikipedia.org/wiki/Linear_congruential_generator - source of the algo
	
	
	LDR R2, = 1729 ; cause that's my favorite number
	LDR R3, = 22695477; a
	LDR R4, = 1; c
	
	LDR R6, =4; loading 4 for multiplication 
	MUL R5, R6, R1; 4 * number of pseudo-random values to generate
	ADD R5, R5, R0; end_address of the numbers
	
while1  ;while(address!=endAdress)
	CMP R0, R5
	BHS endwhile1
	MUL R2, R3, R2; seed * a
	ADD R2, R2, R4; seed * a + c 
	STR R2, [R0]; storing the result
	ADD R0, R0, #4; moving the address forward
	B while1
endwhile1


STOP	B	STOP

	END
