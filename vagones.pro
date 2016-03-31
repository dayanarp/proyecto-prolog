/*...
*/

vagones(In,Out,Operations):- In == Out.
vagones(In,Out,Operations):- 
	Out = [FstOut|RestOut],
	moves(In,[FstOut|RestOut],Nstate,NewOp),
    bfs(FstOut, Out , RestOut, Nstate, NewOp, AuxOps), 
    noReps(AuxOps,[],Operations),!.


bfs(_, State, _, State, Op, Op).
bfs(Anterior, Final, [Wagon | Rest], State, Op, Operations):-        
    split(Anterior, State, [], [X, [Y | Arm]]),
    append(X, [Y], NewEst), 
    moves(Arm,[Wagon|Final],Nstate,NewOp) , 
    append(NewEst, Nstate, Nstate2), 
    bfs(Wagon,Final, Rest, Nstate2,NewOp, Operations), !.
    
moves(In,[Wagon|Final],Nstate,NewOp) :-
	push(Wagon, In, [], Arm1, Arm2, PushOp),
    pop([Wagon| Final], Arm2, Arm1, [], [], PopOp, Nstate),
    append(PushOp, PopOp, NewOp), !.

/* Split lists */
split(Wagon, [X | List], Z, Result):-
    Wagon \= X,
    split(Wagon, List, [X | Z], Result).
split(_, List, Acc, Result):-
    reverse(Acc,X),
    Result = [X,List].


/* Push */
push(Wagon, State, Op, Arm1,Arm2, Operations):-
    split(Wagon, State, [], [Arm1,Arm2]),
    length(Arm1,NArm1),
    length(Arm2,NArm2),    
    append(Op,[push(above,NArm2), push(below,NArm1)], Operations), !.


/* Pop */    
pop(_ , [], [], Op, State, Operations, Nstate):-
    reverse(State,Nstate),
    reverse(Op, Operations), !.
    
pop([Wagon | Final], [], [FstBelow | RestBelow], Op, State, Operations, Nstate):-
    pop(Final, [], RestBelow, [pop(below,1)|Op], [FstBelow | State], Operations, Nstate).
    
pop([Wagon | Final], [FstAbove | RestAbove], [], Op, State, Operations, Nstate):-
    pop(Final, RestAbove, [], [pop(above,1)|Op], [FstAbove | State], Operations, Nstate).
    
pop([Wagon | Final], [FstAbove | RestAbove], [FstBelow | RestBelow], Op, State, Operations, Nstate):-
    X = FstAbove, Wagon == X,
    pop(Final, RestAbove, [FstBelow | RestBelow], [pop(above,1)|Op], [X | State], Operations, Nstate).

pop([Wagon | Final], [FstAbove | RestAbove], [FstBelow | RestBelow], Op, State, Operations, Nstate):-  
    X = FstBelow, Wagon == X,
    pop(Final, [FstAbove | RestAbove], RestBelow, [pop(below,1)|Op], [X | State], Operations, Nstate).
    
  

noReps([A,B|Rest],Cargo,Result) :-rep(A,B,Bond), [A,B] \= Bond, append(Bond,Rest,NList), noReps(NList,[],AuxResult), append(Ncargo,AuxResult,Result),!.

noReps([A,B|Rest],Cargo,Result) :-rep(A,B,Bond), [A,B] = Bond, append(Cargo,[A],Ncargo), append([B],Rest,NList), noReps(NList,[],AuxResult), append(Ncargo,AuxResult,Result),!. 

noReps([A],Cargo,Result) :- [A] = Result,!.

rep(X,Y,Z):- X = pop(below,A), Y = pop(below,B), C is A + B, Z = [pop(below,C)].
rep(X,Y,Z):- X = pop(above,A), Y = pop(above,B), C is A + B, Z = [pop(above,C)].
rep(X,Y,Z):- X = push(below,A), Y = push(below,B), C is A + B, Z = [push(below,C)].
rep(X,Y,Z):- X = push(above,A), Y = push(above,B), C is A + B, Z = [push(above,C)].
rep(X,Y,Z):- Z = [X,Y].


