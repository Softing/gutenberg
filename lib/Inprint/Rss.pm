package Inprint::Rss;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Rss;

use base 'Inprint::BaseController';

sub feed {

    my $c = shift;

    my $i_feed = $c->param("feed");

    my $feed = $c->sql->Q("
        SELECT id, url, title, description, published, created, updated
        FROM rss_feeds WHERE published = true AND url=?
        ", [ $i_feed ])->Hash;

    $c->render(status => 404) unless $feed->{id};

    #my $rubrics = $c->sql->Q("
    #    SELECT id, feed, rubric
    #    FROM rss_feeds_mapping t1,
    #    ", [ $i_feed ])->Hashes;

    my $rss_feed;
    $rss_feed .= "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
    $rss_feed .= "<rss version=\"2.0\" xmlns:atom=\"http://www.w3.org/2005/Atom\" xmlns:media=\"http://search.yahoo.com/mrss/\" xmlns:blogChannel=\"http://backend.userland.com/blogChannelModule\" xmlns:content=\"http://purl.org/rss/1.0/modules/content/\">";
    $rss_feed .= "<channel>";
    $rss_feed .= "<title>". $feed->{title} ."</title>";
    $rss_feed .= "<link>http://kp.ru/daily/economics/</link>";
    $rss_feed .= "<atom:link href=\"http://kp.ru/rss/ipad-economics-kd.xml\" rel=\"self\" type=\"application/rss+xml\" />";
    $rss_feed .= "<description>". $feed->{description} ."</description>";

    my $rss_data = $c->sql->Q("
        SELECT t1.id, t1.document, t1.link, t1.title, t1.description, t1.fulltext, t1.published, t1.created, t1.updated
        FROM rss t1, documents t2 WHERE t2.id=t1.document
    ", [ ])->Hashes;

    foreach my $item (@$rss_data) {

        $rss_feed .= "<item>";
            $rss_feed .= "<title>". $item->{title} ."</title>";
            $rss_feed .= "<link>".  $item->{url} ."</link>";
            $rss_feed .= "<guid>".  $item->{url} ."</guid>";
            $rss_feed .= "<description>". $item->{description} ."</description>";
            $rss_feed .= "<category>Экономика</category>";
            $rss_feed .= "<pubDate>Sun, 28 Nov 2010 12:50:00 +0300</pubDate>";
            $rss_feed .= "<author>Нигина БЕРОЕВА</author>";
            $rss_feed .= "<content:encoded><![CDATA[]]></content:encoded>";
            $rss_feed .= "<media:content url=\"http://kp.ru/f/12/image/49/22/2072249.jpg\" type=\"image/jpeg\" expression=\"full\">";
            $rss_feed .= "<media:description type=\"plain\">У Владимира Путина скоро будет новый холодильник</media:description>";
            $rss_feed .= "</media:content>";
        $rss_feed .= "</item>";

    }

    $rss_feed .= "</channel>";
    $rss_feed .= "</rss>";

    #$rss_feed =~ s/\s+/ /g;

    $c->render(text => $rss_feed, format => 'rss');
}

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
            WHERE 1=1
        ";

    # Total query
    my $sql_total = "
        SELECT count(*)
        FROM documents dcm LEFT JOIN rss ON dcm.id = rss.document
        WHERE 1=1
    ";

    # Filters

    if ($i_filter eq "true") {
        $sql_query .= " AND rss.id is not null";
        $sql_total .= " AND rss.id is not null";
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
        $item->{access} = {};
        if ($item->{workgroup} && $c->access->Check("catalog.documents.rss:*", $item->{workgroup})) {
            $item->{access}->{rss} = $c->json->true;
        }
    }

    $c->render_json( { "data" => $result, "total" => $total } );
}

sub files {
    my $c = shift;
    $c->render_json({});
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
        if ($document->{workgroup} && $c->access->Check("catalog.documents.rss:*", $document->{workgroup})) {
            $result->{access}->{rss} = $c->json->true;
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
