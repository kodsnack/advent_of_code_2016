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
		// TODO: Get md5 sum once
		if len(pass1) < 8 {
			pass1 += hash(input + strconv.Itoa(i))
		}
		b, pos, err := hashVersion2(input + strconv.Itoa(i))
		if err == nil && result[pos] == 0 {
			result[pos] = b
			foundCount++
			fmt.Println(string(result))
		}
	}
	return pass1, string(result)
}

func hash(str string) (out string) {
	if result := getMd5(str); len(result) > 0 {
		out = result[5:6]
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

func hashVersion2(str string) (byte, int, error) {
	if result := getMd5(str); len(result) > 0 {
		out := result[6]
		pos, err := strconv.Atoi(result[5:6])
		if err == nil && pos < 8 {
			return out, pos, nil
		}
	}
	return 0, 0, errors.New("Not found")
}
