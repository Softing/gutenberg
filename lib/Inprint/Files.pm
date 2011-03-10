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
use MIME::Base64;
use HTTP::Request;
use LWP::UserAgent;
use Image::Magick;
use Digest::file qw(digest_file_hex);

use base 'Inprint::BaseController';

sub download {

    my $c = shift;
    my @files = $c->param("id");

    my $rootpath = $c->config->get("store.path");

    my @input;

    foreach my $file (@files) {

        my $cacheRecord = $c->sql->Q("SELECT file_path || '/' || file_name as file_path, file_name, file_extension, file_mime FROM cache_files WHERE id=?", [ $file ])->Hash;

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

        push @input, {

            filepath => $filepath,
            filename => $filename,
            mimetype => $cacheRecord->{file_mime},
            extension => $cacheRecord->{file_extension},

        }

    }

    if ($#files == 0 ) {
        _downloadFile($c, $input[0]);
    }

    if ($#files > 0 ) {
        _downloadArchvie($c, \@input);
    }

    $c->render_json({  });

}

sub _downloadFile {
    my ($c, $file) = @_;

    my $filepath  = $file->{filepath};
    my $filename  = $file->{filename};
    my $mimetype  = $file->{mimetype};
    my $extension = $file->{extension};

    $c->tx->res->headers->content_type($mimetype);
    $c->res->content->asset(Mojo::Asset::File->new(path => $filepath));

    my $headers = Mojo::Headers->new;
    $headers->add("Content-Type", "$mimetype;name=$filename");
    $headers->add("Content-Disposition", "attachment;filename=$filename");
    $headers->add("Content-Description", $extension);
    $c->res->content->headers($headers);

    $c->render_static();

}

sub _downloadArchvie {

    my ($c, $files) = @_;

    my $tmpfname = $c->uuid . ".7z";
    my $tmpfpath = "/tmp/inprint-$tmpfname";

    foreach my $file (@$files) {

        my $filepath  = $file->{filepath};
        my $filename  = $file->{filename};
        my $mimetype  = $file->{mimetype};
        my $extension = $file->{extension};

        if (-e -r $filepath) {
            if ($^O eq "MSWin32") {
                system ("LANG=ru_RU.UTF-8 7z a \"$tmpfpath\" \"$filepath\" >/dev/null 2>&1");
            }
            if ($^O eq "linux") {
                system ("LANG=ru_RU.UTF-8 7z a \"$tmpfpath\" \"$filepath\" >/dev/null 2>&1");
            }
        }

    }

    $c->tx->res->headers->content_type("application/x-7z-compressed");
    $c->res->content->asset(Mojo::Asset::File->new(path => $tmpfpath));

    my $headers = Mojo::Headers->new;
    $headers->add("Content-Type", "application/x-7z-compressed;name=$tmpfname");
    $headers->add("Content-Disposition", "attachment;filename=$tmpfname");
    $headers->add("Content-Description", "7z");
    $c->res->content->headers($headers);

    $c->render_static();

}

sub preview {

    my $c = shift;

    my ($id, $size) = split 'x', $c->param("id");

    $size = 0 unless $size;

    my @errors;
    my $success = $c->json->false;

    my $rootpath = $c->config->get("store.path");
    my $sqlfilepath = $c->sql->Q("SELECT id, file_path, file_name, file_extension, file_thumbnail FROM cache_files WHERE id=?", [ $id ])->Hash;

    my $folderOriginal   = $sqlfilepath->{file_path};
    my $filenameOriginal = $sqlfilepath->{file_name};

    my $filepath = "$rootpath/$folderOriginal/$filenameOriginal";
    my $thumbnailsSrc = "$rootpath/$folderOriginal/.thumbnails/$filenameOriginal-$size.png";

    if ($^O eq "MSWin32") {

        $filepath =~ s/\//\\/g;
        $filepath =~ s/\\+/\\/g;
        $filepath = Encode::encode("cp1251", $filepath);

        $thumbnailsSrc =~ s/\//\\/g;
        $thumbnailsSrc =~ s/\\+/\\/g;
        $thumbnailsSrc   = Encode::encode("cp1251", $thumbnailsSrc);
    }
    if ($^O eq "linux") {

        $filepath =~ s/\\/\//g;
        $filepath =~ s/\/+/\//g;
        $filepath = Encode::encode("utf8", $filepath);

        $thumbnailsSrc =~ s/\\/\//g;
        $thumbnailsSrc =~ s/\/+/\//g;
        $thumbnailsSrc   = Encode::encode("utf8", $thumbnailsSrc);
    }

    # Generate preview
    if (-r $filepath) {
        my $digest = digest_file_hex($filepath, "MD5");
        if ($digest ne $sqlfilepath->{file_thumbnail} || !$sqlfilepath->{file_thumbnail} || ! -r $thumbnailsSrc) {
            _generatePreviewFile( $c, $size, $rootpath, $sqlfilepath->{file_path}, $sqlfilepath->{file_name}, $sqlfilepath->{file_extension} );
            $c->sql->Do("UPDATE cache_files SET file_thumbnail=? WHERE id=?", [ $digest, $id ]);
        }
    }

    if (-r $thumbnailsSrc) {
        $c->tx->res->headers->content_type('image/png');
        $c->res->content->asset(Mojo::Asset::File->new(path => $thumbnailsSrc ));
        $c->render_static();
    }


    $c->render_json({  });
}

