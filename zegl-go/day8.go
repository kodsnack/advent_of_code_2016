package main

import (
	"fmt"
)

type screen [][]bool

func day8screen(width, height int) screen {
	rows := make([][]bool, height)

	for i := range rows {
		rows[i] = make([]bool, width)
	}

	return rows
}

func (s screen) Rect(width, height int) screen {
	for r := 0; r < height; r++ {
		for c := 0; c < width; c++ {
			s[r][c] = true
		}
	}

	return s
}

func (s screen) RotateColumn(column, steps int) screen {
	current := make([]bool, len(s))
	new := make([]bool, len(s))

	// Get current
	for r := 0; r < len(s); r++ {
		current[r] = s[r][column]
	}

	// Calculate new
	for i, now := range current {
		newIndex := (i + steps) % len(current)
		new[newIndex] = now
	}

	// Replace
	for r := 0; r < len(current); r++ {
		s[r][column] = new[r]
	}

	return s
}

func (s screen) RotateRow(row, steps int) screen {
	current := make([]bool, len(s[0]))
	new := make([]bool, len(s[0]))

	// Copy slice
	copy(current, s[row])

	// Calculate new
	for i, now := range current {
		newIndex := (i + steps) % len(current)
		new[newIndex] = now
	}

	// Replace
	for r := 0; r < len(current); r++ {
		s[row][r] = new[r]
	}

	return s
}

func (s screen) Lit() int {
	count := 0

	for _, row := range s {
		for _, val := range row {
			if val {
				count++
			}
		}
	}

	return count
}

func (s screen) Print() {
	for _, row := range s {
		for _, val := range row {
			if val {
				fmt.Print("#")
			} else {
				fmt.Print(" ")
			}
		}

		fmt.Print("\n")
	}
}
