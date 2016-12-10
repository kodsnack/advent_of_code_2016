// Advent of Code 2016 - Day 9 part 1 and 2
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

using namespace std;

string decompress(const string& compressedText)
{
	string decompressedText;
	regex rgx("^\\((\\d+)x(\\d+)\\)(.*)");
	smatch m;
	auto length = compressedText.size();
	for (string::size_type i = 0; i < length; )
	{
		auto s = compressedText.substr(i);
		if (regex_match(s, m, rgx))
		{
			auto m1 = m[1].str();
			auto seqLength = atoi(m1.c_str());
			auto m2 = m[2].str();
			auto repCount = atoi(m2.c_str());
			auto offsetToRest = m[3].first -s.begin();
			auto rest = m[3].str();
			auto seq = rest.substr(0, seqLength);
			while (repCount > 0)
			{
				decompressedText += seq;
				repCount--;
			}
			i += offsetToRest+seqLength;
		} else
		{
			decompressedText += compressedText[i];
			i++;
		}
	}
	return decompressedText;
}


#define TEST(x) { if(!(x)) { cerr << "Test Fail!!"  << endl;  assert(0); } }
void unit_test()
{
	TEST(decompress("ADVENT") == "ADVENT");
	TEST(decompress("A(1x5)BC") == "ABBBBBC");
	TEST(decompress("(3x3)XYZ") == "XYZXYZXYZ");
	TEST(decompress("A(2x2)BCD(2x2)EFG") == "ABCBCDEFEFG");
	TEST(decompress("(6x1)(1x3)A") == "(1x3)A");
	TEST(decompress("X(8x2)(3x3)ABCY") == "X(3x3)ABC(3x3)ABCY");
}

uint64_t decompressv2Length(const string& compressedText)
{
	uint64_t decompressedSize=0;
	regex rgx("^\\((\\d+)x(\\d+)\\)(.*)");
	smatch m;
	auto length = compressedText.size();
	for (string::size_type i = 0; i < length; )
	{
		auto s = compressedText.substr(i);
		if (regex_match(s, m, rgx))
		{
			auto m1 = m[1].str();
			auto seqLength = atoi(m1.c_str());
			auto m2 = m[2].str();
			auto repCount = atoi(m2.c_str());
			auto offsetToRest = m[3].first - s.begin();
			auto rest = m[3].str();
			auto seq = rest.substr(0, seqLength);
			auto seqDecompressedLength = decompressv2Length(seq);
			while (repCount > 0)
			{
				decompressedSize += seqDecompressedLength;
				repCount--;
			}
			i += offsetToRest + seqLength;
		}
		else
		{
			decompressedSize++;
			i++;
		}
	}
	return decompressedSize;
}

void unit_test_part2()
{
	TEST(decompressv2Length("(3x3)XYZ")==9);
	TEST(decompressv2Length("X(8x2)(3x3)ABCY") == string("XABCABCABCABCABCABCY").length());
	TEST(decompressv2Length("(27x12)(20x12)(13x14)(7x10)(1x12)A") == 241920);
	TEST(decompressv2Length("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN") == 445);
}

int main()
{
//	unit_test();
//	unit_test_part2();

	fstream f(INPUT_FILE);
	string input((istreambuf_iterator<char>(f)), istreambuf_iterator<char>());

	// -- Part 1 --
	auto output = decompress(input);
	cout << "Day 9 part 1 result: " << output.length() << endl;

	// -- Part 2 --
	auto output2 = decompressv2Length(input);
	cout << "Day 9 part 2 result: " << output2 << endl;

	return 0;
}
