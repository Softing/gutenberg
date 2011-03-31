package Inprint::Mojoplugins::Logger;

use warnings;
use strict;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

sub register {
    my ( $self, $app, $conf ) = @_;

    # Plugin config
    $conf ||= {};

    $app->helper(
        log => sub {
            my $c = shift;
            return $c->app->log;
        });

    $app->helper(
        debug => sub {
            my ($c, $message) = @_;
            return $c->app->log->debug($message);
        });

    $app->helper(
        info => sub {
            my ($c, $message) = @_;
            return $c->app->log->info($message);
        });

    $app->helper(
        warn => sub {
            my ($c, $message) = @_;
            return $c->app->log->warn($message);
        });

    $app->helper(
        error => sub {
            my ($c, $message) = @_;
            return $c->app->log->error($message);
        });

    $app->helper(
        fatal => sub {
            my ($c, $message) = @_;
            return $c->app->log->fatal($message);
        });

}

1;
