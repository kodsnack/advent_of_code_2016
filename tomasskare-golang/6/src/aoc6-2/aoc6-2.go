package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strings"
)

type CharCount struct {
	char  byte
	count int
}

type CharCountArr []CharCount

func addChar(count CharCountArr, char byte) CharCountArr {
	for i := 0; i < len(count); i++ {
		if count[i].char == char {
			count[i].count++
			return count
		}
	}

	newcount := append(count, CharCount{char, 1})
	return newcount
}

func (s CharCountArr) Len() int {
	return len(s)
}
func (s CharCountArr) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}
func (s CharCountArr) Less(i, j int) bool {
	if s[i].count == s[j].count {
		return s[i].char < s[j].char
	} else {
		return s[i].count < s[j].count
	}
}

func main() {
	reader := bufio.NewReader(os.Stdin)
	var err error
	err = nil

	countarr := make([]CharCountArr, 10)

	lineLen := 0
	for err == nil {
		var line string
		line, err = reader.ReadString('\n')
		line = strings.Trim(line, " \n")
		if line == "" {
			continue
		}
		lineLen = len(line)

		for i := 0; i < lineLen; i++ {
			countarr[i] = addChar(countarr[i], line[i])
		}
	}

	key := ""
	for i := 0; i < lineLen; i++ {
		sort.Sort(countarr[i])
		key = key + string(countarr[i][0].char)
	}

	fmt.Printf("Answer: %s\n", key)
}
