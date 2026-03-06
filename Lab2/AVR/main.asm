
.dseg
.org 0x0200
Array: .byte 16 ; Обозначаем массив размером 16 байт

.cseg
.org 0x0000
	rjmp start

start:

	; Запись в массив случайных элементов
	
	ldi XL, low(Array) ; Начало массива
    ldi XH, high(Array) ; Конец массива

	; Случайные значения в массив

	ldi r16,	 103
	st X+,		 r16
	ldi r16,	 -87
	st X+,		 r16
	ldi r16,	 55
	st X+,		 r16
	ldi r16,	 43
	st X+,		 r16
	ldi r16,	 -88
	st X+,		 r16
	ldi r16,	 -84
	st X+,		 r16
	ldi r16,	 -14
	st X+,		 r16
	ldi r16,	 -108
	st X+,		 r16
	ldi r16,	 -23
	st X+,		 r16
	ldi r16,	 67
	st X+,		 r16
	ldi r16,	 18
	st X+,		 r16
	ldi r16,	 -81
	st X+,		 r16
	ldi r16,	 -34
	st X+,		 r16
	ldi r16,	 38
	st X+,		 r16
	ldi r16,	 -21
	st X+,		 r16
	ldi r16,	 90
	st X+,		 r16

	; Отсортированный массив должен быть: [-108, -88, -87, -84, -81, -34, -23, -21, -14, 18, 38, 43, 55, 67, 90, 103]



sort:

	ldi XL, low(Array) ; Начинаем с начала массива
    ldi XH, high(Array)

	ldi r19, 16 ; Размер обходимого массива
	ldi r20, 0 ; Счётчик для сортировки

sort_cycle:

	inc r20 ; Счётчик ++
	cp r19, r20 ; Сравниваем дошли ли мы до конца массива
	breq end_of_array ; Если да то заканчиваем текущую итерацию

	ld r17, X+ ; Забираем I число с массива
	ld r18, X ; Забираем I+1 число с массива
	sbiw X, 1 ; Встаём на изначальную позицию ( I-- )

	cp r17, r18 ; Сравниваем I и I+1 элемент

	brge swap_elements ; Если I > I + 1 то меняем элементы местами
	; Иначе просто I++ и идём дальше

	adiw X, 1 ; I++

	rjmp sort_cycle

swap_elements:

	st X+, r18 ; Меняем элементы местами
	st X, r17 

	rjmp sort_cycle

end_of_array:

	dec r19 ; Уменьшаем размер обхода
	clr r20 ; Обнуляем счётчик

	cpi r19, 0 ; Смотрим а не прошлись ли мы полностью по всему массиву
	breq end_of_sort

	ldi XL, low(Array) ; Возращаем X в начало массива
    ldi XH, high(Array)

	rjmp sort_cycle

end_of_sort:

	nop

	rjmp start