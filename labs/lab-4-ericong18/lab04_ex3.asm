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

;---------------
;Instructions
;---------------
LEA  R0, INTRO 			;Stores intro prompt into R0
PUTS				;Output intro prompt

LEA R1, ARRAY_1			;Stores pointer address to ARRAY_1 in R1
LD  R2, COUNTER 		;Stores counter (#10) in R2

DO_WHILE_LOOP
	GETC			;User input gets stored in R0
	STR R0, R1, #0		;Stores user input (R0) back into ARRAY_1 index
	ADD R1, R1, #1		;Go to next array index location
	ADD R2, R2, #-1		;Decrement counter
	BRp DO_WHILE_LOOP	;Loop again while positive
END_DO_WHILE_LOOP

LEA R0, NEWLINE 		;Store newline character in R0
PUTS				;Output newline character

LEA R3, ARRAY_1			;Stores pointer address to ARRAY_1 in R3
LD  R4, COUNTER 		;Stores counter (#10) in R4

DO_WHILE_LOOP_2
	LDR  R0, R3, #0		;Stores first array index value in R0
	OUT 			;Outputs R0 to console
	LEA  R0, NEWLINE	;Stores newline character in R0
	PUTS			;Print newline character
	ADD R3, R3, #1		;Go to next array index location
	ADD R4, R4, #-1		;Decrement counter
	BRp DO_WHILE_LOOP_2 	;Loop again while positive
END_DO_WHILE_LOOP_2

HALT

;---------------
;Data
;---------------
INTRO 	.STRINGZ	"Enter 10 characters\n"
ARRAY_1		.BLKW	#10		;Reserves 10 locations
COUNTER		.FILL	#10		;Counter for loop
NEWLINE		.STRINGZ	"\n"
