	AREA		SRAM1,		NOINIT,		READWRITE
	SPACE		0x0200
Stack_Top

	AREA		RESET,		DATA,		READONLY
	DCD		Stack_Top					;[0x0000-0x0003]
	DCD		Start						;[0x0004-0x0007]

	AREA		PROGRAM,	CODE,		READONLY
	ENTRY
	
Start
	
	LDR r1, =-5 ; R1 = ?
	LDR r2, =-4 ; R2 = ?
	MOV r3, #1 ; R3 = Value i = 1
	LDR r4, =4 ; R4 = Value 4 for multiplying
	
	MUL r5, r1, r1 ; R5 = R1 * R1
	MUL r5, r1, r5 ; R5 = R1 * R1 * r1

	MOV r0, #0

Cycle

	MUL r6, r3, r4 ; R6 = i * 4
	ADDS r6, r2 ; R6 = (i * 4) + R2
	
	SDIVNE r7, r5, r6 ; if (r6 != 0) then R7 = R5 / R6
	ADDNE r0, r7 ; if (r6 != 0) R0 = R0 + R7

	ADD r3, #1 ; Increment I
	CMP r3, #6 ; If r3 > 5, then done
	BNE Cycle

	NOP

	END