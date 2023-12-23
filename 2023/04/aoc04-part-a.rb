#!/usr/bin/env ruby

class Card
  attr_accessor :input, :id, :winners, :held, :wins, :score

  def initialize(input)
    @input = input
    parse_line(input)
    calc_wins
    calc_score
  end

  def calc_wins
    count = 0
    @winners.each do |winner|
      if held.include?(winner)
        count = count + 1
      end
    end

    @wins = count
  end

  def calc_score
    if @wins == 0
      @score = 0
      return
    end

    if @wins == 1
      @score = 1
      return
    end

    @score = 1

    count = @wins - 1
    count.times do
      @score = @score + @score
    end
  end

  def get_card_number(input)
    numberData = input.match(/\s[0-9]+:/)

    @number = numberData[0].to_i
  end

  def strip_card_info(input)
    parts = input.split(":")

    if parts.length != 2
      raise "there are not exactly two parts after splitting with ':' -> #{input}\n"
    end

    parts[1]
  end

  def parse_line(input)
    @id = get_card_number(input)
    data_raw = strip_card_info(input)
    numbers = data_raw.split("|")
    @winners = get_array_of_nums(numbers[0])
    @held = get_array_of_nums(numbers[1])
  end

  def get_array_of_nums(input)
    if input.length == 0
      raise "empty strings are not allowed as arguments"
    end
    nums = Array.new

    parts = input.split(" ")

    parts.each do |part|
      nums.append(part.to_i)
    end

    nums
  end

  def dump
    puts "%d -> \t %s \n\t %s\n\twins: %d\n\tscore:%d" % [@number, @winners, @held, @wins, @score]
  end
end


cards = Array.new
total_score = 0

ARGF.each_line do |input|
  input.chomp! ## get rid of newlines

  card = Card.new(input)
  card.dump

  total_score = total_score + card.score

  cards.append(card)
end


puts "The total score is: %d" % total_score