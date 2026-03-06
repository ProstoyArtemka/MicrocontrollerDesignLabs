
	AREA		SRAM1,		NOINIT,		READWRITE
	SPACE		0x0200
Stack_Top
Array	SPACE		16

	AREA		RESET,		DATA,		READONLY
	DCD		Stack_Top
	DCD		Start

	AREA		PROGRAM,	CODE,		READONLY
	ENTRY
	
Start
	
	LDR R0, =Array ; R0 - начало массива
	
	LDR R2, =Array ; R2 - конец массива
	ADD R2, #15
	
	
	
	MOV R1,	#174
	STRB R1, [R0]
	MOV R1,	#210
	STRB R1, [R0, #1]
	MOV R1,	#238
	STRB R1, [R0, #2]
	MOV R1,	#212
	STRB R1, [R0, #3]
	MOV R1,	#190
	STRB R1, [R0, #4]
	MOV R1,	#156
	STRB R1, [R0, #5]
	MOV R1,	#234
	STRB R1, [R0, #6]
	MOV R1,	#88
	STRB R1, [R0, #7]
	MOV R1,	#30
	STRB R1, [R0, #8]
	MOV R1,	#0
	STRB R1, [R0, #9]
	MOV R1,	#236
	STRB R1, [R0, #10]
	MOV R1,	#9
	STRB R1, [R0, #11]
	MOV R1,	#217
	STRB R1, [R0, #12]
	MOV R1,	#72
	STRB R1, [R0, #13]
	MOV R1,	#25
	STRB R1, [R0, #14]
	MOV R1,	#235
	STRB R1, [R0, #15]

	; Отсортированный массив должен быть: [0, 9, 25, 30, 72, 88, 156, 174, 190, 210, 212, 217, 234, 235, 236, 238]
Sort
	
	MOV R3, R0 ; Текущий элемент массива
	
Sort_Cycle

	CMP R3, R2 ; Сравниваем текущий элемент массива с концом
	BEQ End_Of_Array

	LDRB R5, [R3] ; Читаем элемент массива
	ADD R3, #1 ; I++
	
	LDRB R6, [R3] ; Читаем второй элемент из массива
	
	CMP R5, R6 ; Сравниваем два элемента
	BGE Swap_Elements ; Если I > I + 1 то меняем элементы местами
	
	B Sort_Cycle
	
Swap_Elements

	SUB R3, #1 ; I--
	STRB R6, [R3]
	
	ADD R3, #1 ; I++
	STRB R5, [R3]
	
	B Sort_Cycle

End_Of_Array

	SUB R2, #1 ; Уменьшаем размер проходимого массива на 1
	MOV R3, R0 ; Устанавливаем I в начало
	
	CMP R2, R0 ; Конец массива = Начало, сортировка кончилась
	BEQ Sort_End
	
	B Sort_Cycle

Sort_End

	NOP

	END		