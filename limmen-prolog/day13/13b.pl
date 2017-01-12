%% AdventOfCode day 13 part b 13b.pl
%% swi-prolog
%% compile: ['13b.pl']
%%
%% start.
%% or
%% search(+,-).
%% search(N, Result)
%%
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Facts
%%%===================================================================

:- use_module(library(apply)).
:- use_module(library(lists)).

:- dynamic(visited/1).

one(1).

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Solves the puzzle with the favorite number 1358
start:-
    search(1358, Len),
    end,
    pretty_print(Len).

%% cleanup predicate
end:-
    retractall(visited(_)).

%% searches the set of reachable coordinates and calculates the distinct number of them
%% search(+,-).
%% search(N, Len).
search(N, Len):-
    findall(_, do_search((1,1), N, 0, []), _),
    findall(X, visited(X), All),
    length(All, Len),
    end.

%% DFS through the searchspace
%% do_search(+,+,-,+).
%% do_search(CurrentPos, N, Index, Visited).
do_search(Pos, _, I, Visited):-
    (I > 50; memberchk(Pos, Visited)),
    fail.

do_search(Pos, N, I, Visited):-
    visit(Pos),
    I < 50,
    \+ memberchk(Pos, Visited),
    move(_, N, Pos, Pos1),
    I1 is I + 1,
    do_search(Pos1, N, I1, [Pos|Visited]).

%% Visits a position, if already visited does nothing
%% visit(+).
%% visit(Pos).
visit(Pos):-
    visited(Pos).

visit(Pos):-
    \+ visited(Pos),
    assertz(visited(Pos)).

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
pretty_print(N):-
    format("Number of reachable coords are: ~p ~n", [N]).