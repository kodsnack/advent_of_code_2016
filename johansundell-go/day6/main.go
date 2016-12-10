package main

import (
	"fmt"
	"log"
	"strings"

	"github.com/johansundell/advent_of_code_2016/johansundell-go/adventofcode2016"
)

func main() {
	data, err := adventofcode2016.GetInput("day6.txt")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(parseInput(strings.Split(data, "\n")))
}

func parseInput(inputs []string) (part1, part2 string) {
	for i := 0; i < len(inputs[0]); i++ {
		str := ""
		for _, row := range inputs {
			str += string(row[i])
		}
		part1 += string(adventofcode2016.GetSortedCharList(str, false)[0].R)
		part2 += string(adventofcode2016.GetSortedCharList(str, true)[0].R)
	}
	return
}
