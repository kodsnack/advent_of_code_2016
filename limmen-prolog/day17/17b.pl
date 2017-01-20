%% AdventOfCode day 17 part b 17b.pl
%% swi-prolog
%% compile: ['17b.pl']
%%
%% start.
%% or
%% find_longest_path(+,-).
%% find_longest_path(Code, LongestPath).
%%
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Facts
%%%===================================================================

:- use_module(library(md5)).
:- set_prolog_flag(double_quotes, codes).
:- dynamic(best_sol/1).

%% Keys that means that door is open
%% open(+).
%% open(Key).
open(98).
open(99).
open(100).
open(101).
open(102).

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    find_longest_path("ihgpwlah", 370),
    retract,
    find_longest_path("kglvqrro", 492),
    retract,
    find_longest_path("ulqzkmiv", 830),
    retract.

%% Solves the puzzle with "pgflpeqp" as input
start:-
    find_longest_path("pgflpeqp", Length),
    retract,
    pretty_print(Length).

%% Retracts current solution
retract:-
    retractall(best_sol(_)).

%% Finds the longest possible path given a passcsode
%% find_longest_path(+,-).
%% find_longest_path(PassCode, Max).
find_longest_path(PassCode, Max):-
    assertz(best_sol(0)),
    findall(P, find_path(PassCode, [], (1,1), P), All),
    max_list(All, Max).

%% Finds length of path that is longer then the current best path given a passcode, current path and starting position
%% find_path(+,+,+,-).
%% find_path(PassCode, Path, Pos, Length)
find_path(_, Path, (4,4), L):-
    length(Path, L),
    best_sol(Best),
    L > Best,
    retract,
    assertz(best_sol(L)).

find_path(PassCode, Path, Pos, Res):-
    \+ Pos = (4,4),
    append(PassCode, Path, PassCode1),
    md5_hash(PassCode1, Hash, []),
    atom_codes(Hash, [U,D,L,R|_]),
    move(Path, [U,D,L,R], Pos, NewPos, NewPath),
    find_path(PassCode, NewPath, NewPos, Res).

%% Makes a move up,down,left,right
%% move(+,+,+,-,-).
%% move(Path, Key, Pos, NewPos, NewPath).
move(Path, [_,D,_,_], Pos, NewPos, NewPath):-
    append(Path, "D", NewPath),
    move_down(D, Pos, NewPos).

move(Path, [_,_,L,_], Pos, NewPos, NewPath):-
    append(Path, "L", NewPath),
    move_left(L, Pos, NewPos).

move(Path, [_,_,_,R], Pos, NewPos, NewPath):-
    append(Path, "R", NewPath),
    move_right(R, Pos, NewPos).

move(Path, [U,_,_,_], Pos, NewPos, NewPath):-
    append(Path, "U", NewPath),
    move_up(U, Pos, NewPos).

%% Moves up one step given that the door is open
%% move_up(+,+,-).
%% move_up(Door, CurrentPos, NewPos).
move_up(Door, (X,Y), (X, Y1)):-
    Y > 1,
    open(Door),
    Y1 is Y - 1.

%% Moves right one step given that the door is open
%% move_right(+,+,-).
%% move_right(Door, CurrentPos, NewPos).
move_right(Door, (X,Y), (X1, Y)):-
    X < 4,
    open(Door),
    X1 is X + 1.

%% Moves left one step given that the door is open
%% move_left(+,+,-).
%% move_left(Door, CurrentPos, NewPos).
move_left(Door, (X,Y), (X1, Y)):-
    X > 1,
    open(Door),
    X1 is X - 1.

%% Moves down one step given that the door is open
%% move_down(+,+,-).
%% move_down(Door, CurrentPos, NewPos).
move_down(Door, (X,Y), (X, Y1)):-
    Y < 4,
    open(Door),
    Y1 is Y + 1.

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(Length):-
    format("The longest path is of length: ~p ~n", [Length]).