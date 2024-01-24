package internal

import "testing"

func TestMapping_Initialize(t *testing.T) {
	input := "50 98 2"

	var mapping Mapping

	mapping.initialize(input)

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

func TestMapping_HasDestination(t *testing.T) {
	input := "50 98 2"

	var mapping Mapping

	mapping.initialize(input)

	if mapping.HasDestination(105) {
		t.Fatalf("mapping should not have a destination for %d", 105)
	}

	if !mapping.HasDestination(99) {
		t.Fatalf("mapping should have a destination for %d", 99)
	}
}

func TestMapping_GetDestination(t *testing.T) {
	input := "50 98 2"

	var mapping Mapping

	mapping.initialize(input)

	destination := mapping.GetDestination(99)

	if destination != 51 {
		t.Fatalf("destination should be %d instead of %d", 51, destination)
	}
}
