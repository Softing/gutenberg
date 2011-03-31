package Inprint::Models::Rubric;

use strict;
use warnings;

use Inprint::Models::Tag;
use Inprint::Models::Fascicle::Headline;
use Inprint::Models::Fascicle::Rubric;

sub create {
    my $c = shift;

    my ($id, $edition, $headline, $bydefault, $title, $description ) = @_;

    # Validate input

    my $tag = Inprint::Models::Tag::getByTitle($c, $title, $description);
    return $c unless $tag->{id};

    $headline = $c->Q("
        SELECT id, tag, title, description FROM indx_headlines WHERE id=? ",
        [ $headline ])->Hash;
    return $c unless $headline->{id};

    # Do query

    $c->Do("
        INSERT INTO indx_rubrics (id, edition, headline, tag, title, description, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, now(), now());
        ", [ $id, $edition, $headline->{id}, $tag->{id}, $tag->{title}, $tag->{description} || "" ]);

    if ($bydefault eq "on") {
        $c->Do("
            UPDATE indx_rubrics SET bydefault=false WHERE headline=?;
            ", [ $headline->{id} ]);
        $c->Do("
            UPDATE indx_rubrics SET bydefault=true WHERE id=?;
            ", [ $id ]);
    }

    # Update Briefcase
    my $briefcase_headline = $c->Q("
        SELECT id FROM fascicles_indx_headlines WHERE fascicle=? AND tag=? ",
        [ "00000000-0000-0000-0000-000000000000", $headline->{tag} ])->Value;

    unless ($briefcase_headline) {
        $briefcase_headline = $c->uuid;
        Inprint::Models::Fascicle::Headline::create(
            $c, $briefcase_headline,
            "00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000", 0, $headline->{title}, $headline->{description});
    }

    my $exists = $c->Q("
        SELECT id FROM fascicles_indx_rubrics WHERE fascicle=? AND headline=? AND tag=? ",
        [ "00000000-0000-0000-0000-000000000000", $briefcase_headline, $tag->{id} ])->Value;

    unless ($exists) {
        Inprint::Models::Fascicle::Rubric::create(
            $c, $c->uuid,
            "00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000", $briefcase_headline, 0, $tag->{title}, $tag->{description});
    }

    return $c;
}

sub read {
    my $c = shift;
    my $id = shift;

    my $result = $c->Q("
        SELECT id, edition, headline, tag, title, description, created, updated
        FROM indx_rubrics WHERE id=? ",
        [ $id ])->Hash;

    return $result;
}

sub update {
    my $c = shift;
    my ($id, $edition, $headline, $bydefault, $title, $description ) = @_;

    # Validate input

    my $tag = Inprint::Models::Tag::getByTitle($c, $title, $description);
    return $c unless $tag->{id};

    my $rubric = $c->Q("
        SELECT id, tag, title, description FROM indx_rubrics WHERE id=? ",
        [ $id ])->Hash;
    return $c unless $rubric->{id};

    $headline = $c->Q("
        SELECT id, tag, title, description FROM indx_headlines WHERE id=? ",
        [ $headline ])->Hash;
    return $c unless $headline->{id};

    # Do query

    $c->Do(" UPDATE indx_rubrics SET tag=?, title=?, description=? WHERE id=? ",
        [ $tag->{id}, $tag->{title}, $tag->{description} || "", $rubric->{id} ]);

    if ($bydefault eq "on") {
        $c->Do("
            UPDATE indx_rubrics SET bydefault=false WHERE headline=?;
            ", [ $headline ]);
        $c->Do("
            UPDATE indx_rubrics SET bydefault=true WHERE id=?;
            ", [ $rubric->{id} ]);
    }

    # Update Briefcase Headline
    my $briefcase_headline = $c->Q("
        SELECT id FROM fascicles_indx_headlines WHERE fascicle=? AND tag=? ",
        [ "00000000-0000-0000-0000-000000000000", $headline->{tag} ])->Value;

    unless ($briefcase_headline) {
        $briefcase_headline = $c->uuid;
        Inprint::Models::Fascicle::Headline::create(
            $c, $briefcase_headline,
            "00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000", 0, $headline->{title}, $headline->{description});
    }

    my $exists = $c->Q("
        SELECT id FROM fascicles_indx_rubrics WHERE fascicle=? AND headline=? AND id=? ",
        [ "00000000-0000-0000-0000-000000000000", $briefcase_headline, $id ])->Value;

    unless ($exists) {
        Inprint::Models::Fascicle::Rubric::create(
            $c, $c->uuid,
            "00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000", $briefcase_headline, 0, $tag->{title}, $tag->{description});
    } else {
        Inprint::Models::Fascicle::Rubric::update(
            $c, $exists,
            "00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000", $briefcase_headline, 0, $tag->{title}, $tag->{description});
    }


    return $c;
}

sub delete {
    my $c  = shift;
    my $id = shift;

    my $rubric = $c->Q("
        SELECT * FROM indx_rubrics WHERE id =? ",
        [ $id ])->Hash;

    return unless ($rubric->{id});

    $c->Do("
        DELETE FROM indx_rubrics WHERE id =?
            AND id <> '00000000-0000-0000-0000-000000000000' ",
        [ $rubric->{id} ]);

    my $briefcase_rubric = $c->Q("
        SELECT * FROM fascicles_indx_rubrics
        WHERE fascicle = '00000000-0000-0000-0000-000000000000' AND tag=?",
        [ $rubric->{tag} ])->Hash;

    return unless ($briefcase_rubric->{id});

    my $linked = $c->Q("
        SELECT count(*) FROM documents WHERE rubric=? ",
        [ $briefcase_rubric->{id} ])->Value;

    return unless ($linked == 0);

    $c->Do("
        DELETE FROM fascicles_indx_rubrics
        WHERE AND fascicle = '00000000-0000-0000-0000-000000000000' AND id=? ",
        [ $briefcase_rubric->{id} ]);

    return $c;
}

1;
