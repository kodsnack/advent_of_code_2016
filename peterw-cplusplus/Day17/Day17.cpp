// Advent of Code 2016 - Day 17 part 1 and 2
// Peter Westerström

#include <cassert>
#include <string>
#include <iostream>
#include <tuple>
#include <deque>

extern "C"
{
#include "md5.h"
}

using namespace std;
const int verbose = 0;

string md5FromString(string str)
{
	unsigned char sig[MD5_SIZE];
	char md5str[33];

	md5_t md5;
	md5_init(&md5);
	md5_process(&md5, str.data(), static_cast<unsigned int>(str.length()));
	md5_finish(&md5, sig);

	md5_sig_to_string(sig, md5str, sizeof(md5str));

	return(md5str);
}

string generatePathHash(const string& passcode, const string& steps)
{
	auto r = md5FromString(passcode + steps);
	return r.substr(0, 4);
}

string findPossibleSteps(const string& passcode, const string& steps, int x, int y)
{
	string possibleSteps;
	auto h = generatePathHash(passcode, steps);
	if(y > 0 && (h[0] >= 'b' && h[0] <= 'f'))
		possibleSteps += 'U';
	if(y < 3 && (h[1] >= 'b' && h[1] <= 'f'))
		possibleSteps += 'D';
	if(x > 0 && (h[2] >= 'b' && h[2] <= 'f'))
		possibleSteps += 'L';
	if(x < 3 && (h[3] >= 'b' && h[3] <= 'f'))
		possibleSteps += 'R';
	return possibleSteps;
}

// Find shortest path from 0,0 to 3,3 in a grid of 4x4
string findShortestPath(const string& passcode)
{
	deque<tuple<int, int, string>> d;
	d.push_back(make_tuple(0, 0, string()));
	while(!d.empty())
	{
		auto c = d.front();
		auto x = get<0>(c);
		auto y = get<1>(c);
		auto steps = get<2>(c);
		d.pop_front();

		if(x == 3 && y == 3)
		{
			return steps;
		}

		auto possibleSteps = findPossibleSteps(passcode, steps, x, y);
		for(auto c : possibleSteps)
		{
			switch(c)
			{
				case 'U': d.push_back(make_tuple(x, y - 1, steps + c));	break;
				case 'D': d.push_back(make_tuple(x, y + 1, steps + c)); break;
				case 'L': d.push_back(make_tuple(x - 1, y, steps + c)); break;
				case 'R': d.push_back(make_tuple(x + 1, y, steps + c)); break;
			}
		}
	}
	return ""; // no solution found
}

// Find shortest path from 0,0 to 3,3 in a grid of 4x4
string findLongestPath(const string& passcode)
{
	string longestFoundPath;

	deque<tuple<int, int, string>> d;
	d.push_back(make_tuple(0, 0, string()));
	while(!d.empty())
	{
		auto c = d.front();
		auto x = get<0>(c);
		auto y = get<1>(c);
		auto steps = get<2>(c);
		d.pop_front();

		if(x == 3 && y == 3)
		{
			if(steps.length() > longestFoundPath.length())
				longestFoundPath = steps;
			continue;
		}

		auto possibleSteps = findPossibleSteps(passcode, steps, x, y);
		for(auto c : possibleSteps)
		{
			switch(c)
			{
				case 'U': d.push_back(make_tuple(x, y - 1, steps + c));	break;
				case 'D': d.push_back(make_tuple(x, y + 1, steps + c)); break;
				case 'L': d.push_back(make_tuple(x - 1, y, steps + c)); break;
				case 'R': d.push_back(make_tuple(x + 1, y, steps + c)); break;
			}
		}
	}
	return longestFoundPath;
}


#define TEST(x) { if(!(x)) { cerr << "Test Fail!! at line " << __LINE__ << endl;  assert(0); } }
void unitTest()
{
	TEST(findShortestPath("hijkl") == "");
	TEST(findShortestPath("ihgpwlah") == "DDRRRD");
	TEST(findShortestPath("kglvqrro") == "DDUDRLRRUDRD");
	TEST(findShortestPath("ulqzkmiv") == "DRURDRUDDLLDLUURRDULRLDUUDDDRR");

	TEST(findLongestPath("ihgpwlah").length() == 370);
	TEST(findLongestPath("kglvqrro").length() == 492);
	TEST(findLongestPath("ulqzkmiv").length() == 830);
}

int main()
{
//	unitTest();

	auto r1 = findShortestPath("bwnlcvfs");
	cout << "Day 17 part 1 answer: " << r1 << endl;

	auto r2 = findLongestPath("bwnlcvfs");
	auto r2len = r2.length();
	cout << "Day 17 part 2 answer: " << r2len << endl;

	return 0;
}
