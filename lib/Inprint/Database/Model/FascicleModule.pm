package Inprint::Database::Model::FascicleModule;

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

has "place"         => (isa => UUID,    is => 'rw');
has "origin"        => (isa => UUID,    is => 'rw');

has "title"         => (isa => 'Str',   is => 'rw');
has "description"   => (isa => 'Str',   is => 'rw');

has "amount"        => (isa => 'Int',   is => 'rw');
has "w"             => (isa => 'Str',   is => 'rw');
has "h"             => (isa => 'Str',   is => 'rw');
has "area"          => (isa => 'Num',   is => 'rw');

has "width"         => (isa => 'Num',   is => 'rw');
has "height"        => (isa => 'Num',   is => 'rw');
has "fwidth"        => (isa => 'Num',   is => 'rw');
has "fheight"       => (isa => 'Num',   is => 'rw');

has 'created'       => (isa => 'Str',   is => 'rw');
has 'updated'       => (isa => 'Str',   is => 'rw');

#

has '_request'      => (isa => 'Any',  is => 'rw', predicate => "has_request");
has '_map'          => (isa => 'Any',  is => 'rw', predicate => "has_map");

sub findRequest {

    my ($c) = @_;

    if ($c->has_request) { return $c->_request; }

    my $sqldata = $c->sql->Q("
            SELECT t1.*
            FROM fascicles_requests t1
            WHERE 1=1
                AND t1.module = ?
    ", $c->id )->Hash;


    return new Inprint::Database::Model::FascicleRequest({})->setSql($c->sql) unless $sqldata;

    my $item = new Inprint::Database::Model::FascicleRequest($sqldata)->setSql($c->sql);

    return $c->_request($item);
}

sub findMapByPage {

    my ($c, $page) = @_;

    if ($c->has_map) { return $c->_map; }

    my $sqldata = $c->sql->Q("
            SELECT t1.*
            FROM fascicles_map_modules t1
            WHERE 1=1
                AND t1.module = ?
                AND t1.page   = ?
    ", [ $c->id, $page ])->Hash;

    my $item = new Inprint::Database::Model::FascicleModuleMapping($sqldata)->setSql($c->sql);

    return $c->_map($item);
}

1;
