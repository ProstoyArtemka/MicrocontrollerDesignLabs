
.cseg
.org 0x0000
	rjmp init

.equ	INPUT_R19R18	=	31808
.equ	INPUT_R1R0		=	-18182

.equ	INPUT_R2		=	49

init:
	ldi		r19,				high(INPUT_R19R18)
	ldi		r18,				low(INPUT_R19R18)
	
	ldi		r21,				high(INPUT_R1R0)
	ldi		r20,				low(INPUT_R1R0)
		
	ldi		r22,				INPUT_R2



	; r22:r23 = |r22| + 2



	tst		r22 
	brpl	skip_abs_r2
	neg		r22

skip_abs_r2:

	ldi		r30,				2
	add		r22,				r30

	clr		r30
	adc		r23,				r30



	; r24:r25:r26 = r21:r20 * 3	
	


	tst		r21										; Если r21:r20 положительное, то пропускаем инвертацию
	brpl	skip_abs_r0r1

	com		r20
	com		r21

	subi	r20,				-1
	sbci	r21,				-1

	sbr		r16,				(1<<0)				; Запоминаем что r19:r18 отрицательное

skip_abs_r0r1:

	clr		r30

	movw	r24,				r20					; Копируем r21:r20 в r24:r25

	lsl		r20										; Сдвигаем биты влево, умножая число на 2 фактически
	rol		r21 
	adc		r26,				r30

	add		r24,				r20					; Добавляем 1 раз, чтобы было как умножение на 3
	adc		r25,				r21
	adc		r26,				r30

	clr		r20										; r20 больше не пригодится
	


	; r19:r18 - (r1:r0 * 3)



	tst		r19
	brpl	skip_r19r18_neg

	com		r18
	com		r19

	subi	r18,				-1
	sbci	r19,				-1

	sbr		r16,				(1<<1)				; Запоминаем что r19:r18 отрицательное

skip_r19r18_neg:

	ldi		r17,				3			; Маска двух первых битов
	and		r17,				r16

	cpi		r17,				3
	breq	both_was_negative

	cpi		r16,				0
	breq	both_was_positive

	rjmp	one_was_negative

one_was_negative:

	add		r18,				r24					; Можем просто сложить так как минус на минус это плюс
	adc		r19,				r25
	adc		r20,				r26

	sbrc	r16,				1					; r19:r18 было отрицательным
	sbr		r16,				(1<<2)				; Запоминаем что верхняя часть дроби вся отрицательная так то

	rjmp	mul_100

both_was_negative:
	
	sub		r24,				r18					; Меняем местами регистры так как оба числа отрицательные
	sbc		r25,				r19
	sbc		r26,				r20

	mov		r18,				r24					; Возращаем обратно
	mov		r19,				r25
	mov		r20,				r26

	tst		r26										; Если в результате отрицательное число, надо будет его инвертировать
	brpl	mul_100

	rjmp invert_divisible

both_was_positive:

	sub		r18,				r24					; Просто отнимаем r24:r25:r26 из r18:r19
	sbc		r19,				r25
	sbc		r20,				r26

	tst		r20
	brpl	mul_100

invert_divisible:

	com		r18
	com		r19
	com		r20

	subi	r18,				-1
	sbci	r19,				-1
	sbci	r20,				-1

	sbr		r16,				(1<<2)				; Запоминаем что верхняя часть дроби вся отрицательная так то

mul_100:
	
	
	
	; Умножаем r24:r25:r26 на 100 чтобы точность была в 2 знака



	clr		r29
	ldi		r30,				100

	mul		r18,				r30					; Умножаем младший байт
	mov		r2,					r0
	mov		r3,					r1
	
	mul		r19,				r30					; Умножаем средний байт
	add		r3,					r0
	adc		r1,					r29
	mov		r4,					r1

	mul		r20,				r30					; Умножаем старший байт
	add		r4,					r0
	adc		r1,					r29



	mov		r18,				r2					; Возращаем значение обратно
	mov		r19,				r3
	mov		r20,				r4


	ldi		r27,				24					; Счётчик на 24 бита
	clr		r28										; Остаток
	clr		r29

division:
	
	lsl		r18										; Сдивгаем всё делимое и остаток влево
	rol		r19
	rol		r20

	rol		r28
	rol		r29		

	cp		r28,				r22					; Можем ли вычесть из остатка делитель?
	cpc		r29,				r23
	brcs	skip_div_sub

	sub		r28,				r22					; Вычитаем делитель из остатка
	sbc		r29,				r23

	inc		r18										; Добавляем 1 в делимое

skip_div_sub:

	dec		r27										; Отнимаем от счётчика и идём в цикл если ещё не прошли все 24 бита
	brne	division



	; Учитываем остаток и округляем



	lsl		r28
	rol		r29

	cp		r28,				r22					; Если верхняя часть была отрицательной то пропускаем следующую инструкцию
	cpc		r29,				r23

	brlo	skip_rounding
	
	subi	r18,				-1
	sbci	r19,				-1
	sbci	r20,				-1

skip_rounding:



	; Инвертируем число 



	sbrc	r16,				2					; Проверяем была ли верхняя часть дроби отрицательной
	rjmp	result_neg



	rjmp	end

result_neg:

	com		r18
	com		r19
	com		r20

	subi	r18,				-1
	sbci	r19,				-1
	sbci	r20,				-1

end:
    rjmp	end
