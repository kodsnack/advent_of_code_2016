package main

import (
	"fmt"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
	"regexp"
	"strconv"
	"strings"
)

type bot struct {
	chips []int
}

type instruction struct {
	tL int
	tH int
}

var instructions = make(map[int]instruction)
var reBotNr = regexp.MustCompile(`bot (\d+)`)
var value = regexp.MustCompile(`value (\d+)`)
var reOutput = regexp.MustCompile(`output (\d+)`)
var bots = make(map[int]bot)
var output = make(map[int]int)

var instPath = `D:\Owncloud\Golang\src\github.com\revario\advent_of_code_2016\Revario-Go\Day 10\input.txt`

func main() {

	fmt.Printf("Part 1: %v  Part 2: %v", run(), output[0]*output[1]*output[2])
}

func run() int {
	input := common.ReadFileByRow(instPath)
	loadInstructions()

	part1 := -1

	for _, in := range input {
		if strings.Contains(in, `value`) {
			botInfo := extractBotInformation(in)
			if _, ok := bots[botInfo[0]]; !ok {
				bots[botInfo[0]] = bot{}
			}
			bots[botInfo[0]].add(extractValueFromInst(in), botInfo[0])

			if len(bots[botInfo[0]].chips) == 2 {
				if t, n := executeInstruction(botInfo[0]); t {
					if part1 == -1 {
						part1 = n
					}

				}
			}

		}

	}
	return part1
}

func executeInstruction(botNr int) (bool, int) {
	target := false
	targetBot := -1

	if inst, ok := instructions[botNr]; ok != true {
		panic("error in execution")
	} else {
		if bots[botNr].isTarget() {
			target = true
			targetBot = botNr
		}

		if inst.tH < 600 {
			bots[inst.tH].add(bots[botNr].high(), inst.tH)

		} else {
			output[inst.tH-600] = bots[botNr].high()
		}
		if inst.tL < 600 {
			bots[inst.tL].add(bots[botNr].low(), inst.tL)
		} else {
			output[inst.tL-600] = bots[botNr].low()
		}

		bots[botNr].clear(botNr)
		if len(bots[inst.tH].chips) == 2 {
			if t, n := executeInstruction(inst.tH); t {
				target, targetBot = true, n
			}
		}
		if len(bots[inst.tL].chips) == 2 {
			if t, n := executeInstruction(inst.tL); t {
				target, targetBot = true, n
			}
		}

	}

	return target, targetBot
}

func (b bot) isTarget() bool {
	if len(b.chips) != 2 {
		return false
	}
	if b.high() == 61 && b.low() == 17 {
		return true
	} else {
		return false
	}
}

func (b bot) low() int {
	if b.chips[0] < b.chips[1] {
		return b.chips[0]
	}
	return b.chips[1]
}

func (b bot) high() int {
	if b.chips[0] < b.chips[1] {
		return b.chips[1]
	}
	return b.chips[0]
}

func (b bot) add(n int, bot int) {
	if len(b.chips) > 2 {
		panic("Microchip overflow!")
	}
	bo := bots[bot]
	bo.chips = append(bo.chips, n)
	bots[bot] = bo
}

func (b bot) clear(botNr int) {

	bo := bots[botNr]
	bo.chips = nil
	bots[botNr] = bo
}

func loadInstructions() {
	inst := common.ReadFileByRow(instPath)

	for _, v := range inst {
		if strings.Contains(v, `goes to`) {
			continue
		}
		botInfo := extractBotInformation(v)
		outInfo := extractOutputInformation(v)
		switch strings.Count(v, `bot`) {
		case 3:
			instructions[botInfo[0]] = instruction{tL: botInfo[1], tH: botInfo[2]}
		case 2:
			instructions[botInfo[0]] = instruction{tL: 600 + outInfo[0], tH: botInfo[1]}
		case 1:

			if strings.Count(v, `output`) == 2 {
				instructions[botInfo[0]] = instruction{tL: 600 + outInfo[0], tH: 600 + outInfo[1]}
			} else if strings.Count(v, `output`) == 1 {
				panic("Output parse error")
			}
		}

	}
}

func extractOutputInformation(inst string) []int {
	num := reOutput.FindAllStringSubmatch(inst, -1)

	var outNrs []int
	for _, v := range num {
		nr, _ := strconv.Atoi(v[1])
		outNrs = append(outNrs, nr)
	}
	return outNrs
}

func extractBotInformation(inst string) []int {
	numbers := reBotNr.FindAllStringSubmatch(inst, -1)

	var botNrs []int

	for _, v := range numbers {
		nr, _ := strconv.Atoi(v[1])
		botNrs = append(botNrs, nr)
	}
	return botNrs
}

func extractValueFromInst(inst string) int {
	val, _ := strconv.Atoi(value.FindStringSubmatch(inst)[1])
	return val
}
