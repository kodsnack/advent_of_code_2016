package main

import (
	"crypto/md5"
	"fmt"
	"strconv"
)

func main() {
	seed := "ugkcyxxp"
	key := make([]byte, 8)

	i := 0
	k := 0
	for k < 8 {
		val := seed + fmt.Sprintf("%d", i)
		md5 := md5.Sum([]byte(val))
		md5hex := fmt.Sprintf("%x", md5)
		if string(md5hex[0:5]) == "00000" {
			pos, err := strconv.Atoi(string(md5hex[5]))
			if err == nil && pos >= 0 && pos <= 7 && key[pos] == 0 {
				key[pos] = md5hex[6]
				k++
			}
		}
		i++
	}

	fmt.Printf("Answer: %s\n", key)
}
