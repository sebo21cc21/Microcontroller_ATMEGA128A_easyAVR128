/*
 * zad1.asm
 *
 *  Created: 04.11.2021 20:48:15
 *   Author: sebo2
 */ 


/*
 * Laboratorium3_Mikrokontorlery_zad2b_d.asm
 *
 *  Created: 29.10.2021 11:21:50
 *   Author: student
  
.equ	adr_pocz=0x02fd
.equ	adr_konc=0x0307
.equ	wypelniacz=0x3e

.cseg
.org 0
			jmp pocz
.org 0x46
pocz:		ldi r16,wypelniacz
			ldi xl, byte1(adr_pocz) ;adres pocz�tkowy, cz�� m�odsza
			ldi xh, byte2(adr_pocz) ;adres pocz�tkowy, cz�� starsza
			ldi yl, byte1(adr_konc+1) ;adres ko�cowy, cz�� m�odsza
			ldi yh, byte2(adr_konc+1) ;adres ko�cowy, cz�� starsza

kolejna:		st x+,r16

				cp xl, yl ;por�wnujemy m�odsze bajty adres�w
				brbc 1,kolejna
				cp xh, yh ;por�wnujemy starsze bajty adres�w
				brbc 1,kolejna
koniec: jmp koniec



//modyfikacja *gdy r�wne adresy* 
.equ	adr_pocz=0x02fd
.equ	adr_konc=0x02fd
.equ	wypelniacz=0x3e

.cseg
.org 0
			jmp pocz
.org 0x46
pocz:		ldi r16,wypelniacz

			ldi xl, byte1(adr_pocz) ;adres pocz�tkowy, cz�� m�odsza
			ldi xh, byte2(adr_pocz) ;adres pocz�tkowy, cz�� starsza

			ldi yl, byte1(adr_konc+1) ;adres ko�cowy, cz�� m�odsza
			ldi yh, byte2(adr_konc+1) ;adres ko�cowy, cz�� starsza

kolejna:		st x+,r16

				cp xh, yh ;por�wnujemy m�odsze bajty adres�w
				brbs 0,zapisz
				brbc 1,kolejna
				cp yl, xl ;por�wnujemy starsze bajty adres�w
				brbc 0,koniec

zapisz:			st x+,r16
				jmp kolejna


koniec: jmp koniec
*/


//modyfikacja adres pocz�tkowy wiekszy od koncowego- brak ladowania

/*
 .org 0
 rjmp start
 
 .org 0x200
 TAB: .db 0x07, 0x03, 0x05, 0x0f, 0x04, 0x09, 0x06, 0x0b, 0x0e, 0x08, 0x01, 0x02, 0x0c, 0x0a, 0x0d  ;zero na koncu bo musza byc pary/zero uzupelnia bajt 16-bit

 start: ldi r16, 0 ;przez danie zero ustawiamy kierunek portu b na wejscie
		out ddrb, r16

		ldi r16, 0xFF ;przez danie jedynek ustawiamy kierunek portu c na wyj�cie
		out ddrc, r16
ldi xl, LOW(2 * TAB) ; ustalam m�odszy i starszy bajt pocz�tku tablicy (*2, bo pamie� progrmu jest 16 - bitowa)
		ldi xh, HIGH(2 * TAB)
 petla: in r18,PINB
		com r18		;r18 to numer liczby z tablicy
						;andi r18,0x0f	;and daje zero chyba ze jest 1 i 1 (0b00001111 and np. 0b01010011 -> 0b00000011)
		breq petla		;jesli nic nie nacisnieto jest zero -> wracamy do poczatku petli
						;16 badz wiecej lub 0 -> zgasic
		movw z,x
		dec r18
		add zl,r18
		ldi r18,0
		adc zh,r18
 
		;mov ZL,r16 ;zmienia sie tylko ZL, ZH jest takie samo caly czas
		;mov ZH,r17
		;movw z,x
		lpm r19,Z ;ladowanie liczby z tablicy do r19
		com r19		;na miejscach 1 beda 0
		out portc, r19

		rjmp petla
*/
/*
//zad 2b
.equ	adr_pocz=0x0307
.equ	adr_konc=0x02fd
.equ	wypelniacz=0x03

.cseg
.org 0
			jmp pocz
.org 0x46
pocz:		ldi r16,wypelniacz

			ldi xl, byte1(adr_pocz) ;adres pocz�tkowy, cz�� m�odsza
			ldi xh, byte2(adr_pocz) ;adres pocz�tkowy, cz�� starsza

			ldi yl, byte1(adr_konc+1) ;adres ko�cowy, cz�� m�odsza
			ldi yh, byte2(adr_konc+1) ;adres ko�cowy, cz�� starsza

kolejna:	cp yl, xl ;zasadniczo decyduj� starsze bajty, ale gdyby by�y r�wne 
					  ;to zdecyduj� m�odsze bajty
			cpc yh, xh ;gdy starsze bajty b�d� r�wne to cpc nie zmieni ustawienia
					   ;flag Z, C, kt�rego dokona� cp na bajtach m�odszych i one zdecyduj�
			brbs 0,koniec

zapisz:			st x+,r16
				jmp kolejna

koniec:		jmp koniec

*/

