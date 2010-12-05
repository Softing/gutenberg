package Inprint::Fascicle::Combos;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub headlines {
    my $c = shift;
    
    my $i_edition  = $c->param("edition") || undef;
    my $i_fascicle = $c->param("fascicle") || undef;
    
    my $result;
    my @errors;
    my $success = $c->json->false;
    
    #push @errors, { id => "edition", msg => "Incorrectly filled field"}
    #    unless ($c->is_uuid($i_edition));
    
    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));
    
    unless (@errors) {
        #$result = $c->sql->Q("
        #    SELECT DISTINCT t1.id, t1.shortcut as title FROM index t1, index_mapping t2
        #    WHERE t1.edition=? AND t2.parent=? AND t1.id = t2.child
        #    ORDER BY t1.shortcut
        #", [ $i_edition, $i_fascicle ])->Hashes;
        $result = $c->sql->Q("
            SELECT DISTINCT t1.id, t1.shortcut as title FROM index t1, index_mapping t2
            WHERE t2.parent=? AND t1.id = t2.child
            ORDER BY t1.shortcut
        ", [ $i_fascicle ])->Hashes;
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $result || [] });
}

sub rubrics {
    my $c = shift;
    my $i_headline = $c->param("headline") || undef;
    
    my $result;
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "headline", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_headline));
    
    unless (@errors) {
        $result = $c->sql->Q("
            SELECT DISTINCT t1.id, t1.shortcut as title FROM index t1, index_mapping t2
            WHERE t2.parent=? AND t1.id = t2.child
            ORDER BY t1.shortcut
        ", [ $i_headline ])->Hashes;
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $result || [] });
}


1;
