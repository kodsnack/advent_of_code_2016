package main

import (
	"errors"
	"fmt"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
	"regexp"
	"strconv"
)

func main() {
	nm := parseInput()
	fmt.Printf("Number of valid nodes: %v, number of moves: %v", findPairs(), findMovesToAccessData(nm))
}

type node struct {
	size  int
	used  int
	avail int
}

type nodeMap [][]node

var suaRe = regexp.MustCompile(`(\d+)T`)
var nPosRe = regexp.MustCompile(`x(\d+)-y(\d+)`)

func findPairs() (num int) {
	input := common.ReadFileByRow(`input.txt`)

	for i, v := range input {
		_, used, _ := getSpace(v)
		if used == -1 || used == 0 {
			continue
		}
		for ii, vv := range input {
			if ii == i {
				continue
			}
			_, _, a := getSpace(vv)
			if a == -1 {
				continue
			}
			if used <= a {
				num++
			}
		}

	}
	return
}

func findMovesToAccessData(nm nodeMap) (n int) {
	n += findMovesForEmpty(nm)
	n += 5 * 32
	return n
}

//findMovesForEmpty returns the smallest number of moves required to place the "empty" position at x33, y0
func findMovesForEmpty(nm nodeMap) (n int) {

	e := findEmpty(nm)
	for e != [2]int{33, 0} {
		e = findEmpty(nm)
		if e[1] != 0 {
			if nm[e[0]][e[1]].isValid(nm[e[0]][e[1]-1]) {
				move(nm, e, [2]int{e[0], e[1] - 1})
				n++
			} else if nm[e[0]][e[1]].isValid(nm[e[0]-1][e[1]]) {
				move(nm, e, [2]int{e[0] - 1, e[1]})
				n++
			}
		} else if e[0] != 33 {
			if nm[e[0]][e[1]].isValid(nm[e[0]+1][e[1]]) {
				move(nm, e, [2]int{e[0] + 1, e[1]})
				n++
			}
		}
	}
	return
}

func move(nm nodeMap, p, t [2]int) {
	nm[p[0]][p[1]].used, nm[t[0]][t[1]].used = nm[t[0]][t[1]].used, nm[p[0]][p[1]].used
	nm[p[0]][p[1]].avail = nm[p[0]][p[1]].size - nm[p[0]][p[1]].used
	nm[t[0]][t[1]].avail = nm[t[0]][t[1]].size - nm[t[0]][t[1]].used
}

func findEmpty(nm nodeMap) [2]int {
	for i, v := range nm {
		for ii, vv := range v {
			if vv.used == 0 {
				return [2]int{i, ii}
			}
		}
	}
	return [2]int{}
}

func parseInput() nodeMap {
	input := common.ReadFileByRow(`input.txt`)
	nm := nodeMap{}
	nm = make([][]node, 34)
	for i := range nm {
		nm[i] = make([]node, 30)
	}

	for _, v := range input {
		x, y, err := parseNodePosition(v)

		if err != nil {
			continue
		}
		size, used, avail := getSpace(v)
		node := node{size: size, used: used, avail: avail}
		nm[x][y] = node
	}
	return nm
}

func (p node) isValid(t node) bool {

	if p == t {
		return false
	}
	if t.used <= p.avail {
		return true
	}
	return false
}

func getSpace(v string) (size, used, avail int) {
	n := suaRe.FindAllStringSubmatch(v, -1)
	if len(n) != 3 {
		return -1, -1, -1
	} else {
		size, _ = strconv.Atoi(n[0][1])
		used, _ = strconv.Atoi(n[1][1])
		avail, _ = strconv.Atoi(n[2][1])
	}
	return
}

func parseNodePosition(v string) (x, y int, err error) {
	n := nPosRe.FindAllStringSubmatch(v, -1)
	if len(n) != 1 {
		err = errors.New(`Parse error`)
	} else {
		err = nil
		x, _ = strconv.Atoi(n[0][1])
		y, _ = strconv.Atoi(n[0][2])
	}

	return

}
