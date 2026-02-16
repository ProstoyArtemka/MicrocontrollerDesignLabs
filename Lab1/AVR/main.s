
.org 0x0000
	rjmp start

start:

	ldi r16, -5 ; R16 (R1) = ?
	ldi r17, 3 ; R17 (R0) = ?

	ldi r18, 5 ; Value of I
	ldi r19, 4 ; For multiplying

	muls r16, r16 ; R16 * R16
	mov r20, r0 ; R20 = R16 * R16

	muls r20, r16 ; r20 = R16 * R16 * R16
	mov r20, r0 ; R20 = R16 * R16 * R16 (low) 
	mov r21, r1 ; R21 = R16 * R16 * R16 (high)

cycle:

	clr r27	
	ldi r22, 16 ; Counter for division of both halves

	mov r24, r20 ; R24 = R22 (low half of R16^3)
	mov r25, r21 ; R25 = R21 (high half of R16^3)

	muls r18, r19 ; R0 = i * 4
	mov r26, r0 ; R26 = i * 4

	add r26, r17 ; R26 = r17 + (i * 4)

	breq zero_skip ; if r17 + (i * 4) == 0, skip division 

	clt; Clear negative number

	tst r25 ; Check sigh of high half
	brpl divide_cycle ; If r25 > 0

	com r25 ; Invert high half
	com r24 ; Invert low half

	subi r24, -1 ; r24 -= 1
	sbci r25, -1 ; r25 -= 1 + C

	set ; Remember negative number

divide_cycle:

	lsl r24 ; shift bytes of low half to left, last byte now in carry
	rol r25 ; get byte from carry and put it in right part of r25 (high half)
	rol r27 ; get byte from carry and put in remainder

	cp r27, r26 ; Compare remainder and divider
	brlo divide_skip_sub ; If remainder < divider then sub divider from remainder

	sub r27, r26 ; Subtract divider from remainder
	inc r24 ; Add 1 to divisible (low half)

divide_skip_sub:

	dec r22 ; Divide counter--
	brne divide_cycle

	brtc skip_invert

	com r24 ; Invert low half
	com r25 ; Invert high half
	subi r24, -1 ; Sub 1 after inversion
	sbci r25, -1 ; Sub 1 with carry after inversion

skip_invert:

	add r28, r24 ; R28 = R28 + R24
	adc r29, r25 ; R29 = R29 + R25 + C

zero_skip:
	
	dec r18 ; I--
	brne cycle

	mov r0, r28 ; r0 = 28
	mov r1, r29 ; r1 = 29

	rjmp start