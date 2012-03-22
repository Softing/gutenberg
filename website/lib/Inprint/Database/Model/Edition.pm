package Inprint::Database::Model::Edition;

use Moose;

use utf8;
use strict;
use warnings;

use Inprint::Utils::MooseUUID qw(UUID);

use constant ID      => "edition";
use constant TABLE   => "editions";
use constant COLUMNS => qw/ id title shortcut description created updated /;

extends "Inprint::Database::Model";

has 'id'            => (isa => UUID,    is => 'rw');
has "title"         => (isa => 'Str',   is => 'rw');
has "shortcut"      => (isa => 'Str',   is => 'rw');
has "description"   => (isa => 'Str',   is => 'rw');
has 'created'       => (isa => 'Str',   is => 'rw');
has 'updated'       => (isa => 'Str',   is => 'rw');


1;
