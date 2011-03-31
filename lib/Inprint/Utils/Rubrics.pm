package Inprint::Utils::Rubrics;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

sub Create {

    my $c = shift;

    my $edition     = shift;
    my $fascicle    = shift;
    my $headline    = shift;
    my $title       = shift;
    my $shortcut    = shift;
    my $description = shift;

    return unless $edition;
    return unless $fascicle;
    return unless $headline;
    return unless $title;
    return unless $shortcut;

    my $id = $c->uuid();
    my $errors      = [];

    my $exists_title = $c->Q("
            SELECT count(*)
            FROM fascicles_indx_rubrics
            WHERE fascicle=? AND headline=? AND lower(title)=lower(?)
        ", [ $fascicle, $headline, $title ])->Value;

    push @$errors, { id => "title", msg => "Already exists"}
        if ($exists_title);

    my $exists_shortcut = $c->Q("
            SELECT count(*)
            FROM fascicles_indx_rubrics
            WHERE fascicle=? AND headline=? AND lower(shortcut)=lower(?)
        ", [ $fascicle, $headline, $shortcut ])->Value;

    push @$errors, { id => "shortcut", msg => "Already exists"}
        if ($exists_shortcut);

    my $rubric_origin = $c->Q("
            SELECT id FROM indx_rubrics WHERE edition=ANY(
                SELECT id FROM editions WHERE path @> (SELECT path FROM editions WHERE id=?)
            ) AND lower(shortcut)=lower(?)
        ", [ $edition, $shortcut ])->Value;

    unless (@$errors) {
        $c->Do("
            INSERT INTO fascicles_indx_rubrics(id, edition, fascicle, origin, headline, title, shortcut, description, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [ $id, $edition, $fascicle, $rubric_origin || $id, $headline, $title, $shortcut, $description ]);
    }

    my $rubric = $c->Q("
            SELECT * FROM fascicles_indx_rubrics
            WHERE fascicle=? AND headline=? AND lower(shortcut)=lower(?::text) ",
        [ $fascicle, $headline, $shortcut ])->Hash;

    return $rubric;
}

1;
