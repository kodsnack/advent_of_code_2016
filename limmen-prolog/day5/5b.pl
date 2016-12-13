%% AdventOfCode day 5 5b.pl
%% swi-prolog
%% compile: ['5b.pl']
%%
%% start.
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    crack_password("abc", UnSorted),
    sort_pw(UnSorted, "05ace8e3").


%% Solves the puzzle with "ffykfhsq" as input
start:-
    crack_password("ffykfhsq", Pw),
    sort_pw(Pw, SortedPw),
    pretty_print(SortedPw).


%% Puts the characters in their right positions
%% sort_pw(+,-).
%% sort_pw(Pw, SortedPw).
sort_pw(Pw, SortedPw):-
    sort(2,@=<, Pw, Pw1),
    sort_pw(Pw1, [], Pw2),
    reverse(Pw2, Pw3),
    string_codes(SortedPw, Pw3).

sort_pw([], SortedPw, SortedPw).

sort_pw([(Ch,_)|Xs], Acc, SortedPw):-
    sort_pw(Xs, [Ch|Acc], SortedPw).

%% Cracks the password for the given door
%% crack_password(+,-).
%% crack_password(DoorId, Pw).
crack_password(DoorId, Pw):-
    crack_password(DoorId, 0, 0, [], Pw).

crack_password(_,8, _, Acc, Acc).

crack_password(DoorId, N, I, Acc, Pw):-
    N \= 8,
    get_char(DoorId, I, I1, (Ch,Index)),
    (member((_,Index), Acc)->                  
         N1 is N,
         I2 is I1 + 1,
         Acc1 = Acc;
     (
         N1 is N + 1,
         I2 is I1 + 1,
         Acc1 = [(Ch,Index)|Acc]
     )
    ),
    crack_password(DoorId, N1, I2, Acc1, Pw).

%% Gets the next char given a doorId and a index
%% get_char(+,+,-,-).
%% get_char(DoorId, CurrentIndex, IndexOfChar, Char).
get_char(DoorId, I, I1, Char):-
    number_codes(I, ICode),
    string_codes(IStr, ICode),
    string_concat(DoorId, IStr, DoorId1),    
    md5_hash(DoorId1, Hash, []),
    atom_codes(Hash, HashCodes),(
        start_with_five_zeros(HashCodes, 0, Char) ->
            I1 is I;
        (
            I2 is I + 1,
            get_char(DoorId, I2, I1, Char)
        )).

%% Checks if a given hash starts with five zeros and that the Index is valid
%% start_With_five_zeros(+,+,-).
%% start_with_five_zeros(Hash, Count, (Char,Index)).
start_with_five_zeros([Index,Char|_], 5, (Char,Index)):-
    Index < 56,
    Index > 47.

start_with_five_zeros([48|Xs], C, Char):-
    C1 is C + 1,
    start_with_five_zeros(Xs, C1, Char).


%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(Pw):-
    format("The cracked password is: ~p ~n", [Pw]).
