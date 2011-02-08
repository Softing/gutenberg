package Inprint::Files;

# Inprint Content 5.0
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use Encode;
use File::Basename;
use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use Image::Magick;

use base 'Inprint::BaseController';

sub download {
    my $c = shift;


    my $id = $c->param("id");

    my $rootpath = $c->config->get("store.path");
    my $cacheRecord = $c->sql->Q("SELECT file_path || '/' || file_name as file_path, file_name, file_extension, file_mime FROM cache_files WHERE id=?", [ $id ])->Hash;

    my $filename  = $cacheRecord->{file_name};
    my $extension = $cacheRecord->{file_extension};
    my $mimetype  = $cacheRecord->{file_mime};

    my $filepath = "$rootpath/" . $cacheRecord->{file_path};

    if ($^O eq "MSWin32") {
        $filepath =~ s/\//\\/g;
        $filepath =~ s/\\+/\\/g;

        $filepath  = encode("cp1251", $filepath);
        $filename  = encode("cp1251", $filename);
    }

    if ($^O eq "linux") {
        $filepath =~ s/\\/\//g;
        $filepath =~ s/\/+/\//g;

        $filepath  = encode("utf8", $filepath);
        $filename  = encode("utf8", $filename);
    }

    $filename =~ s/\s+/_/g;

    $c->tx->res->headers->content_type($cacheRecord->{file_mime});
    $c->res->content->asset(Mojo::Asset::File->new(path => $filepath));

    my $headers = Mojo::Headers->new;
    $headers->add("Content-Type", "$mimetype;name=$filename");
    $headers->add("Content-Disposition", "attachment;filename=$filename");
    $headers->add("Content-Description", $extension);
    $c->res->content->headers($headers);

    $c->render_static();
}

