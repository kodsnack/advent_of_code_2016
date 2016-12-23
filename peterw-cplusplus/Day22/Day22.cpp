// Advent of Code 2016 - Day 22 part 1 and 2
// Peter Westerström

#include "config.h"
#include <cassert>
#include <iostream>
#include <fstream>
#include <vector>
#include <regex>
#include <tuple>
#include <array>
#include <unordered_set>
#include <utility>
#include <deque>

using namespace std;
int verbose = 0;

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
vector<tuple<int, int, int, int>> parseDfLines(vector<string> dflines)
{
	vector<tuple<int, int, int, int>> nodes;
	regex rgx{"\\/dev\\/grid/node\\-x(\\d+)\\-y(\\d+)\\s+(\\d+)T\\s+(\\d+)T\\s+(\\d+)T\\s+(\\d+).*"};
	for(auto& line:dflines)
	{
		smatch m;
		if(regex_match(line, m, rgx))
		{
			int x = atoi(m[1].str().c_str());
			int y = atoi(m[2].str().c_str());
			int totsize = atoi(m[3].str().c_str());
			int used = atoi(m[4].str().c_str());
			int avail = atoi(m[5].str().c_str());
			nodes.push_back(make_tuple(x, y, used, avail));
		}
	}
	return nodes;
}

// tuple x,y,used,avail
int countViablePairs(vector<tuple<int, int, int, int>>& nodes)
{
	int viableCount = 0;

	for(auto& a:nodes)
	{
		for(auto& b:nodes)
		{
			if(&a!=&b && get<2>(a)!=0&&get<2>(a)<=get<3>(b))
			{
				viableCount++;
			}
		}
	}
	return viableCount;
}

struct Node
{

};

typedef array<array<char, 30>, 35> NodeMatrix;
typedef array<array<char, 3>, 3> NodeMatrixTest;

template<typename NodeMatrixType>
void printMatrix(const NodeMatrixType& m)
{
	for(auto& row:m)
	{
		for(auto& n:row)
		{
			cout << n;
			cout << ' ';
		}
		cout << endl;
	}
}

struct State
{
	State(int emptyX, int emptyY, int goalX, int goalY)
		: emptyX{emptyX}
		, emptyY{emptyY}
		, goalX{goalX}
		, goalY{goalY}
	{
	}

	size_t getHash() const
	{
		auto intHasher = std::hash<int>{};
		return intHasher(emptyX) ^ intHasher(emptyY) ^	intHasher(goalX)^intHasher(goalY);
	}

	bool operator==(const State& other) const
	{
		return emptyX == other.emptyX &&
			emptyY == other.emptyY &&
			goalX == other.goalX &&
			goalY == other.goalY;
	}

	int emptyX, emptyY;
	int goalX, goalY;
};
struct StateHash
{
	size_t operator()(const State& s) const
	{
		return s.getHash();
	}
};

template<typename NodeMatrixType>
void printMatrixWithState(const NodeMatrixType& m, const State& s)
{
	for(int y=0;y<m.size();++y)
	{
		auto& row = m[y];
		for(int x=0;x<row.size();++x)
		{
			if(x==s.emptyX && y==s.emptyY)
			{
				cout << '_';
			} else if(x==s.goalX && y==s.goalY)
			{
				cout << 'G';
			} else
			{
				cout << row[x];
			}
			cout<<' ';
		}
		cout<<endl;
	}
}


