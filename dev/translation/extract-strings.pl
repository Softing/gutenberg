#!/usr/bin/perl

use utf8;
use strict;
use feature ':5.10';

use FindBin;
use File::Copy;
use File::Find;

binmode DATA, ":utf8";

my @langs = ("en", "ru");

my @result;
my @words;
my @jsfiles;

my $path = "../../public/widgets";

find({ wanted => sub {
    my $filename = $File::Find::name;
    if ( (/\.js$/) ) {
        push @jsfiles, $filename;
    }
}}, $path);

@jsfiles = sort { $a cmp $b } @jsfiles;

foreach my $path (@jsfiles) {
    open(my $file, "<:utf8", $path) or die("Could not open $path");
    while (<$file>) {
        while (/_\("(.*?)"\)/g) {
            my $string = $1;
            push @words, $string;
        }
        while (/_\('(.*?)'\)/g) {
            my $string = $1;
            push @words, $string;
        }
    }
    close($file);
}


my %seen = ();
foreach my $item (@words) {
    push(@result, $item) unless $seen{$item}++;
}

@result = sort {$a cmp $b} @result;

foreach my $lang (@langs) {

    my $translation = {};

    if (-r $FindBin::Bin ."/../../lib/Inprint/I18N/$lang.pm") {
        open (my $source, "<:utf8", $FindBin::Bin ."/../../lib/Inprint/I18N/$lang.pm");

        foreach my $string (<$source>) {
            if ($string =~ m/=\>/) {
                chomp($string);
                $string =~ s/\t+/ /g;
                $string =~ s/\s+/ /g;
                $string =~ s/\s+=\>\s+/=>/g;
                $string =~ m/"(.*?)"=\>"(.*?)"/;
                $translation->{$1} = $2;
            }
        }

        close ($source);
    }

    open (my $file, ">:utf8", "$FindBin::Bin/translations/$lang.pm");

    say $file "package Inprint::I18N::$lang;";
    say $file "";
    say $file "# Inprint Content 4.5";
    say $file "# Copyright(c) 2001-2010, Softing, LLC.";
    say $file "# licensing\@softing.ru";
    say $file "# http://softing.ru/license";
    say $file "";
    say $file "use base 'Inprint::I18N';";
    say $file "";
    say $file "use utf8;";
    say $file "";
    say $file "our \%Lexicon = (";

    foreach my $item (@result) {
        my $param = sprintf('%-30s', '"'.$item.'"');
        my $value = $translation->{$item};
        say $file "    $param=> \"$value\",";
    }

    say $file ");";
    say $file "";
    say $file "sub get {";
    say $file "    my \$c = shift;";
    say $file "    my \$key = shift;";
    say $file "    return \$Lexicon{\$key} || \$key;";
    say $file "}";
    say $file "";
    say $file "sub getAll {";
    say $file "    return \\\%Lexicon;";
    say $file "}";
    say $file "";
    say $file "1;";

    close($file);

    if (-e $FindBin::Bin ."/../../lib/Inprint/I18N/$lang.pm") {
        #move($FindBin::Bin ."/../../lib/Inprint/I18N/$lang.pm", $FindBin::Bin ."/../../lib/Inprint/I18N/$lang.pm.old");
        #move($FindBin::Bin ."/translations/$lang.pm", $FindBin::Bin ."/../../lib/Inprint/I18N/$lang.pm");
    }

}
