package main

import (
	"strconv"
	"strings"
)

func day9part1(input string) string {
	out := ""

	inRepeationHeader := false
	repetitionHeaderHaveCharsCount := false
	repeatCharsCount := "" // how many chars to repeat
	repetitionAmount := "" // how many times to repeat

	skip := 0

	for i, char := range input {

		if len(strings.TrimSpace(string(char))) == 0 {
			continue
		}

		if skip > 0 {
			skip--
			continue
		}

		if char == '(' {
			inRepeationHeader = true
			repetitionHeaderHaveCharsCount = false
			repeatCharsCount = ""
			repetitionAmount = ""
			continue
		}

		if char == ')' {
			inRepeationHeader = false

			charCount, _ := strconv.Atoi(repeatCharsCount)
			amount, _ := strconv.Atoi(repetitionAmount)

			ii := 0
			skippedWhitespace := 0

			compressed := ""

			for ii < charCount {
				pos := i + ii + 1 + skippedWhitespace

				if len(strings.TrimSpace(string(input[pos]))) == 0 {
					skippedWhitespace++
					continue
				}

				ii++
				compressed += string(input[pos])
			}

			expanded := strings.Repeat(compressed, amount)

			out += expanded
			skip = charCount

			continue
		}

		if inRepeationHeader {
			if char == 'x' {
				repetitionHeaderHaveCharsCount = true
				continue
			}

			if !repetitionHeaderHaveCharsCount {
				repeatCharsCount += string(char)
			} else {
				repetitionAmount += string(char)
			}

			continue
		}

		out += string(char)
	}

	return out
}

func day9part2(input string) int {
	decompressedLength := 0

	inRepeationHeader := false
	repetitionHeaderHaveCharsCount := false
	repeatCharsCount := "" // how many chars to repeat
	repetitionAmount := "" // how many times to repeat

	skip := 0

	for i, char := range input {

		if len(strings.TrimSpace(string(char))) == 0 {
			continue
		}

		if skip > 0 {
			skip--
			continue
		}

		if char == '(' {
			inRepeationHeader = true
			repetitionHeaderHaveCharsCount = false
			repeatCharsCount = ""
			repetitionAmount = ""
			continue
		}

		if char == ')' {
			inRepeationHeader = false

			charCount, _ := strconv.Atoi(repeatCharsCount)
			amount, _ := strconv.Atoi(repetitionAmount)

			ii := 0
			skippedWhitespace := 0

			compressed := ""

			for ii < charCount {
				pos := i + ii + 1 + skippedWhitespace

				if len(strings.TrimSpace(string(input[pos]))) == 0 {
					skippedWhitespace++
					continue
				}

				ii++
				compressed += string(input[pos])
			}

			decompressedLength += day9part2(compressed) * amount
			skip = charCount

			continue
		}

		if inRepeationHeader {
			if char == 'x' {
				repetitionHeaderHaveCharsCount = true
				continue
			}

			if !repetitionHeaderHaveCharsCount {
				repeatCharsCount += string(char)
			} else {
				repetitionAmount += string(char)
			}

			continue
		}

		decompressedLength++
	}

	return decompressedLength
}
