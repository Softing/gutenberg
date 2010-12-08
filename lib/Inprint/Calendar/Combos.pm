package Inprint::Calendar::Combos;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub copypages {
    my $c = shift;
    
    my $i_term = $c->param("term") || undef;
    
    my @data;
    my $sql = "
        SELECT t1.id, t2.shortcut || '/' || t1.shortcut as title, t1.shortcut, t1.description,
            CASE WHEN is_enabled is true THEN  'rocket-fly' ELSE 'book' END as icon
        FROM fascicles t1, editions t2
        WHERE t2.id = t1.edition AND is_enabled = true AND is_system = false
    ";
    
    my $access = $c->access->GetBindings("editions.calendar.manage");
    $sql .= " AND edition = ANY(?) ";
    push @data, $access;
    
    my $result = $c->sql->Q("
        $sql
        ORDER BY is_enabled DESC, t2.shortcut, t1.shortcut
    ", \@data)->Hashes;
    $c->render_json( { data => $result } );
}

sub copyindex {
    my $c = shift;
    
    my $i_term = $c->param("term") || undef;
    
    my @data;
    my $sql = "
        SELECT t1.id, t2.shortcut || '/' || t1.shortcut as title, t1.shortcut, t1.description,
            CASE WHEN is_enabled is true THEN  'rocket-fly' ELSE 'book' END as icon
        FROM fascicles t1, editions t2
        WHERE t2.id = t1.edition AND is_enabled = true AND is_system = false
    ";
    
    my $access = $c->access->GetBindings("editions.calendar.manage");
    $sql .= " AND edition = ANY(?) ";
    push @data, $access;
    
    my $result = $c->sql->Q("
        $sql
        ORDER BY is_enabled DESC, t2.shortcut, t1.shortcut
    ", \@data)->Hashes;
    
    unshift @$result, {
        id=> "00000000-0000-0000-0000-000000000000",
        icon => "marker",
        title=> $c->l("From index"),
        shortcut=> $c->l("From index"),
        description=> $c->l("Copy from common index"),
    };
    
    $c->render_json( { data => $result } );
}


1;
