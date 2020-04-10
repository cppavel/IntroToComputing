;
; CS1022 Introduction to Computing II 2019/2020
; Polling Example
;

; TIMER0 registers
T0TCR		EQU	0xE0004004
T0TC		EQU	0xE0004008
T0MR0		EQU	0xE0004018
T0MCR		EQU	0xE0004014

; Pin Control Block registers
PINSEL4		EQU	0xE002C010

; GPIO registers
FIO2DIR1	EQU	0x3FFFC041
FIO2PIN1	EQU	0x3FFFC055

	AREA	RESET, CODE, READONLY
	ENTRY

	; Enable P2.10 for GPIO
	LDR	R4, =PINSEL4	; load address of PINSEL4
	LDR	R5, [R4]	; read current PINSEL4 value
	BIC	R5, #(0x3 << 20); modify bits 20 and 21 to 00
	STR	R5, [R4]	; write new PINSEL4 value

	; Set P2.10 for input
	LDR	R4, =FIO2DIR1	; load address of FIO2DIR1

	NOP			; on "real" hardware, we cannot place
				; an instruction at address 0x00000014
	LDRB	R5, [R4]	; read current FIO2DIR1 value
	BIC	R5, #(0x1 << 2)	; modify bit 2 to 0 for input, leaving other bits unmodified
	STRB	R5, [R4]	; write new FIO2DIR1
	
	MOV R4, #1;			;winner = true;
	LDR R9, =5000000; min_time = 5 sec
	LDR R10, =8000000; max_time = 8 sec
while
	CMP R4, #1
	BNE endwhile
	BL waitBtnDn
	
	; Reset TIMER0 using Timer Control Register
	;   Set bit 0 of TCR to 0 to stop TIMER
	;   Set bit 1 of TCR to 1 to reset TIMER
	LDR	R5, =T0TCR
	LDR	R6, =0x2
	STRB	R6, [R5]
	
	; There appears to be a bug in the uVision simulation
	;   of the TIMER peripherals. Setting the RESET bit of
	;   the TCR (above) should reset the TImer Counter (TC)
	;   but does not appear to do so. We can force it back
	;   to zero here.
	LDR	R5, =T0TC
	LDR	R6, =0x0
	STR	R6, [R5]
	
    ; Start TIMER0 using the Timer Control Register
	; Set bit 0 of TCR to enable the timer
	LDR	R5, =T0TCR
	LDR	R6, =0x01
	STRB	R6, [R5]
	
	BL waitBtnDn
	
	; Stop TIMER0 using the Timer Control Register
	; Set bit 0 to 0 of TCR to enable the timer
	LDR	R5, =T0TCR
	LDR	R6, =0x00
	STRB	R6, [R5]
	
	LDR R5, =T0TC
	LDR R6, [R5]		;getting the elapsed time
	
	CMP R6, R9  			;if(elapsed_time<min_time||elapsed_time>max_time)
	BLO winnerFalse					;winner = false;
	CMP R6, R10
	BLS skip
winnerFalse
	MOV R4, #0
skip
	CMP R4, #0				;if(!winner)
	BNE userWon
	; Set P2.10 for output
	LDR	R5, =FIO2DIR1	; load address of FIO2DIR1
	LDRB	R6, [R5]	; read current FIO2DIR1 value
	ORR	R6, #(0x1 << 2)	; modify bit 2 to 1 for output, leaving other bits unmodified
	STRB	R6, [R5]	; write new FIO2DIR1
	
	LDR	R5, =0x04		;   setup bit mask for P2.10 bit in FIO2PIN1
	LDR	R6, =FIO2PIN1		;
	LDRB	R7, [R6]		;   read FIO2PIN1
	BIC	R7, R7, R5			;   clear bit 2 (turn LED on)
	; write new FIO2PIN1 value
	STRB	R7, [R6]
userWon

	LDR R5, = 3000000; 3 seconds 
	ADD R9, R9, R5;	adding 3 seconds to min value
	ADD R10, R10, R5; adding 3 seconds to max value
	B while
	
endwhile

STOP B STOP

waitBtnDn
	PUSH{R4-R7,lr}
	
	LDR R4, = FIO2PIN1
	
	LDRB R5, [R4]; currentState = FIO2PIN1
	;R6 is going to be used for lastState
whBtnDn
	MOV R6, R5 ; lastState = currentState;
	
	LDRB R5, [R4] ; currentState = FIO2PIN1
	TST R5, #0x04
	BNE whBtnDn
	TST R6, #0x04
	BEQ whBtnDn	
	
	;that is done to simulate the behaviour of a real physical button
	;(it goes up when we release it)
	
	LDR	R5, =FIO2DIR1	; load address of FIO2DIR1
	LDRB	R6, [R5]	; read current FIO2DIR1 value
	ORR	R6, #(0x1 << 2)	; modify bit 2 to 1 for output, leaving other bits unmodified
	STRB	R6, [R5]	; write new FIO2DIR1
	
	LDR	R5, =0x04		;   setup bit mask for P2.10 bit in FIO2PIN1
	LDR	R6, =FIO2PIN1		;
	LDRB	R7, [R6]		;   read FIO2PIN1
	ORR	R7, R7, R5			;   set bit 2 (turn LED on)
	; write new FIO2PIN1 value
	STRB	R7, [R6]
		
	LDR	R4, =FIO2DIR1	; load address of FIO2DIR1

	LDRB	R5, [R4]	; read current FIO2DIR1 value
	BIC	R5, #(0x1 << 2)	; modify bit 2 to 0 for input, leaving other bits unmodified
	STRB	R5, [R4]	; write new FIO2DIR1
	
	POP{R4-R7, pc}
	
	END
		
		
