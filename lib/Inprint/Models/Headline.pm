package Inprint::Models::Headline;

use strict;
use warnings;

use Inprint::Models::Tag;
use Inprint::Models::Fascicle::Headline;

sub create {
    my $c = shift;

    my ($id, $edition, $bydefault, $title, $description ) = @_;

    # Validate input

    my $tag = Inprint::Models::Tag::getByTitle($c, $title, $description);
    return $c unless $tag->{id};

    # Do query

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

    # Update Briefcase
    my $exists = $c->sql->Q("
        SELECT id FROM fascicles_indx_headlines WHERE fascicle=? AND tag=? ",
        [ "00000000-0000-0000-0000-000000000000", $tag->{id} ])->Value;

    unless ($exists) {
        Inprint::Models::Fascicle::Headline::create(
            $c, $c->{uuid},
            "00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000", undef, $tag->{title}, $tag->{description});
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

    # Validate input

    my $tag = Inprint::Models::Tag::getByTitle($c, $title, $description);
    return $c unless $tag->{id};

    my $headline = $c->sql->Q("
        SELECT id, tag, title, description FROM indx_headlines WHERE id=? ",
        [ $id ])->Hash;
    return $c unless $headline->{id};

    # Do query

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

    # Update Briefcase
    my $exists = $c->sql->Q("
        SELECT id FROM fascicles_indx_headlines WHERE fascicle=? AND tag=? ",
        [ "00000000-0000-0000-0000-000000000000", $tag->{id} ])->Value;

    if ($exists) {
        Inprint::Models::Fascicle::Headline::update(
            $c, $exists,
            "00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000", undef, $tag->{title}, $tag->{description});
    } else {
        Inprint::Models::Fascicle::Headline::create(
            $c, $c->{uuid},
            "00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000", undef, $tag->{title}, $tag->{description});
    }

    return $c;
}

sub delete {
    my $c  = shift;
    my $id = shift;

    my $headline = $c->sql->Q("
        SELECT * FROM indx_headlines WHERE id =? ",
        [ $id ])->Value;

    return unless ($headline->{id});

    $c->sql->Do("
        DELETE FROM indx_rubrics WHERE headline=? ",
        [ $headline->{id} ]);

    $c->sql->Do("
        DELETE FROM indx_headlines WHERE id =?
            AND id <> '00000000-0000-0000-0000-000000000000' ",
        [ $headline->{id} ]);

    my $briefcase_headline = $c->sql->Q("
        SELECT * FROM fascicles_indx_headlines
        WHERE fascicle = '00000000-0000-0000-0000-000000000000' AND tag=?",
        [ $headline->{tag} ])->Value;

    return unless ($briefcase_headline->{id});

    my $linked = $c->sql->Q("
        SELECT count(*) FROM documents WHERE headline=? ",
        [ $briefcase_headline->{id} ])->Value;

    return unless ($linked == 0);

    $c->sql->Do("
        DELETE FROM fascicles_indx_rubrics
        WHERE AND fascicle == '00000000-0000-0000-0000-000000000000' AND headline=? ",
        [ $briefcase_headline->{id} ]);

    $c->sql->Do("
        DELETE FROM fascicles_indx_headlines
        WHERE AND fascicle == '00000000-0000-0000-0000-000000000000' AND id=? ",
        [ $briefcase_headline->{id} ]);

    return $c;
}


1;
