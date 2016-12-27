package main

import (
	"fmt"
	"strings"
)

var input = 1364

type position struct {
	x int
	y int
	steps int
}

func main () {
	fmt.Printf("Least number of steps: %v, number of reachable locations: %v", findLeastMoves(31, 39), findNumberOfLocations(50))
}

func findLeastMoves(targetX, targetY int) int {
	var prevPos = make(map[[2]int]bool)
	var knownMap = make(map[[2]int]bool)
	
	queue := []position{ {x:1, y:1, steps:0} }
	if !queue[0].isOpen(knownMap) {
		panic("Incorrect starting value")
	}
	finalPos := position{targetX, targetY, 0}
	if !finalPos.isOpen(knownMap){
		panic("Incorrect target value")
	}
	for len(queue) > 0 {
		p := queue[0]

		moves := p.findSteps(knownMap, prevPos)

		for _, m := range moves {
			queue = append(queue, m)

			if m.targetReached(targetX, targetY) {
				return m.steps
			}

		}

		queue = queue[1:]


	}

	return -1
}

func findNumberOfLocations(maxSteps int) int {
	var prevPos = make(map[[2]int]bool)
	var knownMap = make(map[[2]int]bool)

	queue := []position{ {x:1, y:1, steps:0} }
	if !queue[0].isOpen(knownMap) {
		panic("Incorrect starting value")
	}

	for len(queue) > 0 {
		p := queue[0]

		if p.steps < maxSteps {
			moves := p.findSteps(knownMap, prevPos)

			for _, m := range moves {
				queue = append(queue, m)
			}
		}
		queue = queue[1:]


	}
	locations := 0

	for _, v := range knownMap {
		if v == true {
			locations++
		}
	}
	return locations
}

func (p position) findSteps(knownMap map[[2]int]bool, prevPos map[[2]int]bool) []position{
	i := []int{1, -1}
	moves := []position{}
	for _, v := range i {
		if _, ok := prevPos[[2]int{p.x+v, p.y}]; !ok {
			nP := position{x: p.x+v, y: p.y, steps:p.steps+1}
			if nP.isOpen(knownMap){
				moves = append(moves, nP)
				prevPos[[2]int{p.x+v, p.y}] = true
			}
		}

		if _, ok := prevPos[[2]int{p.x, p.y+v}]; !ok {
			nP := position{x: p.x, y: p.y+v, steps: p.steps+1}
			if nP.isOpen(knownMap){
				moves = append(moves, nP)
				prevPos[[2]int{p.x, p.y+v}] = true
			}
		}
	}
	return moves
}



func (p position) isOpen(knownMap map[[2]int]bool) bool {
	if p.x < 0 || p.y < 0 {
		return false
	}

	if open, ok := knownMap[[2]int{p.x, p.y}]; ok {
		return open
	}



	if strings.Count(fmt.Sprintf("%b", p.x*p.x + 3*p.x + 2*p.x*p.y + p.y + p.y*p.y + input), `1`) % 2 == 0 {
		knownMap[[2]int{p.x, p.y}] = true
		return true
	}
	knownMap[[2]int{p.x, p.y}] = false
	return false
}

func (p position) targetReached(tX, tY int) bool{
	if p.x == tX && p.y == tY {
		return true
	}
	return false
}
