// Advent of Code 2016 - Day 20 part 1 and 2
// Peter Westerström

#include "config.h"
#include <numeric>
#include <cassert>
#include <iostream>
#include <fstream>
#include <vector>
#include <list>
#include <regex>
#include <memory>

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

class IInstruction
{
public:
	virtual void run(string& textLine) = 0;
	virtual void runInverse(string& textLine) = 0;
};

class IInstructionParser
{
public:
	virtual unique_ptr<IInstruction> tryParse(const string& instructionInText) = 0;
};

class SwapByIndex : public IInstruction
{
public:
	SwapByIndex(int index1, int index2)
	: index1{index1}
	, index2{index2}
	{
	}
	void run(string& textLine) override
	{
		swap(textLine[index1], textLine[index2]);
	}
	void runInverse(string & textLine) override
	{
		run(textLine);
	}


private:
	int index1;
	int index2;
};
class SwapLetters : public IInstruction
{
public:
	SwapLetters(char letter1, char letter2)
	: letter1{letter1}
	, letter2{letter2}
	{
	}

	void run(string& textLine) override
	{
		for(char& c : textLine)
		{
			if(c == letter1)
				c = letter2;
			else if(c == letter2)
				c = letter1;
		}
	}
	void runInverse(string & textLine) override
	{
		run(textLine);
	}

private:
	char letter1;
	char letter2;
};
class RotateLeft : public IInstruction
{
public:
	RotateLeft(int steps)
	: steps{steps}
	{
	}
	void run(string& textLine) override
	{
		if(steps == 0)
			return;

		auto n = steps % textLine.length();

		auto l = textLine.substr(0, n);
		textLine = textLine.substr(n) + l;
	}
	void runInverse(string & textLine) override;
private:
	int steps;
};
class RotateRight : public IInstruction
{
public:
	RotateRight(int steps)
	: steps{steps}
	{
	}
	void run(string& textLine) override
	{
		if(steps == 0)
			return;

		auto n = steps % textLine.length();

		auto r = textLine.substr(textLine.length()-n, n);
		auto l = textLine.substr(0, textLine.length() - n);
		textLine = r + l;
	}
	void runInverse(string & textLine) override;
private:
	int steps;
};

void RotateLeft::runInverse(string & textLine)
{
	RotateRight(steps).run(textLine);
}
void RotateRight::runInverse(string & textLine)
{
	RotateLeft(steps).run(textLine);
}

class RotateByLetterIndex : public IInstruction
{
public:
	RotateByLetterIndex(char letter)
	: letter{letter}
	{
	}
	void run(string& textLine) override
	{
		auto i = textLine.find(letter);
		if(i == string::npos)
			return;

		RotateRight r(static_cast<int>(i) + 1 + (static_cast<int>(i) >= 4 ? 1 : 0));
		r.run(textLine);
	}
	void runInverse(string & textLine) override
	{
		auto i = textLine.find(letter);
		if (i == string::npos)
			return;
		
		auto n = static_cast<int>(textLine.length());
		for (int i = 1; i <= n; ++i)
		{
			// I'm lazy, search for inverse by finding the Left rotated string that gives
			// input string as result when applying this rule forward..
			auto text2 = textLine;
			RotateLeft(i).run(text2);
			run(text2);
			if (textLine == text2)
			{
				RotateLeft(i).run(textLine);
				return;
			}
		}
		assert(0);
		throw runtime_error("No inverse found for RotateByLetterIndex");
	}
private:
	char letter;
};
class ReverseSpan : public IInstruction
{
public:
	ReverseSpan(int spanStart, int spanEnd)
	: spanStart{spanStart}
	, spanEnd{spanEnd}
	{
	}
	void run(string& textLine) override
	{
		for(int i = spanStart, j = spanEnd; i < j; ++i, --j)
		{
			swap(textLine[i], textLine[j]);
		}
	}
	void runInverse(string & textLine) override
	{
		run(textLine);
	}
private:
	int spanStart;
	int spanEnd; // inclusive
};
class MoveFromIndexToIndex : public IInstruction
{
public:
	MoveFromIndexToIndex(int fromIndex, int toIndex)
	: fromIndex{fromIndex}
	, toIndex{toIndex}
	{
	}
	void run(string& textLine) override
	{
		char c = textLine[fromIndex];
		textLine.erase(fromIndex, 1);
		textLine.insert(toIndex, 1, c);
	}
	void runInverse(string & textLine) override
	{
		MoveFromIndexToIndex(toIndex, fromIndex).run(textLine);
	}

private:
	int fromIndex;
	int toIndex;
};

