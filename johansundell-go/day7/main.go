package main

import (
	"fmt"
	"log"
	"strings"

	"github.com/johansundell/advent_of_code_2016/johansundell-go/adventofcode2016"
)

func main() {
	data, err := adventofcode2016.GetInput("day7.txt")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(parseInput(strings.Split(data, "\n")))
}

func parseInput(inputs []string) (part1, part2 int) {
	for _, input := range inputs {
		if supportsTls(input) {
			part1++
		}
		if supportsSsl(input) {
			part2++
		}
	}
	return
}

func supportsSsl(input string) bool {
	outside, inside := parseIp(input)
	abas := make([]string, 0)
	for _, str := range outside {
		abas = append(abas, getAba(str)...)
	}
	for _, inside := range inside {
		for _, aba := range abas {
			if strings.Contains(inside, aba) {
				return true
			}
		}
	}
	return false
}

func supportsTls(input string) bool {
	outside, inside := parseIp(input)
	foundAbba := false
	for _, str := range outside {
		if hasAbba(str) {
			foundAbba = true
		}
	}
	if foundAbba {
		for _, str := range inside {
			if hasAbba(str) {
				return false
			}
		}
	}
	return foundAbba
}

func parseIp(input string) ([]string, []string) {
	fields := strings.FieldsFunc(input, func(c rune) bool { return c == '[' || c == ']' })
	outside := make([]string, 0)
	inside := make([]string, 0)
	for i := 0; i < len(fields); i++ {
		if i%2 == 0 {
			outside = append(outside, fields[i])
		} else {
			inside = append(inside, fields[i])
		}
	}
	return outside, inside
}

func hasAbba(input string) bool {
	if len(input) < 4 {
		return false
	}
	c := make([]byte, 3)
	c[0], c[1], c[2] = input[0], input[1], input[2]
	for i := 3; i < len(input); i++ {
		current := input[i]
		if c[0] == current && c[1] == c[2] && c[0] != c[1] {
			return true
		}
		c[0], c[1], c[2] = c[1], c[2], current
	}
	return false
}

func getAba(input string) []string {
	result := make([]string, 0)
	if len(input) < 3 {
		return result
	}
	c := make([]byte, 2)
	c[0], c[1] = input[0], input[1]
	for i := 2; i < len(input); i++ {
		current := input[i]
		if c[0] == current && c[1] != current {
			result = append(result, string(c[1])+string(c[0])+string(c[1]))
		}
		c[0], c[1] = c[1], current
	}
	return result
}
