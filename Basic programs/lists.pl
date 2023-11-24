memberOf(X, [X|T]).
memberOf(X, [H|T]):-
         memberOf(X, T).

concatenationLists(L1, L2, L3).
concatenationLists([], L, L).
concatenationLists([X|L1],L2,[X|L3]):-
    concatenationLists(L1, L2, L3).

listSize([],0).
% Head is always a single element
% Tail is a set of elements
% e.g.
% {1,2,3,4,5,6} H:1 T:2,3,4,5,6
% {2,3,4,5,6} H:2 T:3,4,5,6

listSize([H|T],S):-
    listSize(T,S1),
    S is S1 + 1.

compress([],[]).
compress([X],[X]).
compress([X,X|Xs],S):-
    compress([X|Xs],S).
compress([X,Y|Ys],[X|S]):-
    X \= Y,
    compress([Y|Ys],S).