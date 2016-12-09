-module(day2).

-compile([export_all]).

solve_part1() ->
    {ok, Input} = file:read_file("input/day2"),
    solve(parse(Input), keypad_part1()).

solve_part2() ->
    {ok, Input} = file:read_file("input/day2"),
    solve(parse(Input), keypad_part2()).

parse(Bin) ->
    string:tokens(binary_to_list(Bin), "\n").

keypad_part1() ->
    [ [$1, $2, $3]
    , [$4, $5, $6]
    , [$7, $8, $9]
    ].

keypad_part2() ->
    [ [$_, $_, $1, $_, $_]
    , [$_, $2, $3, $4, $_]
    , [$5, $6, $7, $8, $9]
    , [$_, $A, $B, $C, $_]
    , [$_, $_, $D, $_, $_]
    ].

solve(Lines, Keypad) ->
    {Code, _} = lists:foldl(fun(Line, {Digs, Pos}) ->
                                    NewPos = move(Line, Pos, Keypad),
                                    {[digit(NewPos, Keypad)|Digs], NewPos}
                            end, {[], find_digit($5, Keypad)}, Lines),
    lists:reverse(Code).

do_move($U, {X, Y}) -> {X, Y-1};
do_move($D, {X, Y}) -> {X, Y+1};
do_move($L, {X, Y}) -> {X-1, Y};
do_move($R, {X, Y}) -> {X+1, Y}.

move([], Pos, _Keypad) ->
    Pos;
move([H|T], Pos, Keypad) ->
    NewPos = do_move(H, Pos),
    case digit(NewPos, Keypad) of
        $_ -> move(T, Pos, Keypad);
        _  -> move(T, NewPos, Keypad)
    end.

digit({X,Y}, Keypad) ->
    try
        lists:nth(X, lists:nth(Y, Keypad))
    catch
        _:_ -> $_
    end.

find_digit(N, Keypad) ->
    hd([{X,Y} || Y <- lists:seq(1, length(Keypad)),
                 X <- lists:seq(1, length(lists:nth(Y, Keypad))),
                 lists:nth(X, lists:nth(Y, Keypad)) =:= N]).

%%%_* Tests ============================================================
-include_lib("eunit/include/eunit.hrl").

day2_test_() ->
    Example = ["ULL", "RRDDD", "LURDL", "UUUUD"],
    [ ?_assertEqual("1985", solve(Example, keypad_part1()))
    , ?_assertEqual("65556", solve_part1())
    , ?_assertEqual("5DB3", solve(Example, keypad_part2()))
    , ?_assertEqual("CB779", solve_part2())
    ].
