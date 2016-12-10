package main

import "testing"

func Test_Ex1(t *testing.T) {
	cases := map[string]int{
		"ADVENT":          len("ADVENT"),
		"A(1x5)BC":        len("ABBBBBC"),
		"(3x3)XYZ":        len("XYZXYZXYZ"),
		"(6x1)(1x3)A":     len("(1x3)A"),
		"X(8x2)(3x3)ABCY": len("X(3x3)ABC(3x3)ABCY"),
	}
	for a, b := range cases {
		result := parseInput(a, false)
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
		"(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN": 445,
		"(27x12)(20x12)(13x14)(7x10)(1x12)A":                       241920,
	}

	for a, b := range cases {
		result := parseInput(a, true)
		if result != b {
			t.Error("got", result, "expected", b, "from", a)
		}
	}
}
