package main

import (
	"fmt"
	"log"
	"strconv"
	"strings"

	"github.com/johansundell/advent_of_code_2016/johansundell-go/adventofcode2016"
)

var screen []string

func main() {
	data, err := adventofcode2016.GetInput("day8.txt")
	if err != nil {
		log.Fatal(err)
	}
	parseInput(strings.Split(data, "\n"), 6, 50)
}

func printScreen() {
	count := 0
	for k, v := range screen {
		fmt.Println(k, v)
		count += strings.Count(v, "#")
	}
	fmt.Println(count)
}

func parseInput(inputs []string, h, l int) {
	screen = make([]string, h)
	for i := 0; i < h; i++ {
		screen[i] = strings.Repeat("=", l)
	}

	for _, str := range inputs {
		executeInstruction(str)
	}
	printScreen()
}

func executeInstruction(input string) {
	fields := strings.Fields(input)
	switch fields[0] {
	case "rect":
		a := strings.FieldsFunc(fields[1], func(r rune) bool { return r == 'x' })
		x, _ := strconv.Atoi(a[0])
		y, _ := strconv.Atoi(a[1])
		drawRect(x, y)
	case "rotate":
		a := strings.FieldsFunc(fields[2], func(r rune) bool { return r == '=' })
		n, _ := strconv.Atoi(a[1])
		l, _ := strconv.Atoi(fields[4])
		rotate(fields[1], n, l)
	}
}

func drawRect(x, y int) {
	for i := 0; i < y; i++ {
		part := []rune(screen[i])
		for n := 0; n < x; n++ {
			part[n] = '#'
		}
		screen[i] = string(part)
	}
}

func rotate(direction string, n, l int) {
	switch direction {
	case "column":
		str := getColumn(n)
		str = str[len(str)-l:] + str[:len(str)-l]
		setColumn(n, str)
	case "row":
		screen[n] = screen[n][len(screen[n])-l:] + screen[n][:len(screen[n])-l]
	}
}

func getColumn(n int) (str string) {
	for i := 0; i < len(screen); i++ {
		str += string(screen[i][n])
	}
	return
}

func setColumn(n int, str string) {
	for i := 0; i < len(screen); i++ {
		part := []rune(screen[i])
		part[n] = rune(str[i])
		screen[i] = string(part)
	}
}
