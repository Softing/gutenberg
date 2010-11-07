package Inprint::Access;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Inprint::BaseController';

sub index {
    my $c = shift;
    my $term     = $c->param("term");
    my $binding  = $c->param("binding");
    
    my $success = $c->json->false;
    
    my $count = $c->access->One($term, $binding);
    
    if ( $count ) {
        $success = $c->json->true;
    }
    
    return $c->render_json({
        success => $success
    });
}


1;
