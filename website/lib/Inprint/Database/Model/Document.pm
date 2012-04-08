package Inprint::Database::Model::Document;

use Moose;

use utf8;
use strict;
use warnings;

use Inprint::Utils::MooseUUID qw(UUID);

use constant ID      => "documnent";
use constant TABLE   => "documents";
use constant COLUMNS => qw/
    id  edition fascicle title creator creator_shortcut holder holder_shortcut
    manager manager_shortcut  edition edition_shortcut fascicle fascicle_shortcut
    group_id fs_folder
    fascicle_blocked headline headline_shortcut readiness readiness_shortcut
    rubric rubric_shortcut branch branch_shortcut stage stage_shortcut readiness
    readiness_shortcut color progress author firstpage pages ineditions copygroup
    movegroup maingroup maingroup_shortcut workgroup workgroup_shortcut inworkgroups
    pdate::date fdate::date ldate psize rsize images files islooked isopen
    uploaded::date moved::date created::date updated::date /;

use constant FIELDS => qw/ access /;

extends "Inprint::Database::Model";

has "id"                        => (isa => UUID,    is => "rw");
has "edition"                   => (isa => UUID,    is => "rw");
has "fascicle"                  => (isa => UUID,    is => "rw");

has "access"                => (isa => "Any",   is => "rw");

has "title"                     => (isa => "Str",   is => "rw");

has "creator"                   => (isa => UUID,    is => "rw");
has "creator_shortcut"          => (isa => "Str",   is => "rw");

has "holder"                    => (isa => UUID,    is => "rw");
has "holder_shortcut"           => (isa => "Str",   is => "rw");

has "manager"                   => (isa => UUID,    is => "rw");
has "manager_shortcut"          => (isa => "Str",   is => "rw");

has "edition"                   => (isa => UUID,    is => "rw");
has "edition_shortcut"          => (isa => "Str",   is => "rw");

has "fascicle"                  => (isa => UUID,    is => "rw");
has "fascicle_shortcut"         => (isa => "Str",   is => "rw");
has "fascicle_blocked"          => (isa => "Bool",  is => "rw");

has "headline"                  => (isa => UUID,    is => "rw");
has "headline_shortcut"         => (isa => "Str",   is => "rw");

has "readiness"                 => (isa => UUID,    is => "rw");
has "readiness_shortcut"        => (isa => "Str",   is => "rw");

has "rubric"                    => (isa => UUID,    is => "rw");
has "rubric_shortcut"           => (isa => "Str",   is => "rw");

has "branch"                    => (isa => UUID,    is => "rw");
has "branch_shortcut"           => (isa => "Str",   is => "rw");

has "stage"                     => (isa => UUID,    is => "rw");
has "stage_shortcut"            => (isa => "Str",   is => "rw");

has "readiness"                 => (isa => UUID,    is => "rw");
has "readiness_shortcut"        => (isa => "Str",   is => "rw");

has "color"                     => (isa => "Str",   is => "rw");
has "progress"                  => (isa => "Int",   is => "rw");

has "author"                    => (isa => "Str",   is => "rw");

has "firstpage"                 => (isa => "Int",   is => "rw");
has "pages"                     => (isa => "Str",   is => "rw");

has "ineditions"                => (isa => "Any",   is => "rw");

has "copygroup"                 => (isa => UUID,    is => "rw");
has "movegroup"                 => (isa => UUID,    is => "rw");

has "maingroup"                 => (isa => UUID,    is => "rw");
has "maingroup_shortcut"        => (isa => "Str",   is => "rw");

has "workgroup"                 => (isa => UUID,    is => "rw");
has "workgroup_shortcut"        => (isa => "Str",   is => "rw");

has "inworkgroups"              => (isa => "Any",   is => "rw");

has "group_id"                  => (isa => UUID,    is => "rw");
has "fs_folder"                 => (isa => "Str",   is => "rw");

has "pdate"                     => (isa => "Str",   is => "rw");
has "fdate"                     => (isa => "Str",   is => "rw");
has "ldate"                     => (isa => "Str",   is => "rw");

has "psize"                     => (isa => "Int",   is => "rw");
has "rsize"                     => (isa => "Int",   is => "rw");
has "images"                    => (isa => "Int",   is => "rw");
has "files"                     => (isa => "Int",   is => "rw");

has "islooked"                  => (isa => "Bool",  is => "rw");
has "isopen"                    => (isa => "Bool",  is => "rw");

has "uploaded"                  => (isa => "Str",   is => "rw");
has "moved"                     => (isa => "Str",   is => "rw");
has "created"                   => (isa => "Str",   is => "rw");
has "updated"                   => (isa => "Str",   is => "rw");

1;
