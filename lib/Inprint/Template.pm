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
        SELECT
            t1.id, t1.title, t1.w, t1.h, t2.page, t2.x, t2.y
        FROM
            template_module t1,
            template_map_module t2
        WHERE 1=1
            AND t1.template = ?
            AND t2.module=t1.id
            AND t2.placed=false
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

    #my $requests;
    #
    #my $dbrequests = $c->Q("
    #    SELECT t1.id, t1.shortcut, t2.page
    #    FROM fascicles_requests t1, fascicles_map_modules t2
    #    WHERE t1.fascicle = ? AND t1.module=t2.module AND t2.placed=false
    #", [ $fascicle ])->Hashes;
    #
    #foreach my $item (@$dbrequests) {
    #
    #    $index->{$item->{id}} = $idcounter++;
    #
    #    $requests->{$index->{$item->{id}}} = {
    #        id => $item->{id},
    #        title => $item->{shortcut}
    #    };
    #
    #    my $pageindex = $index->{$item->{page}};
    #
    #    if ($pageindex) {
    #        push @{ $pages->{$pageindex}->{requests} }, $index->{$item->{id}};
    #    }
    #
    #}

    $data->{pages}      = $pages;
    $data->{documents}  = $documents;
    $data->{holes}      = $holes;
    $data->{requests}   = [];
    $data->{pageorder}  = \@pageorder;

    return $data ;
}

