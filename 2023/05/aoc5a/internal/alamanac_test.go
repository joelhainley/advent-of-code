package internal

import "testing"

func TestAlmanac_AddSectionRaw(t *testing.T) {

}

func TestAlmanac_ParseSeeds(t *testing.T) {
	input := "seeds: 79 14 55 13"

	var almanac Almanac

	almanac.parseSeeds(input)

	seedLength := len(almanac.seeds.seeds)

	if seedLength != 4 {
		t.Fatalf("invalid seed length, expected %d found %d", 4, seedLength)
	}

	seed := almanac.seeds.seeds[0]

	if seed.id != 79 {
		t.Fatalf("invalid seed value, expected %d found %d", 79, seed.id)
	}
}

func TestAlmanac_ParseMap(t *testing.T) {
	line1 := "seed-to-soil map:"
	line2 := "50 98 2"
	line3 := "52 50 48"

	testInput := []string{line1, line2, line3}

	var almanac Almanac

	mapSet := almanac.parseMap(testInput)

	if len(mapSet.mappings) != 2 {
		t.Fatalf("unexpected mapping count %d is not the expected value %d", len(mapSet.mappings), 2)
	}

}
