package internal

import "fmt"

type MapSet struct {
	mappings []Mapping
}

func (m *MapSet) initialize(section []string) {

	if BeginsWith(section, "seeds") {
		fmt.Println("parsing seeds")
		//parse_seeds(section)
		return
	}
}

/*
def get_destination(location)

	@mappings.each do |mapping|
	  if mapping.has_source?(location)
	    return mapping.get_source(location)
	  end
	end

	# Any source numbers that aren't mapped correspond to the same destination number
	location

end
*/
func (m *Map) GetDestination(location int) {
	// look through each mapping and see if we have the passed location in our source

	// otherwise return the location as the source
}

/*
def get_source(destination)

	@mappings.each do |mapping|
	  if mapping.has_source?(destination)
	    return mapping.get_source(destination)
	  end
	end

	# Any source numbers that aren't mapped correspond to the same destination number
	destination

end
*/
func (m *Map) GetSource(destination int) {
	//
}