class SwapByIndexParser : public IInstructionParser
{
public:
	SwapByIndexParser()
	{
	}
private:
	regex rgx{"swap position (\\d+) with position (\\d+)"};

	// Inherited via IInstructionParser
	virtual unique_ptr<IInstruction> tryParse(const string & instructionInText) override
	{
		smatch m;
		if(regex_match(instructionInText, m, rgx))
		{
			int index1 = atoi(m[1].str().c_str());
			int index2 = atoi(m[2].str().c_str());
			return make_unique<SwapByIndex>(index1, index2);
		} else
		{
			return unique_ptr<IInstruction>();
		}
	}
};
class SwapLettersParser : public IInstructionParser
{
public:
	SwapLettersParser() 
	{
	}
private:
	regex rgx{"swap letter ([a-z]) with letter ([a-z])"};

	// Inherited via IInstructionParser
	virtual unique_ptr<IInstruction> tryParse(const string & instructionInText) override
	{
		smatch m;
		if(regex_match(instructionInText, m, rgx))
		{
			char letter1 = m[1].str()[0];
			char letter2 = m[2].str()[0];
			return make_unique<SwapLetters>(letter1, letter2);
		} else
		{
			return unique_ptr<IInstruction>();
		}
	}
};
class RotateLeftParser : public IInstructionParser
{
public:
	RotateLeftParser()
	{
	}
private:
	regex rgx{"rotate left (\\d+) step(s?)"};
	virtual unique_ptr<IInstruction> tryParse(const string & instructionInText) override
	{
		smatch m;
		if(regex_match(instructionInText, m, rgx))
		{
			int steps = atoi(m[1].str().c_str());
			return make_unique<RotateLeft>(steps);
		} else
		{
			return unique_ptr<IInstruction>();
		}
	}
};
class RotateRightParser : public IInstructionParser
{
public:
	RotateRightParser()
	{
	}
private:
	regex rgx{"rotate right (\\d+) step(s?)"};
	virtual unique_ptr<IInstruction> tryParse(const string & instructionInText) override
	{
		smatch m;
		if(regex_match(instructionInText, m, rgx))
		{
			int steps = atoi(m[1].str().c_str());
			return make_unique<RotateRight>(steps);
		} else
		{
			return unique_ptr<IInstruction>();
		}
	}
};
class RotateByLetterIndexParser : public IInstructionParser
{
public:
	RotateByLetterIndexParser()
	{
	}
private:
	regex rgx{"rotate based on position of letter ([a-z])"};
	virtual unique_ptr<IInstruction> tryParse(const string & instructionInText) override
	{
		smatch m;
		if(regex_match(instructionInText, m, rgx))
		{
			char letter = m[1].str()[0];
			return make_unique<RotateByLetterIndex>(letter);
		} else
		{
			return unique_ptr<IInstruction>();
		}
	}
};
class ReverseSpanParser : public IInstructionParser
{
public:
	ReverseSpanParser()
	{
	}
private:
	regex rgx{"reverse positions (\\d+) through (\\d+)"};

	// Inherited via IInstructionParser
	virtual unique_ptr<IInstruction> tryParse(const string & instructionInText) override
	{
		smatch m;
		if(regex_match(instructionInText, m, rgx))
		{
			int i1 = atoi(m[1].str().c_str());
			int i2 = atoi(m[2].str().c_str());
			return make_unique<ReverseSpan>(i1, i2);
		} else
		{
			return unique_ptr<IInstruction>();
		}
	}
};
class MoveFromIndexToIndexParser : public IInstructionParser
{
public:
	MoveFromIndexToIndexParser()
	{
	}
private:
	regex rgx{"move position (\\d+) to position (\\d+)"};

