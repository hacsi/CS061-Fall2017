;=================================================
; Name: Eric Ong
; Email: eong001@ucr.edu
; 
; Lab: lab 8
; Lab section: 24
; TA: Kenneth O'Neal
; 
;=================================================
.ORIG x3000

LD R0, STRING_ARRAY					;Pass in starting address of array
LD R6, SUB_GET_STRING					;Put SUB_GET_STRING location in R6
JSRR R6							;Go to x3200 for SUB_GET_STRING
LD R6, SUB_IS_A_PALINDROME				;Put SUB_IS_A_PALINDROME location in R6
JSRR R6							;Go to x3400 for SUB_IS_A_PALINDROME

ADD R4, R4, #0						;Make R4 LMF
BRp IS 							;Go to IS if string is palindrome
BRz IS_NOT 						;Go to IS_NOT if string is not a palindrome

IS 
	LEA R0, PALINDROME_YES				;Load PALINDROME_YES into R0
	PUTS						;Output message
	BR END 						;Go to END

IS_NOT
	LEA R0, PALINDROME_NO 				;Load PALINDROME_NO into R0 
	PUTS 						;Output message
	BR END 						;Go to END

END

HALT

;-------------------------------------------------
;Local Data
;-------------------------------------------------
SUB_GET_STRING			.FILL			x3200
SUB_IS_A_PALINDROME 		.FILL			x3400
STRING_ARRAY			.FILL			x4000
PALINDROME_YES			.STRINGZ		"String is a palindrome!\n"
PALINDROME_NO			.STRINGZ		"String is NOT a palindrome!\n"


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
	ADD R1, R1, #1					;Go to next memory location for array
	BR DO_WHILE_LOOP 				;Loop again
END_LOOP

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


;--------------------------------------------------------------------------
; Subroutine: SUB_IS_A_PALINDROME
; Parameter (R0): The address of a string
; Parameter (R5): The number of characters in the array.
; Postcondition: The subroutine has determined whether the string at (R0) 
; is a palindrome or not, and returned a flag to that effect.
; Return Value: R4 {1 if the string is a palindrome, 0 otherwise}
;--------------------------------------------------------------------------
.ORIG x3400

ST R0, BACKUP_R0_3400
ST R1, BACKUP_R1_3400
ST R2, BACKUP_R2_3400
ST R3, BACKUP_R3_3400
ST R5, BACKUP_R5_3400
ST R6, BACKUP_R6_3400
ST R7, BACKUP_R7_3400

ADD R5, R5, #-1						;Decrement char count for array comparison
ADD R2, R0, R5 						;R2 <-- end char of string

CHECK_PALINDROME
	LDR R1, R0, #0					;R1 <-- Mem[R0]
	LDR R3, R2, #0					;R3 <-- Mem[n-1]
	NOT R3, R3 					;Make R3 negative (2's complement)
	ADD R3, R3, #1					
	ADD R1, R1, R3 					;See if result is 0
	BRz TRUE					;If so, go to TRUE
	BR FALSE 					;Else, go to FALSE

	TRUE
		ADD R0, R0, #1 				;Increment array pointer
		ADD R5, R0, #0 				;Make a copy of R0 location

		ADD R2, R2, #-1 			;Decrement R2 pointer
		ADD R6, R2, #0 				;Make a copy of R2 location

		NOT R5, R5 				;Make R5 negative(location of first char)
		ADD R5, R5, #1				;Complete the 2's complement
		ADD R6, R6, R5 				;Check if pointers crossed each other
		BRnz POST_TRUE				;If so, go to DONE
		BR CHECK_PALINDROME			;Else, loop again

		POST_TRUE
			AND R4, R4, #0 			;Make R4 0
			ADD R4, R4, #1 			;Put a 1 in R4 for flag
			BR DONE

	FALSE
		AND R4, R4, #0				;Make R4 0 if not a palindrome
DONE

LD R0, BACKUP_R0_3400
LD R1, BACKUP_R1_3400
LD R2, BACKUP_R2_3400
LD R3, BACKUP_R3_3400
LD R5, BACKUP_R5_3400
LD R6, BACKUP_R6_3400
LD R7, BACKUP_R7_3400

RET

;-------------------------------------------------
;SUB_IS_A_PALINDROME Data
;-------------------------------------------------
BACKUP_R0_3400			.BLKW			#1
BACKUP_R1_3400			.BLKW			#1
BACKUP_R2_3400			.BLKW			#1
BACKUP_R3_3400			.BLKW			#1
BACKUP_R5_3400			.BLKW			#1
BACKUP_R6_3400			.BLKW			#1
BACKUP_R7_3400			.BLKW			#1
