package main

import "testing"

func Test_Ex1(t *testing.T) {
	input := "aaaaa-bbb-z-y-x-123[abxyz]"
	r := newRoom(input)
	if !r.isValid() {
		t.Error(input)
	}
}

func Test_Ex2(t *testing.T) {
	input := "a-b-c-d-e-f-g-h-987[abcde]"
	r := newRoom(input)
	if !r.isValid() {
		t.Error(input)
	}
}

func Test_Ex3(t *testing.T) {
	input := "not-a-real-room-404[oarel]"
	r := newRoom(input)
	if !r.isValid() {
		t.Error(input)
	}
}

func Test_Ex4(t *testing.T) {
	input := "totally-real-room-200[decoy]"
	r := newRoom(input)
	if r.isValid() {
		t.Error(input)
	}
}

func Test_Ex5(t *testing.T) {
	r := room{}
	r.id = 343
	r.name = "qzmt-zixmtkozy-ivhz"
	if r.decryptName() != "very encrypted name" {
		t.Error()
	}
}
