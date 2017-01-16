%% AdventOfCode day 15 part a and b 15ab.pl
%% swi-prolog
%% compile: ['15ab.pl']
%%
%% start.
%% or
%% can_get_capsule(+,-).
%% can_get_capsule(Discs, Time).
%%
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Facts
%%%===================================================================

:- use_module(library(pio)).
:- use_module(library(dcg/basics)).
:- use_module(library(lists)).
:- set_prolog_flag(double_quotes, codes).

%%%===================================================================
%%% Definite Clause Grammars for parsing input file
%%%===================================================================

discs([]) --> eos, !.
discs([]) --> "\n\n", !.
discs([X|Xs]) --> disc(X), "\n", discs(Xs).

disc(disc(Id, NoPos, CurrentPos)) --> "Disc #", integer(Id), " has ",  integer(NoPos), " positions; at time=0, it is at position ", integer(CurrentPos), ".".

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    phrase(discs(Discs), "Disc #1 has 5 positions; at time=0, it is at position 4.\nDisc #2 has 2 positions; at time=0, it is at position 1.\n\n\n"),
    can_get_capsule(Discs, 5).

%% Solves the puzzle with 15.txt as input
start:-
    phrase_from_file(discs(Discs), "15.txt"),
    can_get_capsule(Discs, Time),
    format("Part a: ~n"),
    pretty_print(Time),
    length(Discs, L),
    L1 is L + 1,
    append(Discs, [disc(L1, 11, 0)], Discs1),
    can_get_capsule(Discs1, Time1),
    format("Part b: ~n"),
    pretty_print(Time1).

%% Checks wether we can get the capsule form the discs with the given time
%% can_get_capsule(+,-).
%% can_get_capsule(Discs, Time).
can_get_capsule(Discs, Time):-
    between(0, inf, Time),
    forall(member(Disc, Discs), fall_through(Disc, Time)).

%% Checks wether the capsule would fall through the particular disc when dropping it at the given time
%% fall_through(+,-).
%% fall_through(Disc, Time).
fall_through(disc(Id, NoPos, StartPos), Time):-
    CurrTime is Time + Id,
    get_pos(NoPos, StartPos, CurrTime, 0).

%% Gets the current position of the disc given the time and the configuration
%% get_pos(+,+,+,-).
%% get_pos(NoPos, StartPos, Time, CurrPos).
get_pos(NoPos, StartPos, Time, CurrPos):-
    CurrPos is (StartPos + Time) mod NoPos.

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(Time):-
    format("The first time to press the button and get the capsule is: ~p ~n", [Time]).