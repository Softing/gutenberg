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

    $self->{app}   = shift;
    $self->{conn}  = shift;
    $self->{query} = shift;
    $self->{value} = shift;

    bless($self, $class);
    return $self;
}

sub app {
    return shift->{app};
}

sub conn {
    return shift->{conn};
}

sub query {
    return shift->{query};
}

sub value {
    return shift->{value};
}

sub Value  {
    my $c = shift;

    my $result;

    if ( $c->value ) {
        $result = $c->conn->run(fixup => sub {
            $_->selectrow_arrayref( $c->query, undef, @{ $c->value } );
        });
    } else {
        $result = $c->conn->run(fixup => sub {
            $_->selectrow_arrayref( $c->query, undef );
        });
    }

    return @$result[0];
}

sub Values  {
    my $c = shift;

    my $result;

    if ( $c->value ) {
        $result = $c->conn->run(fixup => sub {
            $_->selectcol_arrayref( $c->query, undef, @{ $c->value } );
        });
    } else {
        $result = $c->conn->run(fixup => sub {
            $_->selectcol_arrayref( $c->query, undef );
        });
    }

    return $result;
}

sub Array {
    my $c = shift;

    my $result;

    if ( $c->value ) {
        $result = $c->conn->run(fixup => sub {
            $_->selectrow_arrayref( $c->query, undef, @{ $c->value } );
        });
    } else {
        $result = $c->conn->run(fixup => sub {
            $_->selectrow_arrayref( $c->query, undef );
        });
    }

    return $result;
}

sub Hash {
    my $c = shift;

    my $result;

    if ( $c->value ) {
        $result = $c->conn->run(fixup => sub {
            $_->selectrow_hashref( $c->query, undef, @{ $c->value } );
        });
    } else {
        $result = $c->conn->run(fixup => sub {
            $_->selectrow_hashref( $c->query, undef);
        });
    }

    return $result;
}

sub Arrays  {
    my $c = shift;

    my $result;

    if ( $c->value ) {
        $result = $c->conn->run(fixup => sub {
            $_->selectall_arrayref( $c->query, undef, @{ $c->value } );
        });
    } else {
        $result = $c->conn->run(fixup => sub {
            $_->selectall_arrayref( $c->query, undef);
        });
    }

    return $result;
}

sub Hashes  {
    my $c = shift;

    my $result;

    if ( $c->value ) {
        $result = $c->conn->run(fixup => sub {
            $_->selectall_arrayref( $c->query, { Slice => {} }, @{ $c->value } );
        });
    } else {
        $result = $c->conn->run(fixup => sub {
            $_->selectall_arrayref( $c->query, { Slice => {} });
        });
    }

    return $result;
}

sub Objects {
    my $c = shift;
    my $class = shift;

    my $records;

    if ( $c->value ) {
        $records = $c->conn->run(fixup => sub {
            $_->selectall_arrayref( $c->query, { Slice => {} }, @{ $c->value } );
        });
    } else {
        $records = $c->conn->run(fixup => sub {
            $_->selectall_arrayref( $c->query, { Slice => {} });
        });
    }

    my $result = [];

    foreach my $record (@$records) {
        push @$result, $class->new( app => $c->app )->map($record);
    }

    return $result;
}

1;
