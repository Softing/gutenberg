package Inprint::Advertising::Requests::Files;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use POSIX;
use Image::ExifTool qw(:Public);

use Encode;
use File::Path;
use File::Basename;
use File::stat;
use Text::Unidecode;

use Inprint::Utils::Files;
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

        $item->{object}      = $request->{id};

        $item->{cmwidth}     = 0;
        $item->{cmheight}    = 0;
        $item->{imagesize}   = $info->{ImageSize}                   || "0x0";
        $item->{xunits}      = $info->{DisplayedUnitsX}             || "undef";
        $item->{yunits}      = $info->{DisplayedUnitsY}             || "undef";
        $item->{colormodel}  = $info->{PhotometricInterpretation}   || "";
        $item->{colorspace}  = $info->{ColorSpace}                  || "";
        $item->{xresolution} = ceil $info->{XResolution}           || 0;
        $item->{yresolution} = ceil $info->{YResolution}           || 0;
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
                $item->{cmwidth}  = $info->{ImageWidth} * 25.4 / $item->{xresolution};
            }

            if ($info->{ImageHeight} > 0 && $info->{YResolution} > 0) {
                $item->{cmheight} = $info->{ImageHeight} * 25.4 / $item->{yresolution};
            }

            $item->{cmwidth}  = sprintf "%.0f", $item->{cmwidth};
            $item->{cmheight} = sprintf "%.0f", $item->{cmheight};

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

        $c->Do("UPDATE fascicles_requests SET check_status='check' WHERE id=?", [ $request->{id} ]);
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

sub download {

    my $c = shift;

    my @errors;

    my @i_files     = $c->param("file[]");
    my $i_safemode  = $c->param("safemode");

    my $temp        = $c->uuid;
    my $rootPath    = $c->config->get("store.path");
    my $tempPath    = "/tmp";
    my $tempFolder  = "$tempPath/inprint-$temp";
    my $tempArchive = "$tempPath/inprint-$temp.7z";

    mkdir $tempFolder;

    die "Can't create temporary folder $tempFolder" unless (-e -w $tempFolder);

    my $fileListString;

    my $currentMember = $c->getSessionValue("member.id");

    foreach my $item (@i_files) {

        my ($objectid, $fileid) = split "::", $item;

        next unless ($fileid);
        next unless ($objectid);

        my $file   = $c->check_record(\@errors, "cache_files", "request", $fileid);
        my $object = $c->check_record(\@errors, "fascicles_requests", "request", $objectid);

        next unless ($file->{id});
        next unless ($object->{id});

        my $pathSource  = $rootPath   ."/". $file->{file_path}  ."/".  $file->{file_name};
        my $pathSymlink = $tempFolder ."/". $object->{shortcut} ."__". $file->{file_name};

        if ($i_safemode eq 'true') {
            $pathSymlink = unidecode($pathSymlink);
            $pathSymlink =~ s/[^\w|\d|\\|\/|\.|-]//g;
            $pathSymlink =~ s/\s+/_/g;
        }

        $pathSource  = __FS_ProcessPath($c, $pathSource);
        $pathSymlink = __FS_ProcessPath($c, $pathSymlink);

        next unless (-e -r $pathSource);

        symlink $pathSource, $pathSymlink;

        die "Can't read symlink $pathSymlink" unless (-e -r $pathSymlink);

        $fileListString .= ' "'. $pathSymlink .'" ';
    }

    __FS_CreateTempArchive($c, $tempArchive, $fileListString);

    rmtree($tempFolder);

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

    $year += 1900; $mon++;

    my $archname = "Downloads_for_${year}_${mon}_${mday}_${hour}${min}${sec}";

    $c->res->content->asset(Mojo::Asset::File->new(path => $tempArchive));

    my $headers = Mojo::Headers->new;
    $headers->add("Content-Type", "application/x-7z-compressed;name=$archname.7z");
    $headers->add("Content-Disposition", "attachment;filename=$archname.7z");
    $headers->add("Content-Description", "7z");
    $headers->add("Content-Length", -s $tempArchive);
    $c->res->content->headers($headers);

    $c->on_finish(sub {
        unlink $tempArchive;
    });

    $c->render_static($tempArchive);
}

1;
