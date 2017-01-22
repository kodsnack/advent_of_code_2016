%% AdventOfCode day 20 part a and b 20ab.pl
%% swi-prolog
%% compile: ['20ab.pl']
%%
%% start.
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Facts
%%%===================================================================

:- use_module(library(pio)).
:- use_module(library(dcg/basics)).
:- set_prolog_flag(double_quotes, codes).
:- dynamic(blocked/2).

%%%===================================================================
%%% Definite Clause Grammars for parsing input file
%%%===================================================================

blocked_all --> [].
blocked_all --> blocked_pair, "\n", blocked_all.
blocked_pair --> integer(Low), "-", integer(High), {assertz(blocked(Low, High))}.

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    phrase(blocked_all, "5-8\n0-2\n4-7\n"),
    first_valid_IP(3, 9),
    count_valid_IP(2, 9),
    end.

%% Solves the puzzle with 20.txt as input
start:-
    phrase_from_file(blocked_all, "20.txt"),
    format("Part a: ~n"),
    first_valid_IP(IP, 4294967295),
    pretty_print_a(IP),
    format("Part b: ~n"),
    count_valid_IP(Count, 4294967295),
    pretty_print_b(Count),
    end.

%% Retracts the database used for solving
end:-
    retractall(blocked(_,_)).

%% Checks if Num is blocked
%% blocked(+).
%% blocked(Num).
blocked(Num):-
    \+ forall(blocked(Low,High), \+ between(Low, High, Num)).

%% Counts number of valid IP's
%% count_valid_IP(-,+).
%% count_valid_IP(Count, Max).
count_valid_IP(Count, Max):-
    count_valid_IP(0, 0, Count, Max).

%% Counts valid IP's by generating valid IP's one by one
%% count_valid_IP(+,+,-,+).
%% count_valid_IP(Prev, Acc, Count, Max).
count_valid_IP(Prev, Acc, Count, Max):-
    (first_valid_IP(Prev, IP, Max) ->
     Acc1 is Acc + 1,
     IP1 is IP + 1,
     count_valid_IP(IP1, Acc1, Count, Max);
     Count is Acc
    ).

%% Finds the first valid IP
%% first_valid_IP(-,+).
%% first_valid_IP(IP, Max).
first_valid_IP(IP, Max):-
    first_valid_IP(0, IP, Max).

%% Finds the first valid IP by going though the blocked-ranges iteratively
%% first_valid_IP(+,-,+).
%% first_valid_IP(Index, IP, Max).
first_valid_IP(I, IP, Max):-
    blocked(I),
    blocked(Low, High),
    I >= Low,
    I =< High,
    High1 is High + 1,
    first_valid_IP(High1, IP, Max).

first_valid_IP(IP, IP, Max):-
    \+ blocked(IP),
    IP < Max+1.

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print_a(LowestIp):-
    format("The lowest non-blocked IP is: ~p ~n", [LowestIp]).

pretty_print_b(NoValidIp):-
    format("Number of valid IPs: ~p ~n", [NoValidIp]).