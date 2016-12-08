package main

import (
	"fmt"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
	"strconv"
	"strings"
)

func main() {
	num, message := lightsAndMessage()
	fmt.Printf("Number of lights: %v \n\nMessage:\n%v\n\n", num, message)
}

type display [][]int

func lightsAndMessage() (int, string) {
	disp := make(display, 50)

	n := 0
	message := ``

	for i := range disp {
		disp[i] = make([]int, 6)
	}

	input := common.ReadFileByRow(`input.txt`)
	for _, v := range input {
		parseInstruction(v, disp)

	}

	for i := 0; i < 6; i++ {
		message += "\n"
		for j := 0; j < 50; j++ {
			if disp[j][i] == 1 {
				message += `x`
				n++
			} else {
				message += ` `
			}
		}
	}

	return n, message
}

func parseInstruction(s string, disp display) {

	if strings.Contains(s, `rect`) {
		inst := string(strings.Split(strings.TrimSpace(s), ` `)[1])
		instS := strings.Split(inst, `x`)
		x, _ := strconv.Atoi(instS[0])
		y, _ := strconv.Atoi(instS[1])
		for i := 0; i < x; i++ {
			for j := 0; j < y; j++ {
				disp[i][j] = 1
			}
		}
	} else if strings.Contains(s, `column`) {
		inst := string(strings.Split(strings.TrimSpace(s), `x=`)[1])
		instS := strings.Split(inst, ` by `)
		column, _ := strconv.Atoi(instS[0])
		by, _ := strconv.Atoi(instS[1])

		for i := 0; i < by; i++ {
			overflow := false
			if disp[column][len(disp[column])-1] == 1 {
				overflow = true
				disp[column][len(disp[column])-1] = 0
			}

			for j := len(disp[column]) - 2; j >= 0; j-- {
				if disp[column][j] == 1 {
					disp[column][j+1], disp[column][j] = 1, 0

				}
			}
			if overflow {
				disp[column][0] = 1
			}
		}

	} else if strings.Contains(s, `row`) {
		inst := string(strings.Split(strings.TrimSpace(s), `y=`)[1])
		instS := strings.Split(inst, ` by `)
		row, _ := strconv.Atoi(string(instS[0]))
		by, _ := strconv.Atoi(string(instS[1]))

		for i := 0; i < by; i++ {
			overflow := false
			if disp[len(disp)-1][row] == 1 {
				overflow = true
				disp[len(disp)-1][row] = 0

			}

			for j := len(disp) - 2; j >= 0; j-- {
				if disp[j][row] == 1 {
					disp[j+1][row], disp[j][row] = 1, 0
				}
			}
			if overflow {
				disp[0][row] = 1
			}
		}
	} else {
		panic("Invalid input")
	}
}
