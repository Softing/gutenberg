package Inprint::Store::Embedded::Metadata;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;

use File::Basename;
use File::Util;
use POSIX qw(strftime);
use Digest::file qw(digest_file_hex);

sub getDigest {
    my ($c, $filepath) = @_;
    $filepath = __clearPath($c, $filepath);
    return digest_file_hex($filepath, "MD5");
}

sub getFileCreateDate {
    my $c = shift;
    my $filepath = shift;
    my $date = File::Util::created($filepath);
    return strftime("%Y-%m-%d %H:%M:%S", gmtime($date));
}

sub getFileModifyDate {
    my ($c, $filepath) = @_;
    my $date = File::Util::last_modified($filepath);
    return strftime("%Y-%m-%d %H:%M:%S", gmtime($date));
}

sub getFileSize {
    my ($c, $filepath) = @_;
    my $filesize = File::Util::size($filepath);
    return $filesize;
}

sub __clearPath {

    my ($c, $filepath) = @_;

    if ($^O eq "MSWin32") {
        $filepath =~ s/\//\\/g;
        $filepath =~ s/\\+/\\/g;
    }

    if ($^O eq "linux") {
        $filepath =~ s/\\/\//g;
        $filepath =~ s/\/+/\//g;
    }

    return $filepath;
}

1;
