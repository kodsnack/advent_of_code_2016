package main

import (
	"io/ioutil"
	"os"
	"regexp"
	"strconv"
	"strings"
	"testing"
)

func TestDay8screenexample(t *testing.T) {
	screen := day8screen(7, 3)

	screen.Rect(3, 2)
	screen.RotateColumn(1, 1)
	screen.RotateRow(0, 4)
	screen.RotateColumn(1, 1)

	t.Log(screen.Lit())
}

func TestDay8Part1(t *testing.T) {
	f, err := os.OpenFile("day8_input.txt", os.O_RDONLY, 0)

	if err != nil {
		t.Error(err)
		return
	}

	all, _ := ioutil.ReadAll(f)
	rows := strings.Split(string(all), "\n")

	screen := day8screen(50, 6)

	rect := regexp.MustCompile("rect ([0-9]+)x([0-9]+)")
	rotateRow := regexp.MustCompile("rotate row y=([0-9]+) by ([0-9]+)")
	rotateColumn := regexp.MustCompile("rotate column x=([0-9]+) by ([0-9]+)")

	for _, row := range rows {

		if rect.MatchString(row) {
			m := rect.FindAllStringSubmatch(row, -1)[0]

			width, _ := strconv.Atoi(m[1])
			height, _ := strconv.Atoi(m[2])
			screen.Rect(width, height)
			continue
		}

		if rotateRow.MatchString(row) {
			m := rotateRow.FindAllStringSubmatch(row, -1)[0]

			rowID, _ := strconv.Atoi(m[1])
			amount, _ := strconv.Atoi(m[2])

			screen.RotateRow(rowID, amount)
			continue
		}

		if rotateColumn.MatchString(row) {
			m := rotateColumn.FindAllStringSubmatch(row, -1)[0]

			column, _ := strconv.Atoi(m[1])
			amount, _ := strconv.Atoi(m[2])

			screen.RotateColumn(column, amount)
			continue
		}

		t.Error("Unknown?", row)
	}

	t.Log(screen.Lit())
	screen.Print()
}

func TestDay8Part2(t *testing.T) {
	TestDay8Part1(t)
}
