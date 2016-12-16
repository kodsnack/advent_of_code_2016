// Advent of Code 2016 - Day 16 part 1 and 2
// Peter Westerström

#include <algorithm>
#include <cassert>
#include <iostream>
#include <string>

using namespace std;

string repeatData(const string& input)
{
	auto a = input;
	auto b = a;
	reverse(b.begin(), b.end());
	for (auto& c : b)
	{
		if (c == '0')
			c = '1';
		else
			c = '0';
	}
	auto r = a + "0" + b;
	return r;
}

string fillTo(const string& input, int n)
{
	string data = input;
	while (data.size() < n)
	{
		data = repeatData(data);
	}
	return data.substr(0, n);
}

string checksum(const string& input)
{
	auto data = input;
	string checksum;
	do
	{
		checksum.clear();
		for (int i = 0; i < data.size(); i += 2)
		{
			auto charPair = data.substr(i, 2);
			if (charPair[0] == charPair[1])
			{
				checksum += "1";
			}
			else
			{
				checksum += "0";
			}
		}
		data = checksum;
	} while (checksum.length() % 2 == 0);
	return checksum;
}

#define TEST(x) { if(!(x)) { cerr << "Test Fail!! at line " << __LINE__ << endl;  assert(0); } }
void unitTest()
{
	TEST(repeatData("1") == "100");
	TEST(repeatData("0") == "001");
	TEST(repeatData("11111") == "11111000000");
	TEST(repeatData("111100001010") == "1111000010100101011110000");

	TEST(fillTo("10000", 20) == "10000011110010000111");

	TEST(checksum("110010110100") == "100");
	TEST(checksum("10000011110010000111") == "01100");
}

int main()
{
//	unitTest();

	const string input = "10010000000110000";

	auto checksum1 = checksum(fillTo(input, 272));
	cout << "Day 16 part 1 answer: " << checksum1 << endl;

	auto checksum2 = checksum(fillTo(input, 35651584));
	cout << "Day 16 part 2 answer: " << checksum2 << endl;

	return 0;
}
