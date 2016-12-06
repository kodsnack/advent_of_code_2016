package main

import (
	"fmt"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
	"sort"
	"strings"
)

type ByLength []string

func (ss ByLength) Len() int {
	return len(ss)
}

func (ss ByLength) Swap(i, j int) {
	ss[i], ss[j] = ss[j], ss[i]
}

func (ss ByLength) Less(i, j int) bool {
	return len(ss[i]) > len(ss[j])
}

func main() {
	fmt.Printf("Message: %v, modified repetition: %v", calculateMessage(), calculateMessageModified())
}

func calculateMessage() string {
	input := common.ReadFileByRow(`input.txt`)
	message := ``
	chars := make([][]string, 8)

	for _, v := range input {
		for i, c := range v {
			chars[i] = append(chars[i], string(c))
		}
	}

	for _, v := range chars {

		message += string(orderByFrequency(strings.Join(v, ``))[0])
	}

	return message
}

func orderByFrequency(s string) string {
	splS := strings.Split(s, ``)
	sort.Strings(splS)
	s = strings.Join(splS, ``)

	var ss []string
	for i := 0; i < len(s)-1; {
		if s[i+1] != s[i] {
			ss, s = append(ss, s[:i+1]), s[i+1:]
			i = 0
		} else {
			i++
		}
	}
	ss = append(ss, s[:])

	sort.Stable(ByLength(ss))
	return strings.Join(ss, ``)
}

func calculateMessageModified() string {
	input := common.ReadFileByRow(`input.txt`)
	message := ``
	chars := make([][]string, 8)

	for _, v := range input {
		for i, c := range v {
			chars[i] = append(chars[i], string(c))
		}
	}

	for _, v := range chars {
		m := orderByFrequency(strings.Join(v, ``))
		message += string(m[len(m)-1])
	}

	return message
}
