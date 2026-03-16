
	AREA		SRAM1,		NOINIT,		READWRITE
	SPACE		0x0200
Stack_Top

	AREA		RESET,		DATA,		READONLY
	DCD		Stack_Top
	DCD		Start

	AREA		PROGRAM,	CODE,		READONLY
	ENTRY
	
Start
	; Разрешаем доступ к сопроцессорам CP10 и CP11 (это FPU)
    LDR     		R0, 	=0xE000ED88    			; Адрес регистра CPACR
    LDR     		R1,		[R0]
    ORR     		R1, 	R1, 	#(0xF << 20)	; Устанавливаем биты доступа
    STR				R1, 	[R0]
	
    DSB                        				; Ждем завершения операций с памятью
    ISB                        				; Очищаем конвейер инструкций
	
	VLDR.F32 		S4,	 =2.56					; Загружаем 2.56 для суммы
	
	

	LDR				R0, 	=-10					; Вводные значения
	LDR				R1, 	=-5
	LDR 			R2, 	=25
	
	LDR				R3,		=8						; k
	
Loop
	SUB 			R3, 	#1						; k--
	MOV 			R4, 	R3 						; Копируем k для возведения в степень

	MOV				R5,		#1						; Очищаем регистры
	MOV				R6,		#0
	MOV				R7,		#0

Power
	CBZ 			R4, 	Calculate

	MUL				R5,		R5, 	R1				; Возводим в степень 
	SUB 			R4, 	#1						; Уменьшаем степень на 1
	
	B Power
	
Calculate

	SUB 			R6,		R0,		R5 				; R6 = R0 - R1^k
	MUL 			R7, 	R3, 	R2				; R7 = R2 * k
	
	VMOV			S1,		R7						; Загружаем R7 в S1
	VCVT.F32.S32	S1,		S1						; Конвертируем S1 в число с плавающей точкой	
	VABS.F32		S1,		S1						; Получаем модуль
	
	VADD.F32 		S2, 	S4,		S1				; Складываем 2.56 и S1
	VSQRT.F32 		S2,		S2						; Получаем корень из суммы 2.56 и S1
	
	VCMP.F32		S2,		#0.0					; Сравниваем делитель с 0, чтобы не делить на 0
	BEQ				Loop							; Пропускаем вычисления если делитель 0
	
	

	VMOV			S3,		R6						; Загружаем R6 (R0 - R1^k)
	VCVT.F32.S32	S3,		S3						
	
	VDIV.F32		S3,		S2						; Деление
	
	VADD.F32		S0,		S3						; Добавляем результат
	
	CMP				R3,		#0
	BNE				Loop

EndOfProgram

	B EndOfProgram
	END