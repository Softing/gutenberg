package Inprint::Models::Rss;

use strict;
use warnings;

use Inprint::Models::Tag;


sub read {
    my $c = shift;
    my $id = shift;

    my $result = $c->Q("
            SELECT id, document, link, title, description, fulltext,
                published, created, updated
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
        $c->Do("
            UPDATE rss
                SET link=?, title=?, description=?, fulltext=?,  published=?,
                    updated=now()
                WHERE id=?; ",
            [ $link, $title, $description, $fulltext, $published, $record->{id} ]);
    }

    # Create record
    unless ($record->{id}) {
        my $record_id = $c->uuid;
        $c->Do("
            INSERT
                INTO rss (id, document, link, title, description, fulltext,
                    published, created,  updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, now(), now()); ",
            [ $record_id, $document, $link, $title, $description, $fulltext, $published ]);
    }

    return $c;
}


1;
