package Inprint::Database::Model::FascicleModuleMapping;

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

has "module"        => (isa => UUID,    is => 'rw');
has "page"          => (isa => UUID,    is => 'rw');

has "placed"        => (isa => 'Bool',   is => 'rw');

has "x"             => (isa => 'Str',   is => 'rw');
has "y"             => (isa => 'Str',   is => 'rw');

has 'created'       => (isa => 'Str',   is => 'rw');
has 'updated'       => (isa => 'Str',   is => 'rw');


1;
