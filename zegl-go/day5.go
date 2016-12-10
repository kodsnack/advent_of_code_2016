package main

import (
	"crypto/md5"
	"encoding/hex"
	// "fmt"
	"strconv"
	"strings"
)

func day5_part1(input string) string {
	res := ""
	i := 0

	for {
		t := input + strconv.Itoa(i)
		md := md5.Sum([]byte(t))

		asStr := hex.EncodeToString(md[:])

		if strings.HasPrefix(asStr, "00000") {
			res += string(asStr[5])

			if len(res) == 8 {
				return res
			}
		}

		i++
	}
}

func day5_part2(input string) string {
	res := make([]string, 8)

	setPos := 0

	i := 0

	for {
		t := input + strconv.Itoa(i)
		md := md5.Sum([]byte(t))

		asStr := hex.EncodeToString(md[:])

		if strings.HasPrefix(asStr, "00000") {

			pos := string(asStr[5])

			posI, err := strconv.Atoi(pos)

			if err == nil && posI < 8 {
				if res[posI] == "" {
					res[posI] = string(asStr[6])
					setPos++
				}
			}

			if setPos == 8 {
				return strings.Join(res, "")
			}
		}

		i++
	}
}
