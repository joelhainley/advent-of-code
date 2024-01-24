package internal

import "testing"

func TestMap_Initialize(t *testing.T) {

	inputLine1 := "50 98 2"
	inputLine2 := "52 50 48"

	input := []string{inputLine1, inputLine2}

	var mapset MapSet

	mapset.initialize(input)

	// NEXT : write the tests for this

	if mapping.destStart != 50 {
		t.Fatalf("destStart should be %d it is %d", 50, mapping.destStart)
	}

	if mapping.sourceStart != 98 {
		t.Fatalf("sourceStart should be %d it is %d", 98, mapping.sourceStart)
	}

	if mapping.mapRange != 2 {
		t.Fatalf("mapRange should be %d it is %d", 2, mapping.mapRange)
	}

	if mapping.sourceEnd != 100 {
		t.Fatalf("sourceEnd should be %d it is %d", 100, mapping.sourceEnd)
	}
}
