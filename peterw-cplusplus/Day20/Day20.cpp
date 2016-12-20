// Advent of Code 2016 - Day 20 part 1 and 2
// Peter Westerström

#include "config.h"
#include <numeric>
#include <cassert>
#include <iostream>
#include <fstream>
#include <vector>
#include <list>

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

template<typename T>
struct RangeT
{
	RangeT(T lower, T upper)
		: lower{lower}
		, upper{upper}
	{
		assert(lower <= upper);
	}

	T lower{0};
	T upper{0};

	T size() const
	{
		return upper+1-lower;
	}

	// -1 if below
	// 1 if above
	// 0 if inside
	int pointInRange(T p) const
	{
		if(p<lower)
			return -1;
		if(p>=lower && p<=upper)
			return 0;
		return 1;
	}
};

typedef RangeT<uint32_t> Range;

vector<Range> rangeMinus(const Range& first, const Range& second)
{
	vector<Range> r;

	if(second.upper<first.lower||second.lower>first.upper)
	{
		r.push_back(first);
		return r;
	}

	//  first   |    |
	//  second   |  |
	if(second.lower>first.lower && second.upper<first.upper)
	{
		// split
		r.push_back(Range(first.lower, second.lower-1));
		r.push_back(Range(second.upper+1, first.upper));
		return r;
	}

	//  first   |    |          |   |      |   |     |  |
	//  second |      |  or     |   | or |     | or  |   |
	if(second.lower<=first.lower && second.upper>=first.upper)
	{
		return r; // nothing left
	}


	//  first   |     |
	//  second |    |
	if(second.lower<=first.lower)
	{
		r.push_back(Range(second.upper+1, first.upper));
		return r;
	}

	//  first  |     |
	//  second   |    |
	if(second.upper>=first.upper)
	{
		r.push_back(Range(first.lower, second.lower-1));
		return r;
	}
	assert(0);
	throw-1;
}

void removeRangeFromAllowedList(
	list<Range>& allowedList,
	const Range& blockRange)

{
	for(auto iter = allowedList.begin();iter!=allowedList.end();)
	{
		auto allowRange = *iter;
		if(blockRange.upper<allowRange.lower)
		{
			break;
		}
		if(blockRange.lower>allowRange.upper)
		{
			++iter;
			continue;
		}

		auto rng = rangeMinus(allowRange, blockRange);
		for(auto r:rng)
		{
			allowedList.insert(iter, r);
		}
		iter = allowedList.erase(iter);
	}
}

vector<Range> readAndParseInput()
{
	vector<Range> blockedList;
	auto rangesText = readStrings(INPUT_FILE);
	for(auto& r:rangesText)
	{
		auto splitIndex = r.find('-');
		auto lowerAddress = r.substr(0, splitIndex);
		auto upperAddress = r.substr(splitIndex+1);
		char *p;
		auto l = strtoul(lowerAddress.c_str(), &p, 10);
		auto u = strtoul(upperAddress.c_str(), &p, 10);
		assert(l<=u);
		blockedList.emplace_back(l, u);
	}
	return blockedList;
}

list<Range> computeAllowedList(const Range& allowedRange, const vector<Range>& blockedList)
{
	list<Range> allowedList;
	allowedList.push_back(allowedRange);
	for(auto b:blockedList)
	{
		removeRangeFromAllowedList(allowedList, b);
	}
	return allowedList;
}

decltype(Range::lower) lowestAllowed(const list<Range>& allowedList)
{
	if(allowedList.empty())
		throw runtime_error("No solution");
	auto lowestAllowedValue = allowedList.begin()->lower;
	return lowestAllowedValue;
}

decltype(Range::lower) allowedCount(const list<Range>& allowedList)
{
	return accumulate(allowedList.begin(), allowedList.end(), 0UL,
			   [](decltype(Range::lower) acc, const Range& r)
	{
		return acc+r.size();
	});
}


#define TEST(x) { if(!(x)) { cerr << "Test Fail!! at line " << __LINE__ << endl;  assert(0); } }
void unitTest()
{
	vector<Range> blockedList{
		{5,8},
		{0,2},
		{4,7}
	};
	auto al = computeAllowedList(Range{0,9}, blockedList);
	auto l = lowestAllowed(al);
	TEST(l==3);

	auto n = allowedCount(al);
	TEST(n==2);
}


int main()
{
	unitTest();

	auto blockedList = readAndParseInput();
	auto allowedList = computeAllowedList(Range{0U, 4294967295U}, blockedList);

	auto r1 = lowestAllowed(allowedList);
	cout << "Day 20 part 1 answer: " << r1 << endl;

	auto r2 = allowedCount(allowedList);
	cout << "Day 20 part 2 answer: " << r2 << endl;

	return 0;
}
