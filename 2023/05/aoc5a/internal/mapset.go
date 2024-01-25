package internal

import (
	"fmt"
	"sort"
)

type MapSet struct {
	mappings   []Mapping
	minMapping int
	maxMapping int
	hasGaps    bool
}

func (m *MapSet) initialize(sectionLines []string) {
	for _, line := range sectionLines {
		mapping := NewMapping(line)
		m.mappings = append(m.mappings, mapping)
	}

	sort.Slice(m.mappings[:], func(i, j int) bool {
		return m.mappings[i].sourceStart < m.mappings[j].sourceStart
	})

	min, max := m.GetCoverage()

	m.minMapping = min
	m.maxMapping = max

	m.hasGaps = m.hasCoverageGaps()
}

func MapSetFromRaw(sectionLines []string) MapSet {
	var mapSet MapSet

	mapSet.initialize(sectionLines)

	return mapSet
}

func (m *MapSet) GetDestination(location int) int {
	// look through each mapping and see if we have the passed location in our source
	for _, mapping := range m.mappings {
		if mapping.HasDestination(location) {
			return mapping.GetDestination(location)
		}
	}

	// otherwise return the location as the source
	return location
}

func (m *MapSet) hasCoverageGaps() bool {
	prevEnd := -1
	for index, mapping := range m.mappings {
		if prevEnd != -1 {
			if mapping.sourceStart != prevEnd {
				fmt.Printf("\nmapSet: %d :: sourceStart: %d - prevEnd: %d\n", index, mapping.sourceStart, prevEnd)
				return true
			}
		}
		prevEnd = mapping.sourceEnd
	}

	return false
}

func (m *MapSet) GetCoverage() (min int, max int) {
	min = m.mappings[0].sourceStart
	max = m.mappings[len(m.mappings)-1].sourceEnd

	return min, max
}
