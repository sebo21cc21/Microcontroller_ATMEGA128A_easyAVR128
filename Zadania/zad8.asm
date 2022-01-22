/*
 * zad8.asm
 *
 *  Created: 20.01.2022 15:42:04
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
8. Osiem przycisk�w dost�pnych w makiecie dzielimy na dwie grupy; podzia� ma by� roz��czny 
i wyczerpuj�cy. Np. 4 przyciski w dolnym rz�dzie to pierwsza grupa, a 4 w g�rnym - to druga. 
Prosz� napisa� program sprawdzaj�cy, do kt�rej grupy nale�� naci�ni�te przyciski 
i wy�wietlaj�cy na 8 diodach jeden z 4 komunikat�w:
- gdy naci�ni�to przyciski tylko z pierwszej grupy - komunikat1,
- gdy naci�ni�to przyciski tylko z drugiej grupy - komunikat2,
- gdy naci�ni�to przyciski z obu grup - komunikat3,
- gdy niczego nie naci�ni�to - komunikat4.
Komunikatami maj� by�, zdefiniowane przez Pa�stwa, ci�gi zapalonych i zgaszonych diod 
pod��czonych do poru C. Komunikaty mog� by� dowolne, ale w komentarzach prosz� poda� jaki 
podzia� klawiszy na grupy zastosowano i jakie komunikaty wybrano. Prosz� przyj��, �e spos�b 
pod��czenia przycisk�w i diod jest taki jak na schemacie dost�pnym na ePortalu w materiale 
�Nasze_makiety�.
*/
;eor jest dlatego �e w poprzednim za�o�eniu jakie mia�em to �e przy czarnych si� nie pali by�o �adnie wida�, a teraz trzeba dawa� eor �eby si� pali�y na starcie
.cseg
	.org 0 

jmp poczatek
	.org 0x100

poczatek:
	ldi r16, 0b11111111 ;wstawienie jedynek do rejestru 16
	ldi r17, 0b00000000 ;wstawienie zer do rejestru 17
	ldi r20, 0b00001111
	ldi r21, 0b11110000
	out DDRC, r16 ;PORTC na wyj�cie - LED, 
	out PORTC, r16 ;1- dioda nie �wieci
	out DDRB, r17 ;PORTB na wej�cie - klawisze
	out PORTB, r16 ;rezystory podci�gaj�ce, u nas nie trzeba w��cza�, je�li przycisk nie jest wci�ni�ty to bez rezystora podci�gaj�cego wej�cie zbiera�oby "zak��cenia z powietrza"

sprawdz_1_grupe: ;sprawdza czy w 1 grupie ostatnie bity s� zerami je�li tak idzie do 2 grupy, jak nie s� to idzie do sprawdz oba
	in r18, PINB ;w r18 warto�� przypisana do wci�nietego przycisku
	mov r19, r18 ;kopia
	eor r19, r20 ;negacja kopii 4 ostatnich bit�w
	andi r19, 0b00001111 ;ustawienie 4 pierwszych na zero
	brbs 1, sprawdz_2_grupe ;poprzedni warunek wyzerowany ca�y? idz do 2 grupy

sprawdz_oba:
	in r18, PINB
	mov r19, r18
	eor r19, r21 ;neguje 4 pierwsze bity
	andi r19, 0b11110000 ;ustawia 4 ostatnie bity na 0
	brbc 1, zapal_wszystkie
	jmp zapal_1_grupe

sprawdz_2_grupe:
	in r18, PINB
	mov r19, r18
	eor r19, r21 ;neguje 4 pierwsze bity
	andi r19, 0b11110000 ;ustawia 4 ostatnie bity na 0
	brbs 1, zaden_guzik
	jmp zapal_2_grupe

zaden_guzik:
	ldi r18, 0b11111111
	out PORTC, r18
	jmp sprawdz_1_grupe

zapal_1_grupe:
	ldi r18, 0b11110000
	out PORTC, r18
	jmp sprawdz_1_grupe

zapal_2_grupe:
	ldi r18, 0b00001111
	out PORTC, r18
	jmp sprawdz_1_grupe

zapal_wszystkie:
	ldi r18, 0b00000000
	out PORTC, r18
	jmp sprawdz_1_grupe
