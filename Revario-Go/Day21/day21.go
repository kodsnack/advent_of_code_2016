package main

import (
	"fmt"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
	"regexp"

	"strconv"
	"strings"
)

type scrambled []byte

func main() {
	scram := []byte(`abcdefgh`)
	var scr = scrambled{}
	scr = scram

	unscram := []byte(`fbgdceah`)
	var uscr = scrambled{}
	uscr = unscram
	fmt.Printf("Scrambled: %v, unscrambled: %v \n\n", scramble(scr), unscramble(uscr))

}

func unscramble(scr scrambled) string {
	input := common.ReadFileByRow(`input.txt`)

	reLet := regexp.MustCompile(`letter (.)`)
	unRotTable := genRotateTable()
	for j := len(input) - 1; j >= 0; j-- {
		if strings.Contains(input[j], `swap position`) {
			a, b := findNumbers(input[j])
			scr.swapPosition(a, b)
		} else if strings.Contains(input[j], `swap letter`) {
			i := reLet.FindAllStringSubmatch(input[j], -1)
			scr.swapLetter(i[0][1][0], i[1][1][0])
		} else if strings.Contains(input[j], `move position`) {
			a, b := findNumbers(input[j])
			scr.move(b, a)
		} else if strings.Contains(input[j], `rotate based on position`) {
			i := reLet.FindStringSubmatch(input[j])
			a := i[1][0]
			scr.unRotateOnLetter(a, unRotTable)
		} else if strings.Contains(input[j], `rotate`) {
			if strings.Contains(input[j], `right`) {
				a := findNumber(input[j])
				scr.rotate('+', a)
			} else if strings.Contains(input[j], `left`) {
				a := findNumber(input[j])
				scr.rotate('-', a)
			}
		} else if strings.Contains(input[j], `reverse positions`) {
			a, b := findNumbers(input[j])
			scr.reversePositions(a, b)
		}
	}
	return string(scr)
}
func scramble(scr scrambled) string {
	input := common.ReadFileByRow(`C:\Users\ander\Owncloud\Golang\src\github.com\revario\advent_of_code_2016\Revario-Go\Day21\input.txt`)

	reLet := regexp.MustCompile(`letter (.)`)

	for _, v := range input {
		if strings.Contains(v, `swap position`) {
			a, b := findNumbers(v)
			scr.swapPosition(a, b)
		} else if strings.Contains(v, `swap letter`) {
			i := reLet.FindAllStringSubmatch(v, -1)
			scr.swapLetter(i[0][1][0], i[1][1][0])
		} else if strings.Contains(v, `move position`) {
			a, b := findNumbers(v)
			scr.move(a, b)
		} else if strings.Contains(v, `rotate based on position`) {
			i := reLet.FindStringSubmatch(v)
			a := i[1][0]
			scr.rotateOnLetter(a)
		} else if strings.Contains(v, `rotate`) {
			if strings.Contains(v, `right`) {
				a := findNumber(v)
				scr.rotate('-', a)
			} else if strings.Contains(v, `left`) {
				a := findNumber(v)
				scr.rotate('+', a)
			}
		} else if strings.Contains(v, `reverse positions`) {
			a, b := findNumbers(v)
			scr.reversePositions(a, b)
		}

	}
	return string(scr)
}

func findNumber(v string) (a int) {
	reNum := regexp.MustCompile(`\d`)
	i := reNum.FindAllString(v, -1)
	a, _ = strconv.Atoi(i[0])
	return
}

func findNumbers(v string) (a, b int) {
	reNum := regexp.MustCompile(`\d`)
	i := reNum.FindAllString(v, -1)
	a, _ = strconv.Atoi(i[0])
	b, _ = strconv.Atoi(i[1])
	return
}

func (s *scrambled) swapPosition(a, b int) {

	(*s)[a], (*s)[b] = (*s)[b], (*s)[a]
}

func (s *scrambled) rotateOnLetter(a byte) {
	re := regexp.MustCompile(string(a))
	aI := re.FindIndex(*s)
	num := 0
	if aI[0] > 3 {
		num = aI[0] + 2
	} else {
		num = aI[0] + 1
	}

	s.rotate('-', num)

}

func genRotateTable() map[int]int {
	a := make(map[int]int)
	n := 0

	for i := 0; i < 8; i++ {

		if i > 3 {
			n = i + 2
		} else {
			n = i + 1
		}
		a[calcRotation(i, n)] = i
	}
	return a
}

func calcRotation(in, num int) int {
	a, b := []int{}, []int{}
	s := []int{0, 1, 2, 3, 4, 5, 6, 7}

	if num >= len(s) {
		num = num % len(s)
	}
	a, b = s[len(s)-num:], (s)[:len(s)-num]

	s = append(a, b...)

	for i, v := range s {
		if v == in {
			return i
		}
	}
	return -1

}

func (s *scrambled) unRotateOnLetter(a byte, rotTable map[int]int) {
	re := regexp.MustCompile(string(a))

	aI := re.FindIndex(*s)

	n := rotTable[aI[0]]
	if n < aI[0] {
		s.rotate('+', aI[0]-n)
	} else if n > aI[0] {
		s.rotate('-', n-aI[0])
	}

}

func (s scrambled) reversePositions(a, b int) {
	rev := s[a : b+1]
	rev.reverse()

}
func (s *scrambled) swapLetter(a, b byte) {
	reA := regexp.MustCompile(string(a))
	reB := regexp.MustCompile(string(b))

	aI := reA.FindIndex(*s)
	bI := reB.FindIndex(*s)

	(*s)[aI[0]] = b

	(*s)[bI[0]] = a
}

func (s *scrambled) rotate(dir rune, num int) {
	a, b := scrambled{}, scrambled{}
	if num >= len(*s) {
		num = num % len(*s)
	}
	if dir == '+' { //Rotate left
		a, b = (*s)[num:], (*s)[:num]
		*s = append(a, b...)

	} else {
		a, b = (*s)[len(*s)-num:], (*s)[:len(*s)-num]

		*s = append(a, b...)
	}

}

func (s scrambled) move(x, y int) {
	a := (s)[x]
	s = append((s)[:x], (s)[x+1:]...)
	s = append(s, []byte(`0`)...)
	copy(s[y+1:], s[y:])
	s[y] = a
}

func (s scrambled) reverse() {
	for i, j := 0, len(s)-1; i < len(s)/2; i, j = i+1, j-1 {
		s[i], s[j] = s[j], s[i]
	}
}
