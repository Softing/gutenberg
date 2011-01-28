package Inprint::Store::Embedded::Navigation;

use strict;

sub getRootPath {
    my $c = shift;

    my $path = $c->config->get("store.path");

    die "Can't find configuration of datastore folder" unless $path;
    die "Can't find datastore folder in filesystem" unless -e $path;
    die "Can't read datastore folder" unless -r $path;
    die "Can't write to datastore folder" unless -w $path;

    return $path;
}

sub getRelativePath {
    my $c = shift;
    my $path = shift;

    die "Can't find configuration of datastore folder" unless $path;
    die "Can't find datastore folder in filesystem" unless -e $path;
    die "Can't read datastore folder" unless -r $path;
    die "Can't write to datastore folder" unless -w $path;

    my $basepath = $c->config->get("store.path");

    $path = substr $path, length($basepath), length($path)-length($basepath);

    $path =~ s/\\/\//g;

    return $path;
}


sub getAreaPath {
    my $c = shift;

    return $c;
}

sub getFolderPath {
    my $c = shift;

    return $c;
}

sub getTmpFolderPath {
    my $c = shift;

    return $c;
}

1;
