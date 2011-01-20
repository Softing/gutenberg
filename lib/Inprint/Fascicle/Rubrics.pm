package Inprint::Fascicle::Rubrics;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Fascicle::Rubric;

use base 'Inprint::BaseController';

sub read {
    my $c = shift;
    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    my $result = [];

    unless (@errors) {
        $result = Inprint::Models::Fascicle::Rubric::read($c, $i_id);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub list {
    my $c = shift;

    my $i_headline = $c->param("headline");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_headline));

    my $result;
    unless (@errors) {
        $result = $c->sql->Q("
            SELECT id, tag, title, description
            FROM fascicles_indx_rubrics WHERE headline=?
            ORDER BY title ASC ",
            [ $i_headline ] )->Hashes;
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result || [] } );
}

sub create {
    my $c = shift;

    my $id            = $c->uuid();

    my $i_bydefault   = $c->param("bydefault");
    my $i_headline    = $c->param("headline");
    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "headline", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_headline));

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));

    my $headline = $c->sql->Q(" SELECT * FROM fascicles_indx_headlines WHERE id=? ", [ $i_headline ])->Hash;
    push @errors, { id => "headline", msg => "Incorrectly filled field"}
        unless ($headline->{id});

    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("editions.index.manage", $headline->{edition}));

    unless (@errors) {
        Inprint::Models::Fascicle::Rubric::create(
            $c, $id, $headline->{edition}, $headline->{fascicle}, $headline->{id}, $i_bydefault, $i_title, $i_description);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub update {
    my $c = shift;

    my $i_id          = $c->param("id");
    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");
    my $i_bydefault   = $c->param("bydefault");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));

    my $rubric = Inprint::Models::Fascicle::Rubric::read($c, $i_id);
    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($rubric->{id});

    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("editions.index.manage", $rubric->{edition}));

    unless (@errors) {
        Inprint::Models::Fascicle::Rubric::update($c, $rubric->{id}, $rubric->{edition}, $rubric->{fascicle}, $rubric->{headline}, $i_bydefault, $i_title, $i_description);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub delete {
    my $c = shift;
    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    my $rubric = Inprint::Models::Fascicle::Rubric::read($c, $i_id);
    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($rubric->{id});

    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("editions.index.manage", $rubric->{edition}));

    unless (@errors) {
        Inprint::Models::Fascicle::Rubric::delete($c, $i_id);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });

}

1;
