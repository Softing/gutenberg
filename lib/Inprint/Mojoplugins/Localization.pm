package Inprint::Mojoplugins::Localization;

use warnings;
use strict;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

sub register {
    my ( $self, $app, $conf ) = @_;

    # Plugin config
    $conf ||= {};

    $app->helper(
        l => sub {
            my $c = shift;
            my $input = shift;
            my @vars = @_;

            my $output = $c->stash->{i18n}->{_handle}->get($input);

            if ($input eq $output) {
                $output = $c->Q("
                    SELECT l18n_translation FROM plugins.l18n
                    WHERE l18n_language=? AND l18n_original=?",
                    [ $c->stash->{i18n}->{_language}, $output ])->Value;
            }

            unless ($output) {
                $output = $input;
            }

            for (1 .. $#vars+1) {
                my $placer = "%$_";
                my $value = $vars[$_-1];
                $output =~ s/$placer/$value/g;
            }

            return $output;
        } );

}

1;
