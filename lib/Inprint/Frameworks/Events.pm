package Inprint::Frameworks::Events;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

sub new {
    my $class = shift;
    my $c = shift;
    my $self     = bless {}, $class;

    bless($self, $class);
    return $self;
}

sub SetHandler {
    my $c = shift;
    my $handler = shift;
    $c->{handler} = $handler;
}

sub Create {

    my $c = shift;

    my $type   = shift;
    my $entity = shift || "00000000-0000-0000-0000-000000000000";
    my $action = shift;
    my $text   = shift;
    my $vars   = shift || [];

    my $initiatorId       = $c->{handler}->QuerySessionGet("member.id")       || "00000000-0000-0000-0000-000000000000";
    my $initiatorLogin    = $c->{handler}->QuerySessionGet("member.login")    || "Unknown";
    my $initiatorShortcut = $c->{handler}->QuerySessionGet("member.shortcut") || "Unknown";
    my $initiatorPosition = $c->{handler}->QuerySessionGet("member.position") || "Unknown";

    $c->{handler}->sql->Do(" INSERT INTO logs(
            initiator, initiator_login, initiator_shortcut, initiator_position, entity, entity_type, message,
            message_type, message_variables, created)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, now());
    ", [ $initiatorId, $initiatorLogin, $initiatorShortcut, $initiatorPosition, $entity, $type, $text, $action, $vars ]);

    return $c;
}

1;
