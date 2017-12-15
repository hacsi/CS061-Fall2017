;=================================================
; Name: Eric Ong
; Email: eong001@ucr.edu
; 
; Lab: lab 2
; Lab section: 24
; TA: Kenneth O'Neal
; 
;=================================================

.ORIG x3000

LEA R0, MSG_TO_PRINT ;labels R0 as MSG_TO_PRINT
PUTS 		     ;prints string character-by-character starting at R0
HALT 		     ;ends program

MSG_TO_PRINT .STRINGZ "Hello world!!!\n"

.END

