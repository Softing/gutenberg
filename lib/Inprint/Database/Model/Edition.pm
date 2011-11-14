package Inprint::Database::Model::Edition;

use utf8;
use strict;
use warnings;

use Moose;
use MooseX::UndefTolerant;
use Inprint::Utils::MooseUUID qw(UUID);

extends "Inprint::Database::Base";

has "sql"           => (isa => "Object",   is => "rw");

has 'id'            => (isa => UUID,    is => 'rw');

has "title"         => (isa => 'Str',   is => 'rw');
has "shortcut"      => (isa => 'Str',   is => 'rw');
has "description"   => (isa => 'Str',   is => 'rw');

has 'created'       => (isa => 'Str',   is => 'rw');
has 'updated'       => (isa => 'Str',   is => 'rw');

1;
