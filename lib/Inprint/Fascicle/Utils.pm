package Inprint::Fascicle::Utils;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub compressString {

    my $c = shift;
    my $string = shift;

    my @pages = split(/[^\d]+/, $string );
    my @string;
    for ( my $i = 0; $i <= $#pages; $i++ ) {

        my $cp = int( $pages[$i] );
        my $pp = int( $pages[$i-1] );
        my $fp = int( $pages[$i+1] );

        next unless $cp;

        if ( !$pp ) {
                push @string, $cp;
        } elsif (!$fp ) {
                push @string, $cp;
        } elsif ( $pp && $fp && $cp-1 == $pp && $cp+1 == $fp ) {
                push @string, "-";
        } else {
                push @string, $cp;
        }
    };

    $string = join (',',@string);
    $string =~ s/,-,/-/g;
    $string =~ s/-,/-/g;
    $string =~ s/-+/-/g;
    $string =~ s/,/, /g;

    return $string;
}

sub uncompressString {

    my $c = shift;
    my $string = shift;

    my @pairs = split '[^\d|\-|\:|<|>]', $string;

    my @source;

    foreach my $pair ( @pairs ) {

        next unless $pair;

        if ( $pair =~ /\-/ ) {
            my ($start, $end) = split '-', $pair;
            my $array = [];
            for ($start .. $end) {
                push @source, $_ if ($_>0);
            }
        } elsif ( $pair =~ /</ ) {
            my ($count, $after) = split '<', $pair;
            for ( $after-$count .. $after) {
                push @source, $_ if ($_>0);
            }
        } elsif ( $pair =~ />/ ) {
            my ($count, $after) = split '>', $pair;
            for ( $after .. $after+$count ) {
                push @source, $_ if ($_>0);
            }
        } elsif ( $pair =~ /\:/ ) {
            my ($count, $after) = split ':', $pair;
            for ($after+1 .. $after+$count) {
                push @source, $_ if ($_>0);
            }
        } elsif ( $pair =~ /\d/ ) {
            push @source, $pair;
        }
    }

    my @pages;

    my %seen = (); foreach my $item (@source) {    push(@pages, $item) unless $seen{$item}++; }

    @pages = sort { $a <=> $b } @pages;

    return \@pages;
}

sub getChunks {
    my $c = shift;
    my $pages = shift;

    my @result;

    for (my $c=0; $c <= $#{$pages}; $c++ ) {

        my $prev = $$pages[$c-1] || undef;
        my $curr = $$pages[$c] || undef;
        my $next = $$pages[$c+1] || undef;

        #die "$prev $curr $next";

        if ($c == 0) {
            push @result, [ $curr ];
            next;
        }

        if ($prev && $curr-$prev == 1 ) {
            push @{ $result[-1] }, $curr ;
            next;
        }

        if ($prev && $curr-$prev > 1 ) {
            push @result, [ $curr ];
            next;
        }

    }

    return \@result;
}

1;
