package main

import (
	"regexp"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
	"strconv"
	"fmt"
)

type disc struct {
	nPos int
	sPos int
	offset int
}

func main () {
	fmt.Printf("First time Part 1: %v, Part 2: %v", findTiming(false), findTiming(true))
}

func findTiming(part2 bool) int{
	discs := parseInput()
	if part2 {
		discs = append(discs, disc{nPos: 11, sPos: 0, offset: len(discs)+1})
	}
	found := 0
	for i := 0; true; i++{
		for _, v := range discs{
			curPos := (i + v.sPos + v.offset) % v.nPos

			if curPos == 0 {
				found++

			} else {
				found = 0
			}

		}
		if found == len(discs) {
			return i
		}
	}
	return -1
}


func parseInput() []disc {
	re := regexp.MustCompile(`\d+`)
	discs := []disc{}
	for _, v := range common.ReadFileByRow(`input.txt`) {
		dig := re.FindAllString(v, -1)
		offset, _ := strconv.Atoi(dig[0])
		nPos, _ := strconv.Atoi(dig[1])
		sPos, _ := strconv.Atoi(dig[3])
		discs = append(discs, disc{nPos: nPos, offset: offset, sPos: sPos})
	}
	return discs
}