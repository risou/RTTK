#!/usr/bin/env perl

use strict;
use warnings;
use HTML::Template;
use IO::File;
use Encode;

my $filename = shift;
my $htmlname = shift;

my %character = (
	'榛奈' => 'haruna',
	'はるね' => 'haruna',
	'智蔵' => 'haruna',
	'うに' => 'uni',
	'神無' => 'uni',
	'遥' => 'haruka',
	'はるか' => 'haruka',
	'今野' => 'haruka',
	'みのり' => 'minori',
	'ｒｉｓｏｕ' => 'minori',
	'ゆき' => 'yuki',
	'有希' => 'yuki',
	'吉村' => 'yuki',
	'穂波' => 'honami',
	'ほなみ' => 'honami',
	'らぃえ' => 'honami',
	'GM' => 'gm',
	'ＧＭ' => 'gm',
);

my %color = (
	'bbb' => '#0000FF',
	'haruna' => '#800000',
	'uni' => '#cd853f',
	'haruka' => '#8b008b',
	'minori' => '#6a5acd',
	'yuki' => '#5f9ea0',
	'honami' => '#dc143c',
	'gm' => '#006400',
);

my $template = new HTML::Template( filename => "template.html" );

my $io = IO::File->new($filename, 'r') or die $!;

my %param;
my @plist;
my $list = [];

$param{'title'} = $htmlname;

my $cssstr;
foreach (keys %color) {
	$cssstr .= "\t\t\t\t.$_ { color: $color{$_} }\n";
}
$param{'css'} = $cssstr;

while (not $io->eof) {
	my %part;

	my $line = Encode::decode('shift-jis', $io->getline);

	#print Encode::encode('shift-jis', "> $line");
	
	chomp $line;

	if ($line =~ /^\s*$/) {
		push @plist, {'line' => $list};
		$list = [];
	} else {

		if ($line =~ /^(.*)?\t(.*)$/) {
			$part{'class'} = $character{Encode::encode('utf-8', $1)};
			$part{'character'} = $character{Encode::encode('utf-8', $1)};
			$part{'text'} = Encode::encode('utf-8', $2);
		} else {
			$part{'class'} = '';
			$part{'text'} = Encode::encode('utf-8', $line);
		}

		push @$list, \%part;
	}
}
$io->close;
push @plist, {'line' => $list};

$param{'paragraph'} = \@plist;

$template->param(%param);

#print $template->output();
$io = IO::File->new($htmlname, 'w');
$io->print($template->output());
$io->close;
