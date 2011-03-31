package Inprint::Models::Tag;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

sub getByTitle {
    my $c = shift;
    my ($title, $description ) = @_;

    my $tag = $c->Q("
        SELECT id, title FROM indx_tags WHERE title=? ",
        [ $title ])->Hash;

    unless ($tag->{id}) {

        $c->Do("
            INSERT INTO indx_tags (id, title, description, created, updated)
            VALUES (?, ?, ?, now(), now()); ",
            [ $c->uuid, $title, $description ]);

        $tag = $c->Q("
            SELECT id, title FROM indx_tags WHERE title=? ",
            [ $title ])->Hash;

    }

    return $tag;
}

sub getById {
    my $c = shift;
    my ($id) = @_;

    my $tag = $c->Q("
        SELECT id, title FROM indx_tags WHERE id=? ",
        [ $id ])->Hash;

    return $tag;
}

1;
