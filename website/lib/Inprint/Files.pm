package Inprint::Files;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use Encode;
use File::Basename;
use File::Temp qw/ tempfile tempdir /;

use MIME::Base64;
use HTTP::Request;
use LWP::UserAgent;
use Image::Magick;
use Digest::file qw(digest_file_hex);

use base 'Mojolicious::Controller';

sub view {

    my $c = shift;
    my $options = shift || {};

    my @i_files       = $c->param("id");
    my $i_document    = $c->param("document");
    my $i_filter      = $c->param("filter");

    my $i_original    = $c->param("original");

    my $document;
    if ($i_document) {
        $document = $c->Q(" SELECT * FROM documents WHERE id=? ", $i_document)->Hash;
    }

    my @filter;
    @filter = ('tiff', 'png', 'gif', 'jpeg', 'jpg') if ($i_filter eq "images");
    @filter = ('otd', 'pdf', 'doc', 'xls', 'docx', 'xlsx', 'rtf') if ($i_filter eq "documents");

    my $rootpath = $c->config->get("store.path");

    my $sql = "
        SELECT file_path as file_path, file_name, file_name, file_extension, file_mime
        FROM cache_files WHERE true
    ";

    my @params;

    if ($document) {
        $sql .= " AND file_path LIKE ? ";
        push @params, "%/" . $document->{id};
    }

    if (@i_files) {
        $sql .= " AND id=ANY(?) ";
        push @params, \@i_files;
    }

    if (@filter) {
        $sql .= " AND file_extension=ANY(?) ";
        push @params, \@filter;
    }

    my @input;
    my $cacheRecords = $c->Q($sql, \@params)->Hashes;
    foreach my $cacheRecord (@$cacheRecords) {

        my $filename  = $cacheRecord->{file_name};
        my $extension = $cacheRecord->{file_extension};
        my $mimetype  = $cacheRecord->{file_mime};

        my $filepath = $rootpath. "/" . $cacheRecord->{file_path};

        if ($i_original eq "true") {
            $filepath .= "/.origins";
        }

        $filepath .= "/". $cacheRecord->{file_name};

        $filepath  = __adaptPath($c, $filepath);
        $filepath  = __encodePath($c, $filepath);

        $filename  = __adaptPath($c, $filename);
        $filename  = __encodePath($c, $filename);

        $filename =~ s/\s+/_/g;

        push @input, {
            filepath => $filepath,
            filename => $filename,
            mimetype => $cacheRecord->{file_mime},
            extension => $cacheRecord->{file_extension},
        }
    }

    # Download single file
    if ($#input == 0 ) {

        my $filepath  = $input[0]->{filepath};
        my $filename  = $input[0]->{filename};
        my $mimetype  = $input[0]->{mimetype};
        my $extension = $input[0]->{extension};

        $c->tx->res->headers->content_type($mimetype);
        $c->res->content->asset(Mojo::Asset::File->new(path => $filepath));

        my $headers = Mojo::Headers->new;
        $headers->add("Content-Type", "$mimetype; name=$filename");

        if ($options->{disposition}) {
            $headers->add("Content-Disposition", "attachment; filename=$filename");
            $headers->add("Content-Description", $extension);
        }

        $c->res->content->headers($headers);

        $c->render_static($filepath);
    }

    # Download archive
    if ($#input > 0 ) {

        my $fileListString;
        foreach my $item (@input) {
            next unless (-e -r $item->{filepath});
            $fileListString .= ' "'. $item->{filepath} .'" ';
        }

        my $tmpid = $c->uuid;
        my $tmpfpath = "/tmp/inprint-$tmpid.7z";

        if ($^O eq "MSWin32") {
            system ("LANG=ru_RU.UTF-8 7z a -mx0 \"$tmpfpath\" $fileListString >/dev/null 2>&1");
        }
        if ($^O eq "darwin") {
            system ("LANG=ru_RU.UTF-8 /opt/local/bin/7z a -mx0 \"$tmpfpath\" $fileListString >/dev/null 2>&1");
        }
        if ($^O eq "linux") {
            system "LANG=ru_RU.UTF-8 7z a -mx0 \"$tmpfpath\" $fileListString >/dev/null 2>&1";
        }

        $c->tx->res->headers->content_type("application/x-7z-compressed");
        $c->res->content->asset(Mojo::Asset::File->new(path => $tmpfpath));

        my $archname = $tmpid; $archname =~ s/\s+/_/g;

        my $headers = Mojo::Headers->new;
        $headers->add("Content-Type", "application/x-7z-compressed;name=$archname.7z");
        $headers->add("Content-Disposition", "attachment;filename=$archname.7z");
        $headers->add("Content-Description", "7z");
        $c->res->content->headers($headers);

        $c->render_static($tmpfpath);

    }

    $c->render_json({  });
}

sub download {
    my $c = shift;

    $c->view({
        disposition => 1
    });

    $c->render_json({  });
}

