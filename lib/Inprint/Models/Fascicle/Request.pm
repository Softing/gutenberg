package Inprint::Models::Fascicle::Request;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
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
            request.id,
            request.serialnum,
            edition.id as edition,
            edition.shortcut as edition_shortcut,
            fascicle.id as fascicle,
            fascicle.shortcut as fascicle_shortcut,
            request.shortcut,
            request.description,
            request.advertiser,
            request.advertiser_shortcut,
            request.place,
            request.place_shortcut,
            request.manager,
            request.manager_shortcut,
            request.tmpl_module as module,
            request.tmpl_module_shortcut as module_shortcut,
            request.page,
            request.pages,
            request.status,
            request.payment,
            request.readiness,
            request.squib,
            request.check_status,
            request.anothers_layout,
            request.imposed,
            request.amount,
            request.area,
            request.w,
            request.h,
            request.width,
            request.height,
            request.fwidth,
            request.fheight,
            to_char(request.created, 'YYYY-MM-DD HH24:MI:SS') as created,
            to_char(request.updated, 'YYYY-MM-DD HH24:MI:SS') as updated
        FROM
            editions edition,
            fascicles fascicle,
            fascicles_requests request
        WHERE 1=1
            AND edition.id  = request.edition
            AND fascicle.id = request.fascicle
    ";

    if ($filter->{flt_fascicle}) {
        $sql_query .= " AND request.fascicle=? ";
        push @params, $filter->{flt_fascicle};
    }

    if ($filter->{flt_checked} && $filter->{flt_checked} ne "all") {
        $sql_query .= " AND request.check_status=? ";
        push @params, $filter->{flt_checked};
    }

    my @sortModes = qw(ASC DESC asc desc);
    my @sortColumns= qw(
        serialnum
        advertiser_shortcut
        place_shortcut
        manager_shortcut
        amount
        shortcut
        description
        status
        payment
        readiness
        pages
        origin_shortcut
        module_shortcut
        check_status
        anothers_layout
        is_maked
    );

    if ( $sorting->{dir} ~~ @sortModes ) {
        if ( $sorting->{column} ~~ @sortColumns ) {
            if ($sorting->{column} eq "pages") {
                $sorting->{column} = "firstpage";
            }
            $sql_query .=  " ORDER BY request.". $sorting->{column} ." ". $sorting->{dir};
        }
    }

    if ($pagination->{limit} > 0 && $pagination->{start} >= 0) {
        $sql_query .= " LIMIT ? OFFSET ? ";
        push @params, $pagination->{limit};
        push @params, $pagination->{start};
    }

    return $c->Q($sql_query, \@params)->Hashes;
}

1;
