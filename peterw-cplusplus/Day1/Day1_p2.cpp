// Advent of Code 2016 - Day1 - part 2
// Peter Westerström

#include <fstream>
#include <iostream>
#include <numeric>
#include <regex>
#include <string>
#include <unordered_set>
#include <functional>

using namespace std;

enum class Direction
{
	North, East, South, West
};

enum class Turn
{
	Left, Right
};

struct Movement
{
	Turn turn;
	int stepsForward;
};

struct Position
{
	Position(int x, int y)
		: x{x}, y{y}
	{
	}

	int distanceFromCenter() const
	{
		return (x > 0 ? x : -x) + (y > 0 ? y : -y);
	}

	int x{0};
	int y{0};
};

bool operator==(const Position& p1, const Position& p2)
{
	return p1.x == p2.x && p1.y == p2.y;
}

struct Pose
{
	Direction direction{Direction::North};
	Position position{0,0};
};

namespace std
{
	template<>
	struct hash<Position>
	{
		size_t operator()(const Position& p) const
		{
			return hash<int>()(p.x) ^ hash<int>()(p.y);
		}
	};

}

class MovementsParser
{
public:
	static Movement parseMovementFromString(string instruction)
	{
		Movement movement;
		regex rgx("[[:space:]]*([RL])([0-9]+)[[:space:]]*");
		std::smatch m;
		if(regex_match(instruction, m, rgx))
		{
			auto turnStr = m[1].str();
			if(turnStr=="L")
				movement.turn = Turn::Left;
			else if(turnStr=="R")
				movement.turn = Turn::Right;
			auto stepsStr = m[2].str();
			movement.stepsForward = atoi(stepsStr.c_str());
		} else
		{
			throw-1;
		}
		return movement;
	}

	static vector<Movement> parseMovementsStr(string movementsStr)
	{
		vector<Movement> movements;

		regex splitRegex(",");
		sregex_token_iterator iter(movementsStr.begin(),
								   movementsStr.end(),
								   splitRegex,
								   -1);
		std::sregex_token_iterator end;
		for(; iter!=end; ++iter)
		{
			auto entry = *iter;
			movements.push_back(parseMovementFromString(entry));
		}
		return movements;
	}

	static vector<Movement> parseMovementsFile(string file)
	{
		fstream f(file);
		string input((istreambuf_iterator<char>(f)), istreambuf_iterator<char>());
		return parseMovementsStr(input);
	}

};

class Movements
{
public:
	static Direction applyTurn(Turn turn, Direction currentDirection) noexcept
	{
		if(turn==Turn::Left)
		{
			switch(currentDirection)
			{
				case Direction::North:
					return Direction::West;
				case Direction::East:
					return Direction::North;
				case Direction::South:
					return Direction::East;
				case Direction::West:
					return Direction::South;
			}
		} else // if(turn==Turn::Right)
		{
			switch(currentDirection)
			{
				case Direction::North:
					return Direction::East;
				case Direction::East:
					return Direction::South;
				case Direction::South:
					return Direction::West;
				case Direction::West:
					return Direction::North;
			}
		}
		return currentDirection;
	}

	static Position applySteps(Direction direction, int steps, const Position& currentPos) noexcept
	{
		switch(direction)
		{
			case Direction::North:
				return Position(currentPos.x, currentPos.y+steps);
			case Direction::East:
				return Position(currentPos.x+steps, currentPos.y);
			case Direction::South:
				return Position(currentPos.x, currentPos.y-steps);
			case Direction::West:
				return Position(currentPos.x-steps, currentPos.y);
			default:
				return currentPos;
		}
	}

	/// Apply movement and return new pose. Second bool is true if walk was stopped by visit function.
	static pair<Pose,bool> applyMovement(
		const Movement& movement,
		const Pose& currentPose,
		function<bool(const Position&)> visitFcn //< Visit function. Stop walking if it returns true
	) noexcept
	{
		Pose newPose;
		newPose.direction = applyTurn(movement.turn, currentPose.direction);
		newPose.position = currentPose.position;
		for (int i = 0; i < movement.stepsForward; ++i)
		{
			newPose.position = applySteps(newPose.direction, 1, newPose.position);
			if(visitFcn(newPose.position))
			{
				return pair<Pose, bool>(newPose, true);
			}
		}
		return pair<Pose, bool>(newPose, false);
	}

	template <typename MovementListT>
	static Position applyMovementsAndFindDuplicatePos(const MovementListT& movements, const Pose& startPose)
	{
		unordered_set<Position> visitedPositions;
		visitedPositions.insert(startPose.position);

		Pose currentPose{ startPose };
		for (auto& movement : movements)
		{
			bool visited;
			tie(currentPose,visited) = Movements::applyMovement(movement, currentPose,
				[&visitedPositions](const Position& p) {
				if (visitedPositions.find(p) != visitedPositions.end())
				{
					return true;
				}
				visitedPositions.insert(p);
				return false;
			});
			if (visited)
				return currentPose.position;
		}
		throw runtime_error("No solution");
	}
};

//string test_input = R"(R8, R4, R4, R8)";

string input(
	R"rawinput(L4, L1, R4, R1, R1, L3, R5, L5, L2, L3, R2, R1, L4, R5, R4, L2, R1, R3, L5, R1, L3, L2, R5, L4, L5, R1, R2, L1, R5, L3, R2, R2, L1, R5, R2, L1, L1, R2, L1, R1, L2, L2, R4, R3, R2, L3, L188, L3, R2, R54, R1, R1, L2, L4, L3, L2, R3, L1, L1, R3, R5, L1, R5, L1, L1, R2, R4, R4, L5, L4, L1, R2, R4, R5, L2, L3, R5, L5, R1, R5, L2, R4, L2, L1, R4, R3, R4, L4, R3, L4, R78, R2, L3, R188, R2, R3, L2, R2, R3, R1, R5, R1, L1, L1, R4, R2, R1, R5, L1, R4, L4, R2, R5, L2, L5, R4, L3, L2, R1, R1, L5, L4, R1, L5, L1, L5, L1, L4, L3, L5, R4, R5, R2, L5, R5, R5, R4, R2, L1, L2, R3, R5, R5, R5, L2, L1, R4, R3, R1, L4, L2, L3, R2, L3, L5, L2, L2, L1, L2, R5, L2, L2, L3, L1, R1, L4, R2, L4, R3, R5, R3, R4, R1, R5, L3, L5, L5, L3, L2, L1, R3, L4, R3, R2, L1, R3, R1, L2, R4, L3, L3, L3, L1, L2)rawinput"
);

int main()
{
	// Read and parse input string
	auto movements = MovementsParser::parseMovementsStr(input);

	try
	{
		// Apply movements
		auto pos = Movements::applyMovementsAndFindDuplicatePos(movements, Pose());

		// Compute distance
		auto distance = pos.distanceFromCenter();
		cout << "Day 1 part 2 solution: " << distance << endl;
	} catch (const std::exception&)
	{
		cout << "No solution found :(" << endl;
	}

	return 0;
}
