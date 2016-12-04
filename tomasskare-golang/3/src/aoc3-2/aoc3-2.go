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

Main:
	for err == nil {
		var line [3]string
		for i := 0; i < 3; i = i + 1 {
			line[i], err = reader.ReadString('\n')
			line[i] = strings.Trim(line[i], " \n")
			for true {
				newline := strings.Replace(line[i], "  ", " ", -1)
				if newline == line[i] {
					break
				}
				line[i] = newline
			}
			if line[i] == "" {
				continue Main
			}
		}

		var values [3][3]int
		for i := 0; i < 3; i = i + 1 {
			strs := strings.Split(line[i], " ")
			values[0][i], _ = strconv.Atoi(strs[0])
			values[1][i], _ = strconv.Atoi(strs[1])
			values[2][i], _ = strconv.Atoi(strs[2])
		}

		for i := 0; i < 3; i = i + 1 {
			minSum, max := getMinSumMax(values[i])
			if minSum > max {
				cntPossible = cntPossible + 1
			}
		}
	}

	fmt.Printf("Answer: %d\n", cntPossible)
}
