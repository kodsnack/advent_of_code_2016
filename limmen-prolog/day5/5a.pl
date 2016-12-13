%% AdventOfCode day 5 5a.pl
%% swi-prolog
%% compile: ['5a.pl']
%%
%% start.
%% or
%% crack_password(+,-).
%%
%% crack_password(DoorId, Pw).
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    crack_password("abc", "18f47a30").

%% Solves the puzzle with "ffykfhsq" as input
start:-
    crack_password("ffykfhsq", Pw),
    pretty_print(Pw).

%% Cracks the password for the given door
%% crack_password(+,-).
%% crack_password(DoorId, Pw).
crack_password(DoorId, Pw):-
    crack_password(DoorId, 0, 0, PwCodes),
    string_codes(Pw, PwCodes).

crack_password(_,8, _, []).

crack_password(DoorId, N, I, [Y|Ys]):-
    N \= 8,
    get_char(DoorId, I, I1, Y),
    N1 is N + 1,
    I2 is I1 + 1,
    crack_password(DoorId, N1, I2, Ys).

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

%% Checks if a given hash starts with five zeros
%% start_With_five_zeros(+,+,-).
%% start_with_five_zeros(Hash, Count, Char).
start_with_five_zeros([Char|_], 5, Char).

start_with_five_zeros([48|Xs], C, Char):-
    C1 is C + 1,
    start_with_five_zeros(Xs, C1, Char).


%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(Pw):-
    format("The cracked password is: ~p ~n", [Pw]).
