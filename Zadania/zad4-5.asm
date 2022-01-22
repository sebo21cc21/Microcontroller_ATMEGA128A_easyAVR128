/*
 * Lista2_zad5_6.asm
 *
 *  Created: 04.01.2022 21:55:40
 *   Author: sebo2
 */ 
 /*
 Lista 2 zadanie 4
Przes³ania: W pamiêci programu proszê umieœciæ tablicê z danymi 8-bitowymi zaczynaj¹c¹ siê 
od adresu ADR_C i zakoñczon¹ bajtem o zawartoœci 0xFF. Z kolei proszê napisaæ program 
przegl¹daj¹cy tê tablicê i wyszukuj¹cy w niej liczby parzyste, a nastêpnie umieszczaj¹cy je w 
drugiej tablicy zlokalizowanej w pamiêci danych pocz¹wszy od adresu ADR_D. Liczb 
nieparzystych w nowej tablicy nie zapisujemy. Utworzon¹ tablicê w pamiêci danych nale¿y tak¿e 
zakoñczyæ ci¹giem 0xFF.
Jak nale¿a³oby zmodyfikowaæ ten program, aby wyszukiwa³ i umieszcza³ w nowej tablicy,
zamiast liczb parzystych, liczby wiêksze od zadanej wartoœci progowej lub nale¿¹ce do zadanego 
przedzia³u wartoœci?
 */
 ;pamiêæ danych 
 ;1 rejestry robocze
 ;2 obszar wejscia wyjscia do 99
 ;od 0x100 obszar komórek do zapamiêtywania danych SRAM do 0x10FF
 ;XRAM mo¿na wsadziæ nikt nie odbiera do 0xFFFF
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
;upycha na m³odszy starszy, gdyby liczba by³a nieparzysta nie wie co za³adowaæ do starszego i za³aduje zera, ostrzezenie!

start:

	ldi zl, low(TAB<<1) ;load imediately, za³aduj adres bajtowy pocz¹tku tablicy, przesuniêcie logiczne o 1 w lewo, wszystkie rejestry s¹ zbudowane z 2 bajtów, w pamieci programu pojedyncze bajty, dzielenie na dwa bo jest na 16 bitach a my zapisaliœmy j¹ na dwóch 8-bitach
	ldi zh, high(TAB<<1)
	ldi xl, byte1(ADR_D)
	ldi xh, byte2(ADR_D)
	ldi r16, end_byte ; w celu porownania zapisanie 0xff jako koncowy adres
	ldi r20, wartosc_dolna
	ldi r21, wartosc_gorna 


petla:

	lpm r17, z+  ; £adujê do rejestru r17 to co znajdê w tabeli i przesuwam siê w tabeli
	cpse r17, r16 ;jeœli s¹ równe pomijamy nastêpny rozkaz, zapisywanie ma siê zakoñczyæ na ff 
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

	;cp r17, r21 ;jesli r17- tablica index, wieksze równe od wartosci gornej gasi carry
	;brbc 0, petla ;jesli carry zgaszone skacze do petli

	;cp r17, r21
	;brlo dodaj - skok gdy ponizej 
	;jmp petla
dodaj:

	sbrs r17, 0 ;Skip if Bit in Register, pominiêcie przy ustawionym bicie (nieparzyste bit 0 to 1)

	;bst r17, 0 ;najmlodszy bit parzystosci do flagi pu³apki  Bit Store from Bit in Register to T Flag in SREG
	;brbs 6, petla ; Jeœli we fladze T jest 1 (liczba nieparzysta), to pomijamy zapis liczby do tablicy result
	st x+, r17 ; zapisanie liczby z r17 do pamiêci danych
	jmp petla


koniec:

	st x, r17 ;zapisanie liczby z r17 i zakoñczenie na tym programu

