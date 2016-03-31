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
	moves(In,[FstOut|RestOut],Nstate,NewOp),
    bfs(FstOut, Out , RestOut, Nstate, NewOp, AuxOps), 
    noReps(AuxOps,[],Operations),!.

moves(In,[Wagon|Final],Nstate,NewOp) :-
	push(Wagon, Arm1,Arm2, In, [], PushOp),
    pop([Wagon| Final], Arm2, Arm1, [], PopOp,[], Nstate),
    append(PushOp, PopOp, NewOp), !.

bfs(_, State, _, State, Op, Op).
bfs(Old, Final, [Wagon | Rest], State, Op, Operations):-        
    split_wagons(Old, State, [], [X, [Y | Arm]]),
    append(X, [Y], NewEst), 
    moves(Arm,[Wagon|Final],Nstate,NewOp) , 
    append(NewEst, Nstate, Nstate2), 
    bfs(Wagon,Final, Rest, Nstate2,NewOp, Operations), !.
    
/* Push */
push(Wagon, Arm1, Arm2, State, Op, Operations):-
    split_wagons(Wagon, State, [], [Arm1,Arm2]),
    length(Arm1,L1),
    length(Arm2,L2),    
    append(Op,[push(above,L2), push(below,L1)], Operations), !. 


/* Pop */    
pop(_ , [], [], Op, Operations, State, Nstate):-
    	reverse(Operations,Op),
	reverse(Nstate,State),!.
    
pop([Wagon|Final], [Wagon| RestAbove], Below, Op, Operations, State, Nstate):-
    append([pop(above,1)],Op,NewOpList),
    pop(Final, RestAbove, Below, NewOpList, Operations, [Wagon|State], Nstate).

pop([Wagon|Final], Above, [Wagon|RestBelow], Op, Operations, State, Nstate):-  
    append([pop(below,1)],Op,NewOpList),
    pop(Final, Above, RestBelow, NewOpList, Operations, [Wagon|State], Nstate).

/* Split lists */
split_wagons(Wagon, [First|Rest], Accumulator, Result):-
    Wagon \= First,
    append(Accumulator,[First],NewAcc),
    split_wagons(Wagon, Rest, NewAcc, Result).
split_wagons(Wagon, Rest, Acc, [Acc,Rest]).

noReps([A,B|Rest],Cargo,Result) :-rep(A,B,Bond), [A,B] \= Bond, append(Bond,Rest,NList), noReps(NList,[],AuxResult), append(Ncargo,AuxResult,Result),!.

noReps([A,B|Rest],Cargo,Result) :-rep(A,B,Bond), [A,B] = Bond, append(Cargo,[A],Ncargo), append([B],Rest,NList), noReps(NList,[],AuxResult), append(Ncargo,AuxResult,Result),!. 

noReps([A],Cargo,Result) :- [A] = Result,!.

rep(X,Y,Z):- X = pop(below,A), Y = pop(below,B), C is A + B, Z = [pop(below,C)].
rep(X,Y,Z):- X = pop(above,A), Y = pop(above,B), C is A + B, Z = [pop(above,C)].
rep(X,Y,Z):- X = push(below,A), Y = push(below,B), C is A + B, Z = [push(below,C)].
rep(X,Y,Z):- X = push(above,A), Y = push(above,B), C is A + B, Z = [push(above,C)].
rep(X,Y,Z):- Z = [X,Y].


