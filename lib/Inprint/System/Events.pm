package Inprint::System::Events;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub list {

    my $c = shift;

    my @data;
    my $i_member = $c->param("member") || undef;

    my $result = $c->Q("
        SELECT id, initiator, initiator_login, initiator_shortcut, initiator_position,
            entity, entity_type, message, message_type, message_variables, to_char(created, 'YYYY-MM-DD HH:MI:SS') as created
        FROM logs;
  ", \@data)->Hashes;

    $c->render_json( { data => $result } );
}

1;
