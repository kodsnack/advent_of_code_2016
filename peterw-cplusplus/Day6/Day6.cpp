// Advent of Code 2016 - Day 6 part 1 and 2
// Peter Westerström

#include "config.h"
#include <algorithm>
#include <fstream>
#include <iostream>
#include <map>
#include <string>
#include <unordered_map>
#include <vector>

using namespace std;

vector<string> readStrings(string inputFile)
{
	vector<string> words;
	fstream f(inputFile);

	int validCount{0};
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

// Index 0 is a
typedef vector<vector<int>> WordCharHistogram;

enum class LetterDistributionType
{
	Min,
	Max
};

string decodeMessage(vector<string> messages, LetterDistributionType type)
{
	const int wordLength = static_cast<int>(messages[0].length());

	// Initiate histograms to 0, one per letter in the word (with length wordLength)
	WordCharHistogram charHistogram(wordLength);
	for (auto& h : charHistogram)
	{
		h.resize(1 + 'z' - 'a', 0);
	}
	// Compute histogram
	for (auto& word : messages)
	{
		for (int i = 0; i < wordLength; ++i)
		{
			char c = word[i];
			int charIdx = c - 'a';
			charHistogram[i][charIdx]++;
		}
	}
	// Get most common char from histogram per word letter index
	string word(wordLength, ' ');
	for (int i = 0; i < wordLength; ++i)
	{
		auto& histogram = charHistogram[i];
		WordCharHistogram::value_type::iterator it;
		if(type== LetterDistributionType::Min)
			it = min_element(histogram.begin(), histogram.end());
		else
			it = max_element(histogram.begin(), histogram.end());
		int c = static_cast<int>('a') + static_cast<int>(distance(histogram.begin(), it));
		word[i] = static_cast<char>(c);
	}
	// That is the result
	return word;

}

int main()
{
	auto messages = readStrings(INPUT_FILE);

	auto word1 = decodeMessage(messages, LetterDistributionType::Max);
	cout << "Day 6 part 1 result: " << word1 << endl;

	auto word2 = decodeMessage(messages, LetterDistributionType::Min);
	cout << "Day 6 part 2 result: " << word2 << endl;
	return 0;
}
