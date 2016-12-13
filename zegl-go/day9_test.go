package main

import (
	"io/ioutil"
	"os"
	"testing"
)

func TestDay9examples(t *testing.T) {
	tests := map[string]string{
		"ADVENT":            "ADVENT",
		"A(1x5)BC":          "ABBBBBC",
		"(3x3)XYZ":          "XYZXYZXYZ",
		"A(2x2)BCD(2x2)EFG": "ABCBCDEFEFG",
		"(6x1)(1x3)A":       "(1x3)A",
		"(6x1)(1x3)  A":     "(1x3)A",
		"X(8x2)(3x3)ABCY":   "X(3x3)ABC(3x3)ABCY",
	}

	for input, expected := range tests {
		res := day9part1(input)

		if res != expected {
			t.Error(input, "expected:", expected, "got:", res)
		}
	}
}

func TestDay9examplesrecursive(t *testing.T) {
	tests := map[string]int{
		"(3x3)XYZ":                                                 9,
		"X(8x2)(3x3)ABCY":                                          20,
		"(27x12)(20x12)(13x14)(7x10)(1x12)A":                       241920,
		"(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN": 445,
	}

	for input, expected := range tests {
		res := day9part2(input)

		if res != expected {
			t.Error(input, "expected:", expected, "got:", res)
		}
	}
}

func TestDay9Part1(t *testing.T) {
	f, err := os.OpenFile("day9_input.txt", os.O_RDONLY, 0)

	if err != nil {
		t.Error(err)
		return
	}

	all, _ := ioutil.ReadAll(f)

	t.Log(len(day9part1(string(all))))
}

func TestDay9Part2(t *testing.T) {
	f, err := os.OpenFile("day9_input.txt", os.O_RDONLY, 0)

	if err != nil {
		t.Error(err)
		return
	}

	all, _ := ioutil.ReadAll(f)

	t.Log(day9part2(string(all)))
}
