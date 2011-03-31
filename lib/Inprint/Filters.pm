package Inprint::Filters;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub mysession
{
    my $c = shift;

    # Get session ID
    my $sid = $c->session("sid") || $c->param("sid");

    $c->cookie(sid => $sid);

    # Check session
    if ($sid) {

        my $session = $c->Q("SELECT * FROM sessions WHERE id=?", [ $sid ])->Hash;
        if ($session->{member}) {

            my $access  = $c->Q("
                SELECT true
                FROM map_member_to_rule
                WHERE member = ? AND term='2fde426b-ed30-4376-9a7b-25278e8f104a'
            ", [ $session->{member} ])->Value;

            if ($access) {
                $c->Do(" UPDATE sessions SET updated=now() WHERE id=? ", [ $sid ] );
            } else {
                $c->redirect_to('/login');
            }
        } else {
            $c->redirect_to('/login');
        }
    } else {
        $c->redirect_to('/login');
    }

    # Create session object
    if ($c->session("sid")) {

        my $member = $c->Q("
            SELECT t2.id, t2.login, t3.title, t3.shortcut, t3.job_position
            FROM sessions t1, members t2 LEFT JOIN profiles t3 ON (t3.id = t2.id) WHERE t1.id=? AND t1.member = t2.id
        ", [ $c->session("sid") ])->Hash || {};

        $c->stash( "member.id" =>       $member->{id});

        $c->setSessionValue("member.id",       $member->{id});
        $c->setSessionValue("member.login",    $member->{login});
        $c->setSessionValue("member.shortcut", $member->{shortcut});
        $c->setSessionValue("member.position", $member->{job_position});

        my $options = $c->Q(" SELECT option_name, option_value FROM options WHERE member=? ", [ $member->{id} ])->Hashes || [];
        foreach my $item (@$options) {
            $c->setSessionValue("options.". $item->{option_name}, $item->{option_value});
        }

    }

    return $c;
}

1;
