package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

var pad [5]string = [5]string{
	"  1  ",
	" 234 ",
	"56789",
	" ABC ",
	"  D  "}

func posToChar(xpos int, ypos int) byte {
	return pad[ypos][xpos]
}

func posMove(xpos int, ypos int, xdelta int, ydelta int) (int, int) {
	xnew := xpos + xdelta
	if xnew < 0 || xnew > 4 {
		return xpos, ypos
	}

	ynew := ypos + ydelta
	if ynew < 0 || ynew > 4 {
		return xpos, ypos
	}

	char := posToChar(xnew, ynew)
	if char == ' ' {
		return xpos, ypos
	}

	return xnew, ynew
}

func main() {

	reader := bufio.NewReader(os.Stdin)
	var err error
	err = nil
	xpos := 0
	ypos := 2
	answer := ""
	for err == nil {
		var data string
		data, err = reader.ReadString('\n')
		data = strings.Trim(data, " \n")
		if data == "" {
			continue
		}
		for i := 0; i < len(data); i = i + 1 {
			xdelta := 0
			ydelta := 0
			switch data[i] {
			case 'U':
				ydelta = -1
			case 'D':
				ydelta = 1
			case 'L':
				xdelta = -1
			case 'R':
				xdelta = 1
			default:
				continue
			}
			xpos, ypos = posMove(xpos, ypos, xdelta, ydelta)
		}
		answer = answer + string(posToChar(xpos, ypos))
	}

	fmt.Printf("Answer: %s\n", answer)
}
