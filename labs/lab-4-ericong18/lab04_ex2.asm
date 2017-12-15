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

HALT

;---------------
;Data
;---------------
INTRO 	.STRINGZ	"Enter 10 characters\n"
ARRAY_1		.BLKW	#10		;Reserves 10 locations
COUNTER		.FILL	#10		;Counter for loop
