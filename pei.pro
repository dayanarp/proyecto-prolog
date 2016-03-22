% Primer problema de prolog del prolog
% tarda 25000 ms aproximadamente

pei :-
	X = [P4,P3,P1,P,P9,P5,P7,P6,P8],
	Y = [I3,I,I2,I1,I4],
        EvenDigits = [2,4,6,8],
	OddDigits = [1,3,5,7,9],
        assign_digits(X,EvenDigits),
	P2 is 8,
	P8 =< 6,
	P6 =< 6,
	P6 + P8 =< 8,
	P7 >= 6,
	P5 + P7 >= 12,
	P9 =< 6,
	P1 =< 4,
	P3 =< 4,
	P3 * P >= 12,
	P3 * P1 =< 8,
	P4 >= 4,
	assign_digits(Y,OddDigits),
	I4 > 5,
	I1 > 1,
	I2 > 1,
	I1 + I2 >= 10,
	I =< 3,
	P2 * I >= 21,
	I * P3 =< 8,
        FNum is P2*(I*100 + P1*10 +P),
	SNum is (P6*1000 + I1*100 + P5*10 + P4),
	FNum =:= SNum,
	TNum is P3*(I*100 + P1*10 +P),
	QNum is (P8*100 + I2*10 + P7),
	TNum =:= QNum,
	KNum is (I4*1000 + I3*100 + P9*10 + P4),
	KNum =:= FNum + TNum*10,
	format('\n ~d~d~d * \n  ~d~d\n ---- \n ~d~d~d~d + \n ~d~d~d\n ----\n ~d~d~d~d',[I,P1,P,P3,P2,P6,I1,P5,P4,P8,I2,P7,I4,I3,P9,P4]),!.
	
assign_digits([], _List).
assign_digits([D|Ds],List) :-
        member(D,List),
        assign_digits(Ds, List).



