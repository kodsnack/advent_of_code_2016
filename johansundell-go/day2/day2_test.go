package main

import "testing"

var input = []string{"ULL", "RRDDD", "LURDL", "UUUUD"}

func Test_Ex1(t *testing.T) {

	answer := "1985"
	code := getCode(input, keypadOne, 1, 1)

	if answer != code {
		t.Error("Not correct code", answer, code)
	}
}

/*if !reflect.DeepEqual(answer, code) {
	t.Error("Not correct code", answer, code)
}*/

func Test_Ex2(t *testing.T) {
	answer := "5DB3"
	code := getCode(input, keypadTwo, 0, 2)
	if answer != code {
		t.Error("Not correct code", answer, code)
	}
}
