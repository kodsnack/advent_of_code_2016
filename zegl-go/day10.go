package main

import (
	"regexp"
	"sort"
	"strconv"
	"strings"
)

type day10bot struct {
	values []int

	giveLow  string
	giveHigh string

	giveLowToBot  bool
	giveHighToBot bool
}

type day10botlist map[string]*day10bot

var day10outputs map[string]int

func day10giveifhave2(bots day10botlist, botID string, matchA, matchB int, stopWhenFound bool) (day10botlist, string) {
	if len(bots[botID].values) == 2 {
		sort.Ints(bots[botID].values)

		low := bots[botID].values[0]
		high := bots[botID].values[1]

		if stopWhenFound {
			if matchA == low && matchB == high || matchB == low && matchA == high {
				return bots, botID
			}
		}

		giveLow := bots[botID].giveLow
		giveHigh := bots[botID].giveHigh

		if giveLow == "" || giveHigh == "" {
			return bots, ""
		}

		bots[botID].values = []int{}

		// create bots if not exists
		if _, ok := bots[giveLow]; !ok {
			bots[giveLow] = &day10bot{}
		}

		if _, ok := bots[giveHigh]; !ok {
			bots[giveHigh] = &day10bot{}
		}

		// Give to bot
		if bots[botID].giveLowToBot {
			bots[giveLow].values = append(bots[giveLow].values, low)
			newbotslist, responsible := day10giveifhave2(bots, bots[botID].giveLow, matchA, matchB, stopWhenFound)
			bots = newbotslist

			if responsible != "" && stopWhenFound {
				return bots, responsible
			}
		} else {
			day10outputs[giveLow] = low
		}

		// Give to bot
		if bots[botID].giveHighToBot {
			bots[giveHigh].values = append(bots[giveHigh].values, high)
			newbotslist2, responsible := day10giveifhave2(bots, bots[botID].giveHigh, matchA, matchB, stopWhenFound)
			bots = newbotslist2

			if responsible != "" && stopWhenFound {
				return bots, responsible
			}
		} else {
			day10outputs[giveHigh] = high
		}
	}

	return bots, ""
}

func day10part1(input string, matchA, matchB int, stopWhenFound bool) string {
	day10outputs = make(map[string]int)

	bots := make(day10botlist)

	instructions := strings.Split(input, "\n")

	valueToBot := regexp.MustCompile("value ([0-9]+) goes to bot ([0-9]+)")
	botCompare := regexp.MustCompile("bot ([0-9]+) gives low to (bot|output) ([0-9]+) and high to (bot|output) ([0-9]+)")

	for _, ins := range instructions {

		// Check all if they have 2
		for botID := range bots {
			responsible := ""
			bots, responsible = day10giveifhave2(bots, botID, matchA, matchB, stopWhenFound)

			if responsible != "" && stopWhenFound {
				return responsible
			}
		}

		if valueToBot.MatchString(ins) {
			m := valueToBot.FindAllStringSubmatch(ins, -1)[0]

			botID := m[2]
			itemValue, _ := strconv.Atoi(m[1])

			// Create bot
			if _, ok := bots[botID]; !ok {
				bots[botID] = &day10bot{}
			}

			// Add value
			bots[botID].values = append(bots[botID].values, itemValue)

			responsible := ""
			bots, responsible = day10giveifhave2(bots, botID, matchA, matchB, stopWhenFound)

			if responsible != "" && stopWhenFound {
				return responsible
			}
		}

		if botCompare.MatchString(ins) {
			m := botCompare.FindAllStringSubmatch(ins, -1)[0]

			botID := m[1]

			// Create bot
			if _, ok := bots[botID]; !ok {
				bots[botID] = &day10bot{}
			}

			bots[botID].giveLow = m[3]
			bots[botID].giveHigh = m[5]

			if m[2] == "bot" {
				bots[botID].giveLowToBot = true
			}

			if m[4] == "bot" {
				bots[botID].giveHighToBot = true
			}
		}
	}

	// Check all if they have 2
	for botID := range bots {
		responsible := ""
		bots, responsible = day10giveifhave2(bots, botID, matchA, matchB, stopWhenFound)

		if responsible != "" && stopWhenFound {
			return responsible
		}
	}

	return ""
}

func day10part2(input string, matchA, matchB int) int {
	day10part1(input, matchA, matchB, false)
	return day10outputs["0"] * day10outputs["1"] * day10outputs["2"]
}
