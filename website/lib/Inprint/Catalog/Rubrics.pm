package Inprint::Catalog::Rubrics;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Rubric;

use base 'Mojolicious::Controller';

sub read {
    my $c = shift;

    my @errors;
    my $result = [];

    my $i_id = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        $result = Inprint::Models::Rubric::read($c, $i_id);
    }

    $c->smart_render( \@errors, $result );
}

sub list {
    my $c = shift;

    my @errors;
    my $result;

    my $i_headline = $c->get_uuid(\@errors, "headline");

    unless (@errors) {
        $result = $c->Q("
            SELECT id, tag, title, description
            FROM indx_rubrics WHERE headline=?
            ORDER BY title ASC ",
            [ $i_headline ] )->Hashes;
    }

    $c->smart_render( \@errors, $result );
}

sub create {
    my $c = shift;

    my @errors;

    my $id            = $c->uuid();

    my $i_headline    = $c->get_uuid(\@errors, "headline");
    my $i_title       = $c->get_text(\@errors, "title");
    my $i_description = $c->get_text(\@errors, "description", 1);
    my $i_bydefault   = $c->param("bydefault");

    $c->check_access( \@errors, "domain.index.manage");

    my $headline = $c->check_record(\@errors, "indx_headlines", "headline", $i_headline);

    unless (@errors) {
        Inprint::Models::Rubric::create($c, $id, $headline->{edition}, $headline->{id}, $i_bydefault, $i_title, $i_description);
    }

    $c->smart_render(\@errors);
}

sub update {
    my $c = shift;

    my @errors;

    my $i_id          = $c->get_uuid(\@errors, "id");
    my $i_title       = $c->get_text(\@errors, "title");
    my $i_description = $c->get_text(\@errors, "description", 1);
    my $i_bydefault   = $c->param("bydefault");

    $c->check_access( \@errors, "domain.index.manage");

    my $rubric = $c->check_record(\@errors, "indx_rubrics", "rubric", $i_id);

    unless (@errors) {
        Inprint::Models::Rubric::update($c, $rubric->{id}, $rubric->{edition}, $rubric->{headline}, $i_bydefault, $i_title, $i_description);
    }

    $c->smart_render(\@errors);
}

sub delete {
    my $c = shift;

    my @errors;

    my $i_id = $c->get_uuid(\@errors, "id");

    $c->check_access( \@errors, "domain.index.manage");

    unless (@errors) {
        Inprint::Models::Rubric::delete($c, $i_id);
    }

    $c->smart_render(\@errors);
}

1;
