package Inprint::Fascicle::Composer;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Fascicle::Events;

use base 'Mojolicious::Controller';

sub initialize {

    my $c = shift;

    my @i_pages    = $c->param("page");

    my $data;
    my @errors;
    my $success = $c->json->false;

    unless (@errors) {

        my @pages;

        $data->{pages} = $c->Q("
            SELECT id, w, h, seqnum
            FROM fascicles_pages
            WHERE id = ANY(?)
            ORDER BY seqnum ASC
        ", [ \@i_pages ])->Hashes;

        $data->{modules} = $c->Q("
            SELECT maps.id, modules.title, modules.w, modules.h, maps.page, maps.x, maps.y
            FROM fascicles_modules modules, fascicles_map_modules maps
            WHERE 1=1
                AND maps.module=modules.id
                AND page=ANY(?)
        ", [ \@i_pages ])->Hashes;

    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $data });
}

sub save {

    my $c = shift;

    my @errors;

    my @i_modules  = $c->param("modules");
    my $i_fascicle = $c->get_uuid(\@errors, "fascicle");

    my $fascicle = $c->Q(" SELECT * FROM fascicles WHERE id =? ", $i_fascicle )->Hash;
    push @errors, { id => "fascicle", msg => "Incorrectly filled field"} unless $fascicle;

    unless (@errors) {

        $c->sql->bt;
        foreach my $string (@i_modules) {

            my ($map_id, $to_page_id, $x, $y, $w, $h) = split "::", $string;

            my $placed = 1;

            my $mapping = $c->Q("
                    SELECT *
                    FROM fascicles_map_modules
                    WHERE id=? ",
                [ $map_id ])->Hash;

            next unless ($mapping->{id});

            my $module = $c->Q("
                    SELECT *
                    FROM fascicles_modules
                    WHERE id=? ",
                [ $mapping->{module} ])->Hash;

            next unless ($module->{id});

            my $to_page = $c->Q("
                SELECT *
                FROM fascicles_pages
                WHERE id=? ",
                [ $to_page_id ])->Hash;

            next unless ($to_page->{id});

            next if ($to_page->{edition}  ne $module->{edition});
            next if ($to_page->{fascicle} ne $module->{fascicle});

            $c->Do("
                UPDATE fascicles_map_modules SET page=?, placed=?, x=?, y=? WHERE id=? ",
                [ $to_page->{id}, $placed, $x, $y, $mapping->{id} ]);

        }

        # Create event
        Inprint::Fascicle::Events::onCompositionChanged($c, $fascicle);

        $c->sql->et;
    }

    $c->smart_render( \@errors );
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
        $templates = $c->Q(" SELECT DISTINCT origin FROM fascicles_pages WHERE id= ANY(?) ", [ \@i_pages ])->Values;
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
                    t2.id as id,
                    t1.origin, t1.fascicle, t1.page, t1.title, t1.description,
                    t1.amount, round(t1.area::numeric, 2) as area, t1.x, t1.y, t1.w, t1.h,
                    t3.id as place, t3.title as place_title,
                    t1.created, t1.updated
                FROM fascicles_tmpl_modules t1, fascicles_tmpl_index t2, fascicles_tmpl_places t3
                WHERE
                    t1.page=?
                    AND t1.amount=?
                    AND t2.entity = t1.id AND t2.place = t3.id
                ";
            push @params, $tmpl_id;
            push @params, $amount;
        }

        $sql = join "\n INTERSECT \n", @queries;

    }

    unless (@errors) {
        $result = $c->Q(" $sql ", \@params)->Hashes;
        $c->render_json( { data => $result } );
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub modules {

    my $c = shift;

    my @result;
    my @errors;

    my $success = $c->json->false;

    my $i_filter = $c->param("filter");
    my @i_pages  = $c->param("page");

    my @filter = split /,\s+/, $i_filter;

    my $sql;
    my @params;
    my @pages;

    unless (@errors) {

        foreach my $code (@i_pages) {
            my ($page_id, $seqnum) = split '::', $code;
            my $page = $c->Q("
                SELECT id, edition, fascicle, origin, headline, seqnum, w, h, created, updated
                FROM fascicles_pages WHERE id=? AND seqnum=?
            ", [ $page_id, $seqnum ])->Hash;
            next unless $page->{id};
            push @pages, $page->{id};
        }

        $sql = "
            SELECT DISTINCT
                maps.id as mapping,
                modules.id as module,
                modules.title,
                modules.description,
                modules.amount,
                modules.area,
                modules.created,
                modules.updated,
                requests.shortcut as request_shortcut,
                places.id as place,
                places.title as place_title,
                (
                    SELECT count(*)
                    FROM fascicles_map_modules
                    WHERE 1=1
                        AND module = modules.id ) as mapcount,
                (
                    SELECT count(*)
                    FROM fascicles_requests
                    WHERE 1=1
                        AND module = modules.id ) as modcount
            FROM
                fascicles_modules modules
                    LEFT JOIN fascicles_tmpl_places places ON ( modules.place = places.id )
                    LEFT OUTER JOIN fascicles_requests requests ON ( modules.id = requests.module ),
                fascicles_map_modules maps
            WHERE 1=1
                AND maps.module = modules.id
                AND maps.page = ANY(?)
        ";

        push @params, \@pages;

    }

    unless (@errors) {

        my $nodes = $c->Q($sql, \@params)->Hashes;

        foreach my $node (@{ $nodes }) {

            if ("unmapped" ~~ @filter) {
                #next if ($node->{mapcount} > 0);
            }

            if ("mapped" ~~ @filter) {
                #next if ($node->{mapcount} == 0);
            }

            if ("unrequested" ~~ @filter) {
                next if ($node->{modcount} > 0);
            }

            if ("requested" ~~ @filter) {
                next if ($node->{modcount} == 0);
            }

            $node->{id} = $c->uuid;

            $node->{leaf} = $c->json->true;
            $node->{icon} = "/icons/table-medium.png";

            $node->{page} = $c->Q("
                SELECT page FROM fascicles_map_modules WHERE module=?",
                [ $node->{module} ])->Value;

            if ($node->{mapcount} > 1) {

                $node->{leaf} = $c->json->false;
                $node->{expanded} = $c->json->true;
                $node->{icon} = "/icons/tables.png";

                my $sql_childrens = "
                    SELECT
                        maps.id as mapping,
                        modules.id as module,
                        modules.title,
                        modules.description,
                        modules.amount,
                        maps.page,
                        pages.id as place,
                        pages.seqnum as place_title
                    FROM
                        fascicles_modules modules,
                        fascicles_map_modules maps,
                        fascicles_pages pages
                    WHERE
                        modules.id=?
                        AND maps.page = pages.id
                        AND maps.page = ANY(?)
                        AND maps.module = modules.id
                ";

                $node->{children} = $c->Q($sql_childrens, [ $node->{module}, \@pages ])->Hashes;

                foreach my $subnode (@{ $node->{children} }) {
                    $subnode->{id} = $c->uuid;
                    $subnode->{leaf} = $c->json->true;
                    $subnode->{icon} = "/icons/table-medium.png";
                    $subnode->{amount} = "";
                }

            }

            $node->{shortcut} = $node->{edition_shortcut} ."/". $node->{shortcut};

            push @result, $node;

        }
    }

    $c->render_json( \@result );

}

1;
