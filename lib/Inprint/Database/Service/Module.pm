package Inprint::Database::Service::Module;

use Moose;

use utf8;
use strict;
use warnings;

use Inprint::Database::Model::ModuleMapping;
use Inprint::Database::Model::Request;

extends "Inprint::Database::Model::Module";

sub Request {
    my ($self) = @_;

    my $sqldata = $self->sql->Q("
            SELECT t1.*
            FROM fascicles_requests t1
            WHERE 1=1
                AND t1.module = ?
    ", $self->id )->Hash;

    unless ($sqldata) {
        return new Inprint::Database::Model::Request( app => $self->app );
    }

    return new Inprint::Database::Model::Request( app => $self->app )->map($sqldata);
}

sub MapByPage {
    my ($self, $page) = @_;

    my $sqldata = $self->sql->Q("
            SELECT t1.*
            FROM fascicles_map_modules t1
            WHERE 1=1
                AND t1.module = ?
                AND t1.page   = ?
    ", [ $self->id, $page ])->Hash;

    return new Inprint::Database::Model::ModuleMapping( app=>$self->app )->map($sqldata);
}

1;
