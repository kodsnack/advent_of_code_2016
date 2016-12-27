package main

import (
	"fmt"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
)

type pos struct {
	y         int
	x         int
	steps     int
	targets   map[byte]bool
	cTarget   byte
	prevPos   map[string]bool
	prevSteps []string
}

type simPos struct {
	cTarget   byte
	targets   map[byte]bool
	steps     int
	prevSteps []byte
}


var input []string

func main() {

	loadInput()
	toAll, back := findPath()
	fmt.Printf("Part 1: %v, Part 2: %v", toAll, back)

}

func loadInput() {
	input = common.ReadFileByRow(`input.txt`)
}

func findPath() (int, int) {
	var queue []pos
	k := make(map[string]int)
	for i := '0'; i < '8'; i++ {
	ii:
		for ii := '0'; ii < '8'; ii++ {
			ts := ``
			if ii < i {
				ts = fmt.Sprintf("%s %s", string(ii), string(i))
			} else {
				ts = fmt.Sprintf("%s %s", string(ii), string(i))
			}
			if _, ok := k[ts]; ok {
				continue ii
			}
			queue = append(queue, findStartPos(byte(i)))
			for len(queue) != 0 {
				cPos := queue[0]
				queue = queue[1:]
				steps := findSteps(cPos)
				for _, v := range steps {
					if v.cTarget == byte(ii) {
						for key := range v.targets {
							str := ``
							if string(key) == string(i) {
								continue
							}
							if i < rune(key) {
								str = fmt.Sprintf("%s %s", string(i), string(key))

							} else {
								str = fmt.Sprintf("%s %s", string(key), string(i))
							}
							if val, ok := k[str]; ok {
								if val > v.steps {
									k[str] = val
								}
							} else {
								k[str] = v.steps
							}
						}
					} else {
						queue = append(queue, v)
					}
				}

			}
		}
	}
	shortestTo := findShortestPath(k)
	stepsback := findStepsBack(k)
	return shortestTo, stepsback

}



func findStepsBack(m map[string]int) (l int) {
	var q []simPos
	t := make(map[byte]bool)
	t['0'] = true
	q = append(q, simPos{cTarget: '0', steps: 0, targets: t, prevSteps: []byte{'0'}})
	l = -1
	for len(q) != 0 {
		cPos := q[0]

		q = q[1:]
		steps := findRoute(cPos, m)
		for _, v := range steps {
			if v.cTarget == byte('0') {
				continue
			}
			if len(v.targets) == 8 {
				if _, ok := m[fmt.Sprintf("0 %v", string(v.cTarget))]; !ok{
					panic(`notOk`)
				}
				if v.steps + m[fmt.Sprintf("0 %v", string(v.cTarget))] < l || l == -1 {
					l = v.steps + m[fmt.Sprintf("0 %v", string(v.cTarget))]

				}
			} else if v.steps < l || l == -1 {
				q = append(q, v)
			}
		}

	}

	return l

}

func findShortestPath(m map[string]int) (l int) {
	var q []simPos
	t := make(map[byte]bool)
	t['0'] = true
	q = append(q, simPos{cTarget: '0', steps: 0, targets: t, prevSteps: []byte{'0'}})
	l = -1

	for len(q) != 0 {
		cPos := q[0]

		q = q[1:]
		steps := findRoute(cPos, m)
		for _, v := range steps {
			if len(v.targets) == 8 {
				if v.steps < l || l == -1 {
					l = v.steps

				}
			} else if v.steps < l || l == -1 {
				q = append(q, v)
			}
		}

	}
	return l
}

