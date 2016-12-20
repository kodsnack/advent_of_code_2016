// Advent of Code 2016 - Day 19 part 1 and 2
// Peter Westerström

#include <cassert>
#include <string>
#include <iostream>
#include <vector>
#include <list>

using namespace std;


int playElephant(int numElves)
{
	vector<int> elves(numElves, 1);

	int elveWithPresent = -1;
	int numElvesWithPresents = 0;
	do
	{
		elveWithPresent = -1;
		numElvesWithPresents = 0;
		for(int i = 0;i < numElves;++i)
		{
			if(elves[i] == 0)
				continue;
			numElvesWithPresents++;
			elveWithPresent = i;

			for(int j = 0;j < numElves - 1;++j)
			{
				auto k = (i + j + 1) % numElves;
				if(elves[k] > 0)
				{
					elves[i] += elves[k];
					elves[k] = 0;
					break;
				}
			}
		}
	} while(numElvesWithPresents > 1);
	return elveWithPresent+1;

}

#define TEST(x) { if(!(x)) { cerr << "Test Fail!! at line " << __LINE__ << endl;  assert(0); } }
void unitTest()
{
	TEST(playElephant(5) == 3);
}


int main()
{
//	unitTest();

	//// Part 1
	auto r1 = playElephant(3014603);
	cout << "Day 19 part 1 answer: " << r1 << endl;

	// Part 2
	//auto r2 = playElephantPart2(3014603);
	//cout << "Day 19 part 2 answer: " << r2 << endl;

	return 0;
}
