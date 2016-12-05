package main

import (
	"testing"
)

func TestDay5abc(t *testing.T) {
	r := day5_part1("abc")
	if r != "18f47a30" {
		t.Error("Unexpecter result:", r)
	}
}

func TestDay5abcPart2(t *testing.T) {
	r := day5_part2("abc")
	if r != "05ace8e3" {
		t.Error("Unexpecter result:", r)
	}
}

func TestDay5Part1(t *testing.T) {
	t.Log(day5_part1("reyedfim"))
}

func TestDay5Part2(t *testing.T) {
	t.Log(day5_part2("reyedfim"))
}
