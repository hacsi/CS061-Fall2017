;=================================================
; Name: Eric Ong
; Email:  eong001@ucr.edu
; 
; Lab: lab 6
; Lab section: 24
; TA: Kenneth O'Neal
; 
;=================================================

.ORIG x3000
;-----------------
;Instructions
;-----------------
LD  R5, SUB_CONVERT			;R5 <-- x3200
JSRR R5					;Jump to SUB_CONVERT subroutine
ADD R2, R1, #0				;Put contents of R1 (total) into R2
LD  R5, SUB_PRINT			;R5 <-- x3400
JSRR R5					;Jump to SUB_PRINT

HALT

;-----------------
;Local data
;-----------------
SUB_CONVERT		.FILL		x3200
SUB_PRINT		.FILL		x3400



;----------------------------------------------
;Subroutine: SUB_CONVERT_3200
;Input (None):
;Post-condition: The user entered 16-bit binary number
;		 is converted to a single value 16-bit
;		 binary number
;Return value: R1 <-- 16-bit value
;----------------------------------------------
.ORIG x3200
ST R7, BACKUP_R7_3200
ST R4, BACKUP_R4_3200
ST R5, BACKUP_R5_3200

LD R1, TOTAL				;R1 <-- TOTAL == #0
LD R3, COUNTER				;Load 16 counter into R3
LD R5, ASCII_SHIFT			;Load #-49 into R5
LEA R0, PROMPT				;Load PROMPT into R0
PUTS					;Output PROMPT to console
GETC					;Get user input 'b' stored in R0

DO_WHILE_LOOP
	GETC				;Get '1' or '0' from user input
	ADD R4, R0, #0			;Store user-entered char '1' or '0' into R4
	ADD R3, R3, #0			;Make counter LMF
	BRp  CALCULATE			;Go to CALCULATE branch if there is more input
	ADD R4, R4, R5			;Check if '1' or '0'
	BRz  ONE
	BRn  ZERO

	CALCULATE
		ADD R1, R1, R1		;Double R1
		ADD R4, R4, #0		;Make R4 LMF
		ADD R4, R4, R5		;Check if '1' or '0'
		BRz ONE			;Go to ONE branch if '1'
		BRn ZERO		;Go to ZERO branch if '0'

	ONE
		ADD R1, R1, #1		;R1 <-- R1 + #1
		ADD R3, R3, #-1		;Decrement counter
		BRz END_DO_WHILE_LOOP	;Go to end of loop
		BRp DO_WHILE_LOOP

	ZERO
		ADD R3, R3, #-1		;Decrement counter
		BRz END_DO_WHILE_LOOP	;Go to end of loop
		BRp DO_WHILE_LOOP	;Loop again if counter is still positive
END_DO_WHILE_LOOP

LD R7, BACKUP_R7_3200
LD R4, BACKUP_R4_3200

RET

;-----------------
;SUB_CONVERT Data
;-----------------
PROMPT			.STRINGZ	"Enter 'b' and 16 binary digits\n"
TOTAL			.FILL		#0
COUNTER			.FILL		#16
ASCII_SHIFT		.FILL		#-49

BACKUP_R4_3200		.BLKW		#1
BACKUP_R7_3200		.BLKW		#1
BACKUP_R5_3200		.BLKW		#1


;---------------------------------------------------
;Subroutine: SUB_PRINT_3400
;Input (R2): 16-bit value of the binary number
;Post-condition: Prints out the value of the 16-bit
;		 binary number
;Return value: None
;---------------------------------------------------
.ORIG x3400
ST  R2, BACKUP_R2_3400
ST  R7, BACKUP_R7_3400
ST  R4, BACKUP_R4_3400

LD  R6, SPACE_COUNT				;Load space counter into R6
LD  R4, COUNT_16				;Load counter for 16-bit binary

LD R0, CHAR_b					;Load 'b' into R0
OUT						;Output 'b' to console
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

LD  R2, BACKUP_R2_3400
LD  R7, BACKUP_R7_3400
LD  R4, BACKUP_R4_3400

RET

;-----------------
;SUB_PRINT Data
;-----------------
ASCII_ZERO   	.FILL  		#48		;ASCII value for char '0'
ASCII_ONE    	.FILL  		#49		;ASCII value for char '1'
SPACE	     	.STRINGZ	" "		;String for " "
NEWLINE	     	.FILL  		#10		;ASCII value for char '/n'
COUNT_16	.FILL  		#16		;Counter to loop from 15 to 0
SPACE_COUNT  	.FILL  		#4		;Counter for space after every 4 bits
CHAR_b		.FILL		#98		;ASCII value for 'b'

BACKUP_R2_3400	.BLKW		#1
BACKUP_R7_3400	.BLKW		#1
BACKUP_R4_3400	.BLKW		#1


.END
