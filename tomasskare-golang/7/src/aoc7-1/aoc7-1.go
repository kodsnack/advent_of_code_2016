package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

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

		strIsAbba := false
		for i := 0; i < len(strs); i++ {
			if len(strs[i]) < 4 {
				continue
			}
			a := strs[i][0]
			b := strs[i][1]
			partAbba := false
			for j := 2; j < len(strs[i])-1; j++ {
				if b == strs[i][j] && a == strs[i][j+1] && a != b {
					partAbba = true
				} else {
					a = b
					b = strs[i][j]
				}
			}
			if partAbba {
				if i%2 == 1 {
					strIsAbba = false
					break
				}
				strIsAbba = true
			}
		}
		if strIsAbba {
			cnt++
		}
	}

	fmt.Printf("Answer: %d\n", cnt)
}
