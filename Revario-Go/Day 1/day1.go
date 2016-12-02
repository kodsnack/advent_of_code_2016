package main

import (
	"fmt"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
	"strconv"
)

func main() {
	fmt.Printf("Block distance: %v, True location distance: %v", calculateBlocksFromStart(), calculateTrueDistance())
}

func calculateBlocksFromStart() int {
	input := common.ReadCSVFile("input.txt")

	dir := 0
	x, y := 0, 0

	for _, v := range input {
		walk(&x, &y, &dir, v)
	}

	return absolute(x) + absolute(y)
}

func calculateTrueDistance() int {

	input := common.ReadCSVFile("input.txt")
	dir := 0
	x, y := 0, 0

	locations := make(map[string]bool)
	locations["0 0"] = true

	for _, v := range input {

		dir = calculateDirection(dir, v[0])

		distance, _ := strconv.Atoi(v[1:])

		for i := 0; i < distance; i++ {
			step(&x, &y, dir)

			if _, ok := locations[strconv.Itoa(x)+" "+strconv.Itoa(y)]; ok {
				return absolute(x) + absolute(y)
			} else {
				locations[strconv.Itoa(x)+" "+strconv.Itoa(y)] = true
			}
		}


	}
	return -1
}

func absolute(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

func walk(x *int, y *int, dir *int, instruction string) {

	distance, err := strconv.Atoi(string(instruction[1:]))
	if err != nil {
		panic("Conversion error")
	}
	switch instruction[0] {
	case 'R':
		*dir += 90
		if *dir == 360 {
			*dir = 0
		}
	case 'L':
		*dir -= 90
		if *dir == -90 {
			*dir = 270
		}
	}
	switch *dir {
	case 0:
		*y += distance
	case 90:
		*x += distance
	case 180:
		*y -= distance
	case 270:
		*x -= distance
	}
}

func step(x *int, y *int, dir int) {

	switch dir {

	case 0:
		*y++
	case 90:
		*x++
	case 180:
		*y--
	case 270:
		*x--
	}

}

func calculateDirection(currentDirection int, turnInstruction byte) int {

	switch turnInstruction {
	case 'R':
		currentDirection += 90
		if currentDirection == 360 {
			currentDirection = 0
		}
	case 'L':
		currentDirection -= 90
		if currentDirection == -90 {
			currentDirection = 270
		}
	}

	return currentDirection
}
