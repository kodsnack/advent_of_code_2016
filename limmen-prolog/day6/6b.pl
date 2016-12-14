%% AdventOfCode day 6 6b.pl
%% swi-prolog
%% compile: ['6b.pl']
%%
%% start.
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    string_codes("eedadn", C1),
    string_codes("drvtee", C2),
    string_codes("eandsr", C3),
    string_codes("raavrd", C4),
    string_codes("atevrs", C5),
    string_codes("tsrnev", C6),
    string_codes("sdttsa", C7),
    string_codes("rasrtv", C8),
    string_codes("nssdts", C9),
    string_codes("ntnada", C10),
    string_codes("svetve", C11),
    string_codes("tesnvt", C12),
    string_codes("vntsnd", C13),
    string_codes("vrdear", C14),
    string_codes("dvrsen", C15),
    string_codes("enarar", C16),
    get_columns([C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16], Columns),
    count_columns(Columns, CountedColumns),
    get_msg(CountedColumns, Code),
    string_codes(StrCode, Code),
    StrCode = "advent".

%% Solves the puzzle with 6.txt as input string
start:-
    get_input(Input),
    get_columns(Input, Columns),
    count_columns(Columns, CountedColumns),
    get_msg(CountedColumns, Code),
    string_codes(StrCode, Code),
    pretty_print(StrCode).


%% Reads inputstring
%% read_input(-).
%% read_input(VariableToStoreReadData).
get_input(Input):-
    open("6.txt", read, Stream),
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

%% Gets the message out of the counted columns
%% get_msg(+,-).
%% get_msg(CountedColumns, Msg).
get_msg([], []).

get_msg([[(X,_)|_]|Ys], [X|Zs]):-
    get_msg(Ys, Zs).

%% Parses input into columns
%% get_columns(+,-).
%% get_columns(Input, Columns).
get_columns(Input, Columns):-
    get_columns(Input, [], Columns).

get_columns([], Acc, Acc).

get_columns([H|T], Acc, Columns):-
    get_column(H, Acc, Acc1),
    get_columns(T, Acc1, Columns).

%% Parses a line of input and adds the chars to their corresponding columns
%% get_column(+,+,-).
%% get_column(Column, ColumnsSoFar, NewColumns).
get_column([], _, []).

get_column([H|T], [Y|Ys], [[H|Y]|Xs]):-
    get_column(T, Ys, Xs).

get_column([H|T], [], [[H]|Xs]):-
    get_column(T, [], Xs).

%% Counts the frequency of letters in the columns
%% count_columns(+,-).
%% count_columns(Columns, CountedColumns).
count_columns([], []).

count_columns([H|T], [X|Xs]):-
    count_column(H, H, [], X),
    count_columns(T, Xs).

%% Counts the frequency of letters for a given columns
%% count_column(+,+,-,-).
%% count_column(Column, ColumnLeft, CountedColumn, SortedColumn)
count_column(_, [], CountedColumn, SortedColumn):-
    sort(2,@=<, CountedColumn, SortedColumn).

count_column(Column, [X|Xs], Acc, CountedColumn):-
    \+ member((X,_), Acc),
    do_count(X, Column, 0, Y),
    count_column(Column, Xs, [Y|Acc], CountedColumn).

count_column(Column, [X|Xs],Acc, CountedColumn):-
    member((X,_), Acc),
    count_column(Column, Xs, Acc, CountedColumn).

%% Does the actual counting of a given letter in the column
%% do_count(+,+,+,-).
%% do_count(Char, Column, Counter, (Char, Count)).
do_count(X, [], I, (X,I)).

do_count(X, [X|Xs], I, Y):-
    I1 is I + 1,
    do_count(X, Xs, I1, Y).

do_count(X, [H|Xs], I, Y):-
    X \= H,
    do_count(X, Xs, I, Y).

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(Code):-
    format("Error-corrected message is: ~p ~n", [Code]).
