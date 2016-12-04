package main

import (
	"io/ioutil"
	"os"
	"strings"
	"testing"
)

func TestDay4IsValid(t *testing.T) {
	tests := map[string]bool{
		"aaaaa-bbb-z-y-x-123[abxyz]":   true,
		"a-b-c-d-e-f-g-h-987[abcde]":   true,
		"not-a-real-room-404[oarel]":   true,
		"totally-real-room-200[decoy]": false,
	}

	for test, expected := range tests {
		_, isValid := day4parser(test)
		if isValid != expected {
			t.Error("Expected", test, "to be", expected)
		}
	}
}

func TestDay4Part1(t *testing.T) {
	f, err := os.OpenFile("day4_input.txt", os.O_RDONLY, 0)

	if err != nil {
		t.Error(err)
		return
	}

	all, _ := ioutil.ReadAll(f)

	rows := strings.Split(string(all), "\n")

	sum := 0

	for _, input := range rows {
		sectorID, isValid := day4parser(input)

		if isValid {
			sum += sectorID
		}
	}

	t.Log(sum)
}

func TestDay4Chifter(t *testing.T) {
	if day4shitfChiper("qzmt-zixmtkozy-ivhz-343[abc]") != "very encrypted name" {
		t.Error("Invalid decrypter")
	}
}

func TestDay4Part2(t *testing.T) {
	f, err := os.OpenFile("day4_input.txt", os.O_RDONLY, 0)

	if err != nil {
		t.Error(err)
		return
	}

	all, _ := ioutil.ReadAll(f)

	rows := strings.Split(string(all), "\n")

	for _, input := range rows {
		sectorID, isValid := day4parser(input)

		if isValid {
			if day4shitfChiper(input) == "northpole object storage" {
				t.Log(sectorID)
			}
		}
	}
}
