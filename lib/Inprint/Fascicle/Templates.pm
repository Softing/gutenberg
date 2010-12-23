package Inprint::Fascicle::Templates;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Utils::Pages;

use base 'Inprint::BaseController';

sub modules {
    my $c = shift;
    
    my $i_fascicle = $c->param("fascicle");
    
    my $sql;
    my @params;
    
    my @errors;
    my $success = $c->json->false;
    
    my $result = [];
    
    $sql = "
        SELECT
            t1.id,
            t1.origin, t1.fascicle, 
            t2.id as place, t2.shortcut as place_shortcut,
            t1.shortcut, t1.description
        FROM
            fascicles_tmpl_modules t1,
            fascicles_tmpl_places t2,
            fascicles_tmpl_index t3
        WHERE
            t1.fascicle=?
            AND t3.entity = t1.id
            AND t3.nature='module'
            AND t3.place=t2.id
        ORDER BY t2.shortcut, t1.shortcut
    ";
    
    push @params, $i_fascicle;
    
    unless (@errors) {
        $result = $c->sql->Q(" $sql ", \@params)->Hashes;
        $c->render_json( { data => $result } );
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}


1;