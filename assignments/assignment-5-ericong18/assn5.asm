;=================================================
; Name: Eric Ong
; Email: eong001@ucr.edu
; 
; Assignment name: Assignment 5
; Lab section: 24
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team.
;
;=================================================

.ORIG x3000						;Program begins here
;-------------
;Instructions
;-------------
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
OPTIONS
LD R6, MENU 						;Load subroutine MENU address into R6 
JSRR R6 						;Go to x3200 for MENU

ADD R1, R1, #-1 					;Check if option 1
BRz ONE 						;If so, go to ONE

ADD R1, R1, #-1 					;Check if option 2
BRz TWO 						;If so, go to TWO

ADD R1, R1, #-1 					;Check if option 3
BRz THREE 						;If so, go to THREE

ADD R1, R1, #-1 					;Check if option 4
BRz FOUR 						;If so, go to FOUR

ADD R1, R1, #-1 					;Check if option 5
BRz FIVE 						;If so, go to FIVE

ADD R1, R1, #-1 					;Check if option 6
BRz SIX 						;If so, go to SIX

ADD R1, R1, #-1 					;Check if option 7
BRz SEVEN 						;If so, go to SEVEN

ONE 
	LD R6, ALL_MACHINES_BUSY 			;Load subroutine ALL_MACHINES_BUSY into R6
	JSRR R6 					;Go to x3400 for ALL_MACHINES_BUSY
	ADD R2, R2, #-1 				;Check if R2 is 0 or 1
	BRz IS_BUSY 					;1 is busy
	BRn NOT_BUSY 					;0 is not busy

	IS_BUSY
		LEA R0, ALLBUSY 			;Load ALLBUSY message into R0 
		PUTS 					;Print message
		BR END_1

	NOT_BUSY
		LEA R0, ALLNOTBUSY 			;Load ALLNOTBUSY message into R0 
		PUTS 					;Print message 
	END_1
	ADD R2, R2, #1 					;Restore R2 to original value
	BR OPTIONS

TWO
	LD R6, ALL_MACHINES_FREE 			;Load subroutine ALL_MACHINES_FREE into R6
	JSRR R6 					;Go to x3600 for ALL_MACHINES_FREE
	ADD R2, R2, #-1 				;Check if R2 is 0 or 1
	BRz IS_FREE 					;1 is free
	BRn NOT_FREE 					;0 is not free

	IS_FREE
		LEA R0, FREE 				;Load FREE message into R0 
		PUTS 					;Print message 
		BR END_2 

	NOT_FREE
		LEA R0, NOTFREE 			;Load NOTFREE message into R0
		PUTS 					;Print message
	END_2
	BR OPTIONS

THREE
	LD R6, NUM_BUSY_MACHINES 			;Load subroutine NUM_BUSY_MACHINES into R6
	JSRR R6 					;Go to x3800 for NUM_BUSY_MACHINES

	LEA R0, BUSYMACHINE1 				;Load first part of message into R0 
	PUTS						;Output to console
	LD R6, PRINT_NUM  				;Load subroutine PRINT_NUM into R6
	JSRR R6 					;Go to x4800 for PRINT_NUM
	LEA R0, BUSYMACHINE2 				;Load second part of message into R0
	PUTS 						;Output to console

	BR OPTIONS

FOUR
	LD R6, NUM_FREE_MACHINES 			;Load subroutine NUM_FREE_MACHINES into R6
	JSRR R6 					;Go to x4000 for NUM_FREE_MACHINES

	LEA R0, FREEMACHINE1 				;Load first part of message into R0
	PUTS 						;Output to console
	LD R6, PRINT_NUM 				;Load subroutine PRINT_NUM into R6 
	JSRR R6 					;Go to x4800 for PRINT_NUM 
	LEA R0, FREEMACHINE2 				;Load second part of message into R0
	PUTS 						;Output to console

	BR OPTIONS

FIVE
	LD R6, GET_INPUT 				;Load subroutine GET_INPUT into R6
	JSRR R6 					;Go to x4600 for GET_INPUT (return R1 with some value 0 - 15)
	LD R6, MACHINE_STATUS 				;Load subroutine MACHINE_STATUS into R6
	JSRR R6 					;Go to x4200 for MACHINE_STATUS

	LEA R0, STATUS1 				;Load R0 with first part of message
	PUTS
	ADD R2, R2, #0 					;Make R2 LMF 
	BRz BUSY_MACHINE 				;If R2 is 0, machine is busy 
	BR FREE_MACHINE 				;Else (R2 is 1), machine is free

	BUSY_MACHINE
		ADD R2, R1, #0 				;R2 <-- R1 to print machine number
		LD R6, PRINT_NUM 			;Load subroutine PRINT_NUM into R6 
		JSRR R6 				;Go to x4800 for PRINT_NUM
		LEA R0, STATUS2 			;Load R0 with second part of (busy) message
		PUTS 					;Output to console
		BR END_5

	FREE_MACHINE
		ADD R2, R1, #0 				;R2 <-- R1 to print machine number
		LD R6, PRINT_NUM 			;Load subroutine PRINT_NUM into R6 
		JSRR R6 				;Go to x4800 for PRINT_NUM
		LEA R0, STATUS3 			;Load R0 with second part of (busy) message
		PUTS 					;Output to console

	END_5
	BR OPTIONS

