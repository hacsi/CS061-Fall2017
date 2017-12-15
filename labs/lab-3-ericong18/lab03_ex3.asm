;=================================================
; Name: Eric Ong	
; Email: eong001@ucr.edu
; 
; Lab: lab 3
; Lab section: 24
; TA: Kenneth O'Neal
; 
;=================================================

.ORIG x3000

;------------------
;INSTRUCTIONS
;------------------
LD R5, DEC_65_PTR
LD R6, HEX_41_PTR

LDR R3, R5, #0
LDR R4, R6, #0

ADD R3, R3, #1
ADD R4, R4, #1

STR R3, R5, #0
STR R4, R6, #0

HALT

;------------------
;Data
;------------------
DEC_65_PTR  .FILL  x4000
HEX_41_PTR  .FILL  x4001

;------------------
;Remote Data
;------------------
.ORIG x4000
DEC_65  .FILL  #65
HEX_41  .FILL  x41