sub preview {

    my $c = shift;

    my ($id, $size) = split 'x', $c->param("id");

    $size = 0 unless $size;

    my @errors;
    my $success = $c->json->false;

    my $rootpath = $c->config->get("store.path");

    my $sqlfilepath = $c->Q("SELECT id, file_path, file_name, file_extension, file_thumbnail FROM cache_files WHERE id=?", [ $id ])->Hash;

    my $folderOriginal   = $sqlfilepath->{file_path};
    my $filenameOriginal = $sqlfilepath->{file_name};
    my $filextenOriginal = $sqlfilepath->{file_extension};

    my $fileExtOrig  = $filextenOriginal;
    my $fileSrcOrig  = "$rootpath/$folderOriginal/$filenameOriginal";
    my $thumbSrcOrig = "$rootpath/$folderOriginal/.thumbnails/$filenameOriginal-$size.png";

    my $fileExt  = $filextenOriginal;

    my $fileSrc  = __adaptPath($c, $fileSrcOrig);
    $fileSrc     = __encodePath($c, $fileSrc);

    my $thumbSrc = __adaptPath($c, $thumbSrcOrig);
    $thumbSrc    = __encodePath($c, $thumbSrc);

    # Generate preview
    if (-r $fileSrc) {

        my $digest = digest_file_hex($fileSrc, "MD5");

        if (
            $digest ne $sqlfilepath->{file_thumbnail}
            || !$sqlfilepath->{file_thumbnail}
            || ! -r $thumbSrc) {

            my $convertSrc;

            if ( lc($fileExt) ~~ [ "eps" ]) {
                system "epstool --quiet --page-number 0 --dpi 300 --ignore-warnings --extract-preview \"$fileSrc\" \"$thumbSrc\" ";
                if (-r $thumbSrc) {

                    my $image = Image::Magick->new;
                    my $x = $image->Read($thumbSrcOrig);
                    warn "$x" if "$x";

                    if ($size > 0) {

                        $x = $image->AdaptiveResize(geometry=>$size);
                        die "$x" if "$x";
                        $x = $image->Normalize();
                        die "$x" if "$x";
                        $x = $image->Strip();
                        die "$x" if "$x";
                    }

                    $x = $image->Write($thumbSrcOrig);
                    die "$x" if "$x";

                }
            }

            if ( lc($fileExt) ~~ [ "jpg", "jpeg", "png", "gif", "bmp", "tif", "tiff", "pdf" ]) {

                if (-r $fileSrc) {

                    my $image = Image::Magick->new;
                    my $x = $image->Read($fileSrcOrig);
                    warn "$x" if "$x";

                    if ($size > 0) {

                        $x = $image->AdaptiveResize(geometry=>$size);
                        die "$x" if "$x";
                        $x = $image->Normalize();
                        die "$x" if "$x";
                        $x = $image->Strip();
                        die "$x" if "$x";
                    }

                    $x = $image->Write($thumbSrcOrig);
                    die "$x" if "$x";

                }
            }

            if (lc($fileExt) ~~ ['doc', 'docx', 'txt', 'rtf', 'odt', 'xls', 'xlsx', 'odp', 'ods' ]) {

                my $pdfPath = $thumbSrc .".pdf";

                my $response = __convert($c, $fileSrc, $fileExt, "pdf");
                open my $FILE, ">", $pdfPath || die "Can't open <$pdfPath> : $!";
                binmode $FILE;
                    print $FILE $response->{responseBody};
                close $FILE;

                if (-r $pdfPath) {

                    my $image = Image::Magick->new;
                    my $x = $image->Read($pdfPath);
                    die "$x" if "$x";

                    my $image2 = $image->[0];

                    if ($size > 0) {
                        $x = $image2->AdaptiveResize(geometry=>$size);
                        die "$x" if "$x";
                        $x = $image2->Normalize();
                        die "$x" if "$x";
                        $x = $image->Strip();
                        die "$x" if "$x";
                    }

                    $x = $image2->Write($thumbSrcOrig);
                    die "$x" if "$x";

                    unlink $pdfPath;
                }

            }

            $c->Do("UPDATE cache_files SET file_thumbnail=? WHERE id=?", [ $digest, $id ]);
        }
    }

    if (-e $thumbSrc) {

        $c->tx->res->headers->content_length(-s $thumbSrc);
        $c->tx->res->headers->content_type("image/png");
        $c->res->content->asset(
            Mojo::Asset::File->new(path => $thumbSrc)
        );
        $c->rendered;

    }

    elsif (-e "$ENV{DOCUMENT_ROOT}/images/st.gif") {
        $c->tx->res->headers->content_type('image/gif');
        $c->res->content->asset(Mojo::Asset::File->new(path => "$ENV{DOCUMENT_ROOT}/images/st.gif" ));
        $c->render_static();
    }

    else {
        $c->res->code(404);
    }

}

sub __adaptPath {
    my ($c, $string) = @_;
    $string =~ s/\//\\/g    if ($^O eq "MSWin32");
    $string =~ s/\\+/\\/g   if ($^O eq "MSWin32");
    $string =~ s/\\/\//g    if ($^O eq "darwin");
    $string =~ s/\/+/\//g   if ($^O eq "darwin");
    $string =~ s/\\/\//g    if ($^O eq "linux");
    $string =~ s/\/+/\//g   if ($^O eq "linux");
    return $string;
}

sub __decodePath {
    my ($c, $string) = @_;
    $string = Encode::decode("cp1251", $string) if ($^O eq "MSWin32");
    #$string = Encode::decode("utf8", $string)   if ($^O eq "darwin");
    #$string = Encode::decode("utf8", $string)   if ($^O eq "linux");
    return $string;
}

sub __encodePath {
    my ($c, $string) = @_;
    $string = Encode::encode("cp1251", $string) if ($^O eq "MSWin32");
    $string = Encode::encode("utf8", $string)   if ($^O eq "darwin");
    $string = Encode::encode("utf8", $string)   if ($^O eq "linux");
    return $string;
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
