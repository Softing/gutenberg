# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

package Inprint::Documents::Comments;

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub list {
    my $c = shift;

    my @errors;
    my $result = [];

    my $i_id    = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        $result = $c->Q("
            SELECT
                id, entity, path,
                member, member_shortcut,
                stage, stage_shortcut, stage_color,
                fulltext, to_char(created, 'YYYY-MM-DD HH24:MI:SS') as created
            FROM comments WHERE entity = ? ORDER BY created DESC
        ", [ $i_id ])->Hashes;
    }

    $c->smart_render(\@errors, $result);
}

sub save {
    my $c = shift;

    my @errors;
    my $i_id   = $c->get_uuid(\@errors, "id");
    my $i_text = $c->get_text(\@errors, "text");

    $c->check_uuid( \@errors, "id", $i_id);
    $c->check_text( \@errors, "text", $i_text);

    my $document  = $c->check_record(\@errors, "documents", "document", $i_id);
    my $principal = $c->check_record(\@errors, "view_principals", "principal", $c->getSessionValue("member.id"));

    unless (@errors) {
            $c->Do("
            INSERT INTO comments(
                path, entity, member, member_shortcut, stage, stage_shortcut, stage_color, fulltext, created, updated)
            VALUES (null, ?, ?, ?, ?, ?, ?, ?, now(), now() ) ", [
                $document->{id}, $principal->{id}, $principal->{shortcut}, $document->{stage}, $document->{stage_shortcut}, $document->{color},
                $i_text
            ]);
    }

    $c->smart_render(\@errors);
}

1;
