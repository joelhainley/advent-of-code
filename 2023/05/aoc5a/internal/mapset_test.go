package internal

import "testing"

func TestMap_Initialize(t *testing.T) {

	inputLine1 := "50 98 2"
	inputLine2 := "52 50 48"

	input := []string{inputLine1, inputLine2}

	var mapSet MapSet

	mapSet.initialize(input)

	mapCount := len(mapSet.mappings)

	if mapCount != 2 {
		t.Fatalf("return value should be %d but it is %d", 2, mapCount)
	}

}

func TestMap_GetDestination(t *testing.T) {
	inputLine1 := "50 98 2"
	inputLine2 := "52 50 48"

	input := []string{inputLine1, inputLine2}

	var mapSet MapSet

	mapSet.initialize(input)

	result := mapSet.GetDestination(99)
	if result != 51 {
		t.Fatalf("return value should be %d but it is %d", 51, result)
	}

	result = mapSet.GetDestination(202)
	if result != 202 {
		t.Fatalf("return value should be %d but it is %d", 202, result)
	}
}
