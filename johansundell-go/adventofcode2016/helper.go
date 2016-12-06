package adventofcode2016

import (
	"io/ioutil"
	"sort"
)

func GetInput(day string) (string, error) {
	b, err := ioutil.ReadFile("./../inputs/" + day)
	if err != nil {
		return "", err
	}
	return string(b), nil
}

type Char struct {
	R     rune
	Count int
}

type CharList []Char

func (c CharList) Len() int { return len(c) }
func (c CharList) Less(i, j int) bool {
	if c[i].Count == c[j].Count {
		return c[i].R < c[j].R
	}
	return c[i].Count > c[j].Count
}
func (c CharList) Swap(i, j int) { c[i], c[j] = c[j], c[i] }

func GetSortedCharList(input string, sortRevese bool) CharList {
	chars := make(map[rune]int)
	for _, r := range input {
		chars[r]++
	}
	list := make(CharList, len(chars))
	i := 0
	for k, v := range chars {
		list[i] = Char{k, v}
		i++
	}
	if sortRevese {
		sort.Sort(sort.Reverse(CharList(list)))

	} else {
		sort.Sort(CharList(list))
	}
	return list
}