sub composer_init {
    my $c = shift;

    my @errors;

    my @i_pages    = $c->param("page");

    my $data;

    unless (@errors) {

        my @pages;

        $data->{pages} = $c->Q("
            SELECT id, width as w, height as h, seqnum
            FROM template_page WHERE id = ANY(?)
            ORDER BY seqnum ASC
        ", [ \@i_pages ])->Hashes;

        $data->{modules} = $c->Q("
            SELECT
                t1.id, t1.title, t1.w, t1.h, t2.page, t2.x, t2.y
            FROM
                template_module t1,
                template_map_module t2
            WHERE 1=1
                AND page=ANY(?)
                AND t2.module=t1.id
        ", [ \@i_pages ])->Hashes;

    }

    $c->smart_render(\@errors, $data);
}

sub composer_save {
    my $c = shift;

    my @i_modules  = $c->param("modules");

    my @errors;

    unless (@errors) {

        foreach my $string (@i_modules) {

            my ($id, $oldpage, $newpage, $x, $y, $w, $h) = split "::", $string;

            my $placed = 1;

            my $mapping = $c->Q("
                SELECT * FROM template_map_module WHERE page=? AND module=? ",
                [ $oldpage, $id ])->Hash;

            next unless $mapping->{id};

            $c->Do("
                UPDATE template_map_module SET page=?, placed=?, x=?, y=? WHERE id=? ",
                [ $newpage, $placed, $x, $y, $mapping->{id} ]);
        }
    }

    $c->smart_render( \@errors );
}

sub module_list {
    my $c = shift;

    my @errors;
    my $result = [];

    my @i_pages    = $c->param("page");

    my $sql;
    my @params;
    my @pages;

    unless (@errors) {

        foreach my $code (@i_pages) {
            my ($page_id, $seqnum) = split '::', $code;
            my $page = $c->Q("
                SELECT id, edition, template, origin, headline, seqnum, width as w, height as h, created, updated
                FROM template_page WHERE id=? AND seqnum=?
            ", [ $page_id, $seqnum ])->Hash;
            next unless $page->{id};
            push @pages, $page->{id};
        }

        $sql = "
            SELECT DISTINCT
                t1.id as module, t1.title,
                t1.description, t1.amount, t1.area, t1.created, t1.updated,
                t3.id as place, t3.title as place_title,
                ( SELECT count(*) FROM template_map_module WHERE module=t1.id ) as count
            FROM
                template_module t1
                    LEFT JOIN ad_places t3 ON ( t1.place = t3.id ),
                template_map_module t2
            WHERE t2.module=t1.id AND t2.page = ANY(?)
        ";

        push @params, \@pages;

    }

    unless (@errors) {

        $result = $c->Q(" $sql ", \@params)->Hashes;

        foreach my $node (@{ $result }) {

            $node->{id} = $c->uuid;

            $node->{leaf} = $c->json->true;
            $node->{icon} = "/icons/table-medium.png";

            $node->{page} = $c->Q("
                SELECT page FROM template_map_module WHERE module=?",
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
                        template_module t1,
                        template_map_module t2,
                        template_pages t3
                    WHERE
                        t1.id=?
                        AND t2.module=t1.id
                        AND t2.page=t3.id
                        AND t2.page=ANY(?)
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

        }
    }

    #$c->smart_render(\@errors, $result);
    $c->render_json( $result );
}

sub module_create {
    my $c = shift;

    my @errors;
    my $id = $c->uuid();

    my $i_fascicle    = $c->param("fascicle");
    my @i_mapping     = $c->param("templates");
    my @i_pages       = $c->param("pages");

    #push @errors, { id => "access", msg => "Not enough permissions <domain.roles.manage>"}
    #    unless ($c->objectAccess("domain.roles.manage"));

    my $fascicle   = $c->check_record(\@errors, "template", "template", $i_fascicle);

    $c->fail_render(\@errors);

    # Find modules by mapping;
    my @modules;
    foreach my $map (@i_mapping) {
        my $module = $c->Q("
            SELECT
                t1.id,
                t2.place as place,
                t1.edition, t1.page,
                t1.title, t1.description,
                t1.amount, t1.area,
                t1.x, t1.y, t1.w, t1.h,
                t1.width, t1.height, t1.fwidth, t1.fheight,
                t1.created, t1.updated
            FROM ad_modules t1, ad_index t2
            WHERE t1.id=t2.entity AND t2.id=?
        ", [ $map ])->Hash;
        next unless $module->{id};
        push @modules, $module;
    }

    push @errors, { id => "page", msg => "Modules not equal $#i_mapping"}
        unless ($#modules == $#i_mapping);

    $c->fail_render(\@errors);

    # Find pages
    my @pages;
    foreach my $code (@i_pages) {

        my ($page_id, $seqnum) = split '::', $code;

        my $page = $c->Q("
            SELECT id, edition, headline, seqnum, width as w, height as h, created, updated
            FROM template_page WHERE id=? AND seqnum=?
        ", [ $page_id, $seqnum ])->Hash;

        next unless $page->{id};
        push @pages, $page;
    }

    push @errors, { id => "page", msg => "Pages not equal $#i_pages"}
        unless ($#pages == $#i_pages);

    $c->fail_render(\@errors);

    foreach my $module (@modules) {

        unless (@errors) {

            my $module_id = $c->uuid;

            $c->Do("
                INSERT INTO template_module
                    (
                        id, edition, template, place, origin,
                        title, description,
                        amount, area,
                        w, h,
                        width, height, fwidth, fheight,
                        created, updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now());
            ", [
                $module_id, $fascicle->{edition}, $fascicle->{id},
                $module->{place},
                $module->{id}, $module->{title}, $module->{description},
                $module->{amount}, $module->{area},
                $module->{w}, $module->{h},
                $module->{width}, $module->{height}, $module->{fwidth}, $module->{fheight}
            ]);

            foreach my $page (@pages) {
                $c->Do("
                    INSERT INTO template_map_module(edition, template, module, page, placed, x, y, created, updated)
                    VALUES (?, ?, ?, ?, ?, ?, ?, now(), now());
                ", [
                    $fascicle->{edition}, $fascicle->{id}, $module_id, $page->{id}, 0, "1/1", "1/1"
                ]);
            }
        }

    }

    $c->smart_render(\@errors);
}

sub module_delete {
    my $c = shift;

    my @errors;

    my @ids = $c->param("id");

    unless (@errors) {
        foreach my $id (@ids) {

            my $module;

            if ($c->is_uuid($id)) {
                $module = $c->Q(" SELECT * FROM template_module WHERE id=? ", [ $id ])->Hash;
            }

            if ($module->{id}) {
                $c->Do(" DELETE FROM template_module WHERE id=? ", [ $module->{id} ]);
                $c->Do(" DELETE FROM template_map_module WHERE module=? ", [ $module->{id} ]);
            }

        }
    }

    $c->smart_render(\@errors);
}

sub template_list {
    my $c = shift;

    my @errors;
    my $result = [];

    my @i_pages = $c->param("page");
    my $amount = $#i_pages+1;

    foreach (@i_pages) {
        push @errors, { id => "page", msg => "Incorrectly filled field"}
            unless ($c->is_uuid($_));
    }

    # Get templates from pages
    my $templates;
    unless (@errors) {

        $templates = $c->Q("
            SELECT DISTINCT origin
            FROM template_page
            WHERE id= ANY(?) ",
        [ \@i_pages ])->Hashes;

        push @errors, { id => "page", msg => "Can't find object!"}
            unless (@$templates);

    }

    my $sql;
    my @queries;
    my @params;

    unless (@errors) {

        foreach my $template (@$templates) {

            push @queries, "
                SELECT
                    t2.id as id,
                    t1.edition,
                    t1.page,
                    t1.title,
                    t1.description,
                    t1.amount,
                    round(t1.area::numeric, 2) as area,
                    t1.x,
                    t1.y,
                    t1.w,
                    t1.h,
                    t3.id as place,
                    t3.title as place_title,
                    t1.created, t1.updated
                FROM
                    ad_modules t1,
                    ad_index t2,
                    ad_places t3
                WHERE
                    t1.page=?
                    AND t1.amount=?
                    AND t2.entity = t1.id AND t2.place = t3.id
                ORDER BY place_title, title
                ";
            push @params, $template->{origin};
            push @params, $amount;
        }

        $sql = join "\n INTERSECT \n", @queries;

    }

    unless (@errors) {
        $result = $c->Q(" $sql ", \@params)->Hashes;
        $c->render_json( { data => $result } );
    }

    $c->smart_render(\@errors, $result);
}

1;
