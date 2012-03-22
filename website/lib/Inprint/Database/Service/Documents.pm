package Inprint::Database::Service::Documents;

use Moose;

use utf8;
use strict;
use warnings;

use Inprint::Database::Model::Document;

extends "Inprint::Database::List";

sub list {
    my $self = shift;
    my %args = @_;

    my $columns = $self->_makeColumnsList([ Inprint::Database::Model::Document::COLUMNS ]);

    my @params;
    my $sql = " SELECT $columns FROM documents WHERE 1=1 ";

    if ($args{fascicle}) {
        $sql .= " AND fascicle=? ";
        push @params, $args{fascicle};
    }

    if ($args{orderBy}) {
        $sql .= " ORDER BY $args{orderBy} ";
    } else {
        $sql .= " ORDER BY title ";
    }

    $self->records(
        $self->sql->Q($sql, \@params)
            ->Objects("Inprint::Database::Model::Document")
    );

    return $self;
}

1;
