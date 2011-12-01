package Inprint::Database::Service::Requests;

use Moose;

use utf8;
use strict;
use warnings;

use Inprint::Database::Model::Request;

extends "Inprint::Database::List";

sub list {
    my $self = shift;
    my %args = @_;

    my $table   = Inprint::Database::Model::Request::TABLE;
    my $columns = $self->_makeColumnsList([ Inprint::Database::Model::Request::COLUMNS ]);

    my @params;
    my $sql = " SELECT $columns FROM $table WHERE 1=1 ";

    if ($args{fascicle}) {
        $sql .= " AND fascicle=? ";
        push @params, $args{fascicle};
    }

    if ($args{orderBy}) {
        $sql .= " ORDER BY $args{orderBy} ";
    } else {
        $sql .= " ORDER BY shortcut ";
    }

    $self->records(
        $self->sql->Q($sql, \@params)
            ->Objects("Inprint::Database::Model::Request")
    );

    # -----------------------------------------------------------------------------------------------

    #my @params;
    #
    ## Query headers
    #my $sql = "
    #    SELECT
    #
    #        rq.id, rq.serialnum,
    #
    #        ed.id as edition,
    #        ed.shortcut as edition_shortcut,
    #
    #        fs.id as fascicle,
    #        fs.shortcut as fascicle_shortcut,
    #
    #        rq.advertiser, rq.advertiser_shortcut,
    #        rq.place, rq.place_shortcut,
    #        rq.manager, rq.manager_shortcut,
    #        rq.origin, rq.origin_shortcut, rq.origin_area,
    #        rq.origin_x, rq.origin_y, rq.origin_w, rq.origin_h,
    #        rq.pages, rq.firstpage,
    #        rq.amount, rq.shortcut, rq.description, rq.status, rq.payment, rq.readiness,
    #
    #        rq.check_status, anothers_layout, imposed,
    #
    #        t2.id as module, t2.title as module_shortcut,
    #
    #        to_char(rq.created, 'YYYY-MM-DD HH24:MI:SS') as created,
    #        to_char(rq.updated, 'YYYY-MM-DD HH24:MI:SS') as updated
    #    FROM
    #        editions ed,
    #        fascicles fs,
    #        fascicles_requests rq
    #        LEFT JOIN fascicles_modules t2 ON rq.module = t2.id
    #    WHERE 1=1
    #        AND ed.id = rq.edition
    #        AND fs.id = rq.fascicle
    #";
    #
    #if ($filter->{flt_fascicle}) {
    #    $sql_query .= " AND rq.fascicle=? ";
    #    push @params, $filter->{flt_fascicle};
    #}
    #
    #if ($filter->{flt_checked} && $filter->{flt_checked} ne "all") {
    #    $sql_query .= " AND rq.check_status=? ";
    #    push @params, $filter->{flt_checked};
    #}
    #
    #my @sortModes = qw(ASC DESC asc desc);
    #my @sortColumns= qw(
    #    serialnum advertiser_shortcut place_shortcut manager_shortcut
    #    amount shortcut description status payment readiness
    #    pages origin_shortcut module_shortcut check_status anothers_layout is_maked
    #);
    #
    #if ( $sorting->{dir} ~~ @sortModes ) {
    #    if ( $sorting->{column} ~~ @sortColumns ) {
    #        if ($sorting->{column} eq "pages") {
    #            $sorting->{column} = "firstpage";
    #        }
    #        $sql_query .=  " ORDER BY rq.". $sorting->{column} ." ". $sorting->{dir};
    #    }
    #}
    #
    #if ($pagination) {
    #    if ($pagination->{limit} > 0 && $pagination->{start} >= 0) {
    #        $sql_query .= " LIMIT ? OFFSET ? ";
    #        push @params, $pagination->{limit};
    #        push @params, $pagination->{start};
    #    }
    #}
    #
    #return $c->Q($sql_query, \@params)->Hashes;


    return $self;
}

1;
