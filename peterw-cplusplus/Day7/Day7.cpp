// Advent of Code 2016 - Day 7 part 1 and 2
// Peter Westerström

#include "config.h"
#include <algorithm>
#include <cassert>
#include <fstream>
#include <iostream>
#include <string>
#include <tuple>
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

bool supportsTLS(const string& ip)
{
	auto len = ip.length();
	bool insideBrackets = false;
	bool abbaOutsideBracketsFound = false;
	bool abbaInsideBracketsFound = false;
	for(decltype(len) i = 0;i<len;++i)
	{
		if(ip[i]=='[')
		{
			insideBrackets = true;
		} else if(ip[i]==']')
		{
			insideBrackets = false;
		} else
		{
			if(i+3<len)
			{
				if(ip[i]!=ip[i+1]&&ip[i]==ip[i+3]&&ip[i+1]==ip[i+2]
				   &&ip[i+1]!='[' && ip[i+2]!='[' && ip[i+3]!='[')
				{
					if(insideBrackets)
						abbaInsideBracketsFound = true;
					else
						abbaOutsideBracketsFound = true;
				}
			}
		}
		if(abbaInsideBracketsFound && abbaOutsideBracketsFound)
			break; // Optimization. We can break out early. As now know result is false
	}
	return abbaOutsideBracketsFound&&!abbaInsideBracketsFound;
}

string::size_type findABA(const string& s, string::size_type startPos=0) noexcept
{
	auto len = s.length();
	for(decltype(len) i = startPos;i<len-2;++i )
	{
		if(s[i]!=s[i+1]&&s[i]==s[i+2])
		{
			return i;
		}
	}
	return s.npos;
}

bool hasABAWithBABInHypernet(const string& supernet, const string& hypernet) noexcept
{
	string::size_type i = 0;
	string bab("   ");
	while(true)
	{
		i = findABA(supernet, i);

		if(i==string::npos)
			return false;

		bab[0] = supernet[i+1];
		bab[1] = supernet[i+0];
		bab[2] = supernet[i+1];
		if(hypernet.find(bab.c_str())!=string::npos)
		{
			return true;
		}
		i++;
	}
	return false;
}


/** 
 * Split ip into supernet and hypernet parts
 * @return pair(first,second) where first is vector of supernets and second is vector of hypernets
 */
pair<vector<string>, vector<string>> parseSuperAndHyperNet(const string& ip)
{
	vector<string> supernets;
	vector<string> hypernets;

	string::size_type startIndex=0;
	while(true)
	{
		auto leftIndex = ip.find('[', startIndex);
		if(leftIndex!=string::npos)
		{
			auto rightIndex = ip.find(']', leftIndex+1);
			if(rightIndex==string::npos)
			{
				throw exception();
			}
			supernets.push_back(ip.substr(startIndex, leftIndex-startIndex));
			hypernets.push_back(ip.substr(leftIndex+1, rightIndex-leftIndex-1));
			startIndex=rightIndex+1;
		} else
		{
			supernets.push_back(ip.substr(startIndex));
			break;
		}
	}
	return make_pair(supernets,hypernets);
}

bool supportsSSL(const string& ip)
{
	vector<string> supernets;
	vector<string> hypernets;
	tie(supernets, hypernets) = parseSuperAndHyperNet(ip);
	for(auto& supernet:supernets)
	{
		for(auto& hypernet:hypernets)
		{
			if(hasABAWithBABInHypernet(supernet, hypernet))
				return true; // found one aba[bab] match
		}
	}
	return false;
}

#define TEST(x) { if(!(x)) { cerr << "Test Fail!!"  << endl;  assert(0); } }
void unitTest()
{
	TEST(supportsSSL("aba[bab]xyz"));
	TEST(!supportsSSL("xyx[xyx]xyx"));
	TEST(supportsSSL("aaa[kek]eke"));
	TEST(supportsSSL("zazbz[bzb]cdb"));
}

int main()
{
	//unitTest();

	// Read input
	auto ips = readStrings(INPUT_FILE);
	
	// -- Part 1 --
	int countTLS=0;
	for(auto ip : ips)
	{
		if(supportsTLS(ip))
			countTLS++;
	}
	cout << "Day 7 part 1 result: " << countTLS << endl;
	
	// -- Part 2 --
	int countSSL = 0;
	for(auto ip:ips)
	{
		if(supportsSSL(ip))
			countSSL++;
	}
	cout << "Day 7 part 2 result: " << countSSL << endl;
	return 0;
}
