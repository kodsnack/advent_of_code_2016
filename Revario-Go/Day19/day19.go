package main

import "fmt"

func main() {
	fmt.Printf("Elf with all presents Part 1: %v Part 2: %v", calcElfPart1(3012210), calcElfPart2(3012210))
}

func calcElfPart1(num int) int {
	e := make([]int, num)
	for i := 0; i < num; i++ {
		e[i] = i + 1
	}

	for len(e) > 1 {
		a := []int{}
		for i := range e {
			if i == len(e)-1 && i%2 == 0 {
				a = append(a, e[i])
				a = a[1:]
			} else if i%2 == 0 {
				a = append(a, e[i])
			}

		}
		e = a
	}
	return e[0]
}

func calcElfPart2(num int) int {
	a := make([]int, num/2)
	b := make([]int, num/2)

	if num%2 == 0 {

		for i := 0; i < num/2; i++ {
			a[i] = i + 1
			b[i] = i + num/2 + 1
		}
	} else {
		for i := 0; i < num/2; i++ {
			a[i] = i + 1
			b[i] = i + num/2 + 2
			if i == num/2-1 {
				a = append(a, num/2+1)
			}
		}
	}

	for len(a)+len(b) > 1 {

		if (len(a)+len(b))%2 == 0 {
			b = b[1:]
		} else {
			a = a[:len(a)-1]
		}

		if len(a)+len(b) > 1 {
			a = append(a, b[0])
			b = b[1:]
			b = append(b, a[0])
			a = a[1:]
		} else {
			if len(a) > 0 {
				return a[0]
			}
			return b[0]
		}
	}
	return -1

}
