package main

import (
	"fmt"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
	"strconv"
	"strings"
)

func main() {
	input := common.ReadFileByRow(`input.txt`)
	fmt.Printf("Part 1: %v, Part 2: %v", parseInstructions(input, loadInst(input), false), parseInstructions(input, loadInst(input), true))

}

func loadInst(input []string) map[int]string {
	inst := make(map[int]string)
	for i, v := range input {
		a := strings.Split(v, ` `)
		inst[i] = a[0]
	}
	return inst
}

func parseInstructions(input []string, instMap map[int]string, part2 bool) int {
	var reg = make(map[string]int)
	reg[`a`] = 7
	if part2 {
		reg[`a`] = 12
	}
	for n := 0; n < len(input); n++ {
		inst := strings.Split(input[n], ` `)
		switch instMap[n] {
		case `tgl`:
			var num int
			if i, err := strconv.Atoi(inst[1]); err == nil {
				num = n + i
			} else if i, ok := reg[inst[1]]; ok {
				num = n + i
			}
			switch instMap[num] {
			case `inc`:
				instMap[num] = `dec`
			case `dec`, `tgl`:
				instMap[num] = `inc`
			case `jnz`:
				instMap[num] = `cpy`
			case `cpy`:
				instMap[num] = `jnz`
			}

		case `inc`:
			if len(inst) != 2 {
				continue
			} else {
				reg[inst[1]]++
			}
		case `cpy`:

			if num, err := strconv.Atoi(inst[1]); err == nil {
				if _, err := strconv.Atoi(inst[2]); err != nil {
					reg[inst[2]] = num
				}
			} else {
				reg[inst[2]] = reg[inst[1]]
			}

		case `jnz`:
			if d, err := strconv.Atoi(inst[1]); err == nil {
				if d != 0 {
					if num, err := strconv.Atoi(inst[2]); err == nil {
						n += num - 1
					} else {
						n += reg[inst[2]] - 1
					}

				}

			} else {
				if reg[inst[1]] != 0 {
					if inst[2] == `-2` && ((instMap[n - 1] == `inc` && instMap[n - 2] == `dec`) || (instMap[n - 1] == `dec` && instMap[n - 2] == `inc`)) {
						if instMap[n - 1] == `inc` {

							ss := strings.Split(input[n - 1], ` `)

							reg[ss[1]] += reg[inst[1]]
						} else {
							ss := strings.Split(input[n - 2], ` `)

							reg[ss[1]] += reg[inst[1]]
						}
						reg[inst[1]] = 0

					} else if inst[2] == `-5` && inst[1] == `d` {

						reg[`a`] += reg[`b`] * reg[`d`]
						reg[`d`] = 0
					} else {

						if num, err := strconv.Atoi(inst[2]); err == nil {
							n += num - 1
						} else {
							n += reg[inst[2]] - 1
						}
					}

				}
			}


		case `dec`:
			reg[inst[1]]--
		default:
			panic(inst[0])
		}

	}
	return reg[`a`]
}

