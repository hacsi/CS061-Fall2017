;=================================================
; Name: Eric Ong
; Email: eong001@ucr.edu
; 
; Lab: lab 9
; Lab section: 24
; TA: Kenneth O'Neal
;=================================================
.ORIG x3000

LD R4, BASE 						;R4 <-- BASE pointer
LD R5, MAX 						;R5 <-- MAX pointer
LD R6, TOS 						;R6 <-- TOS pointer (initially same as BASE)

LEA R0, PROMPT1 					;Load push prompt into R0
PUTS 							;Output prompt
GETC 							;Get user input
OUT
LD R1, ASCII_SHIFT_MAIN 				;R1 <-- #-48
ADD R0, R0, R1 						;Convert R0 to actual value
LD R1, SUB_STACK_PUSH 					;Load subroutine SUB_STACK_PUSH into R1
JSRR R1 						;Go to x3200 for SUB_STACK_PUSH

LEA R0, PROMPT2 					;Load push prompt into R0
PUTS 							;Output prompt 
GETC 							;Get user input
OUT
LD R1, ASCII_SHIFT_MAIN 				;R1 <-- #-48
ADD R0, R0, R1 						;Convert R0 to actual value
LD R1, SUB_STACK_PUSH 					;Load subroutine SUB_STACK_PUSH into R1
JSRR R1 						;Go to x3200 for SUB_STACK_PUSH

INPUT_STAR
	LEA R0, PROMPT3 				;Load operator prompt into R0
	PUTS 						;Output prompt
	GETC 						;Get user input
	OUT
	LD R1, STAR_SHIFT_MINUS 			;R1 <-- #-42
	ADD R0, R0, R1 					;Check if input was a '*'
	BRnp ERROR_INPUT 				;If not, keep looping until correct
	BR CORRECT_INPUT 				;Else, go to CORRECT_INPUT

	ERROR_INPUT
		LEA R0, ERROR_STAR 			;Load error input message into R0 
		PUTS 					;Output message 
		BR INPUT_STAR 				;Loop again

	CORRECT_INPUT
		LD R1, STAR_SHIFT_PLUS 			;R1 <-- #42
		ADD R0, R0, R1 				;Restore R0 back to its original value

LD R1, SUB_RPN_MULTIPLY 				;Load subroutine SUB_RPN_MULTIPLY into R1 
JSRR R1 						;Go to x3600 for SUB_RPN_MULTIPLY

LD R1, SUB_STACK_POP 					;Load subroutine SUB_STACK_POP into R1 
JSRR R1 						;Go to x3400 for SUB_STACK_POP

AND R2, R2, #0 						;Make R2 0
ADD R2, R0, #0 						;R2 <-- R0

LEA R0, RESULT 						;Load result message into R0
PUTS 							;Output result message
LD R1, SUB_PRINT_DECIMAL 				;Load subroutine SUB_PRINT_DECIMAL into R1 
JSRR R1  						;Go to x4000 for SUB_PRINT_DECIMAL

HALT

;-------------------------------------------------
;Local Data
;-------------------------------------------------
SUB_STACK_PUSH 			.FILL 			x3200
SUB_STACK_POP 	 		.FILL 			x3400
SUB_RPN_MULTIPLY 		.FILL 			x3600
SUB_PRINT_DECIMAL 		.FILL 			x4000
BASE 				.FILL 			xA000
MAX 				.FILL 			xA005
TOS 				.FILL 			xA000
ASCII_SHIFT_MAIN 		.FILL 			#-48
STAR_SHIFT_MINUS 		.FILL 			#-42
STAR_SHIFT_PLUS 		.FILL 			#42
PROMPT1				.STRINGZ 		"Enter a value to push onto the stack: "
PROMPT2				.STRINGZ 		"Enter a second value to push onto the stack: "
PROMPT3 			.STRINGZ 		"Enter '*' to multiply the 2 values that were pushed onto the stack: "
ERROR_STAR 			.STRINGZ 		"\nWrong input!\n"
RESULT 				.STRINGZ 		"The resulting product is "


