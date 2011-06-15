package Inprint::Models::Documents;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

sub recycle {

    my ($c, $document, $fascicle ) = @_;

    $document = $c->get_record("documents", $document) unless ($document->{id});
    $fascicle = $c->get_record("fascicles", $fascicle) unless ($fascicle->{id});

    $c->Do(
        " DELETE FROM fascicles_map_documents WHERE fascicle=? AND entity=? ",
        [ $document->{fascicle}, $document->{id} ]);

    $c->Do(
        " UPDATE documents SET fascicle=?, fascicle_shortcut=? WHERE id=? ",
        [ $fascicle->{id}, $fascicle->{shortcut}, $document->{id} ]);

    __reindex($c, $document->{id}, $document->{edition}, $fascicle->{id}, $document->{headline}, $document->{rubric});

    return 1;
}

sub restore {

    my ($c, $document, $fascicle ) = @_;

    $document = $c->get_record("documents", $document) unless ($document->{id});
    $fascicle = $c->get_record("fascicles", $fascicle) unless ($fascicle->{id});

    $c->Do(" UPDATE documents SET fascicle=?, fascicle_shortcut=? WHERE id=? ", [ $fascicle->{id}, $fascicle->{shortcut}, $document->{id} ]);
    __reindex($c, $document->{id}, $document->{edition}, $fascicle->{id}, $document->{headline}, $document->{rubric});

    return 1;
}

sub delete {

    my ($c, $document ) = @_;

    $document = $c->get_record("documents", $document) unless ($document->{id});

    $c->Do(" DELETe FROM documents WHERE fascicle=? AND id=? ", [ "99999999-9999-9999-9999-999999999999", $document->{id} ]);

    return 1;
}

1;
