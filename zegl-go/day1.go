package main

import (
	"fmt"
	"math"
	"strconv"
	"strings"
)

func day1part1(input string) int {
	instructions := strings.Split(input, ", ")

	// 0 = North
	// 1 = East
	// 2 = South
	// 3 = West
	currentlyFacing := 0
	currentX := 0
	currentY := 0

	for _, ins := range instructions {
		// Left or right
		lorr := ins[0]

		if lorr == 'R' {
			// Turn right
			currentlyFacing++
		} else {
			// Turn left
			currentlyFacing--
		}

		// Correct over and underflows
		if currentlyFacing < 0 {
			currentlyFacing = 3
		}

		if currentlyFacing > 3 {
			currentlyFacing = 0
		}

		steps, _ := strconv.Atoi(ins[1:])

		switch currentlyFacing {
		case 0:
			currentY += steps
		case 1:
			currentX += steps
		case 2:
			currentY -= steps
		case 3:
			currentX -= steps
		}
	}

	return int(math.Abs(float64(currentX)) + math.Abs(float64(currentY)))
}

func day1part2(input string) int {
	instructions := strings.Split(input, ", ")

	// 0 = North
	// 1 = East
	// 2 = South
	// 3 = West
	currentlyFacing := 0
	currentX := 0
	currentY := 0

	visited := make(map[string]bool)

	for _, ins := range instructions {
		// Left or right
		lorr := ins[0]

		if lorr == 'R' {
			// Turn right
			currentlyFacing++
		} else {
			// Turn left
			currentlyFacing--
		}

		// Correct over and underflows
		if currentlyFacing < 0 {
			currentlyFacing = 3
		}

		if currentlyFacing > 3 {
			currentlyFacing = 0
		}

		steps, _ := strconv.Atoi(ins[1:])

		for i := 0; i < steps; i++ {

			switch currentlyFacing {
			case 0:
				currentY++
			case 1:
				currentX++
			case 2:
				currentY--
			case 3:
				currentX--
			}

			key := strconv.Itoa(currentX) + "," + strconv.Itoa(currentY)

			// We have already visited this location
			if _, ok := visited[key]; ok {
				return int(math.Abs(float64(currentX)) + math.Abs(float64(currentY)))
			}

			visited[key] = true

		}
	}

	fmt.Println("Did not find duplicate?")
	return 0
}
