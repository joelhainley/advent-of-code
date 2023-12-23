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
      #puts "raw set: #{set_raw} \n"

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

  def reset
    @red = @start_red
    @green = @start_green
    @blue = @start_blue
  end

  def set_possible?(game)
    if game.red > red
      return false
    end

    if game.green > green
      return false
    end 
    if game.blue > blue
      return false
    end

    true
  end

  def game_possible?(game)
    game.sets.each do |set|
      unless set_possible?(set)
        return false
      end
    end

    true ## if we made it here..it's possible!
  end

end


### main

total = 0

ARGF.each_line do |line|
  bag = Bag.new(12, 13, 14)

  game = Game.new(line)

  if bag.game_possible?(game)
    total = total + game.number
  end

end

puts "\n\nTotal: #{total}\n"
