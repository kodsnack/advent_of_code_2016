package main

import (
	"crypto/md5"
	"encoding/hex"
	"errors"
	"fmt"
	"log"
	"strconv"

	"github.com/johansundell/advent_of_code_2016/johansundell-go/adventofcode2016"
)

func main() {
	data, err := adventofcode2016.GetInput("day5.txt")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(findPassword(data))
}

func findPassword(input string) (string, string) {
	result := make([]byte, 8)
	pass1 := ""
	for i, foundCount := 0, 0; len(pass1) < 8 || foundCount < 8; i++ {
		str := getMd5(input + strconv.Itoa(i))
		if len(pass1) < 8 {
			pass1 += getPart1(str)
		}
		b, pos, err := getPart2(str)
		if err == nil && result[pos] == 0 {
			result[pos] = b
			foundCount++
			fmt.Println(string(result))
		}
	}
	return pass1, string(result)
}

func getPart1(str string) (out string) {
	if len(str) > 0 {
		out = str[5:6]
	}
	return
}

func getMd5(str string) string {
	sum := md5.Sum([]byte(str))
	if result := hex.EncodeToString(sum[:]); result[:5] == "00000" {
		return result
	}
	return ""
}

func getPart2(str string) (byte, int, error) {
	if len(str) > 0 {
		out := str[6]
		pos, err := strconv.Atoi(str[5:6])
		if err == nil && pos < 8 {
			return out, pos, nil
		}
	}
	return 0, 0, errors.New("Not found")
}
