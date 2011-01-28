package Inprint::Plugins::Rss::Files;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Store::Embedded;

use base 'Inprint::BaseController';

sub list {
    my $c = shift;

    my $i_document = $c->param("document");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "document", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_document));

    my $feed = $c->sql->Q(" SELECT * FROM rss WHERE document=? ", [ $i_document ])->Hash;

    push @errors, { id => "feed", msg => "Can't find object"}
        unless ($feed->{id});

    my $files;
    unless (@errors) {
        my $folder = Inprint::Store::Embedded::getFolderPath($c, "rss-plugin", $feed->{created}, $feed->{id}, 1);
        $files = Inprint::Store::Embedded::list($c, $folder, ['png', 'jpg', 'gif']);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $files });
}

sub upload {
    my $c = shift;

    my $i_document = $c->param("document");
    my $i_filename = $c->param("Filename");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "document", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_document));

    my $feed = $c->sql->Q(" SELECT * FROM rss WHERE document=? ", [ $i_document ])->Hash;

    push @errors, { id => "feed", msg => "Can't find object"}
        unless ($feed->{id});

    unless (@errors) {
        my $folder = Inprint::Store::Embedded::getFolderPath($c, "rss-plugin", $feed->{created}, $feed->{id}, 1);
        Inprint::Store::Embedded::upload($c, $folder, $i_filename);
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

    push @errors, { id => "document", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_document));

    my $feed = $c->sql->Q(" SELECT * FROM rss WHERE document=? ", [ $i_document ])->Hash;

    push @errors, { id => "feed", msg => "Can't find object"}
        unless ($feed->{id});

    unless (@errors) {
        my $folder = Inprint::Store::Embedded::getFolderPath($c, "rss-plugin", $feed->{created}, $feed->{id}, 1);
        foreach my $file(@i_files) {
            Inprint::Store::Embedded::publish($c, $folder, $file);
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

    push @errors, { id => "document", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_document));

    my $feed = $c->sql->Q(" SELECT * FROM rss WHERE document=? ", [ $i_document ])->Hash;

    push @errors, { id => "feed", msg => "Can't find object"}
        unless ($feed->{id});

    unless (@errors) {
        my $folder = Inprint::Store::Embedded::getFolderPath($c, "rss-plugin", $feed->{created}, $feed->{id}, 1);
        foreach my $file(@i_files) {
            Inprint::Store::Embedded::unpublish($c, $folder, $file);
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

    push @errors, { id => "document", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_document));

    my $feed = $c->sql->Q(" SELECT * FROM rss WHERE document=? ", [ $i_document ])->Hash;

    push @errors, { id => "feed", msg => "Can't find object"}
        unless ($feed->{id});

    unless (@errors) {
        my $folder = Inprint::Store::Embedded::getFolderPath($c, "rss-plugin", $feed->{created}, $feed->{id}, 1);
        foreach my $file(@i_files) {
            Inprint::Store::Embedded::delete($c, $folder, $file);
        }
    }

    $c->render_json({});
}

1;
