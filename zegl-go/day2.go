package main

import (
	"strconv"
	"strings"
)

func day2part1(ins string) string {
	instructions := strings.Split(ins, "\n")

	currentKey := 5

	var code string

	for _, instruction := range instructions {
		for _, direction := range instruction {

			switch direction {
			case 'U':
				if currentKey > 3 {
					currentKey = currentKey - 3
				}

			case 'D':
				if currentKey < 7 {
					currentKey = currentKey + 3
				}

			case 'L':
				if currentKey != 1 && currentKey != 4 && currentKey != 7 {
					currentKey--
				}

			case 'R':
				if currentKey != 3 && currentKey != 6 && currentKey != 9 {
					currentKey++
				}
			}
		}

		code += strconv.Itoa(currentKey)
	}

	return code
}

func day2part2(ins string) string {
	instructions := strings.Split(ins, "\n")

	var code string

	display := [][]rune{
		[]rune{' ', ' ', '1', ' ', ' '},
		[]rune{' ', '2', '3', '4', ' '},
		[]rune{'5', '6', '7', '8', '9'},
		[]rune{' ', 'A', 'B', 'C', ' '},
		[]rune{' ', ' ', 'D', ' ', ' '},
	}

	posX, posY := 0, 2

	for _, instruction := range instructions {
		for _, direction := range instruction {

			switch direction {
			case 'U':
				if posY > 0 {
					if display[posY-1][posX] != ' ' {
						posY--
					}
				}

			case 'D':
				if posY < 4 {
					if display[posY+1][posX] != ' ' {
						posY++
					}
				}

			case 'L':
				if posX > 0 {
					if display[posY][posX-1] != ' ' {
						posX--
					}
				}

			case 'R':
				if posX < 4 {
					if display[posY][posX+1] != ' ' {
						posX++
					}
				}
			}
		}

		code += string(display[posY][posX])
	}

	return code
}
