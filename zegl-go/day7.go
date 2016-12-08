package main

func day7_part1(ip string) bool {
	isInsideBrackets := false
	hasAbba := false

	for i := 0; i < len(ip)-3; i++ {
		if ip[i] == '[' {
			isInsideBrackets = true
		}

		if ip[i] == ']' {
			isInsideBrackets = false
		}

		// Test if an ABBA starts at this position
		if ip[i] != ip[i+1] && ip[i] == ip[i+3] && ip[i+1] == ip[i+2] {
			if isInsideBrackets {
				return false
			}

			hasAbba = true
		}
	}

	return hasAbba
}

func day7_part2(ip string) bool {
	outerIsInsideBrackets := false

	for i := 0; i < len(ip)-2; i++ {
		if ip[i] == '[' {
			outerIsInsideBrackets = true
		}

		if ip[i] == ']' {
			outerIsInsideBrackets = false
		}

		// Test if an ABA starts at this position
		if !outerIsInsideBrackets && ip[i] != ip[i+1] && ip[i] == ip[i+2] {
			isInsideBrackets := false

			// Search for BAB
			for ii := 0; ii < len(ip)-2; ii++ {
				if ip[ii] == '[' {
					isInsideBrackets = true
				}

				if ip[ii] == ']' {
					isInsideBrackets = false
				}

				if isInsideBrackets {
					//  A__  == _A_      && _B_     == B__    && _B_     == __B
					if ip[i] == ip[ii+1] && ip[i+1] == ip[ii] && ip[i+1] == ip[ii+2] {
						return true
					}
				}
			}
		}
	}

	return false
}
