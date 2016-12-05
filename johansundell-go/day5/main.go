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
	fmt.Println(findPassword(data), findPasswordVersion2(data))
}

func findPassword(input string) (result string) {
	for i := 0; len(result) < 8; i++ {
		result += hash(input + strconv.Itoa(i))
	}
	return
}

func findPasswordVersion2(input string) string {
	result := make([]byte, 8)
	for i, foundCount := 0, 0; foundCount < 8; i++ {
		b, pos, err := hashVersion2(input + strconv.Itoa(i))
		if err == nil && result[pos] == 0 {
			result[pos] = b
			foundCount++
			fmt.Println(string(result))
		}
	}
	return string(result)
}

func hash(str string) (out string) {
	sum := md5.Sum([]byte(str))
	result := hex.EncodeToString(sum[:])
	if result[:5] == "00000" {
		out = result[5:6]
	}
	return
}

func hashVersion2(str string) (byte, int, error) {
	sum := md5.Sum([]byte(str))
	result := hex.EncodeToString(sum[:])
	if result[:5] == "00000" {
		out := result[6]
		pos, err := strconv.Atoi(result[5:6])
		if err == nil && pos < 8 {
			return out, pos, nil
		}
	}
	return 0, 0, errors.New("Not found")
}
