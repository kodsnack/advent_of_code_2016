// Advent of Code 2016 - Day 12 part 1 and 2
// Peter Westerström

#include "config.h"
#include <cassert>
#include <fstream>
#include <iostream>
#include <regex>
#include <string>
#include <vector>

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


enum class Opcode
{
	cpy,
	inc,
	dec,
	jnz
};
enum class OperandType
{
	Unused,
	RegisterSelector,
	Value
};

struct Operand
{
	OperandType type{ OperandType::Unused };
	int value{ 0 }; // value or register
};

struct Instruction
{
	Opcode op;
	Operand x;
	Operand y;
};

typedef vector<Instruction> Program;

Operand parseOperand(const string& operandText)
{
	Operand op;
	char r = operandText[0];
	if (r >= 'a' && r <= 'd')
	{
		op.type = OperandType::RegisterSelector;
		op.value = static_cast<int>(r - 'a');
	}
	else
	{
		op.type = OperandType::Value;
		op.value = atoi(operandText.c_str());
	}
	return op;
}

Program parseInstructions(const vector<string>& instructionsInText)
{
	regex cpyRgx("cpy ([a-d]|[+-]?\\d+) ([a-d])");
	regex incRgx("inc ([a-d])");
	regex decRgx("dec ([a-d])");
	regex jnzRgx("jnz ([a-d]|[+-]?\\d+) ([+-]?\\d+)");

	Program p;
	for (const auto& i : instructionsInText)
	{
		Instruction instr;

		smatch m;
		if (regex_match(i, m, cpyRgx))
		{
			auto m1 = m[1].str();
			auto m2 = m[2].str();
			instr.op = Opcode::cpy;
			instr.x = parseOperand(m1);
			instr.y = parseOperand(m2);
		} else if (regex_match(i, m, incRgx))
		{
			auto m1 = m[1].str();
			instr.op = Opcode::inc;
			instr.x = parseOperand(m1);
		} else if (regex_match(i, m, decRgx))
		{
			auto m1 = m[1].str();
			instr.op = Opcode::dec;
			instr.x = parseOperand(m1);
		}
		else if (regex_match(i, m, jnzRgx))
		{
			auto m1 = m[1].str();
			auto m2 = m[2].str();
			instr.op = Opcode::jnz;
			instr.x = parseOperand(m1);
			instr.y = parseOperand(m2);
		}
		else
		{
			assert(0);
			throw runtime_error("Invalid instruction");
		}
		p.push_back(move(instr));
	}
	return p;
}

struct RegistersState
{
	RegistersState()
	{
		reset();
	}
	void reset()
	{
		registerValues[0] = 0;
		registerValues[1] = 0;
		registerValues[2] = 0;
		registerValues[3] = 0;
	}
	int registerValues[4];
};

struct Computer
{
	Program program;
	int programCounter{ 0 };
	RegistersState registers;

	void start();
	void reset();
private:
	void executeInstruction();
	int evalOperand(const Operand& operand);
};

void Computer::start()
{
	while (programCounter < program.size())
	{
		executeInstruction();
	}
}

void Computer::reset()
{
	programCounter = 0;
	registers.reset();
}

int Computer::evalOperand(const Operand& operand)
{
	if (operand.type == OperandType::RegisterSelector)
	{
		return registers.registerValues[operand.value];
	}
	else if (operand.type == OperandType::Value)
	{
		return operand.value;
	}
	else
		throw runtime_error("Invalid operand");
}

void Computer::executeInstruction()
{
	const auto& i = program[programCounter];
	switch (i.op)
	{
	case Opcode::cpy:
	{
		auto v = evalOperand(i.x);
		registers.registerValues[i.y.value] = v;
		programCounter++;
		break;
	}
	case Opcode::inc:
	{
		registers.registerValues[i.x.value]++;
		programCounter++;
		break;
	}
	case Opcode::dec:
	{
		registers.registerValues[i.x.value]--;
		programCounter++;
		break;
	}
	case Opcode::jnz:
	{
		auto vx = evalOperand(i.x);
		auto vy = evalOperand(i.y);
		programCounter += (vx != 0 ? vy : 1);
		break;
	}
	}
}

void unit_test()
{
	vector<string> i;
	i.push_back("cpy 41 a");
	i.push_back("inc a");
	i.push_back("inc a");
	i.push_back("dec a");
	i.push_back("jnz a 2");
	i.push_back("dec a");

	auto program = parseInstructions(i);
	Computer c;
	c.program = program;
	c.programCounter = 0;
	c.start();
	auto regA = c.registers.registerValues[0];
	assert(regA == 42);
}

int main()
{
//	unit_test();

	auto instructionsInText = readStrings(INPUT_FILE);
	auto program = parseInstructions(instructionsInText);
	Computer c;
	c.program = program;

	// Part1
	{
		c.reset();
		c.start();
		auto regA = c.registers.registerValues[0];
		cout << "Day 12 part 1 answer: " << regA << endl;
	}

	// Part 2
	{
		c.reset();
		c.registers.registerValues[2 /* c */] = 1;
		c.start();
		auto regA = c.registers.registerValues[0];
		cout << "Day 12 part 2 answer: " << regA << endl;
	}

	return 0;
}
