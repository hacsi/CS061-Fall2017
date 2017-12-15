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
LD  R2, DEC_1					;Load 2 into R2

DO_WHILE_LOOP
	STR R2, R1, #0				;R2 --> Mem[R1 + #0]
	ADD R2, R2, R2				;R2 >> 2 (multiply by 2)
	ADD R1, R1, #1				;Go to next array index
	ADD R4, R4, #-1				;Decrement R4 counter
	BRp DO_WHILE_LOOP 			;Loop again while positive
END_DO_WHILE_LOOP

LD  R1, ARRAY_1_PTR 				;Repoint R1 to first array index
LD  R4, COUNT_6					;Put new counter value in R4
DO_WHILE_LOOP_2
	ADD R1, R1, #1				;Go to next array index location
	ADD R4, R4, #-1				;Decrement R4 counter
	BRp DO_WHILE_LOOP_2 			;Loop again while positive
END_DO_WHILE_LOOP_2				;R1 should be at 7th index (6)

LDR R2, R1, #0					;R2 <-- Mem[R1 + #0]

HALT

;-------------------
;Data
;-------------------
ARRAY_1_PTR		.FILL	x4000		;Fill pointer to x4000 memory address
COUNT			.FILL   #10		;Counter to count number of times to fill array
COUNT_6			.FILL   #6		;Counter to get to 7th array index (6)
DEC_1			.FILL   #1		;Used as starting binary number 2^0


;-------------------
;Remote Data
;-------------------
.ORIG x4000
ARRAY_1			.BLKW	#10		;Reserve 10 memory locations for an array

.END
