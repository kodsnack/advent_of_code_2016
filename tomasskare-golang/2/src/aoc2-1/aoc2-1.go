package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func posToNumber(xpos int, ypos int) int {
	return (ypos*3 + xpos) + 1
}

func main() {
	reader := bufio.NewReader(os.Stdin)
	var err error
	err = nil
	xpos := 1
	ypos := 1
	num := 0
	for err == nil {
		var data string
		data, err = reader.ReadString('\n')
		data = strings.Trim(data, " \n")
		if data == "" {
			continue
		}
		for i := 0; i < len(data); i = i + 1 {
			switch data[i] {
			case 'U':
				if ypos > 0 {
					ypos = ypos - 1
				}
			case 'D':
				if ypos < 2 {
					ypos = ypos + 1
				}
			case 'L':
				if xpos > 0 {
					xpos = xpos - 1
				}
			case 'R':
				if xpos < 2 {
					xpos = xpos + 1
				}
			default:
			}
		}
		num = num*10 + posToNumber(xpos, ypos)
	}

	fmt.Printf("Answer: %d\n", num)
}
