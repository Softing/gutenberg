package Inprint::Database::Model::Document;

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

has "title"         => (isa => 'Str',   is => 'rw');

has "creator"                  => (isa => UUID,   is => 'rw');
has "creator_shortcut"         => (isa => 'Str',   is => 'rw');

has "holder"                  => (isa => UUID,   is => 'rw');
has "holder_shortcut"         => (isa => 'Str',   is => 'rw');

has "manager"                  => (isa => UUID,   is => 'rw');
has "manager_shortcut"         => (isa => 'Str',   is => 'rw');

has "edition"                  => (isa => UUID,   is => 'rw');
has "edition_shortcut"         => (isa => 'Str',   is => 'rw');

has "fascicle"                  => (isa => UUID,   is => 'rw');
has "fascicle_shortcut"         => (isa => 'Str',   is => 'rw');
has "fascicle_blocked"          => (isa => 'Bool',   is => 'rw');

has "headline"                  => (isa => UUID,   is => 'rw');
has "headline_shortcut"         => (isa => 'Str',   is => 'rw');

has "readiness"                 => (isa => UUID,   is => 'rw');
has "readiness_shortcut"        => (isa => 'Str',   is => 'rw');

has "rubric"                    => (isa => UUID,   is => 'rw');
has "rubric_shortcut"           => (isa => 'Str',   is => 'rw');

has "branch"                    => (isa => UUID,   is => 'rw');
has "branch_shortcut"           => (isa => 'Str',   is => 'rw');

has "stage"                     => (isa => UUID,   is => 'rw');
has "stage_shortcut"            => (isa => 'Str',   is => 'rw');

has "readiness"                 => (isa => UUID,   is => 'rw');
has "readiness_shortcut"        => (isa => 'Str',   is => 'rw');

has "color"                     => (isa => 'Str',   is => 'rw');
has "progress"                  => (isa => 'Int',   is => 'rw');

has "author"                    => (isa => 'Str',   is => 'rw');

has "firstpage"                 => (isa => 'Int',   is => 'rw');
has "pages"                     => (isa => 'Str',   is => 'rw');

#"ineditions" uuid[],
#"copygroup" uuid,
#"movegroup" uuid,
#"maingroup" uuid NOT NULL,
#"maingroup_shortcut" varchar NOT NULL,
#"workgroup" uuid NOT NULL,
#"workgroup_shortcut" varchar NOT NULL,
#"inworkgroups" uuid[],


#"filepath" varchar,

#"pdate" timestamptz(6),
#"fdate" timestamptz(6),
#"ldate" timestamptz(6),

#"psize" int4 DEFAULT 0,
#"rsize" int4 DEFAULT 0,
#"images" int4 DEFAULT 0,
#"files" int4 DEFAULT 0,

has "islooked"                  => (isa => 'Bool',   is => 'rw');
has "isopen"                    => (isa => 'Bool',   is => 'rw');

has "uploaded"                  => (isa => 'Str',   is => 'rw');
has "moved"                     => (isa => 'Str',   is => 'rw');
has "created"                   => (isa => 'Str',   is => 'rw');
has "updated"                   => (isa => 'Str',   is => 'rw');

#

1;
