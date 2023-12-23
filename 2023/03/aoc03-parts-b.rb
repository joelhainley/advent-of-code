#!/usr/bin/env ruby

class Schematic
  attr_accessor :lines

  def initialize()
    @lines = Array.new
  end

  def add_line(input, number, length)
    line = Line.new(input, number, length)
    lines.append(line)
  end

  def get_part_numbers
    across = get_part_numbers_across_lines
    within = get_part_numbers_within_lines

    joined = (across + within).uniq { |p| p.id}

    joined.sort_by { |p| p.id.to_f }
  end


  def get_part_numbers_across_lines
    part_numbers = Array.new
    prev_line = ""
    next_line = ""

    @lines.each do |line|
      if prev_line == ""
        prev_line = line
        next
      end

      line.tokens.each do |token|
        prev_line.tokens.each do |prev_line_token|
          if (prev_line_token.is_symbol && token.is_symbol == false) ||
            (prev_line_token.is_symbol == false && token.is_symbol)

            ## we have a candidate
            puts "we have a candidate\n"
            symbol = ""
            number = ""
            if prev_line_token.is_symbol
              symbol = prev_line_token
              number = token
            else
              symbol = token
              number = prev_line_token
            end

            if number.is_gear_symbol_adjacent?(symbol)
              part_numbers.append(number)
              puts "\n"
            end
          end
        end
      end

      prev_line = line
    end

    part_numbers
  end

  def get_part_numbers_within_lines
    part_numbers = Array.new
    # check within each line
    @lines.each do |line|
      prev_token = ""
      line.tokens.each do |token|
        if prev_token == ""
          prev_token = token
          next
        end

        puts "prev_token"
        prev_token.dump
        puts "token"
        token.dump
        puts "\n"
        if (prev_token.is_symbol && token.is_symbol == false) ||
          (prev_token.is_symbol == false && token.is_symbol)

          ## we have a candidate
          puts "we have a candidate\n"
          symbol = ""
          number = ""
          if prev_token.is_symbol
            symbol = prev_token
            number = token
          else
            symbol = token
            number = prev_token
          end

          # comparing
          puts "symbol: "
          symbol.dump
          puts "number: "
          number.dump
          puts "\n"
          if number.is_gear_symbol_adjacent?(symbol)
            puts "!!! we have a part number!!"
            number.dump
            part_numbers.append(number)
            puts "\n"
            end
        end
        prev_token = token
      end
    end

    part_numbers
  end

  def dump
    @lines.each do |line|
      puts "\n#{line.number} : \n"
      line.dump
    end
  end
end

class Line
  attr_accessor :tokens, :number, :length

  def initialize(input, number, length)
    @number = number
    @length = length

    tokens = Array.new
    in_number = false
    puts("reading #{input} \n")
    chars = input.split("")
    buffer = ""
    start_pos = 0

    chars.each_with_index do |char, index|
      current_pos = index + 1
      if is_numeric?(char)
        unless in_number
          in_number = true
          start_pos = current_pos
        end
        buffer = buffer + char
        if current_pos == length
          ## end of line
          token = Token.new(buffer, start_pos, current_pos, number, false)
          tokens.append(token)
        end
      elsif is_symbol?(char)
        if in_number
          token = Token.new(buffer, start_pos, current_pos - 1, number, false)
          buffer = ""
          in_number = false
          tokens.append(token)
        end
        token = Token.new(char, current_pos, current_pos, number, true)
        tokens.append(token)
      else
        if in_number
          token = Token.new(buffer, start_pos, current_pos-1, number,false)
          buffer = ""
          in_number = false
          tokens.append(token)
        end
      end
    end

    @tokens = tokens

    puts "we found the following tokens for line \n > #{input} \n"
    @tokens.each do |token|
      token.dump
    end

  end

  def dump
    @tokens.each do |token|
      token.dump
    end
  end

  def is_numeric?(char)
    true if Float(char) rescue false
  end

  def is_symbol?(char)
    if is_numeric?(char) == false && char != "."
      return true
    end

    return false
  end
end

class Token
  attr_accessor :value, :is_symbol, :start_pos, :end_pos, :line_number, :gear_ratio_tuples
  attr_reader :id

  def initialize(value, start_pos, end_pos, line_number, is_symbol)
    @value = value
    @is_symbol = is_symbol
    @start_pos = start_pos
    @end_pos = end_pos
    @line_number = line_number
    @gear_ratio_tuples = Array.new
    start_val = "%03d" % start_pos
    @id = "#{line_number}.#{start_val}".to_f
  end

  def dump
    puts "##{id} > #{value} - (#{line_number}) [#{start_pos}, #{end_pos}] - #{is_symbol ? 'symbol' : 'number'}"
    if gear
  end

  def is_gear_symbol?
    if @is_symbol && @value == "*"
      return true
    end

    false
  end

  def is_gear?
    unless is_gear_symbol?
      return false
    end

    gear_ratio_tuples.length == 2
  end

  def add_gear_ratio_tuple(token)
    unless token.is_gear_symbol?
      raise "the argument to this method is NOT a gear"
    end

    unless gear_ratio_tuples.any? {|tuple| tuple.id == token.id}
      gear_ratio_tuples.add(token)
    end
  end

  def is_gear_symbol_adjacent?(symbol)
    unless symbol.is_gear_symbol?
      return false
    end

    if (start_pos - 1) <= symbol.start_pos && symbol.start_pos <= (end_pos + 1)
      return true
    end

    false
  end

end

### main

total = 0
line_number = 1
schematic = Schematic.new
ARGF.each_line do |input|
  input.chomp!
  schematic.add_line(input, line_number, input.length)

  line_number = line_number + 1
end

#schematic.dump
#schematic.get_part_numbers_within_line
gears = schematic.get_gears

puts "\nFound Numbers: \n"
gears.each do |gear|
  number.dump
  total = total + number.value.to_i
end

puts "\n\nTotal: #{total}\n"


