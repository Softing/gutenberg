package Inprint::Common::List;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use utf8;
use feature qw(switch say);

use base 'Inprint::BaseController';

sub ParseFilters {
    my $c = shift;
    my @filter = split ',', $c->param("filter");
    return \@filter;
}

sub editions {
    my $c = shift;
    my $filters = $c->ParseFilters();
    
    my $sql = " SELECT uuid, name as title, sname as stitle FROM edition.edition WHERE deleted<>true ";
    
    my $result = $c->sql->Q($sql)->Hashes;
    
    unshift @$result, { name=> 'Любое издание', id=>0 } if 'any' ~~ $filters;
    
    $c->render_json($result || []);
}

1;
