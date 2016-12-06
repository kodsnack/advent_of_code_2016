package main

import (
	"strings"
	"testing"
)

var inputs = `eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar`

func Test_Ex1(t *testing.T) {
	str, _ := parseInput(strings.Split(inputs, "\n"))
	if str != "easter" {
		t.Fail()
	}
}

func Test_Ex2(t *testing.T) {
	_, str := parseInput(strings.Split(inputs, "\n"))
	if str != "advent" {
		t.Fail()
	}
}
