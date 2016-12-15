// Advent of Code 2016 - Day 15 part 1 and 2
// Peter Westerström

#include "config.h"
#include <iostream>
#include <vector>
#include <tuple>

using namespace std;

// Disc #1 has 17 positions; at time = 0, it is at position 5.
// Disc #2 has 19 positions; at time = 0, it is at position 8.
// Disc #3 has 7 positions; at time = 0, it is at position 1.
// Disc #4 has 13 positions; at time = 0, it is at position 7.
// Disc #5 has 5 positions; at time = 0, it is at position 1.
// Disc #6 has 3 positions; at time = 0, it is at position 0.
vector<tuple<int, int>> discs {
	{17,5},
	{19,8},
	{7,1},
	{13,7},
	{5,1},
	{3,0}
};

int solve()
{
	int t0 = 0;
	while (t0 < numeric_limits<decltype(t0)>::max())
	{
		bool allAtZero = true;
		int t = t0 + 1;
		for (const auto& d : discs)
		{
			int n = get<0>(d);
			int p = get<1>(d);
			if (((p + t) % n) != 0)
			{
				allAtZero = false;
				break;
			}
			t++;
		}
		if (allAtZero)
		{
			return t0;
		}
		++t0;
	}
	throw runtime_error("No solution found");
}

int main()
{
	auto t1 = solve();
	cout << "Day 15 part 1 answer: " << t1 << endl;

	discs.emplace_back(11, 0);
	auto t2 = solve();
	cout << "Day 15 part 2 answer: " << t2 << endl;

	return 0;
}
