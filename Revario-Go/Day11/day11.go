package main

import (
	"fmt"
	"sort"
	"strconv"
	"strings"
)

var part1 = state{{0, 0}, {1, 0}, {1, 0}, {2, 2}, {2, 2}}
var part2 = state{{0, 0}, {1, 0}, {1, 0}, {2, 2}, {2, 2}, {0, 0}, {0, 0}}

type state []element

type elevator struct {
	state    state
	position int
	steps    int
}

type element [2]int

func main() {
	fmt.Printf("Part 1: %v, Part 2: %v", findLeastMoves(part1), findLeastMoves(part2))

}

func findLeastMoves(start state) int {
	var prevStates = make(map[string]bool)

	queue := []elevator{{state: start, position: 0, steps: 0}}
	if !queue[0].state.isValid(queue[0].position, prevStates) {
		panic("Incorrect starting value")
	}

	for len(queue) > 0 {
		e := queue[0]

		elPos, moves := e.findSteps(prevStates)

		for i := range moves {
			queue = append(queue, (e.move(elPos[i], moves[i])))

			if e.targetReached() {
				return e.steps
			}

		}

		queue = queue[1:]

	}
	return -1
}

func (s state) isValid(ePos int, prevStates map[string]bool) bool {

	comGen := ``
	splGen := ``
	for _, v := range s {
		if v[0] == v[1] {
			comGen += strconv.Itoa(v[0])
			continue
		} else {
			splGen += strconv.Itoa(v[0]) + strconv.Itoa(v[1])
		}
		for _, vv := range s {
			if v[0] == vv[1] {

				return false
			}
		}
	}

	co := strings.Split(comGen, ``)
	sort.Strings(co)
	comGen = strings.Join(co, ``)
	st := comGen + `:` + splGen + strconv.Itoa(ePos)
	if _, ok := prevStates[st]; ok == true {

		return false
	} else {
		prevStates[st] = true
	}

	return true
}

func (e elevator) findSteps(prevStates map[string]bool) ([]int, []state) {
	availMoves, elPos := []state{}, []int{}
	for i, v := range e.state {
		for n, l := range v {

			move := make(state, len(e.state))
			copy(move, e.state)

			if l == e.position {
				if e.position != 3 {
					move = make(state, len(e.state))
					copy(move, e.state)
					move[i][n]++
					if move.isValid(e.position+1, prevStates) {
						availMoves = append(availMoves, move)

						elPos = append(elPos, e.position+1)
					}

				}
				if e.position != 0 {
					move = make(state, len(e.state))
					copy(move, e.state)
					move[i][n]--
					if move.isValid(e.position-1, prevStates) {
						availMoves = append(availMoves, move)
						elPos = append(elPos, e.position-1)
					}
				}

				for ii, vv := range e.state {
					for nn, ll := range vv {
						if ii <= i && nn <= n {
							continue
						}

						if !(i == ii && n == nn) && ll == e.position {

							if e.position != 3 {
								move = make(state, len(e.state))
								copy(move, e.state)
								move[i][n]++
								move[ii][nn]++
								if move.isValid(e.position+1, prevStates) {
									availMoves = append(availMoves, move)
									elPos = append(elPos, e.position+1)
								}
							}
							if e.position != 0 {
								move = make(state, len(e.state))
								copy(move, e.state)
								move[i][n]--
								move[ii][nn]--
								if move.isValid(e.position-1, prevStates) {
									availMoves = append(availMoves, move)
									elPos = append(elPos, e.position-1)
								}
							}
						}
					}
				}
			}
		}
	}
	return elPos, availMoves
}

func (e elevator) targetReached() bool {

	for _, v := range e.state {
		for _, n := range v {
			if n != 3 {
				return false
			}
		}
	}
	return true
}

func (e elevator) move(newPos int, s state) elevator {
	if newPos-e.position == 0 {
		panic("No move")
	}

	el := elevator{position: newPos, steps: e.steps + 1, state: s}

	return el
}
