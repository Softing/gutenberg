package Inprint::Documents::Files;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Check;
use Inprint::Store::Embedded;

use base 'Inprint::BaseController';

sub list {
    my $c = shift;

    my $i_document = $c->param("document");

    my @errors;
    my $success = $c->json->false;

    Inprint::Check::uuid($c, \@errors, "document", $i_document);
    my $document = Inprint::Check::document($c, \@errors, $i_document);

    my @result;
    unless (@errors) {

        my $folder = Inprint::Store::Embedded::getFolderPath($c, "documents", $document->{created}, $document->{id}, 1);
        my $files = Inprint::Store::Embedded::findFiles($c, $folder, 'all', ['doc', 'xls', 'rtf', 'odt', 'png', 'jpg', 'gif']);

        foreach my $record (@$files) {
            push @result, {
                name         => $record->{name},
                description  => $record->{description},
                cache        => $record->{cache},
                isdraft      => $record->{isdraft},
                isapproved   => $record->{isapproved},
                size         => $record->{size},
                created      => $record->{created},
                updated      => $record->{updated},
            };
        }

    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => \@result });
}

sub create {
    my $c = shift;

    my $i_document    = $c->param("document");
    my $i_filename    = $c->param("filename");
    my $i_description = $c->param("description");

    my @errors;
    my $success = $c->json->false;

    Inprint::Check::uuid($c, \@errors, "document", $i_document);
    Inprint::Check::exists($c, \@errors, "filename", $i_filename);

    my $document = Inprint::Check::document($c, \@errors, $i_document);

    unless (@errors) {
        my $folder = Inprint::Store::Embedded::getFolderPath($c, "documents", $document->{created}, $document->{id}, 1);
        Inprint::Store::Embedded::fileCreate($c, $folder, $i_filename, $i_description);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub upload {
    my $c = shift;

    my $i_document = $c->param("document");
    my $i_filename = $c->param("Filename");

    my @errors;
    my $success = $c->json->false;

    Inprint::Check::uuid($c, \@errors, "document", $i_document);
    my $document = Inprint::Check::document($c, \@errors, $i_document);

    unless (@errors) {
        my $folder = Inprint::Store::Embedded::getFolderPath($c, "documents", $document->{created}, $document->{id}, 1);
        Inprint::Store::Embedded::fileUpload($c, $folder, $i_filename);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub publish {
    my $c = shift;

    my $i_document = $c->param("document");
    my @i_files = $c->param("file");

    my @errors;
    my $success = $c->json->false;

    Inprint::Check::uuid($c, \@errors, "document", $i_document);
    my $document = Inprint::Check::document($c, \@errors, $i_document);

    unless (@errors) {
        foreach my $file(@i_files) {
            next unless ($c->is_uuid($file));
            Inprint::Store::Embedded::filePublish($c, $file);
        }
    }

    $c->render_json({});
}

sub unpublish {
    my $c = shift;

    my $i_document = $c->param("document");
    my @i_files = $c->param("file");

    my @errors;
    my $success = $c->json->false;

    Inprint::Check::uuid($c, \@errors, "document", $i_document);
    my $document = Inprint::Check::document($c, \@errors, $i_document);

    unless (@errors) {
        foreach my $file(@i_files) {
            next unless ($c->is_uuid($file));
            Inprint::Store::Embedded::fileUnpublish($c, $file);
        }
    }

    $c->render_json({});
}

sub description {
    my $c = shift;

    my $i_document = $c->param("document");
    my @i_files = $c->param("file");
    my $i_text  = $c->param("description");

    my @errors;
    my $success = $c->json->false;

    Inprint::Check::uuid($c, \@errors, "document", $i_document);
    my $document = Inprint::Check::document($c, \@errors, $i_document);

    unless (@errors) {
        foreach my $file (@i_files) {
            next unless ($c->is_uuid($file));
            Inprint::Store::Embedded::fileChangeDescription($c, $file, $i_text);
        }
    }

    $c->render_json({});
}

sub rename {
    my $c = shift;

    my $i_document = $c->param("document");
    my @i_files = $c->param("file");

    my @errors;
    my $success = $c->json->false;

    Inprint::Check::uuid($c, \@errors, "document", $i_document);
    my $document = Inprint::Check::document($c, \@errors, $i_document);

    unless (@errors) {
        #my $folder = Inprint::Store::Embedded::getFolderPath($c, "rss-plugin", $feed->{created}, $feed->{id}, 1);
        #foreach my $file(@i_files) {
        #    Inprint::Store::Embedded::fileRename($c, $folder, $file);
        #}
    }

    $c->render_json({});
}

sub delete {
    my $c = shift;

    my $i_document = $c->param("document");
    my @i_files = $c->param("file");

    my @errors;
    my $success = $c->json->false;

    Inprint::Check::uuid($c, \@errors, "document", $i_document);
    my $document = Inprint::Check::document($c, \@errors, $i_document);

    unless (@errors) {
        foreach my $file(@i_files) {
            next unless ($c->is_uuid($file));
            Inprint::Store::Embedded::fileDelete($c, $file);
        }
    }

    $c->render_json({});
}

1;
