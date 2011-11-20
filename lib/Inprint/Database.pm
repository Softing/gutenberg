use utf8;
package Inprint::Database;

use strict;
use warnings;

use Inprint::Database::Service::Edition;
use Inprint::Database::Service::Editions;

use Inprint::Database::Service::Fascicle;
use Inprint::Database::Service::Fascicles;

use Inprint::Database::Service::Pages;
use Inprint::Database::Service::Documents;
use Inprint::Database::Service::Requests;

# Editions

sub Edition {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Edition->new( app => $c );
}
sub Editions {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Editions->new( app => $c );
}

#Fascicles

sub Fascicle {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Fascicle->new( app => $c );
}
sub Fascicles {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Fascicles->new( app => $c );
}

# Pages

sub Page {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Page->new( app => $c );
}
sub Pages {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Pages->new( app => $c );
}

# Documents

sub Document {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Document->new( app => $c );
}
sub Documents {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Documents->new( app => $c );
}

# Requests

sub Requests {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Requests->new( app => $c );
}


1;
