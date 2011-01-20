#!/usr/bin/perl

# Inprint Content 5.0
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use FindBin;
use File::Find;

my $path = "$FindBin::Bin/..";

my @jsfiles;
my @cssfiles;
my @jsplugins;
my @cssplugins;

# Find css files
find({ wanted => sub {
    if ( -r $File::Find::name && (/\.css$/) ) {
        my $file = $File::Find::name;
        #$file  =~ s/\/+/\//g;
        #$file = substr ($file, length("$path/public"), length($file));
        return if ( $file =~ /\/css\/themes\// );
        return if ( $file =~ /\/css\/engines\// );
        push @cssfiles, $file;
    }
}}, "$path/public/css");
@cssfiles = sort { $a cmp $b } @cssfiles;

# Find js files
find({ wanted => sub {
    if ( -r $File::Find::name && (/\.js$/) ) {
            my $file = $File::Find::name;
            #$file  =~ s/\/+/\//g;
            #$file = substr ($file, length("$path/public"), length($file));
            push @jsfiles, $file;
    }
}}, "$path/public/widgets");
@jsfiles = sort { $a cmp $b } @jsfiles;

# Find plugins
find({ wanted => sub {
    if ( -r $File::Find::name && ((/\.js$/) || (/\.css$/)) ) {
        my $file = $File::Find::name;
        #$file  =~ s/\/+/\//g;
        #$file = substr ($file, length("$path/public"), length($file));
        push @jsplugins, $file if ($file =~ m/\.js$/);
        push @cssplugins, $file if ($file =~ m/\.css$/);
    }
}}, "$path/public/plugins");
@jsplugins = sort { $a cmp $b } @jsplugins;
@cssplugins = sort { $a cmp $b } @cssplugins;

unlink "$path/public/cache/inprint.js"  if (-e "$path/public/cache/inprint.js");
unlink "$path/public/cache/inprint.css" if (-e "$path/public/cache/inprint.css");
unlink "$path/public/cache/plugins.js"  if (-e "$path/public/cache/plugins.js");
unlink "$path/public/cache/plugins.css" if (-e "$path/public/cache/plugins.css");

foreach (@jsfiles) {
    print "$_\n";
    my $text =  "";

    open FILE, "<:encoding(UTF-8)", $_;
    while (my $line = <FILE>) { $text .= $line; }
    close FILE;

    $text =~ s/^\xEF\xBB\xBF//;

    open FILE, ">>:encoding(UTF-8)", "$path/public/cache/inprint.js";
    print FILE "\n\n";
    print FILE $text;
    close FILE;
}

foreach (@cssfiles) {
    print "$_\n";
    my $text =  "";

    open FILE, "<:encoding(UTF-8)", $_;
    while (my $line = <FILE>) { $text .= $line; }
    close FILE;

    $text =~ s/^\xEF\xBB\xBF//;

    open FILE, ">>:encoding(UTF-8)", "$path/public/cache/inprint.css";
    print FILE "\n\n";
    print FILE $text;
    close FILE;
}

foreach (@jsplugins) {
    print "$_\n";
    my $text =  "";

    open FILE, "<:encoding(UTF-8)", $_;
    while (my $line = <FILE>) { $text .= $line; }
    close FILE;

    $text =~ s/^\xEF\xBB\xBF//;

    open FILE, ">>:encoding(UTF-8)", "$path/public/cache/plugins.js";
    print FILE "\n\n";
    print FILE $text;
    close FILE;
}

foreach (@cssplugins) {
    print "$_\n";
    my $text =  "";

    open FILE, "<:encoding(UTF-8)", $_;
    while (my $line = <FILE>) { $text .= $line; }
    close FILE;

    $text =~ s/^\xEF\xBB\xBF//;

    open FILE, ">>:encoding(UTF-8)", "$path/public/cache/plugins.css";
    print FILE "\n\n";
    print FILE $text;
    close FILE;
}

unlink "$path/public/cache/inprint.min.js"  if (-e "$path/public/cache/inprint.min.js");
unlink "$path/public/cache/inprint.min.css" if (-e "$path/public/cache/inprint.min.css");
unlink "$path/public/cache/plugins.min.js"  if (-e "$path/public/cache/plugins.min.js");
unlink "$path/public/cache/plugins.min.css" if (-e "$path/public/cache/plugins.min.css");

system ("java -jar $path/bin/yuicompressor-2.4.2.jar -o $path/public/cache/inprint.min.js $path/public/cache/inprint.js");
system ("java -jar $path/bin/yuicompressor-2.4.2.jar -o $path/public/cache/inprint.min.css $path/public/cache/inprint.css");
system ("java -jar $path/bin/yuicompressor-2.4.2.jar -o $path/public/cache/plugins.min.js $path/public/cache/plugins.js");
system ("java -jar $path/bin/yuicompressor-2.4.2.jar -o $path/public/cache/plugins.min.css $path/public/cache/plugins.css");

unlink "$path/public/cache/inprint.js"  if (-e "$path/public/cache/inprint.js");
unlink "$path/public/cache/inprint.css" if (-e "$path/public/cache/inprint.css");
unlink "$path/public/cache/plugins.js"  if (-e "$path/public/cache/plugins.js");
unlink "$path/public/cache/plugins.css" if (-e "$path/public/cache/plugins.css");
