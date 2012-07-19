package Inprint::Models::Fascicle::Template;

use strict;
use warnings;

sub create {
    my $c = shift;

    my ($id, $edition, $fastype, $shortcut, $description) = @_;

    my $variation = $c->uuid;

    $c->Do("
        INSERT INTO fascicles(
            id, edition, parent, fastype, variation,
            shortcut, description,
            created, updated)
        VALUES (?, ?, ?, ?, ?, ?, ?, now(), now());

    ", [ $id, $edition, $edition, $fastype, $variation, $shortcut, $description]);

    return $c;
}

1;
