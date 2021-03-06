package Inprint::Store::Embedded::Utils;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;

use Encode;
use File::Basename;

sub makePath {
    my $c = shift;
    my $path = shift;

    foreach (@_) {
        $path .= '\\' . $_;
    }

    if ($^O eq "MSWin32") {
        $path =~ s/\//\\/g;
        $path =~ s/\\+/\\/g;
    }

    if ($^O eq "darwin") {
        $path =~ s/\\/\//g;
        $path =~ s/\/+/\//g;
    }

    if ($^O eq "linux") {
        $path =~ s/\\/\//g;
        $path =~ s/\/+/\//g;
    }

    return $path;
}

sub doEncode{
    my $c = shift;
    my $path = shift;

    if ($^O eq "MSWin32") {
        $path = Encode::encode("cp1251", $path);
    }

    if ($^O eq "darwin") {
        $path = Encode::encode("utf8", $path);
    }

    if ($^O eq "linux") {
        #$path = Encode::encode("utf8", $path);
    }

    return $path;
}


sub doDecode {
    my $c = shift;
    my $path = shift;

    if ($^O eq "MSWin32") {
        $path = Encode::decode("cp1251", $path);
    }

    if ($^O eq "darwin") {
        $path = Encode::decode("utf8", $path);
    }

    if ($^O eq "linux") {
        #$path = Encode::decode("utf8", $path);
    }

    return $path;
}

sub getExtension {
    my $c = shift;
    my $filepath = shift;

    my ($name,$path,$suffix) = fileparse($filepath, qr/(\.[^.]+){1}?/);
    $suffix =~ s/^.//g;

    return $suffix;
}

sub checkFolder {
    my $c = shift;
    my $path = shift;

    die "Can't find path <$path>" unless -e $path;
    die "Can't read path <$path>" unless -r $path;
    die "Can't write path <$path>" unless -w $path;

    return;
}

sub normalizeFilename {
    my $c = shift;
    my $filepath = shift;

    my ($cname, $cpath, $cextension) = fileparse($filepath, qr/(\.[^.]+){1}?/);

    $cextension = lc ($cextension);
    $filepath = makePath($c, $cpath, "$cname$cextension");

    if (-e $filepath) {
        for (1..100) {
            my $npath = makePath($c, $cpath, "$cname($_)$cextension");
            unless (-e $npath) {
                return $npath;
            }
        }
    }

    return $filepath;
}

#sub getRelativePath {
#    my $c = shift;
#
#    my $path = shift;
#
#    die "Can't find configuration of datastore folder" unless $path;
#    die "Can't find datastore folder in filesystem" unless -e $path;
#    die "Can't read datastore folder" unless -r $path;
#    die "Can't write to datastore folder" unless -w $path;
#
#    my $basepath = $c->config->get("store.path");
#
#    $path = substr $path, length($basepath), length($path)-length($basepath);
#
#    $path =~ s/\\/\//g;
#    $path =~ s/\/$//g;
#
#    return $path;
#}

1;
