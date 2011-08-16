package Inprint::Calendar::Template;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Fascicle;

use base 'Mojolicious::Controller';

sub list {
    my $c = shift;

    my @params;
    my @errors;
    my $result = [];

    my $i_edition = $c->get_uuid(\@errors, "edition");

    unless (@errors) {

        # Common sql
        my $sql = "
            SELECT

                t1.id,
                t2.id as edition, t2.shortcut as edition_shortcut,
                t1.parent, t1.fastype, t1.variation,
                t1.shortcut, t1.description,
                t1.tmpl, t1.tmpl_shortcut,
                t1.circulation, t1.num, t1.anum,
                t1.manager,
                t1.enabled, t1.archived,
                t1.doc_enabled, t1.adv_enabled,

                to_char(t1.doc_date, 'YYYY-MM-DD HH24:MI:SS')     as doc_date,
                to_char(t1.adv_date, 'YYYY-MM-DD HH24:MI:SS')     as adv_date,
                to_char(t1.print_date, 'YYYY-MM-DD HH24:MI:SS')   as print_date,
                to_char(t1.release_date, 'YYYY-MM-DD HH24:MI:SS') as release_date,

                to_char(t1.created, 'YYYY-MM-DD HH24:MI:SS') as created,
                to_char(t1.updated, 'YYYY-MM-DD HH24:MI:SS') as updated

            FROM fascicles t1, editions t2

            WHERE 1=1
                AND t2.id=t1.edition
                AND t1.deleted = false
                --AND t1.fastype = 'template'
                AND t1.edition = ANY(?)

            ORDER BY t1.shortcut DESC
        ";

        my $children  = $c->objectChildren("editions", $i_edition, "editions.template.manage:*");

        push @params, $children;

        $result = $c->Q($sql, \@params)->Hashes;

    }

    $c->smart_render(\@errors, $result);
}

1;
