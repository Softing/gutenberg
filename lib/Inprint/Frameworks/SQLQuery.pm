package Inprint::Frameworks::SQLQuery;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use utf8;

sub new {
    my $class = shift;

    my $self  = {};
    $self     = bless {}, $class;

    my $DBH    = shift;
    my $query  = shift;
    my $value  = shift;
    my $trace  = shift;

    $self->{conn}  = $DBH;
    $self->{query} = $query;
    $self->{value} = $value;

    bless($self, $class);
    return $self;
}

sub Value  {
    my $c = shift;

    my $result;

    if ( $c->{value} ) {
        $result = $c->conn->run(fixup => sub {
            $_->selectrow_arrayref( $c->{query}, undef, @{ $c->{value} } );
        });
    } else {
        $result = $c->conn->run(fixup => sub {
            $_->selectrow_arrayref( $c->{query}, undef );
        });
    }

    return @$result[0];
}

sub Values  {
    my $c = shift;

    my $result;

    if ( $c->{value} ) {
        $result = $c->conn->run(fixup => sub {
            $_->selectcol_arrayref( $c->{query}, undef, @{ $c->{value} } );
        });
    } else {
        $result = $c->conn->run(fixup => sub {
            $_->selectcol_arrayref( $c->{query}, undef );
        });
    }

    return $result;
}

sub Array {
    my $c = shift;

    my $result;

    if ( $c->{value} ) {
        $result = $c->conn->run(fixup => sub {
            $_->selectrow_arrayref( $c->{query}, undef, @{ $c->{value} } );
        });
    } else {
        $result = $c->conn->run(fixup => sub {
            $_->selectrow_arrayref( $c->{query}, undef );
        });
    }

    return $result;
}

sub Hash {
    my $c = shift;

    my $result;

    if ( $c->{value} ) {
        $result = $c->conn->run(fixup => sub {
            $_->selectrow_hashref( $c->{query}, undef, @{ $c->{value} } );
        });
    } else {
        $result = $c->conn->run(fixup => sub {
            $_->selectrow_hashref( $c->{query}, undef);
        });
    }

    return $result;
}

sub Arrays  {
    my $c = shift;

    my $result;

    if ( $c->{value} ) {
        $result = $c->conn->run(fixup => sub {
            $_->selectall_arrayref( $c->{query}, undef, @{ $c->{value} } );
        });
    } else {
        $result = $c->conn->run(fixup => sub {
            $_->selectall_arrayref( $c->{query}, undef);
        });
    }

    return $result;
}

sub Hashes  {
    my $c = shift;

    my $result;

    if ( $c->{value} ) {

        $result = $c->conn->run(fixup => sub {
            $_->selectall_arrayref( $c->{query}, { Slice => {} }, @{ $c->{value} } );
        });

    } else {
        $result = $c->conn->run(fixup => sub {
            $_->selectall_arrayref( $c->{query}, { Slice => {} });
        });
    }

    return $result;
}

sub conn {
    my $c = shift;
    return $c->{conn};
}

1;
