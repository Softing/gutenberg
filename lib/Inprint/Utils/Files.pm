package Inprint::Utils::Files;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Exporter;

our @ISA        = qw(Exporter);
our @EXPORT     = qw( __FS_GetExtension __FS_AdaptPath __FS_EncodePath __FS_ProcessPath __FS_CreateTempArchive);
our $VERSION    = '0.01';

sub __FS_GetExtension {
    my ($c, $string) = @_;
    return ($string =~ m/([^.]+)$/)[0];
}

sub __FS_AdaptPath {
    my ($c, $string) = @_;
    $string =~ s/\//\\/g    if ($^O eq "MSWin32");
    $string =~ s/\\+/\\/g   if ($^O eq "MSWin32");
    $string =~ s/\\/\//g    if ($^O eq "darwin");
    $string =~ s/\/+/\//g   if ($^O eq "darwin");
    $string =~ s/\\/\//g    if ($^O eq "linux");
    $string =~ s/\/+/\//g   if ($^O eq "linux");
    return $string;
}

sub __FS_EncodePath {
    my ($c, $string) = @_;
    $string = Encode::encode("cp1251", $string) if ($^O eq "MSWin32");
    $string = Encode::encode("utf8", $string)   if ($^O eq "darwin");
    $string = Encode::encode("utf8", $string)   if ($^O eq "linux");
    return $string;
}

sub __FS_ProcessPath {
    my ($c, $string) = @_;
    $string =~ s/\//\\/g    if ($^O eq "MSWin32");

    $string =~ s/\\+/\\/g   if ($^O eq "MSWin32");
    $string =~ s/\\/\//g    if ($^O eq "darwin");
    $string =~ s/\/+/\//g   if ($^O eq "darwin");

    $string =~ s/\\/\//g    if ($^O eq "linux");
    $string =~ s/\/+/\//g   if ($^O eq "linux");

    $string = Encode::encode("cp1251", $string) if ($^O eq "MSWin32");
    $string = Encode::encode("utf8", $string)   if ($^O eq "darwin");
    $string = Encode::encode("utf8", $string)   if ($^O eq "linux");
    return $string;
}

sub __FS_CreateTempArchive {

    my ($c, $tempArchive, $fileListString) = @_;

    my $cmd;
    
    $fileListString .= " *.none ";

    $fileListString .= " *.none ";

    if ($^O eq "MSWin32") {
        $cmd = '"C:\Program Files (x86)\7-Zip\7z"'. " a -mx0 \"$tempArchive\" $fileListString > null";
    }
    if ($^O eq "darwin") {
        $cmd = " LANG=ru_RU.UTF-8 /opt/local/bin/7z a -mx0 \"$tempArchive\" $fileListString > /dev/null 2>&1 ";
    }
    if ($^O eq "linux") {
        $cmd = " LANG=ru_RU.UTF-8 7z a -mx0 \"$tempArchive\" $fileListString > /dev/null 2>&1 ";
    }

    system($cmd);

    return $tempArchive;
}

1;
