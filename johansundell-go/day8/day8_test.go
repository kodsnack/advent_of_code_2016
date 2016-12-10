package main

import "testing"

func Test_Ex1(t *testing.T) {
	inputs := []string{
		"rect 3x2",
		"rotate column x=1 by 1",
		"rotate row y=0 by 4",
		"rotate column x=1 by 1",
	}
	parseInput(inputs, 3, 7)
}
