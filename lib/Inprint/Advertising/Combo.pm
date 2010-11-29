package Inprint::Advertising::Combo;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Inprint::BaseController';

sub editions {
    my $c = shift;
    my $result = $c->sql->Q("
        SELECT t1.id, t1.shortcut as title, nlevel(path) as nlevel, description,
            array_to_string( ARRAY( SELECT shortcut FROM editions WHERE path @> t1.path ORDER BY nlevel(path) ), '.') as title_path
        FROM editions t1
        ORDER BY title_path
    ")->Hashes;
    $c->render_json( { data => $result } );
}

sub fascicles {
    my $c = shift;
    
    my $i_term = $c->param("term") || undef;
    
    my @data;
    my $sql = "
        SELECT t1.id, t2.shortcut || '/' || t1.shortcut as title, t1.shortcut, t1.description,
            CASE WHEN enabled is true THEN  'rocket-fly' ELSE 'book' END as icon
        FROM fascicles t1, editions t2
        WHERE t2.id = t1.edition AND issystem = false
    ";
    
    if ($i_term) {
        my $access = $c->access->GetBindingsByTerm($i_term);
        $sql .= " AND edition = ANY(?) ";
        push @data, $access;
    }
    
    my $result = $c->sql->Q("
        $sql
        ORDER BY enabled DESC, t2.shortcut, t1.shortcut
    ", \@data)->Hashes;
    $c->render_json( { data => $result } );
}


1;
