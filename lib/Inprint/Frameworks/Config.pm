package Inprint::Frameworks::Config;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Config::Tiny;

sub new {
    my $class = shift;
    my $self  = bless {}, $class;

    $self->{config} = Config::Tiny->new;

    return $self;
}

sub load {
    my $class    = shift;
    my $folder   = shift;

    die "Can't get folder param" unless ($folder);

    $class->{filepath} = "$folder/app.config";

    die "Can't read config file ". $class->{filepath} unless (-r $class->{filepath});

    $class->{config} = Config::Tiny->read( $class->{filepath} )
        || die "Can't read config file\n" . Config::Tiny->errstr;

    return $class;
}

sub get {
    my $class = shift;
    my ($section, $parametr) = split '\.', shift;
    return $class->{config}->{$section}->{$parametr};
    return 1;
}

sub set {
    my $class = shift;
    my ($section, $parametr) = split '\.', shift;
    my $value = shift;
    $class->{config}->{$section}->{$parametr} = $value;
    return 1;
}

sub remove {
    my $class = shift;
    my ($section, $parametr) = split '\.', shift;
    delete $class->{config}->{$section}->{$parametr};
    if ( scalar( keys %{ $class->{config}->{$section} } ) == 0) {
        delete $class->{config}->{$section};
    }
    return 1;
}

sub write {
    my $class = shift;
    $class->{config}->write($class->{filepath});
    return 1;
}

1;
