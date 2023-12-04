#!/usr/bin/env ruby

## accumulates a string of numbers (one per line) coming in from STDIN

total = 0

ARGF.each do |line|
  total = total + line.to_i
end

print "total:: " + total.to_s + "\n"
