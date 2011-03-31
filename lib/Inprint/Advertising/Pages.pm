package Inprint::Advertising::Pages;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

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
        $result = $c->Q("
            SELECT id, edition, title, description, bydefault, w, h, created, updated FROM ad_pages WHERE id=?
        ", [ $i_id ])->Hash;
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub list {
    my $c = shift;

    my $i_edition = $c->param("edition");

    my $result = [];

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));

    my $edition = $c->Q(" SELECT * FROM editions WHERE id = ? ", [ $i_edition ])->Hash;

    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($edition->{id});

    my @params;
    my $sql = "
        SELECT id, edition, title, description, bydefault, w, h, created, updated
        FROM ad_pages WHERE edition=?
        ORDER BY title";

    unless (@errors) {

        push @params, $edition->{id};

        $result = $c->Q(" $sql ", \@params)->Hashes;

    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub create {
    my $c = shift;

    my $id = $c->uuid();

    my $i_edition     = $c->param("edition");

    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");

    my $i_default       = $c->param("bydefault");

    my @i_w      = $c->param("w") ;
    my @i_h      = $c->param("h") ;

    unless ( @i_w ) {
        @i_w = ( "1/1" );
    }

    unless ( @i_h ) {
        @i_h = ( "1/1" );
    }

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));

    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->access->Check("domain.roles.manage"));

    #push @errors, { id => "width", msg => "Incorrectly filled field"}
    #    unless ($c->is_int($i_w));
    #
    #push @errors, { id => "height", msg => "Incorrectly filled field"}
    #    unless ($c->is_int($i_h));

    #my $fascicle;
    my $edition;

    #unless (@errors) {
    #    $fascicle = $c->Q(" SELECT * FROM fascicles WHERE id=? ", [ $place->{fascicle} ])->Hash;
    #    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
    #        unless ($fascicle);
    #}

    unless (@errors) {
        $edition  = $c->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($edition);
    }

    my $default = 0;
    if ($i_default eq "on") {
        $default = 1;
    }

    unless (@errors) {
        if ($default == 1) {
            $c->Do(" UPDATE ad_pages SET bydefault=false WHERE edition=? ", [ $edition->{id} ]);
        }
    }

    unless (@errors) {
        $c->Do("
            INSERT INTO ad_pages(id, edition, title, description, bydefault, w, h, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [ $id, $edition->{id}, $i_title, $i_description, $default, \@i_w, \@i_h ]);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub update {
    my $c = shift;

    my $i_id          = $c->param("id");

    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");

    my $i_default       = $c->param("bydefault");

    my @i_w      = $c->param("w");
    my @i_h      = $c->param("h");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));

    my $page = $c->Q(" SELECT * FROM ad_pages WHERE id=?", [ $i_id ] )->Hash;

    push @errors, { id => "page", msg => "Can't find object"}
        unless ($page->{id});

    my $default = 0;
    if ($i_default eq "on") {
        $default = 1;
    }

    unless (@errors) {
        if ($default == 1) {
            $c->Do(" UPDATE ad_pages SET bydefault=false WHERE edition=? ", [ $page->{edition} ]);
        }
    }

    unless (@errors) {
        $c->Do("
            UPDATE ad_pages SET title=?, description=?, bydefault=?, w=?, h=?, updated=now() WHERE id = ? ;
        ", [ $i_title, $i_description, $default, \@i_w, \@i_h, $page->{id} ]);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub delete {
    my $c = shift;
    my @ids = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->access->Check("domain.roles.manage"));

    unless (@errors) {
        foreach my $id (@ids) {
            if ($c->is_uuid($id)) {
                $c->Do(" DELETE FROM ad_pages WHERE id=? ", [ $id ]);
                $c->Do(" DELETE FROM ad_modules WHERE page=? ", [ $id ]);
            }
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

1;
