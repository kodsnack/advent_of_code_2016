%% AdventOfCode day 25 25ab.pl
%% swi-prolog
%% compile: ['25ab.pl']
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
instr(instr(Op, Arg1)) --> operator(Op), " ", integer(Arg1).

operator(cpy) --> "cpy".
operator(inc) --> "inc".
operator(dec) --> "dec".
operator(jnz) --> "jnz".
operator(tgl) --> "tgl".
operator(out) --> "out".

register(a) --> "a".
register(b) --> "b".
register(c) --> "c".
register(d) --> "d".

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Solves the puzzle with 23.txt as input
start:-
    phrase_from_file(instructions(Instr), "25.txt"),
    !,
    length(Instr, Len),
    find_first(Instr, Len, 0, First),
    format("Solution part a (no part b this day) ~n"), %%Sol for my input = 196
    pretty_print(First). 

%% Finds the first value of a that gives correct clock signal
%% find_fist(+,+,+,-).
%% find_first(Instr, Len, Count, First).
find_first(Instr, Len, Count, First):-
    \+ parse_instr(Instr, Len, 1, regs{a:Count, b:0, c:0, d:0}, _, -1),
    format("~nTrying number ~p ~n", [Count]),
    Count1 is Count + 1,
    find_first(Instr, Len, Count1, First).

find_first(Instr, Len, First, First):-
    parse_instr(Instr, Len, 1, regs{a:First, b:0, c:0, d:0}, _, -1).



%% Interprets a instruction and either terminates or evaluates the instruction and recurs
%% parse_instr(+,+,+,+,-,+).
%% parse_instr(Op, Len, Index, Acc, Res, PrevSignal).
parse_instr(_, Len, Index, Acc, Acc, _):-
    Index < 0;
    Index > Len,
    !.

parse_instr(Instr, Len, Index, Acc0, Acc2, PrevSignal):-
    nth1(Index, Instr, Op),
    eval_instr(Op, Index, Index1, Acc0, Acc1, Instr, Instr1, PrevSignal, NewSignal),    
    !,
    parse_instr(Instr1, Len, Index1, Acc1, Acc2, NewSignal).

%% Evaluates an instruction
%% eval_instr(+,+,-,+,-,+,-,+,-).
%% eval_instr(Op, Index, NewIndex, Acc, NewRegs, Instr, NewInstr, Signal, NewSignal).
eval_instr(instr(jnz, X, Y), Index, Index1, Acc0, Acc0, Instr, Instr, PrevSignal, PrevSignal):-
    (
     ((integer(X), \+ X = 0); (atom(X), \+ Acc0.X = 0)) ->
     (integer(Y) ->
      Index1 is Index + Y;
      (Acc0.Y = 0 ->
       Index1 is Index + 1;
       Index1 is Index + Acc0.Y
      )
     )
    );
    Index1 is Index + 1.

eval_instr(instr(cpy, X, Y), Index, Index1, Acc0, Acc1, Instr, Instr, PrevSignal, PrevSignal):-
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

eval_instr(instr(inc, X), Index, Index1, Acc0, Acc1, Instr, Instr, PrevSignal, PrevSignal):-
    Index1 is Index + 1,
    Val is Acc0.X + 1,
    Acc1 = Acc0.put(X, Val).

eval_instr(instr(dec, X), Index, Index1, Acc0, Acc1, Instr, Instr, PrevSignal, PrevSignal):-
    Index1 is Index + 1,
    Val is Acc0.X - 1,
    Acc1 = Acc0.put(X, Val).

eval_instr(instr(out, 0), Index, Index1, Acc0, Acc0, Instr, Instr, -1, 0):-
    Index1 is Index + 1.
eval_instr(instr(out, 0), Index, Index1, Acc0, Acc0, Instr, Instr, 1, 0):-
    Index1 is Index + 1.
eval_instr(instr(out, 1), Index, Index1, Acc0, Acc0, Instr, Instr, 0, 1):-
    Index1 is Index + 1.
eval_instr(instr(out, X), Index, Index1, Acc0, Acc0, Instr, Instr, 0, 1):-
    atom(X),
    Acc0.X = 1,
    Index1 is Index + 1.
eval_instr(instr(out, X), Index, Index1, Acc0, Acc0, Instr, Instr, 1, 0):-
    atom(X),
    Acc0.X = 0,
    Index1 is Index + 1.
eval_instr(instr(out, X), Index, Index1, Acc0, Acc0, Instr, Instr, -1, 0):-
    atom(X),
    Acc0.X = 0,
    Index1 is Index + 1.
eval_instr(instr(tgl, X), Index, Index1, Acc0, Acc0, Instr0, Instr1, PrevSignal, PrevSignal):-
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

%% Checks if a signal is valid
%% valid_signal(+,+).
%% valid_signal(PrevSignal, NextSignal).
valid_signal(0, 1).
valid_signal(1, 0).

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(First):-
    format("First Value of register a is: ~p ~n", [First]).