SIX
	LD R6, FIRST_FREE 	 			;Load subroutine FIRST_FREE into R6
	JSRR R6 					;Go to x4400 for FIRST_FREE

	ADD R2, R2, #0 					;Make R2 LMF
	BRn NONE_FREE 					;If -1, none are free

	LEA R0, FIRSTFREE 				;Load R0 with first part of message
	PUTS 						;Output to console 
	LD R6, PRINT_NUM 				;Load subroutine PRINT_NUM into R6 
	JSRR R6 					;Go to x4800 to print number in R2
	LEA R0, FIRSTFREE2 				;Load R0 with second part of message 
	PUTS
	BR END_6

	NONE_FREE
		LEA R0, FIRSTFREE3 			;Load R0 with none free message
		PUTS 					;Output to console

	END_6
	BR OPTIONS

SEVEN
	LEA R0, Goodbye 				;Load exit message
	PUTS 						;Output message

HALT
;---------------	
;Data
;---------------
;Add address for subroutines
MENU 				.FILL 			x3200
ALL_MACHINES_BUSY 		.FILL 			x3400
ALL_MACHINES_FREE 		.FILL 			x3600
NUM_BUSY_MACHINES 		.FILL 			x3800
NUM_FREE_MACHINES 		.FILL 			x4000
MACHINE_STATUS 			.FILL 			x4200
FIRST_FREE 			.FILL 			x4400
GET_INPUT 			.FILL 			x4600
PRINT_NUM 			.FILL 			x4800

;Other data

;Strings for options
Goodbye .STRINGZ "Goodbye!\n"
ALLNOTBUSY .STRINGZ "Not all machines are busy\n"
ALLBUSY .STRINGZ "All machines are busy\n"
FREE .STRINGZ "All machines are free\n"
NOTFREE .STRINGZ "Not all machines are free\n"
BUSYMACHINE1 .STRINGZ "There are "
BUSYMACHINE2 .STRINGZ " busy machines\n"
FREEMACHINE1 .STRINGZ "There are "
FREEMACHINE2 .STRINGZ " free machines\n"
STATUS1 .STRINGZ "Machine "
STATUS2  .STRINGZ " is busy\n"
STATUS3 .STRINGZ " is free\n"
FIRSTFREE .STRINGZ "The first available machine is number "
FIRSTFREE2 .STRINGZ "\n"
FIRSTFREE3 .STRINGZ "No machines are free\n"


;-------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options,
;		 allowed the user to select an option, and returned the selected 
;		 option.
; Return Value (R1): The option selected:  #1, #2, #3, #4, #5, #6 or #7
; 		     no other return value is possible
;-------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine MENU
;--------------------------------
.ORIG x3200
;HINT back up 
ST R0, BACKUP_R0_3200
ST R2, BACKUP_R2_3200
ST R7, BACKUP_R7_3200

USER_INPUT
	LD R0, Menu_string_addr 			;Load R0 with menu string
	PUTS 						;Output prompt
	GETC						;Get user input
	OUT 						;Output what user types
	LD R2, DEC_MINUS_48 				;R2 <-- #-48
	ADD R0, R0, R2 					;Check if input is less than '1'
	BRnz ERROR_INPUT				;If negative or zero, go to ERROR_INPUT
	LD R2, DEC_PLUS_48 				;R2 <-- #48
	ADD R0, R0, R2 					;Restore R0 to original value

	LD R2, DEC_MINUS_56 				;R2 <-- #-56
	ADD R0, R0, R2 					;Check if input is greater than '7'
	BRzp ERROR_INPUT 				;If zero or positive, go to ERROR_INPUT
	LD R2, DEC_PLUS_56 				;R2 <-- #56
	ADD R0, R0, R2 					;Restore R0 back to original value
	BR FINISH_INPUT 				;Input is valid!

	ERROR_INPUT
		LD R0, NEWLINE 				;Load newline char into R0
		OUT 					;Output newline
		LEA R0, Error_message_1 		;Load R0 with error message
		PUTS 					;Output error message
		BR USER_INPUT 				;Loop again to check input

FINISH_INPUT
LD R2, DEC_MINUS_48 					;R2 <-- #-48
ADD R0, R0, R2 						;Convert to decimal value
ADD R1, R0, #0 						;R1 <-- R0
LD R0, NEWLINE 						;Load newline char into R0 
OUT

;HINT Restore
LD R0, BACKUP_R2_3200
LD R2, BACKUP_R2_3200
LD R7, BACKUP_R7_3200

RET

