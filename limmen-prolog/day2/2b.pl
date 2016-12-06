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
    get_bathroom_code(["ULL", "RRDDD", "LURDL", "UUUUD"], "5DB3").

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

get_bathroom_code([], Code, Code).
%%    atom_codes(CodeAtom, Code),
%%    atom_number(CodeAtom, CodeInt).

get_bathroom_code([H|T], [], Code):-
    get_digit(H, 5, Digit),
    to_str(Digit, DigitStr),
    get_bathroom_code(T, DigitStr, Code).

get_bathroom_code([H|T], Acc, Code):-
    last(Acc, Pos),
    to_int([Pos], PosInt),
    get_digit(H, PosInt, Digit),
    to_str(Digit, DigitStr),
    append(Acc, DigitStr, Acc1),
    get_bathroom_code(T, Acc1, Code).

%% Auxiliary function to convert from digit representation to string for both chars and integers.
%% Useful since regular conversion functions only work with either integers or chars.
%% to_str(+, -).
%% to_str(IntRepresentation, StringRepresentation).
to_str(Digit, [Digit]):-
    Digit > 9.

to_str(Digit, DigitStr):-
    Digit =< 9,
    number_codes(Digit, DigitStr).

%% Auxiliary function to convert from string representation to integer for both chars and integers.
%% Useful since regular conversion functions only work with either integers or chars.
%% to_str(+, -).
%% to_str(IntRepresentation, StringRepresentation).
to_int([DigitStr], DigitStr):-
    DigitStr >= 65.

to_int([DigitStr], Digit):-
    DigitStr < 58,
    number_codes(Digit, [DigitStr]).
    
    

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
    format("The bathroom code is: ~s ~n", [Code]).

%%%===================================================================
%%% Facts
%%%===================================================================

%% Moves up on the keypad
%% up(+, -).
%% up(CurrentPosition, NewPosition).
up(2, 2).

up(1, 1).

up(3, 1).

up(5, 5).

up(8, 4).

up(7, 3).

up(4, 4).

up(9, 9).

up(6, 2).

up(65, 6).

up(66, 7).

up(67, 8).

up(68, 66). 

%% Moves down on the keypad
%% down(+, -).
%% down(CurrentPosition, NewPosition).
down(1, 3).

down(4, 8).

down(7, 66).

down(2, 6).

down(5, 5).

down(8, 67).

down(3, 7).

down(6, 65).

down(9, 9).

down(65, 65).

down(66, 68).

down(67, 67).

down(68, 68). 

%% Moves left on the keypad
%% left(+, -).
%% left(CurrentPosition, NewPosition).    
left(7, 6).

left(8, 7).

left(9, 8).

left(6, 5).

left(5, 5).

left(4, 3).

left(3, 2).

left(2, 2).

left(1, 1).

left(65, 65).

left(66, 65).

left(67, 66).

left(68, 68). 

%% Moves right on the keypad
%% right(+, -).
%% right(CurrentPosition, NewPosition).
right(7, 8).

right(8, 9).

right(9, 9).

right(4, 4).

right(5, 6).

right(6, 7).

right(1, 1).

right(2, 3).

right(3, 4).

right(65, 66).

right(66, 67).

right(67, 67).

right(68, 68).
