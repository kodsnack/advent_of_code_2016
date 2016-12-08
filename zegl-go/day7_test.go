package main

import (
	"io/ioutil"
	"os"
	"strings"
	"testing"
)

func TestDay7TestsPart1(t *testing.T) {
	tests := map[string]bool{
		"abba[mnop]qrst":       true,
		"abcd[bddb]xyyx":       false,
		"aaaa[qwer]tyui":       false,
		"ioxxoj[asdfgh]zxcvbn": true,
	}

	for ip, expected := range tests {
		if day7_part1(ip) != expected {
			t.Error("Wrong result:", ip)
		}
	}
}

func TestDay7Part1(t *testing.T) {
	f, err := os.OpenFile("day7_input.txt", os.O_RDONLY, 0)

	if err != nil {
		t.Error(err)
		return
	}

	all, _ := ioutil.ReadAll(f)
	rows := strings.Split(string(all), "\n")

	count := 0

	for _, row := range rows {
		if day7_part1(row) {
			count++
		}
	}

	t.Log(count)
}

func TestDay7TestsPart2(t *testing.T) {
	tests := map[string]bool{
		"aba[bab]xyz":   true,
		"xyx[xyx]xyx":   false,
		"aaa[kek]eke":   true,
		"zazbz[bzb]cdb": true,
	}

	for ip, expected := range tests {
		if day7_part2(ip) != expected {
			t.Error("Wrong result:", ip)
		}
	}
}

func TestDay7Part2(t *testing.T) {
	f, err := os.OpenFile("day7_input.txt", os.O_RDONLY, 0)

	if err != nil {
		t.Error(err)
		return
	}

	all, _ := ioutil.ReadAll(f)
	rows := strings.Split(string(all), "\n")

	count := 0

	for _, row := range rows {
		if day7_part2(row) {
			count++
		}
	}

	// 238 is too low
	// 363 is too high
	t.Log(count)
}
