package Inprint::Documents::Text;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use HTML::Scrubber;

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

    $result->{text} = __clearHtml($result->{text});

    $result->{text} =~ s/^\s+|\s+$//ig;
    $result->{text} =~ s/<font><font>//ig;
    $result->{text} =~ s/<\/font><\/font>//ig;

    $result->{text} =~ s/<table/<table border=1/ig;

    $result->{text} =~ s/\t+/ /ig;
    $result->{text} =~ s/\s+/ /ig;

    $result->{text} =~ s/<p[^>]*>/<br \/>/ig;
    $result->{text} =~ s/<\/p>//ig;

    $result->{text} =~ s/<br>/<br \/>/ig;
    $result->{text} =~ s/(<br \/>)+/<br \/>/ig;
    $result->{text} =~ s/^(<br \/>)+//ig;
    $result->{text} =~ s/(<br \/>)+$//ig;

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
            push @errors, { id => "access", msg => "Access denied" };
        }
    }

    $html = __clearHtml($html);

    my $result = {
        text => $html,
        access => $access
    };

    $c->smart_render(\@errors, $result);
}

sub __clearHtml {

    my $html = shift;

    my $scrubber = HTML::Scrubber->new(
        allow => [
         qw[ p br b i u ol strong em ul li sub sup table col tr td th tbody ]
        ]);
    $scrubber->rules(

        table =>{
            border => 1,
            width => 1,
            bordercolor => 1,
            cellspacing => 1,
            cellpadding => 1,
            '*' => 0
        },

        tr => {
            valign => 1,
            '*'    => 0
        },

        col =>
        {
            width => 1,
            '*'   => 0
        },

        td =>
        {
            width   => 1,
            colspan => 1,
            rowspan => 1,
            '*'     => 0
        },

        p =>
        {
            style => 1,
            '*'   => 0
        },

        span =>
        {
            style => 1,
            '*'   => 0
        },

        font =>
        {
            size  => 0,
            color => 1,
            style => 0,
            '*'   => 0,
        }

    );

    $html =~ s/<title>(.*?)<\/title>//ig;
    $html = $scrubber->scrub($html);

    return $html;
}

1;
