package main

import "testing"

func Test_Ex1(t *testing.T) {
	cases := map[string]bool{
		"abba[mnop]qrst":       true,
		"abcd[bddb]xyyx":       false,
		"aaaa[qwer]tyui":       false,
		"ioxxoj[asdfgh]zxcvbn": true,
	}
	for input, expected := range cases {
		if supportsTls(input) != expected {
			t.Error(input, "expected", expected)
		}
	}
}