template <typename NodeMatrixType, const int toLargeThreshold>
int minSteps(vector<tuple<int, int, int, int>> nodes)
{
	int maxX{0}, maxY{0};
	for(auto& n:nodes)
	{
		maxX = max(maxX, get<0>(n));
		maxY = max(maxY, get<1>(n));
	}
	// We have hard coded the grid dimensions. Ensure input has that size
	NodeMatrixType matrix;
	assert(maxY+1 == matrix.size());
	assert(maxX+1==matrix[0].size());


	int emptyX{-1}, emptyY{-1};
	int goalX = maxX, goalY{0};
	for(auto& n:nodes)
	{
		int x = get<0>(n);
		int y = get<1>(n);
		int used = get<2>(n);
		int avail = get<3>(n);
		if((used+avail)>toLargeThreshold)
		{
			matrix[y][x] = '#';
		} else if(used==0)
		{
			matrix[y][x] = '.';
			emptyX = x;
			emptyY = y;
		} else
		{
			matrix[y][x] = '.';
		}
	}
	auto isFull = [&matrix](int x, int y) { return matrix[y][x] == '#'; };

	State initialState(emptyX, emptyY, goalX, goalY);
	unordered_set<State, StateHash> visited;
	deque<tuple<int,State>> tryList;
	tryList.push_back(make_tuple(0,initialState));
	visited.insert(initialState);
	if(verbose)
	{
		cout<<"Initial state:"<<endl;
		printMatrixWithState(matrix, initialState);
	}
	while(!tryList.empty())
	{
		auto current = tryList.front();
		tryList.pop_front();
		auto steps = get<0>(current);
		auto state = get<1>(current);

		if(state.goalX==0&&state.goalY==0)
		{
			// Solution found
			if(verbose)
			{
				cout << "Final goal state:" << endl;
				printMatrixWithState(matrix, state);
			}
			return steps;
		}

		// Generate possible steps

		const static vector<pair<int,int>> dirs { {-1,0}, {1,0}, {0,-1}, {0,1} };
		for(auto d : dirs)
		{
			int x = state.emptyX+d.first;
			int y = state.emptyY+d.second;
			if(x>=0&&x<=maxX && y>=0&&y<=maxY && !isFull(x, y))
			{
				int newGoalX{state.goalX};
				int newGoalY{state.goalY};
				if(state.goalX==x && state.goalY==y)
				{
					newGoalX = state.emptyX;
					newGoalY = state.emptyY;
				}
				auto s = State{x, y, newGoalX, newGoalY};
				if(visited.find(s)==visited.end())
				{
					visited.insert(s);
					tryList.emplace_back(steps+1, s);
				}
			}
		}

	}
	return -1; // No solution found
}


#define TEST(x) { if(!(x)) { cerr << "Test Fail!! at line " << __LINE__ << endl;  assert(0); } }
void unitTest()
{
	// part 2
	vector<string> testArray{
		"Filesystem            Size  Used  Avail  Use%",
		"/dev/grid/node-x0-y0   10T    8T     2T   80%",
		"/dev/grid/node-x0-y1   11T    6T     5T   54%",
		"/dev/grid/node-x0-y2   32T   28T     4T   87%",
		"/dev/grid/node-x1-y0    9T    7T     2T   77%",
		"/dev/grid/node-x1-y1    8T    0T     8T    0%",
		"/dev/grid/node-x1-y2   11T    7T     4T   63%",
		"/dev/grid/node-x2-y0   10T    6T     4T   60%",
		"/dev/grid/node-x2-y1    9T    8T     1T   88%",
		"/dev/grid/node-x2-y2    9T    6T     3T   66%"
	};
	auto testNodes = parseDfLines(testArray);
	TEST(testNodes.size()==9);
	int maxX{0}, maxY{0};
	for(auto& n:testNodes)
	{
		maxX = max(maxX, get<0>(n));
		maxY = max(maxY, get<1>(n));
	}
	TEST(maxX==2);
	TEST(maxY==2);


	auto r = minSteps<NodeMatrixTest, 20>(testNodes);
	TEST(r==7);
}


int main()
{
//	unitTest(); return 0;

	auto lines = readStrings(INPUT_FILE);
	auto nodes = parseDfLines(lines);
	assert(lines.size()==nodes.size()+2);

	// Part 1
	auto numberOfViableNodes = countViablePairs(nodes);
	cout<<"Day 22 part 1 answer: "<<numberOfViableNodes<<endl;

	// Part 2
	auto r2 = minSteps<NodeMatrix, 100>(nodes);
	cout << "Day 22 part 2 answer: " << r2 << endl;

	return 0;
}
