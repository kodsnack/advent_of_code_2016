package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"strconv"
	"strings"
)

var input = `ngcjuoqr`



func main() {

	fmt.Printf("Index Part 1: %v, Part 2: %v", find64th(false), find64th(true))

}

func find64th(stretch bool) int {
	keyNum := []int{}
	hashes := []string{}
	for i := 0; true; i++ {
		if len(hashes) < i+1000 {
			if stretch {
				hashes = append(hashes, generateHashes(len(hashes), 1001, true)...)
			} else {
				hashes = append(hashes, generateHashes(len(hashes), 1001, false)...)
			}
		}
		char, found := hasStartSeq(hashes[i])
		if found {
			for _, vv := range hashes[i+1 : i+1001] {
				if hasEndSeq(char, vv) {

					keyNum = append(keyNum, i)
					break
				}
			}
		}

		if len(keyNum) == 64 {
			return keyNum[63]
		}
	}
	return -1
}
func hasStartSeq(hash string) (byte, bool) {
	for i := 0; i < len(hash)-2; i++ {
		if strings.Count(string(hash[i:i+3]), string(hash[i])) == 3 {
			return hash[i], true
		}
	}
	return '0', false
}

func hasEndSeq(keyChar byte, hash string) bool {
	for i := 0; i < len(hash)-5; i++ {
		if strings.Count(string(hash[i:i+5]), string(keyChar)) == 5 {
			return true
		}
	}
	return false
}

func generateHashes(start, amount int, stretched bool) []string {

	hashes := []string{}
	for i := 0; i < amount; i++ {

		hash := md5.Sum([]byte(input + strconv.Itoa(start+i)))
		hexa := hex.EncodeToString([]byte(hash[:]))
		hashes = append(hashes, hexa)

		if stretched {
			for a := 0; a < 2016; a++ {
				hash := md5.Sum([]byte(hashes[i]))
				hexa := hex.EncodeToString([]byte(hash[:]))
				hashes[i] = hexa
			}
		}
	}
	return hashes
}
