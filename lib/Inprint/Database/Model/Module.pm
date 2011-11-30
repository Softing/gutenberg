package Inprint::Database::Model::Module;

use utf8;
use strict;
use warnings;

use Moose;
use MooseX::UndefTolerant;
use Inprint::Utils::MooseUUID qw(UUID);

use constant ID      => "modules";
use constant TABLE   => "fascicle_modules";
use constant COLUMNS => qw/
    id edition fascicle place origin title description amount w h area width
    height fwidth fheight created::date updated::date /;

use constant FIELDS => qw/  /;

extends "Inprint::Database::Model";

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

1;
