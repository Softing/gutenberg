package Inprint::Models::Rubric;

use strict;
use warnings;

use Inprint::Models::Tag;

sub create {
    my $c = shift;

    my ($id, $edition, $headline, $title, $description ) = @_;

    my $tag = Inprint::Models::Tag::getByTitle($c, $title, $description);

    if ($tag->{id}) {
        $c->sql->Do("
            INSERT INTO indx_rubrics (id, edition, headline, tag, title, description, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, now(), now());
            ", [ $id, $edition, $headline, $tag->{id}, $tag->{title}, $tag->{description} || "" ]);
    }

    return $c;
}

sub read {
    my $c = shift;
    my $id = shift;

    my $result = $c->sql->Q("
        SELECT id, edition, headline, tag, title, description, created, updated
        FROM indx_rubrics WHERE id=? ",
        [ $id ])->Hash;

    return $result;
}

sub update {
    my $c = shift;
    my ($id, $title, $description ) = @_;

    my $tag = Inprint::Models::Tag::getByTitle($c, $title, $description);

    if ($tag->{id}) {
        $c->sql->Do(" UPDATE indx_rubrics SET title=?, description=? WHERE id=? ",
            [ $tag->{title}, $tag->{description} || "", $id ]);
    }

    return $c;
}

sub delete {
    my $c  = shift;
    my $id = shift;

    $c->sql->Do("
        DELETE FROM indx_rubrics WHERE id =?
            AND id <> '00000000-0000-0000-0000-000000000000' ",
        [ $id ]);

    return $c;
}

1;
