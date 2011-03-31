package Inprint::Documents::Access;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Mojolicious::Controller';

use Inprint::Store::Embedded;

sub get {

    my ($c, $id) = @_;

    my $document = $c->Q(" SELECT * FROM documents WHERE id=? ", [ $id ])->Hash;

    my %access = ();
    my $current_member = $c->getSessionValue("member.id");
    my @rules = qw( update capture move transfer briefcase delete recover discuss fadd fdelete fedit );

    foreach (@rules) {

        if ($document->{holder} eq $current_member) {
            if ($c->objectAccess(["catalog.documents.$_:*"], $document->{workgroup})) {
                $access{$_} = 1;
            } else {
                $access{$_} = 0;
            }
        }

        if ($document->{holder} ne $current_member) {
            if ($c->objectAccess("catalog.documents.$_:group", $document->{workgroup})) {
                $access{$_} = 1;
            } else {
                $access{$_} = 0;
            }
        }

    }

    return \%access;
}

1;
