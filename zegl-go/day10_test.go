package main

import (
	"io/ioutil"
	"os"
	"testing"
)

func TestDay10examples(t *testing.T) {
	instructions := `value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2`

	responsible := day10part1(instructions, 5, 2, true)

	if responsible != "2" {
		t.Error(responsible)
	}
}

func TestDay10Part1(t *testing.T) {
	f, err := os.OpenFile("day10_input.txt", os.O_RDONLY, 0)

	if err != nil {
		t.Error(err)
		return
	}

	all, _ := ioutil.ReadAll(f)

	responsible := day10part1(string(all), 61, 17, true)

	if responsible != "147" {
		t.Error("found wrong value")
	}

	t.Log(responsible)
}

func TestDay10Part2(t *testing.T) {
	f, err := os.OpenFile("day10_input.txt", os.O_RDONLY, 0)

	if err != nil {
		t.Error(err)
		return
	}

	all, _ := ioutil.ReadAll(f)

	t.Log(day10part2(string(all), 61, 17))
}
