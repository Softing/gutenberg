package Inprint::Documents::Files;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Check;
use Inprint::Store::Cache;
use Inprint::Store::Embedded;

use base 'Inprint::BaseController';

sub list {
    my $c = shift;

    my $i_document = $c->param("document");

    my @errors;
    my $success = $c->json->false;

    Inprint::Check::uuid($c, \@errors, "document", $i_document);
    my $document = Inprint::Check::document($c, \@errors, $i_document);

    my $result = [];
    unless (@errors) {
        Inprint::Store::Embedded::updateCache($c, $document);
        $result = Inprint::Store::Cache::getRecordsByPath($c, $document, "all", ['doc', 'xls', 'rtf', 'odt', 'png', 'jpg', 'gif']);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $result });
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
        Inprint::Store::Embedded::fileCreate($c, $document, $i_filename, $i_description);
        $c->sql->Do("UPDATE documents SET uploaded=now() WHERE id=?", [ $i_document ]);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub upload {

    my $c = shift;

    if ( $c->param("Filename") ) {
        uploadFlash($c);
    } else {
        uploadHtml($c);
    }

}

sub uploadFlash {
    my $c = shift;

    my $i_document = $c->param("document");

    my @errors;
    my $success = $c->json->false;

    Inprint::Check::uuid($c, \@errors, "document", $i_document);
    my $document = Inprint::Check::document($c, \@errors, $i_document);

    unless (@errors) {
        my $upload = $c->req->upload("Filedata");
        Inprint::Store::Embedded::fileUpload($c, $document, $upload);
        $c->sql->Do("UPDATE documents SET uploaded=now() WHERE id=?", [ $i_document ]);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub uploadHtml {
    my $c = shift;

    my $i_document = $c->param("document");

    my @errors;
    my $success = $c->json->false;

    Inprint::Check::uuid($c, \@errors, "document", $i_document);
    my $document = Inprint::Check::document($c, \@errors, $i_document);

    unless (@errors) {
        for ( 1 .. 5 ) {
            my $upload = $c->req->upload("file$_");
            Inprint::Store::Embedded::fileUpload($c, $document, $upload) if ($upload);
        }
        $c->sql->Do("UPDATE documents SET uploaded=now() WHERE id=?", [ $i_document ]);
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
            Inprint::Store::Embedded::filePublish($c, $document, $file);
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
            Inprint::Store::Embedded::fileUnpublish($c, $document, $file);
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
            Inprint::Store::Embedded::fileChangeDescription($c, $document, $file, $i_text);
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
            Inprint::Store::Embedded::fileDelete($c, $document, $file);
        }
    }

    $c->render_json({});
}

1;
