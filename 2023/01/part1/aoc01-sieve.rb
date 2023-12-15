#!/usr/bin/env ruby

# Ruby provides another way to handle STDIN: The -n flag. It treats your entire# program as being inside a loop over STDIN, (including files passed as command# line args)

## you must run this from the command-line `ruby -n script.rb`
## cat sample.txt | ruby -n aoc01.rb

def numeric? string
  true if Float(string) rescue false
end

def get_first_numeric_char(input)
  input.split("").each do |c|
    if numeric?(c)
      return c
    end
  end
  raise Exception.new "Unable to locate number in : [" + input + "]"
end

first_num = get_first_numeric_char($_)
last_num = get_first_numeric_char($_.reverse)

STDOUT.write first_num + last_num + "\n"

