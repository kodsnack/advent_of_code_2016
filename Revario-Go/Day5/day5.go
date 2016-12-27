package main

import (
	"crypto/md5"
	"strconv"
	"fmt"
	"encoding/hex"

)

var input = "cxdnnyjw"

func main () {


	fmt.Printf("Passwords: FirstDoor: %v SecondDoor: %v", calcPasswordFirstDoor(), calcPasswordSecondDoor())

}


func calcPasswordFirstDoor() string {
	var pass string
	for i := 0; len(pass) < 8; i++{

		hash := md5.Sum([]byte(input + strconv.Itoa(i)))

		hexa := hex.EncodeToString([]byte(hash[:]))
		if hexa[0:5] == "00000" {
			pass += hexa[5:6]
		}
	}
	return pass
}

func calcPasswordSecondDoor() string {
	pass := make([]rune, 8)
	filled := make([]bool, 8)
	k := 0

	for i := 0; k < 8; i++{

		hash := md5.Sum([]byte(input + strconv.Itoa(i)))

		hexa := hex.EncodeToString([]byte(hash[:]))
		if hexa[0:5] == "00000" && (rune(hexa[5:6][0]) <= '7') {
			index, _ := strconv.Atoi(hexa[5:6])
			if filled[index] == false {
				pass[index], filled[index] = []rune(hexa[6:7])[0], true
				k++
			}

		}
	}
	return string(pass)
}


