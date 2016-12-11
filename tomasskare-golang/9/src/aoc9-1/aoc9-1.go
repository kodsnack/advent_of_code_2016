package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
	"unicode"
)

func main() {
	data, _ := ioutil.ReadAll(os.Stdin)

	data = bytes.Map(func(r rune) rune {
		if unicode.IsSpace(r) {
			return -1
		}
		return r
	}, data)

	decompressed := ""

	for i := 0; i < len(data); i++ {
		startMarker := bytes.IndexByte(data[i:len(data)], '(')
		if startMarker == -1 {
			decompressed = decompressed + string(data[i:len(data)])
			break
		}

		startMarker = startMarker + i

		decompressed = decompressed + string(data[i:startMarker])
		endMarker := bytes.IndexByte(data[startMarker:len(data)], ')')
		if endMarker == -1 {
			decompressed = decompressed + string(data[i:len(data)])
			break
		}

		endMarker = endMarker + startMarker

		marker := string(data[startMarker+1 : endMarker])
		markerFields := strings.Split(marker, "x")
		numberOfBytes, _ := strconv.Atoi(markerFields[0])
		numberOfTimes, _ := strconv.Atoi(markerFields[1])

		for j := 0; j < numberOfTimes; j++ {
			decompressed = decompressed +
				string(data[endMarker+1:endMarker+numberOfBytes+1])
		}

		i = endMarker + numberOfBytes
	}

	fmt.Printf("Answer: %d\n", len(decompressed))
}