;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH
; Parameter (R0): The value to push onto the stack
; Parameter (R4): BASE: A pointer to the base ( one less than the lowest available
; address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R0) onto the stack (i.e to address TOS+1).
; If the stack was already full (TOS = MAX), the subroutine has printed an
; overflow error message and terminated.
; Return Value: R6 ← updated TOS
;  		R2 ← Flag for test harness loop
;------------------------------------------------------------------------------------------
.ORIG x3200

ST R0, BACKUP_R0_3200
ST R1, BACKUP_R1_3200
ST R4, BACKUP_R4_3200
ST R5, BACKUP_R5_3200
ST R7, BACKUP_R7_3200

AND R2, R2, #0 					;Make R2 0
AND R3, R3, #0 					;Make R3 0
ADD R2, R5, #0 					;R2 <-- R5 (Copy MAX pointer to R2)
ADD R3, R6, #0 					;R3 <-- R6 (Copy TOS pointer to R3)
NOT R3, R3 					;Take 2's complement of TOS address copy
ADD R3, R3, #1 
ADD R2, R2, R3 					;Verify that TOS is LESS THAN MAX
BRnz ERROR_PUSH 				;If it isn't go to ERROR_PUSH

ADD R6, R6, #1 					;Increment TOS pointer
STR R0, R6, #0 					;Mem[R6(TOS) + #0] <-- R0
BR SUCCESS_PUSH 				;Go to SUCCESS to exit subroutine

ERROR_PUSH
	LEA R0, OVERFLOW_ERROR 			;Load error message into R0 
	PUTS 					;Output error message
	LD R0, NEWLINE_PUSH			;Load newline into R0
	OUT 					;Output newline
	AND R2, R2, #0 				;Make R2 0
	ADD R2, R2, #-1 			;Flag R2 as negative to end PUSH LOOP in test harness
	BR END_PUSH

SUCCESS_PUSH
	LD R0, NEWLINE_PUSH			;Load newline into R0
	OUT 					;Output newline
	AND R2, R2, #0 				;Make R2 0
	ADD R2, R2, #1 				;Flag R2 as positive for test harness

END_PUSH

LD R0, BACKUP_R0_3200
LD R1, BACKUP_R1_3200
LD R4, BACKUP_R4_3200
LD R5, BACKUP_R5_3200
LD R7, BACKUP_R7_3200

RET

;-------------------------------------------------
;SUB_STACK_PUSH Data
;-------------------------------------------------
BACKUP_R0_3200 			.BLKW 			#1
BACKUP_R1_3200 			.BLKW 			#1
BACKUP_R4_3200 			.BLKW 			#1
BACKUP_R5_3200 			.BLKW 			#1
BACKUP_R7_3200 			.BLKW 			#1
ASCII_SHIFT_PUSH 		.FILL 			#-48
NEWLINE_PUSH 			.FILL 			#10
OVERFLOW_ERROR 			.STRINGZ 		"\nERROR: Stack overflow!"


