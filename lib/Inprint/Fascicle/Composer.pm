package Inprint::Fascicle::Composer;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Utils::Pages;

use base 'Inprint::BaseController';

sub initialize {

    my $c = shift;

    my @i_pages    = $c->param("page");

    my $data;
    my @errors;
    my $success = $c->json->false;

    unless (@errors) {

        my @pages;

        $data->{pages} = $c->sql->Q("
            SELECT id, w, h, seqnum
            FROM fascicles_pages WHERE id = ANY(?) ORDER BY seqnum ASC
        ", [ \@i_pages ])->Hashes;

        $data->{modules} = $c->sql->Q("
            SELECT t1.id, t1.title, t1.w, t1.h, t2.page, t2.x, t2.y
            FROM fascicles_modules t1, fascicles_map_modules t2
            WHERE page=ANY(?) AND t2.module=t1.id
        ", [ \@i_pages ])->Hashes;

    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $data });
}

sub save {

    my $c = shift;

    my @i_modules  = $c->param("modules");

    my @errors;
    my $success = $c->json->false;

    unless (@errors) {

        foreach my $string (@i_modules) {

            my ($pageid, $moduleid, $x, $y, $w, $h) = split "::", $string;

            my $placed = 1;

            $c->sql->Do("
                UPDATE fascicles_map_modules SET placed=?, x=?, y=? WHERE page=? AND module=? ",
                [ $placed, $x, $y, $pageid, $moduleid ]);

        }

    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub templates {
    my $c = shift;

    my @i_pages = $c->param("page");

    my $amount = $#i_pages+1;

    my $result = [];

    my @errors;
    my $success = $c->json->false;

    foreach (@i_pages) {
        push @errors, { id => "page", msg => "Incorrectly filled field"}
            unless ($c->is_uuid($_));
    }

    # Get templates from pages
    my $templates; unless (@errors) {
        $templates = $c->sql->Q(" SELECT DISTINCT origin FROM fascicles_pages WHERE id= ANY(?) ", [ \@i_pages ])->Values;
        push @errors, { id => "page", msg => "Can't find object!"}
            unless (@$templates);
    }

    my $sql;
    my @queries;
    my @params;

    unless (@errors) {

        foreach my $tmpl_id (@$templates) {

            push @queries, "
                SELECT
                    t1.id, t1.origin, t1.fascicle, t1.page, t1.title, t1.description,
                    t1.amount, round(t1.area::numeric, 2) as area, t1.x, t1.y, t1.w, t1.h,
                    t3.title as place_title,
                    t1.created, t1.updated
                FROM fascicles_tmpl_modules t1, fascicles_tmpl_index t2, fascicles_tmpl_places t3
                WHERE
                    t1.page=? AND t1.amount=?
                    AND t2.entity = t1.id AND t2.place = t3.id
                ";
            push @params, $tmpl_id;
            push @params, $amount;
        }

        $sql = join "\n INTERSECT \n", @queries;

    }

    unless (@errors) {
        $result = $c->sql->Q(" $sql ", \@params)->Hashes;
        $c->render_json( { data => $result } );
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub modules {
    my $c = shift;

    my @i_pages    = $c->param("page");

    my $result = [];

    my @errors;
    my $success = $c->json->false;

    my $sql;
    my @params;
    my @pages;

    unless (@errors) {

        foreach my $code (@i_pages) {
            my ($page_id, $seqnum) = split '::', $code;
            my $page = $c->sql->Q("
                SELECT id, edition, fascicle, origin, headline, seqnum, w, h, created, updated
                FROM fascicles_pages WHERE id=? AND seqnum=?
            ", [ $page_id, $seqnum ])->Hash;
            next unless $page->{id};
            push @pages, $page->{id};
        }

        $sql = "
            SELECT DISTINCT
                t1.id as module, t1.title,
                t1.description, t1.amount, t1.area, t1.created, t1.updated,
                t3.id as place, t3.title as place_title,
                ( SELECT count(*) FROM fascicles_map_modules WHERE module=t1.id ) as count
            FROM
                fascicles_modules t1
                    LEFT JOIN fascicles_tmpl_places t3 ON ( t1.place = t3.id ),
                fascicles_map_modules t2
            WHERE t2.module=t1.id AND t2.page = ANY(?)
        ";

        push @params, \@pages;

    }

    unless (@errors) {

        $result = $c->sql->Q(" $sql ", \@params)->Hashes;

        foreach my $node (@{ $result }) {

            $node->{id} = $c->uuid;

            $node->{leaf} = $c->json->true;
            $node->{icon} = "/icons/table-medium.png";

            $node->{page} = $c->sql->Q("
                SELECT page FROM fascicles_map_modules WHERE module=?",
                [ $node->{module} ])->Value;

            if ($node->{count} > 1) {

                $node->{leaf} = $c->json->false;
                $node->{expanded} = $c->json->true;
                $node->{icon} = "/icons/tables.png";

                my $sql_childrens = "
                    SELECT
                        t1.id as module, t1.title, t1.description, t1.amount,
                        t2.page, t3.id as place, t3.seqnum as place_title
                    FROM
                        fascicles_modules t1,
                        fascicles_map_modules t2,
                        fascicles_pages t3
                    WHERE
                        t1.id=?
                        AND t2.module=t1.id
                        AND t2.page=t3.id
                        AND t2.page=ANY(?)
                ";

                $node->{children} = $c->sql->Q($sql_childrens, [ $node->{module}, \@pages ])->Hashes;
                foreach my $subnode (@{ $node->{children} }) {
                    $subnode->{id} = $c->uuid;
                    $subnode->{leaf} = $c->json->true;
                    $subnode->{icon} = "/icons/table-medium.png";
                    $subnode->{amount} = "";
                }

            }

            $node->{shortcut} = $node->{edition_shortcut} ."/". $node->{shortcut};

        }
    }

    $c->render_json( $result );

}


1;
