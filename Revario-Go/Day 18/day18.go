package main

import (
	"fmt"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
	"strings"
)

func main() {
	fmt.Printf("Number of safe tiles \n 40 rows: %v, 400000 rows: %v", calcNumSafeTiles(40), calcNumSafeTiles(400000))
}

func calcNumSafeTiles(rows int) (n int) {
	input := common.ReadEntireFile(`input.txt`)
	for i := 0; i < rows; i++ {
		n += numSafeTiles(input)
		input = calcNextRow(input)
	}
	return
}

func numSafeTiles(s string) int {
	return strings.Count(s, `.`)
}

func calcNextRow(s string) string {
	nr := []byte{}
	for i := range s {
		if i == 0 {
			if s[1] == '^' {
				nr = append(nr, '^')
			} else {
				nr = append(nr, '.')
			}
		} else if i == len(s)-1 {
			if s[i-1] == '^' {
				nr = append(nr, '^')
			} else {
				nr = append(nr, '.')
			}
		} else {

			if s[i-1] != s[i+1] {
				nr = append(nr, '^')
			} else {
				nr = append(nr, '.')
			}

		}

	}
	return string(nr)
}
