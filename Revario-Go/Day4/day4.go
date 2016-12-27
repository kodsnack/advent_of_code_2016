package main

import (
	"fmt"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
	"sort"
	"strconv"
	"strings"
)

func main() {

	sectorSum, npoSector := calculateSumAndSector()
	fmt.Printf("Sum of valid sectorIDs: %v, North Pole objects sector ID: %v", sectorSum, npoSector)
}

func calculateSumAndSector() (sectorSum, npoSector int) {

	input := common.ReadFileByRow(`input.txt`)


	for _, v := range input {
		if valid, num := isRoomValid(v); valid {
			sectorSum += num
			if (decrypt(v) == `northpole object storage`) {
				npoSector = num
			}
		}
	}
	return sectorSum, npoSector
}

type ByLength []string

func (ss ByLength) Len() int {
	return len(ss)
}

func (ss ByLength) Swap (i, j int) {
	ss[i], ss[j] = ss[j], ss[i]
}

func (ss ByLength) Less(i, j int) bool {
	return len(ss[i]) > len(ss[j])
}

func isRoomValid(room string) (bool, int) {
	splStr := strings.Split(room, `-`)

	//Extract id and checksum
	idAndCheck, splStr := splStr[len(splStr)-1], splStr[:len(splStr)-1]

	id, _ := strconv.Atoi(strings.Split(idAndCheck, `[`)[0])
	checksum := strings.TrimSuffix(strings.Split(idAndCheck, `[`)[1], `]`)

	//Joint the slices and then split them to allow sorting
	splStr = strings.Split(strings.Join(splStr, ``), "")

	sort.Strings(splStr)
	js := strings.Join(splStr, ``)

	var ss []string
	for i := 0; i < len(js) - 1; {
		if js[i+1] != js[i] {
			ss, js = append(ss, js[:i + 1]), js[i + 1:]
			i = 0
		} else {
			i++
		}

	}
	ss = append(ss, js[:])

	sort.Stable(ByLength(ss))

	for i, v := range checksum {
		if byte(v) != ss[i][0] {
			return false, 0
		}
	}
	return true, id

}

func decrypt (room string) string {
	splStr := strings.Split(room, `-`)

	//Extract id
	id, _ := strconv.Atoi(strings.Split(string(strings.Join(splStr[len(splStr) - 1 :], ``)), "[")[0])

	//remove id and checksum
	splStr = splStr[:len(splStr)-1]

	ss := []rune(strings.Join(splStr, ` `))

	decrypted := ``
	shift := rune(id%26)
	for _, v := range ss {
		if v == ' ' {
			decrypted += ` `
			continue
		}
		if v+shift <= 'z' {
			decrypted += string(v+shift)
		} else {
			decrypted += string(v+shift-rune(26))
		}
	}
	return decrypted
}