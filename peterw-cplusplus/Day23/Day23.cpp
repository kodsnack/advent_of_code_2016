// Advent of Code 2016 - Day 23 part 1 and 2
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
	jnz,
	tgl
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
	regex jnzRgx("jnz ([a-d]|[+-]?\\d+) ([a-d]|[+-]?\\d+)");
	regex tglRgx("tgl ([a-z])");

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
		else if(regex_match(i, m, tglRgx))
		{
			auto m1 = m[1].str();
			instr.op = Opcode::tgl;
			instr.x = parseOperand(m1);
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

	int registerCount() const
	{
		return 4;
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
		try
		{
			executeInstruction();
		} catch(runtime_error)
		{
			// skipping illegal instructions
			programCounter++;
		}
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
		if(operand.value >=0 && operand.value < registers.registerCount())
			return registers.registerValues[operand.value];
		else
			throw runtime_error("Invalid register");
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
		if(i.y.value < 0 || i.y.value>=registers.registerCount())
			throw runtime_error("Invalid register");
		registers.registerValues[i.y.value] = v;
		programCounter++;
		break;
	}
	case Opcode::inc:
	{
		if(i.x.value<0||i.x.value>=registers.registerCount())
			throw runtime_error("Invalid register");
		registers.registerValues[i.x.value]++;
		programCounter++;
		break;
	}
	case Opcode::dec:
	{
		if(i.x.value<0||i.x.value>=registers.registerCount())
			throw runtime_error("Invalid register");
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
	case Opcode::tgl:
	{
		auto v = evalOperand(i.x);
		auto tglAddr = programCounter + v;
		if(tglAddr>=0&&tglAddr<program.size())
		{
			auto& tglInstr = program[tglAddr];
			switch(tglInstr.op)
			{
				case Opcode::cpy:
					tglInstr.op = Opcode::jnz;
					break;
				case Opcode::inc:
					tglInstr.op = Opcode::dec;
					break;
				case Opcode::dec:
					tglInstr.op = Opcode::inc;
					break;
				case Opcode::jnz:
					tglInstr.op = Opcode::cpy;
					break;
				case Opcode::tgl:
					tglInstr.op = Opcode::inc;
					break;
			}
		}
		programCounter++;
		break;
	}
	}
}

void unit_test()
{
	vector<string> i;
	i.push_back("cpy 2 a");
	i.push_back("tgl a");
	i.push_back("tgl a");
	i.push_back("tgl a");
	i.push_back("cpy 1 a");
	i.push_back("dec a");
	i.push_back("dec a");
	auto program = parseInstructions(i);
	Computer c;
	c.program = program;
	c.programCounter = 0;
	c.start();
	auto regA = c.registers.registerValues[0];
	assert(regA == 3);
}

int main()
{
//	unit_test(); return 0;

	auto instructionsInText = readStrings(INPUT_FILE);
	auto program = parseInstructions(instructionsInText);

	// Part1
	{
		Computer c;
		c.program = program;
		c.reset();
		c.registers.registerValues[0] = 7;
		c.start();
		auto regA = c.registers.registerValues[0];
		cout << "Day 23 part 1 answer: " << regA << endl;
	}

	// Part 2
	{
		Computer c;
		c.program = program;
		c.reset();
		c.registers.registerValues[0] = 12;
		c.start();
		auto regA = c.registers.registerValues[0];
		cout << "Day 23 part 2 answer: " << regA << endl;
	}

	return 0;
}
