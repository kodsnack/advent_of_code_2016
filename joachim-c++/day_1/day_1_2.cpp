#include <iostream>
#include <fstream>
#include <regex>

struct Position {
  int x;
  int y;

  bool operator==(const Position &) const;
};

bool Position::operator==(const Position &p) const {
  return x == p.x && y == p.y;
}

struct Direction {
  int dx;
  int dy;

  bool operator==(const Direction &) const;
};

bool Direction::operator==(const Direction &d) const {
  return dx == d.dx && dy == d.dy;
}

struct Instruction {
  std::string turn;
  int steps;
};

std::string readInputFile(const std::ifstream &inputFile) {
  std::stringstream sstr;
  sstr << inputFile.rdbuf();
  return sstr.str();
}

Instruction convertToInstruction(const std::string &entry) {
  std::regex matchPattern("[[:space:]]?([LR])([[:digit:]]+)[[:space:]]?");
  std::smatch match;
  Instruction instruction = {};

  if (std::regex_match(entry, match, matchPattern)) {
    instruction.turn = match[1].str();
    instruction.steps = stoi(match[2].str());    
  } else {
    std::cout << "Failed to parse instruction, entry = " << entry << '\n';
  }
  
  return instruction;
}

std::vector<Instruction> parseInstructions(const std::string &input) {
  std::vector<Instruction> instructions; 
  std::regex splitCriteria(",");
  std::sregex_token_iterator iter(input.begin(), input.end(), splitCriteria, -1);
  std::sregex_token_iterator end;

  for ( ; iter != end; ++iter) {
    auto &entry = *iter;
    instructions.push_back(convertToInstruction(entry));
  }

  return instructions;
}

Direction getNewDirection(const Direction &currentDirection, const Instruction &instruction) {
  Direction newDirection = {};
  
  Direction north = {0, 1};
  Direction east = {1, 0}; 
  Direction south = {0, -1};
  Direction west = {-1, 0};

  if (currentDirection == north) {
    newDirection = instruction.turn == "L" ? west : east;
  } else if (currentDirection == west) {
    newDirection = instruction.turn == "L" ? south : north;
  } else if (currentDirection == south) {
    newDirection = instruction.turn == "L" ? east : west;
  } else if (currentDirection == east) {
    newDirection = instruction.turn == "L" ? north : south;
  }

  return newDirection;
}

int main() {
  std::ifstream inputFile("../day_1/input.txt");
  std::string input = readInputFile(inputFile);
  std::vector<Instruction> instructions = parseInstructions(input);
 
  Direction currentDirection = {0, 1}; 
  Position currentPosition = {0, 0};

  std::vector<Position> visitedLocations;
  visitedLocations.push_back(currentPosition); 
 
  for (const auto& instruction : instructions) {
    currentDirection = getNewDirection(currentDirection, instruction);
    
    for (int i = 0; i < instruction.steps; ++i) {
      currentPosition.x += currentDirection.dx;
      currentPosition.y += currentDirection.dy;

      if (find(visitedLocations.begin(), visitedLocations.end(), currentPosition) != visitedLocations.end()) {
        std::cout << "Position visited twice: x = " << currentPosition.x << " y = " << currentPosition.y << '\n';
        std::cout << "Manhattan norm = " << abs(currentPosition.x) + abs(currentPosition.y) << '\n';
        return 0;
      }
      visitedLocations.push_back(currentPosition); 
    }
  }
  
  return 0;
}    
