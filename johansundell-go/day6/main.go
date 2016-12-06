package main

import (
	"fmt"
	"log"
	"sort"
	"strings"

	"github.com/johansundell/advent_of_code_2016/johansundell-go/adventofcode2016"
)

func main() {
	data, err := adventofcode2016.GetInput("day6.txt")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(parseInput(strings.Split(data, "\n")))
}

type char struct {
	r     rune
	count int
}

type charList []char

func (c charList) Len() int           { return len(c) }
func (c charList) Less(i, j int) bool { return c[i].count > c[j].count }
func (c charList) Swap(i, j int)      { c[i], c[j] = c[j], c[i] }

func parseInput(inputs []string) (result string) {

	for i := 0; i < len(inputs[0]); i++ {
		str := ""
		for _, row := range inputs {
			str += string(row[i])

		}
		result += getMostCommon(str)
	}
	return
}

func getMostCommon(input string) (result string) {
	chars := make(map[rune]int)
	for _, r := range input {
		chars[r]++
	}
	list := make(charList, len(chars))
	i := 0
	for k, v := range chars {
		list[i] = char{k, v}
		i++
	}
	sort.Sort(charList(list))
	return string(list[0].r)
}
