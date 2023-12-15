#!/usr/bin/env ruby

class MappingEntry
  attr_reader :value, :text
  def initialize(value, text)
    @value = value
    @text = text
  end
end

token_mappings = Array.new

token_mappings.push(MappingEntry.new(1, 'one'))
token_mappings.push(MappingEntry.new(2, 'two'))
token_mappings.push(MappingEntry.new(3, 'three'))
token_mappings.push(MappingEntry.new(4, 'four'))
token_mappings.push(MappingEntry.new(5, 'five'))
token_mappings.push(MappingEntry.new(6, 'six'))
token_mappings.push(MappingEntry.new(7, 'seven'))
token_mappings.push(MappingEntry.new(8, 'eight'))
token_mappings.push(MappingEntry.new(9, 'nine'))

# TODO boundary checking
def is_match?(candidate, mapping, position)

  if candidate.length < position - 1 || mapping.text.length < position - 1
    puts "position is greater than candidate length"
    return
  end

  if candidate[position] == mapping.text[position]
    if position == mapping.text.length - 1
      return true
    else
      return is_match?(candidate, mapping, position+1)
    end
  end

  false
end

def numeric? string
  true if Float(string) rescue false
end

def process_line(line, mappings)
  new_line = ''
  next_position = 0
  match_found = false

  last_match_position = 0

  (0..line.length-1).each do | position|
    if next_position > position
      next
    end
    mappings.each do |mapping|
      if is_match?(line[position..-1], mapping, 0)
        new_line << mapping.value.to_s
        last_match_position = position + mapping.text.length
        next_position = position + mapping.text.length - 1
        match_found = true
        break
      else
        if match_found
          match_found = false
        end
      end
    end

    unless match_found
      if last_match_position <= position
        last_match_position = position
        new_line << line[position, 1]
      end
      match_found = false
    end
  end

  new_line
end

ARGF.each_line do |line|
  print process_line(line, token_mappings)
end
