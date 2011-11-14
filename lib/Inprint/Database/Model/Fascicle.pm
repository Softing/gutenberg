package Inprint::Database::Model::Fascicle;

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
has 'parent'        => (isa => UUID,    is => 'rw');
has 'manager'       => (isa => UUID,    is => 'rw');

has 'variation'     => (isa => UUID,    is => 'rw');
has 'circulation'   => (isa => 'Int',   is => 'rw');

has 'shortcut'      => (isa => 'Str',   is => 'rw');
has 'description'   => (isa => 'Str',   is => 'rw');

has 'tmpl'          => (isa => UUID,    is => 'rw');
has 'tmpl_shortcut' => (isa => 'Str',   is => 'rw');

has 'fastype'       => (isa => 'Str',   is => 'rw');
has 'status'        => (isa => 'Str',   is => 'rw');
has 'deleted'       => (isa => 'Bool',  is => 'rw');
has 'enabled'       => (isa => 'Bool',  is => 'rw');
has 'archived'      => (isa => 'Bool',  is => 'rw');

has 'adv_enabled'   => (isa => 'Bool',  is => 'rw');
has 'doc_enabled'   => (isa => 'Bool',  is => 'rw');

has 'num'           => (isa => 'Int',   is => 'rw');
has 'anum'          => (isa => 'Int',   is => 'rw');

has 'doc_date'      => (isa => 'Str',   is => 'rw');
has 'adv_date'      => (isa => 'Str',   is => 'rw');
has 'print_date'    => (isa => 'Str',   is => 'rw');
has 'release_date'  => (isa => 'Str',   is => 'rw');

has 'created'       => (isa => 'Str',   is => 'rw');
has 'updated'       => (isa => 'Str',   is => 'rw');

#

has '_pages'       => (isa => 'Any',  is => 'rw', predicate => "has_pages");

sub findEdition {
    my ($c) = @_;
    my $sqldata = $c->sql->Q(" SELECT * FROM editions WHERE id = ? ", $c->edition)->Hash;
    return new Inprint::Database::Model::Edition($sqldata)->setSql($c->sql);
}

sub findPages {

    my ($c) = @_;

    if ($c->has_pages) { return $c->_pages; }

    my $sqldata = $c->sql->Q(" SELECT * FROM fascicles_pages WHERE fascicle = ? ORDER BY seqnum", $c->id)->Hashes;

    my @pages;
    foreach (@$sqldata) {
        push @pages, new Inprint::Database::Model::FasciclePage($_)->setSql($c->sql);
    }

    return $c->_pages(\@pages);

}

1;
