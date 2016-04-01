%% Vagones
%
% calcula las cantidad mínima de operaciones necesarias para que
% dado un estado inicial con un orden de los vagones de un tren, se obtenga 
% un estado final dado, obtenido de enganchar y desenganchar vagones según
% sea conveniente para alcanzar el objetivo. El resultado es mostrando en 
% pantalla como una lista de movimientos (enganches y desenganches).
%
% @autores:
%	- Dayana Rodrigues	10-10615
%	- Roberto Romero	10-106142

%% vagones(+In:list, +Out:list, ?Operations:list)
%
% calcula la lista de operaciones necesarias para pasar del estado inicial
% al estado final
%
% @param In estado incial de los vagones del tren
% @param Out estado final de los vagones del tren
% @param Operations lista de movimientos resultante

vagones(In,Out,Operations):- In == Out.
vagones(In,Out,Operations):- 
	Out = [FstOut|RestOut],
	moves(In,[FstOut|RestOut],[],Nstate,NewOp),
	bfs(FstOut, Out , RestOut, Nstate, NewOp, AuxOps),
	noReps(AuxOps,[],Operations),!.

%% moves(+In:list, +[Wagon|Final]:list, +Op:list ?Nstate, ?NewOp)
%
% calcula y ejecuta los movimientos adecuados.
%
% @param In Estado inicial
% @param [Wagon|Final] estado final
% @param Op lista de operaciones realizada hasta ahora
% @param Nstare nuevo estado generado de un movimiento
% @param NewOp nueva lista de operaciones realizadas

moves(In,[Wagon|Final],Op,Nstate,NewOp) :-
    push(Wagon, Arm1,Arm2, In, Op, PushOp),
    pop([Wagon| Final], Arm2, Arm1, [], PopOp,[], Nstate),
    append(PushOp, PopOp, NewOp), !.

%% bfs(+Old:atom,+Final:list,+[Wagon|Rest]:list, State:list, Op:list, Operations:list)
%
% recorre el espacio de soluciones
% 
% @param Old vagon auxiliar para calculos
% @param Final estado al que se quiere llegar
% @param [Wagon|Rest] estado auxiliar para calculos
% @param State estado actual del tren
% @param Op lista de movimientos realizados hasta ahora
% @param Operations lista final de movimientos 

bfs(_, State, _, State, Op, Op).
bfs(Old, Final, [Wagon|Rest], State, Op, Operations):-        
    split_wagons(Old, State, [], [A1, [A2|A2s]]),
    append(A1, [A2], NewEst), 
    moves(A2s,[Wagon|Rest],Op,Nstate,NewOp) , 
    append(NewEst, Nstate, Nstate2), 
    bfs(Wagon,Final, Rest, Nstate2,NewOp, Operations), !.
    
%% push(+Wagon:atom, +Arm1:list, +Arm2:list,+State:list, +Op:list, ?Operations:list)
%
% divide los vagones del tren segun como sea conveniente y los desengancha
%
% @param Wagon elemento que sirve de auxliar para la división de vagones
% @param Arm1 lista de vagones en el brazo superior de la Y
% @param Arm2 lista de vagones en el brazo inferioir de la Y
% @param State estado actual del tren
% @param Op lista de movimientos realizados hasta ahora
% @param Operationes lista final de movimientos realizados

push(Wagon, Arm1, Arm2, State, Op, Operations):-
    split_wagons(Wagon, State, [], [Arm1,Arm2]),
    length(Arm1,L1),
    length(Arm2,L2),    
    append(Op,[push(above,L2), push(below,L1)], Operations), !. 

%% pop(+[Wagon|Final]:list, +Arm1Y:list, +Arm2Y:list, +Op:list,
%	?Operations:list, +State:list, ?Nstate:list)
%
% realiza las operaciones de enganche de los vagones según sea conveniente
%
% @param [Wagon|Final] estado del tren al que se quiere llegar
% @param W1s lista de vagones en el brazo superior de la Y
% @param W2s lista de vagones en el brazo inferior de la Y
% @param Op lista de movimientos realizados hasta ahora
% @param Operations lista final de movimientos
% @param State estado actual del tren
% @param Nstate nuevo estado del tren

pop(_ , [], [], Op, Operations, State, Nstate):-
    	reverse(Op, Operations),
	reverse(State, Nstate),!.
