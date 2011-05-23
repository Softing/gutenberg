package Inprint::Documents::Text;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Documents::Access;
use Inprint::Store::Embedded;

use base 'Mojolicious::Controller';

sub get {
    my $c = shift;

    my @errors;
    my $access;
    my $result;

    my $i_file = $c->param("file");
    my $i_document = $c->param("document");

    $c->check_uuid( \@errors, "file", $i_file);
    $c->check_uuid( \@errors, "file", $i_document);

    my $file = $c->Q(" SELECT * FROM cache_files WHERE id=? ", $i_file)->Hash;
    my $document = $c->Q(" SELECT * FROM documents WHERE id=? ", $i_document)->Hash;

    unless (@errors) {
        $result = Inprint::Store::Embedded::fileRead($c, $file->{id});
        $result->{access} = Inprint::Documents::Access::get($c, $document->{id});
    }

    $result ->{text} =~ s/<p[^>]*>//g;
    $result ->{text} =~ s/<\/p>/<br \/>/g;

    $c->smart_render(\@errors, $result);
}

sub set {
    my $c = shift;

    my $html;
    my $access;

    my @errors;

    my $i_file = $c->param("file");
    my $i_text = $c->param("text");
    my $i_document = $c->param("document");

    $c->check_uuid( \@errors, "file", $i_file);
    $c->check_uuid( \@errors, "document", $i_document);

    my $file = $c->check_record(\@errors, "cache_files", "file", $i_file);
    my $document = $c->check_record(\@errors, "documents", "document", $i_document);

    unless (@errors) {
        $access = Inprint::Documents::Access::get($c, $document->{id});

        if ($access->{"fedit"}) {
            $html = Inprint::Store::Embedded::fileSave($c, $file->{id}, $i_text);
        } else {
            $html = $i_text;
            push @errors, { id => "access", msg => "Access denide" };
        }
    }

    my $result = {
        text => $html,
        access => $access
    };

    $c->smart_render(\@errors, $result);
}

1;
