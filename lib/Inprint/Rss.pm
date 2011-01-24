package Inprint::Rss;

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

1;
