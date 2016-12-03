package main

import (
	"fmt"
	"strings"
	"testing"
)

func Test_Ex1(t *testing.T) {
	a := []int{5, 10, 25}
	if isValid(a) {
		t.Error()
	}
}

func Test_Ex2(t *testing.T) {
	var data = `101 301 501
102 302 502
103 303 503
201 401 601
202 402 602
203 403 603`
	inputs := strings.Split(data, "\n")
	fmt.Println(doCount(inputs))
}
