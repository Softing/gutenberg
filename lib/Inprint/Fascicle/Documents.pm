package Inprint::Fascicle::Documents;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

#use Inprint::Utils;
use Inprint::Documents;

use base 'Inprint::BaseController';

sub list {
    my $c = shift;
    Inprint::Documents::list($c);
}

1;
