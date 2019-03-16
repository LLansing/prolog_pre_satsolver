/*Lance Lansing V00819401 - Yves Belliveau V00
  CSC 322 - Project 2: PLE Preprocessing for SAT-Solver*/

/*Clauses is the input CNF structured as a list of [polarity - var]
  pairs
  Vars is the list of variables appearing in Clauses
  El_Clauses should be the CNF after pure literal elimination
  El_Vars should be the list of variables with pure literals set to
  their polarity*/
pure_literal_eliminate(Clauses, Vars, El_Clauses, El_Vars) :-
    flatten(Clauses, FlattenedClauses), 
    list_to_set(FlattenedClauses, AllLiterals),
    purify(AllLiterals, PureLiterals).
    eliminate_clauses(PureLiterals,Clauses,El_Clauses).
    set_vars(PureLiterals, Vars, El_Vars).


/*Literals is set of all literals (input)
  Pure_Literals is the set of all literals that appear with only one
  polarity in Literals
  Because duplicates are eliminated, we only need to check for 
  variables that occur twice*/
purify([],[]).
purify([Pol-Var|Literals], Pure_Literals):-
    %if var occurs more than once, it is not a pure literal
    occurs(Var, Literals), !,
    remove_literal(Pol-Var, Literals, Cleaned_Literals),
    purify(Cleaned_Literals, Pure_Literals).
purify([Pol-Var|Literals], [Pol-Var|Pure_Literals]):-
    %Var occurs once, so add the literal to Pure_Literals
    purify(Literals, Pure_Literals).

/*Checks for given variable in a given list*/
occurs(_,[]):- false.
occurs(SearchVar, [_-CurrentVar|_]):-
    SearchVar == CurrentVar, !, true.
occurs(SearchVar, [_-CurrentVar|Literals]):-
    SearchVar \== CurrentVar, occurs(SearchVar, Literals).

/*Removes all literals with given variable from given list*/
remove_literal(_,[],[]).
remove_literal(Pol1-Var1, [_-Var2|Literals], Cleaned_Literals):-
    %If literal has the target var, don't add to Cleaned
    Var1 == Var2, !, 
    remove_literal(Pol1-Var1, Literals, Cleaned_Literals).
remove_literal(Pol1-Var1, [Pol2-Var2|Literals], [Pol2-Var2|Cleaned_Literals]):-
    %Literal doesn't have same variable: put it in Cleaned
    remove_literal(Pol1-Var1, Literals, Cleaned_Literals).