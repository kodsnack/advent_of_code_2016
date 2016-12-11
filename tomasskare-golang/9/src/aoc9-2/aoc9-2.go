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

func decompressLen(data []byte) int {
	decompressedLen := 0

	for i := 0; i < len(data); i++ {
		startMarker := bytes.IndexByte(data[i:len(data)], '(')
		if startMarker == -1 {
			decompressedLen = decompressedLen + len(data) - i
			break
		}

		startMarker = startMarker + i

		decompressedLen = decompressedLen + startMarker - i
		endMarker := bytes.IndexByte(data[startMarker:len(data)], ')')
		if endMarker == -1 {
			decompressedLen = decompressedLen + len(data) - i
			break
		}

		endMarker = endMarker + startMarker

		marker := string(data[startMarker+1 : endMarker])
		markerFields := strings.Split(marker, "x")
		numberOfBytes, _ := strconv.Atoi(markerFields[0])
		numberOfTimes, _ := strconv.Atoi(markerFields[1])

		decompressedLen = decompressedLen +
			decompressLen(data[endMarker+1:endMarker+numberOfBytes+1])*
				numberOfTimes

		i = endMarker + numberOfBytes

	}

	return decompressedLen
}

func main() {
	data, _ := ioutil.ReadAll(os.Stdin)

	data = bytes.Map(func(r rune) rune {
		if unicode.IsSpace(r) {
			return -1
		}
		return r
	}, data)

	decompressedLen := decompressLen(data)

	fmt.Printf("Answer: %d\n", decompressedLen)
}
