package Inprint::Template;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Fascicle::Utils;

use base 'Mojolicious::Controller';

sub seance {

    my $c = shift;

    my @errors;
    my $access   = {};
    my $pages    = [];

    my $i_template = $c->get_uuid(\@errors, "fascicle");
    my $c_member   = $c->getSessionValue("member.id");

    my $fascicle = $c->check_record(\@errors, "template", "template", $i_template);

    unless (@errors) {
        $pages     = $c->getPages($i_template);
        $access = {
            manage  => $c->json->true
        };
    }

    $c->render_json({
        success  => $c->json->true,
        errors   => \@errors,
        access   => $access   || {},
        fascicle => $fascicle || {},
        pages    => [ $pages ]
    });

}

sub getPages {

    my $c = shift;
    my $fascicle = shift;

    return unless $fascicle;

    my $data = {};

    my $idcounter = 1;
    my $index;

    my @pageorder;

    my $pages;
    my $dbpages = $c->Q("
        SELECT
            t1.id, t1.seqnum, t1.width as w, t1.height as h,
            t2.id as headline, t2.title as headline_shortcut
        FROM
            template_page t1
            LEFT JOIN indx_headlines as t2 ON t2.id=t1.headline
        WHERE t1.template=?
        ORDER BY t1.seqnum ",
        [ $fascicle ])->Hashes;

    foreach my $item (@$dbpages) {

        $index->{$item->{id}} = $idcounter++;

        my ($trash, $headline) = split /\//, $item->{headline_shortcut};

        $pages->{$index->{$item->{id}}} = {
            id => $item->{id},
            num => $item->{seqnum},
            headline => $headline || $item->{headline_shortcut}
        };

        push @pageorder, $index->{$item->{id}};
    }

    my $documents = {};
    my $doccount = 0;
    my $dbdocuments = $c->Q("
        SELECT DISTINCT t2.edition, t2.fascicle, t2.id, t2.title
        FROM fascicles_map_documents t1, documents t2
        WHERE t2.id = t1.entity AND t1.fascicle = ?
    ", [ $fascicle ])->Hashes;

    foreach my $item (@$dbdocuments) {

        $index->{$item->{id}} = $idcounter++;

        $documents->{$index->{$item->{id}}} = {
            id => $item->{id},
            title => $item->{title}
        };

        my $docpages = $c->Q("
            SELECT t2.id
            FROM fascicles_map_documents t1, fascicles_pages t2
            WHERE t2.id = t1.page AND t1.fascicle = ? AND entity = ?
        ", [ $fascicle, $item->{id} ])->Values;

        foreach my $pageid (@$docpages) {
            my $pageindex = $index->{$pageid};
            if ($pageindex) {
                push @{ $pages->{$pageindex}->{documents} }, $index->{$item->{id}};
            }
        }
    }

    my $holes;

    my $dbholes = $c->Q("
        SELECT t1.id, t1.title, t1.w, t1.h, t2.page, t2.x, t2.y
        FROM fascicles_modules t1, fascicles_map_modules t2
        WHERE t1.fascicle = ? AND t2.module=t1.id AND t2.placed=false
    ", [ $fascicle ])->Hashes;

    foreach my $item (@$dbholes) {
        $index->{$item->{id}} = $idcounter++;

        $holes->{$index->{$item->{id}}} = {
            id => $item->{id},
            title => $item->{title}
        };

        my $pageindex = $index->{$item->{page}};
        if ($pageindex) {
            push @{ $pages->{$pageindex}->{holes} }, $index->{$item->{id}};
        }
    }

    my $requests;

    my $dbrequests = $c->Q("
        SELECT t1.id, t1.shortcut, t2.page
        FROM fascicles_requests t1, fascicles_map_modules t2
        WHERE t1.fascicle = ? AND t1.module=t2.module AND t2.placed=false
    ", [ $fascicle ])->Hashes;

    foreach my $item (@$dbrequests) {

        $index->{$item->{id}} = $idcounter++;

        $requests->{$index->{$item->{id}}} = {
            id => $item->{id},
            title => $item->{shortcut}
        };

        my $pageindex = $index->{$item->{page}};

        if ($pageindex) {
            push @{ $pages->{$pageindex}->{requests} }, $index->{$item->{id}};
        }

    }

    $data->{pages}      = $pages;
    $data->{documents}  = $documents;
    $data->{holes}      = $holes;
    $data->{requests}   = $requests;
    $data->{pageorder}  = \@pageorder;

    return $data ;
}

1;
