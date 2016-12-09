-module(day1).

-compile([export_all]).

solve_part1() ->
    {ok, Input} = file:read_file("input/day1"),
    solve_part1(parse(Input)).

solve_part2() ->
    {ok, Input} = file:read_file("input/day1"),
    solve_part2(parse(Input)).

parse(Bin) ->
    Str0 = binary_to_list(Bin),
    Str  = [C || C <- Str0, C =/= $\n],
    [op(Token) || Token <- string:tokens(Str, ", ")].

op([$L|N]) -> {left, list_to_integer(N)};
op([$R|N]) -> {right, list_to_integer(N)}.

solve_part1(Ops) ->
    {{X, Y}, _} = lists:foldl(fun({Turn, Steps}, {Pos, Dir}) ->
                                      NewDir = turn(Dir, Turn),
                                      NewPos = lists:last(walk(Pos, NewDir, Steps)),
                                      {NewPos, NewDir}

                              end, {{0, 0}, north()}, Ops),
    abs(X) + abs(Y).

solve_part2(Ops) ->
    {X, Y} = solve_part2(Ops, {[{0, 0}], north()}),
    abs(X) + abs(Y).

solve_part2([{Turn, Steps}|Ops], {[Pos|_] = Visited, Dir}) ->
    NewDir = turn(Dir, Turn),
    NewVisited = walk(Pos, NewDir, Steps),
    case has_visited(NewVisited, Visited) of
        {true, VisitedPos} ->
            VisitedPos;
        false ->
            solve_part2(Ops, {lists:reverse(NewVisited) ++ Visited, NewDir})
    end.

has_visited([], _Visited) ->
    false;
has_visited([Pos|Rest], Visited) ->
    case lists:member(Pos, Visited) of
        true  -> {true, Pos};
        false -> has_visited(Rest, Visited)
    end.

north() ->
    0.

turn(0, Turn)    -> turn(4, Turn);
turn(Dir, left)  -> (Dir-1) rem 4;
turn(Dir, right) -> (Dir+1) rem 4.

walk(_, _, 0) ->
    [];
walk({X, Y}, Dir, Steps) ->
    {DX, DY} = lists:nth(Dir+1, directions()),
    [{X+DX, Y+DY}|walk({X+DX, Y+DY}, Dir, Steps-1)].

directions() ->
    [{0, -1}, {1, 0}, {0, 1}, {-1, 0}].

%%%_* Tests ============================================================
-include_lib("eunit/include/eunit.hrl").

day1_test_() ->
    [ ?_assertEqual(5, solve_part1(parse(<<"R2, L3">>)))
    , ?_assertEqual(4, solve_part2(parse(<<"R8, R4, R4, R8">>)))
    , ?_assertEqual(279, solve_part1())
    , ?_assertEqual(163, solve_part2())
    ].
