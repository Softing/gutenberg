package Inprint::Mojoplugins::Render;

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

    $app->helper(
        smart_render => sub {
            my ($c, $errors, $data) = @_;

            my $success = $c->json->false;

            unless (@$errors) {
                $success = $c->json->true;
            }

            my $result = {
                success => $success,
                errors  => $errors
            };

            if ($data) {
                $result->{data} = $data;
            }

            $c->render_json($result);
        });

    $app->helper(
        fail_render => sub {
            my ($c, $errors) = @_;
            if (@{ $errors }) {
                $c->render_json({ success => $c->json->false, errors => \@$errors });
                return;
            }
            return $c;
        });
}

1;
