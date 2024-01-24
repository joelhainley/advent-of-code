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
    section[0].scan(/\d+/).each do |value|
      @seeds.add_seed(Seed.new(value.to_i))
    end
  end

  def parse_map(section)
    Map.new(section.drop(1))
  end

  def get_destination(seed_value)
    soil_value = @seed_soil_map.get_destination(seed_value)
    fertilizer_value = @soil_fertilizer_map.get_destination(soil_value)
    water_value = @fertilizer_water_map.get_destination(fertilizer_value)
    light_value = @water_light_map.get_destination(water_value)
    temp_value = @light_temp_map.get_destination(light_value)
    humidity_value = @temp_humidity_map.get_destination(temp_value)
    location_value = @humidity_location_map.get_destination(humidity_value)

    location_value
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
        @dest_start = part.to_f
      when 1
        @source_start = part.to_f
      when 2
        @range = part.to_i
      else
        raise "Unexpected Input In Mapping Definition\n>>> #{input}\n"
      end
    end
    @source_end = (@source_start + @range).to_i
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

lowest_destination = ""



almanac.seeds.seeds.each_slice(2) do |start, length|
  puts "processing seeds starting at %d for %d numbers\n" % [start.id, length.id]

  start.id.upto(start.id + length.id - 1) do |value|
    location = almanac.get_destination(value)

    if lowest_destination == "" || location < lowest_destination
      puts "found lower location %d \n" % location
      lowest_destination = location
    end

  end
end

puts "the lowest destination is %s\n" % [lowest_destination]


