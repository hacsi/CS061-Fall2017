;=================================================
; Name: Eric
; Email: eong001@ucr.edu
; 
; Lab: lab 7
; Lab section: 24
; TA: Kenneth O'Neal
; 
;=================================================

.ORIG x3000

LEA R0, PROMPT_INPUT				;R0 <-- PROMPT_INPUT
PUTS						;Output input prompt
GETC						;Get input from user
OUT 						;Output whatever user inputted
ADD R1, R0, #0 					;Copy R0 to R1 for checking purposes
LD R6, SUB_COUNT				;R6 <-- x3400
JSRR R6						;Go to SUB_COUNT
LEA R0, RESULT_OUTPUT 				;R0 <-- RESULT_OUTPUT	
PUTS						;Output result message
ADD R0, R3, #0					;R0 <-- R3 (number of 1's)
LD R4, DEC_TO_CHAR
ADD R0, R0, R4 					;Convert R0 decimal to char equivalent
OUT
LD R0, NEWLINE					;Load newline char into R0
OUT 						;Output newline char to console

HALT

;--------------------------
;Local Data
;--------------------------
PROMPT_INPUT		.STRINGZ		"Input a single character:\n"
RESULT_OUTPUT		.STRINGZ		"The number of 1's is: "
NEWLINE			.STRINGZ		"\n"
DEC_TO_CHAR		.FILL			#48
SUB_COUNT		.FILL			x3400



;---------------------------------------------
;Subroutine: SUB_COUNT
;Input: R0 (user input)
;Post-condition: R3 <-- # of 1's in char input
;Return: R3 (contains # of 1's) 
;---------------------------------------------
.ORIG x3400

ST R1, BACKUP_R1_3400
ST R2, BACKUP_R2_3400
ST R7, BACKUP_R7_3400

LD R1, COUNT_16					;Counter for number of bit shifts
ADD R2, R0, #0					;R2 <-- R0

WHILE_LOOP
	ADD R2, R2, #0				;Make R0 LMF
	BRn NEGATIVE				;Go to NEGATIVE if 1
	BR POST 				;Go to POST to decrement counter

	NEGATIVE
		ADD R3, R3, #1			;Increment if it is 1 (negative)

	POST
		ADD R2, R2, R2 			;Bit shift left << 
		ADD R1, R1, #-1			;Decrement counter for 16 bits
		BRz END_WHILE_LOOP		;If counter is 0, end loop
		BR WHILE_LOOP 			;Else, loop again
END_WHILE_LOOP

LD R0, NEWLINE_2 				;Load newline char into R0
OUT

LD R1, BACKUP_R1_3400
LD R2, BACKUP_R2_3400
LD R7, BACKUP_R7_3400

RET

;--------------------------
;SUB_COUNT Data
;--------------------------
COUNT_16		.FILL			#16
NEWLINE_2 		.STRINGZ 		"\n"

BACKUP_R1_3400		.BLKW			#1
BACKUP_R2_3400		.BLKW			#1
BACKUP_R7_3400		.BLKW			#1
