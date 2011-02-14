package Inprint::Store::Embedded::Utils;

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

    if ($^O eq "linux") {
        $path =~ s/\\/\//g;
        $path =~ s/\/+/\//g;
    }

    return $path;
}

sub encode {
    my $c = shift;
    my $path = shift;

    if ($^O eq "MSWin32") {
        $path = Encode::decode("cp1251", $path);
    }

    if ($^O eq "linux") {
        #$path = Encode::decode("utf8", $path);
    }

    return $path;
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

    my ($cname,$cpath,$cextension) = fileparse($filepath, qr/(\.[^.]+){1}?/);

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

sub getRootPath {
    my $c = shift;

    my $path = $c->config->get("store.path");

    die "Can't find configuration of datastore folder" unless $path;
    die "Can't find datastore folder in filesystem" unless -e $path;
    die "Can't read datastore folder" unless -r $path;
    die "Can't write to datastore folder" unless -w $path;

    return $path;
}



sub getExtension {
    my $c = shift;
    my $filepath = shift;

    my ($name,$path,$suffix) = fileparse($filepath, qr/(\.[^.]+){1}?/);
    $suffix =~ s/^.//g;

    return $suffix;
}

1;
