package Inprint::Downloads;

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

sub list {
    my $c = shift;

    my $result;
    my @errors;
    my @params;

    my $i_pictures  = $c->param("pictures");
    my $i_documents = $c->param("documents");

    my $i_edition   = $c->param("flt_edition");
    my $i_fascicle  = $c->param("flt_fascicle");

    my $sql = "
        SELECT
            fls.id,
            dcm.id as document, dcm.title document_shortcut, dcm.edition, dcm.edition_shortcut, dcm.fascicle, dcm.fascicle_shortcut,
            fls.file_name filename, fls.file_description description,
            fls.file_mime mime, fls.file_extension extension, fls.file_published published,
            fls.file_size size, fls.file_length length,
            to_char(fls.created, 'YYYY-MM-DD HH24:MI:SS') as created,
            to_char(fls.updated, 'YYYY-MM-DD HH24:MI:SS') as updated
        FROM documents dcm, cache_files fls
        WHERE dcm.filepath = fls.file_path
    ";

    $sql .= " AND dcm.edition <> '99999999-9999-9999-9999-999999999999' ";

    if ($i_edition && $i_edition =~ m/^[a-z|0-9]{8}(-[a-z|0-9]{4}){3}-[a-z|0-9]{12}+$/) {
        $sql .= " AND dcm.edition=? ";
        push @params, $i_edition;
    }

    if ($i_fascicle && $i_fascicle =~ m/^[a-z|0-9]{8}(-[a-z|0-9]{4}){3}-[a-z|0-9]{12}+$/) {
        $sql .= " AND dcm.edition=? ";
        push @params, $i_fascicle;
    }

    my @filter;
    if ($i_pictures eq "true") {
        push @filter, " fls.file_extension = ANY(?) ";
        push @params, [ "png", "gif", "jpg", "jpeg", "tiff" ]
    }

    if ($i_documents eq "true") {
        push @filter, " fls.file_extension = ANY(?) ";
        push @params, [ "doc", "docx", "xls", "xlsx", "rtf" ]
    }

    if (@filter) {
        $sql.= " AND (". join(" OR ", @filter) .") ";
    }

    $sql .= " ORDER BY fls.updated, fls.file_path ";
    $result = $c->sql->Q($sql, \@params)->Hashes;

    $c->smart_render(\@errors, $result);
}

sub download {
    my $c = shift;

    my $tmpid = $c->uuid;
    #my $tmpfpath = "/tmp/inprint-$tmpid.7z";
    #
    #my $fileListString;
    #foreach my $item (@input) {
    #    next unless (-e -r $item->{filepath});
    #    $fileListString .= ' "'. $item->{filepath} .'" ';
    #}
    #
    #system (" touch /tmp/2222 ");
    #system (" echo 2222 > /tmp/2222 ");
    #
    #if ($^O eq "MSWin32") {
    #    system ("LANG=ru_RU.UTF-8 7z a -mx0 \"$tmpfpath\" $fileListString >/dev/null 2>&1");
    #}
    #if ($^O eq "darwin") {
    #    system ("LANG=ru_RU.UTF-8 /opt/local/bin/7z a -mx0 \"$tmpfpath\" $fileListString >/dev/null 2>&1");
    #}
    #if ($^O eq "linux") {
    #    system "LANG=ru_RU.UTF-8 7z a -mx0 \"$tmpfpath\" $fileListString >/dev/null 2>&1";
    #}

    $c->tx->res->headers->content_type("application/x-7z-compressed");
    #$c->res->content->asset(Mojo::Asset::File->new(path => $tmpfpath));
    #
    my $archname = $tmpid; $archname =~ s/\s+/_/g;

    my $headers = Mojo::Headers->new;
    $headers->add("Content-Type", "application/x-7z-compressed;name=$archname.7z");
    $headers->add("Content-Disposition", "attachment;filename=$archname.7z");
    $headers->add("Content-Description", "7z");
    $c->res->content->headers($headers);

    $c->render_static();

    $c->render_json({});
}

1;