;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R4): BASE: A pointer to the base ( one less than the lowest available
; address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[top] off of the stack.
; If the stack was already empty (TOS = BASE), the subroutine has printed
; an underflow error message and terminated.
; Return Value: R0 ← value popped off of the stack
; R6 ← updated TOS
;------------------------------------------------------------------------------------------
.ORIG x3400

ST R1, BACKUP_R1_3400
ST R3, BACKUP_R3_3400
ST R4, BACKUP_R4_3400
ST R5, BACKUP_R5_3400
ST R7, BACKUP_R7_3400

ADD R2, R2, #0 					;Make R2 0
ADD R3, R3, #0 					;Make R3 0
ADD R2, R6, #0 					;R2 <-- R6 (Copy TOS pointer to R2)
ADD R3, R4, #0 					;R3 <-- R4 (Copy BASE pointer to R3)
NOT R3, R3 					;Take 2's complement of BASE address copy
ADD R3, R3, #1
ADD R2, R2, R3 					;Verify that TOS is GREATER THAN BASE
BRnz ERROR_POP 					;If not, go to ERROR_POP

LDR R1, R6, #0 					;R1 <-- Mem[R6(TOS) + #0]
ADD R6, R6, #-1 				;Decrement TOS pointer
BR SUCCESS_POP

ERROR_POP
	LEA R0, UNDERFLOW_ERROR 		;Load R0 with error message
	PUTS 					;Output error message
	LD R0, NEWLINE_POP 			;Load newline into R0 
	OUT 					;Output newline
	AND R2, R2, #0 				;Make R2 0
	ADD R2, R2, #-1 			;Flag R2 as negative to end pop loop in test harness
	BR END_POP

SUCCESS_POP					;Output newline
	AND R2, R2, #0 				;Make R2 0
	ADD R2, R2, #1 				;Flag R2 as positive for test harness

END_POP
ADD R0, R1, #0 					;R0 <-- value popped off 

LD R1, BACKUP_R1_3400
LD R3, BACKUP_R3_3400
LD R4, BACKUP_R4_3400
LD R5, BACKUP_R5_3400
LD R7, BACKUP_R7_3400

RET

;-------------------------------------------------
;SUB_STACK_POP Data
;-------------------------------------------------
BACKUP_R1_3400 			.BLKW 			#1
BACKUP_R3_3400 			.BLKW 			#1
BACKUP_R4_3400 			.BLKW 			#1
BACKUP_R5_3400 			.BLKW 			#1
BACKUP_R7_3400 			.BLKW 			#1
UNDERFLOW_ERROR 		.STRINGZ 		"ERROR: Stack underflow!"
NEWLINE_POP 			.FILL 			#10
ASCII_SHIFT_POP 		.FILL 			#-48


;------------------------------------------------------------------------------------------
; Subroutine: SUB_RPN_MULTIPLY
; Parameter (R4): BASE: A pointer to the base ( one less than the lowest available
; address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
; multiplied them together, and pushed the resulting value back
; onto the stack.
; Return Value: R6 ← updated top value
;------------------------------------------------------------------------------------------
.ORIG x3600

ST R1, BACKUP_R1_3600
ST R7, BACKUP_R7_3600

AND R3, R3, #0 					;Make sure R3 is 0

LD R1, SUB_STACK_POP_2 				;Load subroutine SUB_STACK_POP into R1
JSRR R1 					;Go to x3400 for SUB_STACK_POP (x2)
ADD R3, R0, #0 					;R3 <-- 1st popped value
JSRR R1 					;R0 will have the 2nd popped value

LD R1, SUB_MULTIPLY 				;Load subroutine SUB_MULTIPLY into R1
JSRR R1 					;Go to x3800 for SUB_MULTIPLY

LD R1, SUB_STACK_PUSH_2 			;Load subroutine SUB_STACK_PUSH into R1 
JSRR R1 					;Go to x3200 for SUB_STACK_PUSH (push the product onto stack)

LD R1, BACKUP_R1_3600
LD R7, BACKUP_R7_3600

RET

;-------------------------------------------------
;SUB_STACK_POP Data
;-------------------------------------------------
SUB_STACK_PUSH_2 		.FILL 			x3200
SUB_STACK_POP_2 		.FILL 			x3400
SUB_MULTIPLY 			.FILL 			x3800
BACKUP_R1_3600 			.BLKW 			#1
BACKUP_R7_3600 			.BLKW 			#1


;------------------------------------------------------------------------------------------
; Subroutine: SUB_MULTIPLY
; Parameter (R0): 1st value
; Parameter (R3): 2nd value
; Postcondition: The subroutine multiplies the 2 values passed in, 
; Return Value: R0 ← product of the 2 values
;------------------------------------------------------------------------------------------
.ORIG x3800

ST R2, BACKUP_R2_3800
ST R3, BACKUP_R3_3800
ST R7, BACKUP_R7_3800

ADD R2, R0, #0 					;R2 <-- R0 (for multiplying)
ADD R3, R3, #-1
MULTIPLY_LOOP
	ADD R0, R0, R2  			;Add R2 to R0 (R3 - 1) times
	ADD R3, R3, #-1
	BRz END_MULTIPLY
	BR MULTIPLY_LOOP
END_MULTIPLY

LD R2, BACKUP_R2_3800
LD R3, BACKUP_R3_3800
LD R7, BACKUP_R7_3800

RET

;-------------------------------------------------
;SUB_STACK_POP Data
;-------------------------------------------------
BACKUP_R2_3800			.BLKW 			#1
BACKUP_R3_3800 			.BLKW 			#1
BACKUP_R7_3800 			.BLKW 			#1


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_DECIMAL
; Input: R2 
; Postcondition: The subroutine prints the number that is in R2
; Return Value : None
; NOTE: This subroutine should print the number to the user WITHOUT 
;		leading 0's and DOES NOT output the '+' for positive numbers.
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4000

ST R1, BACKUP_R1_4000
ST R2, BACKUP_R2_4000
ST R3, BACKUP_R3_4000
ST R4, BACKUP_R4_4000
ST R5, BACKUP_R5_4000
ST R6, BACKUP_R6_4000
ST R7, BACKUP_R7_4000

ADD R1, R2, #0					;R1 <-- R2 (contains decimal)
ADD R6, R2, #0 					;R6 <-- R2 (also contains same decimal)
AND R3, R3, #0					;R3 <-- #0
ADD R2, R2, #0					;Make R2 LMF
BRn NEGATIVE_PRINT 				;Go to NEGATIVE if R2 is negative
BR PRECHECK					;Else, just skip it

NEGATIVE_PRINT
	LD R0, ASCII_MINUS 			;R0 <-- '-'
	OUT
	NOT R2, R2 				;2's complement for negative decimals
	ADD R2, R2, #1
	ADD R1, R2, #0
	ADD R6, R2, #0

PRECHECK					;Decide which loop to start from
	LD R5, DEC_10K
	ADD R1, R1, R5 				;Check if 10K loop
	BRzp PRE_10K 				;If so, go to PRE_10K
	ADD R1, R6, #0				;Restore R1 to original value

	LD R5, DEC_1K 				;Check if 1K loop
	ADD R1, R1, R5
	BRzp PRE_1K 
	ADD R1, R6, #0

	LD R5, DEC_100 				;Check if 100 loop
	ADD R1, R1, R5 
	BRzp PRE_100
	ADD R1, R6, #0

	LD R5, DEC_10 				;Check if 10 loop
	ADD R1, R1, R5
	BRzp PRE_10
	ADD R1, R6, #0

	BR PRE_1 				;Else, you have to go to 1 loop

	PRE_10K
		ADD R1, R6, #0
		LD R5, DEC_10K			;R5 <-- #-10000
		BR CHECK_10K_LOOP

	PRE_1K
		ADD R1, R6, #0
		LD R5, DEC_1K			;R5 <-- #-1000
		BR CHECK_1K_LOOP

	PRE_100
		ADD R1, R6, #0
		LD R5, DEC_100			;R5 <-- #-100
		BR CHECK_100_LOOP

	PRE_10
		ADD R1, R6, #0
		LD R5, DEC_10			;R5 <-- #-10
		BR CHECK_10_LOOP

	PRE_1
		ADD R1, R6, #0
		LD R5, DEC_1			;R5 <-- #-1
		BR CHECK_1_LOOP


CHECK_10K_LOOP
	ADD R4, R1, #0				;Make a copy of R1 in R4
	ADD R1, R1, R5 				;Subtract 10000
	BRp INCREMENT_1 			;Go to INCREMENT to count
	BRn END_CHECK_10K_LOOP 			;Else, END loop

	INCREMENT_1
		ADD R3, R3, #1			;Increment to count 10K's place
		BR CHECK_10K_LOOP
END_CHECK_10K_LOOP

ADD R0, R3, #0 					;R0 <-- R3
ADD R0, R0, #12					;Convert to char equivalent
ADD R0, R0, #12
ADD R0, R0, #12
ADD R0, R0, #12
OUT 						;Print to console

ADD R1, R4, #0					;Restore R1 to value before it was negative
AND R3, R3, #0					;Reset R3 to 0

CHECK_1K_LOOP 
	LD R5, DEC_1K				;R5 <-- #-1000
	ADD R4, R1, #0				;Make a copy of R1 in R4
	ADD R1, R1, R5 				;Subtract 1000
	BRp INCREMENT_2 			;Go to INCREMENT to count
	BRn END_CHECK_1K_LOOP			;Else, END loop

	INCREMENT_2
		ADD R3, R3, #1			;Increment to count 1K's place
		BR CHECK_1K_LOOP
END_CHECK_1K_LOOP

ADD R0, R3, #0 					;R0 <-- R3
ADD R0, R0, #12					;Convert to char equivalent
ADD R0, R0, #12
ADD R0, R0, #12
ADD R0, R0, #12
OUT

ADD R1, R4, #0					;Restore R1 to value before it was negative
AND R3, R3, #0					;Reset R3 to 0

CHECK_100_LOOP 
	LD R5, DEC_100				;R5 <-- #-100
	ADD R4, R1, #0				;Make a copy of R1 in R4
	ADD R1, R1, R5 				;Subtract 100
	BRp INCREMENT_3 			;Go to INCREMENT to count
	BRn END_CHECK_100_LOOP			;Else, END loop

	INCREMENT_3
		ADD R3, R3, #1			;Increment to count 100's place
		BR CHECK_100_LOOP
END_CHECK_100_LOOP

ADD R0, R3, #0 					;R0 <-- R3
ADD R0, R0, #12					;Convert to char equivalent
ADD R0, R0, #12
ADD R0, R0, #12
ADD R0, R0, #12
OUT

ADD R1, R4, #0					;Restore R1 to value before it was negative
AND R3, R3, #0					;Reset R3 to 0

CHECK_10_LOOP 
	LD R5, DEC_10				;R5 <-- #-10
	ADD R4, R1, #0				;Make a copy of R1 in R4
	ADD R1, R1, R5 				;Subtract 10
	BRp INCREMENT_4 			;Go to INCREMENT to count
	BRn END_CHECK_10_LOOP			;Else, END loop

	INCREMENT_4
		ADD R3, R3, #1			;Increment to count 10's place
		BR CHECK_10_LOOP
END_CHECK_10_LOOP

ADD R0, R3, #0 					;R0 <-- R3
ADD R0, R0, #12					;Convert to char equivalent
ADD R0, R0, #12
ADD R0, R0, #12
ADD R0, R0, #12
OUT

ADD R1, R4, #0					;Restore R1 to value before it was negative
AND R3, R3, #0					;Reset R3 to 0

CHECK_1_LOOP
	LD R5, DEC_1				;R5 <-- #-1 
	ADD R4, R1, #0				;Make a copy of R1 in R4
	ADD R1, R1, R5 				;Subtract 1
	BRp INCREMENT_5 			;Go to INCREMENT to count
	BRn END_CHECK_1_LOOP			;Else, END loop

	INCREMENT_5
		ADD R3, R3, #1			;Increment to count 1's place
		BR CHECK_1_LOOP
END_CHECK_1_LOOP

ADD R0, R3, #0 					;R0 <-- R3
ADD R0, R0, #12					;Convert to char equivalent
ADD R0, R0, #12
ADD R0, R0, #12
ADD R0, R0, #12
OUT

LD R1, BACKUP_R1_4000
LD R2, BACKUP_R2_4000
LD R3, BACKUP_R3_4000
LD R4, BACKUP_R4_4000
LD R5, BACKUP_R5_4000
LD R6, BACKUP_R6_4000
LD R7, BACKUP_R7_4000

RET

;--------------------------------
;SUB_PRINT_DECIMAL Data
;--------------------------------
DEC_10K			.FILL			#-10000
DEC_1K 			.FILL			#-1000
DEC_100			.FILL 			#-100
DEC_10 			.FILL 			#-10
DEC_1 			.FILL			#-1
ASCII_MINUS 		.FILL 			#45
BACKUP_R1_4000		.BLKW			#1
BACKUP_R2_4000		.BLKW			#1
BACKUP_R3_4000		.BLKW			#1
BACKUP_R4_4000		.BLKW			#1
BACKUP_R5_4000		.BLKW			#1
BACKUP_R6_4000		.BLKW			#1
BACKUP_R7_4000		.BLKW			#1