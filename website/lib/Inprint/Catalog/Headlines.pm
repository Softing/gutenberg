package Inprint::Catalog::Headlines;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Headline;

use base 'Mojolicious::Controller';

sub read {
    my $c = shift;

    my @errors;
    my $result = [];

    my $i_id = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        $result = Inprint::Models::Headline::read($c, $i_id);
    }

    $c->smart_render( \@errors, $result );
}

sub tree {
    my $c = shift;

    my @errors;
    my @result;

    my $i_edition = $c->get_uuid(\@errors, "node");

    my $edition = $c->check_record(\@errors, "editions", "edition", $i_edition);

    unless (@errors) {

        my $sql;
        my @data;

        my $editions = $c->Q("
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

        my $data = $c->Q($sql, \@data)->Hashes;

        foreach my $item (@$data) {

            my $count = $c->Q(" SELECT count(*) FROM indx_rubrics WHERE headline=? ", [ $item->{id} ])->Value;

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

    $c->render_json( \@result );
}

sub create {
    my $c = shift;

    my @errors;

    my $id            = $c->uuid();

    my $i_edition     = $c->get_uuid(\@errors, "edition");
    my $i_title       = $c->get_text(\@errors, "title");
    my $i_description = $c->get_text(\@errors, "description", 1);
    my $i_bydefault   = $c->param("bydefault");

    $c->check_access( \@errors, "domain.index.manage");

    my $edition = $c->check_record(\@errors, "editions", "edition", $i_edition);

    unless (@errors) {
        Inprint::Models::Headline::create($c, $id, $edition->{id}, $i_bydefault, $i_title, $i_description);
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

    my $headline = $c->check_record(\@errors, "indx_headlines", "headline", $i_id);

    unless (@errors) {
        Inprint::Models::Headline::update($c, $i_id, $headline->{edition}, $i_bydefault, $i_title, $i_description);
    }

    $c->smart_render(\@errors);
}

sub delete {
    my $c = shift;

    my @errors;

    my $i_id = $c->get_uuid(\@errors, "id");

    $c->check_access( \@errors, "domain.index.manage");

    unless (@errors) {
        Inprint::Models::Headline::delete($c, $i_id);
    }

    $c->smart_render(\@errors);
}

1;
