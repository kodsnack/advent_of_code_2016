-module(day7).

-compile([export_all]).

solve_part1() ->
    {ok, Input} = file:read_file("input/day7"),
    solve(split_lines(Input), fun is_tls/1).

solve_part2() ->
    {ok, Input} = file:read_file("input/day7"),
    solve(split_lines(Input), fun is_ssl/1).

split_lines(Bin) ->
    [Line || Line <- string:tokens(binary_to_list(Bin), "\n")].

solve(Lines, CheckFun) ->
    length([Line || Line <- Lines, CheckFun(collect(Line))]).

is_tls({In, Out}) ->
    (not lists:any(fun is_abba/1, In)) andalso lists:any(fun is_abba/1, Out).

is_ssl({In, Out}) ->
    [] =/= [Aba || O <- Out, Aba <- abas(O), I <- In, is_bab(I, Aba)].

collect(Line) ->
    collect(Line, [], [], []).

collect([], Curr, In, Out)     -> {In, [Curr|Out]};
collect([$[|T], Curr, In, Out) -> collect(T, [], In, [Curr|Out]);
collect([$]|T], Curr, In, Out) -> collect(T, [], [Curr|In], Out);
collect([H|T], Curr, In, Out)  -> collect(T, [H|Curr], In, Out).

is_abba([])                        -> false;
is_abba([A,B,B,A|_X]) when A =/= B -> true;
is_abba([_|T])                     -> is_abba(T).

abas([])                     -> [];
abas([A,B,A|T]) when A =/= B -> [[A,B,A]|abas([B,A|T])];
abas([_|T])                  -> abas(T).

is_bab([], _)              -> false;
is_bab([B,A,B|_], [A,B,A]) -> true;
is_bab([_|T], Bab)         -> is_bab(T, Bab).

%%%_* Tests ============================================================
-include_lib("eunit/include/eunit.hrl").

part1_test_() ->
    Example = [ "abba[mnop]qrst"
              , "abcd[bddb]xyyx"
              , "aaaa[qwer]tyui"
              , "ioxxoj[asdfgh]zxcvbn"
              ],
    [ ?_assertEqual(2, solve(Example, fun is_tls/1))
    , ?_assertEqual(105, solve_part1())
    ].

part2_test_() ->
    Example = [ "aba[bab]xyz"
              , "xyx[xyx]xyx"
              , "aaa[kek]eke"
              , "zazbz[bzb]cdb"
              ],
    [ ?_assertEqual(3, solve(Example, fun is_ssl/1))
    , ?_assertEqual(258, solve_part2())
    ].
