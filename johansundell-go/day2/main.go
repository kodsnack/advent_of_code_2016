package main

import (
	"fmt"
	"log"
	"strings"

	"github.com/johansundell/advent_of_code_2016/johansundell-go/adventofcode2016"
)

var (
	keypadOne = []string{"123", "456", "789"}
	keypadTwo = []string{"--1--", "-234-", "56789", "-ABC-", "--D--"}
)

func main() {
	test, err := adventofcode2016.GetInput("day2.txt")
	if err != nil {
		log.Fatal(err)
	}

	input := strings.Split(test, "\n")
	fmt.Println("First code:", getCode(input, keypadOne, 1, 1), "Second code", getCode(input, keypadTwo, 0, 2))
}

func getCode(input []string, keypad []string, x, y int) string {
	result := ""
	for _, str := range input {
		button := ""
		x, y, button = getButton(x, y, str, keypad)
		result += button
	}
	return result
}

func getButton(startX, startY int, row string, keypad []string) (x, y int, button string) {
	x, y = startX, startY
	for _, v := range row {
		switch string(v) {
		case "U":
			if y != 0 {
				if string(keypad[y-1][x]) != "-" {
					y--
				}
			}
		case "D":
			if y != len(keypad)-1 {
				if string(keypad[y+1][x]) != "-" {
					y++
				}
			}
		case "L":
			if x != 0 {
				if string(keypad[y][x-1]) != "-" {
					x--
				}
			}
		case "R":
			if x != len(keypad[y])-1 {
				if string(keypad[y][x+1]) != "-" {
					x++
				}
			}
		}
	}
	button = string(keypad[y][x])
	return
}