;--------------------------------
;Data for subroutine MENU
;--------------------------------
Error_message_1			.STRINGZ 		"INVALID INPUT\n"		
Menu_string_addr 		.FILL 			x6000
DEC_MINUS_48			.FILL 			#-48
DEC_PLUS_48 			.FILL 			#48
DEC_MINUS_56 			.FILL 			#-56
DEC_PLUS_56 			.FILL 			#56
NEWLINE 			.STRINGZ 		"\n"
BACKUP_R0_3200 			.BLKW 			#1
BACKUP_R2_3200 			.BLKW 			#1
BACKUP_R7_3200			.BLKW			#1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_BUSY
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy,    0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_BUSY
;--------------------------------
.ORIG x3400
;HINT back up
ST R0, BACKUP_R0_3400
ST R1, BACKUP_R1_3400
ST R7, BACKUP_R7_3400

LD R0, BUSYNESS_ADDR_ALL_MACHINES_BUSY 			;Load R0 with address of busyness vector
LDR R1, R0, #0 						;R0 <-- Mem[xD000]
BRz IM_ALL_BUSY 					;If x0000 (all are 0s, which means busy), then busy
BR NOT_ALL_BUSY 					;Else, go to end to DONE_BUSY

IM_ALL_BUSY
	AND R2, R2, #0 					;Make R2 0 before putting a 1
	ADD R2, R2, #1 					;R2 <-- #1 if ALL are busy
	BR DONE_BUSY 					;Go to DONE_BUSY	

NOT_ALL_BUSY
	AND R2, R2, #0 					;R2 <-- #0
	BR DONE_BUSY		 			;Go to DONE_BUSY

DONE_BUSY 						;R2 will either have #0 or #1

;HINT Restore
LD R0, BACKUP_R0_3400
LD R1, BACKUP_R1_3400
LD R7, BACKUP_R7_3400

RET

;--------------------------------
;Data for subroutine ALL_MACHINES_BUSY
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_BUSY .FILL 			xD000
BACKUP_R0_3400 			.BLKW 			#1
BACKUP_R1_3400 			.BLKW 			#1
BACKUP_R7_3400 			.BLKW 			#1	

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free,    0 otherwise
;		     xFFFF means ALL FREE, anything else is not free
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_FREE
;--------------------------------
.ORIG x3600
;HINT back up 
ST R0, BACKUP_R0_3600
ST R1, BACKUP_R1_3600
ST R7, BACKUP_R7_3600

LD R0, BUSYNESS_ADDR_ALL_MACHINES_FREE 			;Load R0 with address of busyness vector
LDR R1, R0, #0 						;R1 <-- Mem[xD000]

ADD R1, R1, #1 						;See if xFFFF (all 1s = all free)
BRz IM_ALL_FREE						;If so, then free
BR NOT_ALL_FREE 					;Else, then not all are free

IM_ALL_FREE
	AND R2, R2, #0 					;R2 <-- 0
	ADD R2, R2, #1 					;R2 <-- #1 if ALL are free
	BR DONE_FREE 					;Go to DONE_FREE

NOT_ALL_FREE
	AND R2, R2, #0 					;R2 <-- 0
	BR DONE_FREE  					;Go to DONE_FREE

DONE_FREE 						;R2 will either have 1 or 0

;HINT Restore
LD R0, BACKUP_R0_3600
LD R1, BACKUP_R1_3600
LD R7, BACKUP_R7_3600

RET

;--------------------------------
;Data for subroutine ALL_MACHINES_FREE
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_FREE .Fill xD000
BACKUP_R0_3600 			.BLKW 			#1
BACKUP_R1_3600 			.BLKW 			#1
BACKUP_R7_3600 			.BLKW 			#1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R2): The number of machines that are busy (1 is free, 0 is busy)
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine NUM_BUSY_MACHINES
;--------------------------------
.ORIG x3800
;HINT back up
ST R0, BACKUP_R0_3800
ST R1, BACKUP_R1_3800
ST R3, BACKUP_R3_3800
ST R4, BACKUP_R4_3800
ST R7, BACKUP_R7_3800

LD R0, BUSYNESS_ADDR_NUM_BUSY_MACHINES 			;Load R0 with address of busyness vector
LDR R1, R0, #0 						;R1 <-- Mem[R0] contains value of busyness vector
LD R3, DEC_16_BUSY 					;R2 <-- #16 to traverse 16 bits

COUNT_NUM_BUSY
	ADD R1, R1, #0 					;Make R1 LMF
	BRn IS_NEGATIVE_BUSY 				;Go to negative if negative
	ADD R1, R1, R1 					;Bit shift left <<
	ADD R3, R3, #-1 				;Decrement counter for 16 bits
	BRz END_COUNT_BUSY				;Go to END_COUNT if done traversing
	BR COUNT_NUM_BUSY 				;Else, loop again

	IS_NEGATIVE_BUSY
		ADD R4, R4, #1 				;R4 counts number of 1s
		ADD R1, R1, R1 				;Bit shift left <<
		ADD R3, R3, #-1 			;Decrement counter for 16 bits
		BRz END_COUNT_BUSY 			;Go to END_COUNT if done traversing
		BR COUNT_NUM_BUSY 			;Else, loop again
