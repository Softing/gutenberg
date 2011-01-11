package Inprint::Models::Headline;

use strict;
use warnings;

use Inprint::Models::Tag;

sub create {
    my $c = shift;

    my ($id, $edition, $bydefault, $title, $description ) = @_;

    my $tag = Inprint::Models::Tag::getByTitle($c, $title, $description);

    if ($tag->{id}) {
        $c->sql->Do("
            INSERT INTO indx_headlines (id, edition, tag, title, description, created, updated)
                VALUES (?, ?, ?, ?, ?, now(), now());
            ", [ $id, $edition, $tag->{id}, $tag->{title}, $tag->{description} || "" ]);
        if ($bydefault eq "on") {
            $c->sql->Do("
                UPDATE indx_headlines SET bydefault=false WHERE edition=?;
                ", [ $edition ]);
            $c->sql->Do("
                UPDATE indx_headlines SET bydefault=true WHERE id=?;
                ", [ $id ]);
        }
    }

    return $c;
}

sub read {
    my $c = shift;
    my $id = shift;

    my $result = $c->sql->Q("
        SELECT id, edition, tag, title, description, bydefault, created, updated
        FROM indx_headlines WHERE id=? ",
        [ $id ])->Hash;

    return $result;
}

sub update {
    my $c = shift;
    my ($id, $edition, $bydefault, $title, $description ) = @_;

    my $tag = Inprint::Models::Tag::getByTitle($c, $title, $description);

    if ($tag->{id}) {
        $c->sql->Do(" UPDATE indx_headlines SET title=?, description=? WHERE id=? ",
            [ $tag->{title}, $tag->{description} || "", $id ]);
        if ($bydefault eq "on") {
            $c->sql->Do("
                UPDATE indx_headlines SET bydefault=false WHERE edition=?;
                ", [ $edition ]);
            $c->sql->Do("
                UPDATE indx_headlines SET bydefault=true WHERE id=?;
                ", [ $id ]);
        }
    }

    return $c;
}

sub delete {
    my $c  = shift;
    my $id = shift;

    $c->sql->Do("
        DELETE FROM indx_rubrics WHERE headline=? ",
        [ $id ]);

    $c->sql->Do("
        DELETE FROM indx_headlines WHERE id =?
            AND id <> '00000000-0000-0000-0000-000000000000' ",
        [ $id ]);

    return $c;
}


1;
