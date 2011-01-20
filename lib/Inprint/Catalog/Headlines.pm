package Inprint::Catalog::Headlines;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Headline;

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
        $result = Inprint::Models::Headline::read($c, $i_id);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub tree {

    my $c = shift;

    my $i_edition = $c->param("node");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));

    my $edition = $c->sql->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($edition->{id});

    my @result;
    unless (@errors) {

        my $sql;
        my @data;

        my $editions = $c->sql->Q("
                SELECT id FROM editions WHERE path @> ? order by path asc;
            ", [ $edition->{path} ])->Values;

        $sql = "
            (
                SELECT id, title, 'marker' as icon, 'current' as status
                FROM indx_headlines WHERE edition=?
                ORDER BY title ASC
            ) UNION ALL (
                SELECT id, title, 'marker--arrow' as icon, 'child' as status
                FROM indx_headlines WHERE edition = ANY(?) AND edition <> ?
                ORDER BY title ASC
            )
        ";
        push @data, $edition->{id};
        push @data, $editions;
        push @data, $edition->{id};

        my $data = $c->sql->Q($sql, \@data)->Hashes;

        foreach my $item (@$data) {

            my $count = $c->sql->Q(" SELECT count(*) FROM indx_rubrics WHERE headline=? ", [ $item->{id} ])->Value;

            my $record = {
                id      => $item->{id},
                icon    => $item->{icon},
                status  => $item->{status},
                text    => $item->{title} . " ($count)",
                leaf    => $c->json->true
            };

            push @result, $record;
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( \@result );
}

sub create {
    my $c = shift;

    my $id            = $c->uuid();

    my $i_edition     = $c->param("edition");
    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");
    my $i_bydefault   = $c->param("bydefault");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));

    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.index.manage"));

    my $edition = $c->sql->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($edition->{id});

    unless (@errors) {
        Inprint::Models::Headline::create($c, $id, $edition->{id}, $i_bydefault, $i_title, $i_description);
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

    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.index.manage"));

    my $headline = Inprint::Models::Headline::read($c, $i_id);
    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($headline->{id});

    unless (@errors) {
        Inprint::Models::Headline::update($c, $i_id, $headline->{edition}, $i_bydefault, $i_title, $i_description);
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

    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.index.manage"));

    unless (@errors) {
        Inprint::Models::Headline::delete($c, $i_id);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });

}

1;
