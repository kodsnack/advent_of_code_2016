package main

import "testing"

func Test_Ex1(t *testing.T) {
	input := "abc3231929"
	if hash(input) != "1" {
		t.Fail()
	}
}

func Test_Ex2(t *testing.T) {
	input := "abc5017308"
	if hash(input) != "8" {
		t.Fail()
	}
}

func Test_Ex3(t *testing.T) {
	input := "abc5278568"
	if hash(input) != "f" {
		t.Fail()
	}
}

func Test_Ex4(t *testing.T) {
	input := "abc"
	if findPassword(input) != "18f47a30" {
		t.Fail()
	}
}