END_COUNT_BUSY

LD R2, DEC_16_BUSY 					;R5 <-- #16
NOT R4, R4 						;Take 2's complement
ADD R4, R4, #1 						
ADD R2, R2, R4 						;R2 <-- R2 (#16) - R4 (number of free) = number of busy

;HINT Restore
LD R0, BACKUP_R0_3800
LD R1, BACKUP_R1_3800
LD R3, BACKUP_R3_3800
LD R4, BACKUP_R4_3800
LD R7, BACKUP_R7_3800

RET

;--------------------------------
;Data for subroutine NUM_BUSY_MACHINES
;--------------------------------
BUSYNESS_ADDR_NUM_BUSY_MACHINES .Fill xD000
DEC_16_BUSY 			.FILL 			#16
BACKUP_R0_3800 			.BLKW 			#1
BACKUP_R1_3800 			.BLKW 			#1
BACKUP_R3_3800 			.BLKW 			#1
BACKUP_R4_3800 			.BLKW 			#1
BACKUP_R7_3800 			.BLKW 			#1


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R2): The number of machines that are free 
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine NUM_FREE_MACHINES
;--------------------------------
.ORIG x4000
;HINT back up 
ST R0, BACKUP_R0_4000
ST R1, BACKUP_R1_4000
ST R3, BACKUP_R3_4000
ST R4, BACKUP_R4_4000
ST R7, BACKUP_R7_4000

LD R0, BUSYNESS_ADDR_NUM_FREE_MACHINES 			;Load R0 with address of busyness vector
LDR R1, R0, #0 						;R1 <-- Mem[R0] contains value of busyness vector
LD R3, DEC_16_FREE					;R2 <-- #16 to traverse 16 bits

COUNT_NUM_FREE
	ADD R1, R1, #0 					;Make R1 LMF
	BRn IS_NEGATIVE_FREE 				;Go to negative if negative
	ADD R1, R1, R1 					;Bit shift left <<
	ADD R3, R3, #-1 				;Decrement counter for 16 bits
	BRz END_COUNT_FREE 				;Go to END_COUNT if done traversing
	BR COUNT_NUM_FREE 				;Else, loop again

	IS_NEGATIVE_FREE
		ADD R4, R4, #1 				;R4 counts number of 1s
		ADD R1, R1, R1 				;Bit shift left <<
		ADD R3, R3, #-1 			;Decrement counter for 16 bits
		BRz END_COUNT_FREE			;Go to END_COUNT if done traversing
		BR COUNT_NUM_FREE 			;Else, loop again
END_COUNT_FREE

ADD R2, R4, #0 						;R2 <-- R4

;HINT Restore
LD R0, BACKUP_R0_4000
LD R1, BACKUP_R1_4000
LD R3, BACKUP_R3_4000
LD R4, BACKUP_R4_4000
LD R7, BACKUP_R7_4000

RET

;--------------------------------
;Data for subroutine NUM_FREE_MACHINES
;--------------------------------
BUSYNESS_ADDR_NUM_FREE_MACHINES .Fill xD000
DEC_16_FREE 			.FILL 			#16
BACKUP_R0_4000 			.BLKW 			#1
BACKUP_R1_4000 			.BLKW 			#1
BACKUP_R3_4000 			.BLKW 			#1
BACKUP_R4_4000 			.BLKW 			#1
BACKUP_R7_4000 			.BLKW 			#1


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS
; Input (R1): Which machine to check
; Postcondition: The subroutine has returned a value indicating whether the machine indicated
;                          by (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine MACHINE_STATUS
;--------------------------------
.ORIG x4200
;HINT back up 
ST R1, BACKUP_R1_4200
ST R3, BACKUP_R3_4200
ST R7, BACKUP_R7_4200

LD R3, BUSYNESS_ADDR_MACHINE_STATUS 			;Load R2 with address of busyness vector 
LDR R3, R3, #0 						;R3 <-- Mem[R3]
AND R2, R2, #0 						;Make sure R2 is 0
AND R4, R4, #0 						;Make sure R4 is 0
ADD R4, R4, #15
NOT R1, R1 						;Take 2's complement of R1
ADD R1, R1, #1
ADD R4, R4, R1 						;R4 contains how many times we need to iterate

CHECK_MACHINE_STATUS
	ADD R4, R4, #0 					;Make R4 LMF
	BRz BUSY_OR_FREE				;If R1 is 0, then we've reached desired position
	ADD R4, R4, #-1 				;Subtract 1 to account for 0 as first machine
	ADD R3, R3, R3 					;Else, keep bitshifting to the left <<
	BR CHECK_MACHINE_STATUS 			;Loop again until desired position is reached

BUSY_OR_FREE
	ADD R3, R3, #0 					;Make R3 LMF (contains desired machine position)
	BRn FREEMACHINE  				;If negative, then machine is free
	BR DONE_MACHINE_STATUS	 			;Else (positive), machine is busy (R2 will already be 0 from the beginning of the subroutine)

	FREEMACHINE 
		ADD R2, R2, #1 				;Make R2 #1 as a flag for it being free

DONE_MACHINE_STATUS

;HINT Restore
LD R1, BACKUP_R1_4200
LD R3, BACKUP_R3_4200
LD R7, BACKUP_R7_4200

RET

;--------------------------------
;Data for subroutine MACHINE_STATUS
;--------------------------------
BUSYNESS_ADDR_MACHINE_STATUS.Fill xD000
BACKUP_R1_4200 			.BLKW 			#1
BACKUP_R3_4200 			.BLKW 			#1
BACKUP_R7_4200 			.BLKW 			#1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE
; Inputs: None
; Postcondition: 
; The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R2): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine FIRST_FREE
;--------------------------------
.ORIG x4400
;HINT back up 
ST R0, BACKUP_R0_4400
ST R1, BACKUP_R1_4400
ST R3, BACKUP_R3_4400
ST R4, BACKUP_R4_4400
ST R5, BACKUP_R5_4400 
ST R6, BACKUP_R6_4400
ST R7, BACKUP_R7_4400

