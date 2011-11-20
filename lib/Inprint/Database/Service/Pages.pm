package Inprint::Database::Service::Pages;

use Moose;

use utf8;
use strict;
use warnings;

use Inprint::Database::Model::FasciclePage;

extends "Inprint::Database::List";

sub list {
    my $self = shift;
    my %args = @_;

    my @params;
    my $sql = " SELECT * FROM fascicles_pages WHERE 1=1 ";

    if ($args{fascicle}) {
        $sql .= " AND fascicle=? ";
        push @params, $args{fascicle};
    }

    $self->records(
        $self->sql->Q(" $sql ORDER BY seqnum ", \@params)
            ->Objects("Inprint::Database::Model::FasciclePage")
    );

    return $self;
}


1;
