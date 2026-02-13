
.org 0x0000
	rjmp start

start:

	ldi r16, 6 ; R16 = ?
	ldi r17, 10 ; R17 = ?

	ldi r18, 5 ; Value of I
	ldi r19, 4 ; For multiplying

	mul r16, r16 ; R16 * R16
	mov r20, r0 ; R20 = R16 * R16

	mul r20, r16 ; R16 * R16 * R16
	mov r16, r0 ; R16 = R16 * R16 * R16

	clr r23
	clr r25

cycle:
	
	ldi r21, 8 ; Counter for division
	mov r22, r16 ; Get R16^3 for division

	mul r18, r19 ; i * 4
	mov r23, r0 ; r23 = i * 4

	add r23, r17 ; r23 = r17 + (i * 4)

	clr r24 ; Clear remainder

divide_cycle:
	
	lsl r22 ; shift bytes of r22 to left, last byte now in carry
	rol r24 ; get byte from carry and put it in left part of r24 (our remainder)

	cp r24, r23 ; If remainder > divider
	brlo divide_skip_sub ; If remainder > divider then sub divider from remainder

	sub r24, r23 ; Subtract divider from remainder
	inc r22 ; Add 1 to divisible

divide_skip_sub:

	dec r21 ; r21--
	brne divide_cycle

	; End of divide cycle

	add r25, r22

	dec r18 ; I--
	brne cycle

	; End of main cycle
	
	mov r0, r25

	rjmp start