package main

import "fmt"

var input = `11011110011011101`
var part1Len = 272
var part2Len = 35651584

func main() {
	fmt.Printf("Checksum Part 1: %v, Part 2: %v", calculateChecksum(genDragon(input, part1Len)[:part1Len]), calculateChecksum(genDragon(input, part2Len)[:part2Len]))
}

func calculateChecksum(input string) (rs string) {
	c := []byte{}
	for i := 0; i < len(input)-1; i += 2 {
		if input[i] == input[i+1] {
			c = append(c, '1')
		} else {
			c = append(c, '0')
		}
	}
	rs = string(c)
	if len(rs)%2 == 0 {
		rs = calculateChecksum(rs)
	}
	return rs
}

func genDragon(input string, l int) string {
	b := flip(reverse(input))
	input = input + `0` + b
	if len(input) < l {
		input = genDragon(input, l)
	}
	return input
}


func flip(s string) string {
	a := []byte{}
	for _, v := range s {
		if v == '1' {
			a = append(a, '0')
		} else {
			a = append(a, '1')
		}
	}
	return string(a)
}

func reverse(s string) string {
	r := []rune(s)
	for i, j := 0, len(r)-1; i < len(r)/2; i, j = i+1, j-1 {
		r[i], r[j] = r[j], r[i]
	}
	return string(r)
}
