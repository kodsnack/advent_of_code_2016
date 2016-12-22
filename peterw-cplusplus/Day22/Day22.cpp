// Advent of Code 2016 - Day 22 part 1 and 2
// Peter Westerström

#include "config.h"
#include <cassert>
#include <iostream>
#include <fstream>
#include <vector>
#include <regex>
#include <tuple>

using namespace std;

vector<string> readStrings(const string& inputFile)
{
	vector<string> words;
	fstream f(inputFile);

	while(!f.eof())
	{
		string line;
		if(getline(f, line))
		{
			words.push_back(line);
		}
	}
	return words;
}


// tuple x,y,used,avail
vector<tuple<int,int,int,int>> parseDfLines(vector<string> dflines)
{
	vector<tuple<int,int,int,int>> nodes;
	regex rgx{"\\/dev\\/grid/node\\-x(\\d+)\\-y(\\d+)\\s+(\\d+)T\\s+(\\d+)T\\s+(\\d+)T\\s+(\\d+).*"};
	for(auto& line : dflines)
	{
		smatch m;
		if(regex_match(line, m, rgx))
		{
			int x = atoi(m[1].str().c_str());
			int y = atoi(m[2].str().c_str());
			int totsize = atoi(m[3].str().c_str());
			int used = atoi(m[4].str().c_str());
			int avail = atoi(m[5].str().c_str());
			nodes.push_back(make_tuple(x,y,used,avail));
		}
	}
	return nodes;
}

// tuple x,y,used,avail
int countViablePairs(vector<tuple<int,int,int,int>>& nodes)
{
	int viableCount = 0;

	for(auto& a:nodes)
	{
		for(auto& b:nodes)
		{
			if(&a!=&b && get<2>(a)!=0 && get<2>(a)<=get<3>(b))
			{
				viableCount++;
			}
		}
	}
	return viableCount;
}

#define TEST(x) { if(!(x)) { cerr << "Test Fail!! at line " << __LINE__ << endl;  assert(0); } }
void unitTest()
{
}


int main()
{
	unitTest();

	auto lines = readStrings(INPUT_FILE);
	auto nodes = parseDfLines(lines);
	assert(lines.size()==nodes.size()+2);


	// Part 1
	auto numberOfViableNodes = countViablePairs(nodes);
	cout << "Day 22 part 1 answer: " << numberOfViableNodes << endl;

	// Part 2
//	cout << "Day 22 part 2 answer: " << text2 << endl;

	return 0;
}
