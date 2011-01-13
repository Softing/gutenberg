package Inprint::Models::Rss;

use strict;
use warnings;

use Inprint::Models::Tag;


sub read {
    my $c = shift;
    my $id = shift;

    my $result = $c->sql->Q("
            SELECT id, document, link, title, description, fulltext,
                enabled, created, updated
            FROM rss
            WHERE document=? ",
        [ $id ])->Hash;

    return $result;
}

sub update {
    my $c = shift;
    my ($document, $published, $link, $title, $description, $fulltext) = @_;

    # Get record
    my $record = &read($c, $document);

    # Update record
    if ($record->{id}) {
        $c->sql->Do("
            UPDATE rss
                SET link=?, title=?, description=?, fulltext=?,  enabled=?,
                    updated=now()
                WHERE id=?; ",
            [ $link, $title, $description, $fulltext, $published, $record->{id} ]);
    }

    # Create record
    unless ($record->{id}) {
        my $record_id = $c->uuid;
        $c->sql->Do("
            INSERT
                INTO rss (id, document, link, title, description, fulltext,
                    enabled, created,  updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, now(), now()); ",
            [ $record_id, $document, $link, $title, $description, $fulltext, $published ]);
    }

    return $c;
}


1;
