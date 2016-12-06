package main

import (
	"log"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

func day4parser(roomID string) (int, bool) {

	r := regexp.MustCompile("([a-z-]+)([0-9]+)\\[([a-z]+)\\]")

	res := r.FindStringSubmatch(roomID)

	sectorID, err := strconv.Atoi(res[2])

	if err != nil {
		log.Panic("invalid input:", roomID)
	}

	if day4calculateMostPopularChars(res[1]) == res[3] {
		return sectorID, true
	}

	return sectorID, false
}

func day4calculateMostPopularChars(in string) string {
	in = strings.Replace(in, "-", "", -1)

	counts := make(map[int][]string)

	alphabet := "abcdefghijklmnopqrstuvwxyz"

	for _, char := range alphabet {
		cnt := strings.Count(in, string(char))

		if _, ok := counts[cnt]; !ok {
			counts[cnt] = make([]string, 0)
		}

		counts[cnt] = append(counts[cnt], string(char))
	}

	popularCounts := []int{}

	for c := range counts {
		popularCounts = append(popularCounts, c)
	}

	sort.Sort(sort.Reverse(sort.IntSlice(popularCounts)))

	res := ""

	for _, key := range popularCounts {
		for _, char := range counts[key] {
			res += char

			if len(res) == 5 {
				return res
			}
		}
	}

	return res
}

func day4shitfChiper(input string) string {
	r := regexp.MustCompile("([a-z-]+)([0-9]+)\\[([a-z]+)\\]")

	res := r.FindStringSubmatch(input)

	roomID := res[1]

	sectorID, _ := strconv.Atoi(res[2])

	_ = sectorID

	decrypted := ""

	for _, char := range roomID {

		if char == '-' {
			char = ' '
		} else {

			for i := 0; i < sectorID; i++ {

				if char == 'z' {
					char = 'a'
				} else {
					char++
				}
			}

		}

		decrypted += string(char)
	}

	return strings.TrimSpace(decrypted)
}
