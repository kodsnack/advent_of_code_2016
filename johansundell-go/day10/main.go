package main

import (
	"fmt"
	"log"
	"sort"
	"strconv"
	"strings"

	"github.com/johansundell/advent_of_code_2016/johansundell-go/adventofcode2016"
)

var bots = make(map[int]bot)
var outputs = make(map[int]bin)

type bot struct {
	hight, low                int
	lowIsOutbin, highIsOutbin bool
	chips                     []int
	num                       int
}

func (b *bot) give() {
	sort.Ints(b.chips)
	if b.chips[0] == 17 && b.chips[1] == 61 {
		fmt.Println(b.num, "is the bot with the chips")
	}
	if !b.lowIsOutbin {
		low := bots[b.low]
		low.rescive(b.chips[0])
		bots[b.low] = low
	} else {
		low := outputs[b.low]
		low.rescive(b.chips[0])
		outputs[b.low] = low
	}

	if !b.highIsOutbin {
		high := bots[b.hight]
		high.rescive(b.chips[1])
		bots[b.hight] = high
	} else {
		high := outputs[b.hight]
		high.rescive(b.chips[1])
		outputs[b.hight] = high
	}
	b.chips = nil
}

func (b *bot) rescive(chip int) {
	b.chips = append(b.chips, chip)
	if len(b.chips) == 2 {
		b.give()
	}
}

func (b *bot) setUpChips(chip int) {
	b.chips = append(b.chips, chip)
}

type bin struct {
	chips []int
}

func (b *bin) rescive(chip int) {
	b.chips = append(b.chips, chip)
}

func main() {
	data, err := adventofcode2016.GetInput("day10.txt")
	if err != nil {
		log.Fatal(err)
	}
	parseInput(strings.Split(data, "\n"))
}

func parseInput(inputs []string) {
	for _, input := range inputs {
		fields := strings.Fields(input)
		switch fields[0] {
		case "value":
			numBot, _ := strconv.Atoi(fields[5])
			chipVal, _ := strconv.Atoi(fields[1])
			b := bots[numBot]
			b.setUpChips(chipVal)
			bots[numBot] = b
		case "bot":
			numBot, _ := strconv.Atoi(fields[1])
			low, _ := strconv.Atoi(fields[6])
			high, _ := strconv.Atoi(fields[11])
			b := bots[numBot]
			switch fields[5] {
			case "bot":
				b.low = low
			case "output":
				b.lowIsOutbin = true
				b.low = low
			}
			switch fields[10] {
			case "bot":
				b.hight = high
			case "output":
				b.highIsOutbin = true
				b.hight = high
			}
			b.num = numBot
			bots[numBot] = b
		}
	}
	for _, v := range bots {
		if len(v.chips) == 2 {
			v.give()
		}
	}
	fmt.Println(outputs[0].chips[0] * outputs[1].chips[0] * outputs[2].chips[0])
}
