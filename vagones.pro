/*...
*/

vagones(Entrada,[Elem| Final],Operaciones):- Entrada == [Elem| Final].
vagones(Entrada,[Elem| Final],Operaciones):- 
    push(Elem, Entrada, [], S1, S2, PushOp),
    pop([Elem| Final], S2, S1, [], [], PopOp, NuevoEstado),
    append(PushOp, PopOp, NewOp),
    bfs(Elem, [Elem| Final] , Final, NuevoEstado, NewOp, AuxOperaciones), 
    noReps(AuxOperaciones,[],Operaciones),!.


bfs(_, Estado, _, Estado, Op, Op).
bfs(Anterior, Final, [Elem | Fs], Estado, Op, Operaciones):-        
    split(Anterior, Estado, [], [X, [Y | S]]),
    append(X, [Y], NewEst),   
    push(Elem, S, Op, S1, S2, PushOp),
    pop([Elem | Fs], S2, S1, [], [], PopOp, NuevoEstado),
    append(PushOp, PopOp, NewOp),
    append(NewEst, NuevoEstado, NuevoEstado2), 
    bfs(Elem,Final, Fs, NuevoEstado2,NewOp, Operaciones), !.
    

/* Split lists */
split(Elem, [X | List], Z, Result):-
    Elem \= X,
    split(Elem, List, [X | Z], Result).
split(_, List, Acc, Result):-
    reverse(Acc,X),
    Result = [X,List].


/* Push */
push(Elem, Estado, Op, S1,S2, Operaciones):-
    split(Elem, Estado, [], [S1,S2]),
    length(S1,NS1),
    length(S2,NS2),    
    append(Op,[push(above,NS2), push(below,NS1)], Operaciones), !.


/* Pop */    
pop(_ , [], [], Op, Estado, Operaciones, NuevoEstado):-
    reverse(Estado,NuevoEstado),
    reverse(Op, Operaciones), !.
    
pop([Elem | Final], [], [FstBelow | RestBelow], Op, Estado, Operaciones, NuevoEstado):-
    pop(Final, [], RestBelow, [pop(below,1)|Op], [FstBelow | Estado], Operaciones, NuevoEstado).
    
pop([Elem | Final], [FstAbove | RestAbove], [], Op, Estado, Operaciones, NuevoEstado):-
    pop(Final, RestAbove, [], [pop(above,1)|Op], [FstAbove | Estado], Operaciones, NuevoEstado).
    
pop([Elem | Final], [FstAbove | RestAbove], [FstBelow | RestBelow], Op, Estado, Operaciones, NuevoEstado):-
    X = FstAbove, Elem == X,
    pop(Final, RestAbove, [FstBelow | RestBelow], [pop(above,1)|Op], [X | Estado], Operaciones, NuevoEstado).

pop([Elem | Final], [FstAbove | RestAbove], [FstBelow | RestBelow], Op, Estado, Operaciones, NuevoEstado):-  
    X = FstBelow, Elem == X,
    pop(Final, [FstAbove | RestAbove], RestBelow, [pop(below,1)|Op], [X | Estado], Operaciones, NuevoEstado).
    
  

noReps([A,B|Rest],Cargo,Result) :-rep(A,B,Bond), [A,B] \= Bond, append(Bond,Rest,NList), noReps(NList,[],AuxResult), append(Ncargo,AuxResult,Result),!.

noReps([A,B|Rest],Cargo,Result) :-rep(A,B,Bond), [A,B] = Bond, append(Cargo,[A],Ncargo), append([B],Rest,NList), noReps(NList,[],AuxResult), append(Ncargo,AuxResult,Result),!. 

noReps([A],Cargo,Result) :- [A] = Result,!.

rep(X,Y,Z):- X = pop(below,A), Y = pop(below,B), C is A + B, Z = [pop(below,C)].
rep(X,Y,Z):- X = pop(above,A), Y = pop(above,B), C is A + B, Z = [pop(above,C)].
rep(X,Y,Z):- X = push(below,A), Y = push(below,B), C is A + B, Z = [push(below,C)].
rep(X,Y,Z):- X = push(above,A), Y = push(above,B), C is A + B, Z = [push(above,C)].
rep(X,Y,Z):- Z = [X,Y].