func findRoute(cPos simPos, m map[string]int) (steps []simPos) {

	for i := '0'; i <= '7'; i++ {
		str := ``
		if cPos.cTarget < byte(i) {
			str = string(cPos.cTarget) + ` ` + string(i)
		} else {
			str = string(i) + ` ` + string(cPos.cTarget)
		}
		if val, ok := m[str]; ok {
			nPos := simPos{cTarget: byte(i), steps: cPos.steps + val, targets: cPos.copyMap(), prevSteps: cPos.Append(byte(i))}
			nPos.targets[byte(i)] = true
			steps = append(steps, nPos)

		}
	}
	return

}

func findStartPos(t byte) pos {
	for i, v := range input {
		for ii, vv := range v {
			if byte(vv) == t {
				tar := make(map[byte]bool)
				tar[t] = true
				prev := make(map[string]bool)
				prev[fmt.Sprintf("%v %v", i, ii)] = true
				return pos{x: ii, y: i, targets: tar, prevPos: prev, prevSteps: []string{fmt.Sprintf("%v %v", i, ii)}}
			}
		}
	}
	panic(`Could not find start position`)
}

func findSteps(cPos pos) []pos {
	var steps []pos
	if isValid(pos{x: cPos.x + 1, y: cPos.y, prevPos: cPos.prevPos}) {
		steps = append(steps, pos{x: cPos.x + 1, y: cPos.y, steps: cPos.steps + 1, targets: cPos.copyMap(), prevPos: cPos.prevPos})
	}
	if isValid(pos{x: cPos.x - 1, y: cPos.y, prevPos: cPos.prevPos}) {
		steps = append(steps, pos{x: cPos.x - 1, y: cPos.y, steps: cPos.steps + 1, targets: cPos.copyMap(), prevPos: cPos.prevPos})
	}
	if isValid(pos{x: cPos.x, y: cPos.y + 1, prevPos: cPos.prevPos}) {
		steps = append(steps, pos{x: cPos.x, y: cPos.y + 1, steps: cPos.steps + 1, targets: cPos.copyMap(), prevPos: cPos.prevPos})
	}
	if isValid(pos{x: cPos.x, y: cPos.y - 1, prevPos: cPos.prevPos}) {
		steps = append(steps, pos{x: cPos.x, y: cPos.y - 1, steps: cPos.steps + 1, targets: cPos.copyMap(), prevPos: cPos.prevPos})
	}

	for i, v := range steps {
		if ok, target := isTarget(v); ok {
			steps[i].cTarget = target
			v.targets[target] = true
		}
		steps[i].prevSteps = cPos.Append(fmt.Sprintf("%v %v", v.y, v.x))
		v.prevPos = cPos.addPos(v.y, v.x)
	}
	return steps
}

func (cPos pos) addPos(y, x int) map[string]bool {
	cPos.prevPos[fmt.Sprintf("%v %v", y, x)] = true
	return cPos.prevPos
}

func (cPos pos) copyMap() (nM map[byte]bool) {
	nM = make(map[byte]bool)
	for k, v := range cPos.targets {
		nM[k] = v
	}
	return
}

func (cPos simPos) copyMap() (nM map[byte]bool) {
	nM = make(map[byte]bool)
	for k, v := range cPos.targets {
		nM[k] = v
	}
	return
}

func (cPos simPos) Append(i byte) (s []byte) {

	s = make([]byte, len(cPos.prevSteps))
	copy(s, cPos.prevSteps)
	s = append(s, i)
	return

}

func (cPos pos) Append(i string) (s []string) {

	s = make([]string, len(cPos.prevSteps))
	copy(s, cPos.prevSteps)
	s = append(s, i)
	return

}

func isValid(cPos pos) bool {
	if input[cPos.y][cPos.x] == '#' {
		return false
	}
	if _, ok := cPos.prevPos[fmt.Sprintf("%v %v", cPos.y, cPos.x)]; ok {
		return false
	}
	return true
}

func isTarget(cPos pos) (bool, byte) {
	if input[cPos.y][cPos.x] != '#' && input[cPos.y][cPos.x] != '.' {
		return true, input[cPos.y][cPos.x]
	} else {
		return false, 0
	}
}
