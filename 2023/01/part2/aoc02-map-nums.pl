#!/usr/bin/env perl

use warnings;
use strict;

use Scalar::Util qw(looks_like_number);
use Data::Dumper;


## TODO
# - everything should be lowercase

while(<>){
    
    my %mappings = ( one => 1,
		 two => 2,
		 three => 3,
		 four => 4,
		 five => 5,
		 six => 6,
		 seven => 7,
		 eight => 8,
		     nine => 9 );

    process_line(lc($_), \%mappings);
}


sub process_line {
    my $line = shift;
    my $mappingsRef = shift;

    my $result = "";
    my $token = "";

    foreach my $char (split //, $line){
	if(looks_like_number($char)){
	    $result = $result . $token . $char;
	    $token = "";
	}
	else {   
	    $token = $token . $char;
	    $token = getMappedToken($token, $mappingsRef);
	}	    
    }
    $result = $result . $token;

    printf("%s", $result);
}

sub getMappedToken(){
    my $token = shift;
    my $mappingsRef = shift;
    
    foreach my $key (keys %{$mappingsRef}) {
	if(index($token, $key) != -1){
	    my $mappedValue = $mappingsRef->{$key};
	    my $newToken = $token =~ s/$key/$mappedValue/r;
	    return $newToken;
	}
    }

    return $token;
}