/*
//praca domowa zad2c
.equ	adr_pocz=0x02fd
.equ	adr_konc=0x0302
.equ	wypelniacz=0x03

.cseg
.org 0
			jmp pocz
.org 0x46
pocz:		ldi r16,wypelniacz
			ldi r17,2

			ldi xl, byte1(adr_pocz) ;adres pocz�tkowy, cz�� m�odsza
			ldi xh, byte2(adr_pocz) ;adres pocz�tkowy, cz�� starsza

			ldi yl, byte1(adr_konc) ;adres ko�cowy, cz�� m�odsza
			ldi yh, byte2(adr_konc) ;adres ko�cowy, cz�� starsza

kolejna:	cp yl, xl ;zasadniczo decyduj� starsze bajty, ale gdyby by�y r�wne 
					  ;to zdecyduj� m�odsze bajty
			cpc yh, xh ;gdy starsze bajty b�d� r�wne to cpc nie zmieni ustawienia
					   ;flag Z, C, kt�rego dokona� cp na bajtach m�odszych i one zdecyduj�
			brbs 0,koniec

zapisz:			st x+,r16
				add r16,r17
				jmp kolejna

koniec:		jmp koniec
*/

/*
//praca domowa zad 2c
.equ	adr_pocz = 0x02fd
.equ	wypelniacz=0x03
.equ	zwiekszenie=2
.equ	ostatnia=0x0d

.cseg
.org 0
			jmp pocz
.org 0x46
pocz:		ldi r16,wypelniacz
			ldi r17, zwiekszenie //zwiekszenie
			ldi r18, ostatnia //ko�cowa liczba do wpisu

			ldi xl, byte1(adr_pocz) ;adres pocz�tkowy, cz�� m�odsza
			ldi xh, byte2(adr_pocz) ;adres pocz�tkowy, cz�� starsza

kolejna:	cp r16, r18 ;por�wnanie do liczby ko�cowej

			brbs 0,zapisz
			brbc 1,koniec

zapisz:			st x+,r16
				add r16, r17
				jmp kolejna

koniec:		jmp koniec

*/
// zadanie 3 
.equ	ADR_D = 0x0200
.equ	ciag = 0xf1
.def	counter = r18
.def	endcounter = r19
.cseg
.org 0
			jmp pocz
.org 0x46
pocz:
			ldi counter, 8
			ldi endcounter, 0
			ldi r16, ciag
			ldi xl, byte1(ADR_D) ;adres poczatkowy, czesc mlodsza
			ldi xh, byte2(ADR_D) ;adres poczatkowy, czesc starsza
			st x+, r16
kolejna:	
			;reprezentacja bitu b7, b6, b5, b4, b3, b2, b1, b0
			;reprezentacja ciagu 0   0   0   0   0   0   0  1
			bst r16, 7 ;zapisz bit 7 w znaczniku flagi T
			bld r17, 0 ;za�aduj znacznik T do bitu 0 w rejestrze 17 
			st x+, r17 ;zapamietaj bit z rejestru, potem inkrementuj
			dec r18 ;zmniejsz p�tle o 1 obr�t
			rol r16 ; <- bity o jedn� pozycje w lewo (flaga Carry znacznik przeniesienia)
			;reprezentacja bitu C <- b6, b5, b4, b3, b2, b1, b0, b7 <- C
			cpse counter, endcounter ;je�li counter = endcounter pomi� nast�pny rozkaz idz do ko�ca, ma przej�� 8 p�tli do zapisu 8 bitow
			jmp kolejna

koniec:		jmp koniec