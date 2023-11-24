% Checks if an element is part of a set (list)
memberOf(X, [X|T]).
memberOf(X, [H|T]):-
         memberOf(X, T).

concatenationLists(L1, L2, L3).
concatenationLists([], L, L).
concatenationLists([X|L1],L2,[X|L3]):-
    concatenationLists(L1, L2, L3).

% Returns a list's size
listSize([],0).
listSize([H|T],S):-
    listSize(T,S1),
    S is S1 + 1.

% Deletes ocurrences
compress([],[]).
compress([X],[X]).
compress([X,X|Xs],S):-
    compress([X|Xs],S).
compress([X,Y|Ys],[X|S]):-
    X \= Y,
    compress([Y|Ys],S).

% Series of a factorial (returns a list with the series)
factorialSeries(0,[1]).
factorialSeries(X,L):-
    X>0,
    X1 is X-1,
    factorialSeries(X1,[H|T]),
    FactorialX is X*H,
    L = [FactorialX|[H|T]].