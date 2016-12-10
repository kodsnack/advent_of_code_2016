package screens

import (
	"fmt"
	"strconv"
	"strings"
)

type Screen struct {
	data []string
}

func NewScreen(h, l int) Screen {
	screen := Screen{make([]string, h)}
	for i := 0; i < h; i++ {
		screen.data[i] = strings.Repeat("=", l)
	}
	return screen
}

func (s *Screen) PrintScreen() {
	count := 0
	for k, v := range s.data {
		fmt.Println(k, v)
		count += strings.Count(v, "#")
	}
	fmt.Println(count)
}

func (s *Screen) ExecuteInstruction(input string) {
	fields := strings.Fields(input)
	switch fields[0] {
	case "rect":
		a := strings.FieldsFunc(fields[1], func(r rune) bool { return r == 'x' })
		x, _ := strconv.Atoi(a[0])
		y, _ := strconv.Atoi(a[1])
		s.drawRect(x, y)
	case "rotate":
		a := strings.FieldsFunc(fields[2], func(r rune) bool { return r == '=' })
		n, _ := strconv.Atoi(a[1])
		l, _ := strconv.Atoi(fields[4])
		s.rotate(fields[1], n, l)
	}
}

func (s *Screen) drawRect(x, y int) {
	for i := 0; i < y; i++ {
		part := []rune(s.data[i])
		for n := 0; n < x; n++ {
			part[n] = '#'
		}
		s.data[i] = string(part)
	}
}

func (s *Screen) rotate(direction string, n, l int) {
	switch direction {
	case "column":
		str := s.getColumn(n)
		str = str[len(str)-l:] + str[:len(str)-l]
		s.setColumn(n, str)
	case "row":
		s.data[n] = s.data[n][len(s.data[n])-l:] + s.data[n][:len(s.data[n])-l]
	}
}

func (s *Screen) getColumn(n int) (str string) {
	for i := 0; i < len(s.data); i++ {
		str += string(s.data[i][n])
	}
	return
}

func (s *Screen) setColumn(n int, str string) {
	for i := 0; i < len(s.data); i++ {
		part := []rune(s.data[i])
		part[n] = rune(str[i])
		s.data[i] = string(part)
	}
}
