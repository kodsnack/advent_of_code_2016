package main

import "testing"

func Test_Ex1(t *testing.T) {
	input := "abc3231929"
	if getPart1(getMd5(input)) != "1" {
		t.Fail()
	}
}

func Test_Ex2(t *testing.T) {
	input := "abc5017308"
	if getPart1(getMd5(input)) != "8" {
		t.Fail()
	}
}

func Test_Ex3(t *testing.T) {
	input := "abc5278568"
	if getPart1(getMd5(input)) != "f" {
		t.Fail()
	}
}

func Test_Ex4(t *testing.T) {
	input := "abc"
	pass, _ := findPassword(input)
	if pass != "18f47a30" {
		t.Fail()
	}
}

func Test_Ex5(t *testing.T) {
	input := "abc3231929"
	b, pos, _ := getPart2(getMd5(input))
	if string(b) != "5" || pos != 1 {
		t.Fail()
	}
}

func Test_Ex6(t *testing.T) {
	input := "abc5017308"
	str, pos, err := getPart2(getMd5(input))

	if str != 0 || pos != 0 || err == nil {
		t.Fail()
	}
}

func Test_Ex7(t *testing.T) {
	input := "abc5357525"
	b, pos, _ := getPart2(getMd5(input))
	if string(b) != "e" || pos != 4 {
		t.Fail()
	}
}

func Test_Ex8(t *testing.T) {
	input := "abc"
	correct := "05ace8e3"
	_, result := findPassword(input)
	if result != correct {
		t.Error("expected " + correct + " got " + result)
	}
}

func Test_Ex9(t *testing.T) {
	input := "ffykfhsq"
	pass1, pass2 := findPassword(input)
	if pass1 != "c6697b55" || pass2 != "8c35d1ab" {
		t.Fail()
	}
}
