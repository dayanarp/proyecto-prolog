% Primer problema de prolog del pro
% no puedo enumerar las p tipo P1, P2, etc, eso me da conflicto

pei :-
	X = [P3,P1,P4,P2,P,P9,P7,P5,P6,P8],
	Y = [I3,I2,I,I1,I4],
        EvenDigits = [2,4,6,8],
	OddDigits = [1,3,5,7,9],
        assign_digits(X,EvenDigits),
	P6 + P8 =< 8,
	P5 + P7 >= 10,
	P9 =< 6,
	assign_digits(Y,OddDigits),
	I4 > 5,
	I1 + I2 >= 10,
	I * P3 =< 8,
	Num is (I*100 + P1*10 +P),
        FNum is P2*Num,
	SNum is (P6*1000 + I1*100 + P5*10 + P4),
	FNum =:= SNum,
	TNum is P3*Num,
	QNum is (P8*100 + I2*10 + P7),
	TNum =:= QNum,
	KNum is (I4*1000 + I3*100 + P9*10 + P4),
	KNum =:= FNum + TNum*10,
	format('\n ~d~d~d * \n  ~d~d\n ---- \n ~d~d~d~d + \n ~d~d~d\n ----\n ~d~d~d~d',[I,P1,P,P3,P2,P6,I1,P5,P4,P8,I2,P7,I4,I3,P9,P4]),!.
	
assign_digits([], _List).
assign_digits([D|Ds],List) :-
        select(D,List,NewList),
        assign_digits(Ds, List).



