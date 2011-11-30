package Inprint::Database::Service::Page;

use Moose;

use utf8;
use strict;
use warnings;

use Inprint::Database::Service::Module;
use Inprint::Database::Service::Request;
use Inprint::Database::Service::Document;

extends "Inprint::Database::Model::Page";

sub Documents{

    my ($self) = @_;

    my $sqldata = $self->sql->Q("
            SELECT t1.*
            FROM
                documents t1,
                fascicles_map_documents t2
            WHERE 1=1
                AND t1.id       = t2.entity
                AND t1.fascicle = ?
                AND t2.page     = ?
    ", [ $self->fascicle, $self->id ])->Hashes;

    my @items;
    foreach (@$sqldata) {
        push @items, new Inprint::Database::Service::Document( app => $self)->map($_);
    }

    return \@items;
}

sub Holes{

    my ($self) = @_;

    my $sqldata = $self->sql->Q("
            SELECT modules.*
            FROM
                fascicles_modules modules,
                fascicles_map_modules maps
            WHERE 1=1
                AND modules.id  = maps.module
                AND modules.fascicle = ?
                AND maps.placed = false
                AND maps.page   = ?
    ", [ $self->fascicle, $self->id ])->Hashes;

    my @items;
    foreach (@$sqldata) {
        push @items, new Inprint::Database::Service::Module( app => $self )->map($_);
    }

    return \@items;
}

sub Requests {

    my ($self) = @_;

    my $sqldata = $self->sql->Q("
    SELECT
        rq.*
    FROM
        fascicles_requests rq
        LEFT JOIN fascicles_modules modules ON rq.module = modules.id
        LEFT JOIN fascicles_map_modules maps ON modules.id = maps.module
    WHERE 1=1
        AND rq.fascicle = ?
        AND maps.placed = false
        AND maps.page   = ?
    ", [ $self->fascicle, $self->id ])->Hashes;

    my @items;
    foreach (@$sqldata) {
        push @items, new Inprint::Database::Service::Request( app => $self )->map($_);
    }

    return \@items;
}

sub Modules {

    my ($self) = @_;

    my $sqldata = $self->sql->Q("
            SELECT t1.*
            FROM
                fascicles_modules t1,
                fascicles_map_modules t2
            WHERE 1=1
                AND t1.id       = t2.module
                AND t2.placed   = true
                AND t1.fascicle = ?
                AND t2.page     = ?
    ", [ $self->fascicle, $self->id ])->Hashes;

    my @items;
    foreach (@$sqldata) {
        push @items, new Inprint::Database::Service::Module( app => $self )->map($_);
    }

    return \@items;
}

1;
