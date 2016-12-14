// Advent of Code 2016 - Day 13 part 1 and 2
// Peter Westerström

#include <algorithm>
#include <array>
#include <cassert>
#include <functional>
#include <iostream>
#include <iterator>
#include <set>
#include <string>
#include <unordered_set>
#include <utility>
#include <vector>
#include <queue>

using namespace std;

struct Position
{
	Position() : x{ 0 }, y{ 0 } {}
	Position(int x, int y)
		: x{ x }
		, y{ y }
	{
	}

	bool operator==(const Position& other) const
	{
		return x == other.x && y == other.y;
	}

	int x;
	int y;
};

namespace std
{
	template <>
	struct hash<Position>
	{
		size_t operator()(const Position& p) const
		{
			return hash<int>{}(p.x) ^ (67 * hash<int>{}(p.y));
		}
	};
}

bool isWall(int seed, Position pos)
{
	int x = pos.x;
	int y = pos.y;
	auto z = x*x + 3 * x + 2 * x*y + y + y*y + seed;
	int numBits = 0;
	int odd = 0;
	while (z != 0)
	{
		odd = odd ^ (z & 1);
		z = z >> 1;
	}
	return odd?true:false;
}

bool isOpenSpace(int seed, Position p)
{
	return !isWall(seed, p);
}

typedef unordered_set<Position> PositionSet;

vector<Position> generatePossibleMovesFrom(int seed, const Position& pos)
{
	vector<Position> possibleMoves;
	possibleMoves.reserve(4);

	if (pos.x > 0)
	{
		Position left{ pos.x - 1, pos.y };
		if (isOpenSpace(seed, left))
		{
			possibleMoves.push_back(left);
		}
	}

	if (pos.y > 0)
	{
		Position up{ pos.x, pos.y -1 };
		if (isOpenSpace(seed, up))
		{
			possibleMoves.push_back(up);
		}
	}

	Position right{ pos.x+1, pos.y };
	if (isOpenSpace(seed, right))
	{
		possibleMoves.push_back(right);
	}

	Position down{ pos.x, pos.y +1};
	if (isOpenSpace(seed, down))
	{
		possibleMoves.push_back(down);
	}

	return possibleMoves;
}


int findShortestPath(
	int seed,
	const Position& startPos,
	const Position& targetPos)
{
	PositionSet visited{ startPos };

	int steps = 0;
	bool targetReached = false;
	PositionSet currentGeneration{ startPos };
	do
	{
		PositionSet nextGeneration;
		for (auto& pos : currentGeneration)
		{
			auto possibleMoves = generatePossibleMovesFrom(seed, pos);
			if (find(possibleMoves.begin(), possibleMoves.end(),targetPos) != possibleMoves.end())
			{
				targetReached = true;
				break;
			}
			copy_if(
				possibleMoves.begin(), possibleMoves.end(),
				inserter(nextGeneration, nextGeneration.end()),
				[&visited](const Position& pos) { return visited.find(pos) == visited.end(); }
			);
		}
		copy(nextGeneration.begin(), nextGeneration.end(), inserter(visited, visited.end()));
		currentGeneration = move(nextGeneration);
		steps++;
	} while (!targetReached);

	return steps;
}

void unitTest()
{
	const int seed = 10;
	const Position startPos{ 1,1 };
	const Position targetPos{ 7,4 };
	auto steps = findShortestPath(seed, startPos, targetPos);
	assert(steps == 11);
}

// Part 2 types and functions

struct State
{
	State() {}
	State(const Position& pos)
		: position{ pos }
	{
	}
	State(int steps, const Position& pos)
		: steps{ steps }
		, position{ pos	}
	{
	}

	int steps{ 0 };
	Position position;

	bool operator==(const State& other) const
	{
		return steps == other.steps && position == other.position;
	}
};
namespace std
{
	template <>
	struct hash<State>
	{
		size_t operator()(const State& s) const
		{
			auto h = hash<Position>{}(s.position);
			h = h ^ ( 617 * hash<int>{}(s.steps) );
			return h;
		}
	};
};


int positionsReachableInMaxSteps(
	int seed,
	const Position& startPos,
	int maxSteps)
{
	queue<State> pathsToTry;
	pathsToTry.push(State{ 0, startPos });
	PositionSet visited{ startPos };
	while (!pathsToTry.empty())
	{
		auto currentState = pathsToTry.front();
		pathsToTry.pop();
		auto possibleMoves = generatePossibleMovesFrom(seed, currentState.position);
		for (auto& pos : possibleMoves)
		{
			State s{ currentState.steps + 1, pos };
			if (visited.find(pos) == visited.end())
			{
				if (s.steps <= maxSteps)
				{
					pathsToTry.push(s);
					visited.insert(pos);
				}
			}
		}
	}

	return static_cast<int>(visited.size());
}

// -----

int main()
{
//	unitTest();

	const int seed = 1350;
	const Position startPos{ 1,1 };
	const Position targetPos{ 31,39 };
	auto minSteps = findShortestPath(seed, startPos, targetPos);
	cout << "Day 13 part 1 answer: " << minSteps << endl;

	auto maxPositions = positionsReachableInMaxSteps(seed, startPos, 50);
	cout << "Day 13 part 2 answer: " << maxPositions << endl;;

	return 0;
}
