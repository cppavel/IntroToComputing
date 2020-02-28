;
; CS1022 Introduction to Computing II 2018/2019
; Lab 2 - Subarray
;

N	EQU	7
M	EQU	3

	AREA	RESET, CODE, READONLY
	ENTRY

	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	;R0 - sub_matrix boolean 
	;R1 - current_dimension
	;R2 - current address
	;R3 - counter_w
	;R4 - counter_h
	;R6 - address
	;R7 - element small A
	;R8 - element large A
	;R9 - index i
	;R10 - index j
	MOV R0, #0 									; isSubmatrix = false;
	MOV R3, #0 									; w_cur = 0;
	MOV R4, #0 									; h_cur = 0;
	MOV R9, #0									; i = 0;
for1											; for(i =0 ;i <= N - M; i++)
	CMP R9, #(N-M)								; {
	BGT endfor1									;		j = 0;
	MOV R10, #0									; 		for(j = 0; j<= N - M;j++)
for2											;		{
	CMP R10, #(N-M)								;			w_cur = 0;
	BGT endfor2									;			h_cur = 0;
												;			while(w_cur<M&&small[w_cur,h_cur]==big[i + w_cur, j + h_cur])
	MOV R3, #0									;			{
	MOV R4, #0 									;				h_cur++;
while											;				if(h_cur==M)
	CMP R3, #M									;				{
	BEQ endwhile								;					h_cur = 0;
												;					w_cur++;
	LDR R1, = N									;				}										
	LDR R2, = LARGE_A							;				if(w_cur == M)
	MOV R6, R9									;				{	
	ADD R6, R6, R3								;					isSubmatrix = true;	
	MUL R6, R1, R6								;					return
	ADD R6, R6, R10								;				}
	ADD R6, R6, R4								;			}
	LDR R8, [R2, R6, LSL #2]					;		}
												; }

	LDR R1, = M
	LDR R2, = SMALL_A
	MUL R6, R3, R1
	ADD R6, R6, R4
	LDR R7, [R2, R6, LSL #2]
	
	CMP R7, R8
	BNE endwhile
	
	ADD R4, R4, #1
	
	CMP R4, #M
	BNE notif
	MOV R4, #0
	ADD R3, R3, #1
notif
	CMP R3, #M
	BNE notif1
	MOV R0, #1
	B STOP
notif1
	B while
endwhile

	ADD R10, R10, #1
	B for2
endfor2
	ADD R9, R9, #1
	B for1
endfor1


STOP	B	STOP


;
; test data
;

LARGE_A	DCD	 48, 37, 15, 44,  3, 17, 26
	DCD	  2,  9, 12, 18, 14, 33, 16
	DCD	 13, 20,  1, 22,  7, 48, 21
	DCD	 27, 19, 44, 49, 44, 18, 10
	DCD	 29, 17, 22,  4, 46, 43, 41
	DCD	 37, 35, 38, 34, 16, 25,  0
	DCD	 17,  0, 48, 15, 27, 35, 11


SMALL_A	DCD	 49, 44, 18
	DCD	  4, 46, 43
	DCD	 34, 16, 25

	END