sub preview {

    my $c = shift;

    my ($id, $size) = split 'x', $c->param("id");

    #die "$id, $size" . $c->{stash}->{format};

    my @errors;
    my $success = $c->json->false;

    my $rootpath = $c->config->get("store.path");
    my $sqlfilepath = $c->sql->Q("SELECT id, file_path, file_name, file_extension FROM cache_files WHERE id=?", [ $id ])->Hash;



    my $filepathEncoded;
    my $filepathOriginal = "$rootpath/" . $sqlfilepath->{file_path} . "/". $sqlfilepath->{file_name};

    my $fileid           = $sqlfilepath->{id};
    my $folderOriginal   = $sqlfilepath->{file_path};
    my $filenameOriginal = $sqlfilepath->{file_name};
    my $filextenOriginal = $sqlfilepath->{file_extension};

    $folderOriginal = "$rootpath/$folderOriginal";
    $folderOriginal =~ s/\//\\/g;
    $folderOriginal =~ s/\\+/\\/g;

    my $folderEncoded   = $sqlfilepath->{file_path};
    my $filenameEncoded = $sqlfilepath->{file_name};
    my $filextenEncoded = $sqlfilepath->{file_extension};

    if ($^O eq "MSWin32") {

        $rootpath = Encode::encode("cp1251", $rootpath);
        $folderEncoded   = Encode::encode("cp1251", $folderEncoded);
        $filenameEncoded = Encode::encode("cp1251", $filenameEncoded);
        $filextenEncoded = Encode::encode("cp1251", $filextenEncoded);

        $folderEncoded = "$rootpath/$folderEncoded";
        $folderEncoded =~ s/\//\\/g;
        $folderEncoded =~ s/\\+/\\/g;

        $filepathEncoded = "$folderEncoded/$filenameEncoded";
        $filepathEncoded =~ s/\//\\/g;
        $filepathEncoded =~ s/\\+/\\/g;
    }

    if ($^O eq "linux") {

        $rootpath = Encode::encode("utf8", $rootpath);
        $folderEncoded   = Encode::encode("utf8", $folderEncoded);
        $filenameEncoded = Encode::encode("utf8", $filenameEncoded);
        $filextenEncoded = Encode::encode("utf8", $filextenEncoded);

        $folderEncoded = "$rootpath/$folderEncoded";
        $folderEncoded =~ s/\//\\/g;
        $folderEncoded =~ s/\\+/\\/g;

        $filepathEncoded = "$folderEncoded/$filenameEncoded";
        $filepathEncoded =~ s/\\/\//g;
        $filepathEncoded =~ s/\/+/\//g;
    }

    if (-r $filepathEncoded) {

        if ($filextenOriginal ~~ ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff']) {
            if (-w "$folderEncoded/.thumbnails") {

                my $image = Image::Magick->new;
                my $x = $image->Read($filepathOriginal);
                die "$x" if "$x";

                $x = $image->AdaptiveResize(geometry=>$size);
                die "$x" if "$x";

                $x = $image->Write("$folderOriginal/.thumbnails/$filenameOriginal-$size.png");

                die "$x" if "$x";

            }

        }

        if ($filextenOriginal ~~ ['doc', 'docx', 'txt', 'rtf', 'odt', 'xls', 'xlsx', 'odp', 'ods' ]) {

            my $ooHost = $c->config->get("openoffice.host");
            my $ooPort = $c->config->get("openoffice.port");
            my $ooTimeout = $c->config->get("openoffice.timeout");

            die "Cant read configuration <openoffice.host>" unless $ooHost;
            die "Cant read configuration <openoffice.port>" unless $ooPort;
            die "Cant read configuration <openoffice.timeout>" unless $ooTimeout;

            my $ooUrl = "http://$ooHost:$ooPort/api/converter/";
            my $ooUagent = LWP::UserAgent->new();

            my $pdfPath = "$folderEncoded/.thumbnails/$filenameEncoded.pdf";

            if ($^O eq "MSWin32") {
                $pdfPath =~ s/\//\\/g;
                $pdfPath =~ s/\\+/\\/g;
            }
            if ($^O eq "linux") {
                $pdfPath =~ s/\\/\//g;
                $pdfPath =~ s/\/+/\//g;
            }

            # Create pdf
            my $ooRequest = POST(
                $ooUrl, Content_Type => 'form-data',
                Content => [ outputFormat => "pdf", inputDocument =>  [ $filepathEncoded ] ]
            );

            my $ooResponse = $ooUagent->request($ooRequest);
            if ($ooResponse->is_success()) {

                open FILE, "> $pdfPath" or die "Can't open <$pdfPath> : $!";
                binmode FILE;
                    print FILE $ooResponse->content;
                close FILE;

            } else {
                die $ooResponse->as_string;
            }

            # Crete thumbnail
            if (-w "$folderEncoded/.thumbnails") {
                if (-r $pdfPath) {

                    my $image = Image::Magick->new;
                    my $x = $image->Read($pdfPath);
                    die "$x" if "$x";

                    my $image2 = $image->[0];

                    $x = $image2->Normalize();
                    die "$x" if "$x";

                    $x = $image2->AdaptiveResize(geometry=>$size);
                    die "$x" if "$x";

                    $x = $image2->Write("$folderOriginal/.thumbnails/$filenameOriginal-$size.png");
                    die "$x" if "$x";

                    unlink $pdfPath;
                }
            }
        }

        my $thumbnailsSrc = "$folderOriginal/.thumbnails/$filenameOriginal-$size.png";

        if ($^O eq "MSWin32") {
            $thumbnailsSrc =~ s/\//\\/g;
            $thumbnailsSrc =~ s/\\+/\\/g;
            $thumbnailsSrc   = Encode::encode("cp1251", $thumbnailsSrc);
        }
        if ($^O eq "linux") {
            $thumbnailsSrc =~ s/\\/\//g;
            $thumbnailsSrc =~ s/\/+/\//g;
            $thumbnailsSrc   = Encode::encode("utf8", $thumbnailsSrc);
        }

        if (-r $thumbnailsSrc) {
            #die $thumbnailsSrc;
        }

        if (-r $thumbnailsSrc) {
            $c->tx->res->headers->content_type('image/png');
            $c->res->content->asset(Mojo::Asset::File->new(path => $thumbnailsSrc ));
            $c->render_static();
        }

    }

    $c->render_json({  });
}

1;
