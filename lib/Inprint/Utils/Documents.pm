package Inprint::Utils::Documents;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

sub MoveDocumentIndexToFascicle {

    die 1;

    my $c = shift;
    my $errors = shift;
    my $i_document = shift;

    my $document = $c->Q(" SELECT * FROM documents WHERE id=? ", [ $i_document ])->Hash;
    unless ($document->{id}) {
        push @$errors, { id => "document", msg => "Can't find object"};
        return;
    }

    my $edition = $c->Q(" SELECT * FROM editions  WHERE id=? ", [ $document->{edition} ])->Hash;
    unless ($edition->{id}) {
        push @$errors, { id => "edition", msg => "Can't find object"};
        return;
    }

    my $fascicle = $c->Q(" SELECT * FROM fascicles WHERE id=? ", [ $document->{fascicle} ])->Hash;
    unless ($fascicle->{id}) {
        push @$errors, { id => "fascicle", msg => "Can't find object"};
        return;
    }

    # Briefcase
    if ($fascicle->{id} eq '00000000-0000-0000-0000-000000000000') {
        my $headline = Inprint::Utils::Headlines::Create($c, $edition->{id}, $fascicle->{id}, $document->{headline_shortcut}, $document->{headline_shortcut}, $document->{headline_shortcut});
        my $rubric   = Inprint::Utils::Rubrics::Create($c, $edition->{id}, $fascicle->{id}, $headline->{id}, $document->{rubric_shortcut}, $document->{rubric_shortcut}, $document->{rubric_shortcut});
        return;
    }

    # TrashCan
    if ($fascicle->{id} eq '99999999-9999-9999-9999-999999999999') {
        my $headline = Inprint::Utils::Headlines::Create($c, $edition->{id}, $fascicle->{id}, $document->{headline_shortcut}, $document->{headline_shortcut}, $document->{headline_shortcut});
        my $rubric   = Inprint::Utils::Rubrics::Create($c, $edition->{id}, $fascicle->{id}, $headline->{id}, $document->{rubric_shortcut}, $document->{rubric_shortcut}, $document->{rubric_shortcut});
        return;
    }

    # Regular fascicle

    my $editions = $c->Q(" SELECT id FROM editions WHERE path @> ? order by path asc ", [ $edition->{path} ])->Values;

    # Check, if headline exist in this fascicle

    my $headline = $c->Q("
        SELECT * FROM fascicles_indx_headlines WHERE fascicle=? AND lower(shortcut)=lower(?) ",
        [ $fascicle->{id}, $document->{headline_shortcut} ])->Hash;

    my $rubric = $c->Q("
        SELECT * FROM fascicles_indx_rubrics WHERE fascicle=? AND headline=? AND lower(shortcut)=lower(?) ",
        [ $fascicle->{id}, $headline->{id}, $document->{rubric_shortcut} ])->Hash;

    unless ($headline->{id} || $headline->{shortcut}) {

        my $source_headline = $c->Q("
                SELECT title, shortcut, description FROM fascicles_indx_headlines
                WHERE edition=ANY(?) AND lower(shortcut)=lower(?) LIMIT 1",
            [ $editions, $document->{headline_shortcut} ])->Hash;

        if ($source_headline->{shortcut}) {
            $headline = Inprint::Utils::Headlines::Create($c, $edition->{id}, $fascicle->{id}, $source_headline->{title}, $source_headline->{shortcut}, $source_headline->{description} );
        } else {
            $headline = Inprint::Utils::Headlines::Create($c, $edition->{id}, $fascicle->{id}, "--", "--", "--" );
        }
    }

    if ($headline->{id} && $headline->{shortcut}) {
        $c->Do(" UPDATE documents SET headline=?, headline_shortcut=? WHERE id=?", [ $headline->{id}, $headline->{shortcut}, $document->{id} ]);
    }

    unless($rubric->{id} || $rubric->{shortcut}) {

        my $source_rubric = $c->Q("
                SELECT title, shortcut, description FROM fascicles_indx_rubrics
                WHERE edition=ANY(?) AND lower(shortcut)=lower(?) LIMIT 1",
            [ $editions, $document->{rubric_shortcut} ])->Hash;

        if ($source_rubric->{shortcut}) {
            $rubric = Inprint::Utils::Rubrics::Create($c, $edition->{id}, $fascicle->{id}, $headline->{id}, $source_rubric->{title}, $source_rubric->{shortcut}, $source_rubric->{description} );

        } else {
            $rubric = Inprint::Utils::Rubrics::Create($c, $edition->{id}, $fascicle->{id}, $headline->{id}, "--", "--", "--" );
        }
    }


    if ($rubric->{id} && $rubric->{shortcut}) {
        $c->Do(" UPDATE documents SET rubric=?, rubric_shortcut=? WHERE id=?", [ $rubric->{id}, $rubric->{shortcut}, $document->{id} ]);
    }

    #die 3;
    return;
}

1;
