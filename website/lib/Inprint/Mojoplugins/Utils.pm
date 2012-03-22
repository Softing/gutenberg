package Inprint::Mojoplugins::Utils;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use warnings;
use strict;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

sub register {

    my ( $self, $app, $conf ) = @_;

    # Plugin config
    $conf ||= {};

    # NEW ACCESS CHECK

    $app->helper(

        optionalize => sub {

            my ($c, $options) = @_;

            my $result = {};

            my @items = split /[,|;]/, $options;

            foreach (@items) {
                my ($var, $val) = split "::", $_;
                $result->{$var} = $val // 1;
            }

            return $result;
        });


}

1;
