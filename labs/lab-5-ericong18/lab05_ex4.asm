;=================================================
; Name: Eric Ong
; Email: eong001@ucr.edu
; 
; Lab: lab 5
; Lab section: 24
; TA: Kenneth O'Neal
; 
;=================================================

.ORIG x3000
;-------------------
;Instructions
;-------------------
LD  R1, ARRAY_1_PTR				;R1 points to first index of ARRAY_1
LD  R4, COUNT_10 				;Put counter value 10 in R4
LD  R2, DEC_1					;Load 2 into R2
LD  R3, COUNT_16				;Put counter value 16 in R3
LD  R5, SPACE_COUNT				;Put counter value 4 in R5

DO_WHILE_LOOP
	STR R2, R1, #0				;R2 --> Mem[R1 + #0]
	ADD R2, R2, R2				;R2 >> 2 (multiply by 2)
	ADD R1, R1, #1				;Go to next array index
	ADD R4, R4, #-1				;Decrement R4 counter
	BRp DO_WHILE_LOOP 			;Loop again while positive
END_DO_WHILE_LOOP

LD  R6, ARRAY_1_PTR 				;Point R6 to first array index
LD  R4, COUNT_10				;Reload counter value in R4

PRINT_LOOP
	TOP	
	LDR R2, R6, #0				;R2 <-- Mem[R6 + #0]

	BEGINNING
	ADD R2, R2, #0
	BRp POSITIVE
	BRn NEGATIVE	
	
	POSITIVE
		LD  R0, ASCII_ZERO		;Load '0' into R0
		OUT				;Output R0 to console
		BR	CHECK_COUNT		;Go to CHECK_COUNT regardless
	
	NEGATIVE
		LD  R0, ASCII_ONE		;Load '1' into R0
		OUT				;Output R0 to console
		BR	CHECK_COUNT		;Go to CHECK_COUNT regardless

	CHECK_COUNT				
		ADD R3, R3, #-1			;Decrement counter for 16-total bits
		BRz	BOTTOM			;Go to end of loop if counter reaches 0
		BRnp 	CHECK_SPACES		;Otherwise, proceed to check spaces

	CHECK_SPACES
		ADD R5, R5, #-1			;Decrement space counter
		BRp	END			;Go to end for bit shifting
		LEA R0, SPACE			;Load space into R0
		PUTS				;Output space to console
		LD  R5, SPACE_COUNT		;Reload R5 with SPACE_COUNT
	
	END
		ADD R2, R2, R2			;R2 << 2
		BR	BEGINNING		;Go to beginning

	BOTTOM
		LD  R0, NEWLINE			;Load NEWLINE to R0
		OUT				;Output NEWLINE
		LD  R3, COUNT_16		;Reload R3
		LD  R5, SPACE_COUNT
		ADD R6, R6, #1			;Go to next array index
		ADD R4, R4, #-1			;Decrement array traversal counter
		BRp	TOP			;Go to TOP regardless
END_PRINT_LOOP

LD R0, #1
OUT

HALT

;-------------------
;Data
;-------------------
ARRAY_1_PTR	.FILL		x4000		;Fill pointer to x4000 memory address
COUNT_10	.FILL   	#10		;Counter to count number of times to fill array
COUNT_6		.FILL   	#6		;Counter to get to 7th array index (6)
DEC_1		.FILL   	#1		;Used as starting binary number 2^0
COUNT_16	.FILL  		#16		;Counter to loop from 15 to 0
SPACE_COUNT  	.FILL  		#4		;Counter for space after every 4 bits
ASCII_ZERO   	.FILL  		#48		;ASCII value for char '0'
ASCII_ONE    	.FILL  		#49		;ASCII value for char '1'
SPACE	     	.STRINGZ	" "		;String for " "
NEWLINE	     	.FILL  		#10		;ASCII value for char '/n'

;-------------------
;Remote Data
;-------------------
.ORIG x4000
ARRAY_1		.BLKW		#10		;Reserve 10 memory locations for an array

.END
