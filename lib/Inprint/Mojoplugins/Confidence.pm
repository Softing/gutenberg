package Inprint::Mojoplugins::Confidence;

use warnings;
use strict;
use Mojo::Base 'Mojolicious::Plugin';

use Inprint::Frameworks::Access;

our %Cache;

our $VERSION = '0.01';

sub register {
    my ( $self, $app, $conf ) = @_;

    # Plugin config
    $conf ||= {};

    $app->helper(
        access => sub {
            my $c = shift;
            $Cache{Access} = new Inprint::Frameworks::Access($c) unless ($Cache{Access});
            $Cache{Access}->SetHandler($c);
            return $Cache{Access};
        } );

    $app->helper(
        rules => sub {
            my $c = shift;
                die 2;
            return $c;
        } );
}

1;
