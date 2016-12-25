package main

import (
	"fmt"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
	"strconv"
	"strings"
)

func main() {
	l, t := calcBlock()
	fmt.Printf("Lowest ip allowed: %v. Total allowed: %v", l, t)
}



func calcBlock() (lowest int, total int) {
	input := common.ReadFileByRow(`input.txt`)
	lowest = -1

	s := make([]int, 0, len(input))
	e := make([]int, 0, len(input))

	for _, v := range input {
		in := strings.Split(v, `-`)
		si, _ := strconv.Atoi(in[0])
		ei, _ := strconv.Atoi(in[1])
		s = append(s, si)
		e = append(e, ei)
	}

	for i := 0; i <= 4294967295; i++ {
		found := false
		for j := range s {

			if i >= s[j] && i <= e[j] {
				found = true
				i = e[j]
				break
			}
		}
		if !found {
			total++
			if i < lowest || lowest == -1{
				lowest = i
			}
		}
	}

	return lowest, total

}
