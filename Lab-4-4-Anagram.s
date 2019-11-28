;
; CSU11021 Introduction to Computing I 2019/2020
; Anagrams
;

	AREA	RESET, CODE, READONLY
	ENTRY
	
	;The approach is to get an array of 26 elements, where each element stands for the number of the letters
	;with the respective place in the alphabet in the first string
	;Then whenever we find a certain element in the second string we decrease the corresponding counter by one.
	;If all of the counters are equal to zero, strings are anagrams.
	;I do not consider special symbols, punctuation, numbers and etc. And the case of the letters does not matter.
	
	LDR R3, = 'a'
	LDR R0, = 0;
whilezeroes ;setting all the possible counters to zero
	CMP R3, #'z'
	BHI endwhilezeroes
	ADD R2, R3, #0x40000000
	STRB R0, [R2]
	ADD R3, R3, #1;
	B whilezeroes
endwhilezeroes

	LDR	R0, =tststr1	; first string
	LDR	R1, =tststr2	; second string
	
	LDRB R3, [R0]; loading new element
	
while1 ;counting the number of each symbol in the first string (regardless its case)

	CMP R3, #0 ;while(current_element != 0)
	BEQ endwhile1
	CMP R3, #'a'
	BLO notif1l
	CMP R3, #'z'
	BHI notif1l
	ADD R2, R3, #0x40000000; current_address
	LDRB R4, [R2];
	ADD R4, R4, #1;
	STRB R4, [R2];
notif1l
	CMP R3, #'A'
	BLO notif1u
	CMP R3, #'Z'
	BHI notif1u
	ADD R2, R3, #0x40000000;
	ADD R2, R2, #0x20; 
	LDRB R4, [R2];
	ADD R4, R4, #1;
	STRB R4, [R2];
notif1u
	ADD R0, R0, #1 ;moving address
	LDRB R3, [R0]; loading next element
	B while1
endwhile1

	LDRB R3, [R1]; loading new element
	
while2 ;counting the number of each symbol in the second string (regardless its case)
	
	CMP R3, #0 ;while(current_element!=0)
	BEQ endwhile2
	CMP R3, #'a'
	BLO notif2l
	CMP R3, #'z'
	BHI notif2l
	ADD R2, R3, #0x40000000; current_address
	LDRB R4, [R2];
	SUB R4, R4, #1;
	STRB R4, [R2];
notif2l
	CMP R3, #'A'
	BLO notif2u
	CMP R3, #'Z'
	BHI notif2u
	ADD R2, R3, #0x40000000;
	ADD R2, R2, #0x20; 
	LDRB R4, [R2];
	SUB R4, R4, #1;
	STRB R4, [R2];
notif2u
	ADD R1, R1, #1 ;moving address
	LDRB R3, [R1]; loading next element
	B while2
endwhile2
	
	
	LDR R3, ='a'; 

while3 ;checking if every counter is now equal to zero

	CMP R3, #'z'
	BHI endwhile3
	ADD R2, R3, #0x40000000
	LDRB R4, [R2]
	CMP R4, #0
	BNE notanagram
	ADD R3, R3, #1; 
	B while3
endwhile3

	LDR R0, =1; is_anagram
	B endprogram	
	
notanagram
	LDR R0, = 0; not_anagram
endprogram
	
STOP	B	STOP

tststr1	DCB	"nEAtt",0
tststr2	DCB	"a nEtE",0

	END
