package Inprint::Plugins::Rss::Manage;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;



use base 'Mojolicious::Controller';

sub list {
    my $c = shift;

    my $start    = $c->param("start")        || 0;
    my $limit    = $c->param("limit")        || 60;
    my $dir      = $c->param("dir")          || "DESC";
    my $sort     = $c->param("sort")         || "created";

    my $i_filter = $c->param("filter");

    my @errors;

    # Base query
    my @params;
    my $sql_query = "
            SELECT
                dcm.*,
                rss.id as rss_id, rss.published as rss_published,
                rss.priority as rss_sortorder,
                to_char(dcm.pdate, 'YYYY-MM-DD HH24:MI:SS') as pdate,
                to_char(dcm.fdate, 'YYYY-MM-DD HH24:MI:SS') as fdate,
                to_char(dcm.ldate, 'YYYY-MM-DD HH24:MI:SS') as ldate,
                to_char(dcm.created, 'YYYY-MM-DD HH24:MI:SS') as created,
                to_char(dcm.updated, 'YYYY-MM-DD HH24:MI:SS') as updated
            FROM documents dcm
                LEFT JOIN plugins_rss.rss ON dcm.id = rss.entity
            WHERE dcm.fascicle <> '99999999-9999-9999-9999-999999999999'
        ";

    # Total query
    my $sql_total = "
        SELECT count(*)
        FROM documents dcm LEFT JOIN plugins_rss.rss ON dcm.id = rss.entity
        WHERE dcm.fascicle <> '99999999-9999-9999-9999-999999999999'
    ";

    # Filters

    if ($i_filter eq "show-all") {
    }

    if ($i_filter eq "only-rss") {
        $sql_query .= " AND rss.id is not null AND rss.published=true";
        $sql_total .= " AND rss.id is not null AND rss.published=true";
    }

    if ($i_filter eq "without-rss") {
        $sql_query .= " AND rss.id is null";
        $sql_total .= " AND rss.id is null";
    }

    if ($i_filter =~ m/^[a-z|0-9]{8}(-[a-z|0-9]{4}){3}-[a-z|0-9]{12}+$/) {

        $sql_query .= " AND rss.id is not null AND rss.published=true";
        $sql_total .= " AND rss.id is not null AND rss.published=true";

        my $index = $c->Q("
            SELECT tag, nature FROM plugins_rss.rss_feeds_mapping t1 WHERE feed=?
        ", $i_filter)->Hashes;

        my @editions, my @headlines, my @rubrics;
        foreach my $item (@$index) {
            push @editions,  $item->{tag} if ($item->{nature} eq "edition");
            push @headlines, $item->{tag} if ($item->{nature} eq "headline");
            push @rubrics,   $item->{tag} if ($item->{nature} eq "rubric");
        }

        my @filters;

        if (@editions) {
            push @filters, " dcm.edition = ANY(?) ";
            push @params, \@editions;
        }

        if (@headlines) {
            push @filters, " dcm.headline = ANY(?) ";
            push @params, \@headlines;
        }

        if (@rubrics) {
            push @filters, " dcm.rubric = ANY(?) ";
            push @params, \@rubrics;
        }

        if (@filters) {
            $sql_query .= " AND ( ". join(" OR ", @filters) ." ) ";
            $sql_total .= " AND ( ". join(" OR ", @filters) ." ) ";
        }
    }

    # Get total
    my $total  = $c->Q($sql_total, \@params)->Value;

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

    my $result = $c->Q($sql_query, \@params)->Hashes;


    foreach my $item (@$result) {
        $item->{access} = {
            rss => $c->json->false,
            upload => $c->json->false,
        };
        if ($item->{workgroup}) {
            if ( $c->check_access( \@errors, "catalog.documents.rss:*", $item->{workgroup})) {
                $item->{access}->{rss} = $c->json->true;
                if ($item->{id}) {
                    $item->{access}->{upload} = $c->json->true;
                }
            }
        }
    }

    $c->render_json( { "data" => $result, "total" => $total } );
}

sub read {
    my $c = shift;

    my $result;
    my @errors;

    my $i_document = $c->param("document") || undef;

    $c->check_uuid( \@errors, "document", $i_document);
    my $document = $c->check_record(\@errors, "documents", "document", $i_document);

    unless (@errors) {

        $result = $c->Q("
                SELECT id, entity, sitelink, title, description, fulltext,
                    published, created, updated
                FROM plugins_rss.rss
                WHERE entity=? ",
            [ $document->{id} ])->Hash;

        $result->{access} = {
            rss => $c->json->false,
            upload => $c->json->false,
        };

        if ($document->{workgroup} && $c->objectAccess("catalog.documents.rss:*", $document->{workgroup})) {
            $result->{access}->{rss}    = $c->json->true;
            $result->{access}->{upload} = $c->json->true if ($result->{id});
        }
    }

    $c->smart_render(\@errors, $result);
}

sub update {

    my $c = shift;

    my @errors;

    my $i_document    = $c->param("document") || undef;
    my $i_published   = $c->param("published") || undef;
    my $i_link        = $c->param("link") || $c->param("document");
    my $i_title       = $c->param("title") || "Without title";
    my $i_description = $c->param("description") || undef;
    my $i_fulltext    = $c->param("fulltext") || undef;

    $c->check_uuid( \@errors, "document", $i_document);
    my $document = $c->check_record(\@errors, "documents", "document", $i_document);

    unless (@errors) {

        my $enabled; $i_published eq "on" ? $enabled = 1 : $enabled = 0;

        # Get record
        my $record = $c->Q("
                SELECT id, entity, sitelink, title, description, fulltext,
                    published, created, updated
                FROM plugins_rss.rss
                WHERE entity=? ",
            [ $document->{id} ])->Hash;

        # Update record
        if ($record->{id}) {
            $c->Do("
                UPDATE plugins_rss.rss
                    SET sitelink=?, title=?, description=?, fulltext=?,  published=?,
                        updated=now()
                    WHERE id=?; ",
                [ $i_link, $i_title, $i_description, $i_fulltext, $enabled, $record->{id} ]);
        }

        # Create record
        unless ($record->{id}) {
            $c->Do("
                INSERT
                    INTO plugins_rss.rss (id, entity, sitelink, title, description, fulltext,
                        published, created,  updated)
                    VALUES (?, ?, ?, ?, ?, ?, ?, now(), now()); ",
                [ $c->uuid, $document->{id}, $i_link, $i_title, $i_description, $i_fulltext, $enabled ]);
        }
    }

    $c->smart_render(\@errors);
}

sub filter {
    my $c = shift;

    my $data;
    my @errors;

    unless (@errors) {
        $data = $c->Q(" SELECT id, title FROM plugins_rss.rss_feeds ORDER BY title ")->Hashes;
    }

    unshift @$data, {
        id => "without-rss",
        title => $c->l("Show without RSS")
    };
    unshift @$data, {
        id => "only-rss",
        title => $c->l("Show with RSS")
    };
    unshift @$data, {
        id => "show-all",
        title => $c->l("Show all")
    };


    $c->smart_render(\@errors, \@$data);
}

sub save {
    my $c = shift;

    my @errors;

    my @i_documents = $c->param("documents");

    foreach my $item (@i_documents) {

        my ($id, $sortorder) = split "::", $item;

        unless (@errors) {
            $c->Do(" UPDATE plugins_rss.rss SET priority=? WHERE entity=? ", [ $sortorder, $id ]);
        }
    }

    $c->smart_render(\@errors);
}

sub publish {
    my $c = shift;

    my @errors;

    my @i_ids = $c->param("id");

    foreach my $id (@i_ids) {
        $c->check_uuid( \@errors, "document", $id);
        my $document = $c->check_record(\@errors, "documents", "document", $id);

        next unless ($document->{workgroup} && $c->objectAccess("catalog.documents.rss:*", $document->{workgroup}));

        my $rss = $c->Q(" SELECT * FROM plugins_rss.rss WHERE entity=? ", [ $id ])->Hash;

        next unless $rss;

        $c->Do(" UPDATE plugins_rss.rss SET published=true WHERE entity=? ", [ $id ]);
    }

    $c->smart_render(\@errors);
}

sub unpublish {
    my $c = shift;

    my @errors;

    my @i_ids = $c->param("id");

    foreach my $id (@i_ids) {

        $c->check_uuid( \@errors, "document", $id);
        my $document = $c->check_record(\@errors, "documents", "document", $id);

        next unless ($document->{workgroup} && $c->objectAccess("catalog.documents.rss:*", $document->{workgroup}));

        my $rss = $c->Q(" SELECT * FROM plugins_rss.rss WHERE entity=? ", [ $id ])->Hash;

        next unless $rss;

        $c->Do(" UPDATE plugins_rss.rss SET published=false WHERE entity=? ", [ $id ]);
    }

    $c->smart_render(\@errors);
}


1;
