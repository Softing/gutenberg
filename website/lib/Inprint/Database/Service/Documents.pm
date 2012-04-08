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
        $self->sql->Q($sql, \@params)->Objects("Inprint::Database::Model::Document")
    );

    my $cacheAccess = {};
    my $current_member = $self->app->getSessionValue("member.id");

    foreach my $document (@{ $self->records() }) {

        $document->{access} = {};
        my @rules = qw(update capture move transfer briefcase delete recover fupload fedit fdelete);

        foreach (@rules) {

            undef my $term;

            if ($document->{holder} eq $current_member) {
                $term = "catalog.documents.$_:*";
            }

            if ($document->{holder} ne $current_member) {
                $term = "catalog.documents.$_:group";
            }

            if ( defined $cacheAccess->{$term ."::". $document->{workgroup}} ) {
                $document->{access}->{$_} = $cacheAccess->{$term ."::". $document->{workgroup}};
                next;
            }

            my $access = $self->app->objectAccess($term, $document->{workgroup});

            if ($access) {
                $cacheAccess->{$term ."::". $document->{workgroup}} = $self->app->json->true;
                $document->{access}->{$_} = $self->app->json->true;
            } else {
                $cacheAccess->{$term ."::". $document->{workgroup}} = $self->app->json->false;
                $document->{access}->{$_} = $self->app->json->false;
            }

        }
    }

    return $self;
}

1;