jmp pc
 */


 /*
Lista 2, zadanie 5
Operacje logiczne: Proszê napisaæ program pobieraj¹cy kolejne bajty z tablicy w pamiêci
programu podobnej do tej z zadania 4. i modyfikuj¹cy je wed³ug nastêpuj¹cych zasad: jeœli
dwa najm³odsze bity to 0b01 wówczas pobranego bajtu nie nale¿y zmieniaæ, je¿eli zaœ te dwa
bity zawieraj¹ 0b10, to w tym bajcie nale¿y zanegowaæ wszystkie bity starszej tetrady. Je¿eli
dwa najm³odsze bity zawieraj¹ ci¹g 0b11, to w tym bajcie bity starszej tetrady nale¿y ustawiæ
na jedynki, gdy zaœ dwa najm³odsze bity to 0b00, wówczas starsz¹ tetradê zale¿y wyzerowaæ.
Bity m³odszej tetrady nie mog¹ ulec zmianie. Wszystkie bajty nale¿y zapisywaæ w kolejnych
komórkach w pamiêci danych pocz¹wszy od adresu ADR_D. Przed tym jednak nale¿y
sprawdziæ, czy bajt przetworzony wed³ug powy¿szych zasad nie sta³ siê symbolem koñca
tablicy 0xFF. Gdyby tak siê sta³o, to rezygnujemy z jego zapisania w tworzonej tablicy.
Dopiero po przejrzeniu ca³ej tablicy w pamiêci programu, utworzon¹ tablicê w pamiêci danych
nale¿y zakoñczyæ ci¹giem 0xFF.
Tablicê pierwotn¹ w pamiêci programu proszê przygotowaæ tak, aby umo¿liwia³a sprawdzenie
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
;upycha na m³odszy starszy, gdyby liczba by³a nieparzysta nie wie co za³adowaæ do starszego i za³aduje zera, ostrzezenie!

start:
	ldi zl, low(TAB<<1) ;load imediately, za³aduj adres bajtowy pocz¹tku tablicy, przesuniêcie logiczne o 1 w lewo, wszystkie rejestry s¹ zbudowane z 2 bajtów, w pamieci programu pojedyncze bajty, dzielenie na dwa bo jest na 16 bitach a my zapisaliœmy j¹ na dwóch 8-bitach
	ldi zh, high(TAB<<1)
	ldi xl, byte1(ADR_D)
 	ldi xh, byte2(ADR_D)
	ldi r16, end_byte ; w celu porownania zapisanie 0xff jako koncowy adres

pobierz:        ;pobranie kolejnych adresów z tablicy, sprawdzenie warunków i skierowanie liczby przechowywanej w rejestrze do w³aœciwej etykiety
                lpm r16, z+												  ;³adowanie kolejnych bajtów do r16
				cpi r16, end_byte      									  ;porównanie liczby z rejestru do sta³ej - w tym przypadku do 'koñca' (0xff)
				brbs 1, zapisz											  ;jeœli r16=koniec przechodzimy do etykiety zapisz

				mov r17, r16											  ;skopiowanie r16 do r17
				cbr r17, 0b11111100									      ;zostawiamy 2 najm³odsze bity aby móc je porównaæ
				
				cpi r17, 0b00000001										  ;porównaj: r17 i 0b01
				brbs 1, zero_jeden										  ;jeœli r17=0b01 -> skok do zero_jeden

				cpi r17, 0b00000010										  ;porównaj r17 i 0b10
				brbs 1, jeden_zero										  ;skok do jeden_zero jeœli s¹ równe

				cpi r17, 0b00000011										  ;porównaj r17 i 0b11
				brbs 1, jeden_jeden										  ;skok do jeden_jeden	 jeœli s¹ równe

zero_zero:		;0b00 -> wyzerowanie starszej tetrady
                cbr r16, 0b11110000								          ;clear bits in register - zeruje w rejestrze bity, które w sta³ej = 1 // wyzerowanie starszej tetrady
				st x+, r16												  ;zapis r16 do pamiêci IRAM
				rjmp pobierz											  ;przejœcie do etykiety 'pobierz' aby za³adowaæ kolejn¹ liczbê

zero_jeden:		;0b01 -> bez zmian
                st x+, r16												  ;zapis do IRAM
				rjmp pobierz											  ;relative jump
		  
jeden_zero:		;0b10 -> negacja starszej tetrady (zamiana 0 i 1)
                ldi r17, 0b11110000										  ;za³aduj sta³¹ do r17
				eor r16, r17											  ;zaneguj bity starszej tetrady, exclusive or
				st x+, r16												  ;zapisz wartosc r16 do pamieci
				rjmp pobierz											  ;skacz do pobierz i sprawda kolejna wartosc

jeden_jeden:	;0b11 -> starsza tetrada 1111
                sbr r16, 0b11110000										  ;ustaw jedynki na starszej tetradzie; set bit in register
				cpi r16, end_byte  										  ;sprawdzenie czy r16 to wartoœæ koñcowa
				brbs 1, pobierz											  ;przejœcie do 'pobierz' jeœli s¹ równe
				st x+, r16												  ;a jeœli nie wpisujemy w pamiêæ 
				brbc 1, pobierz											  ;i skaczemy do 'pobierz'

zapisz:			st x, r16									 			  ;wpisujemy ostatni¹ wartoœæ w pamiêæ Iram
				rjmp koniec                                               ;skaczemy do koñca

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