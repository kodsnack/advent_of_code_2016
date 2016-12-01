package main

import "testing"

func Test_Ex1(t *testing.T) {
	d, _ := walk("R2, L3")
	if d != 5 {
		t.Error()
	}
}

func Test_Ex2(t *testing.T) {
	d, _ := walk("R2, R2, R2")
	if d != 2 {
		t.Error()
	}
}

func Test_Ex3(t *testing.T) {
	d, _ := walk("R5, L5, R5, R3")
	if d != 12 {
		t.Error()
	}
}

func Test_Ex4(t *testing.T) {
	d, _ := walk("R2, R2, R2, R2")
	if d != 0 {
		t.Error(d)
	}
}

func Test_Ex5(t *testing.T) {
	d, _ := walk("R2, L1, R2, R1, R1, L3, R3, L5, L5, L2, L1")
	if d != 10 {
		t.Error(d)
	}
}

func Test_Ex6(t *testing.T) {
	_, p := walk("R8, R4, R4, R8")
	if p.distance() != 4 {
		t.Error(p)
	}
}
