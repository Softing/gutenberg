package Inprint::Models::Fascicle::Rubric;

use strict;
use warnings;

use Inprint::Models::Tag;

sub create {
    my $c = shift;

    my ($id, $edition, $fascicle, $headline, $bydefault, $title, $description ) = @_;

    my $tag = Inprint::Models::Tag::getByTitle($c, $title, $description);

    if ($tag->{id}) {
        $c->sql->Do("
            INSERT INTO fascicles_indx_rubrics (id, edition, fascicle, headline, tag, title, description, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, now(), now());
            ", [ $id, $edition, $fascicle, $headline, $tag->{id}, $tag->{title}, $tag->{description} || "" ]);
        if ($bydefault eq "on") {
            $c->sql->Do("
                UPDATE fascicles_indx_rubrics SET bydefault=false WHERE fascicle=? AND headline=?;
                ", [ $fascicle, $headline ]);
            $c->sql->Do("
                UPDATE fascicles_indx_rubrics SET bydefault=true WHERE id=?;
                ", [ $id ]);
        }
    }

    return $c;
}

sub read {
    my $c = shift;
    my $id = shift;

    my $result = $c->sql->Q("
        SELECT id, edition, fascicle, headline, tag, title, description, created, updated
        FROM fascicles_indx_rubrics WHERE id=? ",
        [ $id ])->Hash;

    return $result;
}

sub findByTag {
    my $c = shift;
    my ($fascicle, $headline, $tag) = shift;
    my $result = $c->sql->Q("
        SELECT id, edition, headline, tag, title, description, created, updated
        FROM fascicles_indx_rubrics WHERE fascicle=? AND headline=? AND tag=? ",
        [ $fascicle, $headline, $tag ])->Hash;
    return $result;
}

sub update {
    my $c = shift;
    my ($id, $edition, $fascicle, $headline, $bydefault, $title, $description ) = @_;

    my $tag = Inprint::Models::Tag::getByTitle($c, $title, $description);

    if ($tag->{id}) {
        $c->sql->Do(" UPDATE fascicles_indx_rubrics SET tag=?, title=?, description=? WHERE id=? ",
            [ $tag->{id}, $tag->{title}, $tag->{description} || "", $id ]);
        if ($bydefault eq "on") {
            $c->sql->Do("
                UPDATE fascicles_indx_rubrics SET bydefault=false WHERE fascicle=? AND headline=?;
                ", [ $fascicle, $headline ]);
            $c->sql->Do("
                UPDATE fascicles_indx_rubrics SET bydefault=true WHERE id=?;
                ", [ $id ]);
        }
    }

    return $c;
}

sub delete {
    my $c  = shift;
    my $id = shift;

    $c->sql->Do("
        DELETE FROM fascicles_indx_rubrics WHERE id =?
            AND id <> '00000000-0000-0000-0000-000000000000' ",
        [ $id ]);

    return $c;
}

1;
