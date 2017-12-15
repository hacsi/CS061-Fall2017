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
    ;------------
    ;Instructions
    ;------------
    LD R1, DEC_0	;Stores value of DEC_0 in register R1
    LD R2, DEC_12       ;Stores value of DEC_12 in register R2
    LD R3, DEC_6	;Stores value of DEC_6
	
    DO_WHILE_LOOP
        ADD R1, R1, R2		;R1 <-- R1 + R2
				;Adds 6 to R1, which starts at 0
        ADD R3, R3, #-1		;R3 <-- R3 + (-1)
				;Decreases loop counter by 1 each time
	BRp DO_WHILE_LOOP	;Keep looping while R3 > 0 
    END_DO_WHILE_LOOP

    HALT
    ;------------
    ;Local data
    ;------------
    DEC_0    .FILL    #0	;puts decimal 0 into DEC_0
    DEC_12   .FILL    #12       ;puts decimal 12 into DEC_12
    DEC_6    .FILL    #6	;puts decimal 6 into DEC_6

.END

    

