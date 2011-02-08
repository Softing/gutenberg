package Inprint::Store::Embedded::File;

# Inprint Content 5.0
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;

use File::Basename;

sub create {
    my $c = shift;
    my $filpath = shift;

    return $c;
}

sub rename {
    my $c = shift;
    my $filpath = shift;

    return $c;
}

sub delete {
    my $c = shift;
    my $filpath = shift;

    return $c;
}

sub upload {
    my $c = shift;
    my $filpath = shift;

    return $c;
}

sub getExtension {
    my $c = shift;
    my $filepath = shift;

    my ($name,$path,$suffix) = fileparse($filepath, qr/(\.[^.]+){1}?/);
    $suffix =~ s/^.//g;

    return $suffix;
}

sub normalizeFilename {
    my $c = shift;
    my $path = shift;
    my $file = shift;

    my ($cname,$cpath,$cextension) = fileparse("$path/$file", qr/(\.[^.]+){1}?/);

    my $baseName = $cname;
    my $baseExtension = $cextension;

    #if ($^O eq "MSWin32") {
    #    my $converter = Text::Iconv->new("utf-8", "windows-1251");
    #    $baseName = $converter->convert($baseName);
    #    $baseExtension = $converter->convert($baseExtension);
    #}

    my $suffix;
    if (-e "$path/$baseName$baseExtension") {
        for (1..100) {
            unless (-e "$path/$baseName($_)$baseExtension") {
                $suffix = "($_)";
                last;
            }
        }
    }

    return "$baseName$suffix$baseExtension";
}

1;
