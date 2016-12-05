package main

import (
	"fmt"
	"math"
	"strconv"
	"strings"
)

func main() {
	fmt.Println(day1part1("L3, R2, L5, R1, L1, L2, L2, R1, R5, R1, L1, L2, R2, R4, L4, L3, L3, R5, L1, R3, L5, L2, R4, L5, R4, R2, L2, L1, R1, L3, L3, R2, R1, L4, L1, L1, R4, R5, R1, L2, L1, R188, R4, L3, R54, L4, R4, R74, R2, L4, R185, R1, R3, R5, L2, L3, R1, L1, L3, R3, R2, L3, L4, R1, L3, L5, L2, R2, L1, R2, R1, L4, R5, R4, L5, L5, L4, R5, R4, L5, L3, R4, R1, L5, L4, L3, R5, L5, L2, L4, R4, R4, R2, L1, L3, L2, R5, R4, L5, R1, R2, R5, L2, R4, R5, L2, L3, R3, L4, R3, L2, R1, R4, L5, R1, L5, L3, R4, L2, L2, L5, L5, R5, R2, L5, R1, L3, L2, L2, R3, L3, L4, R2, R3, L1, R2, L5, L3, R4, L4, R4, R3, L3, R1, L3, R5, L5, R1, R5, R3, L1"))
}

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
