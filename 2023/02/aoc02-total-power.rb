#!/usr/bin/env ruby

class Game
  attr_accessor :number, :sets
  def initialize(raw)
    @number = get_game_number(raw)
    @sets = parse_sets(raw)
  end

  def dump
    puts "Game: #{@number}"
    @sets.each do |set|
      set.dump
    end
  end

  def get_game_number(raw)
    numberData = raw.match(/[0-9]+/)

    @number = numberData[0].to_i
  end

  def parse_sets(raw)
    new_sets = Array.new

    # get everything after the number
    raw_set_start = raw.index(':') + 1
    raw_set_data = raw[raw_set_start..-1]
    
    # split by semicolon
    sets_raw = raw_set_data.split(';')

    # parse
    sets_raw.each do |set_raw|
      set = Set.new

      cubes_raw = set_raw.split(',')

      cubes_raw.each do |cube_raw|
        color = get_color(cube_raw)
        number = get_number(cube_raw)

        if color === 'red'
          set.red = number
        elsif color === 'green'
          set.green = number
        elsif color === 'blue'
          set.blue = number
        else
          raise "Unknown color value encountered: #{color}"
        end
      end

      new_sets.append(set)
    end

    new_sets
  end

  def get_number(input)
    number_data = input.match(/^\s*([0-9]+)/)
    number_data[0].to_i
  end


  def get_color(input)
    word_data = input.match(/[a-z]+/)
    word_data[0]
  end
end

class Set
  attr_accessor :red, :green, :blue

  def initialize
    @red = 0
    @green = 0
    @blue = 0
  end

  def dump
    puts "\tRed   : #{red}\n"
    puts "\tGreen : #{green}\n"
    puts "\tBlue  : #{blue}\n"
    puts "\t-------------------\n"
  end
end


class Bag
  attr_reader :red, :green, :blue, :start_red, :start_green, :start_blue
  def initialize(red, green, blue)
    @red = red
    @green = green
    @blue = blue
    @start_red = red
    @start_green = green
    @start_blue = blue
  end

  def dump
    puts "Bag values\n"
    puts "Red: #{red}\n"
    puts "Green: #{green}\n"
    puts "Blue: #{blue}\n"
  end

  def reset
    @red = @start_red
    @green = @start_green
    @blue = @start_blue
  end


  def adjust_for_game(game)
    game.sets.each do |set|
      if set.red > red
        @red = set.red
      end
      if set.green > green
        @green = set.green
      end
      if set.blue > blue
        @blue = set.blue
      end
    end
  end

  def get_power
    red * green * blue
  end
end


### main

total = 0

ARGF.each_line do |line|
  bag = Bag.new(0, 0, 0)

  game = Game.new(line)

  bag.adjust_for_game(game)
  bag.dump
  puts("game: #{game.number} : #{bag.get_power}")
  total = total + bag.get_power
  bag.reset

end

puts "\n\nTotal: #{total}\n"
