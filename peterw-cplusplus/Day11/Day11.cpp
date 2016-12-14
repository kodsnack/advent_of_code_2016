// Advent of Code 2016 - Day 11 part 1 and 2
// Peter Westerström
//
// Caution: Required to be compiled for 64-bit architecture to be able to solve part 2.

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

using namespace std;

const int verbose = 1;

enum class ItemType
{
	Generator,
	Microchip
};

class Item
{
public:
	Item() {}
	Item(char id, ItemType type)
		: id{id}
		, type{ type }
	{
	}

	bool operator==(const Item& other) const
	{
		return id == other.id && type == other.type;
	}

	char id{' '};
	ItemType type{ ItemType::Generator };

};

bool operator<(const Item& lhs, const Item& rhs)
{
	if (lhs.id < rhs.id)
		return true;
	else if (lhs.id > rhs.id)
		return false;
	else
		return static_cast<int>(lhs.type) < static_cast<int>(rhs.type);
}

class Floor
{
public:
	set<Item> items;

	bool operator==(const Floor& other) const
	{
		return items == other.items;
	}

	set<Item> allMicrochips() const
	{
		set<Item> microchips;
		copy_if(
			items.begin(), items.end(),
			inserter(microchips, microchips.end()),
			[](const Item& item) { return item.type == ItemType::Microchip; });
		return microchips;
	}

	set<Item> allGenerators() const
	{
		set<Item> generators;
		copy_if(
			items.begin(), items.end(),
			inserter(generators, generators.end()),
			[](const Item& item) { return item.type == ItemType::Generator; });
		return generators;
	}
};
static const int floorCount = 4;

class Elevator
{
public:
	int level;
};

class State
{
public:
	array<Floor, floorCount> floors;
	Elevator elevator;

	bool operator==(const State& other) const
	{
		return elevator.level == other.elevator.level && floors == other.floors;
	}
};

namespace std
{
	template<> struct hash<Item>
	{
		size_t operator()(const Item& item) const
		{
			return hash<char>{}(item.id) ^ (hash<int>{}(static_cast<int>(item.type)) * 15);
		}
	};

	template<> struct hash<Floor>
	{
		size_t operator()(const Floor& floor) const
		{
			size_t h{ 0 };
			for (const Item& i : floor.items)
			{
				h = h^hash<Item>{}(i);
			}
			return h;
		}
	};

	template<> struct hash<State>
	{
		size_t operator()(const State& state) const
		{
			size_t h = 17 * hash<int>{}(state.elevator.level);
			for (const Floor& f : state.floors)
			{
				h = (2*h) ^ hash<Floor>{}(f);
			}
			return h;
		}

	};
}


void print(const Item& i)
{
	cout << i.id;
	if (i.type == ItemType::Generator)
	{
		cout << "G";
	}
	if (i.type == ItemType::Microchip)
	{
		cout << "M";
	}
}

void print(const Floor& f)
{
	bool previous = false;
	for (auto& i : f.items)
	{
		if (previous)
		{
			cout << ", ";
		}
		else
		{
			previous = true;
		}
		print(i);
	}
}
void print(const State& s)
{
	for (int l = 0; l < floorCount; l++)
	{
		cout << "F" << (l+1) << "=[";
		if (s.elevator.level == l)
		{
			cout << "E";
			if (!s.floors[l].items.empty())
				cout << ", ";
		}

		print(s.floors[l]);
		cout << "]";
		if(l<floorCount-1)
			cout << ", ";
	}
	cout << endl;
}

/**
 * Check if floor is valid (i.e no chip will burn)
 */
bool isValidFloor(const Floor& floor)
{
	auto generators = floor.allGenerators();
	// If there are any generators in the room, it can burn microchips (if microchip is not paired
	// with corresponding generator)
	if (!generators.empty()) // any generator?
	{
		auto microchips = floor.allMicrochips();
		for (const auto& mc : microchips)
		{
			// For all microchips ensure there is a matching generator, if not chip will burn
			if (generators.find(Item(mc.id, ItemType::Generator)) == generators.end())
			{
				// No matching generator for microchip in the room. The generators in the room
				// will burn this chip.
				return false;
			}
		}
	}
	return true;
}

/**
* Check state is valid (i.e no chip will burn on any level)
*/
bool isValidState(const State& state)
{
	for (auto& floor : state.floors)
	{
		if (!isValidFloor(floor))
			return false;
	}
	return true;
}

/**
 * Final state we want to reach. I.e. all items in the top floor
 */
bool isFinalState(const State& state)
{
	for (int i = 0; i < floorCount - 1; ++i)
	{
		if (!state.floors[i].items.empty())
			return false;
	}
	return true;
}

/**
 * From state generate new state where one item is moved to nextLevel
 * nextLevel must be one above or below state.elevator.level
 */
State moveOne(const State& state, int nextLevel, const Item& item)
{
	int currLevel = state.elevator.level;
	assert(((currLevel + 1) == nextLevel) || ((currLevel- 1) == nextLevel));
	State nextState(state);
	nextState.elevator.level = nextLevel;
	// move item *itemIter up one floor
	nextState.floors[currLevel].items.erase(item);
	nextState.floors[nextLevel].items.insert(item);
	return nextState;
}

/**
 * Generate list of all possible new states when one item is moved one level
 * up or down (to nextLevel).
 */
