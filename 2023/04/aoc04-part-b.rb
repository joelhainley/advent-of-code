#!/usr/bin/env ruby

class Pile
  attr_accessor :cards
  def initialize
    @cards = Array.new
    super
  end

  def add_card(card)
    @cards.append(card)
  end

  def increment_card_count(card_number)
    if card_number == 0
      raise "card_number should not be zero"
    end

    cards[card_number-1].count = cards[card_number-1].count + 1
  end

  def total_points
    total_points = 0

    @cards.each do |card|
      total_points = total_points + card.score
    end

    total_points
  end

  def total_cards
    total_cards = 0
    @cards.each do | card|
      card.count.times do
        card.calc_score
        if card.wins == 0
          next
        end

        start_card = card.id
        1.upto(card.wins) do |i|
          increment_card_count(start_card + i)
        end
      end

      total_cards = total_cards + card.count
    end

    total_cards
  end


end

class Card
  attr_accessor :input, :id, :winners, :held, :wins, :score, :count

  def initialize(input)
    @input = input
    @count = 1 # we start out with 1 of each card
    parse_line(input)
    calc_wins
    calc_score
  end

  def increment_count
    @count = @count + 1
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

    win_count = @wins - 1 * @count
    win_count.times do
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
    puts "%d -> \t %s \n\t %s\n\twins: %d\n\tscore:%d\n\tcount:%d\n" % [@number, @winners, @held, @wins, @score, @count]
  end
end


pile = Pile.new

ARGF.each_line do |input|
  input.chomp! ## get rid of newlines
  card = Card.new(input)
  pile.add_card(card)
end

puts "The total score is: %d" % pile.total_points
puts "The total cards are: %d" % pile.total_cards
