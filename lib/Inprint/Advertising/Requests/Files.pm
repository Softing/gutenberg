package Inprint::Advertising::Requests::Files;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Image::ExifTool qw(:Public);

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
        $result = Inprint::Store::Cache::getRecordsByPath($c, $folder, "all", [ "tiff", "tif", "eps", "pdf" ]);
    }

    my $rootpath = $c->config->get("store.path");

    foreach my $item (@$result) {

        my $file_path = $c->Q(" SELECT file_path || '/' || file_name FROM cache_files WHERE id=? ", $item->{id})->Value;

        $file_path = "$rootpath/$file_path";

        next unless (-r $file_path );

        my $info = ImageInfo($file_path);

        $item->{cmwidth}       = 0;
        $item->{cmheight}      = 0;
        $item->{imagesize}   = $info->{ImageSize}                   || "0x0";
        $item->{xunits}      = $info->{DisplayedUnitsX}             || "undef";
        $item->{yunits}      = $info->{DisplayedUnitsY}             || "undef";
        $item->{colormodel}  = $info->{PhotometricInterpretation}   || "";
        $item->{colorspace}  = $info->{ColorSpace}                  || "";
        $item->{xresolution} = $info->{XResolution}                 || 0;
        $item->{yresolution} = $info->{YResolution}                 || 0;
        $item->{software}    = $info->{Software}                    || "";

        $item->{cm_error} = $c->json->false;
        $item->{dpi_error} = $c->json->false;

        if ( lc($info->{FileType}) ~~ ["tif", "tiff"]) {

            # Check for errors

            if ($item->{colormodel} ne "CMYK") {
                $item->{cm_error} = $c->json->true;
            }

            if ($item->{xresolution} < 250) {
                $item->{dpi_error} = $c->json->true;
            }

            if ($item->{yresolution} < 250) {
                $item->{dpi_error} = $c->json->true;
            }

            # Calculate image size
            if ($info->{ImageWidth} > 0 && $info->{XResolution} > 0) {
                $item->{cmwidth}  = $info->{ImageWidth} / $info->{XResolution};
            }

            if ($info->{ImageHeight} > 0 && $info->{YResolution} > 0) {
                $item->{cmheight} = $info->{ImageHeight} / $info->{YResolution};
            }

            if ($item->{cmwidth} > 0 && $item->{xunits} eq "inches") {
                $item->{cmwidth} = sprintf("%.2f", $item->{cmwidth} * 2.5 * 100);
            }
            if ($item->{cmheight} > 0 && $item->{yunits} eq "inches") {
                $item->{cmheight} = sprintf("%.2f", $item->{cmheight} * 2.5 * 100);
            }

        }

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
