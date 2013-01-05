package Inprint::Database::Model::Fascicle;

use Moose;

use utf8;
use strict;
use warnings;

use Inprint::Utils::MooseUUID qw(UUID);

use constant ID      => "fascicle";
use constant TABLE   => "fascicles";
use constant COLUMNS => qw/
    id edition parent manager variation circulation
    shortcut description tmpl tmpl_shortcut fastype
    status deleted enabled archived adv_enabled
    doc_enabled num anum doc_date adv_date adv_modules print_date
    release_date created updated /;

use constant FIELDS => qw/ manager_shortcut /;

extends "Inprint::Database::Model";

has "id"                => (isa => UUID,    is => "rw");
has "edition"           => (isa => UUID,    is => "rw");
has "parent"            => (isa => UUID,    is => "rw");
has "manager"           => (isa => UUID,    is => "rw");
has "manager_shortcut"  => (isa => "Str",    is => "rw");

has "variation"         => (isa => UUID,    is => "rw");
has "circulation"       => (isa => "Int",   is => "rw");

has "shortcut"          => (isa => "Str",   is => "rw");
has "description"       => (isa => "Str",   is => "rw");

has "tmpl"              => (isa => UUID,    is => "rw");
has "tmpl_shortcut"     => (isa => "Str",   is => "rw");

has "fastype"           => (isa => "Str",   is => "rw");
has "status"            => (isa => "Str",   is => "rw");
has "deleted"           => (isa => "Bool",  is => "rw");
has "enabled"           => (isa => "Bool",  is => "rw");
has "archived"          => (isa => "Bool",  is => "rw");

has "adv_enabled"       => (isa => "Bool",  is => "rw");
has "doc_enabled"       => (isa => "Bool",  is => "rw");

has "adv_modules"       => (isa => "Num",   is => "rw");

has "num"               => (isa => "Int",   is => "rw");
has "anum"              => (isa => "Int",   is => "rw");

has "doc_date"          => (isa => "Str",   is => "rw");
has "adv_date"          => (isa => "Str",   is => "rw");
has "print_date"        => (isa => "Str",   is => "rw");
has "release_date"      => (isa => "Str",   is => "rw");

has "created"           => (isa => "Str",   is => "rw");
has "updated"           => (isa => "Str",   is => "rw");

1;
