%% AdventOfCode day 17 part a 17a.pl
%% swi-prolog
%% compile: ['17a.pl']
%%
%% start.
%% or
%% find_shortest_path(+,-).
%% find_shortest_path(Code, ShortestPath).
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
    \+ find_shortest_path("hijkl", _),
    retract,
    find_shortest_path("ihgpwlah", "DDRRRD"),
    retract,
    find_shortest_path("kglvqrro", "DDUDRLRRUDRD"),
    retract,
    find_shortest_path("ulqzkmiv", "DRURDRUDDLLDLUURRDULRLDUUDDDRR"),
    retract.
    
%% Solves the puzzle with "pgflpeqp" as input
start:-
    find_shortest_path("pgflpeqp", Path),
    retract,
    pretty_print(Path).

%% Retracts current solution
retract:-
    retractall(best_sol(_)).

%% Finds the shortest possible path given a passcsode
%% find_shortest_path(+,-).
%% find_shortest_path(PassCode, MinPath).
find_shortest_path(PassCode, Path):-
    assertz(best_sol(inf)),
    findall(P, find_path(PassCode, [], (1,1), P), All),
    min_member((_, Path), All).

%% Finds a path that is shorter then the current best path given a passcode, current path and starting position
%% find_path(+,+,+,-).
%% find_path(PassCode, Path, Pos, (Length, Path))
find_path(_, Path, (4,4), (L, Path)):-
    length(Path, L),
    best_sol(Best),
    L < Best,
    retractall(best_sol(_)),
    assertz(best_sol(L)).

find_path(PassCode, Path, Pos, Res):-
    append(PassCode, Path, PassCode1),
    md5_hash(PassCode1, Hash, []),
    atom_codes(Hash, [U,D,L,R|_]),
    move(Path, [U,D,L,R], Pos, NewPos, NewPath),
    find_path(PassCode, NewPath, NewPos, Res).

%% Makes a move up,down,left,right
%% move(+,+,+,-,-).
%% move(Path, Key, Pos, NewPos, NewPath).
move(Path, [_,D,_,_], Pos, NewPos, NewPath):-
    keep_going(Path),
    append(Path, "D", NewPath),
    move_down(D, Pos, NewPos).

move(Path, [_,_,L,_], Pos, NewPos, NewPath):-
    keep_going(Path),
    append(Path, "L", NewPath),
    move_left(L, Pos, NewPos).

move(Path, [_,_,_,R], Pos, NewPos, NewPath):-
    keep_going(Path),
    append(Path, "R", NewPath),
    move_right(R, Pos, NewPos).

move(Path, [U,_,_,_], Pos, NewPos, NewPath):-
    keep_going(Path),
    append(Path, "U", NewPath),
    move_up(U, Pos, NewPos).

%% Checks wether is is worth keep going or if path is too long already
%% keep_going(+).
%% keep_going(Path).
keep_going(Path):-
    best_sol(Best),
    length(Path, L),
    L < Best.

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
pretty_print(Path):-
    format("The shortest path is: ~s ~n", [Path]).