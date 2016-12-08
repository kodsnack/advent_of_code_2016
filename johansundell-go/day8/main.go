package main

import (
	"log"
	"strings"

	"github.com/johansundell/advent_of_code_2016/johansundell-go/adventofcode2016"
	"github.com/johansundell/advent_of_code_2016/johansundell-go/day8/screens"
)

func main() {
	data, err := adventofcode2016.GetInput("day8.txt")
	if err != nil {
		log.Fatal(err)
	}
	parseInput(strings.Split(data, "\n"), 6, 50)
}

func parseInput(inputs []string, h, l int) {
	screen := screens.NewScreen(h, l)
	for _, str := range inputs {
		screen.ExecuteInstruction(str)
	}
	screen.PrintScreen()
}
