// 2016 project main.go
package main

import (
	"fmt"
	"log"
	"math"
	"strconv"
	"strings"

	"github.com/johansundell/advent_of_code_2016/johansundell-go/adventofcode2016"
)

type point struct {
	x, y int
}

func (p point) distance() int {
	return int(math.Abs(float64(p.x)) + math.Abs(float64(p.y)))
}

func main() {
	str, err := adventofcode2016.GetInput("day1.txt")
	if err != nil {
		log.Fatal(err)
	}
	n, p := walk(str)
	fmt.Println("Part 1 distance", n, "Part 2 distance", p.distance())

}

func walk(input string) (int, point) {
	x, y, d := 0, 0, 0
	points := make(map[point]int)
	var found bool
	p := point{}
	for _, r := range strings.Split(input, ", ") {
		s := string(r[0])
		i, _ := strconv.Atoi(r[1:])

		if s == "R" {
			d++
		} else {
			d--
		}

		for n := 0; n < i; n++ {
			switch d % 4 {
			case 0: // N
				y++
			case 1, -3: // E
				x++
			case 2, -2: // S
				y--
			case 3, -1: // W
				x--
			}
			points[point{x, y}]++
			if !found && points[point{x, y}] == 2 {
				p = point{x, y}
				found = true
			}
		}
	}

	return int(math.Abs(float64(x)) + math.Abs(float64(y))), p
}
