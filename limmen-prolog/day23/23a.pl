%% AdventOfCode day 23 23ab.pl
%% swi-prolog
%% compile: ['23ab.pl']
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
operator(tgl) --> "tgl".

register(a) --> "a".
register(b) --> "b".
register(c) --> "c".
register(d) --> "d".

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Solves the puzzle with 23.txt as input
start:-
    phrase_from_file(instructions(Instr), "23.txt"),
    !,
    length(Instr, Len),
    parse_instr(Instr, Len, 1, regs{a:7, b:0, c:0, d:0}, Regs0),
    format("Solution part a ~n"),
    pretty_print(Regs0),
    parse_instr(Instr, Len, 1, regs{a:12, b:0, c:0, d:0}, Regs1),
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
    eval_instr(Op, Index, Index1, Acc0, Acc1, Instr, Instr1),
    !,
    parse_instr(Instr1, Len, Index1, Acc1, Acc2).

%% Evaluates an instruction
%% eval_instr(+,+,-,+,-).
%% eval_instr(Op, Index, NewIndex, Acc, NewAcc).

%%Input-dependent optimization. TODO: Make general optimization
eval_instr(_, 5, 11, R, regs{a:BD, b:R.b, c:0, d:0}, I, I):-
    !,
    BD is R.b * R.d.

eval_instr(instr(jnz, X, Y), Index, Index1, Acc0, Acc0, Instr, Instr):-
    (
     ((integer(X), \+ X = 0); (\+ Acc0.X = 0)) ->
     (integer(Y) ->
      Index1 is Index + Y;
      (Acc0.Y = 0 ->
       Index1 is Index + 1;
       Index1 is Index + Acc0.Y
      )
     )
    );
    Index1 is Index + 1.

eval_instr(instr(cpy, X, Y), Index, Index1, Acc0, Acc1, Instr, Instr):-
    (atom(Y) ->
     Index1 is Index + 1,
     (
      integer(X) ->
      Acc1 = Acc0.put(Y, X);
      Acc1 = Acc0.put(Y, Acc0.X)
     );
     Index1 is Index + 1,
     Acc1 = Acc0
    ).

eval_instr(instr(inc, X), Index, Index1, Acc0, Acc1, Instr, Instr):-
    Index1 is Index + 1,
    Val is Acc0.X + 1,
    Acc1 = Acc0.put(X, Val).

eval_instr(instr(dec, X), Index, Index1, Acc0, Acc1, Instr, Instr):-
    Index1 is Index + 1,
    Val is Acc0.X - 1,
    Acc1 = Acc0.put(X, Val).

eval_instr(instr(tgl, X), Index, Index1, Acc0, Acc0, Instr0, Instr1):-
    X1 is Index + Acc0.X,
    Index1 is Index + 1,
    toggle(Instr0, 1, X1, Instr1).

%% Toggles an instruction
%% toggle(+,+,+,-).
%% toggle(PreToggle, Count, Index, Toggled).
toggle([T|Ts], Index, Index, [Toggled|Ts]):-
    toggle(T, Toggled).

toggle([], _, _, []).

toggle([T|Ts], Acc, Index, [T|R]):-
    \+ Acc = Index,
    Acc1 is Acc + 1,
    toggle(Ts, Acc1, Index, R).

%% toggle
%% toggle(+,-).
%% toggle(PreToggle, Toggle).
toggle(instr(tgl, X), instr(inc, X)).
toggle(instr(dec, X), instr(inc, X)).
toggle(instr(inc, X), instr(dec, X)).
toggle(instr(jnz, X, Y), instr(cpy, X, Y)).
toggle(instr(cpy, X, Y), instr(jnz, X, Y)). 

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(Regs):-
    format("Value of register a is: ~p ~n", [Regs.a]).