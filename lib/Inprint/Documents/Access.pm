package Inprint::Documents::Access;

# Inprint Content 5.0
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

use Inprint::Store::Embedded;

sub get {

    my ($c, $id) = @_;

    my $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $id ])->Hash;

    my %access = ();

    my @rules = qw(
       documents.update
       documents.capture
       documents.move
       documents.transfer
       documents.briefcase
       documents.delete
       documents.recover
       documents.discuss
       files.add
       files.delete
       files.work
    );

    my $current_member = $c->QuerySessionGet("member.id");

    foreach (@rules) {

        if ($document->{holder} eq $current_member) {
            if ($c->access->Check(["catalog.$_:*"], $document->{workgroup})) {
                $access{$_} = 1;
            } else {
                $access{$_} = 0;
            }
        }

        if ($document->{holder} ne $current_member) {
            if ($c->access->Check("catalog.$_:group", $document->{workgroup})) {
                $access{$_} = 1;
            } else {
                $access{$_} = 0;
            }
        }

    }

    return \%access;
}

1;
