/*
 	IPP  *
	 PP
	----
	PIPP +
	PIP
	----
	IIPP

	Donde P representa algún dígito par e I representa algún dígito impar.
	
	pei/0 triunfa presentando en pantalla la solución al problema.

	Para generar la solución:
		1.- Se generan posibles soluciones para los multiplicadores, de
				manera que cumplan los siguientes requisitos:
				Haciendo:	
									I0P0P1   *
									  P2P3
									--------
									P6I3P7P5 +
									P8I4P9
									--------
									I1I2P4P5
			
				Entonces debe cumplirse que:
					- P3*I0 + el acarreo de P3*P2 (que es a lo sumo 6) debe ser al menos
						21, por tanto I0 debe ser mayor que 1.
					- P2*I0 es cuando mucho el digíto par más grande, es decir, 8.
					- Para el cumplimiento de los items anteriores se tiene entonces
						que I0 = 3 y P2 = 2.
					- Los Acarreos de P0*P3 y P2*P1 deben ser al menos 1.
					- P6 y P8 deben ser al menos 2, por lo que I1 debe ser al menos 5.
					- Como P3*I0 + A >= 21 e I0 = 3, P3 debe ser al menos 6, por lo que
						P3*I0 dene ser al menos 18. 
					- El Acarreo de P7+P9 debe ser al menos 1, por lo que P7+P9 en al
						menos 10.
					- P6 + P8 es a lo sumo el dígito par más grande, es decir 8.
					- Como P6 y P8 son al menos 2, su suma es al menos 4.
					- El acarreo de I3+I4 debe ser al menos 1, por lo que I3+I4 es
						al menos 10.

		2.- Se verifican las soluciones aprovechando el backtracking del lenguaje.
		3.- Se muestra en pantalla la solución.
*/ 

pei :- 
	Even = [0,2,4,6,8],
	Odd = [1,3,5,7,9],
	X1 = [P0,P1,P2,P3,P4,P5],
	Y1 = [I0,I1,I2],
	assign(X1,Even),
	P2 is 2,
	P0*P3 >= 12,
	P2*P1 >= 12,
	assign(Y1, Odd),
	I0 is 3,
	I1 >= 5, 
	P3*I0 >= 18,
	IPP is I0*100 + P0*10 + P1,
	PP is P2*10 + P3,
	IIPP is IPP * PP,
	IIPP is I1*1000 + I2*100 + P4*10 + P5,
	X2 = [P7,P8,P9,P6],
	Y2 = [I3,I4],
	assign(X2, Even),
	P7 + P9 >= 10,
	P6 + P8 =< 8,
	P6 + P8 >= 4,
	assign(Y2, Odd),
	I3 + I4 >= 10,
	PIPP is P6*1000 + I3*100 + P7*10 + P5,
	PIPP is P3*IPP,
	PIP is P8*100 + I4*10 + P9,
	PIP is P2*IPP,
	format('\n  ~d *\n   ~d\n ----\n ~d +\n ~d\n ----\n ~d',[IPP, PP, PIPP,PIP,IIPP]),!.


assign([],L).
assign([X|XS],L) :- member(X,L), assign(XS, L).
