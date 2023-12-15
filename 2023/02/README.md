# Day 02


## Iteration 1

I started out fiddling with sed seeing if I could use a simple set of commands for today's assignment. There were some issues with this, an example of this is if we consider the string:

```
greightwo7
```

if we run the following commands in order, (which is how a command file operates):

```
s/one/1/g
s/two/2/g
s/three/3/g
s/four/4/g
s/five/5/g
s/six/6/g
s/seven/7/g
s/eight/8/g
s/nine/9/g
```

We will end up with:

```
greight27
```

however, what we SHOULD end up with is:

```
gr8wo7
```

this happens because the search for `two`s runs before the search for `eight`s, in this particular case we want to execute the eight before the two, unfortunately, we can't shuffle this and apply it intelligently. It might be possible to use some more sophisticated regex, but it is starting to feel kludgy.

The solution language I started with? Something written in PERL.

I haven't played with PERL in YEARS and I kinda miss it sometimes...sorta. I ended up on Ruby after PERL because PERL started down their PERL 6 path and that seemed to be doomed (turns out it just took a while), plus I wasn't a fan OOP-ish things in PERL 5.


## incorrect answers
54623

## Iteration 2

filename: `aoc02-map-nums.pl`
It turns out the rules for this puzzle aren't entirely clear and the script I wrote assumed incorrectly that `threeight` should be converted to `3ight` and not `38`


## Iteration 3

I ended up moving back to Ruby for this version mostly because I starting to remember all of the reasons I had moved away from PERL. 

filename: `aoc02-map-nums.rb`


final execution command to solve this puzzle:

`cat ../01/input.txt | ./aoc02-map-nums-c.rb | ruby -n ../01/aoc01-sieve.rb | ../01/aoc01-accumulator.rb`
