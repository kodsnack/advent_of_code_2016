package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	var err error
	err = nil

	botLowDest := make(map[int]int)
	botHighDest := make(map[int]int)
	botVal1 := make(map[int]int)
	botVal2 := make(map[int]int)

	for err == nil {
		var line string
		line, err = reader.ReadString('\n')
		line = strings.Trim(line, " \n")
		if line == "" {
			continue
		}

		strs := strings.Split(line, " ")
		switch strs[0] {
		case "value":
			value, _ := strconv.Atoi(strs[1])
			toBot, _ := strconv.Atoi(strs[5])
			_, ok := botVal1[toBot]
			if !ok {
				botVal1[toBot] = value
			} else {
				botVal2[toBot] = value
			}
		case "bot":
			fromBot, _ := strconv.Atoi(strs[1])
			toLow, _ := strconv.Atoi(strs[6])
			if strs[5] == "output" {
				toLow = -toLow - 1
			}
			toHigh, _ := strconv.Atoi(strs[11])
			if strs[10] == "output" {
				toHigh = -toHigh - 1
			}

			botLowDest[fromBot] = toLow
			botHighDest[fromBot] = toHigh
		default:
		}
	}

	outputs := make(map[int]int)

	again := true
	for again {
		again = false
		for bot, val1 := range botVal1 {
			val2, ok := botVal2[bot]
			if !ok {
				continue
			}

			again = true

			botValLowP := &botVal1
			botValHighP := &botVal2
			lowVal := val1
			highVal := val2
			if val2 < val1 {
				botValLowP = &botVal2
				botValHighP = &botVal1
				lowVal = val2
				highVal = val1
			}

			lowTo := botLowDest[bot]
			if lowTo < 0 {
				output := -lowTo - 1
				outputs[output] = lowVal
				delete(botLowDest, bot)
			} else {
				_, ok := botVal1[lowTo]
				if !ok {
					botVal1[lowTo] = lowVal
				} else {
					botVal2[lowTo] = lowVal
				}
				delete(*botValLowP, bot)
			}
			highTo := botHighDest[bot]
			if highTo < 0 {
				output := -highTo - 1
				outputs[output] = highVal
				delete(botHighDest, bot)
			} else {
				_, ok := botVal1[highTo]
				if !ok {
					botVal1[highTo] = highVal
				} else {
					botVal2[highTo] = highVal
				}
				delete(*botValHighP, bot)
			}
		}
	}

	answer := outputs[0] * outputs[1] * outputs[2]
	fmt.Printf("Answer: %d\n", answer)
}
