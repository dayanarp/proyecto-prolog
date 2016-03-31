/*...
*/

vagones(In,[Wagon| Final],Operations):- In == [Wagon| Final].
vagones(In,[Wagon| Final],Operations):- 
    push(Wagon, Arm1, Arm2, In, [], PushOp),
    pop([Wagon|Final], Arm2, Arm1, [], PopOp, [], Nstate),
    append(PushOp, PopOp, NewOp),
    bfs(Wagon, [Wagon| Final] , Final, Nstate, NewOp, AuxOperations), 
    noReps(AuxOperations,[],Operations),!.

bfs(_, State, _, State, Op, Op).
bfs(Anterior, Final, [Wagon | Fs], State, Op, Operations):-        
    split_wagons(Anterior, State, [], [X, [Y | S]]),
    append(X, [Y], NewState),   
    push(Wagon, Arm1, Arm2, S, Op, PushOp),
    pop([Wagon | Fs], Arm2, Arm1, [], PopOp, [], Nstate),
    append(PushOp, PopOp, NewOp),
    append(NewState, Nstate, Nstate2), 
    bfs(Wagon,Final, Fs, Nstate2,NewOp, Operations), !.
    

/* Split lists */
split_wagons(Wagon, [First|Rest], Accumulator, Result):-
    Wagon \= First,
    append(Accumulator,[First],NewAcc),
    split_wagons(Wagon, Rest, NewAcc, Result).
split_wagons(Wagon, Rest, Acc, [Acc,Rest]).



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
     

noReps([A,B|Rest],Cargo,Result) :-
	rep(A,B,Bond), 
	[A,B] \= Bond, 
	append(Bond,Rest,NList), 
	noReps(NList,[],AuxResult), 
	append(Ncargo,AuxResult,Result),!.

noReps([A,B|Rest],Cargo,Result) :-
	rep(A,B,Bond), 
	[A,B] = Bond, 
	append(Cargo,[A],Ncargo), 
	append([B],Rest,NList), 
	noReps(NList,[],AuxResult), 
	append(Ncargo,AuxResult,Result),!. 

noReps([A],Cargo,Result) :- [A] = Result,!.

rep(X,Y,Z):- X = pop(below,A), Y = pop(below,B), C is A + B, Z = [pop(below,C)].
rep(X,Y,Z):- X = pop(above,A), Y = pop(above,B), C is A + B, Z = [pop(above,C)].
rep(X,Y,Z):- X = push(below,A), Y = push(below,B), C is A + B, Z = [push(below,C)].
rep(X,Y,Z):- X = push(above,A), Y = push(above,B), C is A + B, Z = [push(above,C)].
rep(X,Y,Z):- Z = [X,Y].


/*noReps([pop(below,1),pop(below,2),pop(below,3)],[],Result).*/
