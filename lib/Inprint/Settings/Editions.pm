package Inprint::Settings::Editions;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub list {
    my $c = shift;
    
    my $result = $c->sql->Q("SELECT * FROM edition.edition ")->Hashes;
    
    $c->render_json({ data => $result });
}

1;
