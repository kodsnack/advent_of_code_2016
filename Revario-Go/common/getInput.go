package common

import (
	"bufio"
	"io/ioutil"
	"os"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func ReadCSVFile(fileName string) []string {
	data, err := ioutil.ReadFile(fileName)
	check(err)

	instr := strings.Split(string(data), ", ")

	return instr
}

func ReadFileByRow(fileName string) []string {
	file, err := os.Open(fileName)
	check(err)

	defer file.Close()

	scanner := bufio.NewScanner(file)
	var lines []string
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	return lines
}

func ReadEntireFile(fileName string) string {
	data, err := ioutil.ReadFile(fileName)
	check(err)
	return string(data)
}
