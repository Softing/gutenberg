package Inprint::Advertising::Requests::Files;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Store::Embedded;

use base 'Mojolicious::Controller';

sub list {
    my $c = shift;

    my @errors;
    my $i_request = $c->get_uuid(\@errors, "request");

    my $request = $c->check_record(\@errors, "fascicles_requests", "request", $i_request);

    #push @errors, { id => "feed", msg => "Can't find object"}
    #    unless ($feed->{id});

    my $result;
    unless (@errors) {
        my $folder = Inprint::Store::Embedded::getFolderPath($c, "requests", $request->{created}, $request->{id}, 1);
        Inprint::Store::Embedded::updateCache($c, $folder);
        $result = Inprint::Store::Cache::getRecordsByPath($c, $folder, "all", ["tiff", "tif", "eps"]);
    }

    $c->smart_render(\@errors, $result);
}

sub upload {
    my $c = shift;

    my @errors;
    my $i_id = $c->get_uuid(\@errors, "id");
    my $i_filename = $c->param("Filename");

    my $request = $c->check_record(\@errors, "fascicles_requests", "request", $i_id);

    unless (@errors) {
        my $upload = $c->req->upload("Filedata");
        my $folder = Inprint::Store::Embedded::getFolderPath($c, "requests", $request->{created}, $request->{id}, 1);
        Inprint::Store::Embedded::fileUpload($c, $folder, $upload);
    }

    $c->smart_render(\@errors);
}

sub publish {
    my $c = shift;

    my $i_document = $c->param("document");
    my @i_files = $c->param("file");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "document", $i_document);
    my $document = $c->check_record(\@errors, "documents", "document", $i_document);

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

    $c->check_uuid( \@errors, "document", $i_document);
    my $document = $c->check_record(\@errors, "documents", "document", $i_document);

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
    my $i_text  = $c->param("text");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "document", $i_document);
    my $document = $c->check_record(\@errors, "documents", "document", $i_document);

    unless (@errors) {
        foreach my $file (@i_files) {
            next unless ($c->is_uuid($file));
            Inprint::Store::Embedded::fileChangeDescription($c, $file, $i_text);
        }
    }

    $c->render_json({});
}

sub delete {
    my $c = shift;

    my $i_document = $c->param("document");
    my @i_files = $c->param("file");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "document", $i_document);
    my $document = $c->check_record(\@errors, "documents", "document", $i_document);

    unless (@errors) {
        foreach my $file(@i_files) {
            next unless ($c->is_uuid($file));
            Inprint::Store::Embedded::fileDelete($c, $file);
        }
    }

    $c->render_json({});
}

1;
