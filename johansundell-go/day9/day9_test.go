package main

import "testing"

func Test_Ex1(t *testing.T) {
	cases := map[string]string{
		"ADVENT":          "ADVENT",
		"A(1x5)BC":        "ABBBBBC",
		"(3x3)XYZ":        "XYZXYZXYZ",
		"(6x1)(1x3)A":     "(1x3)A",
		"X(8x2)(3x3)ABCY": "X(3x3)ABC(3x3)ABCY",
	}
	for a, b := range cases {
		result := parseInput(a)
		if result != b {
			t.Error("got", result, "expected", b)
		}
	}
}

func Test_Ex2(t *testing.T) {
	cases := map[string]int{
		"(3x3)XYZTT":        11,
		"TX(8x2)(3x3)ABCYT": len("TXABCABCABCABCABCABCYT"),
		"A(2x2)BCD(2x2)EFG": 11,
		"A(2x3)BCDE":        9,
		"A(1x5)BCYY":        len("ABBBBBCYY"),
		"ADVENT":            6,
	}

	for a, b := range cases {
		result := parseInputPart2(a)
		if result != b {
			t.Error("got", result, "expected", b, "from", a)
		}
	}
}
