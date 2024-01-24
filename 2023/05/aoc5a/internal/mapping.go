package internal

import (
	"strconv"
	"strings"
)

type Mapping struct {
	sourceStart int
	sourceEnd   int
	destStart   int
	mapRange    int
}

func (m *Mapping) initialize(input string) {
	parts := strings.Split(input, " ")

	value, err := strconv.Atoi(parts[0])
	checkErr(err)
	m.destStart = value

	value, err = strconv.Atoi(parts[1])
	checkErr(err)
	m.sourceStart = value

	value, err = strconv.Atoi(parts[2])
	checkErr(err)
	m.mapRange = value

	m.sourceEnd = m.sourceStart + m.mapRange
}

func (m *Mapping) HasDestination(location int) bool {
	if m.sourceStart <= location && location <= m.sourceEnd {
		return true
	}

	return false
}

func (m *Mapping) GetDestination(location int) int {
	// TODO the go-ish way to do this is likely to return en error from this method
	if !m.HasDestination(location) {
		panic("Mapping Does Not Cover The Supplied Start Value")
	}

	offset := location - m.sourceStart

	return offset + m.destStart
}

func checkErr(err error) {
	if err != nil {
		panic(err)
	}
}

// TODO
// string method that will find integers/regexes in a string and spit them out as an array
