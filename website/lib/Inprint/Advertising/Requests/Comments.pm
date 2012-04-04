package Inprint::Advertising::Requests::Comments;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use v5.10;

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub list {
    my $c = shift;

    my @errors;
    my $result = [];

    my $i_id    = $c->get_uuid(\@errors, "id");
    my $request = $c->check_record(\@errors, "fascicles_requests", "request", $i_id);

    unless (@errors) {
        $result = $c->Q("
            SELECT
                id, check_status, member, member_shortcut, fulltext,
                to_char(created, 'YYYY-MM-DD HH24:MI:SS') as created
            FROM fascicles_requests_comments
            WHERE entity=?
            ORDER BY created DESC ",
            [ $request->{id} ])->Hashes;
    }

    foreach my $item (@$result) {
        given ($item->{check_status}) {
            when  ("error")    {
                $item->{icon} = "exclamation-red";     $item->{stage_color} = "C63137";
            }
            when  ("check")    {
                $item->{icon} = "exclamation-octagon"; $item->{stage_color} = "F1DA5D";
            }
            when  ("ready")    {
                $item->{icon} = "tick-circle";         $item->{stage_color} = "009E1C";
            }
            when  ("imposed")  {
                $item->{icon} = "printer";             $item->{stage_color} = "000000";
            }
            default {

            }
        }
    }

    $c->smart_render(\@errors, $result);
}

sub save {
    my $c = shift;

    my @errors;
    my $i_id   = $c->get_uuid(\@errors, "id");
    my $i_text = $c->get_text(\@errors, "text");

    my $request   = $c->check_record(\@errors, "fascicles_requests", "request", $i_id);
    my $principal = $c->check_record(\@errors, "view_principals", "principal", $c->getSessionValue("member.id"));

    unless (@errors) {
        $c->Do("
            INSERT INTO fascicles_requests_comments(
                entity, member, member_shortcut, check_status, fulltext, created, updated)
                VALUES (?, ?, ?, ?, ?, NOW(), NOW() ) ",
            [ $request->{id}, $principal->{id}, $principal->{shortcut}, $request->{check_status}, $i_text ]);
    }

    $c->smart_render(\@errors);
}


1;
