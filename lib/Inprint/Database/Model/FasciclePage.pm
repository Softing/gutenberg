package Inprint::Database::Model::FasciclePage;

use utf8;
use strict;
use warnings;

use Moose;
use MooseX::UndefTolerant;
use Inprint::Utils::MooseUUID qw(UUID);

extends "Inprint::Database::Base";

has "sql"           => (isa => "Object",   is => "rw");

has 'id'            => (isa => UUID,    is => 'rw');
has 'edition'       => (isa => UUID,    is => 'rw');
has 'fascicle'      => (isa => UUID,    is => 'rw');
has 'origin'        => (isa => UUID,    is => 'rw');
has 'headline'      => (isa => UUID,    is => 'rw');

has 'seqnum'        => (isa => 'Int',   is => 'rw');

has 'w'             => (isa => 'ArrayRef',   is => 'rw');
has 'h'             => (isa => 'ArrayRef',   is => 'rw');

has 'created'       => (isa => 'Str',  is => 'rw');
has 'updated'       => (isa => 'Str',  is => 'rw');

has '_holes'        => (isa => 'Any',  is => 'rw', predicate => "has_holes");
has '_modules'      => (isa => 'Any',  is => 'rw', predicate => "has_modules");
has '_requests'     => (isa => 'Any',  is => 'rw', predicate => "has_requests");
has '_documents'    => (isa => 'Any',  is => 'rw', predicate => "has_documents");

sub findDocuments{

    my ($c) = @_;

    if ($c->has_documents) { return $c->_documents; }

    my $sqldata = $c->sql->Q("
            SELECT t1.*
            FROM
                documents t1,
                fascicles_map_documents t2
            WHERE 1=1
                AND t1.id       = t2.entity
                AND t1.fascicle = ?
                AND t2.page     = ?
    ", [ $c->fascicle, $c->id ])->Hashes;

    my @items;
    foreach (@$sqldata) {
        push @items, new Inprint::Database::Model::Document($_)->setSql($c->sql);
    }

    return $c->_documents(\@items);
}

sub findHoles{

    my ($c) = @_;

    if ($c->has_holes) { return $c->_holes; }

    my $sqldata = $c->sql->Q("
            SELECT modules.*
            FROM
                fascicles_modules modules,
                fascicles_map_modules maps
            WHERE 1=1
                AND modules.id  = maps.module
                AND modules.fascicle = ?
                AND maps.placed = false
                AND maps.page   = ?
    ", [ $c->fascicle, $c->id ])->Hashes;

    my @items;
    foreach (@$sqldata) {
        push @items, new Inprint::Database::Model::FascicleModule($_)->setSql($c->sql);
    }

    return $c->_holes(\@items);
}

sub findRequests {

    my ($c) = @_;

    if ($c->_requests) { return $c->_requests; }

    my $sqldata = $c->sql->Q("
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
    ", [ $c->fascicle, $c->id ])->Hashes;

    my @items;
    foreach (@$sqldata) {
        push @items, new Inprint::Database::Model::FascicleRequest($_)->setSql($c->sql);
    }

    return $c->_requests(\@items);
}

sub findModules {

    my ($c) = @_;

    if ($c->has_modules) { return $c->_modules; }

    my $sqldata = $c->sql->Q("
            SELECT t1.*
            FROM
                fascicles_modules t1,
                fascicles_map_modules t2
            WHERE 1=1
                AND t1.id       = t2.module
                AND t2.placed   = true
                AND t1.fascicle = ?
                AND t2.page     = ?
    ", [ $c->fascicle, $c->id ])->Hashes;

    my @items;
    foreach (@$sqldata) {
        push @items, new Inprint::Database::Model::FascicleModule($_)->setSql($c->sql);
    }

    return $c->_modules(\@items);
}


1;
