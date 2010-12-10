package Inprint::Utils::Rubrics;

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
    
    my $exists_title = $c->sql->Q("
            SELECT count(*)
            FROM index_fascicles
            WHERE fascicle=? AND parent=? AND nature=? AND lower(title) = lower(?)
        ", [ $fascicle, $headline, "rubric", $title ])->Value;
    
    push @$errors, { id => "title", msg => "Already exists"}
        if ($exists_title);
    
    my $exists_shortcut = $c->sql->Q("
            SELECT count(*)
            FROM index_fascicles
            WHERE fascicle=? AND parent=? AND nature=? AND lower(shortcut) = lower(?)
        ", [ $fascicle, $headline, "rubric", $shortcut ])->Value;
    
    push @$errors, { id => "shortcut", msg => "Already exists"}
        if ($exists_shortcut);
    
    unless (@$errors) {
        $c->sql->Do("
            INSERT INTO index_fascicles(id, edition, fascicle, origin, nature, parent, title, shortcut, description, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [ $id, $edition, $fascicle, $id, "rubric", $headline, $title, $shortcut, $description ]);
    }
    
    my $rubric = $c->sql->Q("
            SELECT * FROM index_fascicles
            WHERE fascicle = ? AND parent = ? AND lower(shortcut) = lower(?::text) ",
        [ $fascicle, $headline, $shortcut ])->Hash;
    
    return $rubric;
}

1;