;=================================================
; Name: Eric Ong
; Email: eong001@ucr.edu
; 
; Lab: lab 4
; Lab section: 24
; TA: Kenneth O'Neal
; 
;=================================================

.ORIG x3000

;----------------
;INSTRUCTIONS
;----------------
LD  R5, DATA_PTR	;R5 <- x4000

LDR R3, R5, #0		;R3 <- Mem[x4000] == Mem[R5 + 0] 
			;R3 <- #65
ADD R3, R3, #1		;R3 <- R3 + 1 (#66)
STR R3, R5, #0		;R3 (#66) -> Mem[R5 + 0] == Mem[x4000]

ADD R5, R5, #1		;R5 <- R5 + 1
			;R5 <- x4001

LDR R4, R5, #0		;R4 <- Mem[x4001] == Mem[R5 + 0]
			;R4 <- x41
ADD R4, R4, #1		;R4 <- R4 + 1 (x42)
STR R4, R5, #0		;R4 (#66) -> Mem[R5 + 0] == Mem[x4000]


HALT

;----------------
;Data
;----------------
DATA_PTR	.FILL	x4000

;----------------
;Remote Data
;----------------
.ORIG x4000
.FILL	#65		;x4000 <- #65
.FILL	x41		;x4001 <- x41

.END
