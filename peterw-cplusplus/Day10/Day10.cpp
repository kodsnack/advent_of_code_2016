// Advent of Code 2016 - Day 10 part 1 and 2
// Peter Westerström

#include "config.h"
#include <cassert>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <iterator>
#include <memory>
#include <regex>
#include <string>
#include <vector>
#include <unordered_set>

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

enum class GiveType
{
	Unspecified,
	Bot,
	Output
};

struct GiveSpec
{
	GiveSpec()
		: type(GiveType::Unspecified), value{-1}
	{
	}
	GiveSpec(GiveType type, int value)
		: type{ type }
		, value{ value }
	{
	}

	GiveType type;
	int value;

	bool isNull() const { return type == GiveType::Unspecified; }
};

struct Instruction
{
	int bot{ -1 };
	GiveSpec lowGive;
	GiveSpec highGive;
};

class Environment;

class Bot
{
public:
	Environment& env;
	Bot(Environment& env) : env{ env }
	{
	}

	void giveChip(int chipId);

	// Bot program
	int lowValue{ -1 };
	int highValue{ -1 };

};

GiveType giveTypeFromString(const string& t)
{
	if (t == "output")
		return GiveType::Output;
	else if (t == "bot")
		return GiveType::Bot;
	else
		throw runtime_error("Illegal give type");
}

class Environment
{
public:
	Bot& getBotByValue(int value)
	{
		if (value >= bots.size())
		{
			bots.resize(value+1, Bot(*this));
			return bots[value];
		}
		else
		{
			return bots[value];
		}
	}

	unordered_set<int>& getOutput(int index)
	{
		if(index >= outputs.size())
		{
			outputs.resize(index + 1);
		}
		return outputs[index];
	}


	vector<Bot> bots;
	vector<unordered_set<int>> outputs;
};


void Bot::giveChip(int chipId)
{
	if (lowValue == -1)
	{
		lowValue = chipId;
	}
	else if (highValue == -1)
	{
		if (chipId > lowValue)
		{
			highValue = chipId;
		}
		else
		{
			highValue = lowValue;
			lowValue = chipId;
		}
	}
	else
	{
		throw runtime_error("full");
	}
}

vector<Instruction> parseBotInstructions(Environment& env, vector<string>& instructionsAsText)
{
	vector<Instruction> instructions;
	regex r1("value (\\d+) goes to bot (\\d+)");
	regex r2("bot (\\d+) gives low to (output|bot) (\\d+) and high to (output|bot) (\\d+)");

	for (auto& i : instructionsAsText)
	{
		smatch m;
		if (regex_match(i, m, r1))
		{
			// Give chip to a bot
			int chipVal = atoi(m[1].str().c_str());
			int botVal = atoi(m[2].str().c_str());
			auto& bot = env.getBotByValue(botVal);
			bot.giveChip(chipVal);
		}
		else if (regex_match(i, m, r2))
		{
			int botValue = atoi(m[1].str().c_str());
			auto lowType = giveTypeFromString(m[2].str());
			int lowValue = atoi(m[3].str().c_str());
			auto highType = giveTypeFromString(m[4].str());
			int highValue = atoi(m[5].str().c_str());
			Instruction instr;
			instr.bot = botValue;
			instr.lowGive = GiveSpec{ lowType, lowValue };
			instr.highGive = GiveSpec{ highType, highValue };
			instructions.push_back(instr);
		}
		else
		{
			throw runtime_error("Unknown instruction");
		}

	}
	return instructions;
}

bool applyInstructions(
	Environment &env,
	const vector<Instruction>& instructions)
{
	bool chipMoved = false;
	for (auto& i : instructions)
	{
		auto& bot = env.getBotByValue(i.bot);
		if (bot.lowValue != -1 && bot.highValue != -1)
		{
			if (i.lowGive.type == GiveType::Bot)
			{
				auto& giveBot = env.getBotByValue(i.lowGive.value);
				giveBot.giveChip(bot.lowValue);
			} else if(i.lowGive.type == GiveType::Output)
			{
				auto& outputBin = env.getOutput(i.lowGive.value);
				outputBin.insert(bot.lowValue);
			}
			bot.lowValue = -1;

			if (i.highGive.type == GiveType::Bot)
			{
				auto& giveBot = env.getBotByValue(i.highGive.value);
				giveBot.giveChip(bot.highValue);
			}
			else if (i.highGive.type == GiveType::Output)
			{
				auto& outputBin = env.getOutput(i.highGive.value);
				outputBin.insert(bot.highValue);
			}
			bot.highValue = -1;
			chipMoved = true;
			break;
		}
	}
	return chipMoved;
}

int main()
{
	Environment env;
	auto instructionsInText = readStrings(INPUT_FILE);

	// Part 1 (and 2)
	auto instructions = parseBotInstructions(env, instructionsInText);
	bool somethingToDo = true;
	while (somethingToDo)
	{
		somethingToDo = applyInstructions(env, instructions);

		// Search for answer for part 1
		auto i = find_if(env.bots.begin(), env.bots.end(),
			[](const Bot& b) { return b.lowValue == 17 && b.highValue == 61; });
		if (i != env.bots.end())
		{
			auto d = distance(env.bots.begin(), i);
			cout << "Day 9 part 1 result: " << d << endl;
		}
	}

	// -- Part 2 --
	int r = 1;
	if (env.outputs.size() >= 3)
	{
		for (int i = 0; i < 3; ++i)
		{
			auto& output = env.outputs[i];
			for (auto& value : output)
			{
				r *= value;
			}
		}
		cout << "Day 9 part 2 result: " << r << endl;
	}
	return 0;
}
