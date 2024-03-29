/*Lance Lansing V00819401 - Yves Belliveau V00815315
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
    purify(AllLiterals, PureLiterals),
    eliminate_clauses(PureLiterals,Clauses,El_Clauses),
    set_vars(PureLiterals, Vars, El_Vars).


%%%%%%%%%%%% PURIFY + AUXILLARY %%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*Literals is set of all literals (input)
  Pure_Literals is the set of all literals that appear with only one
  polarity in Literals
  Because duplicates are eliminated, we only need to check for 
  variables that occur twice*/
purify([], []).
purify([Pol-Var|Literals], Pure_Literals):-
    %if var occurs more than once, it is not a pure literal
    var_occurs(Var, Literals), !,
    remove_literal(Pol-Var, Literals, Cleaned_Literals),
    purify(Cleaned_Literals, Pure_Literals).
purify([Pol-Var|Literals], [Pol-Var|Pure_Literals]):-
    %Var occurs once, so add the literal to Pure_Literals
    purify(Literals, Pure_Literals).

/*Checks for given variable in a given list*/
var_occurs(_,[]):- false.
var_occurs(SearchVar, [_-CurrentVar|_]):-
    SearchVar == CurrentVar, !, true.
var_occurs(SearchVar, [_-CurrentVar|Literals]):-
    SearchVar \== CurrentVar, var_occurs(SearchVar, Literals).

/*Removes all literals with given variable from given list*/
remove_literal(_, [], []).
remove_literal(Pol1-Var1, [_-Var2|Literals], Cleaned_Literals):-
    %If literal has the target var, don't add to Cleaned
    Var1 == Var2, !, 
    remove_literal(Pol1-Var1, Literals, Cleaned_Literals).
remove_literal(Literal, [Pol2-Var2|Literals], [Pol2-Var2|Cleaned_Literals]):-
    %Literal doesn't have same variable: put it in Cleaned
    remove_literal(Literal, Literals, Cleaned_Literals).

%%%%%%%%%%%% ELIMINATE CLAUSES + AUXILLARY %%%%%%%%%%%%%%%%%%%%%%
/*Eliminate clauses that contain any of the pure literals*/
eliminate_clauses([], [], []).
eliminate_clauses(_, [], []).
eliminate_clauses([], El, El).
eliminate_clauses([CurrentPure|Pure_Literals], Clauses, El_Clauses):-
    /*If Pure literal list is empty, this is the final pure lit - we 
    will copy the filtered list to El_Clauses instead of recursing*/
    list_empty(Pure_Literals), !,
    remove_purelit(CurrentPure, Clauses, Rem_Clauses),
    copy_list(Rem_Clauses, El_Clauses), !.

eliminate_clauses([CurrentPure|Pure_Literals], Clauses, El_Clauses):-
    /*Pure_literal list isn't empty yet, so remove clauses with the 
      current pure literal and recurse on the remaining pure literals*/
    remove_purelit(CurrentPure, Clauses, Rem_Clauses),
    eliminate_clauses(Pure_Literals, Rem_Clauses, El_Clauses).

/*Copy items from one list to another*/
copy_list([], []).
copy_list([Item|List1], [Item|List2]):-
    copy_list(List1, List2).

/*Return true if list is empty, false otherwise*/
list_empty([]):-true.
list_empty([_|_]):-false.

/*Remove clauses that contain the given pure lit*/
remove_purelit(_, [], []).
remove_purelit(Pol-Var, [CurrentClause|Clauses], Rem_Clauses):-
    %If the pure literal is in the clause, don't add it to El_Clauses
    var_occurs(Var, CurrentClause), !,
    remove_purelit(Pol-Var, Clauses, Rem_Clauses).
remove_purelit(Literal, [Clause|Clauses], [Clause|Rem_Clauses]):-
    %Clause doesn't contain the pure lit; put it in Rem_Clauses
    remove_purelit(Literal, Clauses, Rem_Clauses).

%%%%%%%%%%%%%% SET_VARS + AUXILLARY %%%%%%%%%%%%%%%%%%%%%%

/*Go through each pure literal and replace the instance of its
  variable in the variable list with its polarity*/
set_vars([], Vars, Vars).
set_vars([Pol-Var|Pures], Vars, El_Vars):-
    %If it's the last pure literal, no recursion needed
    list_empty(Pures), !,
    replace_with_pol(Var, Pol, Vars, New_Vars),
    copy_list(New_Vars, El_Vars).

set_vars([Pol-Var|Pures], Vars, El_Vars):-
    %It is not the last pure literal - keep recursing
    replace_with_pol(Var, Pol, Vars, New_Vars),
    set_vars(Pures, New_Vars, El_Vars).

/*Replace all instances of the variable in the var list with polarity*/
replace_with_pol(_, _, [], []).
replace_with_pol(Var, Pol, [Head|Tail1], [Head|Tail2]):-
    Head \== Var, !, replace_with_pol(Var, Pol, Tail1, Tail2).
replace_with_pol(Var, Pol, [Var|Tail1], [Pol|Tail2]):-
    replace_with_pol(Var, Pol, Tail1, Tail2).