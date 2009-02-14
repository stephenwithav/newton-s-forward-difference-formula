-module(newton).
-author({steven,edwards}).
-vsn(1.0).
-export([solve/1]).

% get powers of X for a function of degree Degree
% returns list, largest first
powers(X, Degree) -> [trunc(math:pow(X, Exp)) || Exp <- lists:seq(Degree, 0, -1)].


% get list of equations
% returns list of equations... [Value = a + b + ...] -> [Value, a, b, ...]
get_equations(Values) -> NumTerms = length(Values), Degree = NumTerms-1, L = [powers(X, Degree) || X <- lists:seq(1, NumTerms) ],
					L2 = lists:zipwith(fun(X, Y) -> [X|Y] end, Values, L), lists:reverse(L2).


% get diff list
% returns list of difference lists
get_diff_list(Terms) -> get_diff_list(Terms, []).

get_diff_list([_], Acc) -> lists:reverse(Acc);
get_diff_list([Bigger|Rest], Acc) -> [Smaller|_] = Rest,
					Diffs = lists:zipwith(fun(X, Y) -> X-Y end, Bigger, Smaller), get_diff_list(Rest,[Diffs|Acc]).


% get all diff lists
% returns list of ^^^ that thing up there
get_all_diffs(Terms) -> get_all_diffs(Terms, []).

get_all_diffs([_], Acc) -> Acc;
get_all_diffs(Terms, Acc) -> DiffList = get_diff_list(Terms), [First|_] = DiffList, get_all_diffs(DiffList, [First|Acc]).


% solve
% returns coefficients for a function f(x) that maps to the given y values.
solve(Values) -> Equations = get_equations(Values), Diffs = get_all_diffs(Equations), Diffs2 = lists:append(Diffs, [lists:last(Equations)]),
					solve(Diffs2, [], 0).

solve([], Coefficients, _) -> Coefficients;
solve([Equation|EqRest], KnownCoefficients, NumKnown) -> [Y|Xs] = Equation, Sum = lists:sum(lists:zipwith(fun(Co, X) -> Co*X end, KnownCoefficients, lists:sublist(Xs, NumKnown))),
					Co = (Y - Sum) div lists:nth(NumKnown+1, Xs), solve(EqRest, lists:append(KnownCoefficients, [Co]), NumKnown+1).
					


% compute

