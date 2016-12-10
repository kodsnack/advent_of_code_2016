package main

import (
	"io/ioutil"
	"os"
	"strings"
	"testing"
)

func TestDay3part1invalid(t *testing.T) {
	invalid := []string{
		"5 10 25",
		"25 5 10",
		"10 25 5",
	}

	for _, input := range invalid {
		if day3isvalid(input) {
			t.Error("Reported ", input, "as valid")
		}
	}
}

func TestDay3part1valid(t *testing.T) {
	invalid := []string{
		"5 10 12",
		"5 10 6",
		"5 10 7",
	}

	for _, input := range invalid {
		if !day3isvalid(input) {
			t.Error("Reported ", input, "as not valid")
		}
	}
}

func TestDay3Part1(t *testing.T) {
	f, err := os.OpenFile("day3_input.txt", os.O_RDONLY, 0)

	if err != nil {
		t.Error(err)
		return
	}

	all, _ := ioutil.ReadAll(f)

	rows := strings.Split(string(all), "\n")

	count := 0

	for _, row := range rows {
		if day3isvalid(row) {
			count++
		}
	}

	t.Log(count)
}

func TestDay3Part2(t *testing.T) {
	f, err := os.OpenFile("day3_input.txt", os.O_RDONLY, 0)

	if err != nil {
		t.Error(err)
		return
	}

	all, _ := ioutil.ReadAll(f)

	rows := strings.Split(string(all), "\n")
	count := 0

	for row, input := range rows {
		if row%3 == 0 {
			inputs := day3part2organize([3]string{
				input,
				rows[row+1],
				rows[row+2],
			})

			for _, input := range inputs {
				if day3isvalid(input) {
					count++
				}
			}
		}
	}

	t.Log(count)
}
