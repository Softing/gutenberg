package Inprint::Database::Model::FascicleRequest;

use utf8;
use strict;
use warnings;

use Moose;
use MooseX::UndefTolerant;
use Inprint::Utils::MooseUUID qw(UUID);

extends "Inprint::Database::Base";

has "sql"                   => (isa => "Object",   is => "rw");

has 'id'                    => (isa => UUID,    is => 'rw');
has 'edition'               => (isa => UUID,    is => 'rw');
has 'fascicle'              => (isa => UUID,    is => 'rw');

has "module"                => (isa => UUID,    is => 'rw');

has "serialnum"             => (isa => 'Int',   is => 'rw');

has "advertiser"            => (isa => UUID,    is => 'rw');
has "advertiser_shortcut"   => (isa => 'Str',   is => 'rw');
has "place"                 => (isa => UUID,    is => 'rw');
has "place_shortcut"        => (isa => 'Str',   is => 'rw');
has "manager"               => (isa => UUID,    is => 'rw');
has "manager_shortcut"      => (isa => 'Str',   is => 'rw');

has "amount"                => (isa => 'Int',   is => 'rw');
has "origin"                => (isa => UUID,   is => 'rw');
has "origin_shortcut"       => (isa => 'Str',   is => 'rw');
has "origin_area"           => (isa => 'Num',   is => 'rw');
has "origin_x"              => (isa => 'Str',   is => 'rw');
has "origin_y"              => (isa => 'Str',   is => 'rw');
has "origin_w"              => (isa => 'Str',   is => 'rw');
has "origin_h"              => (isa => 'Str',   is => 'rw');

has "pages"                 => (isa => 'Str',   is => 'rw');
has "firstpage"             => (isa => 'Int',   is => 'rw');
has "shortcut"              => (isa => 'Str',   is => 'rw');
has "description"           => (isa => 'Str',   is => 'rw');
has "status"                => (isa => 'Str',   is => 'rw');
has "payment"               => (isa => 'Str',   is => 'rw');
has "readiness"             => (isa => 'Str',   is => 'rw');

has "squib"                 => (isa => 'Str',   is => 'rw');
has "check_status"          => (isa => 'Str',   is => 'rw');

has "anothers_layout"       => (isa => 'Bool',   is => 'rw');
has "imposed"               => (isa => 'Bool',   is => 'rw');

has 'created'               => (isa => 'Str',   is => 'rw');
has 'updated'               => (isa => 'Str',   is => 'rw');

##


1;
