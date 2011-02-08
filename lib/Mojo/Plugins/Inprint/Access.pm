package Mojo::Plugins::Inprint::Access;

use strict;
use warnings;

use base 'Mojolicious::Plugin';

sub register {
    my ($self, $app, $args) = @_;

    $args ||= {};
    
    $app->plugins->add_hook(
        before_dispatch => sub {
            my ($self, $c) = @_;
            
            
            
        }
    );

    $app->plugins->add_hook(
        after_dispatch => sub {
            my ($self, $c) = @_;
            
        }
    );
}

1;
