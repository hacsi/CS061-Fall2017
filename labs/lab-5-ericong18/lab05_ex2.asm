;=================================================
; Name: Eric Ong
; Email: eong001@ucr.edu
; 
; Lab: lab 5
; Lab section: 24
; TA: Kenneth O'Neal
; 
;=================================================

.ORIG x3000
;-------------------
;Instructions
;-------------------
LD  R1, ARRAY_1_PTR				;R1 points to first index of ARRAY_1
LD  R4, COUNT 					;Put counter value in R4

DO_WHILE_LOOP
	STR  R3, R1, #0				;R3 -> Mem[R1 + #0]
	ADD  R3, R3, #1				;Increment R3 by 1
	ADD  R1, R1, #1				;Go to next array index
	ADD  R4, R4, #-1			;Decrement R4 counter by 1
	BRp	 DO_WHILE_LOOP 			;Loop again while positive
END_DO_WHILE_LOOP

LD  R4, COUNT 					;Reload counter to R4
LD  R1, ARRAY_1_PTR				;Repoint ARRAY_1 to first array index
DO_WHILE_LOOP_2
	LDR  R0, R1, #0				;R0 <-- Mem[R1]
	ADD  R0, R0, #12			;Convert R0 decimal to corresponding character
	ADD  R0, R0, #12
	ADD  R0, R0, #12
	ADD  R0, R0, #12
	OUT					;Output character to console
	ADD  R1, R1, #1				;Go to next array index
	ADD  R4, R4, #-1			;Decrement counter
	BRp  DO_WHILE_LOOP_2 			;Loop again while positive
END_DO_WHILE_LOOP_2

HALT

;-------------------
;Data
;-------------------
ARRAY_1_PTR		.FILL	x4000	;Fill pointer to x4000 memory address
COUNT			.FILL   #10		;Counter to count number of times to fill array


;-------------------
;Remote Data
;-------------------
.ORIG x4000
ARRAY_1			.BLKW	#10		;Reserve 10 memory locations for an array

.END
