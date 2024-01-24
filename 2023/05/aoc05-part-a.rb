#!/usr/bin/env ruby

class Almanac
  attr_accessor :seeds, :seed_soil_map, :soil_fertilizer_map, :fertilizer_water_map,
                :water_light_map, :light_temp_map, :temp_humidity_map, :humidity_location_map

  def initialize
    @seeds = Seeds.new
  end

  def add_section_raw(section)
    case section[0]
    when /^seeds:/
      parse_seeds(section)
    when /^seed-to/
      @seed_soil_map = parse_map(section)
    when /^soil-to/
      @soil_fertilizer_map = parse_map(section)
    when /^fertilizer-to/
      @fertilizer_water_map = parse_map(section)
    when /^water-to/
      @water_light_map = parse_map(section)
    when /^light-to/
      @light_temp_map = parse_map(section)
    when /^temperature-to/
      @temp_humidity_map = parse_map(section)
    when /^humidity-to/
      @humidity_location_map = parse_map(section)
    else
      raise "Unknown Section Encountered"
    end
  end

  def parse_seeds(section)
    section[0].scan(/\d+/).each do |seed_id|
      @seeds.add_seed(Seed.new(seed_id))
    end
  end

  def parse_map(section)
    Map.new(section.drop(1))
  end

  def get_lowest_destination
    lowest_destination = ""
    @seeds.seeds.each do |seed|
      seed.soil = @seed_soil_map.get_destination(seed.id)
      seed.fertilizer = @soil_fertilizer_map.get_destination(seed.soil)
      seed.water = @fertilizer_water_map.get_destination(seed.fertilizer)
      seed.light = @water_light_map.get_destination(seed.water)
      seed.temp = @light_temp_map.get_destination(seed.light)
      seed.humidity = @temp_humidity_map.get_destination(seed.temp)
      seed.location = @humidity_location_map.get_destination(seed.humidity)

      if lowest_destination == "" || lowest_destination > seed.location
        lowest_destination = seed.location
      end
    end

    puts "the lowest destination is %s\n" % [lowest_destination]
  end
end

class Seeds
  attr_accessor :seeds

  def initialize
    @seeds = Array.new
  end

  def add_seed(seed)
    @seeds.append(seed)
  end
end

class Seed
  attr_accessor :id, :soil, :fertilizer, :water, :light, :temp, :humidity, :location

  def initialize(id)
    @id = id.to_i
  end
end

class Map
  attr_accessor :mappings
  def initialize(input)
    @mappings = Array.new

    input.each do |mapping_input|
      mapping = Mapping.new(mapping_input)
      @mappings.append(mapping)
    end
  end

  def get_destination(location)
    @mappings.each do |mapping|
      if mapping.has_destination?(location)
        return mapping.get_destination(location)
      end
    end

    # Any source numbers that aren't mapped correspond to the same destination number
    location
  end
end

class Mapping
  attr_accessor :source_start, :source_end, :dest_start, :range
  def initialize(input)
    input.scan(/\d+/).each_with_index do | part, index |
      case index
      when 0
        @dest_start = part.to_i
      when 1
        @source_start = part.to_i
      when 2
        @range = part.to_i
      else
        raise "Unexpected Input In Mapping Definition\n>>> #{input}\n"
      end
    end
    @source_end = @source_start + @range
  end

  def has_destination?(location)
    if @source_start <= location && location <= @source_end
      return true
    end

    false
  end

  def get_destination(location)
    unless has_destination?(location)
      raise "Mapping does not cover the supplied start value"
    end

    # determine the offset from the start
    offset = location - source_start

    offset + dest_start
  end

  def dump()
    puts "\t Source Start: %d, Dest Start: %d, Range: %d\n" % [@source_start, @dest_start, @range]
  end
end

almanac = Almanac.new

section = Array.new
ARGF.each_line do |input|
  input.chomp! ## get rid of newlines

  if input == ""
    almanac.add_section_raw(section)
    section = Array.new
  else
    section.append(input)
  end

  #
  # total_score = total_score + card.score
  #
  # cards.append(card)
end

almanac.get_lowest_destination