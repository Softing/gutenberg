package Inprint::Documents::Access;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub get {

    my ($c, $id) = @_;

    my $document = $c->Q(" SELECT * FROM documents WHERE id=? ", [ $id ])->Hash;
    my $fascicle = $c->Q(" SELECT * FROM fascicles WHERE id=? ", [ $document->{fascicle} ])->Hash;

    my %access = ();
    my $current_member = $c->getSessionValue("member.id");
    my @rules = qw( update capture move transfer briefcase delete recover discuss fadd fdelete fedit );

    foreach (@rules) {

        if ( $fascicle->{archived} && $_ ne "move ") {
            $access{$_} = $c->json->false;
            next;
        }

        if ($document->{holder} eq $current_member) {
            if ($c->objectAccess(["catalog.documents.$_:*"], $document->{workgroup})) {
                $access{$_} = $c->json->true;
            } else {
                $access{$_} = $c->json->false;
            }
        }

        if ($document->{holder} ne $current_member) {
            if ($c->objectAccess("catalog.documents.$_:group", $document->{workgroup})) {
                $access{$_} = $c->json->true;
            } else {
                $access{$_} = $c->json->false;
            }
        }

    }

    return \%access;
}

1;
