package Inprint::Frameworks::SQLQuery;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use utf8;

sub new {
    my $class = shift;

    my $self  = {};
    $self     = bless {}, $class;

    my $sql    = shift;
    my $query  = shift;
    my $value  = shift;
    my $trace  = shift;

    $self->{sql}   = $sql;
    $self->{app}   = $sql->{app};
    $self->{dbh}   = $sql->{dbh};
    $self->{query} = $query;
    $self->{value} = $value;

    bless($self, $class);
    return $self;
}

sub Value  {
    my $c = shift;

    my $result;

    if ( $c->{value} ) {
        $result = $c->{dbh}->selectrow_arrayref( $c->{query}, undef, @{ $c->{value} } );
    } else {
        $result = $c->{dbh}->selectrow_arrayref( $c->{query}, undef );
    }

    return @$result[0];
}

sub Values  {
    my $c = shift;

    my $result;

    if ( $c->{value} ) {
        $result = $c->{dbh}->selectcol_arrayref( $c->{query}, undef, @{ $c->{value} } );
    } else {
        $result = $c->{dbh}->selectcol_arrayref( $c->{query}, undef );
    }

    return $result;
}

sub Array {
    my $c = shift;

    my $result;

    if ( $c->{value} ) {
        $result = $c->{dbh}->selectrow_arrayref( $c->{query}, undef, @{ $c->{value} } );
    } else {
        $result = $c->{dbh}->selectrow_arrayref( $c->{query}, undef );
    }

    return $result;
}

sub Hash {
    my $c = shift;

    my $result;

    if ( $c->{value} ) {
        $result = $c->{dbh}->selectrow_hashref( $c->{query}, undef, @{ $c->{value} } );
    } else {
        $result = $c->{dbh}->selectrow_hashref( $c->{query}, undef);
    }

    return $result;
}

sub Arrays  {
    my $c = shift;

    my $result;

    if ( $c->{value} ) {
        $result = $c->{dbh}->selectall_arrayref( $c->{query}, undef, @{ $c->{value} } );
    } else {
        $result = $c->{dbh}->selectall_arrayref( $c->{query}, undef);
    }

    return $result;
}

sub Hashes  {
    my $c = shift;

    my $result;

    if ( $c->{value} ) {
        $result = $c->{dbh}->selectall_arrayref( $c->{query}, { Slice => {} }, @{ $c->{value} } );
    } else {
        $result = $c->{dbh}->selectall_arrayref( $c->{query}, { Slice => {} });
    }

    return $result;
}

sub Objects {
    my $c = shift;
    my $class = shift;

    my $records;

    if ( $c->{value} ) {
        $records = $c->{dbh}->selectall_arrayref( $c->{query}, { Slice => {} }, @{ $c->{value} } );
    } else {
        $records = $c->{dbh}->selectall_arrayref( $c->{query}, { Slice => {} });
    }

    my $result = [];

    foreach my $record (@$records) {
        push @$result, $class->new( app => $c->{app} )->map($record);
    }

    return $result;
}

1;
