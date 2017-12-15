;=================================================
; Name: Eric Ong
; Email: eong001@ucr.edu
; 
; Assignment name: Assignment 2
; Lab section: 24
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team.
;
;=================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------

;----------------------------------------------
;outputs prompt
;----------------------------------------------	
LEA R0, intro			; 
PUTS				; Invokes BIOS routine to output string

;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
GETC				;Asks user for input stored in R0
OUT				;Echoes value in R0
ADD  R1, R0, #0			;R1 <- R0 + (0)
LD R0, NEWLINE			;Stores newline character into R0
OUT				;Prints out the newline character

GETC				;Asks user for input again, stored in R0
OUT				;Echoes value in R0
ADD  R2, R0, #0			;R2 <- R0 + (0)
LD R0, NEWLINE			;Stores newline character into R0
OUT				;Prints out the newline character

;------------------------------
;PRINT OUT EXPRESSION
;------------------------------
ADD R0, R1, #0
OUT
LEA R0, MINUS
PUTS
ADD R0, R2, #0
OUT
LEA R0, EQUALS
PUTS


ADD  R1, R1, #-16		;Converts char in R1 into actual decimal
ADD  R1, R1, #-16
ADD  R1, R1, #-16

ADD  R2, R2, #-16		;Converts char in R2 into actual decimal
ADD  R2, R2, #-16
ADD  R2, R2, #-16

NOT  R2, R2			;R2 <- NOT R2
ADD  R2, R2, #1			;Makes R2's value negative

ADD  R3, R1, R2			;R3 <- R1 + (-R2)

BRn  IS_NEGATIVE		;if R3 < 0, go to IS_NEGATIVE

IS_POSITIVE
	ADD R3, R3, #12		;Converts result to char
	ADD R3, R3, #12
	ADD R3, R3, #12
	ADD R3, R3, #12
	ADD R0, R3, #0		;Stores char result to R0
	OUT			;Outputs char result to console
	LD R0, NEWLINE		;Stores newline character into R0
	OUT			;Prints out the newline character
	HALT

IS_NEGATIVE
	NOT R3, R3		;Flip result
	ADD R3, R3, #1		;Convert result to positive
	ADD R3, R3, #12		;Convert positive result to char
	ADD R3, R3, #12
	ADD R3, R3, #12
	ADD R3, R3, #12
	LD  R0, ASCII_MINUS	;Stores "-" in R0
	OUT			;Outputs "-" to console
	ADD R0, R3, #0		;Stores char result to R0
	OUT			;Outputs char result to console
	LD R0, NEWLINE		;Stores newline character into R0
	OUT			;Prints out the newline character

HALT				;Stop execution of program
;------	
;Data
;------
; String to explain what to input 
intro .STRINGZ	"ENTER two numbers (i.e '0'....'9')\n" 
NEWLINE .STRINGZ "\n"	; String that holds the newline character

MINUS .STRINGZ  " - "
EQUALS .STRINGZ " = "

ASCII_MINUS  .FILL  #45   ;ASCII Code for "-"

;---------------	
;END of PROGRAM
;---------------	
.END

