;=================================================
; Name: Eric Ong
; Email: eong001@ucr.edu
; 
; Lab: lab 6
; Lab section: 24
; TA: Kenneth O'Neal
;=================================================

.ORIG x3000
;-------------------
;Instructions
;-------------------
LD  R1, COUNT_10				;Load first of the first 10 binary powers
LD  R2, DEC_1					;Load array counter
LD  R3, ARRAY_1_PTR				;Store pointer to first array index

DO_WHILE_LOOP
	STR  R2, R3, #0				;R2 -> Mem[R3 + #0]
	ADD  R3, R3, #1				;Go to next array index
	ADD  R2, R2, R2				;Bit shift to the left (next binary power)
	ADD  R1, R1, #-1			;Decrement counter
	BRp  DO_WHILE_LOOP			;Loop while counter is still positive
END_DO_WHILE_LOOP

LD  R3, ARRAY_1_PTR				;Reset pointer to beginning of ARRAY_1
LD  R1, COUNT_10				;Reload counter for array traversal

DO_WHILE_LOOP_2
	LD R5, SUB_PRINT			;R5 <-- x3200
	JSRR R5					;Jump to subroutine
	ADD R3, R3, #1				;Go to next array index
	ADD R1, R1, #-1				;Decrement counter
	BRp  DO_WHILE_LOOP_2			;Loop again while counter is still positive
END_DO_WHILE_LOOP_2	

HALT
;-------------------
;Local Data
;-------------------
ARRAY_1_PTR	.FILL		x4000		;Define pointer to array
DEC_1		.FILL		#1		;Start with 1 (2^0)
COUNT_10	.FILL		#10		;Counter for array traversal
SUB_PRINT	.FILL		x3200		

;-------------------
;Remote Data
;-------------------
.ORIG x4000
ARRAY_1		.BLKW		#10		;Reserve 10 memory locations for an array


;---------------------------------------------------
;Subroutine: SUB_PRINT_3200
;Input (R3): Array index to extract the value stored
;	     at the array index
;Post-condition: Prints the binary value of the
;		 value stored in the the array index
;Return value: None
;---------------------------------------------------
.ORIG x3200
ST  R2, BACKUP_R2_3200
ST  R7, BACKUP_R7_3200
ST  R4, BACKUP_R4_3200

LDR  R2, R3, #0					;R2 <-- Mem[R3 + #0]
LD  R6, SPACE_COUNT				;Load space counter into R6
LD  R4, COUNT_16				;Load counter for 16-bit binary

LD  R0, 
TOP
	ADD R2, R2, #0				;Make sure R2 is LMF
	BRp  POSITIVE				;Go to POSITIVE if LMF > 0
	BRn  NEGATIVE				;Go to NEGATIVE if LMF < 0

	POSITIVE
		LD  R0, ASCII_ZERO		;Load '0' to R0
		OUT				;Output '0' to console
		BR  CHECK_COUNT			;Go to CHECK_COUNT regardless

	NEGATIVE
		LD  R0, ASCII_ONE		;Load '1' to R0
		OUT				;Output '1' to console
		BR  CHECK_COUNT			;Go to CHECK_COUNT regardless

	CHECK_COUNT
		ADD R4, R4, #-1			;Decrement counter for 16-bit binary
		BRz BOTTOM			;If counter is 0, proceed bottom to print newline
		BR  CHECK_SPACES		;Otherwise, proceed to check space counter
	
	CHECK_SPACES
		ADD R6, R6, #-1			;Decrement counter for spaces
		BRp BIT_SHIFT			;Go to BIT_SHIFT if space counter > 0
		LEA R0, SPACE			;Load space into R0
		PUTS				;Output space to console
		LD  R6, SPACE_COUNT		;Reload space counter into R6

	BIT_SHIFT
		ADD R2, R2, R2			;R2 << 2
		BR  TOP				;Go to TOP regardless

	BOTTOM
		LD  R0, NEWLINE			;Load newline char into R0
		OUT				;Print newline char

LD  R2, BACKUP_R2_3200
LD  R7, BACKUP_R7_3200
LD  R4, BACKUP_R4_3200

RET
;-------------------
;Subroutine Data
;-------------------
ASCII_ZERO   	.FILL  		#48		;ASCII value for char '0'
ASCII_ONE    	.FILL  		#49		;ASCII value for char '1'
SPACE	     	.STRINGZ	" "		;String for " "
NEWLINE	     	.FILL  		#10		;ASCII value for char '/n'
COUNT_16	.FILL  		#16		;Counter to loop from 15 to 0
SPACE_COUNT  	.FILL  		#4		;Counter for space after every 4 bits

BACKUP_R2_3200	.BLKW		#1
BACKUP_R7_3200	.BLKW		#1
BACKUP_R4_3200	.BLKW		#1

.END