LD R0, BUSYNESS_ADDR_FIRST_FREE 			;Load R0 with address of busyness vector
LDR R1, R0, #0 						;R1 <-- Mem[R0]
AND R5, R5, #0 						;Make sure R5 is 0 (AND result will be stored here)
AND R3, R3, #0 						;Make sure R3 is 0
AND R2, R2, #0 						;Make sure R2 is 0
AND R6, R6, #0 						;Make sure R6 is 0
ADD R3, R3, #1 						;R3 <-- #1 (this is going to be used to determine the first free)
LD R4, DEC_16_FIRST_FREE 				;R4 <-- #16 for traversing 16 bits

FIND_FIRST_FREE
	AND R5, R1, R3 					;Check if bit is 1 (free) starting from LSB
	BRnp FREE_BIT 					;If it is, then go to FREE_BIT
	BR NOT_FREE_BIT 				;Else, go to NOT_FREE_BIT

	NOT_FREE_BIT
		ADD R3, R3, R3 				;Bit shift R3 to the left <<
		ADD R6, R6, #1 				;Increment R6 to know how many bits we've gone through
		ADD R4, R4, #-1 			;Decrement counter for 16 bits
		BRz NOTHING_FREE			;If counter is done, go to NO_FREE
		BR FIND_FIRST_FREE 			;Else, loop again

	FREE_BIT
		ADD R2, R6, #0 				;R2 <-- R6 (R6 contains the position of the first free bit)
		BR DONE_FIRST_FREE

	NOTHING_FREE
		ADD R2, R2, #-1 			;If none are free, set R2 to -1 as a flag
		BR DONE_FIRST_FREE

DONE_FIRST_FREE


;HINT Restore
LD R0, BACKUP_R0_4400
LD R1, BACKUP_R1_4400
LD R3, BACKUP_R3_4400
LD R4, BACKUP_R4_4400
LD R5, BACKUP_R5_4400
LD R6, BACKUP_R6_4400
LD R7, BACKUP_R7_4400

RET

;--------------------------------
;Data for subroutine FIRST_FREE
;--------------------------------
BUSYNESS_ADDR_FIRST_FREE .Fill xD000
DEC_16_FIRST_FREE 		.FILL 			#16
BACKUP_R0_4400 			.BLKW 			#1
BACKUP_R1_4400 			.BLKW 			#1
BACKUP_R3_4400 			.BLKW 			#1
BACKUP_R4_4400 			.BLKW 			#1
BACKUP_R5_4400 			.BLKW 			#1
BACKUP_R6_4400 			.BLKW 			#1
BACKUP_R7_4400 			.BLKW 			#1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: GET_INPUT
; Inputs: None
; Postcondition: 
; The subroutine get up to a 5 digit input from the user within the range [-32768,32767]
; Return Value (R1): The value of the contructed input
; NOTE: This subroutine should be the same as the one that you did in assignment 4
;	to get input from the user, except the prompt is different.
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine GET_INPUT
;--------------------------------
.ORIG x4600

ST R0, BACKUP_R0_4600
ST R2, BACKUP_R2_4600
ST R3, BACKUP_R3_4600
ST R4, BACKUP_R4_4600
ST R5, BACKUP_R5_4600
ST R7, BACKUP_R7_4600

LD R3, INPUT_COUNTER 				;R3 <-- #5 to count number of inputs (max 5)
LD R4, MULTIPLY_COUNTER 			;R4 <-- #9 to multiply 10 times (0, 1, ... 9)
LD R2, ENTER_SHIFT 				;R2 <-- #-10
AND R1, R1, #0 					;Make sure R1 is 0 before taking input
AND R5, R5, #0 					;Make sure R5 is 0 before taking input

