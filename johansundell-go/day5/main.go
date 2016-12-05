package main

import (
	"crypto/md5"
	"encoding/hex"
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

func findPassword(input string) (result string) {
	for i := 0; len(result) < 8; i++ {
		result += hash(input + strconv.Itoa(i))
	}
	return
}

func hash(str string) (out string) {
	sum := md5.Sum([]byte(str))
	result := hex.EncodeToString(sum[:])
	if result[:5] == "00000" {
		out = result[5:6]
	}
	return
}
