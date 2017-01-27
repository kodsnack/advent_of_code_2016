%% AdventOfCode day 21 part a and b 21ab.pl
%% swi-prolog
%% compile: ['21ab.pl']
%%
%% start.
%% or
%% apply_instructions(+,+,-). or apply_instructions(+,-,+).
%% apply_instructions(Instructions, DeScrambled, Scrambled).
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Facts
%%%===================================================================

:- use_module(library(pio)).
:- use_module(library(dcg/basics)).
:- set_prolog_flag(double_quotes, codes).

%%%===================================================================
%%% Definite Clause Grammars for parsing input file
%%%===================================================================

instructions([]) --> eos.
instructions([]) --> "\n\n".
instructions([X|Xs]) --> instr(X), "\n",  instructions(Xs).

instr(instr(Op, Args)) --> operator(Op), " ", args(Args).

operator(swap) --> "swap".
operator(reverse) --> "reverse".
operator(rotate) --> "rotate".
operator(move) --> "move".

args(args(position, Pos1, Pos2)) --> "position ", integer(Pos1), " with position ", integer(Pos2).
args(args(positions, Pos1, Pos2)) --> "positions ", integer(Pos1), " through ", integer(Pos2).
args(args(letter, Letter1, Letter2)) --> "letter ", [Letter1], " with letter ", [Letter2].
args(args(position, Pos1, Pos2)) --> "position ", integer(Pos1), " to position ", integer(Pos2).
args(args(based_on_position, Letter)) --> "based on position of letter ", [Letter].
args(args(dir, Dir, Steps)) --> dir(Dir), " ", integer(Steps), (" steps" | " step").

dir(left) --> "left".
dir(right) --> "right".

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Solves the puzzle with 21.txt as input
start:-
    phrase_from_file(instructions(Instr), "21.txt"),
    format("Part a: ~n"),
    apply_instructions(Instr, "abcdefgh", Scrambled),
    pretty_print_a(Scrambled),
    format("Part b: ~n"),
    permutation(Pw, "fbgdceah"),
    apply_instructions(Instr, Pw, "fbgdceah"),
    pretty_print_b(Pw). 

%% Applies the parsed instructions sequentially
%% apply_instructions(+,+,-). or apply_instructions(+,-,+).
%% apply_instructions(Instr, Pw, Scrambled).
apply_instructions(Instr, Pw, Scrambled):-
    foldl(do_instr, Instr, Pw, Scrambled).

%% Perform a single instruction
%% do_instr(+,+,-). or do_instr(+,-,+).
%% do_instr(Instr, Pw, Scrambled).
do_instr(instr(swap, args(letter, X, Y)), Pw, Scrambled):-
    swap_letter(Pw, X, Y, Scrambled).

do_instr(instr(swap, args(position, X, Y)), Pw, Scrambled):-
    nth0(X, Pw, XLetter),
    nth0(Y, Pw, YLetter),
    swap_letter(Pw, XLetter, YLetter, Scrambled).

do_instr(instr(rotate, args(dir, Dir, Steps)), Pw, Scrambled):-
    rotate(Dir, Steps, Pw, Scrambled).

do_instr(instr(rotate, args(based_on_position, X)), Pw, Scrambled):-
    rotate(X, Pw, Scrambled).

do_instr(instr(reverse, args(positions, X, Y)), Pw, Scrambled):-
    reverse(X, Y, Pw, Scrambled).

do_instr(instr(move, args(position, X, Y)), Pw, Scrambled):- 
    move(X, Y, Pw, Scrambled).

%% Move position X to position Y
%% move(+,+,+,-).
%% move(X, Y, Pw, Scrambled).
move(X, Y, Pw, Scrambled):-
    nth0(X, Pw, XChar),
    delete(Pw, XChar, Pw1),
    insert(XChar, Y, 0, Pw1, Scrambled).

%% Insert char at position Y
%% insert(+,+,+,+,-).
%% insert(XChar, Y, I, Rest, Result).
insert(XChar, Y, Y, Rest, [XChar|Rest]).

insert(XChar, Y, I, [X|Xs], [X|T]):-
    I < Y,
    I1 is I + 1,
    insert(XChar, Y, I1, Xs, T).

%% Reverse positions Start to End
%% reverse(+,+,+,-).
%% reverse(Start, End, Pw, Scrambled).
reverse(Start, End, Pw, Scrambled):-
    append(Pre, [X|Xs], Pw),
    nth0(Start, Pw, X),
    append(StartToEnd, Post, [X|Xs]),
    last(StartToEnd, Y),
    nth0(End, Pw, Y),
    reverse(StartToEnd, Reversed),
    append(Reversed, Post, S0),
    append(Pre, S0, Scrambled).

%% Rotate left/right X steps
%% rotate(+,+,+,-).
%% rotate(Dir, Steps, Pw, Scrambled).
rotate(left, Steps, Pw, Scrambled):-
    append(H, T, Pw),
    length(H, Steps),
    append(T, H, Scrambled).

rotate(right, Steps, Pw, Scrambled):-
    append(H, T, Pw),
    length(T, Steps),
    append(T, H, Scrambled).

%% Rotate based on position of letter X
%% rotate(+,+,-).
%% rotate(X, Pw, Scrambled).
rotate(X, Pw, Scrambled):-
    length(Pw, L),
    nth0(Pos, Pw, X),
    (Pos >= 4 ->
     Steps is (Pos + 1 + 1) mod L;
     Steps is (Pos + 1) mod L
    ),
    rotate(right, Steps, Pw, Scrambled).

%% Swaps letter X with leetter Y
%% swap_letter(+,+,+,-).
%% swap_letter(Pw, X, Y, Scrambled).
swap_letter([], _, _, []).

swap_letter([X|Xs], X, Y, [Y|R]):-
    swap_letter(Xs, X, Y, R).

swap_letter([Y|Xs], X, Y, [X|R]):-
    swap_letter(Xs, X, Y, R).

swap_letter([Z|Xs], X, Y, [Z|R]):-
    \+ Z = X,
    \+ Z = Y,
    swap_letter(Xs, X, Y, R).

%% Pretty print the result
%% Pretty_print(+).
%% pretty_print(Result).
pretty_print_a(Scrambled):-
    format("The scrambled password is: ~s ~n", [Scrambled]).

pretty_print_b(DeScrambled):-
    format("The descrambled password is: ~s ~n", [DeScrambled]).