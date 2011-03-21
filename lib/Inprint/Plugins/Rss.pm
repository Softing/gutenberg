package Inprint::Plugins::Rss;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use HTML::Scrubber;

use Inprint::Store::Embedded;

use base 'Inprint::BaseController';

sub feeds {
    my $c = shift;

    my $feeds = $c->sql->Q("
        SELECT id, url, title, description, published, created, updated
        FROM rss_feeds
        ")->Hashes;

    my $html;

    $html .= '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">';
    $html .= '<html xml:lang="en" lang="en" xmlns="http://www.w3.org/1999/xhtml">';
    $html .= '<head>';
    $html .= '<meta http-equiv="content-type" content="text/html; charset=UTF-8" />';
    $html .= '</head>';
    $html .= '<body>';
    $html .= '<h1>RSS Feeds</h1>';
    $html .= "<ul>";
    foreach (@$feeds) {
        $html .= "<li><a href=\"$$_{url}.xml\">$$_{url}.xml</li>";
    }
    $html .= "</ul>";
    $html .= '</body>';
    $html .= '</html>';

    $c->render(inline => $html);
}

sub feed {

    my $c = shift;

    my $i_feed = $c->param("feed");

    my $siteurl = $c->config->get("public.url");

    my $feed = $c->sql->Q("
        SELECT id, url, title, description, published, created, updated
        FROM rss_feeds WHERE url=?
        ", [ $i_feed ])->Hash;

    $c->render(status => 404) unless $feed->{id};

    my $index = $c->sql->Q("
            SELECT tag, nature
            FROM rss_feeds_mapping t1
            WHERE feed=?
        ", [ $feed->{id} ])->Hashes;

    $c->render(status => 404) unless @$index;

    my @editions, my @headlines, my @rubrics;
    foreach my $item (@$index) {
        push @editions,  $item->{tag} if ($item->{nature} eq "edition");
        push @headlines, $item->{tag} if ($item->{nature} eq "headline");
        push @rubrics,   $item->{tag} if ($item->{nature} eq "rubric");
    }

    unless ( @headlines ) {
        unless ( @rubrics ) {
            $c->render(status => 404);
        }
    }

    my $rss_feed;

    my $feed_url = $siteurl . "/plugin/rss/feeds/". $feed->{url} .".xml";

    $rss_feed .= "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
    $rss_feed .= "<rss version=\"2.0\" xmlns:atom=\"http://www.w3.org/2005/Atom\" xmlns:media=\"http://search.yahoo.com/mrss/\" xmlns:blogChannel=\"http://backend.userland.com/blogChannelModule\" xmlns:content=\"http://purl.org/rss/1.0/modules/content/\">";
    $rss_feed .= "<channel>";
    $rss_feed .= "<link>$siteurl</link>";
    $rss_feed .= "<title>". $feed->{title} ."</title>";
    $rss_feed .= "<atom:link href=\"$feed_url\" rel=\"self\" type=\"application/rss+xml\" />";
    $rss_feed .= "<description>". $feed->{description} ."</description>";

    my @params; my $sql = "
        SELECT
            t1.id, t1.document, t1.link, t1.title, t1.description, t1.fulltext, t1.published, t1.created,
            to_char(t1.updated, 'Dy, DD Mon YYYY HH:MI:SS +0300') as updated,
            t2.headline, t2, rubric, t2.author
        FROM rss t1, documents t2
        WHERE t2.id = t1.document
    ";

    my @filters;

    if (@editions) {
        push @filters, " t2.edition = ANY(?) ";
        push @params, \@editions;
    }

    if (@headlines) {
        push @filters, " t2.headline = ANY(?) ";
        push @params, \@headlines;
    }

    if (@rubrics) {
        push @filters, " t2.rubric = ANY(?) ";
        push @params, \@rubrics;
    }

    if (@filters) {
        $sql .= " AND ( ". join(" OR ", @filters) ." ) ";
    }

    my $rss_data = $c->sql->Q($sql, \@params)->Hashes;

    foreach my $item (@$rss_data) {

        my $guid = $item->{url} || $item->{id};

        $rss_feed .= "<item>";

            $rss_feed .= "<title>". $item->{title} ."</title>";
            $rss_feed .= "<link>".  $siteurl ."/". $guid ."</link>";
            $rss_feed .= "<guid>".  $siteurl ."/". $guid ."</guid>";

            $rss_feed .= "<description><![CDATA[". $item->{description} ."]]></description>" if $item->{description};
            $rss_feed .= "<pubDate>". $item->{updated} ."</pubDate>" if $item->{updated};
            $rss_feed .= "<author>".  $item->{author} ."</author>" if $item->{author};

            my $scrubber = HTML::Scrubber->new( allow => [ qw[ p b i u hr br ] ] );
            my $fulltext = $scrubber->scrub($item->{fulltext});
            $rss_feed .= "<content:encoded><![CDATA[$fulltext]]></content:encoded>";

            my $folder = Inprint::Store::Embedded::getFolderPath($c, "rss-plugin", $item->{created}, $item->{id}, 1);
            Inprint::Store::Embedded::updateCache($c, $folder);
            my $files = Inprint::Store::Cache::getRecordsByPath($c, $folder, "all", ['png', 'jpg', 'jpeg', 'gif']);

            foreach my $file (@$files) {

                my $fileurl  = "$siteurl/files/download/". $file->{id} .".". $file->{extension};
                my $filemime = $file->{mime};
                my $filedesc = $file->{description};

                $rss_feed .= "<media:content url=\"$fileurl\" type=\"$filemime\" expression=\"full\">";
                if ($filedesc) {
                    $rss_feed .= "<media:description type=\"plain\"><![CDATA[$filedesc]]></media:description>";
                }
                $rss_feed .= "</media:content>";

            }

        $rss_feed .= "</item>";

    }

    $rss_feed .= "</channel>";
    $rss_feed .= "</rss>";

    $c->render(text => $rss_feed, format => 'xml');
}

1;
