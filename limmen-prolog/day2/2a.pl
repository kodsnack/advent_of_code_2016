%% AdventOfCode day 2 2a.pl
%% swi-prolog
%% compile: ['2a.pl']
%%
%% start.
%% or
%% get_bathroom_code(+,-).
%%
%% get_bathroom_code(InputString, BathroomCode).
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    get_bathroom_code(["ULL", "RRDDD", "LURDL", "UUUUD"], 1985).

%% Solves the puzzle with 2a.txt as input string
start:-
    get_input(Input),
    !,
    get_bathroom_code(Input, Code),
    pretty_print(Code).

%% Reads inputstring
%% read_input(-).
%% read_input(VariableToStoreReadData).
get_input(Input):-
    open("2a.txt", read, Stream),
    read_line_to_codes(Stream,Line1),
    get_input(Stream, Line1, Input).

get_input(Stream, Line1, Input):-
    get_input(Stream, Line1, [], Input).

get_input(_, end_of_file, Input, Input).

get_input(Stream, Line, Acc, Input):-
    is_list(Line),
    append(Acc, [Line], Acc1),
    read_line_to_codes(Stream,Line1),
    get_input(Stream, Line1, Acc1, Input).

%% Computes the bathroomcode given a set of instructions
%% get_bathroom_code(+,-).
%% get_bathroom_code(InputString, BathroomCode).
get_bathroom_code(Input, Code):-
    get_bathroom_code(Input, [], Code).

get_bathroom_code([], Code, CodeInt):-
    atom_codes(CodeAtom, Code),
    atom_number(CodeAtom, CodeInt).

get_bathroom_code([H|T], [], Code):-
    get_digit(H, 5, Digit),
    number_codes(Digit, DigitStr),
    get_bathroom_code(T, DigitStr, Code).

get_bathroom_code([H|T], Acc, Code):-
    last(Acc, Pos),
    number_codes(PosInt, [Pos]),
    get_digit(H, PosInt, Digit),
    number_codes(Digit, DigitStr),
    append(Acc, DigitStr, Acc1),
    get_bathroom_code(T, Acc1, Code).

%% Retrieves the digit given a row of instructions
%% get_digit(+, +, -).
%% get_digit(RowOfInstructions, CurrentDigit, NewDigit).
get_digit([], Digit, Digit).

get_digit([85|T], Acc, Digit):-
    up(Acc, Acc1),
    get_digit(T, Acc1, Digit).

get_digit([68|T], Acc, Digit):-
    down(Acc, Acc1),
    get_digit(T, Acc1, Digit).

get_digit([76|T], Acc, Digit):-
    left(Acc, Acc1),
    get_digit(T, Acc1, Digit).

get_digit([82|T], Acc, Digit):-
    right(Acc, Acc1),
    !,
    get_digit(T, Acc1, Digit).    

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(Code):-
    format("The bathroom code is: ~p", Code).

%%%===================================================================
%%% Facts
%%%===================================================================

%% Moves up on the keypad
%% up(+, -).
%% up(CurrentPosition, NewPosition).
up(2, 2).

up(1, 1).

up(3, 3).

up(5, 2).

up(8, 5).

up(7, 4).

up(4, 1).

up(9, 6).

up(6, 3).

%% Moves down on the keypad
%% down(+, -).
%% down(CurrentPosition, NewPosition).
down(1, 4).

down(4, 7).

down(7, 7).

down(2, 5).

down(5, 8).

down(8, 8).

down(3, 6).

down(6, 9).

down(9, 9).

%% Moves left on the keypad
%% left(+, -).
%% left(CurrentPosition, NewPosition).    
left(7, 7).

left(8, 7).

left(9, 8).

left(6, 5).

left(5, 4).

left(4, 4).

left(3, 2).

left(2, 1).

left(1, 1).

%% Moves right on the keypad
%% right(+, -).
%% right(CurrentPosition, NewPosition).
right(7, 8).

right(8, 9).

right(9, 9).

right(4, 5).

right(5, 6).

right(6, 6).

right(1, 2).

right(2, 3).

right(3, 3).
