// Advent of Code 2016 - Day3 part 1
// Peter Westerström

#include <algorithm>
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
	while (!f.eof())
	{
		int a, b, c;
		f >> a;
		f >> b;
		f >> c;
		if (!f)
		{
			break;
		}
		if (isValidTriangle(a, b, c))
			validCount++;
	}
	return validCount;
}


int main()
{
	auto validCount = readTrianglesAndCountValid(INPUT_FILE);
	cout << "Day 3 part 1 result: " << validCount << endl;
	return 0;
}
