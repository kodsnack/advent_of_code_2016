// Advent of Code 2016 - Day 4 part 2
// Peter Westerström

#include "config.h"
#include <algorithm>
#include <fstream>
#include <iostream>
#include <map>
#include <regex>
#include <string>
#include <unordered_map>
#include <vector>
#include <cassert>

using namespace std;

vector<string> readRoomStrings(string inputFile)
{
	vector<string> rooms;
	fstream f(inputFile);

	int validCount{0};
	while(!f.eof())
	{
		string line;
		if(getline(f, line))
		{
			rooms.push_back(line);
		}
	}
	return rooms;
}

template <typename A, typename B> std::pair<B, A> flip_pair(const std::pair<A, B>& p)
{
	return std::pair<B, A>(p.second, p.first);
}

// flips an associative container of A,B pairs to B,A pairs
template <typename A, typename B, template <class, class, class...> class M, class... Args>
std::multimap<B, A> flip_map(const M<A, B, Args...>& src)
{
	std::multimap<B, A> dst;
	std::transform(src.begin(), src.end(), std::inserter(dst, dst.begin()), flip_pair<A, B>);
	return dst;
}

string computeChecksumFromName(string name)
{
	name.erase(remove(name.begin(), name.end(), '-'), name.end());
	sort(name.begin(), name.end());
	unordered_map<char, int> histogram;
	for(char c : name)
	{
		if(histogram.find(c)==histogram.end())
		{
			histogram[c] = 1;
		} else
		{
			histogram[c]++;
		}
	}
	auto countToCharMap = flip_map(histogram);
	vector<pair<int, char>> countToCharVec;
	copy(countToCharMap.rbegin(), countToCharMap.rend(), back_inserter(countToCharVec));

	sort(countToCharVec.begin(), countToCharVec.end(),
		 [](const pair<int, char>& lhs, const pair<int, char>& rhs) {
		if(lhs.first>rhs.first)
			return true;
		if(lhs.first<rhs.first)
			return false;

		return (lhs.second<rhs.second);
	});

	string computedChecksum;
	for(int i = 0; i<5&&i<countToCharVec.size(); i++)
	{
		computedChecksum += countToCharVec[i].second;
	}
	return computedChecksum;
}

string decryptName(string encryptedName, int id)
{
	for(char& c : encryptedName)
	{
		if(c=='-')
		{
			c=' ';
		} else
		{
			c = 'a' + (static_cast<int>(c-'a') + id) % static_cast<int>(1+'z'-'a');
		}
	}
	return encryptedName;
}

struct Room
{
	string name;
	int sectorID{-1};

	bool isNull() const { return sectorID == -1; }
};

// return -1 if not valid
Room parseRoomID(string room)
{
	regex rgx("(([a-z]+[-])+)([0-9]+)\\[([a-z]+)\\]");
	std::smatch m;
	if(regex_match(room, m, rgx))
	{
		auto n = m.size();
		auto name = m[1].str();
		auto sectorID = m[3].str();
		auto checksum = m[4].str();

		name = name.substr(0, name.length()-1);
		auto computedChecksum = computeChecksumFromName(name);

		if(checksum==computedChecksum)
		{
			Room room;
			room.sectorID = atoi(sectorID.c_str());
			room.name = decryptName(name, room.sectorID);
			return room;
		} else
			return Room();
	}
	return Room();
}

void unit_test()
{
	// 	assert(parseRoomID("aaaaa-bbb-z-y-x-123[abxyz]")>0);
	// 	assert(parseRoomID("a-b-c-d-e-f-g-h-987[abcde]")>0);
	// 	assert(parseRoomID("not-a-real-room-404[oarel]")>0);
	// 	assert(parseRoomID("totally-real-room-200[decoy]")==-1);

	auto name = decryptName("qzmt-zixmtkozy-ivhz", 343);
	assert(name=="very encrypted name");
}

int main()
{
	unit_test();

	auto rooms = readRoomStrings(INPUT_FILE);
	int validRoomsIDSum{0};
	for(auto& roomStr:rooms)
	{
		auto room = parseRoomID(roomStr);
		if(!room.isNull())
		{
//			cout<<"Room with name : "<<room.name<<endl;
			if(room.name.find("north")!=string::npos)
			{
				// Found it
				cout<<"Day 4 part 2 result: "<<room.sectorID<<endl;
				return 0;
			}
		}
	}

	cout << "Day 4 part 2 result: NO SOLUTION FOUND" << endl;
	return 0;
}
