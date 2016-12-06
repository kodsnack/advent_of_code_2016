package main

import (
	"log"
	"strconv"
	"strings"
)

func day3isvalid(input string) bool {
	input = strings.TrimSpace(input)
	input = strings.Replace(input, "  ", " ", -1)
	input = strings.Replace(input, "  ", " ", -1)

	sidesString := strings.Split(input, " ")
	sidesInt := [3]int{}

	for i, s := range sidesString {
		num, err := strconv.Atoi(s)

		if err == nil {
			sidesInt[i] = num
		} else {
			log.Panic("invalid input", input)
		}
	}

	for i, current := range sidesInt {

		sumOthers := 0

		for ii, val := range sidesInt {
			if i != ii {
				sumOthers += val
			}
		}

		if current > sumOthers || current == sumOthers {
			return false
		}
	}

	return true
}

func day3part2organize(inputs [3]string) [3]string {

	var res [3]string

	// Cleanup
	for i, input := range inputs {
		input = strings.TrimSpace(input)
		input = strings.Replace(input, "  ", " ", -1)
		input = strings.Replace(input, "  ", " ", -1)
		inputs[i] = input
	}

	for _, input := range inputs {

		parts := strings.Split(input, " ")

		res[0] += parts[0] + " "
		res[1] += parts[1] + " "
		res[2] += parts[2] + " "
	}

	return res
}