BEGINNING
	LEA R0, prompt 				;Load prompt into R0
	PUTS					;Output  to console	
	GETC					;User input could be '+', '-', or 'num'
	OUT 					;Output user input
	ADD R0, R0, R2				;Check if 'enter'
	BRz INVALID_INPUT 			;If so, go to INVALID_INPUT
	ADD R0, R0, #10				;Restore R0 to its original value

CHECK_SIGN
	ADD R5, R0, #0 				;R5 <-- R0

	LD R2, ASCII_PLUS_SHIFT			;R2 <-- #-43
	ADD R5, R5, R2				;Check if input was '+'
	BRz PRE_CONVERT_2 			;Directly go to PRE_CONVERT_2 if '+'
	ADD R5, R5, #15				;Restore R0 to its original value
	ADD R5, R5, #15
	ADD R5, R5, #13

	LD R2, ASCII_MINUS_SHIFT		;R2 <-- #-45
	ADD R5, R5, R2				;Check if input was '-'
	BRz NEGATIVE_PREP			;Go to NEGATIVE if '-'

	BR PRE_CONVERT_1			;Else, go to CONVERT

NEGATIVE_PREP
	ADD R5, R5, #-1				;Flag R5 for later
	BR PRE_CONVERT_2			;Go to PRE_CONVERT_2

PRE_CONVERT_1
	LD R2, NAN				;R2 <-- #-57
	ADD R0, R0, R2				;Check if input (ASCII) > '9'
	BRp INVALID_INPUT 			;If so, go to ERROR
	ADD R0, R0, #15				;Restore R0 to original value
	ADD R0, R0, #15
	ADD R0, R0, #15
	ADD R0, R0, #12

	LD R2, DEC_SHIFT			;R2 <-- #-48
	ADD R0, R0, R2				;R0 <-- Actual decimal value of user input
	BRn INVALID_INPUT 			;Go to ERROR if input (ASCII) is < '0'
	ADD R1, R0, #0				;R1 <-- R0
	ADD R3, R3, #-1				;Decrement input counter (counted from before)
CONVERT_1 
	GETC					;Get next 'num' from user
	OUT 					;Output to console

	LD R2, ENTER_SHIFT			;R2 <-- #-10
	ADD R0, R0, R2				;Check if input was 'enter'
	BRz LAST_CHECK				;If 'enter', then go to LAST_CHECK
	ADD R0, R0, #10				;Restore R0 to its original value

	LD R2, NAN				;R2 <-- #-57
	ADD R0, R0, R2				;Check if input (ASCII) > '9'
	BRp INVALID_INPUT 			;If so, go to ERROR
	ADD R0, R0, #15				;Restore R0 to original value
	ADD R0, R0, #15
	ADD R0, R0, #15
	ADD R0, R0, #12

	LD R2, DEC_SHIFT			;R2 <-- #-48
	ADD R0, R0, R2				;R0 <-- Actual decimal value of user input
	BRn INVALID_INPUT
	ADD R2, R1, #0				;R2 <-- R1 (used for multiplying)
	MULTIPLY_1
		ADD R1, R1, R2			;R1 <-- R1 + R2
		ADD R4, R4, #-1			;Decrement multiplication counter
		BRp MULTIPLY_1 			;Loop 10 times
	LD R4, MULTIPLY_COUNTER			;Reset multiplying counter
	ADD R1, R1, R0				;R1 <-- R1 + R0
	ADD R3, R3, #-1				;Decrement input counter
	BRp CONVERT_1 				;Loop until max 5 inputs

	LD R0, NEWLINE_2
	OUT
	ADD R5, R5, #0				;Make R5 LMF bc of flag (R5 is -1 or 0)
	BRn NEGATIVE  				;Go to NEGATIVE if flag was set to #-1
	BR DONE_INPUT 				;Else, go to ENDING
	

PRE_CONVERT_2
	GETC					;Get first 'num' from user
	OUT 					;Output to console

	LD R2, ENTER_SHIFT			;R2 <-- #-10
	ADD R0, R0, R2				;Check if 'enter'
	BRz INVALID_INPUT 			;If first input is 'enter', go to ERROR branch; else, continue on
	ADD R0, R0, #10				;Restore R0 to its original value

	LD R2, NAN				;R2 <-- #-57
	ADD R0, R0, R2				;Check if input (ASCII) > '9'
	BRp INVALID_INPUT			;If so, go to ERROR
	ADD R0, R0, #15				;Restore R0 to original value
	ADD R0, R0, #15
	ADD R0, R0, #15
	ADD R0, R0, #12

	LD R2, DEC_SHIFT			;R2 <-- #-48
	ADD R0, R0, R2				;R0 <-- Actual decimal value of user input
	BRn INVALID_INPUT
	ADD R1, R0, #0				;R1 <-- R0
	ADD R3, R3, #-1				;Decrement counter (max 5)
