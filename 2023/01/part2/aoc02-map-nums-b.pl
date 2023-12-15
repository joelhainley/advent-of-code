#!/usr/bin/env perl

use warnings;
use strict;

use Scalar::Util qw(looks_like_number);
use Data::Dumper;


## TODO
# - everything should be lowercase
# - structure to hold mappings
while(<>){

    my @mappings = [];

    @mappings[1] = "one";
    @mappings[2] = "two";
    @mappings[3] = "three";
    @mappings[4] = "four";
    @mappings[5] = "five";
    @mappings[6] = "six";
    @mappings[7] = "seven";
    @mappings[8] = "eight";
    @mappings[9] = "nine";
    
    
    process_line(lc($_), \@mappings);
}


sub process_line {
    my $line = shift;
    my $mappingsRef = shift;
    my @mappings = @{$mappingsRef};

    my $result = "";
    my $token = "";
    my $mappedToken = "";

    my @lineArray = split('', $line);

    my $lineLen = @lineArray;

    printf("the length of the line is: %d \n", $lineLen);

    for(my $j=0;$j<$lineLen;$j++){
	for(my $i=0;$i<@mappings;$i++){
	    my @mapping = $mappings[$i];
	    print Dumper(@mapping);
	    my $mapping = join('', @mapping);
	    printf("current mapping: %s\n", $mapping);
	    print Dumper($mapping);
	    if(is_match($line, \@mapping, 0)){
		$result = $result . join('', $mapping);
		$i = @mappings; # short circuit rest of mappings
		$j = $j + @mapping - 1; # just in case we have a shared letter
	    }
	    else {
		$result = $result . $lineArray[$j];
	    }	    
	}
    }
    
    printf("input: %s .... %s \n", $line, $result);
}


sub is_match() {
    # candidate
    my $candidate = shift; # current line
    my $mappingRef = shift; # current mapping
    my $matchIndex = shift; # the current character position to match against
    my @mapping = @{$mappingRef};


    printf("\n");
    printf("matchIndex:: %s", $matchIndex);
    
    # TODO: just do a substr here?
    my @candidate_chars = split('', $candidate);
    
    # current word match char
    if(@mapping < $matchIndex - 1){
	return 0;
    }

    if(length($candidate) < $matchIndex - 1){
	return 0;
    }
    
    printf("mapping value: %s \n", $mapping[$matchIndex]);
    printf("candidate_chars value: %s \n", $candidate_chars[$matchIndex]);
    printf("candidate value: %s \n", $candidate);
    
    if($mapping[$matchIndex] eq $candidate_chars[$matchIndex]){
	# check the next char
	if($matchIndex == length($candidate) - 1){
	    printf("match..eol..returning");
	    return 1;
	}
	else {
	    print("match..checking next\n");
	    printf("matchIndex before :: %s\n", $matchIndex);
	    $matchIndex++;
	    printf("matchIndex after :: %s\n", $matchIndex);
	    
	    return is_match($candidate, \@mapping, $matchIndex);
	}
    }
    else {
	return 0;
    }
}
    
    
#for each line
#    start at the beginning char and eval if any first letters in the mappings array match if one does then check the second char
#    return what matches
