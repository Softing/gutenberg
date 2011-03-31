package Inprint::Mojoplugins::Events;

use warnings;
use strict;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

sub register {
    my ( $self, $app, $conf ) = @_;

    $conf ||= {};

    $app->helper(
        event => sub {
            my $c = shift;

            my $type   = shift;
            my $entity = shift || "00000000-0000-0000-0000-000000000000";
            my $action = shift;
            my $text   = shift;
            my $vars   = shift || [];

            my $initiatorId       = $c->getSessionValue("member.id")       || "00000000-0000-0000-0000-000000000000";
            my $initiatorLogin    = $c->getSessionValue("member.login")    || "Unknown";
            my $initiatorShortcut = $c->getSessionValue("member.shortcut") || "Unknown";
            my $initiatorPosition = $c->getSessionValue("member.position") || "Unknown";

            $c->Do(" INSERT INTO logs(
                    initiator, initiator_login, initiator_shortcut, initiator_position, entity, entity_type, message,
                    message_type, message_variables, created)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, now());
            ", [ $initiatorId, $initiatorLogin, $initiatorShortcut, $initiatorPosition, $entity, $type, $text, $action, $vars ]);

            return $c;
        });

}

1;
