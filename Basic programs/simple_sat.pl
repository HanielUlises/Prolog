% Helper function to remove an element from a list
remove_element(_, [], []).
remove_element(X, [X|T], T).
remove_element(X, [H|T], [H|Result]) :- remove_element(X, T, Result).

% SAT solver implementation using DPLL algorithm
solve_sat(Clauses, Variables) :-
    dpll(Clauses, Variables).

% DPLL algorithm
dpll([], _).
dpll(Clauses, Variables) :-
    member([], Clauses), !, fail.
dpll(Clauses, _) :-
    member([Literal], Clauses),
    assign_literal(Literal).
dpll(Clauses, Variables) :-
    select_literal(Clauses, Literal),
    dpll(unit_propagate(Clauses, Literal), Variables),
    assign_literal(Literal).
dpll(Clauses, Variables) :-
    select_literal(Clauses, Literal),
    dpll(unit_propagate(Clauses, neg(Literal)), Variables),
    assign_literal(neg(Literal)).

% Select a literal from the clauses
select_literal(Clauses, Literal) :-
    member(Clause, Clauses),
    member(Literal, Clause).

% Unit propagation
unit_propagate(Clauses, Literal) :-
    findall(NewClause, (member(Clause, Clauses), \+ member(Literal, Clause), remove_element(neg(Literal), Clause, NewClause)), NewClauses),
    append(NewClauses, Clauses, Result),
    remove_element([], Result, UpdatedClauses),
    !.

% Assign a literal (either true or false) to the Variables list
assign_literal(Literal) :-
    Variables = [],
    (member(Literal, Variables); member(neg(Literal), Variables)),
    !.