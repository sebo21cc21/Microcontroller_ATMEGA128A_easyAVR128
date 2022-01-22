/*
 * zad6_makieta.asm
 *
 *  Created: 14.01.2022 00:21:35
 *   Author: sebo2
 */ 

 /*
.cseg
.org 0
		rjmp pocz

.org 0x46 
pocz:	
		ldi r16,0xFF
		out ddrc, r16
		ldi r16, 0b00001111
		out portc, r16
		rjmp pc
*/

.cseg
.org 0
		rjmp pocz

.org 0x46 
pocz:	
		ldi r16,0xFF
		out ddrc, r16
		ldi r16, 0
		out ddrb, r16
		
petla:
		in r16, pinb
		out portc, r16
		rjmp petla