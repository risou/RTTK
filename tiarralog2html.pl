#!/usr/bin/env perl

use strict;
use warnings;
use HTML::Template;
use IO::File;
use Encode;

my $htmlname = pop;
my @filenames = @ARGV;

my $template = new HTML::Template( filename => "tt.html" );

my %members = ();

my @color = ('#0000FF', '#800000', '#cd853f', '#8b008b', '#6a5acd', '#5f9ea0', '#dc143c', '#006400', '#c71585', '#2f4f4f', '#4682b4', '#d2691e', '#483d8b', '#ff7f50', '#696969');

my %param;

$param{'title'} = $htmlname;

my @list;
foreach (@filenames) {
	my $io = IO::File->new($_, 'r') or die $!;

	while (not $io->eof) {

		my $line = Encode::decode('utf-8', $io->getline);

		if ($line =~ /^([0-9]{2}:[0-9]{2}:[0-9]{2}) (<|\(|>|\))#.*?\@[a-zA-Z0-9]+:(.*?)(<|\(|>|\)) (.*)$/) {
			my %one;
			my $time = $1;
			my $name = $3;
			my $part = $5;
			$part =~ s/03//g;
			if (not exists $members{$name}) {
				$members{$name} = shift(@color);
				$members{$name} = '#000000' if not defined $members{$name};
			}
			#$line =~ s/03//g;
			#print Encode::encode('shift-jis', $line);
			#print Encode::encode('utf-8', $time . ' (' . $name . ') ' . $part), "\n";
			$one{'time'} = Encode::encode('utf-8', $time);
			$one{'name'} = Encode::encode('utf-8', $name);
			$one{'part'} = Encode::encode('utf-8', $part);
			$one{'color'} = $members{$name};

			push @list, \%one;
		} elsif ($line =~ /^[0-9]{2}:[0-9]{2}:[0-9]{2} (.*?) -> (.*?)$/) {
			if (defined $members{$1}) {
				$members{$2} = $members{$1};
				delete($members{$1});
			}
		}
	}
	$io->close;
}
$param{'line'} = \@list;

$template->param(%param);

my $io = IO::File->new($htmlname, 'w');
$io->print($template->output());
$io->close;

foreach (keys %members) {
	print "$_ : $members{$_}\n";
}
