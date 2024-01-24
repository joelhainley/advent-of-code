package internal

import "fmt"

type Almanac struct {
	seeds               string
	seedSoilMap         string
	soilFertilizerMap   string
	fertilizerWaterMap  string
	waterLightMap       string
	lightTempMap        string
	tempHumidityMap     string
	humidityLocationMap string
}

func (a *Almanac) AddSectionRaw(section string) {
	if BeginsWith(section, "seeds") {
		fmt.Println("parsing seeds")
		//parse_seeds(section)
		return
	}
}
