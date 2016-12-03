package main

import (
	"fmt"
	"log"
	"sort"
	"strconv"
	"strings"

	"github.com/johansundell/advent_of_code_2016/johansundell-go/adventofcode2016"
)

func main() {
	data, err := adventofcode2016.GetInput("day3.txt")
	if err != nil {
		log.Fatal(err)
	}

	inputs := strings.Split(data, "\n")
	part1, part2 := doCount(inputs)
	fmt.Println("Answer part one", part1, "answer part two", part2)
}

func doCount(inputs []string) (part1, part2 int) {
	t1 := make([]int, 3)
	t2 := make([]int, 3)
	t3 := make([]int, 3)
	for i := 0; i < len(inputs); i++ {
		t := fixInput(inputs[i])
		t1[i%3], t2[i%3], t3[i%3] = t[0], t[1], t[2]
		if i%3 == 2 {
			if isValid(t1) {
				part2++
			}
			if isValid(t2) {
				part2++
			}
			if isValid(t3) {
				part2++
			}
		}
		if isValid(t) {
			part1++
		}
	}
	return
}

func isValid(ints []int) bool {
	sort.Ints(ints)
	return ints[0]+ints[1] > ints[2]
}

func fixInput(str string) []int {
	s := strings.Fields(str)
	t := make([]int, 3)
	if len(s) == 3 {
		t[0], _ = strconv.Atoi(s[0])
		t[1], _ = strconv.Atoi(s[1])
		t[2], _ = strconv.Atoi(s[2])
	}
	return t
}
