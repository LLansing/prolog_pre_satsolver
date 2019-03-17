# Project 2 - CSC322 - Mar 2019
## Yves Belliveau V00815315 - Lance Lansing V00819401

Task 1 

Performs preprocessing of a given conjunctive normal form (CNF) and list of variables for input into prolog SAT-solver.

1. Flattens CNF, removes duplicates, and identifies all pure literals (literals whose occurences in the CNF all have the same polarity).

2. Removes clauses from the CNF that contain any pure literal. This is filtered CNF is produced to El_Clauses.

3. Sets all variables in the variable list that are pure literals to their polarity.