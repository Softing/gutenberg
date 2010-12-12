package Inprint::Utils::Documents;
use strict;
use warnings;

sub TransferDocumentToPrincipal {
    my $c = shift;
    my $document = shift;
    my $principal = shift;
    
    
}

sub MoveDocumentIndexToFascicle {
    
    my $c = shift;
    my $errors = shift;
    my $i_document = shift;
    
    my $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $i_document ])->Hash;
    unless ($document->{id}) {
        push @$errors, { id => "document", msg => "Can't find object"};
        return;
    }
    
    my $edition = $c->sql->Q(" SELECT * FROM editions  WHERE id=? ", [ $document->{edition} ])->Hash;
    unless ($edition->{id}) {
        push @$errors, { id => "edition", msg => "Can't find object"};
        return;
    }
    
    my $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $document->{fascicle} ])->Hash;
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
    
    my $editions = $c->sql->Q(" SELECT id FROM editions WHERE path @> ? order by path asc ", [ $edition->{path} ])->Values;
    
    # Check, if headline exist in this fascicle
    
    my $headline = $c->sql->Q("
            SELECT * FROM index_fascicles WHERE fascicle=? AND nature='headline' AND lower(shortcut) = lower(?) ",
        [ $fascicle->{id}, $document->{headline_shortcut} ])->Hash;
    
    my $rubric = $c->sql->Q("
            SELECT * FROM index_fascicles WHERE fascicle=? AND parent=? AND nature='rubric' AND lower(shortcut) = lower(?) ",
        [ $fascicle->{id}, $headline->{id}, $document->{rubric_shortcut} ])->Hash;
    
    unless ($headline->{id} || $headline->{shortcut}) {
        
        my $source_headline = $c->sql->Q("
                SELECT title, shortcut, description FROM index_fascicles
                WHERE edition = ANY(?) AND nature='headline' AND lower(shortcut) = lower(?) LIMIT 1",
            [ $editions, $document->{headline_shortcut} ])->Hash;
        
        if ($source_headline->{shortcut}) {
            $headline = Inprint::Utils::Headlines::Create($c, $edition->{id}, $fascicle->{id}, $source_headline->{title}, $source_headline->{shortcut}, $source_headline->{description} );
        } else {
            $headline = Inprint::Utils::Headlines::Create($c, $edition->{id}, $fascicle->{id}, "--", "--", "--" );
        }
    }
    
    if ($headline->{id} && $headline->{shortcut}) {
        $c->sql->Do(" UPDATE documents SET headline=?, headline_shortcut=? WHERE id=?", [ $headline->{id}, $headline->{shortcut}, $document->{id} ]);
    }
    
    unless($rubric->{id} || $rubric->{shortcut}) {
        
        my $source_rubric = $c->sql->Q("
                SELECT title, shortcut, description FROM index_fascicles
                WHERE edition = ANY(?) AND nature='rubric' AND lower(shortcut) = lower(?) LIMIT 1",
            [ $editions, $document->{rubric_shortcut} ])->Hash;
        
        if ($source_rubric->{shortcut}) {
            $rubric = Inprint::Utils::Rubrics::Create($c, $edition->{id}, $fascicle->{id}, $headline->{id}, $source_rubric->{title}, $source_rubric->{shortcut}, $source_rubric->{description} );
            
        } else {
            $rubric = Inprint::Utils::Rubrics::Create($c, $edition->{id}, $fascicle->{id}, $headline->{id}, "--", "--", "--" );
        }
    }
    
    
    if ($rubric->{id} && $rubric->{shortcut}) {
        $c->sql->Do(" UPDATE documents SET rubric=?, rubric_shortcut=? WHERE id=?", [ $rubric->{id}, $rubric->{shortcut}, $document->{id} ]);
    }
    
    #die 3;
    return;
}

1;