package Inprint::Advertising::Index;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Inprint::BaseController';

sub save {
    my $c = shift;

    my $i_edition   = $c->param("edition");
    my $i_type = $c->param("type");
    my @i_ids  = $c->param("entity");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));
        
    push @errors, { id => "type", msg => "Incorrectly filled field"}
        unless ($i_type ~~ [ "headline", "module" ]);
    
    my $edition; unless (@errors) {
        $edition  = $c->sql->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($edition);
    }
    
    unless (@errors) {
        
        $c->sql->Do("
                DELETE FROM ad_index WHERE edition=? AND nature=?
            ", [ $edition->{id}, $i_type ]);
        
        #die "$edition->{id}, $i_type";
        
        foreach my $item (@i_ids) {
            
            next unless ($c->is_uuid($item));
            
            $c->sql->Do("
                INSERT INTO ad_index(edition, nature, entity, created, updated)
                    VALUES (?, ?, ?, now(), now());
            ", [ $edition->{id}, $i_type, $item ]);
        }
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub headlines {
    
    my $c = shift;
    
    my $i_edition = $c->param("edition");
    
    my $result = [];
    
    my $sql;
    my @params;
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));
    
    my $edition; unless (@errors) {
        $edition  = $c->sql->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($edition);
    }
    
    my $editions = []; unless (@errors) {
        $editions = $c->sql->Q("
            SELECT id FROM editions WHERE path @> ? order by path asc; 
        ", [ $edition->{path} ])->Values;
    }
    
    unless (@errors) {
        $sql = "
            SELECT
                t1.id, t1.edition, t1.nature, t1.parent, t1.title, t1.shortcut, t1.description, t1.created, t1.updated,
                EXISTS(SELECT true FROM ad_index WHERE edition=t1.edition AND entity=t1.id) as selected
            FROM index t1
            WHERE t1.edition = ANY(?) AND t1.nature='headline'
            ORDER BY shortcut
        ";
        push @params, $editions;
    }
    
    unless (@errors) {
        $result = $c->sql->Q(" $sql ", \@params)->Hashes;
        $c->render_json( { data => $result } );
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub modules {
    
    my $c = shift;
    
    my $i_edition = $c->param("edition");
    
    my $result = [];
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));
    
    my $edition; unless (@errors) {
        $edition  = $c->sql->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($edition);
    }
    
    my $sql;
    my @params;
    
    unless (@errors) {
        $sql = "
            SELECT
                t1.id, t1.edition, t1.page, t1.title, t1.shortcut, t1.description, t1.amount, t1.area, t1.x, t1.y, t1.w, t1.h, t1.created, t1.updated,
                t2.id as page, t2.shortcut as page_shortcut,
                EXISTS(SELECT true FROM ad_index WHERE edition=t1.edition AND entity=t1.id) as selected
            FROM ad_modules t1, ad_pages t2
            WHERE t2.id = t1.page AND t1.edition=?
            ORDER BY t2.shortcut, t1.shortcut
        ";
        push @params, $edition->{id};
    }
    
    unless (@errors) {
        $result = $c->sql->Q(" $sql ", \@params)->Hashes;
        $c->render_json( { data => $result } );
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

1;
