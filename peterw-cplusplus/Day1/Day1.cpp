// Advent of Code 2016 - Day1
// Peter Westerström

#include <fstream>
#include <iostream>
#include <numeric>
#include <regex>
#include <string>

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
		return x+y;
	}

	int x{0};
	int y{0};
};

struct Pose
{
	Direction direction{Direction::North};
	Position position{0,0};
};

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

	static Pose applyMovement(const Movement& movement, const Pose& currentPose) noexcept
	{
		Pose newPose;
		newPose.direction = applyTurn(movement.turn, currentPose.direction);
		newPose.position = applySteps(newPose.direction, movement.stepsForward, currentPose.position);
		return newPose;
	}

	template <typename MovementListT>
	static Pose applyMovements(const MovementListT& movements, const Pose& startPose)
	{
		return accumulate(movements.begin(), movements.end(), startPose,
						  [](const Pose& p, const Movement& m) {
			return Movements::applyMovement(m, p);
		});
	}
};

string input(
	R"rawinput(L4, L1, R4, R1, R1, L3, R5, L5, L2, L3, R2, R1, L4, R5, R4, L2, R1, R3, L5, R1, L3, L2, R5, L4, L5, R1, R2, L1, R5, L3, R2, R2, L1, R5, R2, L1, L1, R2, L1, R1, L2, L2, R4, R3, R2, L3, L188, L3, R2, R54, R1, R1, L2, L4, L3, L2, R3, L1, L1, R3, R5, L1, R5, L1, L1, R2, R4, R4, L5, L4, L1, R2, R4, R5, L2, L3, R5, L5, R1, R5, L2, R4, L2, L1, R4, R3, R4, L4, R3, L4, R78, R2, L3, R188, R2, R3, L2, R2, R3, R1, R5, R1, L1, L1, R4, R2, R1, R5, L1, R4, L4, R2, R5, L2, L5, R4, L3, L2, R1, R1, L5, L4, R1, L5, L1, L5, L1, L4, L3, L5, R4, R5, R2, L5, R5, R5, R4, R2, L1, L2, R3, R5, R5, R5, L2, L1, R4, R3, R1, L4, L2, L3, R2, L3, L5, L2, L2, L1, L2, R5, L2, L2, L3, L1, R1, L4, R2, L4, R3, R5, R3, R4, R1, R5, L3, L5, L5, L3, L2, L1, R3, L4, R3, R2, L1, R3, R1, L2, R4, L3, L3, L3, L1, L2)rawinput"
);

int main()
{
	// Read and parse input string
	auto movements = MovementsParser::parseMovementsStr(input);

	// Apply movements
	auto pose = Movements::applyMovements(movements, Pose());

	// Compute distance
	auto distance = pose.position.distanceFromCenter();
	cout<<"Day 1 part 1 solution: "<<distance<<endl;

	return 0;
}
