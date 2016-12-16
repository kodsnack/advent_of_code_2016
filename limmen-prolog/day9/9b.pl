%% AdventOfCode day 9 9b.pl
%% swi-prolog
%% compile: ['9b.pl']
%%
%% start.
%% or
%% decompress(+,-).
%% decompress(Input, Length).
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    string_codes("(3x3)XYZ",C0),
    decompress([C0], 9),
    string_codes("X(8x2)(3x3)ABCY",C1),
    decompress([C1], 20),
    string_codes("(27x12)(20x12)(13x14)(7x10)(1x12)A",C2),
    decompress([C2], 241920),
    string_codes("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN",C3),
    decompress([C3], 445).

%% Solves the puzzle with 8.txt as input string
start:-
    get_input(Input),
    decompress(Input, Length),
    pretty_print(Length).

%% Reads inputstring
%% read_input(-).
%% read_input(VariableToStoreReadData).
get_input(Input):-
    open("9.txt", read, Stream),
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

%% Decompresses the Input and returns the length
%% decompress(+,-).
%% decompress(Input, Length).
decompress(Input, Length):-
    foldl(decompress_line, Input, 0, Length).

%% Decompresses a line of the input and returns the length
%% decompress_line(+,+,-).
%% decompress_line(Line, CurrentLength, UpdatedLength).
decompress_line([], Length, Length).

decompress_line([40|T], I, Length):-
    parse_instruction(T, NoChars, NoRepeat, Rest),
    !,
    number_codes(CharsInt, NoChars),
    number_codes(TimesInt, NoRepeat),
    get_rest(Rest, CharsInt, Rest2, Rest3),
    decompress_line(Rest2, 0, L2),
    I1 is (L2 * TimesInt) + I,
    decompress_line(Rest3, I1, Length).

decompress_line([H|T], I, Length):-
    H \= [],
    I1 is I + 1,
    decompress_line(T, I1, Length).


%% Auxillary predicate that returns rest of line after applying decompression to a given marker
%% get_rest(+,+,-,-).
%% get_rest(Input, CharsInt, Rest2, Rest3).
get_rest([], _, [], []).

get_rest([H|T], 0, [], [H|T]).

get_rest([H|T], I, [H|X], Rest):-
    I > 0,
    I1 is I - 1,
    get_rest(T, I1, X, Rest).

%% Parses a line for decompression instructions
%% parse_instruction(+,-,-,-).
%% parse_instruction(Line, NumberOfChars, RepeatedNumber, Rest).
parse_instruction(Input, NoChars, NoRepeat, Rest):-
    parse_no_chars(Input, NoChars, R0),
    parse_no_repeat(R0, NoRepeat, Rest).

%% Parses the number of chars for the decompression instruction
%% parse_no_chars(+,+,-).
%% parse_no_chars(Input, Acc, NoChars).
parse_no_chars([120|T], [], T).

parse_no_chars([H|T], [H|X], Rest):-
    H \= 120,
    parse_no_chars(T, X, Rest).

%% Parses the number of chars for the decompression instruction
%% parse_no_repeat(+,+,-).
%% parse_no_chars(Input, Acc, NoRepeat).
parse_no_repeat([41|T], [], T).

parse_no_repeat([H|T], [H|X], Rest):-
    H \= 41,
    parse_no_repeat(T, X, Rest).

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(Length):-
    format("Decompressed length is ~p ~n", [Length]).
