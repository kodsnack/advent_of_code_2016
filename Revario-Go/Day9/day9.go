package main

import (
	"fmt"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
	"regexp"
	"strconv"
)

var inputPath = `input.txt`

func main() {
	fmt.Printf("Uncompressed length: v1: %v  v2: %v", decompressString(common.ReadEntireFile(inputPath)), calcDecompressed(common.ReadEntireFile(inputPath)))
}

var reg = regexp.MustCompile(`\((\d+)x(\d+)\)`)

func decompressString(input string) int {
	num := 0

	for {
		if match := reg.FindStringSubmatchIndex(input); match != nil {
			l, _ := strconv.Atoi(input[match[2]:match[3]])
			n, _ := strconv.Atoi(input[match[4]:match[5]])
			if match[0] != 0 {
				num += len(input[:match[0]])
			}
			input = input[match[5]+1:]

			num += l * n
			input = input[l:]
		} else {
			num += len(input)
			break
		}
	}
	return num
}

func calcDecompressed(s string) int {
	num := 0
	for {
		if match := reg.FindStringSubmatchIndex(s); match != nil {
			l, _ := strconv.Atoi(s[match[2]:match[3]])
			n, _ := strconv.Atoi(s[match[4]:match[5]])
			if match[0] != 0 {
				num += len(s[:match[0]])
			}
			s = s[match[5]+1:]
			num += calcDecompressed(s[:l]) * n
			s = s[l:]

		} else {
			num += len(s)
			break
		}
	}
	return num
}