CONVERT_2
	GETC					;Get next 'num' from user
	OUT 					;Output to console

	LD R2, ENTER_SHIFT			;R2 <-- #-10
	ADD R0, R0, R2				;Check if input was 'enter'
	BRz LAST_CHECK				;If 'enter', then go to LAST_CHECK
	ADD R0, R0, #10				;Restore R0 to its original value

	LD R2, NAN				;R2 <-- #-57
	ADD R0, R0, R2				;Check if input (ASCII) > '9'
	BRp INVALID_INPUT			;If so, go to ERROR
	ADD R0, R0, #15				;Restore R0 to original value
	ADD R0, R0, #15
	ADD R0, R0, #15
	ADD R0, R0, #12

	LD R2, DEC_SHIFT			;R2 <-- #-48
	ADD R0, R0, R2				;R0 <-- Actual decimal value of user input
	BRn INVALID_INPUT
	ADD R2, R1, #0				;R2 <-- R1 (used for multiplying)
	MULTIPLY_2
		ADD R1, R1, R2			;R1 <-- R1 + R2
		ADD R4, R4, #-1			;Decrement multiplication counter
		BRp MULTIPLY_2 			;Loop 10 times
	LD R4, MULTIPLY_COUNTER			;Reset multiplying counter
	ADD R1, R1, R0				;R1 <-- R1 + R0
	ADD R3, R3, #-1				;Decrement input counter
	BRp CONVERT_2 				;Loop until max 5 inputs

	LD R0, NEWLINE_2
	OUT
	ADD R5, R5, #0				;Make R5 LMF bc of flag (R5 is -1 or 0)
	BRn NEGATIVE  				;Go to NEGATIVE if flag was set to #-1
	BR DONE_INPUT 				;Else, go to ENDING

INVALID_INPUT
	LD R0, NEWLINE_2			;Newline after last input and before error message
	OUT 					;Print newline
	LEA R0, Error_message_2			;Load error message into R0
	PUTS 					;Output error to console
	AND R1, R1, #0				;Reset R1 to 0
	LD R3, INPUT_COUNTER			;Reset R3's counter value to 5
	LD R2, ENTER_SHIFT			;Reset R2's first original value
	BR BEGINNING				;Start over from BEGINNING

INVALID_INPUT_POST_ENTER
	LEA R0, Error_message_2			;Load error message into R0
	PUTS 					;Output error to console
	AND R1, R1, #0				;Reset R1 to 0
	LD R3, INPUT_COUNTER			;Reset R3's counter value to 5
	LD R2, ENTER_SHIFT			;Reset R2's first original value
	BR BEGINNING				;Start over from BEGINNING

LAST_CHECK
	ADD R5, R5, #0				;Make R5 LMF
	BRn NEGATIVE 				;Go to NEGATIVE
	BR DONE_INPUT

NEGATIVE 					;Taking two's complement of R5
	NOT R1, R1				
	ADD R1, R1, #1				

DONE_INPUT

OVER_15
	LD R2, DEC_MINUS_15 			;R2 <-- #-15
	ADD R1, R1, R2 				;Check if R1 > 15 
	BRp INVALID_INPUT_POST_ENTER 		;If so, then it's invalid (must be between 0 - 15)
	ADD R1, R1, #15 			;Restore R1 to original value

NEGATIVE_INPUT
	ADD R1, R1, #0 				;Make R1 LMF to check if input was negative
	BRn INVALID_INPUT_POST_ENTER 		;If so, then it's invalid

LD R0, BACKUP_R0_4600
LD R2, BACKUP_R2_4600
LD R3, BACKUP_R3_4600
LD R4, BACKUP_R4_4600
LD R5, BACKUP_R5_4600
LD R7, BACKUP_R7_4600

RET

;--------------------------------
;Data for subroutine GET_INPUT
;--------------------------------
prompt .STRINGZ "Enter which machine you want the status of (0 - 15), followed by ENTER: "
Error_message_2 .STRINGZ "ERROR INVALID INPUT\n"
ENTER_SHIFT 			.FILL 			#-10
ASCII_PLUS_SHIFT 		.FILL 			#-43
ASCII_MINUS_SHIFT 		.FILL 			#-45
DEC_SHIFT 			.FILL 			#-48 
NAN 				.FILL 			#-57
NEWLINE_2 			.STRINGZ 		"\n"
INPUT_COUNTER 			.FILL 			#5
MULTIPLY_COUNTER 		.FILL 			#9
DEC_MINUS_15 			.FILL 			#-15
BACKUP_R0_4600 			.BLKW 			#1
BACKUP_R2_4600 			.BLKW 			#1
BACKUP_R3_4600 			.BLKW 			#1
BACKUP_R4_4600 			.BLKW 			#1
BACKUP_R5_4600 			.BLKW 			#1
BACKUP_R7_4600 			.BLKW 			#1
	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: PRINT_NUM
