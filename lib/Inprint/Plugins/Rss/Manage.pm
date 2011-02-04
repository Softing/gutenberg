package Inprint::Plugins::Rss::Manage;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Rss;

use base 'Inprint::BaseController';

sub list {
    my $c = shift;

    my $start    = $c->param("start")        || 0;
    my $limit    = $c->param("limit")        || 60;
    my $dir      = $c->param("dir")          || "DESC";
    my $sort     = $c->param("sort")         || "created";

    my $i_filter = $c->param("flt_rssonly");

    # Base query
    my @params;
    my $sql_query = "
            SELECT
                dcm.*, rss.id as rss_id, rss.published as rss_published,
                to_char(dcm.pdate, 'YYYY-MM-DD HH24:MI:SS') as pdate,
                to_char(dcm.fdate, 'YYYY-MM-DD HH24:MI:SS') as fdate,
                to_char(dcm.ldate, 'YYYY-MM-DD HH24:MI:SS') as ldate,
                to_char(dcm.created, 'YYYY-MM-DD HH24:MI:SS') as created,
                to_char(dcm.updated, 'YYYY-MM-DD HH24:MI:SS') as updated
            FROM documents dcm LEFT JOIN rss ON dcm.id = rss.document
            WHERE dcm.fascicle <> '99999999-9999-9999-9999-999999999999'
        ";

    # Total query
    my $sql_total = "
        SELECT count(*)
        FROM documents dcm LEFT JOIN rss ON dcm.id = rss.document
        WHERE dcm.fascicle <> '99999999-9999-9999-9999-999999999999'
    ";

    # Filters

    if ($i_filter eq "true") {
        $sql_query .= " AND rss.id is not null AND rss.published=true";
        $sql_total .= " AND rss.id is not null AND rss.published=true";
    }

    # Sorting
    if ($dir && $sort) {
        if ( $dir ~~ ["ASC", "DESC"] ) {
            if ( $sort ~~ ["title", "maingroup_shortcut", "fascicle_shortcut", "headline_shortcut", "created",
                           "rubric_shortcut", "pages", "manager_shortcut", "progress", "holder_shortcut", "images", "rsize" ] ) {
                $sql_query .= " ORDER BY dcm.$sort $dir ";
            }
        }
    }

    # Pagination
    if ($limit > 0 && $start >= 0) {
        $sql_query .= " LIMIT ? OFFSET ? ";
        push @params, $limit;
        push @params, $start;
    }

    my $result = $c->sql->Q($sql_query, \@params)->Hashes;
    my $total  = $c->sql->Q($sql_total, [])->Value;

    foreach my $item (@$result) {
        $item->{access} = {
            rss => $c->json->false,
            upload => $c->json->false,
        };
        if ($item->{workgroup} && $c->access->Check("catalog.documents.rss:*", $item->{workgroup})) {
            $item->{access}->{rss} = $c->json->true;
            if ($item->{id}) {
                $item->{access}->{upload} = $c->json->true;
            }
        }
    }

    $c->render_json( { "data" => $result, "total" => $total } );
}

sub read {

    my $c = shift;

    my $i_document = $c->param("document") || undef;

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "document", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_document));

    my $document;
    unless (@errors) {
        $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $i_document ])->Hash;
        push @errors, { id => "document", msg => "Can't find object"}
            unless $document->{id};
    }

    my $result;

    unless (@errors) {

        $result = Inprint::Models::Rss::read($c, $document->{id});

        $result->{access} = {
            rss => $c->json->false,
            upload => $c->json->false,
        };

        if ($document->{workgroup} && $c->access->Check("catalog.documents.rss:*", $document->{workgroup})) {
            $result->{access}->{rss} = $c->json->true;
            if ($result->{id}) {
                $result->{access}->{upload} = $c->json->true;
            }
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub update {

    my $c = shift;

    my $i_document    = $c->param("document") || undef;
    my $i_published   = $c->param("published") || undef;
    my $i_link        = $c->param("link") || undef;
    my $i_title       = $c->param("title") || undef;
    my $i_description = $c->param("description") || undef;
    my $i_fulltext    = $c->param("fulltext") || undef;

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "document", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_document));

    my $document;
    unless (@errors) {
        $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $i_document ])->Hash;
        push @errors, { id => "document", msg => "Can't find object"}
            unless $document->{id};
    }

    unless (@errors) {
        my $enabled = 0;
        if ($i_published eq "on") {
            $enabled = 1;
        }
        Inprint::Models::Rss::update($c, $document->{id}, $enabled, $i_link, $i_title, $i_description, $i_fulltext);
        $success = $c->json->true;
    }

    $success = $c->json->true unless @errors;
    $c->render_json( { success => $success, errors => \@errors } );
}

sub publish {
    my $c = shift;

    my @i_ids = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    foreach my $id (@i_ids) {
        my $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $id ])->Hash;
        next unless ($document->{workgroup} && $c->access->Check("catalog.documents.rss:*", $document->{workgroup}));
        my $rss = $c->sql->Q(" SELECT * FROM rss WHERE document=? ", [ $id ])->Hash;
        next unless $rss;
        $c->sql->Do(" UPDATE rss SET published=true WHERE document=? ", [ $id ]);
    }

    $success = $c->json->true unless @errors;
    $c->render_json({});
}

sub unpublish {
    my $c = shift;

    my @i_ids = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    foreach my $id (@i_ids) {
        my $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $id ])->Hash;
        next unless ($document->{workgroup} && $c->access->Check("catalog.documents.rss:*", $document->{workgroup}));
        my $rss = $c->sql->Q(" SELECT * FROM rss WHERE document=? ", [ $id ])->Hash;
        next unless $rss;
        $c->sql->Do(" UPDATE rss SET published=false WHERE document=? ", [ $id ]);
    }

    $success = $c->json->true unless @errors;
    $c->render_json({});
}


1;
