package Inprint::Models::Documents;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

sub update_record {
    my ( $c, $document, $title, $author, $size, $enddate ) = @_;
    $c->Do(" UPDATE documents SET title=?, author=?, psize=?, pdate=? WHERE id=? OR copygroup=?; ",
        [ $title, $author, $size, $enddate, $document, $document ]);
}

sub update_index {

    my ( $c, $id, $headline, $headline_title, $rubric, $rubric_title ) = @_;

    if ($headline && $headline_title) {
        $c->Do("
            UPDATE documents SET headline=?, headline_shortcut=? WHERE id=? ",
            [ $headline, $headline_title, $id ]);
    } else {
        $c->Do(" UPDATE documents SET headline=null, headline_shortcut=null WHERE id=? ", [ $id ]);
    }

    if ($rubric && $rubric_title) {
        $c->Do("
            UPDATE documents SET rubric=?, rubric_shortcut=? WHERE id=? ",
            [ $rubric, $rubric_title, $id ]);
    } else {
        $c->Do(" UPDATE documents SET rubric=null, rubric_shortcut=null WHERE id=? ", [ $id ]);
    }

}

sub update_manager {
    my ( $c, $document, $manager, $manager_shortcut ) = @_;
    $c->Do(" UPDATE documents SET manager=?, manager_shortcut=? WHERE id=? OR copygroup=?; ",
        [ $manager, $manager_shortcut, $document, $document ]);
}

sub update_maingroup {
    my ( $c, $document, $maingroup, $maingroup_shortcut ) = @_;
    $c->Do(" UPDATE documents SET maingroup=?, maingroup_shortcut=? WHERE id=? OR copygroup=?; ",
        [ $maingroup, $maingroup_shortcut, $document, $document ]);
}

1;
