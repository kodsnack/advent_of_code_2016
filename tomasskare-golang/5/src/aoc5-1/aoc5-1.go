package main

import (
	"crypto/md5"
	"fmt"
)

func main() {
	seed := "ugkcyxxp"
	key := ""

	i := 0
	k := 0
	for k < 8 {
		val := seed + fmt.Sprintf("%d", i)
		md5 := md5.Sum([]byte(val))
		md5hex := fmt.Sprintf("%x", md5)
		if string(md5hex[0:5]) == "00000" {
			key = key + string(md5hex[5])
			k++
		}
		i++
	}

	fmt.Printf("Answer: %s\n", key)
}
