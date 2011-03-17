#!/usr/bin/perl

use utf8;
use strict;
use feature ':5.10';

use FindBin;
use File::Copy;
use File::Find;

binmode DATA, ":utf8";

my @words;
my @langs = ("en", "ru");

# Process JS files

my @jsfiles;

find({ wanted => sub {
    my $filename = $File::Find::name;
    if ( (/\.js$/) ) {
        push @jsfiles, $filename;
    }
}}, "../../public/scripts");

find({ wanted => sub {
    my $filename = $File::Find::name;
    if ( (/\.js$/) ) {
        push @jsfiles, $filename;
    }
}}, "../../public/widgets");

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

# Process PM files

my @pmfiles;

find({ wanted => sub {
    my $filename = $File::Find::name;
    if ( (/\.pm$/) ) {
        push @pmfiles, $filename;
    }
}}, "../../lib/Inprint");

foreach my $path (@pmfiles) {
    open(my $file, "<:utf8", $path) or die("Could not open $path");
    while (<$file>) {
        while (/->l\("(.*?)"\)/g) {
            my $string = $1;
            push @words, $string;
        }
        while (/->l\('(.*?)'\)/g) {
            my $string = $1;
            push @words, $string;
        }
    }
    close($file);
}

# Fill pm files
foreach my $lang (@langs) {

    my @result = @words;
    my $translation = {};

    # Add strings to @words from pm file

    if (-r $FindBin::Bin ."/../../lib/Inprint/I18N/$lang.pm") {
        open (my $source, "<:utf8", $FindBin::Bin ."/../../lib/Inprint/I18N/$lang.pm");

        my $param;
        foreach my $string (<$source>) {

            chomp($string);
            $string =~ s/\t+/ /g;
            $string =~ s/\s+/ /g;
            $string =~ s/\s+=\>\s+/=>/g;

           if ($string =~ m/"(.*?)"=\>"(.*?)"/) {
                chomp($string);
                $string =~ s/\t+/ /g;
                $string =~ s/\s+/ /g;
                $string =~ s/\s+=\>\s+/=>/g;
                $string =~ m/"(.*?)"=\>"(.*?)"/;
                push @result, $1;
                $translation->{$1} = $2;
            }

            elsif ($string =~ m/=\>/) {
                $string =~ m/"(.*?)"/;
                push @result, $param;
                $translation->{$param} = $1;
                $param = "";
            }

            elsif ($string =~ m/"(.*?)"/) {
                $param = $1;
            }

        }

        close ($source);
    }

    # Sort @words
    @result = sort {$a cmp $b} @result;

    # Save @words to pm file
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
    say $file "our \%Lexicon = (\n";

    my $tab = "    ";
    my %seen = ();
    foreach my $item (@result) {

        next if $seen{$item}++;
        next unless $item;

        my $param = '"' .$item. '"';
        my $value = $translation->{$item};

        if ($item ~~ @words) {
            say $file "    $param\n => \"$value\",\n";
        }

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

    #if (-e $FindBin::Bin ."/../../lib/Inprint/I18N/$lang.pm") {
    #    move($FindBin::Bin ."/../../lib/Inprint/I18N/$lang.pm", $FindBin::Bin ."/../../lib/Inprint/I18N/$lang.pm.old");
    #    move($FindBin::Bin ."/translations/$lang.pm", $FindBin::Bin ."/../../lib/Inprint/I18N/$lang.pm");
    #}

}
