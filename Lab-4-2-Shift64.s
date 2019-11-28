;
; CSU11021 Introduction to Computing I 2019/2020
; 64-bit Shift
;

	AREA	RESET, CODE, READONLY
	ENTRY

 	LDR	R1, =0xD9448A9B		; most significaint 32 bits (63 ... 32)
	LDR	R0, =0xB8AA9D3B		; least significant 32 bits (31 ... 0)
	LDR	R2, = -2			; shift count
	
	; negative - > shift left
	; positive - > shift right
	CMP R2, #0 ; if(shift<0)
	BGE positive
while1			;while(shift!=0)
	CMP R2, #0 
	BEQ endwhile1
	MOV R1, R1, LSL #1 ; shift the most significant by one
	LDR R3, = 0x80000000; mask to get the most significant bit of least significant part
	AND R4, R3, R0; getting the most significant bit of least significant part
	MOV R4, R4, LSR #31 ;shifting it by 31 positions, so we can just add it to the most significant part
	ADD R1, R1, R4; getting the most significant bit of least significant part into the least significant bit of the most
	;significant part
	;better to use ORR
	MOV R0, R0, LSL #1; shift the least significant by one
	ADD R2, R2, #1; adding one to the shift, so it will become zero after some number of iterations (as it is negative)
	B while1
endwhile1
	B zero
positive
while2			;while(shift!=0)
	CMP R2, #0 
	BEQ endwhile2
	BEQ zero
	MOV R0, R0, LSR #1; shift the least signigicant by one
	LDR R3, = 0x00000001; mask to get the least significant bit of the most significant part
	AND R4, R3, R1; getting the least significant bit of the most significant part
	MOV R4, R4, LSL #31; shifting it by 31 positions, so we can just add it to the least significant part
	ADD R0, R0, R4; getting the least significant bit of the most significant part into the most significant bit
	;better to use ORR
	;of the least significant part 
	MOV R1, R1, LSR #1;; shift the most significant part by one
	ADD R2, R2, #-1; substracting one from the shift, so it will become zero after some number of iterations 
	;(as it is positive)
	B while2
endwhile2 
zero; doing nothing if shift is zero


STOP	B	STOP

	END
