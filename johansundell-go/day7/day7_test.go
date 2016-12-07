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

func Test_Ex2(t *testing.T) {
	cases := map[string]bool{
		"aba[bab]xyz":   true,
		"xyx[xyx]xyx":   false,
		"aaa[kek]eke":   true,
		"zazbz[bzb]cdb": true,
	}
	for input, expected := range cases {
		if supportsSsl(input) != expected {
			t.Error(input, "expected", expected)
		}

	}
}
