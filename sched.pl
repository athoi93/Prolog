/*		Part 1 Start 		*/

/* Numbers of all courses */
c_numbers(N) :-
	course(N,_,_).

/* Numbers of all programming languages courses */
c_pl(N) :-
	course(N,programming_languages,_).

/* Numbers of all non-programming languages courses */
c_notpl(N) :-
	course(N,PL,_),
	PL \== programming_languages.

/* List of those teaching 60 */
c_inst60(L) :-
	course(60,_,L).

/* Sorted list of those teaching 60 */
c_inst60_sorted(L) :-
	course(60,_,L1),
	sort(L1,L).

/* List of those teaching 20 */
c_inst20(L) :-
	course(20,_,L).

/* Sorted list of those teaching 20 */
c_inst20_sorted(L) :-
	course(20,_,L1),
	sort(L1,L).

/* Sorted list of those teaching N */
c_inst_sorted(N,L) :-
	course(N,_,L1),
	sort(L1,L).

/* Numbers of courses with exactly one instructor */
c_single_inst(N) :-
	course(N,_,L),
	length(L,1).

/* Numbers of courses with more than one instructor */
c_multi_inst(N) :-
	course(N,_,L),
	length(L,N1),
	N1 > 1.

/* Numbers of courses for which I is the only instructor */
c_exclusive(I,N) :-
	course(N,_,L),
	length(L,1),
	member(I,L).

/* Numbers of courses with exactly 1 or 2 instructors */
c_12_inst_1or(N) :-
	(
	course(N,_,L),
	length(L,1)
	;
	course(N,_,L),
	length(L,2)
	).

c_12_inst_2wo(N) :-
	course(N,_,L),
	length(L,N1),
	N1 >= 1,
	N1 =< 2.

/*		Part 1 End 		*/

/*		Part 2 Start		*/

/* delete_question */
delete_question("gprolog's delete behavior follows the behavior on pg 157").

/* Append L1,L2, then sort the appended list */
sortappend(L1,L2,Z) :-
	append(L1,L2,Z1),
	sort(Z1,Z).

/* 		Part 2 End		*/

/*		Part 3 Start		*/

/* distribute(W,X,Y) -> returns list Y of pairs in the form of (W,X) */
distribute(_W,[],[]).	%Handles cases where X is []
distribute(W,[X],Y) :-  
	Y = [[W,X]].
distribute(W,[F|R],Y) :- %R = remaining elements of list, F = 1st elt
	A = [[W,F]],
	distribute(W,R,Y1),		%Recursive call
	(Y1 \== [] -> append(A,Y1,Y)).

/* 		Part 3 End		*/

/*		Part 4 Start		*/

/* 	myfor(L,U,Result) taken from assignment sheet	*/
myfor(L,U,Result) :-
	L =< U,
	L1 is L+1,
	myfor(L1,U,Res1),
	Result = [L | Res1].
myfor(L,U,[]) :-
	L > U.

/* crossmyfor(R,H,Z) */
crossmyfor(R,H,Z) :-
	(
	R == 0 -> distribute(0,[],Z)
	);
	(
	H == 0 -> distribute(0,[],Z)
	);
	(
	myfor(1,R,LL),	%LL = list for lower bound
	myfor(1,H,UL),  %UL = list for upper bound
	mycross(LL,UL,Z)
	).
%	findall([X,Y],(member(X,LL),member(Y,UL)),Z)
%	^^^^^^^   how to "cheat" this part gg wp ^^^^^^^

mycross([LH|LT],UL,Z) :-
	distribute(LH,UL,Z1),
	(LT \== [] -> mycross(LT,UL,Z2), append(Z1,Z2,Z) ; Z = Z1).

	
/*		Part 4 End		*/

/*		Part 5 Start		*/

/*  5a: getallmeetings(C,Z)  */
getallmeetings([],[]).
getallmeetings(C,Z) :-
	select([_|[M]],C,E),
	getallmeetings(E,Z2),
	!,	%prevent backtracking
	append(M,Z2,Z1),
	sort(Z1,Z).

/*  5b: participants(C,Z)  */
/*participants([],[]).*/
participants(C,Z) :-
	getallmeetings(C,Z1),
	checkmeetings(C,Z1,Z).
checkmeetings(_,[],[]).
checkmeetings(C,ML,L) :-	%Recursively moves through meeting list
	select(H,ML,R),
	!,
	list_p(C,H,L1),
	L2 = [[H|[L1]]],
	checkmeetings(C,R,L3),
	append(L2,L3,L).
	
list_p([],_,[]).
list_p(C,M,L) :-	%Recursively checks people
	select([P|[M1]],C,E),
	!,
	(member(M,M1) -> L1 = [P] ; L1 = []),
	list_p(E,M,L2),
	append(L1,L2,L3),
	sort(L3,L).
	
/*  5c: osched(MR,MH,C,Z)  */	
%RH = crossproduct of rooms and hours
%Z1 = list of participants for each meeting
osched(_,_,[],[]).
osched(MR,MH,C,Z) :-
	participants(C,Z1),
	length(Z1,N),
	TOTAL is MR * MH,
	N =< TOTAL,
	crossmyfor(MR,MH,RH),
	makesched(RH,Z1,Z).


makesched(RH,[H|T],Z) :-
	select(S,RH,R),
	Z1 = [S|[H]],
	(T \== [] -> makesched(R,T,Z2), sort([Z1|Z2],Z) ; Z = [Z1]). 

/*  5d: xsched(MR,MH,C,Z)  
xsched(_,_,[],[]).
xsched(MR,MH,C,Z) :-
	osched(MR,MH,C,Z1),
	mycheck(Z1,Z).

mycheck(L,Z) :-
	[[[NH|[NT]]|[[H|[T]]]]] = L.	
	
*/
	
	
	


/*		Part 5 End		*/
