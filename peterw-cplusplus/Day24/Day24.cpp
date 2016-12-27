// Advent of Code 2016 - Day 24 part 1 and 2
// Peter Westerström

#include "config.h"
#include <cassert>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <unordered_set>
#include <utility>
#include <array>
#include <deque>
#include <tuple>

using namespace std;

vector<string> readStrings(const string& inputFile)
{
	vector<string> words;
	fstream f(inputFile);

	while (!f.eof())
	{
		string line;
		if (getline(f, line))
		{
			words.push_back(line);
		}
	}
	return words;
}

using Position = pair<int,int>;
using Direction = pair<int, int>;
template <const int w, const int h> using MapWH = array<array<char,w>,h>;

Position operator+(const Position& pos0, const Direction& dir)
{
	return make_pair(pos0.first + dir.first, pos0.second + dir.second);
}

namespace std
{
	template<>
	struct hash<Position>
	{
		size_t operator()(const Position& p) const
		{
			return hash<int>{}(p.first) ^ 117 * hash<int>{}(p.second);
		}
	};
}

struct State
{
	Position position;
	unordered_set<Position> positionsToVisit;

	bool operator==(const State& other) const
	{
		return position == other.position && positionsToVisit == other.positionsToVisit;
	}
};

namespace std
{
	template<>
	struct hash<State>
	{
		size_t operator()(const State& s) const
		{
			auto h = 171 * hash<Position>{}(s.position);
			for (auto pos : s.positionsToVisit)
			{
				h = h ^ hash<Position>{}(pos);
			}
			return h;
		}
	};
}


template <typename Map>
tuple<State, Map> parseMap(const vector<string>& mapLines)
{
	State initialState;
//	Map<177, 45> map;
	Map map;
	assert(mapLines.size() == map.size());
	int y = 0;
	for (auto& row : mapLines)
	{
		assert(row.size() == map[0].size());
		int x = 0;
		for (char c : row)
		{
			if (c == '0')
			{
				initialState.position = make_pair(x, y);
				map[y][x] = '.';
			}
			else if (c >= '1' && c <= '9')
			{
				initialState.positionsToVisit.emplace(x, y);
				map[y][x] = '.';
			}
			else
			{
				map[y][x] = c;
			}
			++x;
		}
		++y;
	}
	return make_tuple(initialState, map);
}

template<typename Map>
int shortestPath(State initialState, const Map& map, bool returnToStart=false)
{
	auto startPosition = initialState.position;
	unordered_set<State> visited;
	deque<pair<int, State>> toTryQueue;
	toTryQueue.push_back(make_pair(0, initialState));
	visited.insert(initialState);
	while (!toTryQueue.empty())
	{
		int steps;
		State currentState;
		tie(steps, currentState) = toTryQueue.front();
		toTryQueue.pop_front();

		if (currentState.positionsToVisit.find(currentState.position) != currentState.positionsToVisit.end())
		{
			currentState.positionsToVisit.erase(currentState.position);
		}
		if (currentState.positionsToVisit.empty()
			&& (!returnToStart || (returnToStart && currentState.position==startPosition)))
		{
			// All positions we wanted to visit is now visited
			return steps;
		}


		const vector<Direction> dirs = { {-1,0}, {1,0}, {0,-1}, {0,1} };
		for (auto dir : dirs)
		{
			auto newPos = currentState.position + dir;
			auto newState = currentState;
			newState.position = newPos;
			if (map[newPos.second][newPos.first] == '.' && visited.find(newState) == visited.end())
			{
				visited.insert(newState);
				toTryQueue.emplace_back(steps + 1, newState);
			}
		}
	}
	return -1; // No solution found
}

#define TEST(x) { if(!(x)) { cerr << "Test Fail!! at line " << __LINE__ << endl;  assert(0); } }
void unitTest()
{
	vector<string> mapLines{
		"###########",
		"#0.1.....2#",
		"#.#######.#",
		"#4.......3#",
		"###########"
	};
	auto initialStateAndMap = parseMap<MapWH<11,5>>(mapLines);
	auto steps = shortestPath(get<0>(initialStateAndMap), get<1>(initialStateAndMap));
	TEST(steps == 14);
}


int main()
{
//	unitTest();

	auto mapLines = readStrings(INPUT_FILE);
	auto initialStateAndMap = parseMap<MapWH<177, 45>>(mapLines);

	// Part1
	auto s1 = shortestPath(get<0>(initialStateAndMap), get<1>(initialStateAndMap), false);
	cout << "Day 24 part 1 answer: " << s1 << endl;

	// Part 2
	auto s2 = shortestPath(get<0>(initialStateAndMap), get<1>(initialStateAndMap), true);
	cout << "Day 24 part 2 answer: " << s2 << endl;

	return 0;
}