	// Inherited via IInstructionParser
	virtual unique_ptr<IInstruction> tryParse(const string & instructionInText) override
	{
		smatch m;
		if(regex_match(instructionInText, m, rgx))
		{
			int i1 = atoi(m[1].str().c_str());
			int i2 = atoi(m[2].str().c_str());
			return make_unique<MoveFromIndexToIndex>(i1, i2);
		} else
		{
			return unique_ptr<IInstruction>();
		}
	}
};


vector<unique_ptr<IInstruction>> parseInstructions(vector<string>& instructionsAsText)
{
	vector<unique_ptr<IInstructionParser>> parsers;
	parsers.push_back(make_unique<SwapByIndexParser>());
	parsers.push_back(make_unique<SwapLettersParser>());
	parsers.push_back(make_unique<RotateLeftParser>());
	parsers.push_back(make_unique<RotateRightParser>());
	parsers.push_back(make_unique<RotateByLetterIndexParser>());
	parsers.push_back(make_unique<ReverseSpanParser>());
	parsers.push_back(make_unique<MoveFromIndexToIndexParser>());

	vector<unique_ptr<IInstruction>> instructions;
	regex r1("value (\\d+) goes to bot (\\d+)");
	regex r2("bot (\\d+) gives low to (output|bot) (\\d+) and high to (output|bot) (\\d+)");

	for(auto& i : instructionsAsText)
	{
		unique_ptr<IInstruction> instr;
		for(auto& p : parsers)
		{
			instr = p->tryParse(i);
			if(instr)
				break;
		}
		if(!instr)
		{
			throw runtime_error("Syntax error");
		}
		instructions.push_back(move(instr));
	}
	return instructions;
}

void runInstructions(const vector<unique_ptr<IInstruction>>& instructions, string& text)
{
	for(auto& i : instructions)
	{
		i->run(text);
	}
}

void runInstructionsInverse(const vector<unique_ptr<IInstruction>>& instructions, string& text)
{
	for (auto iter=instructions.rbegin();iter!=instructions.rend();++iter)
	{
		(*iter)->runInverse(text);
	}
}

#define TEST(x) { if(!(x)) { cerr << "Test Fail!! at line " << __LINE__ << endl;  assert(0); } }
void unitTest()
{
	vector<string> instructionsAsText = {
			"swap position 4 with position 0",
			"swap letter d with letter b",
			"reverse positions 0 through 4",
			"rotate left 1 step",
			"move position 1 to position 4",
			"move position 3 to position 0",
			"rotate based on position of letter b",
			"rotate based on position of letter d"
	};
	auto instructions = parseInstructions(instructionsAsText);
	TEST(instructions.size() == 8);

	string text = "abcde";

	instructions[0]->run(text);
	TEST(text == "ebcda");
	instructions[1]->run(text);
	TEST(text == "edcba");
	instructions[2]->run(text);
	TEST(text == "abcde");
	instructions[3]->run(text);
	TEST(text == "bcdea");
	instructions[4]->run(text);
	TEST(text == "bdeac");
	instructions[5]->run(text);
	TEST(text == "abdec");
	instructions[6]->run(text);
	TEST(text == "ecabd");
	instructions[7]->run(text);
	TEST(text == "decab");

	text = "abcde";
	runInstructions(instructions, text);
	TEST(text == "decab");

	runInstructionsInverse(instructions, text);
	TEST(text == "abcde");

}


int main()
{
//	unitTest();

	auto instructionsInText = readStrings(INPUT_FILE);
	auto instructions = parseInstructions(instructionsInText);

	// Part 1
	string text = "abcdefgh";
	runInstructions(instructions, text);
	cout << "Day 21 part 1 answer: " << text << endl;

	// Part 2
	string text2 = "fbgdceah";
	runInstructionsInverse(instructions, text2);
	cout << "Day 21 part 2 answer: " << text2 << endl;

	return 0;
}
