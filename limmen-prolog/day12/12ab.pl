%% AdventOfCode day 12 12ab.pl
%% swi-prolog
%% compile: ['12ab.pl']
%%
%% start.
%%
%% solves both problem a and b.
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Facts
%%%===================================================================

:- use_module(library(pio)).
:- use_module(library(dcg/basics)).
:- use_module(library(lists)).
:- set_prolog_flag(double_quotes, codes).
:- set_prolog_flag(optimise, true).
:- set_prolog_stack(local,  limit(2 000 000 000)).

%%%===================================================================
%%% Definite Clause Grammars for parsing input file
%%%===================================================================

instructions([]) --> eos, !.
instructions([]) --> "\n\n", !.
instructions([X|Xs]) --> instr(X), "\n", instructions(Xs).

instr(instr(Op, Arg1, Arg2)) --> operator(Op), " ", (integer(Arg1) | register(Arg1)), " ", (register(Arg2) | integer(Arg2)).
instr(instr(Op, Arg1)) --> operator(Op), " ", register(Arg1).

operator(cpy) --> "cpy".
operator(inc) --> "inc".
operator(dec) --> "dec".
operator(jnz) --> "jnz".

register(a) --> "a".
register(b) --> "b".
register(c) --> "c".
register(d) --> "d".

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    phrase(instructions(Instr), "cpy 41 a\ninc a\ninc a\ndec a\njnz a 2\ndec a\n\n\n"),
    !,
    length(Instr, Len),
    parse_instr(Instr, Len, 1, regs{a:0, b:0, c:0, d:0}, regs{a:42, b:_, c:_, d:_}).

%% Solves the puzzle with 12.txt as input
start:-
    phrase_from_file(instructions(Instr), "12.txt"),
    !,
    length(Instr, Len),
    parse_instr(Instr, Len, 1, regs{a:0, b:0, c:0, d:0}, Regs0),
    format("Solution part a ~n"),
    pretty_print(Regs0),
    parse_instr(Instr, Len, 1, regs{a:0, b:0, c:1, d:0}, Regs1),
    format("Solution part b ~n"),
    pretty_print(Regs1).

%% Interprets a instruction and either terminates or evaluates the instruction and recurs
%% parse_instr(+,+,+,+,-).
%% parse_instr(Op, Len, Index, Acc, Res).
parse_instr(_, Len, Index, Acc, Acc):-
    Index < 0;
    Index > Len,
    !.

parse_instr(Instr, Len, Index, Acc0, Acc2):-
    nth1(Index, Instr, Op),
    eval_instr(Op, Index, Index1, Acc0, Acc1),
    !,
    parse_instr(Instr, Len, Index1, Acc1, Acc2).

%% Evaluates an instruction
%% eval_instr(+,+,-,+,-).
%% eval_instr(Op, Index, NewIndex, Acc, NewAcc).
eval_instr(instr(jnz, X, Y), Index, Index1, Acc0, Acc0):-
    (
     ((integer(X), \+ X = 0); (\+ Acc0.X = 0)) ->
     Index1 is Index + Y;
     Index1 is Index + 1
    ).

eval_instr(instr(cpy, X, Y), Index, Index1, Acc0, Acc1):-
    Index1 is Index + 1,
    (
     integer(X) ->
     Acc1 = Acc0.put(Y, X);
     Acc1 = Acc0.put(Y, Acc0.X)
    ).

eval_instr(instr(inc, X), Index, Index1, Acc0, Acc1):-
    Index1 is Index + 1,
    Val is Acc0.X + 1,
    Acc1 = Acc0.put(X, Val).

eval_instr(instr(dec, X), Index, Index1, Acc0, Acc1):-
    Index1 is Index + 1,
    Val is Acc0.X - 1,
    Acc1 = Acc0.put(X, Val).

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(Regs):-
    format("Value of register a is: ~p ~n", [Regs.a]).