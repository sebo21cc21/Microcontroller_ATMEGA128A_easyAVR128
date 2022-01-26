/*
 * zad9.asm
 *
 *  Created: 25.01.2022 18:33:09
 *   Author: sebo2
 */ 
 /*
 .equ negowana_bitowa_jedynka = 0xfe ;A-10 B-11 C-12 D-13 E-14 F-15
 .equ negowana_bitowa_dwojka = 0xfd
 .equ negowana_bitowa_trojka = 0xfc
 .equ negowana_bitowa_czworka = 0xfb
 .equ negowana_bitowa_piatka = 0xfa
 .equ negowana_bitowa_szostka = 0xf9
 .equ negowana_bitowa_siodemka = 0xf8
 .equ negowana_bitowa_osemka = 0xf7
 .equ bledna_wartosc = 0x7f
.cseg
.org 0
	rjmp start
.org 0x100

start:
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
	breq jeden

	cpi r22, 0b00000010
	breq dwa

	cpi r22, 0b00000100
	breq trzy

	cpi r22, 0b00001000
	breq cztery

	cpi r22, 0b00010000
	breq piec

	cpi r22, 0b00100000
	breq szesc

	cpi r22, 0b01000000
	breq siedem

	cpi r22, 0b10000000
	breq osiem
	
	cpi r22, 0x00
	breq gas

blad:
	ldi r22, bledna_wartosc
	out PORTC, r22
	jmp petla

jeden:
	com r22
	out PORTC, r22
	jmp petla

dwa:
	com r22
	out PORTC, r22
	jmp petla
trzy:
	ldi r22, negowana_bitowa_trojka
	out PORTC, r22
	jmp petla
cztery:
	ldi r22, negowana_bitowa_czworka
	out PORTC, r22
	jmp petla
piec:
	ldi r22, negowana_bitowa_piatka
	out PORTC, r22
	jmp petla
szesc:
	ldi r22, negowana_bitowa_szostka
	out PORTC, r22
	jmp petla
siedem:
	ldi r22, negowana_bitowa_siodemka
	out PORTC, r22
	jmp petla
osiem:
	ldi r22, negowana_bitowa_osemka
	out PORTC, r22
	jmp petla
gas:
	ldi r22, 0xff
	out PORTC, r22
	jmp petla
 /*
 */
 //counter petli- wynik binarny
  /*
.cseg
.org 0
	rjmp start
.org 0x100

start:
	ldi r19, 0xff
	ldi r20, 0x00
	ldi r16, 0x01
	ldi r17, 0x01
	out DDRC, r19 ;PORTC na wyjœcie 1 - LED, wyj=1, gdyby portC = 0x0 to wyj= 0
	out PORTC, r19
	out DDRB, r20 ;PORTB na wejœcie 0 - klawisze
	out PORTB, r19 ;rezystory podci¹gaj¹ce, a u nas trzeba wl¹czaæ on zbiera szumy i jak nie jest w³aczony to wtedy moze nie wczytywac dobrze pinow B

petla:
	in r21, PINB
	mov r22, r21
	com r22
	lsl r16
	sub r19, r17
	out PORTC, r19
	jmp petla

	*/