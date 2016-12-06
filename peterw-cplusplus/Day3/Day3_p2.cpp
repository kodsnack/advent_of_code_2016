// Advent of Code 2016 - Day3 part 2
// Peter Westerström

#include <algorithm>
#include <cassert>
#include <fstream>
#include <iostream>
#include <string>

#include "config.h"

using namespace std;

bool isValidTriangle(const int a, const int b, const int c)
{
	auto longestSide = max(max(a, b), c);
	auto sumShortestAndMedium = a + b + c - longestSide;
	return(sumShortestAndMedium > longestSide);
}

int readTrianglesAndCountValid(string trianglesFile)
{
	fstream f(trianglesFile);

	int validCount{ 0 };
	while (f.good())
	{
		int n[9];
		for (int i = 0; i < 9; ++i)
		{
			if (!(f >> n[i]))
			{
				return validCount;
			}
		}
		for (int c = 0; c < 3; c++)
		{
			if (isValidTriangle(n[0+c], n[3+c], n[6+c]))
				validCount++;
		}
	}
	return validCount;
}


int main()
{
	auto validCount = readTrianglesAndCountValid(INPUT_FILE);
	cout << "Day 3 part 2 result: " << validCount << endl;
	return 0;
}
