//---- funkcja XOR
//---- algorytm wstecznej propagacji bledu
clear all;
// dane trenujące - wg nich sprawdzaj wprowadzane u1 i u2
A(1,1)=1; A(1,2)=0; A(1,3)=0; A(1,4)=0;
A(2,1)=1; A(2,2)=0; A(2,3)=1; A(2,4)=1;
A(3,1)=1; A(3,2)=1; A(3,3)=0; A(3,4)=1;
A(4,1)=1; A(4,2)=1; A(4,3)=1; A(4,4)=0;
//---- wykreslenie obszaru klasyfikacji
Licz=0;
IleKrokow=50000;
mtlb_hold on;
for i=1:4
if A(i,4)==1
plot(A(i,2),A(i,3),'ko:');
else
plot(A(i,2),A(i,3),'r+:');
end
end
mtlb_axis([-0.4 1.4 -0.4 1.4]);

//---- utworzenie odpowiednich tablic na dane
W=zeros(1,9); S=zeros(1,3); U=zeros(1,3); F=zeros(1,3); d=zeros(1,3); // definicja wektorów

//---- losowa inicjalizacja wag poczatkowych
for i=1:9 // losowanie wag
W(i)=rand()-0.5; // od -0.5 dp 0.5
end;
ro=0.2; // bład dopuszczalny
iteracja=0;
while (iteracja<IleKrokow)
iteracja=iteracja+1;
//---- losowe wybieranie wektora trenujacego
i=round(rand()*3)+1; // losowa liczba z zakresu 1-4, round zaokrąglenie

//---- faza propagacji w przod - warstwa posrednia
S(1)=W(1)*A(i,1)+W(2)*A(i,2)+W(3)*A(i,3);
S(2)=W(4)*A(i,1)+W(5)*A(i,2)+W(6)*A(i,3);
U(1)=1/(1+exp(-S(1))); // wartosci wyjsc
U(2)=1/(1+exp(-S(2)));

//---- faza propagacji w przod - warstwa wyjsciowa
S(3)=W(7)*A(i,1)+W(8)*U(1)+W(9)*U(2); // suma ważona
U(3)=1/(1+exp(-S(3)));                  // wartośc aktywacji 




//---- faza propagacji wstecz - warstwa wyjsciowa
F(3)=U(3)*(1-U(3));
d(3)=(A(i,4)-U(3))*F(3); // delta

//---- faza propagacji wstecz - warstwa posrednia
F(1)=U(1)*(1-U(1)); // pochodne
d(1)=W(8)*d(3)*F(1);
F(2)=U(2)*(1-U(2));
d(2)=W(9)*d(3)*F(2);

//---- uaktualnienie wag - warstwa wyjsciowa
W(7)=W(7)+(ro*d(3)*A(i,1));
W(8)=W(8)+(ro*d(3)*U(1));
W(9)=W(9)+(ro*d(3)*U(2));

//---- uaktualnienie wag - warstwa posrednia
W(1)=W(1)+(ro*d(1)*A(i,1));
W(2)=W(2)+(ro*d(1)*A(i,2));
W(3)=W(3)+(ro*d(1)*A(i,3));
W(4)=W(4)+(ro*d(2)*A(i,1));
W(5)=W(5)+(ro*d(2)*A(i,2));
W(6)=W(6)+(ro*d(2)*A(i,3));
end;

//---- wykreslenie otrzymanej linii podzialu (neuron 1)
k=0;
for i=-2:0.01:2
k=k+1;
XX(k)=i;
YY(k)=-((W(2)/W(3))*i)-(W(1)*1)/W(3);
end
plot(XX,YY,'r');

//---- wykreslenie otrzymanej linii podzialu (neuron 2)
k=0;
for i=-2:0.01:2
k=k+1;
XX(k)=i;
YY(k)=-((W(5)/W(6))*i)-(W(4)*1)/W(6);
end
plot(XX,YY,'b');
mtlb_axis([-0.4 1.4 -0.4 1.4]);
disp(W);
mtlb_hold off;
// d co setna iteracja, instarukakcja modulo, wg wzoru w instrukcji
disp (" 1 - wprowadzam dane");
petla = input ("czy chcesz wprowadzić dane U1 i U2 ?");
while(petla == 1)
    
disp ("Podaj dane u1 i u2");
U1 = input("Podaj u1");
U2 = input("Podaj u2");

S(1)=W(1)*1+W(2)*U1+W(3)*U2;            // suma ważona -- sprawdz numery indeksów względem rysunku, są inne
U(1)=1/(1+exp(-S(1)));                  // wartośc aktywacji 

S(2)=W(4)*1+W(5)*U1+W(6)*U2;            // suma ważona
U(2)=1/(1+exp(-S(2)));                  // wartośc aktywacji 

S(3)=W(7)*1+W(8)*U(1)+W(9)*U(2);        // suma ważona
U(3)=1/(1+exp(-S(3)));                  // wartośc aktywacji 

disp (U(3), "Wartośc U3 = ");
end;
