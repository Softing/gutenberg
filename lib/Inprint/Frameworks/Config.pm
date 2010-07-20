package Inprint::Frameworks::Config;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Config::INIPlus;

sub new {
    my $class           = shift;
    my $self        = {};
    $self           = bless {}, $class;
    $self->{folder} = shift;
    $self->{file}   = $self->{folder} . '/app.config';
        
        unless (-e $self->{file}) {
            if (-W $self->{folder}) {
                
                $self->{config} = Config::INIPlus->new( string => "");
                
                $self->{config}->set("title", "Inprint Content", "core");
                $self->{config}->set("version", "5.0", "core");
                $self->{config}->set("installed", "no", "core");
                
                $self->{config}->write($self->{file});
            } else {
                die "Can't create config file ". $self->{file} . " at folder " . $self->{folder};
            }
        }
        else {
                $self->{config} = Config::INIPlus->new( file => $self->{file} );
        }
        
    return $self;
}

sub get {
        my $class = shift;
        my ($section, $parametr) = split '\.', shift;
        return $class->{config}->get( $parametr, $section );
}

sub set {
        my $class = shift;
        my ($section, $parametr) = split '\.', shift;
        my $value = shift;
        $class->{config}->set( $parametr, $value, $section );
}

sub del {
        my $class = shift;
        my ($section, $parametr) = split '\.', shift;
        $class->{config}->del( $parametr, $section );
}

sub write {
        my $class = shift;
        $class->{config}->write($class->{file});
}

1;
