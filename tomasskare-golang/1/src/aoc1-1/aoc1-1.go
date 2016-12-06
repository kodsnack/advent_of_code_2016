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
	xpos := 0
	ypos := 0
	xdir := 0
	ydir := 1
	for err == nil {
		var data string
		data, err = reader.ReadString(',')
		data = strings.Trim(data, " ,\n")
		if data == "" {
			break
		}
		turndir := data[:1]
		walklen, _ := strconv.Atoi(data[1:len(data)])
		if xdir != 0 {
			ydir = -xdir
			xdir = 0
		} else if ydir != 0 {
			xdir = ydir
			ydir = 0
		}
		if turndir == "L" {
			xdir = -xdir
			ydir = -ydir
		}
		xpos = xpos + walklen*xdir
		ypos = ypos + walklen*ydir
	}

	if xpos < 0 {
		xpos = -xpos
	}
	if ypos < 0 {
		ypos = -ypos
	}
	fmt.Printf("Answer: %d\n", xpos+ypos)
}
