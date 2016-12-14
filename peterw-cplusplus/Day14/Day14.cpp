// Advent of Code 2016 - Day 14 part 1 and 2
// Peter Westerström

#include <cassert>
#include <algorithm>
#include <string>
#include <iostream>
#include <vector>
#include <tuple>
#include <deque>

extern "C"
{
#include "md5.h"
}

using namespace std;
const int verbose = 0;

string md5FromString(string str)
{
	unsigned char sig[MD5_SIZE];
	char md5str[33];

	md5_t md5;
	md5_init(&md5);
	md5_process(&md5, str.data(), static_cast<unsigned int>(str.length()));
	md5_finish(&md5, sig);

	md5_sig_to_string(sig, md5str, sizeof(md5str));

	return(md5str);
}

string generateRandom(const string& salt, int index, bool keystretching=false)
{
	auto r = md5FromString(salt + to_string(index));
	if (keystretching)
	{
		for (int i = 0; i < 2016; ++i)
		{
			r = md5FromString(r);
		}
	}
	return r;
}

string findTriple(const string& s)
{
	for (int i = 2; i < s.length(); ++i)
	{
		if (s[i] == s[i - 1] && s[i] == s[i - 2])
		{
			return s.substr(i - 2, 3);
		}
	}
	return string();
}

vector<tuple<string, int>> generatePasswords(
	const string& salt,
	int passwordCount,
	bool keystretching=false)
{
	vector<tuple<string,int>> passwords;
	passwords.reserve(passwordCount);
	vector<tuple<string, string, int>> candidates;

	int i = 0;
	do
	{
		auto currentCandidate = generateRandom(salt, i, keystretching);

		// Remove candidates that is too far away
		for(auto it=candidates.begin();it!=candidates.end();)
		{
			auto candidateIndex = get<2>(*it);
			if (i - candidateIndex > 1000)
			{
				it = candidates.erase(it);
			}
			else
			{
				break;
			}
		}

		for (auto it = candidates.begin(); it != candidates.end();)
		{
			auto fivedruple = get<1>(*it);
			auto candidateIndex = get<2>(*it);
			if (currentCandidate.find(fivedruple) != string::npos)
			{
				// Found a password
				auto& p = get<0>(*it);
				passwords.push_back(make_tuple(move(p),candidateIndex));
				if (verbose)
				{
					cout << (passwords.size() * 100 / passwordCount) << "% ";
				}
				if (passwords.size() == passwordCount)
				{
					break; // we are done
				}
				it = candidates.erase(it);
				continue;
			}
			else
			{
				++it;
			}

		}

		auto tripple = findTriple(currentCandidate);
		if(!tripple.empty())
		{
			tripple += tripple[0];
			tripple += tripple[0];
			candidates.push_back(make_tuple(currentCandidate, tripple, i));
		}

		++i;
	} while (passwords.size()<passwordCount);
	if (verbose)
	{
		cout << endl;
	}
	return passwords;
}

#define TEST(x) { if(!(x)) { cerr << "Test Fail!! at line " << __LINE__ << endl;  assert(0); } }
void unitTest()
{
	string salt = "abc";

	// part 1
	auto passwords = generatePasswords(salt, 64, false);
	TEST(passwords.size() == 64);
	TEST(get<1>(passwords[63]) == 22728);

	// part 2
	auto passwords2 = generatePasswords(salt, 64, true);
	TEST(passwords2.size() == 64);
	TEST(get<1>(passwords2[63]) == 22551);
}

int main()
{
//	unitTest();

	const string inputSalt = "cuanljph";

	auto passwords = generatePasswords(inputSalt, 64, false);
	cout<<"Day 14 part 1 answer: "<< get<1>(passwords[63]) <<endl;

	auto passwords2 = generatePasswords(inputSalt, 64, true);
	cout<<"Day 14 part 2 answer: "<< get<1>(passwords2[63]) <<endl;

	return 0;
}
