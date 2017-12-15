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

PUSH_LOOP
	LEA R0, PROMPT 					;Load R0 with prompt
	PUTS
	GETC 						;Get user input
	OUT
	LD R1, SUB_STACK_PUSH 				;Load subroutine SUB_STACK_PUSH into R1
	JSRR R1 					;Go to x3200 for SUB_STACK_PUSH
	ADD R2, R2, #0 					;Make R2 LMF
	BRn END_PUSH_LOOP 				;If overflow (R2 is -1) end loop
	BR PUSH_LOOP 					;Else, keep looping
END_PUSH_LOOP

POP_LOOP
	LD R1, SUB_STACK_POP 				;Load subroutine SUB_STACK_POP into R1 
	JSRR R1 					;Go to x3400 for SUB_STACK_POP
	ADD R2, R2, #0 					;Make R2 LMF
	BRn END_POP_LOOP 				;If underflow (R2 is -1) end loop
	LD R3, ASCII_SHIFT 				;R3 <-- #48
	ADD R0, R0, R3 					;Convert popped off value to character equivalent
	OUT 						;Output value popped off
	LEA R0, POP_MESSAGE 				;Load pop message into R0
	PUTS 						;Output pop message
	BR POP_LOOP 			 		;Loop again
END_POP_LOOP

HALT

;-------------------------------------------------
;Local Data
;-------------------------------------------------
SUB_STACK_PUSH 			.FILL 			x3200
SUB_STACK_POP 			.FILL 			x3400
BASE 				.FILL 			xA000
MAX 				.FILL 			xA005
TOS 				.FILL 			xA000
PROMPT 				.STRINGZ 		"Enter a value to push onto the stack: "
POP_MESSAGE 			.STRINGZ 		" was popped off the stack\n"
NEWLINE 			.FILL 			#10
ASCII_SHIFT 			.FILL 			#48

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
LD R2, ASCII_SHIFT_PUSH 			;R2 <-- #-48
ADD R0, R0, R2 					;R0 <-- actual single digit decimal value
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
LD R4, BACKUP_R4_3400
LD R5, BACKUP_R5_3400
LD R7, BACKUP_R7_3400

RET

;-------------------------------------------------
;SUB_STACK_POP Data
;-------------------------------------------------
BACKUP_R1_3400 			.BLKW 			#1
BACKUP_R4_3400 			.BLKW 			#1
BACKUP_R5_3400 			.BLKW 			#1
BACKUP_R7_3400 			.BLKW 			#1
UNDERFLOW_ERROR 		.STRINGZ 		"ERROR: Stack underflow!"
NEWLINE_POP 			.FILL 			#10
ASCII_SHIFT_POP 		.FILL 			#-48
