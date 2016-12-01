package common

import (
	"io/ioutil"
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
