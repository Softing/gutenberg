#!/usr/bin/perl

use strict;
use File::Find;

my $path ="../../public/widgets/components";

my @jsfiles;

# Find js files
find({ wanted => sub {

    if ( (/\.js$/) ) {
            my $file = $File::Find::name;
            $file  =~ s/\/+/\//g;
            push @jsfiles, $file;
    }
}}, $path);

@jsfiles = sort { $a cmp $b } @jsfiles;

foreach my $file (@jsfiles) {
    system "java -jar jslint4java-1.4.6.jar $file";
}
