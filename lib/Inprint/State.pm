package Inprint::State;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub index {
    my $c = shift;

    my $i_cmd = $c->param("cmd");

    my $result = {};

    if ($i_cmd eq 'read') {
        $result = $c->read();
    }

    if ($i_cmd eq 'save') {
        $result = $c->save();
    }

    $c->render_json( $result );
}

sub read {
    my $c = shift;

    my $sid = $c->session("sid");

    my $result = {
        success => $c->json->true
    };

    $result->{data} = $c->sql->Q("
        SELECT param as name, value FROM state WHERE member = ?
    ", [ $sid ])->Hashes;

    return $result;
}

sub save {
    my $c = shift;

    my $sid = $c->session("sid");

    my $result = {
        success => $c->json->true
    };

    my $i_name = $c->param("name");
    my $i_data = $c->param("data");

    my $data = $c->json->decode($i_data);

    foreach (@{$data}) {
        if ( $sid && $_->{name} && $_->{value} ) {
            $c->sql->Do("
                DELETE FROM state WHERE member=? AND param=?
            ", [ $sid, $_->{name} ]);
            $c->sql->Do("
                INSERT INTO state(member, param, value, created, updated)
                VALUES (?, ?, ?, now(), now());
            ", [ $sid, $_->{name}, $_->{value} ]);
        }
    }

    return $result;

}

1;
