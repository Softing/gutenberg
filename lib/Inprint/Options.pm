package Inprint::Options;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub update {

    my $c = shift;

    my $member_id     = $c->QuerySessionGet("member.id");
    my $i_destination = $c->param("capture.destination");

    my $result = {
        success => $c->json->false,
        errors  => []
    };

    my @options;

    push @options, {
        name  => "transfer.capture.destination",
        value => $i_destination
    } if $i_destination;

    foreach my $item (@options) {
        $c->sql->Do(
            "DELETE FROM options WHERE option_name=? AND member=?", [
                $item->{name}, $member_id
        ]);
        $c->sql->Do(
            "INSERT INTO OPTIONS (member, option_name, option_value) VALUES (?, ?, ?)", [
                $member_id, $item->{name}, $item->{value}
        ]);
        $result->{success} = $c->json->true;
    }

    $c->render_json( $result );
}


1;
