package main

import (
	"strings"
)

func day6_part1(input string) string {
	rows := strings.Split(input, "\n")

	popularCharacters := make(map[int]map[rune]int)

	for _, row := range rows {
		for pos, char := range row {

			if _, ok := popularCharacters[pos]; !ok {
				popularCharacters[pos] = make(map[rune]int)
			}

			if _, ok := popularCharacters[pos][char]; !ok {
				popularCharacters[pos][char] = 1
			} else {
				popularCharacters[pos][char]++
			}
		}
	}

	// Create placeholders
	res := strings.Repeat(" ", len(popularCharacters))

	for pos, chars := range popularCharacters {
		var mostPopular rune
		var mostPopularCount int

		for char, count := range chars {
			if count > mostPopularCount {
				mostPopularCount = count
				mostPopular = char
			}
		}

		// Set char
		res = res[:pos] + string(mostPopular) + res[pos+1:]
	}

	return res
}

func day6_part2(input string) string {
	rows := strings.Split(input, "\n")

	popularCharacters := make(map[int]map[rune]int)

	for _, row := range rows {
		for pos, char := range row {

			if _, ok := popularCharacters[pos]; !ok {
				popularCharacters[pos] = make(map[rune]int)
			}

			if _, ok := popularCharacters[pos][char]; !ok {
				popularCharacters[pos][char] = 1
			} else {
				popularCharacters[pos][char]++
			}
		}
	}

	// Create placeholders
	res := strings.Repeat(" ", len(popularCharacters))

	for pos, chars := range popularCharacters {
		var leastPopular rune
		var leastPopularCount int

		for char, count := range chars {
			if count < leastPopularCount || leastPopularCount == 0 {
				leastPopularCount = count
				leastPopular = char
			}
		}

		// Set char
		res = res[:pos] + string(leastPopular) + res[pos+1:]
	}

	return res
}
