package main

import (
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
	"strconv"
	"fmt"
)

var keypad [3][3]int = [3][3]int{
	{1, 2, 3},
	{4, 5, 6},
	{7, 8, 9}}

var keypadPart2 [5][5]byte = [5][5]byte{
	{'0', '0', '1', '0', '0'},
	{'0', '2', '3', '4', '0'},
	{'5', '6', '7', '8', '9'},
	{'0', 'A', 'B', 'C', '0'},
	{'0', '0', 'D', '0', '0'}}


func main() {
	println(calculateCode())
}

func calculateCode() string {
	input := common.ReadFileByRow(`input.txt`)

	var code []int

	var codePart2 string

	var curXPos, curYPos int = 1, 1
	var curXPos2, curYPos2 int = 0, 2


	for _, v := range input {
		code = append(code, calculateDigit(v, &curXPos, &curYPos))
		codePart2 += calculateDigitPart2(v, &curXPos2, &curYPos2)
	}

	codeString := ``
	for _, v := range code {
		codeString += strconv.Itoa(v)
	}

	return fmt.Sprintf("Code Part 1: %v, Part 2: %v", codeString, string(codePart2))

}

func calculateDigitPart2(instruction string, curXPos2 *int, curYPos2 *int) string {
	for _, v := range instruction {

		switch v {
		case 'U':
			if *curYPos2 > 0 && keypadPart2[*curXPos2][*curYPos2-1] != '0' {
				*curYPos2--
			}
		case 'D':
			if *curYPos2 < 4 && keypadPart2[*curXPos2][*curYPos2+1] != '0' {
				*curYPos2++
			}
		case 'L':
			if *curXPos2 > 0 && keypadPart2[*curXPos2-1][*curYPos2] != '0' {
				*curXPos2--
			}
		case 'R':
			if *curXPos2 < 4 && keypadPart2[*curXPos2+1][*curYPos2] != '0' {
				*curXPos2++
			}
		}
	}
	return string(keypadPart2[*curYPos2][*curXPos2])

}


func calculateDigit(instruction string, curXPos *int, curYPos *int) int {

	for _, v := range instruction {
		switch v {
		case 'U':
			if *curYPos > 0 {
				*curYPos--
			}
		case 'D':
			if *curYPos < 2 {
				*curYPos++
			}
		case 'L':
			if *curXPos > 0 {
				*curXPos--
			}
		case 'R':
			if *curXPos < 2 {
				*curXPos++
			}
		}
	}
	return keypad[*curYPos][*curXPos]
}
