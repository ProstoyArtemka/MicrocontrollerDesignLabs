	AREA		SRAM1,		NOINIT,		READWRITE
	SPACE		0x0200
Stack_Top

	AREA		RESET,		DATA,		READONLY
	DCD		Stack_Top					;[0x0000-0x0003]
	DCD		Start						;[0x0004-0x0007]

	AREA		PROGRAM,	CODE,		READONLY
	ENTRY
	
Start
	
	MOV r1, #5 ; R1 = ?
	MOV r2, #10 ; R2 = ?
	MOV r3, #6 ; R3 = Value i = 5 + 1
	MOV r4, #4 ; R4 = Value 4 for multiplying
	
	
	
	MUL r5, r1, r1 ; R5 = R1 * R1
	MUL r5, r1, r5 ; R5 = R1 * R1 * r1

Cycle

	SUBS r3, #1 ; Decrement by 1

	MUL r6, r3, r4 ; R6 = i * 4
	ADD r6, r2 ; R6 = (i * 4) + R2
	
	UDIV r7, r5, r6 ; R7 = R6 / R6
	
	ADD r0, r7 ; R0 = R0 + R7

	BNE Cycle

	NOP

	END