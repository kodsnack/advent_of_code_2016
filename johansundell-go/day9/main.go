package main

import (
	"fmt"
	"log"
	"strconv"
	"strings"

	"github.com/johansundell/advent_of_code_2016/johansundell-go/adventofcode2016"
)

var xFn = func(r rune) bool { return r == 'x' }

func main() {
	data, err := adventofcode2016.GetInput("day9.txt")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(parseInput(data, false), parseInput(data, true))
}

func parseInput(input string, isPart2 bool) int {
	count := 0
	for {
		startPos := strings.Index(input, "(")
		endPos := strings.Index(input, ")")
		if startPos == -1 {
			return count + len(input)
		}
		count += startPos
		fields := strings.FieldsFunc(input[startPos+1:endPos], xFn)
		chars, _ := strconv.Atoi(fields[0])
		repeat, _ := strconv.Atoi(fields[1])
		part := ""
		for n := 0; n < repeat; n++ {
			part += input[endPos+1 : endPos+1+chars]
		}
		if strings.Contains(part, "(") && isPart2 {
			count += parseInput(part, isPart2)
		} else {
			count += len(part)
		}
		input = input[endPos+1+chars:]
	}
}
