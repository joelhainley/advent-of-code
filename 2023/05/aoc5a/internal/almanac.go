package internal

import (
	"fmt"
	"strconv"
	"strings"
)

type Almanac struct {
	seeds               Seeds
	seedSoilMap         MapSet
	soilFertilizerMap   MapSet
	fertilizerWaterMap  MapSet
	waterLightMap       MapSet
	lightTempMap        MapSet
	tempHumidityMap     MapSet
	humidityLocationMap MapSet
}

func (a *Almanac) AddSectionRaw(section []string) {
	// check the first 5 chars of the first element of the section to determine what were dealing with
	firstLine := section[0][:5]

	switch firstLine {
	case "seeds":
		a.parseSeeds(section[0])
	case "seed-":
		a.seedSoilMap = a.parseMap(section)
	case "soil-":
		a.soilFertilizerMap = a.parseMap(section)
	case "ferti":
		a.fertilizerWaterMap = a.parseMap(section)
	case "water":
		a.waterLightMap = a.parseMap(section)
	case "light":
		a.lightTempMap = a.parseMap(section)
	case "tempe":
		a.tempHumidityMap = a.parseMap(section)
	case "humid":
		a.humidityLocationMap = a.parseMap(section)
	}
}

func (a *Almanac) GetLowestDestinationA() int {
	lowestDestination := -1

	for _, seed := range a.seeds.seeds {
		seed.soil = a.seedSoilMap.GetDestination(seed.id)
		seed.fertilizer = a.soilFertilizerMap.GetDestination(seed.soil)
		seed.water = a.fertilizerWaterMap.GetDestination(seed.fertilizer)
		seed.light = a.waterLightMap.GetDestination(seed.water)
		seed.temp = a.lightTempMap.GetDestination(seed.light)
		seed.humidity = a.tempHumidityMap.GetDestination(seed.temp)
		seed.location = a.humidityLocationMap.GetDestination(seed.humidity)

		if lowestDestination == -1 || lowestDestination > seed.location {
			lowestDestination = seed.location
		}
	}

	return lowestDestination
}

func (a *Almanac) GetLowestDestinationB() int {
	lowestDestination := -1

	for i := 0; i < len(a.seeds.seeds); i = i + 2 {
		start := a.seeds.seeds[i].id
		length := a.seeds.seeds[i+1].id
		fmt.Printf("\nprocessing seeds starting at %d for %d numbers\n", start, length)

		for j := start; j < start+length; j++ {
			soil := a.seedSoilMap.GetDestination(j)
			fertilizer := a.soilFertilizerMap.GetDestination(soil)
			water := a.fertilizerWaterMap.GetDestination(fertilizer)
			light := a.waterLightMap.GetDestination(water)
			temp := a.lightTempMap.GetDestination(light)
			humidity := a.tempHumidityMap.GetDestination(temp)
			location := a.humidityLocationMap.GetDestination(humidity)

			fmt.Printf("%d\t%d\t%d\t%d\t%d\t%d\t%d\n", soil, fertilizer, water, light, temp, humidity, location)

			if lowestDestination == -1 || lowestDestination > location {
				lowestDestination = location
			}
		}
	}

	return lowestDestination
}

/*
dumps mappings to stdio so I can understand what the mappings look like
*/
func (a *Almanac) DumpMappings() {
	dumpMapping("Seed Soil Map", a.seedSoilMap)
	dumpMapping("Soil Fertilizer Map", a.soilFertilizerMap)
	dumpMapping("Fertilizer Water Map", a.fertilizerWaterMap)
	dumpMapping("Water Light Map", a.waterLightMap)
	dumpMapping("Light Temp Map", a.lightTempMap)
	dumpMapping("Temp Humidity Map", a.tempHumidityMap)
	dumpMapping("Humidity Location Map", a.humidityLocationMap)
}

func dumpMapping(label string, mapSet MapSet) {
	fmt.Printf("\n%s\n", label)
	fmt.Printf("Has Coverage Gaps: %t\n", mapSet.hasGaps)
	fmt.Printf("Min / Max: %d / %d\n", mapSet.minMapping, mapSet.maxMapping)
	fmt.Printf("start\tend\toffset\n")
	for _, mapping := range mapSet.mappings {
		fmt.Printf("%d\t%d\t%d\n", mapping.sourceStart, mapping.sourceEnd, mapping.offset)
	}

}

func (a *Almanac) parseSeeds(section string) {
	parts := strings.Split(section, " ")

	for i := 1; i < len(parts); i++ {
		intValue, err := strconv.Atoi(parts[i])

		if err != nil {
			panic(err)
		}
		a.seeds.AddSeedValue(intValue)
	}
}

func (a *Almanac) parseMap(section []string) MapSet {
	// send to new map to parse
	var mapSet = MapSetFromRaw(section[1:])

	// return new map
	return mapSet
}
