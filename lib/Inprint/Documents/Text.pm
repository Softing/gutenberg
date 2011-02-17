package Inprint::Documents::Text;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Check;
use Inprint::Store::Embedded;

use base 'Inprint::BaseController';

sub get {
    my $c = shift;

    my $i_oid = $c->param("oid");

    my @errors;
    my $success = $c->json->false;

    Inprint::Check::uuid($c, \@errors, "document", $i_oid);
    my $html = Inprint::Store::Embedded::fileRead($c, $i_oid);

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $html } );
}

sub set {
    my $c = shift;

    my $i_oid  = $c->param("oid");
    my $i_text = $c->param("text");

    my $data;
    my @errors;
    my $success = $c->json->false;

    my $html = Inprint::Store::Embedded::fileSave($c, $i_oid, $i_text);

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $data } );

}

1;
