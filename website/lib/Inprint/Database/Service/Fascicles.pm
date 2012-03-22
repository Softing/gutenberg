package Inprint::Database::Service::Fascicles;

use Moose;

use utf8;
use strict;
use warnings;

use Inprint::Database::Model::Fascicle;

extends "Inprint::Database::List";

sub list {
    my ($self) = @_;

    $self->records(
        $self->sql->Q(" SELECT * FROM fascicles ")
            ->Objects("Inprint::Database::Model::Fascicle")
    );

    return $self;
}


1;