; Input: R2 
; Postcondition: The subroutine prints the number that is in R2
; Return Value : None
; NOTE: This subroutine should print the number to the user WITHOUT 
;		leading 0's and DOES NOT output the '+' for positive numbers.
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine PRINT_NUM
;--------------------------------
.ORIG x4800

ST R1, BACKUP_R1_4800
ST R2, BACKUP_R2_4800
ST R3, BACKUP_R3_4800
ST R4, BACKUP_R4_4800
ST R5, BACKUP_R5_4800
ST R6, BACKUP_R6_4800
ST R7, BACKUP_R7_4800

ADD R1, R2, #0					;R1 <-- R2 (contains decimal)
ADD R6, R2, #0 					;R6 <-- R2 (also contains same decimal)
AND R3, R3, #0					;R3 <-- #0
ADD R2, R2, #0					;Make R2 LMF
BRn NEGATIVE_PRINT 				;Go to NEGATIVE if R2 is negative
BR PRECHECK					;Else, just skip it

NEGATIVE_PRINT
	LD R0, ASCII_MINUS 			;R0 <-- '-'
	OUT
	NOT R2, R2 				;2's complement for negative decimals
	ADD R2, R2, #1
	ADD R1, R2, #0
	ADD R6, R2, #0

PRECHECK					;Decide which loop to start from
	LD R5, DEC_10K
	ADD R1, R1, R5 				;Check if 10K loop
	BRzp PRE_10K 				;If so, go to PRE_10K
	ADD R1, R6, #0				;Restore R1 to original value

	LD R5, DEC_1K 				;Check if 1K loop
	ADD R1, R1, R5
	BRzp PRE_1K 
	ADD R1, R6, #0

	LD R5, DEC_100 				;Check if 100 loop
	ADD R1, R1, R5 
	BRzp PRE_100
	ADD R1, R6, #0

	LD R5, DEC_10 				;Check if 10 loop
	ADD R1, R1, R5
	BRzp PRE_10
	ADD R1, R6, #0

	BR PRE_1 				;Else, you have to go to 1 loop

	PRE_10K
		ADD R1, R6, #0
		LD R5, DEC_10K			;R5 <-- #-10000
		BR CHECK_10K_LOOP

	PRE_1K
		ADD R1, R6, #0
		LD R5, DEC_1K			;R5 <-- #-1000
		BR CHECK_1K_LOOP

	PRE_100
		ADD R1, R6, #0
		LD R5, DEC_100			;R5 <-- #-100
		BR CHECK_100_LOOP

	PRE_10
		ADD R1, R6, #0
		LD R5, DEC_10			;R5 <-- #-10
		BR CHECK_10_LOOP

	PRE_1
		ADD R1, R6, #0
		LD R5, DEC_1			;R5 <-- #-1
		BR CHECK_1_LOOP


CHECK_10K_LOOP
	ADD R4, R1, #0				;Make a copy of R1 in R4
	ADD R1, R1, R5 				;Subtract 10000
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
	LD R5, DEC_1K				;R5 <-- #-1000
	ADD R4, R1, #0				;Make a copy of R1 in R4
	ADD R1, R1, R5 				;Subtract 1000
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
	LD R5, DEC_100				;R5 <-- #-100
	ADD R4, R1, #0				;Make a copy of R1 in R4
	ADD R1, R1, R5 				;Subtract 100
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
	LD R5, DEC_10				;R5 <-- #-10
	ADD R4, R1, #0				;Make a copy of R1 in R4
	ADD R1, R1, R5 				;Subtract 10
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
	LD R5, DEC_1				;R5 <-- #-1 
	ADD R4, R1, #0				;Make a copy of R1 in R4
	ADD R1, R1, R5 				;Subtract 1
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

LD R1, BACKUP_R1_4800
LD R2, BACKUP_R2_4800
LD R3, BACKUP_R3_4800
LD R4, BACKUP_R4_4800
LD R5, BACKUP_R5_4800
LD R6, BACKUP_R6_4800
LD R7, BACKUP_R7_4800

RET

;--------------------------------
;Data for subroutine PRINT_NUM
;--------------------------------
DEC_10K			.FILL			#-10000
DEC_1K 			.FILL			#-1000
DEC_100			.FILL 			#-100
DEC_10 			.FILL 			#-10
DEC_1 			.FILL			#-1
ASCII_MINUS 		.FILL 			#45
BACKUP_R1_4800		.BLKW			#1
BACKUP_R2_4800		.BLKW			#1
BACKUP_R3_4800		.BLKW			#1
BACKUP_R4_4800		.BLKW			#1
BACKUP_R5_4800		.BLKW			#1
BACKUP_R6_4800		.BLKW			#1
BACKUP_R7_4800		.BLKW			#1


.ORIG x6000
MENUSTRING .STRINGZ "**********************\n* The Busyness Server *\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"

.ORIG xD000			; Remote data
BUSYNESS .FILL xABCD		; <----!!!VALUE FOR BUSYNESS VECTOR!!!

;---------------	
;END of PROGRAM
;---------------	
.END
