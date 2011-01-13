package Inprint::Documents::Rss;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Rss;

use base 'Inprint::BaseController';

sub read {

    my $c = shift;

    my $i_document = $c->param("document") || undef;

    my @errors;
    my $success = $c->json->false;

    my $result = Inprint::Models::Rss::read($c, $i_document);

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}


sub update {

    my $c = shift;

    my $i_document    = $c->param("document") || undef;
    my $i_published   = $c->param("published") || undef;
    my $i_link        = $c->param("link") || undef;
    my $i_title       = $c->param("title") || undef;
    my $i_description = $c->param("description") || undef;
    my $i_fulltext    = $c->param("fulltext") || undef;

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "document", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_document));

    my $document;
    unless (@errors) {
        $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $i_document ])->Hash;
    }
    push @errors, { id => "document", msg => "Can't find object"}
        unless ($document->{id});

    unless (@errors) {

        my $enabled = 0;
        if ($i_published eq "on") {
            $enabled = 1;
        }

        Inprint::Models::Rss::update($c, $document->{id}, $enabled, $i_link, $i_title, $i_description, $i_fulltext);

        $success = $c->json->true;
    }


    $c->render_json( { success => $success } );
}

1;
