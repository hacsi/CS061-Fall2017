;=================================================
; Name: Eric Ong
; Email: eong001@ucr.edu
; 
; Lab: lab 4
; Lab section: 24
; TA: Kenneth O'Neal
; 
;=================================================

.ORIG x3000

;------------------
;Instructions
;------------------
LD  R1, DATA_PTR			;Store pointer to x4000 in R1

DO_WHILE_LOOP
	GETC				;Get user input -> R0
	STR  R0, R1, #0			;R0 -> Mem[R1 + 0] == Mem[x4000]
	ADD  R1, R1, #1			;Goes to next array index location
	ADD  R0, R0, #-10		;See if R0 == #0
	BRnp DO_WHILE_LOOP		;If not 0 (if R0 is negative or positive), continue looping
END_DO_WHILE_LOOP

LD  R1, DATA_PTR			;Reset beginning location of pointer to R1

DO_WHILE_LOOP_2
	LDR  R0, R1, #0			;Load value at Mem[R1 + 0] == Mem[x4000] to R0
	ADD  R2, R0, #0			;Store R0 value in R2 as a temp
	ADD  R2, R2, #-10		;Subtract 10 to see if it is sentinel character
	BRz  END_DO_WHILE_LOOP_2	;End program if R0 is newline
	OUT 				;Output value from R0
	LEA  R0, NEWLINE		;Load newline character into R0
	PUTS				;Output newline character from R0
	ADD  R1, R1, #1			;Go to next memory location
	BRnp DO_WHILE_LOOP_2
END_DO_WHILE_LOOP_2

HALT

;------------------
;Data
;------------------
DATA_PTR	.FILL	x4000		;Beginning location of array
NEWLINE		.STRINGZ	"\n"	;Newline character
