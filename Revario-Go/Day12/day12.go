package main

import (
	"fmt"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
	"strconv"
	"strings"
)

func main() {
	input := `input.txt`
	fmt.Printf(`Part 1: %v, Part 2: %v`, parseInstructions(common.ReadFileByRow(input), false), parseInstructions(common.ReadFileByRow(input), true))

}

func parseInstructions(i []string, part2 bool) int {
	var reg = make(map[string]int)
	if part2 {
		reg[`c`] = 1
	}
	for n := 0; n < len(i); n++ {
		inst := strings.Split(i[n], ` `)
		switch inst[0] {
		case `cpy`:

			if num, err := strconv.Atoi(inst[1]); err == nil {
				reg[inst[2]] = num
			} else {
				reg[inst[2]] = reg[inst[1]]
			}

		case `jnz`:
			if d, err := strconv.Atoi(inst[1]); err == nil {
				if d != 0 {
					if num, err := strconv.Atoi(inst[2]); err == nil {
						n += num - 1
					} else {
						panic("Conversion error")
					}
				}

			} else {
				if reg[inst[1]] != 0 {
					if num, err := strconv.Atoi(inst[2]); err == nil {
						n += num - 1
					} else {
						panic("Conversion error")
					}
				}
			}

		case `inc`:
			reg[inst[1]]++

		case `dec`:
			reg[inst[1]]--
		default:
			panic(inst[0])
		}

	}
	return reg[`a`]
}
