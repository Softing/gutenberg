package Inprint::Plugins::Rss::Files;

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

    my $feed = $c->sql->Q(" SELECT * FROM plugins_rss.rss WHERE entity=? ", [ $i_document ])->Hash;

    #push @errors, { id => "feed", msg => "Can't find object"}
    #    unless ($feed->{id});

    my $result;
    unless (@errors) {

        if ($feed->{id}) {
            my $folder = Inprint::Store::Embedded::getFolderPath($c, "rss-plugin", $feed->{created}, $feed->{id}, 1);
            Inprint::Store::Embedded::updateCache($c, $folder);
            $result = Inprint::Store::Cache::getRecordsByPath($c, $folder, "all", ['png', 'jpg', 'jpeg', 'gif', 'wma', 'wmv', 'mpeg', 'mp3']);
        }

    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => \@$result });
}

sub upload {
    my $c = shift;

    my $i_document = $c->param("document");
    my $i_filename = $c->param("Filename");

    my @errors;
    my $success = $c->json->false;

    Inprint::Check::uuid($c, \@errors, "document", $i_document);
    my $document = Inprint::Check::document($c, \@errors, $i_document);

    my $feed = $c->sql->Q(" SELECT * FROM plugins_rss.rss WHERE entity=? ", [ $i_document ])->Hash;
    push @errors, { id => "feed", msg => "Can't find object"} unless ($feed->{id});

    unless (@errors) {
        my $upload = $c->req->upload("Filedata");
        my $folder = Inprint::Store::Embedded::getFolderPath($c, "rss-plugin", $feed->{created}, $feed->{id}, 1);
        Inprint::Store::Embedded::fileUpload($c, $folder, $upload);
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
    my $i_text  = $c->param("text");

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
