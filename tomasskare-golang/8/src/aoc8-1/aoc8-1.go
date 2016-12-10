package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	var err error
	err = nil

	screenWidth := 50
	screenHeight := 6

	screen := make([][]bool, screenWidth)
	for i := 0; i < screenWidth; i++ {
		screen[i] = make([]bool, screenHeight)
	}

	for err == nil {
		var line string
		line, err = reader.ReadString('\n')
		line = strings.Trim(line, " \n")
		if line == "" {
			continue
		}

		strs := strings.Split(line, " ")
		switch strs[0] {
		case "rect":
			rectstr := strings.Split(strs[1], "x")
			w, _ := strconv.Atoi(rectstr[0])
			h, _ := strconv.Atoi(rectstr[1])
			for i := 0; i < w; i++ {
				for j := 0; j < h; j++ {
					screen[i][j] = true
				}
			}
		case "rotate":
			whichstr := strings.Split(strs[2], "=")
			which, _ := strconv.Atoi(whichstr[1])
			by, _ := strconv.Atoi(strs[4])
			if strs[1] == "row" {
				for i := 0; i < by; i++ {
					carry := screen[screenWidth-1][which]
					for j := screenWidth - 1; j > 0; j-- {
						screen[j][which] = screen[j-1][which]
					}
					screen[0][which] = carry
				}
			} else {
				for i := 0; i < by; i++ {
					carry := screen[which][screenHeight-1]
					for j := screenHeight - 1; j > 0; j-- {
						screen[which][j] = screen[which][j-1]
					}
					screen[which][0] = carry
				}
			}
		default:
		}
	}

	cnt := 0
	for i := 0; i < screenHeight; i++ {
		for j := 0; j < screenWidth; j++ {
			if screen[j][i] {
				cnt++
			}
		}
	}

	fmt.Printf("Answer 1: %d\n", cnt)

	fmt.Printf("Answer 2:\n")
	for i := 0; i < screenHeight; i++ {
		for j := 0; j < screenWidth; j++ {
			if screen[j][i] {
				fmt.Print("#")
			} else {
				fmt.Print(" ")
			}
		}
		fmt.Print("\n")
	}
}