sub _generatePreviewFile {

    my ($c, $size, $rootpath, $path, $file, $extension) = @_;

    my $filepathEncoded;
    my $filepathOriginal = $rootpath ."/" . $path . "/". $file;

    my $folderOriginal   = $path;
    my $filenameOriginal = $file;
    my $filextenOriginal = $extension;

    $folderOriginal = "$rootpath/$folderOriginal";
    $folderOriginal =~ s/\//\\/g;
    $folderOriginal =~ s/\\+/\\/g;

    my $folderEncoded   = $path;
    my $filenameEncoded = $file;
    my $filextenEncoded = $extension;

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

    my $thumbnailFolder = "$folderEncoded/.thumbnails";
    my $thumbnailFile   = "$folderOriginal/.thumbnails/$filenameOriginal-$size.png";
    if ($^O eq "MSWin32") {
        $thumbnailFolder =~ s/\//\\/g;
        $thumbnailFolder =~ s/\\+/\\/g;
        $thumbnailFile  =~ s/\//\\/g;
        $thumbnailFile  =~ s/\\+/\\/g;
    }
    if ($^O eq "linux") {
        $thumbnailFolder =~ s/\\/\//g;
        $thumbnailFolder =~ s/\/+/\//g;
        $thumbnailFile  =~ s/\\/\//g;
        $thumbnailFile  =~ s/\/+/\//g;
    }

    if ( lc($filextenOriginal) ~~ ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff']) {

        if (-w $thumbnailFolder) {

            my $image = Image::Magick->new;
            my $x = $image->Read($filepathOriginal);
            die "$x" if "$x";

            if ($size > 0) {
                $x = $image->AdaptiveResize(geometry=>$size);
                die "$x" if "$x";
            }

            $x = $image->Write($thumbnailFile);

            die "$x" if "$x";

        }

    }

    if (lc($filextenOriginal) ~~ ['doc', 'docx', 'txt', 'rtf', 'odt', 'xls', 'xlsx', 'odp', 'ods' ]) {

        my $pdfPath = "$folderEncoded/.thumbnails/$filenameEncoded.pdf";

        if ($^O eq "MSWin32") {
            $pdfPath =~ s/\//\\/g;
            $pdfPath =~ s/\\+/\\/g;
        }
        if ($^O eq "linux") {
            $pdfPath =~ s/\\/\//g;
            $pdfPath =~ s/\/+/\//g;
        }

        my $response = __convert($c, $filepathEncoded, $extension, "pdf");
        open my $FILE, ">", $pdfPath || die "Can't open <$pdfPath> : $!";
        binmode $FILE;
            print $FILE $response->{responseBody};
        close $FILE;

        # Crete thumbnail

        if (-w $thumbnailFolder) {

            if (-r $pdfPath) {

                my $image = Image::Magick->new;
                my $x = $image->Read($pdfPath);
                die "$x" if "$x";

                my $image2 = $image->[0];

                $x = $image2->Normalize();
                die "$x" if "$x";

                if ($size > 0) {
                    $x = $image2->AdaptiveResize(geometry=>$size);
                    die "$x" if "$x";
                }

                $x = $image2->Write($thumbnailFile );
                die "$x" if "$x";

                unlink $pdfPath;
            }
        }
    }

}

sub __convert {

    my ($c, $filepath, $input, $output) = @_;

    my $ooHost = $c->config->get("openoffice.host");
    my $ooPort = $c->config->get("openoffice.port");
    my $ooTimeout = $c->config->get("openoffice.timeout");

    die "Cant read configuration <openoffice.host>" unless $ooHost;
    die "Cant read configuration <openoffice.port>" unless $ooPort;
    die "Cant read configuration <openoffice.timeout>" unless $ooTimeout;

    my $ooUrl = "http://$ooHost:$ooPort/api/converter/";
    my $ooUagent = LWP::UserAgent->new();
    $ooUagent->timeout( $ooTimeout );

    my $ooRequest = HTTP::Request->new();
    $ooRequest->method("POST");
    $ooRequest->uri( $ooUrl );

    $ooRequest->header("InputFormat", $input);
    $ooRequest->header("OutputFormat", $output);
    $ooRequest->header("Content-type", "application/octet-stream");

    my $fileContent;
    open my $INPUT, "<", $filepath || die "Can't open <$filepath> : $!";
    binmode $INPUT;
    while ( read($INPUT, my $buf, 60*57)) {
        $fileContent .= $buf;
    }
    close $INPUT;

    $fileContent = encode_base64($fileContent);

    $ooRequest->content( $fileContent );

    my $responseBody;
    my $ParagraphCount = 0;
    my $CharacterCount = 0;
    my $WordCount = 0;

    my $ooResponse = $ooUagent->request($ooRequest);
    if ($ooResponse->is_success()) {

        $ParagraphCount = $ooResponse->header("Softing-Meta-WordCount");
        $CharacterCount = $ooResponse->header("Softing-Meta-CharacterCount");
        $WordCount = $ooResponse->header("Softing-Meta-WordCount");

        $responseBody = MIME::Base64::decode($ooResponse->content);

    } else {
        die $ooResponse->as_string;
    }

    return {
        responseBody => $responseBody,
        ParagraphCount => $ParagraphCount,
        CharacterCount => $CharacterCount,
        WordCount => $WordCount
    }
}

1;
