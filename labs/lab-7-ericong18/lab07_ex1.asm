;=================================================
; Name: Eric
; Email: eong001@ucr.edu
; 
; Lab: lab 7
; Lab section: 24
; TA: Kenneth O'Neal
;=================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------

;-------------------------------
;INSERT CODE STARTING FROM HERE 
;--------------------------------
;Example of how to Output Intro Message
;LD R0, introMessage  ;Output Intro Message
;PUTS

LD R6, SUB_CONVERT
JSRR R6
ADD R5, R5, #1
LD R6, SUB_PRINT
JSRR R6

HALT

;---------------	
;Local Data
;---------------
SUB_CONVERT 			.FILL			x3400
SUB_PRINT			.FILL			x3800


;----------------------------------------------
;Subroutine: SUB_CONVERT_3400
;Input: None
;Post-condition: Decimal value of user-entered
;		 num is stored in R5
;Return value: R5 (contains actual decimal value)
;----------------------------------------------
.ORIG x3400
ST R1, BACKUP_R1_3400
ST R2, BACKUP_R2_3400
ST R3, BACKUP_R3_3400
ST R4, BACKUP_R4_3400
ST R6, BACKUP_R6_3400
ST R7, BACKUP_R7_3400

LD R1, COUNTER_5				;R1 <-- COUNTER_5 (#5) for number of inputs
LD R3, ENTER_SHIFT
LD R4, COUNTER_10				;R4 <-- COUNTER_10 (#10) for multiplying

BEGINNING
	LD R0, introMessage			;Load introMessage into R0
	PUTS					;Output introMessage to console	
	GETC					;User input could be '+', '-', or 'num'
	OUT 					;Output user input
	ADD R0, R0, R3				;Check if 'enter'
	BRz ERROR 				;If so, go to ERROR
	ADD R0, R0, #10				;Restore R0 to its original value

CHECK_SIGN
	ADD R2, R0, #0				;R2 <-- R0

	LD R3, ASCII_PLUS_SHIFT			;R3 <-- #-43
	ADD R2, R2, R3				;Check if input was '+'
	BRz PRE_CONVERT_2 			;Directly go to PRE_CONVERT_2 if '+'
	ADD R2, R2, #15				;Restore R2 to its original value
	ADD R2, R2, #15
	ADD R2, R2, #13

	LD R3, ASCII_MINUS_SHIFT		;R3 <-- #-45
	ADD R2, R2, R3				;Check if input was '-'
	BRz NEGATIVE_PREP			;Go to NEGATIVE if '-'

	BR PRE_CONVERT_1			;Else, go to CONVERT


NEGATIVE_PREP
	ADD R2, R2, #-1				;Flag R2 for later
	BR PRE_CONVERT_2			;Go to PRE_CONVERT_2


PRE_CONVERT_1
	LD R3, NAN				;R3 <-- #-57
	ADD R0, R0, R3				;Check if input (ASCII) > '9'
	BRp ERROR 				;If so, go to ERROR
	ADD R0, R0, #15				;Restore R0 to original value
	ADD R0, R0, #15
	ADD R0, R0, #15
	ADD R0, R0, #12

	LD R3, DEC_SHIFT			;R3 <-- #-48
	ADD R0, R0, R3				;R0 <-- Actual decimal value of user input
	BRn ERROR 				;Go to ERROR if input (ASCII) is < '0'
	ADD R5, R0, #0				;R5 <-- R0
	ADD R1, R1, #-1				;Decrement input counter (counted from before)
CONVERT_1 
	GETC					;Get next 'num' from user
	OUT 					;Output to console

	LD R3, ENTER_SHIFT			;R3 <-- #-10
	ADD R0, R0, R3				;Check if input was 'enter'
	BRz LAST_CHECK				;If 'enter', then go to LAST_CHECK
	ADD R0, R0, #10				;Restore R0 to its original value

	LD R3, NAN				;R3 <-- #-57
	ADD R0, R0, R3				;Check if input (ASCII) > '9'
	BRp ERROR 				;If so, go to ERROR
	ADD R0, R0, #15				;Restore R0 to original value
	ADD R0, R0, #15
	ADD R0, R0, #15
	ADD R0, R0, #12

	LD R3, DEC_SHIFT			;R3 <-- #-48
	ADD R0, R0, R3				;R0 <-- Actual decimal value of user input
	BRn ERROR
	ADD R3, R5, #0				;R3 <-- R5 (used for multiplying)
	ADD R4, R4, #-1				;Pre-decrement counter for multiplying (0, 1,...9)
	MULTIPLY_1
		ADD R5, R5, R3			;R5 <-- R5 + R3
		ADD R4, R4, #-1			;Decrement multiplication counter
		BRp MULTIPLY_1 			;Loop 10 times
	LD R4, COUNTER_10			;Reset multiplying counter
	ADD R5, R5, R0				;R5 <-- R5 + R0
	ADD R1, R1, #-1				;Decrement input counter
	BRp CONVERT_2 				;Loop until max 5 inputs

	LD R0, NEWLINE
	OUT
	ADD R2, R2, #0				;Make R2 LMF bc of flag (R2 is #-1 or #0)
	BRn NEGATIVE  				;Go to NEGATIVE if flag was set to #-1
	BR ENDING 				;Else, go to ENDING
	

PRE_CONVERT_2
	GETC					;Get first 'num' from user
	OUT 					;Output to console

	LD R3, ENTER_SHIFT			;R3 <-- #-10
	ADD R0, R0, R3				;Check if 'enter'
	BRz ERROR 				;If first input is 'enter', go to ERROR branch; else, continue on
	ADD R0, R0, #10				;Restore R0 to its original value

	LD R3, NAN				;R3 <-- #-57
	ADD R0, R0, R3				;Check if input (ASCII) > '9'
	BRp ERROR 				;If so, go to ERROR
	ADD R0, R0, #15				;Restore R0 to original value
	ADD R0, R0, #15
	ADD R0, R0, #15
	ADD R0, R0, #12

	LD R3, DEC_SHIFT			;R3 <-- #-48
	ADD R0, R0, R3				;R0 <-- Actual decimal value of user input
	BRn ERROR
	ADD R5, R0, #0				;R5 <-- R0
	ADD R1, R1, #-1				;Decrement counter (max 5)
CONVERT_2
	GETC					;Get next 'num' from user
	OUT 					;Output to console

	LD R3, ENTER_SHIFT			;R3 <-- #-10
	ADD R0, R0, R3				;Check if input was 'enter'
	BRz LAST_CHECK				;If 'enter', then go to LAST_CHECK
	ADD R0, R0, #10				;Restore R0 to its original value

	LD R3, NAN				;R3 <-- #-57
	ADD R0, R0, R3				;Check if input (ASCII) > '9'
	BRp ERROR 				;If so, go to ERROR
	ADD R0, R0, #15				;Restore R0 to original value
	ADD R0, R0, #15
	ADD R0, R0, #15
	ADD R0, R0, #12

	LD R3, DEC_SHIFT			;R3 <-- #-48
	ADD R0, R0, R3				;R0 <-- Actual decimal value of user input
	BRn ERROR
	ADD R3, R5, #0				;R3 <-- R5 (used for multiplying)
	ADD R4, R4, #-1				;Pre-decrement counter for multiplying (0, 1,...9)
	MULTIPLY_2
		ADD R5, R5, R3			;R5 <-- R5 + R3
		ADD R4, R4, #-1			;Decrement multiplication counter
		BRp MULTIPLY_2 			;Loop 10 times
	LD R4, COUNTER_10			;Reset multiplying counter
	ADD R5, R5, R0				;R5 <-- R5 + R0
	ADD R1, R1, #-1				;Decrement input counter
	BRp CONVERT_2 				;Loop until max 5 inputs

	LD R0, NEWLINE
	OUT
	ADD R2, R2, #0				;Make R2 LMF bc of flag (R2 is #-1 or #0)
	BRn NEGATIVE  				;Go to NEGATIVE if flag was set to #-1
	BR ENDING 				;Else, go to ENDING

ERROR
	LD R0, NEWLINE				;Newline after last input and before error message
	OUT 					;Print newline
	LD R0, errorMessage 			;Load errorMessage into R0
	PUTS 					;Output error to console
	AND R5, R5, #0				;Reset R5 to 0
	LD R1, COUNTER_5			;Reset R1's counter value to 5
	LD R3, ENTER_SHIFT			;Reset R3's first original value
	BR BEGINNING				;Start over from BEGINNING

LAST_CHECK
	ADD R2, R2, #0				;Make R2 LMF
	BRn NEGATIVE 				;Go to NEGATIVE
	BR ENDING

NEGATIVE 					;Taking two's complement of R5
	NOT R5, R5				;Flip R5
	ADD R5, R5, #1				;Add 1

ENDING

LD R1, BACKUP_R1_3400
LD R2, BACKUP_R2_3400
LD R3, BACKUP_R3_3400
LD R4, BACKUP_R4_3400
LD R6, BACKUP_R6_3400
LD R7, BACKUP_R7_3400

RET

;Example of how to Output Error Message
;LD R0, errorMessage  ;Output Error Message
;PUTS

;---------------------	
;SUB_CONVERT_3400 Data
;---------------------
COUNTER_5		.FILL			#5
COUNTER_10		.FILL			#10
ASCII_PLUS_SHIFT	.FILL			#-43
ASCII_MINUS_SHIFT	.FILL			#-45
DEC_SHIFT		.FILL			#-48
ENTER_SHIFT		.FILL			#-10
NAN			.FILL			#-57
NEWLINE			.STRINGZ		"\n"

BACKUP_R1_3400		.BLKW			#1
BACKUP_R2_3400		.BLKW			#1
BACKUP_R3_3400		.BLKW			#1
BACKUP_R4_3400		.BLKW			#1
BACKUP_R6_3400		.BLKW			#1
BACKUP_R7_3400		.BLKW			#1

introMessage 		.FILL 			x6000
errorMessage 		.FILL 			x6100


;----------------------------------------------
;Subroutine: SUB_PRINT_3800
;Input (None): R5
;Post-condition: Prints out the decimal value
;		 stored in R5
;Return value: None
;----------------------------------------------
.ORIG x3800

ST R1, BACKUP_R1_3800
ST R2, BACKUP_R2_3800
ST R3, BACKUP_R3_3800
ST R4, BACKUP_R4_3800
ST R5, BACKUP_R5_3800
ST R6, BACKUP_R6_3800
ST R7, BACKUP_R7_3800

ADD R1, R5, #0					;R1 <-- R5 (contains decimal)
ADD R6, R5, #0 					;R6 <-- R5 (also contains same decimal)
AND R3, R3, #0					;R3 <-- #0
ADD R5, R5, #0					;Make R5 LMF
BRn NEGATIVE_PRINT 				;Go to NEGATIVE if R5 is negative
BR PRECHECK					;Else, just skip it

NEGATIVE_PRINT
	LD R0, ASCII_MINUS 			;R0 <-- '-'
	OUT
	NOT R5, R5 				;2's complement for negative decimals
	ADD R5, R5, #1
	ADD R1, R5, #0
	ADD R6, R5, #0

PRECHECK					;Decide which loop to start from
	LD R2, DEC_10K
	ADD R1, R1, R2 				;Check if 10K loop
	BRzp PRE_10K 				;If so, go to PRE_10K
	ADD R1, R6, #0				;Restore R1 to original value

	LD R2, DEC_1K 				;Check if 1K loop
	ADD R1, R1, R2
	BRzp PRE_1K 
	ADD R1, R6, #0

	LD R2, DEC_100 				;Check if 100 loop
	ADD R1, R1, R2 
	BRzp PRE_100
	ADD R1, R6, #0

	LD R2, DEC_10 				;Check if 10 loop
	ADD R1, R1, R2
	BRzp PRE_10
	ADD R1, R6, #0

	BR PRE_1 				;Else, you have to go to 1 loop

	PRE_10K
		ADD R1, R6, #0
		LD R2, DEC_10K			;R2 <-- #-10000
		BR CHECK_10K_LOOP

	PRE_1K
		ADD R1, R6, #0
		LD R2, DEC_1K			;R2 <-- #-1000
		BR CHECK_1K_LOOP

	PRE_100
		ADD R1, R6, #0
		LD R2, DEC_100			;R2 <-- #-100
		BR CHECK_100_LOOP

	PRE_10
		ADD R1, R6, #0
		LD R2, DEC_10			;R2 <-- #-10
		BR CHECK_10_LOOP

	PRE_1
		ADD R1, R6, #0
		LD R2, DEC_1			;R2 <-- #-1
		BR CHECK_1_LOOP


CHECK_10K_LOOP
	ADD R4, R1, #0				;Make a copy of R1 in R4
	ADD R1, R1, R2 				;Subtract 10000
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
	LD R2, DEC_1K				;R2 <-- #-1000
	ADD R4, R1, #0				;Make a copy of R1 in R4
	ADD R1, R1, R2 				;Subtract 1000
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
	LD R2, DEC_100				;R2 <-- #-100
	ADD R4, R1, #0				;Make a copy of R1 in R4
	ADD R1, R1, R2 				;Subtract 100
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
	LD R2, DEC_10				;R2 <-- #-10
	ADD R4, R1, #0				;Make a copy of R1 in R4
	ADD R1, R1, R2 				;Subtract 10
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
	LD R2, DEC_1				;R2 <-- #-1 
	ADD R4, R1, #0				;Make a copy of R1 in R4
	ADD R1, R1, R2 				;Subtract 1
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

LD R0, NEWLINE_2
OUT

LD R1, BACKUP_R1_3800
LD R2, BACKUP_R2_3800
LD R3, BACKUP_R3_3800
LD R4, BACKUP_R4_3800
LD R5, BACKUP_R5_3800
LD R6, BACKUP_R6_3800
LD R7, BACKUP_R7_3800

RET

;---------------------	
;SUB_PRINT_3800 Data
;---------------------
DEC_10K			.FILL			#-10000
DEC_1K 			.FILL			#-1000
DEC_100			.FILL 			#-100
DEC_10 			.FILL 			#-10
DEC_1 			.FILL			#-1
ASCII_MINUS 		.FILL 			#45
NEWLINE_2 		.STRINGZ 		"\n"

BACKUP_R1_3800		.BLKW			#1
BACKUP_R2_3800		.BLKW			#1
BACKUP_R3_3800		.BLKW			#1
BACKUP_R4_3800		.BLKW			#1
BACKUP_R5_3800		.BLKW			#1
BACKUP_R6_3800		.BLKW			#1
BACKUP_R7_3800		.BLKW			#1


;------------
;Remote data
;------------
.ORIG x6000
;---------------
;messages
;---------------
intro .STRINGZ	"Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"
;---------------
;error_messages
;---------------
.ORIG x6100	
error_mes .STRINGZ	"ERROR INVALID INPUT\n"

;---------------
;END of PROGRAM
;---------------
.END
;-------------------
;PURPOSE of PROGRAM
;-------------------