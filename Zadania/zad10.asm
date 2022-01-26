/*
 * zad10.asm
 *
 *  Created: 26.01.2022 01:18:57
 *   Author: sebo2
 */ 
 .equ komunikat1 = 0b01111111
 .equ komunikat2 = 0b00111111
 .equ komunikat3 = 0b10011111
 .equ komunikat4 = 0b11001111
 .equ komunikat5 = 0b11100111
 .equ komunikat6 = 0b11110011
 .equ komunikat7 = 0b11111001
 .equ komunikat8 = 0b11111100
 .equ komunikat9 = 0b11111110

 .equ ADR_C = 0x100
 .equ ADR_D = 0x300

.cseg
.org 0
	jmp start
.org ADR_C
	TAB: .dw 0x6000, 0x746a, 0x887e, 0xA692

start:
	ldi zl, low(TAB<<1)
	ldi zh, high(TAB<<1)
	ldi xl, byte1(ADR_D)
	ldi xh, byte2(ADR_D)


	ldi r19, 0xff
	ldi r20, 0x0
	out DDRC, r19 ;PORTC na wyjœcie 1 - LED, wyj=1, gdyby portC = 0x0 to wyj= 0
	out PORTC, r19
	out DDRB, r20 ;PORTB na wejœcie 0 - klawisze
	out PORTB, r19 ;rezystory podci¹gaj¹ce, a u nas trzeba wl¹czaæ on zbiera szumy i jak nie jest w³aczony to wtedy moze nie wczytywac dobrze pinow B

petla:
	in r21, PINB
	mov r22, r21
	com r22

	cpi r22, 0x01
	breq kolejny

	cpi r22, 0b00000010
	breq kolejny2

	cpi r22, 0b00000100
	breq kolejny3

	cpi r22, 0b00001000
	breq kolejny4

	cpi r22, 0b00010000
	breq kolejny5

	cpi r22, 0b00100000
	breq kolejny6

	cpi r22, 0b01000000
	breq kolejny7

	cpi r22, 0b10000000
	breq kolejny8

	jmp petla

kolejny:
	lpm r17, z+
	jmp store
kolejny2:
	lpm r17, z+
	lpm r17, z+
	jmp store
kolejny3:
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	jmp store
kolejny4:
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	jmp store
kolejny5:
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	jmp store
kolejny6:
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	jmp store

kolejny7:
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+	
	jmp store
kolejny8:
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+
	lpm r17, z+	
	lpm r17, z+	
	jmp store
	
store:
	st x+, r17

sprawdzenie:
	mniej_96:
		cpi r17, 0x60 ;<96
		brbs 0, jeden

	mniej_106:
		cpi r17, 0x6A ;<106
		brbs 0, dwa

	mniej_116:
		cpi r17, 0x74 ;<116
		brbs 0, trzy

	mniej_126:
		cpi r17, 0x7E;<126
		brbs 0, cztery

	mniej_136:
		cpi r17, 0x88 ;<136
		brbs 0, piec

	mniej_146:
		cpi r17, 0x92;<146
		brbs 0, szesc

	mniej_166:
		cpi r17, 0xA6 ;<166
		brbs 0, siedem

	mniej_186:
		cpi r17, 0xBA ;<186
		brbs 0, osiem

	inf:
		cpi r17, 0xBA
		brbc 0, dziewiec
	jmp sprawdzenie

jeden:
	ldi r22, komunikat1
	out PORTC, r22
	jmp start
dwa:
	ldi r22, komunikat2
	out PORTC, r22
	jmp start
trzy:
	ldi r22, komunikat3
	out PORTC, r22
	jmp start
cztery:
	ldi r22, komunikat4
	out PORTC, r22
	jmp start
piec:
	ldi r22, komunikat5
	out PORTC, r22
	jmp start
szesc:
	ldi r22, komunikat6
	out PORTC, r22
	jmp start
siedem:
	ldi r22, komunikat7
	out PORTC, r22
	jmp start
osiem:
	ldi r22, komunikat8
	out PORTC, r22
	jmp start
dziewiec:
	ldi r22, komunikat9
	out PORTC, r22
	jmp start


