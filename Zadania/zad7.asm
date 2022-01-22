/*
 * zad7.asm
 *
 *  Created: 14.01.2022 03:22:35
 *   Author: sebo2
 */ 
 /*
ROZKAZY Z BRAMEK LOGICZNYCH
andi rd, sta�a ZEROWANIE 
Ori rd, sta�a  USTAWIANIE
Eor rd, rs NEGACJA
com rd wszystkie bity neguj
aliasy:
sbr rd ustawia
cbr rd czy�ci 

lsl rd przesuwa w lewo wstawia 0
lsr rd  przesuwa w prawo wstawia 0
Rol rd przesuwa w lewo wstawia to co w Carry
ror rd przesuwa w prawo wstawia carry
Arithmetic shift right - asr rd wstawia to co by�o po lewej do tego co po lewej i leci w prawo po czym ostatni po prawej wstawia do Carry 

Podwajanie to lsl
Dzielenie lsr
PORTY
Bramy do komunikacji
6 8-biotowych i jeden 5 G
Max pr�d w porcie to <= 40 mA
Na wsystkich max 400 mA 

PIN - port input pins odczyt
zapis odczyt:
DDR data direction register 
PORT- data register 


sbi set bit in I/O na wejscie wyjscie 
przy 1 sbi na wyjscie!
przy 0 na wej�cie!
cbi PORTD, 4 
Out zapis rejestru do kom�rki we/wy
In zapis kom�rki we/wy do rejestry




PORT B przycisk 
PORT C dioda
PORT D przerywa� zewn�trznych 2
Stan wyoki 1 �r�d�o pr�du
Stan niski 0 odbiornik pr�du do 2mA 5V 

DDR 0 na wej�cie
DDR 1 na wyj�cie 

0 na DDR 1 na Porcie z podci�gananiem wejscie, potencja� gdy wy��cznik otwarty 


DDR rejestr okreslajacy kierunek portu na wejscie/wyjscie
 */

 /*
 7. Prosz� zmodyfikowa� program z zadania 6 w taki spos�b, by ka�demu z kluczy dolnego rz�du 
(tzn. kluczom pod��czonym do bit�w o numerach od 0 do 3 portu B) mog�a by� przypisana jedna,
ale dowolna dioda pod��czona do portu C. Klucze g�rnego rz�du (pod��czone do bit�w portu B 
o numerach od 4 do 7) nie musz� by� obs�ugiwane. Prosz� przyj��, �e spos�b pod��czenia 
przycisk�w i diod jest taki jak na schemacie dost�pnym na ePortalu w materiale 
�Nasze_makiety�. Program prosz� uruchomi� i sprawdzi� najpierw symulacyjnie, a nast�pnie w 
makiecie. Ponadto prosz� przeanalizowa�, jak Pa�stwa program zachowa si�, gdy naci�niemy 
wi�cej ni� jeden przycisk. Prosz� t� wa�n� w�a�ciwo�� zbada� symulacyjnie i szczeg�owo 
opisa� w komentarzach.
 */
 /*
.equ pierwszy = 0b10000000 
.equ drugi = 0b01000000
.equ trzeci = 0b00100000
.equ czwarty = 0b00010000

.cseg
	rjmp pocz
.org 0x100
 
pocz:
 ldi r16, 0xff ;wstawienie jedynek do rejestru 16
 ldi r17, 0x0
 out DDRC, r16 ;PORTC na wyj�cie - LED, 
 out PORTC, r17 ;0- dioda nie �wieci
 out DDRB, r17 ;PORTB na wej�cie - klawisze
 out PORTB, r16 ;rezystory podci�gaj�ce, u nas nie trzeba w��cza�, je�li przycisk nie jest wci�ni�ty to bez rezystora podci�gaj�cego wej�cie zbiera�oby "zak��cenia z powietrza"

przypisanie:
	ldi r17, pierwszy
	ldi r18, drugi
	ldi r19, trzeci
	ldi r20, czwarty

petla: ;sprawdzanie ktory guzik jest wcisniety
	in r16, pinb ;w r16 warto�� przypisana do wci�nietego przycisku
	andi r16, 0b00001111 ;wyzerowanie starszej tetrady
	cpi r16, 0b00000001
	breq jeden
	cpi r16, 0b00000010
	breq dziesiec
	cpi r16, 0b00000100
	breq sto
	cpi r16, 0b00001000
	breq tysiac

	cpi r16, 0b00000000
	;breq zero
	jmp zero

jeden:
	out PORTC, r17 ;wysylanie wartosci r17 na port c
	jmp petla

dziesiec:
	out PORTC, r18 ;zapalenie diody
	jmp petla

sto:
	out PORTC, r19
	jmp petla

tysiac:
	out PORTC, r20
	jmp petla

zero:
	ldi r21, 0b00000000
	out PORTC, r21 ;gaszenie diod
	jmp petla
*/

.equ pierwszy = 0b01111111 
.equ drugi = 0b10111111
.equ trzeci = 0b11011111
.equ czwarty = 0b11101111
 .cseg
	rjmp pocz
 .org 0x100
 
 pocz:
	ldi r16, 0xff
	ldi r17, 0x0
	out DDRC, r16 ;PORTC na wyj�cie 1 - LED
	out PORTC, r16
	out DDRB, r17 ;PORTB na wej�cie 0 - klawisze
	out PORTB, r16 ;rezystory podci�gaj�ce, a u nas trzeba wl�cza� on zbiera szumy i jak nie jest w�aczony to wtedy moze nie wczytywac dobrze pinow B


przypisanie:
	ldi r17, pierwszy
	ldi r18, drugi
	ldi r19, trzeci
	ldi r20, czwarty

odsylanie: ;sprawdzanie ktory guzik jest wcisniety
	in r16, pinb
	com r16 ;negacja rejestru
	andi r16, 0b00001111 ;wyzerowanie starszej tetrady
	cpi r16, 0b00000001
	breq jeden
	cpi r16, 0b00000010
	breq dziesiec
	cpi r16, 0b00000100
	breq sto
	cpi r16, 0b00001000
	breq tysiac


	jmp zero

jeden:
	out PORTC, r17 ;wysylanie wartosci r17 na port c
	jmp odsylanie

dziesiec:
	out PORTC, r18 ;zapalenie diody
	jmp odsylanie

sto:
	out PORTC, r19
	jmp odsylanie

tysiac:
	out portc, r20
	jmp odsylanie

zero:
	ldi r21, 0b11111111
	out PORTC, r21 ;gaszenie diod
	jmp odsylanie