package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func getMinSumMax(values [3]int) (int, int) {
	var minSum int
	var max int
	if values[0] < values[1] {
		minSum = values[0]
		if values[1] < values[2] {
			minSum = minSum + values[1]
			max = values[2]
		} else {
			minSum = minSum + values[2]
			max = values[1]
		}
	} else {
		minSum = values[1]
		if values[0] < values[2] {
			minSum = minSum + values[0]
			max = values[2]
		} else {
			minSum = minSum + values[2]
			max = values[0]
		}
	}

	return minSum, max
}

func main() {
	reader := bufio.NewReader(os.Stdin)
	var err error
	err = nil
	cntPossible := 0

	for err == nil {
		var line string
		line, err = reader.ReadString('\n')
		line = strings.Trim(line, " \n")
		if line == "" {
			continue
		}
		for true {
			newline := strings.Replace(line, "  ", " ", -1)
			if newline == line {
				break
			}
			line = newline
		}
		strs := strings.Split(line, " ")
		var values [3]int
		values[0], _ = strconv.Atoi(strs[0])
		values[1], _ = strconv.Atoi(strs[1])
		values[2], _ = strconv.Atoi(strs[2])

		minSum, max := getMinSumMax(values)
		if minSum > max {
			cntPossible = cntPossible + 1
		}
	}

	fmt.Printf("Answer: %d\n", cntPossible)
}
