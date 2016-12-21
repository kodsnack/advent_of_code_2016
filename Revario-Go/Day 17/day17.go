package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
)

var input = `rrrbmfta`

type path struct {
	prevSteps []rune
	currPos   [2]int
}

func main() {

	fmt.Printf("Steps for shortest path: %v, lenght of longest path: %v", findShortestPath(), findLongestPath())

}

func (p path) isTarget() bool {
	if p.currPos[0] == 3 && p.currPos[1] == 3 {
		return true
	}
	return false
}

func findShortestPath() string {

	queue := []path{{currPos: [2]int{0, 0}}}

	for len(queue) > 0 {
		if queue[0].isTarget() {
			return string(queue[0].prevSteps)
		}
		moves := queue[0].findSteps()
		queue = append(queue, moves...)
		queue = queue[1:]
	}
	return `No PATH`
}

func findLongestPath() int {

	queue := []path{{currPos: [2]int{0, 0}}}
	longest := 0
	for len(queue) > 0 {
		if queue[0].isTarget() {
			if longest < len(queue[0].prevSteps) {
				longest = len(queue[0].prevSteps)
			}
			queue = queue[1:]

		}
		moves := queue[0].findSteps()
		queue = append(queue, moves...)
		queue = queue[1:]
	}
	return longest
}

func (p path) Append(r rune) []rune {
	a := make([]rune, len(p.prevSteps))
	copy(a, p.prevSteps)
	a = append(a, r)
	return a
}

func (p path) findSteps() []path {

	steps := []path{}
	od := openDoors(hash(p.prevSteps))

	if od['U'] == true && p.currPos[1] > 0 {
		c := p.currPos
		c[1]--
		steps = append(steps, path{prevSteps: p.Append('U'), currPos: c})
	}

	if od['D'] == true && p.currPos[1] < 3 {
		c := p.currPos
		c[1]++
		steps = append(steps, path{prevSteps: p.Append('D'), currPos: c})
	}
	if od['L'] == true && p.currPos[0] > 0 {
		c := p.currPos
		c[0]--
		steps = append(steps, path{prevSteps: p.Append('L'), currPos: c})
	}
	if od['R'] == true && p.currPos[0] < 3 {
		c := p.currPos
		c[0]++
		steps = append(steps, path{prevSteps: p.Append('R'), currPos: c})
	}
	return steps
}

func openDoors(hash string) map[rune]bool {
	openDoors := make(map[rune]bool)

	doors := [...]rune{'U', 'D', 'L', 'R'}

	for i, v := range doors {
		if hash[i] >= 'b' && hash[i] <= 'f' {
			openDoors[v] = true
		}
	}
	return openDoors
}

func hash(path []rune) string {
	hash := md5.Sum([]byte(input + string(path)))
	he := hex.EncodeToString([]byte(hash[:]))
	return he
}
