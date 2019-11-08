;
; CSU11021 Introduction to Computing I 2019/2020
; Proper Case
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R0, =tststr	; address of existing string
	LDR	R1, =0x40000000	; address for new string
	
	
	LDRB R2, [R0] ;previouschar = test_string[0];
	; R3 is going to be used as current_char; 
	CMP R2, #'z'
	BHI finish 
	CMP R2, #'a'
	BLO finish 
	ADD R2, R2, #-0x20; converting to uppercase
finish
	STRB R2,[R1] ; storing new first character
	ADD R0, R0, #1; 
	ADD R1, R1, #1; 
	
while
	LDRB R3, [R0] ; current_char = next_char;
	CMP R3, #'\0' ; if(current_char != end_of_string)
	BEQ endwhile
	CMP R2, #' ' ; if(previous_char != ' ')
	BEQ finish1
	CMP R3, #'A'
	BLO finish2
	CMP R3, #'Z';
	BHI finish2
	ADD R3, R3, #0x20; convering to lower case
	B finish2
finish1
	CMP R3, #' ' ;else if(current_char!=' ') 
	BEQ finish2
	CMP R3, #'a'
	BLO finish2
	CMP R3, #'z'
	BHI finish2
	ADD R3, R3, #-0x20; converting to uppercase
finish2
	STRB R3, [R1]
	MOV R2, R3  ; previous_char = current_char 
	ADD R0, R0, #1 ; address_begin = address_begin + 1; 
	ADD R1, R1, #1 ; address_end = address_end + 1; 
	B while
endwhile
	
STOP	B	STOP

tststr	DCB	"Hello WORLD",0

	END
