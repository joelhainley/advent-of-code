package main

import (
	"aoc5a/internal"
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {

	stat, _ := os.Stdin.Stat()

	if (stat.Mode() & os.ModeCharDevice) != 0 {
		fmt.Printf("This application uses stdin for example: cat file.txt | aoc05-part-a")
		os.Exit(0)
	}

	almanac := processPipe()

	almanac.DumpMappings()
	//lowestDestination := almanac.GetLowestDestinationA()
	//
	//fmt.Printf("PART A: the lowest destination is: %d\n", lowestDestination)
	//
	//lowestDestination = almanac.GetLowestDestinationB()
	//
	//fmt.Printf("PART B: the lowest destination is: %d\n", lowestDestination)

	os.Exit(0)
}

func processPipe() internal.Almanac {
	scanner := bufio.NewScanner(os.Stdin)
	var section []string
	var almanac internal.Almanac

	for scanner.Scan() {
		line := scanner.Text()
		cleaned := strings.TrimSuffix(line, "\n")

		if len(cleaned) == 0 {
			almanac.AddSectionRaw(section)
			section = make([]string, 0)
		} else {
			section = append(section, cleaned)
		}
	}

	if len(section) > 0 {
		almanac.AddSectionRaw(section)
	}

	return almanac
}
