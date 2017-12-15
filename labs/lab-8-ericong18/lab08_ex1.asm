;=================================================
; Name: Eric Ong
; Email: eong001@ucr.edu
; 
; Lab: lab 8
; Lab section: 24
; TA: Kenneth O'Neal

;=================================================
.ORIG x3000

LD R0, STRING_ARRAY					;Pass in starting address of array
LD R6, SUB_GET_STRING					;Put SUB_GET_STRING location in R6
JSRR R6							;Go to x3400 for SUB_GET_STRING

HALT

;-------------------------------------------------
;Local Data
;-------------------------------------------------
SUB_GET_STRING			.FILL			x3200
STRING_ARRAY			.FILL			x4000


;--------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING
; Parameter (R0): The address of where to start storing the string
; Postcondition: The subroutine has allowed the user to input a string,
; 		 terminated by the [ENTER] key, and has stored it in an 
;		 array that starts at (R0) and is NULL-terminated.
; Return Value: R5 The number of non-sentinel characters read from the user
;--------------------------------------------------------------------------
.ORIG x3200

ST R0, BACKUP_R0_3200
ST R2, BACKUP_R2_3200
ST R7, BACKUP_R7_3200

LD R2, ENTER_SHIFT 					;Used to check if ENTER
ADD R1, R0, #0						;R1 <-- R0 (beginning address of array) for temporary purposes
LEA R0, PROMPT						;Load prompt text in R0
PUTS							;Output prompt

DO_WHILE_LOOP
	GETC						;Get user char input
	OUT 						;Display typed char
	ADD R0, R0, R2					;Check if input was ENTER
	BRz END_LOOP					;End loop if it was ENTER
	ADD R0, R0, #10					;Restore R0 to original value
	STR R0, R1, #0					;Mem[R1 + #0] <-- R0
	ADD R5, R5, #1					;Count number of char inputs
	ADD R1, R1, #1					;Go to next memory location for R0 array
	BR DO_WHILE_LOOP 				;Loop again
END_LOOP
STR R3, R1, #0

LD R0, BACKUP_R0_3200
LD R2, BACKUP_R2_3200
LD R7, BACKUP_R7_3200

RET

;-------------------------------------------------
;SUB_GET_STRING Data
;-------------------------------------------------
PROMPT				.STRINGZ		"Enter a string of text followed by [ENTER]\n"
ENTER_SHIFT			.FILL			#-10
BACKUP_R0_3200			.BLKW			#1
BACKUP_R2_3200			.BLKW			#1
BACKUP_R7_3200			.BLKW			#1