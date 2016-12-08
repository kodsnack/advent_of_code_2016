package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func CheckBab(strs []string, a byte, b byte) bool {
	for i := 1; i < len(strs); i = i + 2 {
		if len(strs[i]) < 3 {
			continue
		}
		for j := 0; j < len(strs[i])-2; j++ {
			if strs[i][j] == b && strs[i][j+1] == a && strs[i][j+2] == b {
				return true
			}
		}
	}

	return false
}

func main() {
	reader := bufio.NewReader(os.Stdin)
	var err error
	err = nil

	cnt := 0

	for err == nil {
		var line string
		line, err = reader.ReadString('\n')
		line = strings.Trim(line, " \n")
		if line == "" {
			continue
		}

		strs := strings.FieldsFunc(line, func(r rune) bool {
			return r == '[' || r == ']'
		})

		hasSSL := false
	Str:
		for i := 0; i < len(strs); i = i + 2 {
			if len(strs[i]) < 3 {
				continue
			}
			a := strs[i][0]
			b := strs[i][1]
			for j := 2; j < len(strs[i]); j++ {
				if a == strs[i][j] && a != b {
					if CheckBab(strs, a, b) {
						hasSSL = true
						break Str
					}
				}
				a = b
				b = strs[i][j]
			}
		}

		if hasSSL {
			cnt++
		}
	}

	fmt.Printf("Answer: %d\n", cnt)
}
