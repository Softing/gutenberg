package Inprint::Models::Fascicle::Request;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

sub search {

    my ($c, $filter, $sorting, $pagination) = @_;

    my @params;

    # Query headers
    my $sql_query = "
        SELECT
            rq.id, rq.serialnum, rq.edition, rq.fascicle,
            rq.advertiser, rq.advertiser_shortcut,
            rq.place, rq.place_shortcut,
            rq.manager, rq.manager_shortcut,
            rq.origin, rq.origin_shortcut, rq.origin_area,
            rq.origin_x, rq.origin_y, rq.origin_w, rq.origin_h,

            t2.id as module, t2.title as module_shortcut,

            rq.pages, rq.firstpage,

            rq.amount, rq.shortcut, rq.description, rq.status, rq.payment, rq.readiness,

            to_char(rq.created, 'YYYY-MM-DD HH24:MI:SS') as created,
            to_char(rq.updated, 'YYYY-MM-DD HH24:MI:SS') as updated
        FROM fascicles_requests rq LEFT JOIN fascicles_modules t2 ON rq.module = t2.id
        WHERE 1=1
    ";

    if ($filter->{flt_fascicle}) {
        $sql_query .= " AND rq.fascicle=? ";
        push @params, $filter->{flt_fascicle};
    }

    my @sortModes = qw(ASC DESC);
    my @sortColumns= qw(
        serialnum advertiser_shortcut place_shortcut manager_shortcut
        amount shortcut description status payment readiness
        pages origin_shortcut module_shortcut
    );
    if ( $sorting->{dir} ~~ @sortModes ) {
        if ( $sorting->{column} ~~ @sortColumns ) {
            if ($sorting->{column} eq "pages") {
                $sorting->{column} = "firstpage";
            }
            $sql_query .=  " ORDER BY rq.". $sorting->{column} ." ". $sorting->{dir};
        }
    }

    if ($pagination->{limit} > 0 && $pagination->{start} >= 0) {
        $sql_query .= " LIMIT ? OFFSET ? ";
        push @params, $pagination->{limit};
        push @params, $pagination->{start};
    }

    return $c->sql->Q($sql_query, \@params)->Hashes;
}

1;
