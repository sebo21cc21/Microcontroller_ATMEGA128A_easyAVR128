/*
 * zad8.asm
 *
 *  Created: 20.01.2022 15:42:04
 *   Author: sebo2
 */ 

/*
ROZKAZY Z BRAMEK LOGICZNYCH
andi rd, sta³a ZEROWANIE 
Ori rd, sta³a  USTAWIANIE
Eor rd, rs NEGACJA
com rd wszystkie bity neguj
aliasy:
sbr rd ustawia
cbr rd czyœci 

lsl rd przesuwa w lewo wstawia 0
lsr rd  przesuwa w prawo wstawia 0
Rol rd przesuwa w lewo wstawia to co w Carry
ror rd przesuwa w prawo wstawia carry
Arithmetic shift right - asr rd wstawia to co by³o po lewej do tego co po lewej i leci w prawo po czym ostatni po prawej wstawia do Carry 

Podwajanie to lsl
Dzielenie lsr
PORTY
Bramy do komunikacji
6 8-biotowych i jeden 5 G
Max pr¹d w porcie to <= 40 mA
Na wsystkich max 400 mA 

PIN - port input pins odczyt
zapis odczyt:
DDR data direction register 
PORT- data register 


sbi set bit in I/O na wejscie wyjscie 
przy 1 sbi na wyjscie!
przy 0 na wejœcie!
cbi PORTD, 4 
Out zapis rejestru do komórki we/wy
In zapis komórki we/wy do rejestry




PORT B przycisk 
PORT C dioda
PORT D przerywañ zewnêtrznych 2
Stan wyoki 1 Ÿród³o pr¹du
Stan niski 0 odbiornik pr¹du do 2mA 5V 

DDR 0 na wejœcie
DDR 1 na wyjœcie 

0 na DDR 1 na Porcie z podci¹gananiem wejscie, potencja³ gdy wy³¹cznik otwarty 


DDR rejestr okreslajacy kierunek portu na wejscie/wyjscie
 */
/*
8. Osiem przycisków dostêpnych w makiecie dzielimy na dwie grupy; podzia³ ma byæ roz³¹czny 
i wyczerpuj¹cy. Np. 4 przyciski w dolnym rzêdzie to pierwsza grupa, a 4 w górnym - to druga. 
Proszê napisaæ program sprawdzaj¹cy, do której grupy nale¿¹ naciœniête przyciski 
i wyœwietlaj¹cy na 8 diodach jeden z 4 komunikatów:
- gdy naciœniêto przyciski tylko z pierwszej grupy - komunikat1,
- gdy naciœniêto przyciski tylko z drugiej grupy - komunikat2,
- gdy naciœniêto przyciski z obu grup - komunikat3,
- gdy niczego nie naciœniêto - komunikat4.
Komunikatami maj¹ byæ, zdefiniowane przez Pañstwa, ci¹gi zapalonych i zgaszonych diod 
pod³¹czonych do poru C. Komunikaty mog¹ byæ dowolne, ale w komentarzach proszê podaæ jaki 
podzia³ klawiszy na grupy zastosowano i jakie komunikaty wybrano. Proszê przyj¹æ, ¿e sposób 
pod³¹czenia przycisków i diod jest taki jak na schemacie dostêpnym na ePortalu w materiale 
„Nasze_makiety”.
*/
;eor jest dlatego ¿e w poprzednim za³o¿eniu jakie mia³em to ¿e przy czarnych siê nie pali by³o ³adnie widaæ, a teraz trzeba dawaæ eor ¿eby siê pali³y na starcie
.cseg
	.org 0 

jmp poczatek
	.org 0x100

poczatek:
	ldi r16, 0b11111111 ;wstawienie jedynek do rejestru 16
	ldi r17, 0b00000000 ;wstawienie zer do rejestru 17
	ldi r20, 0b00001111
	ldi r21, 0b11110000
	out DDRC, r16 ;PORTC na wyjœcie - LED, 
	out PORTC, r16 ;1- dioda nie œwieci
	out DDRB, r17 ;PORTB na wejœcie - klawisze
	out PORTB, r16 ;rezystory podci¹gaj¹ce, u nas nie trzeba w³¹czaæ, jeœli przycisk nie jest wciœniêty to bez rezystora podci¹gaj¹cego wejœcie zbiera³oby "zak³ócenia z powietrza"

sprawdz_1_grupe: ;sprawdza czy w 1 grupie ostatnie bity s¹ zerami jeœli tak idzie do 2 grupy, jak nie s¹ to idzie do sprawdz oba
	in r18, PINB ;w r18 wartoœæ przypisana do wciœnietego przycisku
	mov r19, r18 ;kopia
	eor r19, r20 ;negacja kopii 4 ostatnich bitów
	andi r19, 0b00001111 ;ustawienie 4 pierwszych na zero
	brbs 1, sprawdz_2_grupe ;poprzedni warunek wyzerowany ca³y? idz do 2 grupy

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
