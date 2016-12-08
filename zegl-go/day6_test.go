package main

import (
	"io/ioutil"
	"os"
	"testing"
)

func TestDay6Easter(t *testing.T) {
	res := day6_part1(`eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar`)

	if res != "easter" {
		t.Error(res)
	}
}

func TestDay6Part1(t *testing.T) {
	f, err := os.OpenFile("day6_input.txt", os.O_RDONLY, 0)

	if err != nil {
		t.Error(err)
		return
	}

	all, _ := ioutil.ReadAll(f)

	t.Log(day6_part1(string(all)))
}

func TestDay6Advent(t *testing.T) {
	res := day6_part2(`eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar`)

	if res != "advent" {
		t.Error(res)
	}
}

func TestDay6Part2(t *testing.T) {
	f, err := os.OpenFile("day6_input.txt", os.O_RDONLY, 0)

	if err != nil {
		t.Error(err)
		return
	}

	all, _ := ioutil.ReadAll(f)

	t.Log(day6_part2(string(all)))
}
