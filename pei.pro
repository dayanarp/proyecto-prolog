% Primer problema de prolog del prolog
%   I P1 P   *
%     P3 P2
%  ---------
% P6 I1 P5 P4 +
% P8 I2 P7
% -----------
% I4 I3 P9 P4
%
% se A el acarreo que se lleva en la suma y multiplicación.
%
% como P6 I1 es el resultado de P2 * I, suponiendo que P3 * P1 es menor que 10 y no
% hay acarreo, el menor resultado posible es que P6 = 2 y I1 = 1 que son 
% los digitos par e impar menores posibles, y como es cierto siempre que la 
% multiplicacion de un par por un impar es par, se debe tener un accareo impar
% de P2 * P1, por tanto P2 * P1 >= 12. Ademas  como se tiene que
% P3 * I = P8, I debe ser =< 3 para que el al multiplicarse por el par mas pequeño
% el resultado no sobrepase 8, que es el valor maximo para P8.
%
% como P6 + P8 + A = I4, se tiene que I4 =< 9 y entonces el valor máximo que pueden
% tomar P6 y P8 es 6, de manera que el min A sea 1 y el min P6 + P8 es 8.
%
% para que la multiplicación de dos numeros pares produzca un numero impar, como 
% en el caso P3 * P1 = I2, es porque P3 * P produjo un A impar, asi los posibles
% valores son 12, 16, 32 y 36 por tanto el mayor valor para P7 es 6.
%
% La suma de dos numeros impares como en I1 + I2 produce un numero par, por lo que
% I1 + I2 = I3 evidencia un A >= 1 de P5 + P7 y como el minimo valor de dos cifras
% resultado de sumar dos pares es 12, se tiene que P7 + P5 >= 12.
%
% como el valor maximo para los digitos pares es 8, P5 + P7 =< 16, por tanto, 
% y siguiento la regla anterior P9 =< 6.
%
% como P3 * P1 = I2, se tiene de nuevo el caso en que dos pares
% multiplicados dan como resultado un impar, para ello P3 * P debe generar un 
% A impar y como P7 >= 6 entonces P3 * P >= 16.
%
% igualmente P3 * I = P8, por lo que P3 * I =< 8.
%
% se observa que ninguno de los dígitos pares es cero, por tanto P4 es al menos
% el resultado de multiplicar los pares mas pequeños, es decir P4 >= 4.
%
% como P6 y P8 son al menos 6, y se tiene P6 + P8 = I4, suponiendo los pares
% minimos, I4 >= 5.
%
% como la suma de dos pares es par, para que P6 +P8 = I4 debe haber un acarreo 
% A = 1 de I1 + I2, por lo que I1 + I2 >= 10.

pei :-
	Pares = [P4,P3,P1,P,P9,P5,P2,P7,P6,P8],
	Impares = [I3,I,I2,I1,I4],
        DigitosP = [2,4,6,8],
	DigitosI = [1,3,5,7,9],
        assign_digits(Pares,DigitosP),
	P8 =< 6,
	P6 =< 6,
	P6 + P8 =< 8,
	P7 =< 6,
	P5 + P7 >= 12,
	P9 =< 6,
	P2 * P1 >= 12,
	P3 * P >= 16,
	P3 * P1 =< 8,
	P4 >= 4,
	assign_digits(Impares,DigitosI),
	I4 >= 5,
	I1 > 1,
	I2 > 1,
	I1 + I2 >= 10,
	I =< 3,
	P2 * I >= 21,
	I * P3 =< 8,
	Factor1 is (I*100 + P1*10 +P),
        Multiplicacion1 is P2*Factor1,
	Sumando1 is (P6*1000 + I1*100 + P5*10 + P4),
	Multiplicacion1 =:= Sumando1,
	Multiplicacion2 is P3*Factor1,
	Sumando2 is (P8*100 + I2*10 + P7),
	Multiplicacion2 =:= Sumando2,
	Resultado is (I4*1000 + I3*100 + P9*10 + P4),
	Resultado =:= Sumando1 + Sumando2*10,
	format('\n ~d *\n  ~d~d\n ---- \n ~d +\n ~d\n ----\n ~d',[Factor1,P3,P2,Sumando1,Sumando2,Resultado]),!.
	
assign_digits([], _List).
assign_digits([D|Ds],List) :-
        member(D,List),
        assign_digits(Ds, List).