void allValidMoveOne(const State &state, int nextLevel, vector<State>& nextStates)
{
	int currLevel = state.elevator.level;
	assert(((currLevel + 1) == nextLevel) || ((currLevel - 1) == nextLevel));

	for (auto& item : state.floors[state.elevator.level].items)
	{
		auto nextState = moveOne(state, nextLevel, item);
		if (isValidState(nextState))
		{
			nextStates.push_back(move(nextState));
		}
	}
}

/**
* Generate list of all possible new states when two items is moved one level
* up or down (to nextLevel).
*/
void allValidMoveTwo(const State &state, int nextLevel, vector<State>& nextStates)
{
	int currLevel = state.elevator.level;
	assert(((currLevel + 1) == nextLevel) || ((currLevel - 1) == nextLevel));

	auto& ci = state.floors[state.elevator.level].items;
	for (auto& i=ci.begin();i!=ci.end();++i)
	{
		auto j = i;
		++j;
		for (; j != ci.end(); ++j)
		{
			State nextState{ state };
			nextState.elevator.level = nextLevel;
			nextState.floors[nextLevel].items.insert(*i);
			nextState.floors[nextLevel].items.insert(*j);
			nextState.floors[currLevel].items.erase(*i);
			nextState.floors[currLevel].items.erase(*j);
			if (isValidState(nextState))
			{
				nextStates.push_back(move(nextState));
			}
		}
	}
}

void generateAllValidMovesOneLevelOneDir(
	const State &state,
	int newLevel,
	vector<State>& nextStates)
{
	// Generate state where elevator is moved with 1 item
	allValidMoveOne(state, newLevel, nextStates);
	// Generate state where elevator is moved with 2 items
	allValidMoveTwo(state, newLevel, nextStates);
}

vector<State> generateNextStates(const State& state)
{
	assert(isValidState(state));
	vector<State> nextStates;
	if(state.elevator.level<floorCount-1)
	{
		generateAllValidMovesOneLevelOneDir(
			state,
			state.elevator.level + 1,
			nextStates);

	}
	if (state.elevator.level > 0)
	{
		generateAllValidMovesOneLevelOneDir(
			state,
			state.elevator.level - 1,
			nextStates);

	}
	return nextStates;
}

State startStateExample()
{
	State state0;
	state0.elevator.level = 0;
	state0.floors[0].items.emplace('H', ItemType::Microchip);
	state0.floors[0].items.emplace('L', ItemType::Microchip);
	state0.floors[1].items.emplace('H', ItemType::Generator);
	state0.floors[2].items.emplace('L', ItemType::Generator);
	return state0;
}

/*
The first floor contains a strontium generator, a strontium-compatible microchip, a plutonium generator, and a plutonium-compatible microchip.
The second floor contains a thulium generator, a ruthenium generator, a ruthenium-compatible microchip, a curium generator, and a curium-compatible microchip.
The third floor contains a thulium-compatible microchip.
The fourth floor contains nothing relevant.
*/
State startState()
{

	State state0;
	state0.elevator.level = 0;
	state0.floors[0].items.emplace('S', ItemType::Generator);
	state0.floors[0].items.emplace('S', ItemType::Microchip);
	state0.floors[0].items.emplace('P', ItemType::Generator);
	state0.floors[0].items.emplace('P', ItemType::Microchip);

	state0.floors[1].items.emplace('T', ItemType::Generator);
	state0.floors[1].items.emplace('R', ItemType::Generator);
	state0.floors[1].items.emplace('R', ItemType::Microchip);
	state0.floors[1].items.emplace('C', ItemType::Generator);
	state0.floors[1].items.emplace('C', ItemType::Microchip);

	state0.floors[2].items.emplace('T', ItemType::Microchip);
	assert(isValidState(state0));
	return state0;
}

State startStatePart2()
{
	State state0 = startState();
	state0.floors[0].items.emplace('E', ItemType::Generator);
	state0.floors[0].items.emplace('E', ItemType::Microchip);
	state0.floors[0].items.emplace('D', ItemType::Generator);
	state0.floors[0].items.emplace('D', ItemType::Microchip);
	assert(isValidState(state0));
	return state0;
}

int solve(const State& initialState)
{
	int generation = 0;
	bool finalReached = false;
	vector<State> states;
	unordered_set<State> visited;
	states.push_back(initialState);
	do
	{
		generation++;
		if (verbose)
		{
			cout << "Generation " << generation << endl;
		}
		vector<State> nextStates;
		for (const auto& state : states)
		{
			auto newStates = generateNextStates(state);
			auto slv = find_if(newStates.begin(), newStates.end(),
				[](const State& state) { return isFinalState(state);  });
			if (slv != newStates.end())
			{
				// Final solution.
				if(verbose) print(*slv);
				finalReached = true;
				break;
			}
			for (auto& s : newStates)
			{
				if (visited.find(s) == visited.end())
				{
					visited.insert(s);
					nextStates.push_back(move(s));
				}
			}
//			move(newStates.begin(), newStates.end(), back_inserter(nextStates));
		}
		states = move(nextStates);
	} while (!finalReached);
	return generation;
}

void unit_test_part1()
{
	int numExample = solve(startStateExample());
	assert(numExample == 11);
}

int main()
{
//	unit_test_part1();

   	int numPart1 = solve(startState());
   	cout << "Day 11 part 1 answer: " << numPart1 << endl;;

   	int numPart2 = solve(startStatePart2());
   	cout << "Day 11 part 2 answer: " << numPart2 << endl;;

	return 0;
}
