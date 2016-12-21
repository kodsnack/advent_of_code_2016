// Advent of Code 2016 - Day 18 part 1 and 2
// Peter Westerström

#include <cassert>
#include <string>
#include <iostream>
#include <vector>

using namespace std;

bool isTrap(char c)
{
	return c == '^';
}

string findNextRow(const string& row)
{
	auto n = row.length();
	string nextRow = row;
	for (decltype(n) i = 0; i < n; ++i)
	{
		char l = i > 0 ? row[i - 1] : '.';
		char c = row[i];
		char r = i < n - 1 ? row[i + 1] : '.';

		bool trap =
			(isTrap(l) && isTrap(c) && !isTrap(r))
			|| (!isTrap(l) && isTrap(c) && isTrap(r))
			|| (isTrap(l) && !isTrap(c) && !isTrap(r))
			|| (!isTrap(l) && !isTrap(c) && isTrap(r));
		nextRow[i] = trap ? '^' : '.';
	}
	return nextRow;
}

int countSafeTiles(const string& firstRow, int rowCount)
{
	if (rowCount < 1)
		return 0;
	auto current = firstRow;
	int safeCount = 0;
	while (rowCount-- > 0)
	{
		for (char c : current)
		{
			if (c == '.')
				safeCount++;
		}
		current = findNextRow(current);
	}
	return safeCount;
}

#define TEST(x) { if(!(x)) { cerr << "Test Fail!! at line " << __LINE__ << endl;  assert(0); } }
void unitTest()
{
	TEST(findNextRow("..^^.") == ".^^^^");
	TEST(findNextRow(".^^^^") == "^^..^");

	TEST(findNextRow(".^^.^.^^^^") == "^^^...^..^");
}

int main()
{
//	unitTest();

	const string input = ".^..^....^....^^.^^.^.^^.^.....^.^..^...^^^^^^.^^^^.^.^^^^^^^.^^^^^..^.^^^.^^..^.^^.^....^.^...^^.^.";

	// Part 1
	auto safeCount1 = countSafeTiles(input, 40);
	cout << "Day 18 part 1 answer: " << safeCount1 << endl;

	// Part 2
	int safeTileCount2 = countSafeTiles(input, 400000);
	cout << "Day 17 part 2 answer: " << safeTileCount2 << endl;

	return 0;
}
