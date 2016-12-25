package main

import (
	"strings"
	"strconv"
	"fmt"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
)

func main() {
	input := common.ReadFileByRow(`input.txt`)
	fmt.Printf("Part 1: %v", parseInstructions(input, loadInst(input)))

}

func loadInst(input []string) map[int]string {
	inst := make(map[int]string)
	for i, v := range input {
		a := strings.Split(v, ` `)
		inst[i] = a[0]
	}
	return inst
}

func genControl() (string) {
	b := []byte{}
	for i := 0; i < 50; i++ {
		if i % 2 == 0 {

			b = append(b, byte('0'))
		} else {

			b = append(b, byte('1'))
		}
	}
	return string(b)
}

func parseInstructions(input []string, instMap map[int]string) int {
	var reg = make(map[string]int)

	out := []byte{}
	ctrl := genControl()
	for j := 1; true; j++ {
		reg[`a`] = j
		if j % 5000 == 0 {
			fmt.Println(j)

		}
		number:
		for n := 0; n < len(input); n++ {
			if len(out) == 10 {
				for i, v := range out{
					if v != ctrl[i]{
						out = []byte{}
						break number
					}
				}
					return j
			}
			inst := strings.Split(input[n], ` `)
			switch instMap[n] {
			case `out`:
				out = append(out, strconv.Itoa(reg[inst[1]])[0])
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

							if num, err := strconv.Atoi(inst[2]); err == nil {
								n += num - 1
							} else {
								n += reg[inst[2]] - 1
							}
						}

				}


			case `dec`:
				reg[inst[1]]--
			default:
				panic(inst[0])
			}

		}
	}
	return reg[`a`]
}

