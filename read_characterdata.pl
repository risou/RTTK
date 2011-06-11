#!/usr/bin/env perl6
use v6;
#use YAML;
use JSON::Tiny;

sub MAIN() {
	my @array = (0, 1, 2);
	my %hash = (a=>1,b=>2);
	#say dump(@array);
	
	my $json = to-json(%hash);

	say $json;

	my %hash2 = from-json($json);

	say %hash2;
}
