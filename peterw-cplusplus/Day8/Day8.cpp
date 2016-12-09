// Advent of Code 2016 - Day 8 part 1 and 2
// Peter Westerström

#include "config.h"
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <memory>
#include <regex>
#include <string>
#include <vector>

using namespace std;

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

class Display
{
public:
	static const int displayWidth = 50;
	static const int displayHeight = 6;

	Display()
	{
		clear();
	}

	bool readPixel(int x, int y) const
	{
		return m_displayMatrix[y][x];
	}
	void writePixel(int x, int y, bool value)
	{
		m_displayMatrix[y][x] = value;
	}

	void clear()
	{
		for(int y = 0;y<displayHeight;++y)
			for(int x = 0;x<displayWidth;++x)
				m_displayMatrix[y][x] = false;
	}

	int countLit() const
	{
		int count=0;
		for(int y = 0;y<displayHeight;++y)
			for(int x = 0;x<displayWidth;++x)
				if(m_displayMatrix[y][x])
					count++;
		return count;
	}

	void print(ostream& os)
	{
		for(int y = 0;y<displayHeight;++y)
		{
			for(int x = 0;x<displayWidth;++x)
			{
				if(m_displayMatrix[y][x])
				{
					os << "*";
				} else
				{
					os << " ";
				}
			}
			os<< endl;
		}
	}
private:
	bool m_displayMatrix[displayHeight][displayWidth];
};

class Instruction
{
public:
	virtual void apply(Display& display) = 0;
};

class RectInstruction : public Instruction
{
public:
	RectInstruction(int a, int b)
		: m_a{a}
		, m_b{b}
	{
	}
	void apply(Display& display) override
	{
		for(int y = 0;y<m_b;++y)
		{
			for(int x = 0;x<m_a;++x)
			{
				display.writePixel(x, y, true);
			}
		}
	}

	static unique_ptr<Instruction> tryParseCreate(const string& instructionStr)
	{
		regex rectRgx("rect (\\d+)x(\\d+)");
		smatch m;
		if(regex_match(instructionStr, m, rectRgx))
		{
			auto m1 = m[1].str();
			auto m2 = m[2].str();
			auto n1 = atoi(m1.c_str());
			auto n2 = atoi(m2.c_str());
			return make_unique<RectInstruction>(n1,n2);
		} else
		{
			return nullptr;
		}
	}

private:
	int m_a, m_b;
};

class RotateRowInstruction : public Instruction
{
public:
	RotateRowInstruction(int y, int steps)
		: m_y{y}
		, m_steps{steps}
	{
	}

	virtual void apply(Display & display) override
	{
		for(int step = 0;step<m_steps;++step)
		{
			bool c0 = display.readPixel(display.displayWidth-1, m_y);
			for(int x = display.displayWidth-2;x>=0;--x)
			{
				display.writePixel(x+1, m_y, display.readPixel(x, m_y));
			}
			display.writePixel(0, m_y, c0);
		}
	}

	static unique_ptr<Instruction> tryParseCreate(const string& instructionStr)
	{
		regex rotRowRgx("rotate row y=(\\d+) by (\\d+)");
		smatch m;
		if(regex_match(instructionStr, m, rotRowRgx))
		{
			auto m1 = m[1].str();
			auto m2 = m[2].str();
			auto n1 = atoi(m1.c_str());
			auto n2 = atoi(m2.c_str());
			return make_unique<RotateRowInstruction>(n1,n2);
		} else
		{
			return nullptr;
		}
	}

private:
	int m_y;
	int m_steps;
};

class RotateColumntInstruction : public Instruction
{
public:
	RotateColumntInstruction(int x, int steps)
		: m_x{x}
		, m_steps{steps}
	{
	}

	virtual void apply(Display & display) override
	{
		for(int step = 0;step<m_steps;++step)
		{
			bool c0 = display.readPixel(m_x, display.displayHeight-1);
			for(int y = display.displayHeight-2;y>=0;--y)
			{
				display.writePixel(m_x, y+1, display.readPixel(m_x, y));
			}
			display.writePixel(m_x, 0, c0);
		}
	}

	static unique_ptr<Instruction> tryParseCreate(const string& instructionStr)
	{
		regex rotColRgx("rotate column x=(\\d+) by (\\d+)");
		smatch m;
		if(regex_match(instructionStr, m, rotColRgx))
		{
			auto m1 = m[1].str();
			auto m2 = m[2].str();
			auto n1 = atoi(m1.c_str());
			auto n2 = atoi(m2.c_str());
			return make_unique<RotateColumntInstruction>(n1,n2);
		} else
		{
			return nullptr;
		}
	}

private:
	int m_x;
	int m_steps;
};

unique_ptr<Instruction> parseInstruction(const string& instructionStr)
{
	auto rectInstr = RectInstruction::tryParseCreate(instructionStr);
	if(rectInstr)
		return rectInstr;

	auto rowInstr = RotateRowInstruction::tryParseCreate(instructionStr);
	if(rowInstr)
		return rowInstr;

	auto colInstr = RotateColumntInstruction::tryParseCreate(instructionStr);
	if(colInstr)
		return colInstr;

	throw runtime_error("Illegal instruction: "+instructionStr);
}

vector<unique_ptr<Instruction>> parseInstructions(const vector<string>& instructionsInText)
{
	vector<unique_ptr<Instruction>> instructions;
	for(auto& instrStr:instructionsInText)
	{
		auto instr = parseInstruction(instrStr);
		instructions.push_back(move(instr));
	}
	return instructions;
}

int main()
{
	// Read input
	auto instructionsInText = readStrings(INPUT_FILE);
	auto instructions = parseInstructions(instructionsInText);

	// -- Part 1 --
	Display display;
	for(auto& instr:instructions)
	{
		instr->apply(display);
	}
	auto litCount = display.countLit();
	cout << "Day 8 part 1 result: " << litCount << endl;

	// -- Part 2 --
	cout << "Day 8 part 2 result: " << endl;
	display.print(cout);

	return 0;
}
