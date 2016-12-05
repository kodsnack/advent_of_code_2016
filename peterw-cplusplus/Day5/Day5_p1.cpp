// Advent of Code 2016 - Day 5 part 1
// Peter Westerström

#include <string>
#include <iostream>

extern "C"
{
#include "md5.h"
}

using namespace std;

string md5FromString(string str)
{
	unsigned char sig[MD5_SIZE]; 
	char md5str[33];

	md5_t md5;
	md5_init(&md5);
	md5_process(&md5, str.data(), str.length());
	md5_finish(&md5, sig); 
	
	md5_sig_to_string(sig, md5str, sizeof(md5str));

	return(md5str);
}

string doorHash(const string& doorID, const int index)
{
	auto strToMd5 = doorID + to_string(index);
	auto md5 = md5FromString(strToMd5);

	return md5;
}

string generatePassport(const string& doorID, const int length)
{
	string password;

	int i = 0;
	do
	{
		auto h = doorHash(doorID, i);
		if(h.substr(0, 5)=="00000")
		{
			password += h[5];
		}
		++i;
	} while(password.length()<length);
	return password;
}

void unit_test()
{
	auto test1 = generatePassport("abc", 8);
	if(test1!="18f47a30")
	{
		cerr << "Error: Unit test failed for Day5p1" << endl;
	} else
	{
		cout << "Unit test pass Day5p1" << endl;
	}
}

int main()
{
//	unit_test();
	
	string input = "ffykfhsq";
	auto password = generatePassport(input, 8);
	cout<<"Day 5 part 1 result: "<<password<<endl;

	return 0;
}
