%% AdventOfCode day 13 part a 13a.pl
%% swi-prolog
%% compile: ['13a.pl']
%%
%% start.
%% or
%% solve_all(+,+,-).
%% solve_all(Goal, N, Min)
%%
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Facts
%%%===================================================================

:- use_module(library(apply)).
:- use_module(library(lists)).

one(1).

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    search((7,4), 10, 11).

%% Solves the puzzle with the favorite number 1358
start:-
    search((31,39), 1358, Min),
    pretty_print(Min).

%% searches for the shortest path to goal coordinate
%% search(+,+,-).
%% search(Goal, N, Min).
search(Goal, N, Min):-
    findall(I, do_search((1,1), N, [], 0, I, Goal), All),
    min_list(All, Min).

%% DFS through the searchspace
%% do_search(+,+,+,+,-,+).
%% do_search(Pos, N, Visited, I0, Length, Goal).
do_search(Goal, _, _, I, I, Goal).

do_search(Pos, _, Visited, I0, _, _):-
    ((I0 > 100 ; memberchk(Pos, Visited)) ->
     fail).

do_search(Pos, N, Visited, I0, I, Goal):-
    I0 < 100,
    \+ memberchk(Pos, Visited),
    \+ Pos = Goal,
    move(_, N, Pos, Pos1),
    I1 is I0 + 1,
    do_search(Pos1, N, [Pos|Visited], I1, I, Goal).

%% Makes a move
%% move(+,+,+,-).
%% move(Dir, N, Pos, NewPos).
move(down, N, (X,Y), (X,Y1)):-
    Y1 is Y + 1,
    \+ wall((X,Y1), N).

move(left, N, (X,Y), (X1,Y)):-
    X1 is X - 1,
    X1 >= 0,
    \+ wall((X1,Y), N).

move(right, N, (X,Y), (X1,Y)):-
    X1 is X + 1,
    \+ wall((X1,Y), N).

move(up, N, (X,Y), (X,Y1)):-
    Y1 is Y - 1,
    Y1 >= 0,
    \+ wall((X,Y1), N).

%% Checks if position is a wall
%% wall(+,+).
%% wall(Pos, N).
wall((X,Y), N):-
    V is X*X + 3*X + 2*X*Y + Y + Y*Y + N,
    dec2bin(V, Bin),
    include(one, Bin, Bin1),
    length(Bin1, Len),
    1 is mod(Len, 2).

%% Converts  decimal number to binary
%% dec2bin(+,-).
%% dec2bin(Dec, Bin).
dec2bin(0,[0]).
dec2bin(1,[1]).
dec2bin(N,L):- 
    N > 1,
    X is N mod 2,
    Y is N // 2,  
    dec2bin(Y,L1),
    L = [X|L1].

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(MinSteps):-
    format("The minimum number of steps necessary is ~p ~n", [MinSteps]).