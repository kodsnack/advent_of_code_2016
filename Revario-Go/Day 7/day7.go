package main

import (
	"fmt"
	"github.com/revario/advent_of_code_2016/Revario-Go/common"
	"regexp"
)

func main() {
	fmt.Printf("Number of ip with TLS support: %v, SSL support: %v", calculateNumWithTLS(), calculateNumWithSSL())
}

func calculateNumWithTLS() int {
	input := common.ReadFileByRow(`input.txt`)

	num := 0
	for _, v := range input {
		if isTLS(v) {
			num++
		}
	}
	return num
}



func isTLS(s string) bool {

	reg := regexp.MustCompile(`\[.+?]`)
	hyp := reg.FindAllString(s, -1)
	if hyp == nil {
		return false
	}

	ext := s
	for i := 0; i < len(ext)-3; i++ {
		if ext[i] == ext[i+1] {
			continue
		}
		if ext[i] == ext[i+3] && ext[i+1] == ext[i+2] {
			for _, v := range hyp {
				for j := 0; j < len(v)-3; j++ {
					if v[j] == v[j+3] && v[j+1] == v[j+2] {
						return false
					}
				}
			}
			return true
		}
	}
	return false
}

func calculateNumWithSSL() int {
	input := common.ReadFileByRow(`input.txt`)

	num := 0
	for _, v := range input {
		if isSSL(v) {
			num++
		}
	}
	return num
}

func isSSL(s string) bool {

	reg := regexp.MustCompile(`\[.+?]`)
	hyp := reg.FindAllString(s, -1)
	if hyp == nil {
		return false
	}
	ext := reg.ReplaceAllString(s, ` `)

	//ext := s
	for i := 0; i < len(ext)-2; i++ {
		if ext[i] == ext[i+1] {
			continue
		}
		if ext[i] == ext[i+2] {
			for _, v := range hyp {
				for j := 0; j < len(v)-2; j++ {

					if v[j] == v[j+2] && v[j] == ext[i+1] && v[j+1] == ext[i] {
						return true

					}
				}
			}
		}
	}
	return false
}