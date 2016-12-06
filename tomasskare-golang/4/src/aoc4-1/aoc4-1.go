package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
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
		return s[i].count > s[j].count
	}
}

func main() {
	reader := bufio.NewReader(os.Stdin)
	var err error
	err = nil
	cntReal := 0

	for err == nil {
		var line string
		line, err = reader.ReadString('\n')
		line = strings.Trim(line, " \n")
		if line == "" {
			continue
		}

		count := make(CharCountArr, 0, len(line))

		var i int
		for i = 0; i < len(line); i++ {
			if line[i] == '-' {
				continue
			}
			if line[i] >= '0' && line[i] <= '9' {
				break
			}

			count = addChar(count, line[i])
		}

		idStart := i

		for i < len(line) {
			if line[i] == '[' {
				break
			}
			i++
		}

		id, _ := strconv.Atoi(line[idStart:i])
		chksum := line[i+1 : len(line)-1]

		sort.Sort(count)

		keys := ""
		for i = 0; i < 5; i++ {
			keys = keys + string(count[i].char)
		}

		if keys == chksum {
			cntReal = cntReal + id
		}
	}

	fmt.Printf("Answer: %d\n", cntReal)
}
