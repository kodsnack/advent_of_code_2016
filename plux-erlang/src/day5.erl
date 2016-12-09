-module(day5).

-compile([export_all]).

solve_part1() ->
    solve(input(), 0, []).

solve_part2() ->
    solve2(input(), 0, []).

input() ->
    "wtnhxymk".

solve(_Str, _N, [_,_,_,_,_,_,_,_] = Password) ->
    lists:reverse(Password);
solve(Str, N, Password) ->
    case calc(Str, N) of
        {true, [C|_]} -> solve(Str, N+1, [C|Password]);
        false         -> solve(Str, N+1, Password)
    end.

solve2(_Str, _N, [_,_,_,_,_,_,_,_] = Password) ->
    [C || {_, C} <- lists:sort(Password)];
solve2(Str, N, Password) ->
    case calc(Str, N) of
        {true, [I,C|_]} ->
            case valid_pos(I, Password) of
                true  -> solve2(Str, N+1, [{I,C}|Password]);
                false -> solve2(Str, N+1, Password)
            end;
        false ->
            solve2(Str, N+1, Password)
    end.

calc(Str, N) ->
    Md5Bin = crypto:hash(md5, Str ++ integer_to_list(N)),
    case Md5Bin of
        <<0,0,_/binary>> ->
            case to_hex(Md5Bin) of
                "00000" ++ S -> {true, S};
                _            -> false
            end;
        _ ->
            false
    end.

valid_pos(I, _Password) when I > $7; I < $0 ->
    false;
valid_pos(I, Password) ->
    not lists:keymember(I, 1, Password).

to_hex(Bin) ->
    [HexChar || <<C:4>> <= Bin, [HexChar] <- io_lib:format("~.16b", [C])].

%%%_* Tests ============================================================
-include_lib("eunit/include/eunit.hrl").

day5_test_() ->
    {timeout, 60, [?_assertEqual("18f47a30", solve("abc", 0, []))]}.

solve_day5_part1_test_() ->
    {timeout, 60, [?_assertEqual("2414bc77", solve_part1())]}.

solve_day5_part2_test_() ->
    {timeout, 60, [?_assertEqual("437e60fc", solve_part2())]}.
