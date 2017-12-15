;=================================================
; Name: Eric Ong
; Email: eong001@ucr.edu
; 
; Assignment name: Assignment 3
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
LD R6, Convert_addr		; R6 <-- Address pointer for Convert
LDR R1, R6, #0			; R1 <-- VARIABLE Convert
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
LD R2, COUNTER			; Load counter val 16 to R2
LD R3, SPACE_COUNT		; Load counter val 4 to R3 for spaces
ADD R1, R1, #0			; Make sure R1 is LMF

BRzp  IS_POSITIVE           	; Jumps to IS_NEGATIVE
IS_NEGATIVE
    LD R0, ASCII_ONE		; Load '1' into R0
    OUT                     	; Output '1' to console
    BRnzp  END_CHECK		; Jumps to END_CHECK

IS_POSITIVE
    LD R0, ASCII_ZERO		; Load '0' into R0
    OUT				; Output '0' to console
END_CHECK

ADD R3, R3, #-1			; Decrement space counter by 1 to account for first bit
ADD R2, R2, #-1			; Decrement counter by 1 to account for first bit	

WHILE_LOOP
    ADD R1, R1, R1		; Bit shift to left <<
    ADD R1, R1, #0		; Make sure R1 is LMF
    BRp  POSITIVE		; Jumps to POSITIVE if bit shifting is pos
    BRn  NEGATIVE		; Jumps to NEGATIVE if bit shifting is neg

    POSITIVE
        LD R0, ASCII_ZERO	; Load '0' into R0
	OUT                     ; Output '0' to console
	BR     CHECK_COUNT	; Go back to top of loop regardless

    NEGATIVE
	LD R0, ASCII_ONE	; Load '1' into R1
	OUT			; Output '1' to console
	BRnzp  CHECK_COUNT	; Go back to top of loop regardless

    CHECK_COUNT
	ADD R2, R2, #-1		; Decrement counter by 1
    	BRz  END_WHILE_LOOP     ; Go to end of loop if counter reaches 0
	BRnp CHECK_SPACE	; Otherwise, proceed to check spaces

    CHECK_SPACE
	ADD R3, R3, #-1		; Decrement space counter by 1
	BRp    WHILE_LOOP	; If greater than 0, loop again
	LEA R0, SPACE		; Load " " to R0
	PUTS			; Output " " to console
	LD R3, SPACE_COUNT	; Reload space counter after printing space
	BR     WHILE_LOOP	; Go back to top of loop
END_WHILE_LOOP

LD R0, NEWLINE			; Load NEWLINE to R0
OUT				; Print NEWLINE at very end


HALT
;---------------	
;Data
;---------------
Convert_addr	.FILL  		xD000		; The address of where to find the data
COUNTER	     	.FILL  		#16		; Counter to loop from 15 to 0
SPACE_COUNT  	.FILL  		#4		; Counter for space after every 4 bits
ASCII_ZERO   	.FILL  		#48		; ASCII value for char '0'
ASCII_ONE    	.FILL  		#49		; ASCII value for char '1'
SPACE	     	.STRINGZ	" "		; String for " "
NEWLINE	     	.FILL  		#10		; ASCII value for char '/n'

.ORIG xD000			; Remote data
Convert .FILL xABCD		; <----!!!NUMBER TO BE CONVERTED TO BINARY!!!
;---------------	
;END of PROGRAM
;---------------	
.END