pop([Wagon | Final], [], [W2 | W2s], Op, Operations, State, Nstate):-
    append([pop(below,1)],Op,NewOpList),
    pop(Final, [], W2s, NewOpList, Operations, [W2 | State], Nstate).
pop([Wagon | Final], [W1 | W1s], [], Op, Operations, State, Nstate):-
    append([pop(above,1)],Op,NewOpList),
    pop(Final, W1s, [], NewOpList, Operations, [W1 | State], Nstate).
pop([Wagon | Final], [Wagon | W1s], [W2 | W2s], Op, Operations, State, Nstate):-
    append([pop(above,1)],Op,NewOpList),
    pop(Final, W1s, [W2 | W2s], NewOpList, Operations,[Wagon| State], Nstate).
pop([Wagon | Final], [W1 | W1s], [Wagon | W2s], Op, Operations, State, Nstate):-
    append([pop(below,1)],Op,NewOpList),
    pop(Final, [W1 | W1s], W2s, NewOpList, Operations,[Wagon| State], Nstate).
pop([Wagon | Final], [W1 | W1s], [W2 | W2s], Op, Operations, State, Nstate):-
    member(Wagon, W2s),
    append([push(above,1), pop(below,1)],Op,NewOpList),
    pop([Wagon | Final],[W2, W1| W1s], W2s, NewOpList, Operations, State, Nstate).
pop([Wagon | Final], [W1 | W1s], [W2 | W2s], Op, Operations, State, Nstate):-
    member(Wagon, W1s),
    append([push(below,1), pop(above,1)],Op,NewOpList),
    pop([Wagon | Final], W1s, [W1, W2| W2s], NewOpList, Operations, State, Nstate).

%% split_wagons(+Wagon:atom, +Rest:list, +Accumulator:list, ?Resul:list)
%
% divide los vagones según como es mas conveniente para desenganchar y enganchar
%
% @param Wagon vagon que sirve de auxiliar para la division del tren
% @param Rest estado actual del tren
% @param Accumulator ista de vagones auxiliar para la division
% @param Result lista final con la division del tren

split_wagons(Wagon, [First|Rest], Accumulator, Result):-
    Wagon \= First,
    append(Accumulator,[First],NewAcc),
    split_wagons(Wagon, Rest, NewAcc, Result).
split_wagons(Wagon, Rest, Acc, [Acc,Rest]).

%% noReps(+[A,B|Rest]:list, +Cargo:list, ?Result:list)
%
% elimina los movimientos repetidos resultando en la suma d elos mismos
%
% @param [A,B|Rest] lista de movimientos realizados
% @param Cargo lista auxiliar de movimientos
% @param Result lista final de movimientos realizados

noReps([A,B|Rest],Cargo,Result) :-
	rep(A,B,Bond), 
	[A,B] \= Bond, 
	append(Bond,Rest,NList), 
	noReps(NList,[],AuxResult), 
	append(Ncargo,AuxResult,Result),!.
noReps([A,B|Rest],Cargo,Result) :-
	rep(A,B,Bond), [A,B] = Bond, 
	append(Cargo,[A],Ncargo), 
	append([B],Rest,NList), 
	noReps(NList,[],AuxResult), 
	append(Ncargo,AuxResult,Result),!. 
noReps([A],Cargo,Result) :- [A] = Result,!.

%% rep(+X:atom, +Y:atom, ?Z:list)
%
% realiza la contabilidad de los movimientos repetidos
%
% @param X movimiento de enganche o desenganche
% @param Y movimiento de enganche o desenganche
% @param Z lista con el movimiento resultante despues de contabiizar

rep(X,Y,Z):- 
	X = pop(below,A), 
	Y = pop(below,B), 
	C is A + B, Z = [pop(below,C)].
rep(X,Y,Z):- 
	X = pop(above,A), 
	Y = pop(above,B), 
	C is A + B, 
	Z = [pop(above,C)].
rep(X,Y,Z):- 
	X = push(below,A), 
	Y = push(below,B), 
	C is A + B, 
	Z = [push(below,C)].
rep(X,Y,Z):- 
	X = push(above,A), 
	Y = push(above,B), 
	C is A + B, 
	Z = [push(above,C)].
rep(X,Y,Z):- Z = [X,Y].
