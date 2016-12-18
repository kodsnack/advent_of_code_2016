%% AdventOfCode day 10 10ab.pl
%% swi-prolog
%% compile: ['10ab.pl']
%%
%% start.
%%
%% solves both problem a and b.
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    string_codes("value 5 goes to bot 2", C0),
    string_codes("bot 2 gives low to bot 1 and high to bot 0", C1),
    string_codes("value 3 goes to bot 1", C2),
    string_codes("bot 1 gives low to output 1 and high to bot 0", C3),
    string_codes("bot 0 gives low to output 2 and high to output 0", C4),
    string_codes("value 2 goes to bot 2", C5),
    parse([C0,C1,C2,C3,C4,C5], I, B),
    find_bot_id(I,B,2,5,2, Bots),
    multiply_three_chips(Bots, 30).

%% Solves the puzzle with 10.txt as input string
start:-
    get_input(Input),
    parse(Input, Instructions, Bots),
    find_bot_id(Instructions, Bots, 17, 61, Id, Bots1),
    pretty_print_a(Id),
    multiply_three_chips(Bots1, Val),
    pretty_print_b(Val).    

%% Reads inputstring
%% read_input(-).
%% read_input(VariableToStoreReadData).
get_input(Input):-
    open("10.txt", read, Stream),
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

%% Solves problem b, multiplies chips in output 0,1,2
%% multiply_three(+,-).
%% multiply_three(Bots,Result).
multiply_three_chips(Bots, Val):-
    Val is Bots.0.output * Bots.1.output * Bots.2.output.

%% Finds id of the bot that is responsible for comparing the given numbers
%% find_bot_id(+,+,+,+,-,-).
%% find_bot_id(Input, Bots, Compare1, Compare2, Id, Bots1).
find_bot_id([], Bots, Cmp1, Cmp2, Id, Bots):-
    H = Bots.get(0),
    bot{low:Cmp1,high:Cmp2,output:_,compare:_}= Bots.get(Id),
    G = Bots.get(Id).

find_bot_id([H|T], Bots, Cmp1, Cmp2, Id, Bots2):-
    do_instruction(H, Bots, Bots1),
    find_bot_id(T, Bots1, Cmp1, Cmp2, Id, Bots2).

find_bot_id([H|T], Bots, Cmp1, Cmp2, Id, Bots2):-
    \+ do_instruction(H, Bots, Bots1),
    append(T,[H],T1),
    find_bot_id(T1, Bots, Cmp1, Cmp2, Id, Bots2).

%% Parses the value-instructions
%% parse(+,-,-).
%% parse(Input, RestOfInstructions, Bots).
parse(Input, Instructions1, Bots):-
    foldl(parse_line, Input, ([], bots{}), (Instructions, Bots)),
    reverse(Instructions, Instructions1).

%% Parses a value-instruction
%% parse_line(+,+,-)
%% parse_line(Line, (RestAcc, BotsAcc), RestOfInstructions, Bots)
parse_line(Line, (Inst, Bots), ([Line|Inst], Bots)):-
    string_codes(LineStr, Line),
    sub_string(LineStr,0,3,_,"bot").

parse_line(Line, (Inst, Bots), (Inst, Bots1)):-
    string_codes(LineStr, Line),
    sub_string(LineStr,0,5,_,"value"),
    split_string(LineStr, " ", "", [_,Val,_,_,_,Id]),
    number_codes(IdInt, Id),
    number_codes(ValInt, Val),
    ((Bot = Bots.get(IdInt)) ->
     Bot = Bots.get(IdInt);
     (
      Bot = bot{low:nil,high:nil,output:nil, compare:[]}
     )
    ),
    insert_value(Bot, ValInt, nil, Bot1),
    Bots1 = Bots.put(IdInt, Bot1).

%% inserts a value the the correct slot of a bot
%% insert_value(+,+,+,-).
%% insert_value(Bot, Value, output/nil, Bot1).
insert_value(Bot, Val, output, Bot1):-
    Bot1 = Bot.put(output, Val).

insert_value(Bot, Val, _, Bot1):-
    Bot.low = nil,
    Bot.high = nil,
    Bot1 = Bot.put(low, Val).

insert_value(Bot, Val, _, Bot1):-
    Bot.low = nil,
    \+ Bot.high = nil,
    (Val > Bot.high ->
     Bot1 = Bot.put(low, Bot.high).put(high,Val);
     (
      Bot1 = Bot.put(low, Val)
     )
    ).

insert_value(Bot, Val, _, Bot1):-
    Bot.high = nil,
    \+ Bot.low = nil,
    (Val < Bot.low ->
     Bot1 = Bot.put(high, Bot.low).put(low,Val);
     (
      Bot1 = Bot.put(high, Val)
     )
    ).

%% Handles a send-instruction and updates the bots data structure accordingly
%% do_instruction(+,+,-).
%% do_instruction(Line, Bots, Bots3).
do_instruction(Line, Bots, Bots3):-
    string_codes(LineStr, Line),
    split_string(LineStr, " ", "", [_,Giver,_,Choice1,_,Output1,Receiver1,_,Choice2,_,Output2,Receiver2]),
    atom_codes(ChoiceAtm1, Choice1),
    atom_codes(ChoiceAtm2, Choice2),
    atom_codes(OutputAtm1, Output1),
    atom_codes(OutputAtm2, Output2),
    number_codes(GiverInt, Giver),
    number_codes(Receiver1Int, Receiver1),
    number_codes(Receiver2Int, Receiver2),
    GiverBot = Bots.get(GiverInt),
    \+ GiverBot.low = nil,
    \+ GiverBot.high = nil,
    Choice1Val = GiverBot.ChoiceAtm1,
    Choice2Val = GiverBot.ChoiceAtm2,
    (Receiver1Bot = Bots.get(Receiver1Int) ->
     Bots1 = Bots;
     (
      Receiver1Bot = bot{low:nil,high:nil,output:nil,compare:[]},
      Bots1 = Bots.put(Receiver1Int, Receiver1Bot)
     )
    ),
    (
     Receiver2Bot = Bots1.get(Receiver2Int) ->     
     Bots2 = Bots;
     (
      Receiver2Bot = bot{low:nil,high:nil,output:nil,compare:[]},
      Bots2 = Bots1.put(Receiver2Int, Receiver2Bot)
     )
    ),
    insert_value(Receiver1Bot, Choice1Val, OutputAtm1, Receiver1Bot1),
    insert_value(Receiver2Bot, Choice2Val, OutputAtm2, Receiver2Bot1),
    GiverBot1 = GiverBot.put(compare, [Choice1Val, Choice2Val]),
    Bots3 = Bots2.put(GiverInt, GiverBot1).put(Receiver1Int, Receiver1Bot1).put(Receiver2Int, Receiver2Bot1).


%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print_a(Id):-
    format("The bot number is ~p ~n", [Id]).

pretty_print_b(Val):-
    format("The multiplied number is ~p ~n", [Val]).
