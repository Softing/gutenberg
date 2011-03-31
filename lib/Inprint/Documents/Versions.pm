package Inprint::Documents::Versions;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;



use base 'Inprint::BaseController';

sub list {
    my $c = shift;

    my $i_file = $c->param("file");

    my @errors;
    my $success = $c->json->false;

    #$c->check_uuid( \@errors, "document", $i_oid);
    #my $html = Inprint::Store::Embedded::fileRead($c, $i_oid);

    my @data;

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => \@data } );
}

1;
