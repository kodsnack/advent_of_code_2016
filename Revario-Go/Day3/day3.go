package main

import (
	"fmt"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
	"log"
	"regexp"
	"sort"
	"strconv"
)

func main() {
	fmt.Printf("Number of valid triangles: Part 1: %v, Part 2: %v", countValidTriangles(), countValidTrianglesPart2())
}

func countValidTriangles() int {
	input := common.ReadFileByRow(`input.txt`)
	regex := regexp.MustCompile(`\w+`)
	numberOfValid := 0

	for _, v := range input {

		strSides := regex.FindAllString(v, -1)
		sides := []int{}

		for _, v := range strSides {
			if v == "" {
				continue
			}
			if side, ok := strconv.Atoi(v); ok == nil {
				sides = append(sides, side)
			} else {
				log.Panic(ok)
			}
		}
		if isValidTriangle(sides) {
			numberOfValid++
		}
	}
	return numberOfValid
}

func isValidTriangle(sideLengths []int) bool {
	sort.Ints(sideLengths)

	if sideLengths[0]+sideLengths[1] > sideLengths[2] {
		return true
	}

	return false
}

func countValidTrianglesPart2() int {
	input := common.ReadFileByRow(`input.txt`)
	inputLen := len(input)
	regex := regexp.MustCompile(`\w+`)

	numbers := make([][]int, 3)
	for i := range numbers {
		numbers[i] = make([]int, inputLen)
	}

	//col, row := 0, 0

	for i, row := range input {
		strSides := regex.FindAllString(row, -1)
		for j, v := range strSides {
			var ok error
			if numbers[j][i], ok = strconv.Atoi(v); ok != nil {
				log.Panic(ok)
			}
		}
	}

	numValid := 0
	for i := 0; i < 3; i++ {
		for j := 0; j < inputLen; j += 3 {
			if isValidTriangle(numbers[i][j : j+3]) {
				numValid++
			}
		}
	}

	return numValid
}
