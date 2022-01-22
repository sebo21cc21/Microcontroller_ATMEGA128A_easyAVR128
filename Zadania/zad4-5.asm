/*
 * Lista2_zad5_6.asm
 *
 *  Created: 04.01.2022 21:55:40
 *   Author: sebo2
 */ 
 /*
 Lista 2 zadanie 4
Przes�ania: W pami�ci programu prosz� umie�ci� tablic� z danymi 8-bitowymi zaczynaj�c� si� 
od adresu ADR_C i zako�czon� bajtem o zawarto�ci 0xFF. Z kolei prosz� napisa� program 
przegl�daj�cy t� tablic� i wyszukuj�cy w niej liczby parzyste, a nast�pnie umieszczaj�cy je w 
drugiej tablicy zlokalizowanej w pami�ci danych pocz�wszy od adresu ADR_D. Liczb 
nieparzystych w nowej tablicy nie zapisujemy. Utworzon� tablic� w pami�ci danych nale�y tak�e 
zako�czy� ci�giem 0xFF.
Jak nale�a�oby zmodyfikowa� ten program, aby wyszukiwa� i umieszcza� w nowej tablicy,
zamiast liczb parzystych, liczby wi�ksze od zadanej warto�ci progowej lub nale��ce do zadanego 
przedzia�u warto�ci?
 */
 ;pami�� danych 
 ;1 rejestry robocze
 ;2 obszar wejscia wyjscia do 99
 ;od 0x100 obszar kom�rek do zapami�tywania danych SRAM do 0x10FF
 ;XRAM mo�na wsadzi� nikt nie odbiera do 0xFFFF
 /*
.equ ADR_C = 0x100
.equ ADR_D = 0x300
.equ wartosc_dolna = 0x03
.equ wartosc_gorna = 0x50
.equ end_byte = 0xFF

.cseg
.org 0
	jmp start
.org ADR_C
	TAB: .db low(0x1101), high(0x0211), 0x03, 0x06, 0x13, 0x22, 0x86, 0xFF ;define byte umieszczamy dyrektywa dane w pamieci programu w adresie poczatku tego miejsca TAB
;upycha na m�odszy starszy, gdyby liczba by�a nieparzysta nie wie co za�adowa� do starszego i za�aduje zera, ostrzezenie!

start:

	ldi zl, low(TAB<<1) ;load imediately, za�aduj adres bajtowy pocz�tku tablicy, przesuni�cie logiczne o 1 w lewo, wszystkie rejestry s� zbudowane z 2 bajt�w, w pamieci programu pojedyncze bajty, dzielenie na dwa bo jest na 16 bitach a my zapisali�my j� na dw�ch 8-bitach
	ldi zh, high(TAB<<1)
	ldi xl, byte1(ADR_D)
	ldi xh, byte2(ADR_D)
	ldi r16, end_byte ; w celu porownania zapisanie 0xff jako koncowy adres
	ldi r20, wartosc_dolna
	ldi r21, wartosc_gorna 


petla:

	lpm r17, z+  ; �aduj� do rejestru r17 to co znajd� w tabeli i przesuwam si� w tabeli
	cpse r17, r16 ;je�li s� r�wne pomijamy nast�pny rozkaz, zapisywanie ma si� zako�czy� na ff 
	jmp granica_dolna
	jmp koniec

granica_dolna:
	
	;uwzgledniajac domkniecie
	cp r17, r20
	brbs 0, petla

	;uwzgledniajac otwarcie
	;cp r20, r17   ;jesli r20 wieksze rowne od wartosci dolnej gasi Carry
	;brbc 0, petla ;jesli carry zgaszone skacze do petli

	;cp r17, r20
	;brsh granica_dolna - skok wzgledny gdy wieksze rowne
	;jmp petla
granica_gorna:

	cp r21, r17
	brbs 0, petla

	;cp r17, r21 ;jesli r17- tablica index, wieksze r�wne od wartosci gornej gasi carry
	;brbc 0, petla ;jesli carry zgaszone skacze do petli

	;cp r17, r21
	;brlo dodaj - skok gdy ponizej 
	;jmp petla
dodaj:

	sbrs r17, 0 ;Skip if Bit in Register, pomini�cie przy ustawionym bicie (nieparzyste bit 0 to 1)

	;bst r17, 0 ;najmlodszy bit parzystosci do flagi pu�apki  Bit Store from Bit in Register to T Flag in SREG
	;brbs 6, petla ; Je�li we fladze T jest 1 (liczba nieparzysta), to pomijamy zapis liczby do tablicy result
	st x+, r17 ; zapisanie liczby z r17 do pami�ci danych
	jmp petla


koniec:

	st x, r17 ;zapisanie liczby z r17 i zako�czenie na tym programu

jmp pc
 */


 /*
Lista 2, zadanie 5
Operacje logiczne: Prosz� napisa� program pobieraj�cy kolejne bajty z tablicy w pami�ci
programu podobnej do tej z zadania 4. i modyfikuj�cy je wed�ug nast�puj�cych zasad: je�li
dwa najm�odsze bity to 0b01 w�wczas pobranego bajtu nie nale�y zmienia�, je�eli za� te dwa
bity zawieraj� 0b10, to w tym bajcie nale�y zanegowa� wszystkie bity starszej tetrady. Je�eli
dwa najm�odsze bity zawieraj� ci�g 0b11, to w tym bajcie bity starszej tetrady nale�y ustawi�
na jedynki, gdy za� dwa najm�odsze bity to 0b00, w�wczas starsz� tetrad� zale�y wyzerowa�.
Bity m�odszej tetrady nie mog� ulec zmianie. Wszystkie bajty nale�y zapisywa� w kolejnych
kom�rkach w pami�ci danych pocz�wszy od adresu ADR_D. Przed tym jednak nale�y
sprawdzi�, czy bajt przetworzony wed�ug powy�szych zasad nie sta� si� symbolem ko�ca
tablicy 0xFF. Gdyby tak si� sta�o, to rezygnujemy z jego zapisania w tworzonej tablicy.
Dopiero po przejrzeniu ca�ej tablicy w pami�ci programu, utworzon� tablic� w pami�ci danych
nale�y zako�czy� ci�giem 0xFF.
Tablic� pierwotn� w pami�ci programu prosz� przygotowa� tak, aby umo�liwia�a sprawdzenie
wszystkich opcji programu.
 */
 /*
.equ ADR_C = 0x100
.equ ADR_D = 0x300
.equ end_byte = 0xFF

.cseg
.org 0
	jmp start
.org ADR_C
	TAB: .db 0b00000000, 0b00000010, 0b00000011, 0b11111101, 0b11111110, 0b11111100, 0b00001111, 0b11111111 ;define byte umieszczamy dyrektywa dane w pamieci programu w adresie poczatku tego miejsca TAB
;upycha na m�odszy starszy, gdyby liczba by�a nieparzysta nie wie co za�adowa� do starszego i za�aduje zera, ostrzezenie!

start:
	ldi zl, low(TAB<<1) ;load imediately, za�aduj adres bajtowy pocz�tku tablicy, przesuni�cie logiczne o 1 w lewo, wszystkie rejestry s� zbudowane z 2 bajt�w, w pamieci programu pojedyncze bajty, dzielenie na dwa bo jest na 16 bitach a my zapisali�my j� na dw�ch 8-bitach
	ldi zh, high(TAB<<1)
	ldi xl, byte1(ADR_D)
 	ldi xh, byte2(ADR_D)
	ldi r16, end_byte ; w celu porownania zapisanie 0xff jako koncowy adres

pobierz:        ;pobranie kolejnych adres�w z tablicy, sprawdzenie warunk�w i skierowanie liczby przechowywanej w rejestrze do w�a�ciwej etykiety
                lpm r16, z+												  ;�adowanie kolejnych bajt�w do r16
				cpi r16, end_byte      									  ;por�wnanie liczby z rejestru do sta�ej - w tym przypadku do 'ko�ca' (0xff)
				brbs 1, zapisz											  ;je�li r16=koniec przechodzimy do etykiety zapisz

				mov r17, r16											  ;skopiowanie r16 do r17
				cbr r17, 0b11111100									      ;zostawiamy 2 najm�odsze bity aby m�c je por�wna�
				
				cpi r17, 0b00000001										  ;por�wnaj: r17 i 0b01
				brbs 1, zero_jeden										  ;je�li r17=0b01 -> skok do zero_jeden

				cpi r17, 0b00000010										  ;por�wnaj r17 i 0b10
				brbs 1, jeden_zero										  ;skok do jeden_zero je�li s� r�wne

				cpi r17, 0b00000011										  ;por�wnaj r17 i 0b11
				brbs 1, jeden_jeden										  ;skok do jeden_jeden	 je�li s� r�wne

zero_zero:		;0b00 -> wyzerowanie starszej tetrady
                cbr r16, 0b11110000								          ;clear bits in register - zeruje w rejestrze bity, kt�re w sta�ej = 1 // wyzerowanie starszej tetrady
				st x+, r16												  ;zapis r16 do pami�ci IRAM
				rjmp pobierz											  ;przej�cie do etykiety 'pobierz' aby za�adowa� kolejn� liczb�

zero_jeden:		;0b01 -> bez zmian
                st x+, r16												  ;zapis do IRAM
				rjmp pobierz											  ;relative jump
		  
jeden_zero:		;0b10 -> negacja starszej tetrady (zamiana 0 i 1)
                ldi r17, 0b11110000										  ;za�aduj sta�� do r17
				eor r16, r17											  ;zaneguj bity starszej tetrady, exclusive or
				st x+, r16												  ;zapisz wartosc r16 do pamieci
				rjmp pobierz											  ;skacz do pobierz i sprawda kolejna wartosc

jeden_jeden:	;0b11 -> starsza tetrada 1111
                sbr r16, 0b11110000										  ;ustaw jedynki na starszej tetradzie; set bit in register
				cpi r16, end_byte  										  ;sprawdzenie czy r16 to warto�� ko�cowa
				brbs 1, pobierz											  ;przej�cie do 'pobierz' je�li s� r�wne
				st x+, r16												  ;a je�li nie wpisujemy w pami�� 
				brbc 1, pobierz											  ;i skaczemy do 'pobierz'

zapisz:			st x, r16									 			  ;wpisujemy ostatni� warto�� w pami�� Iram
				rjmp koniec                                               ;skaczemy do ko�ca

koniec:			jmp koniec	
*/

.cseg
.org 0
	jmp start
.org 0x100
start: 
	ldi r16, 3

petla:
inc r16
brbc 1, petla

koniec: jmp koniec