package Inprint::Store::Cache;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use Encode;

use File::Basename;
use Inprint::Store::Embedded::Utils;

sub makeRecord {

    my $c = shift;

    my ( $folder, $file, $digest, $filesize, $created, $updated) = @_;

    my $extension = Inprint::Store::Embedded::Utils::getExtension($c, $file);

    my $mimetype = extractMimeType($c, $extension);

    $file   = Inprint::Store::Embedded::Utils::doDecode($c, $file);
    $folder = Inprint::Store::Embedded::Utils::doDecode($c, $folder);

    my $cacheRecord = $c->Q("
        SELECT
            id, file_path, file_name, file_extension, file_mime,
            file_digest, file_thumbnail, file_description, file_size,
            file_length, file_meta, file_exists, file_published,
            created, updated
        FROM cache_files
        WHERE 1=1
            AND file_path=?
            AND file_name=? ",
        [ $folder, $file ]
    )->Hash;

    unless ($cacheRecord->{id}) {

        $c->Do("
            INSERT INTO cache_files (
                id, file_path, file_name, file_extension, file_mime,
                file_digest, file_size, created, updated )
            VALUES (?,?,?,?,?,?,?,?,?) ",
            [ $c->uuid(), $folder, $file, $extension, $mimetype, $digest, $filesize, $created, $updated ]
        );

        $cacheRecord = $c->Q("
            SELECT * FROM cache_files WHERE file_path=? AND file_name=? ",
            [ $folder, $file ]
        )->Hash;
    }

    return $cacheRecord;
}

sub getRecordById {

    my $c = shift;
    my $id = shift;

    my $record = $c->Q("
        SELECT
            id, file_path, file_name, file_extension, file_mime,
            file_digest, file_thumbnail, file_description, file_size,
            file_length, file_meta, file_exists, file_published,
            to_char(created, 'YYYY-MM-DD HH24:MI:SS') as created,
            to_char(updated, 'YYYY-MM-DD HH24:MI:SS') as updated
        FROM cache_files WHERE id=?", [ $id ])->Hash;

    return $record;
}

sub getRecordByPath {
    my $c = shift;
    my ($path, $filename) = @_;

    my $record = $c->Q("
        SELECT
            id, file_path, file_name, file_extension, file_mime,
            file_digest, file_thumbnail, file_description, file_size,
            file_length, file_meta, file_exists, file_published,
            to_char(created, 'YYYY-MM-DD HH24:MI:SS') as created,
            to_char(updated, 'YYYY-MM-DD HH24:MI:SS') as updated
        FROM cache_files WHERE file_path=? AND file_name=?
    ", [ $path, $filename ])->Hash;

    return $record;
}

sub getRecordsByPath {

    my ($c, $path, $status, $filter) = @_;

    my @params;
    my $sql = "
        SELECT
            id, file_name as name, file_mime as mime,
            file_description as description, file_extension as extension,
            file_size as size, file_length as length,
            file_published as published,
            to_char(created, 'YYYY-MM-DD HH24:MI:SS') as created,
            to_char(updated, 'YYYY-MM-DD HH24:MI:SS') as updated
        FROM cache_files
        WHERE file_exists = true AND file_path=? ";

    push @params, $path;

    $sql .= " AND file_published = true "  if ($status eq 'published');
    $sql .= " AND file_published = false " if ($status eq 'unpublished');

    if ($filter) {
        my @filter;
        foreach my $item (@$filter) {
            push @filter, " lower(file_extension) = lower(?) ";
            push @params, $item;
        }
        $sql .= " AND ( ". join(" OR ", @filter) ." ) ";
    }

    $sql .= " ORDER BY file_published DESC, file_extension, file_name";

    my $records = $c->Q($sql, \@params)->Hashes;

    return $records;
}

sub deleteRecordById {
    my $c = shift;
    my $id = shift;

    $c->Do(" UPDATE cache_files SET file_exists = false WHERE id=? ", [ $id ]);

    return $c;
}

sub cleanup {

    my ($c, $fs_root, $fs_folder) = @_;

    my $cacheRecords = $c->Q(" SELECT * FROM cache_files WHERE file_path=? ", $fs_folder )->Hashes;

    foreach my $record (@$cacheRecords) {

        my $filepath = $fs_root . $fs_folder ."/". $record->{file_name};

        if ($^O eq "MSWin32") {
            $filepath = encode("cp1251", $filepath);
        }

        unless (-e $filepath) {
            deleteRecordById($c, $record->{id});
        }

    }

    return;
}

sub extractMimeType {

    my ($c, $suffix) = @_;

    $suffix = lc $suffix;

    my $MimeTypes = {
        "323" => "text/h323",
        "acx" => "application/internet-property-stream",
        "ai" => "application/postscript",
        "aif" => "audio/x-aiff",
        "aifc" => "audio/x-aiff",
        "aiff" => "audio/x-aiff",
        "asf" => "video/x-ms-asf",
        "asr" => "video/x-ms-asf",
        "asx" => "video/x-ms-asf",
        "au" => "audio/basic",
        "avi" => "video/x-msvideo",
        "axs" => "application/olescript",
        "bas" => "text/plain",
        "bcpio" => "application/x-bcpio",
        "bin" => "application/octet-stream",
        "bmp" => "image/bmp",
        "c" => "text/plain",
        "cat" => "application/vnd.ms-pkiseccat",
        "cdf" => "application/x-cdf",
        "cer" => "application/x-x509-ca-cert",
        "class" => "application/octet-stream",
        "clp" => "application/x-msclip",
        "cmx" => "image/x-cmx",
        "cod" => "image/cis-cod",
        "cpio" => "application/x-cpio",
        "crd" => "application/x-mscardfile",
        "crl" => "application/pkix-crl",
        "crt" => "application/x-x509-ca-cert",
        "csh" => "application/x-csh",
        "css" => "text/css",
        "dcr" => "application/x-director",
        "der" => "application/x-x509-ca-cert",
        "dir" => "application/x-director",
        "dll" => "application/x-msdownload",
        "dms" => "application/octet-stream",
        "doc" => "application/msword",
        "dot" => "application/msword",
        "dvi" => "application/x-dvi",
        "dxr" => "application/x-director",
        "eps" => "application/postscript",
        "etx" => "text/x-setext",
        "evy" => "application/envoy",
        "exe" => "application/octet-stream",
        "fif" => "application/fractals",
        "flr" => "x-world/x-vrml",
        "gif" => "image/gif",
        "gtar" => "application/x-gtar",
        "gz" => "application/x-gzip",
        "h" => "text/plain",
        "hdf" => "application/x-hdf",
        "hlp" => "application/winhlp",
        "hqx" => "application/mac-binhex40",
        "hta" => "application/hta",
        "htc" => "text/x-component",
        "htm" => "text/html",
        "html" => "text/html",
        "htt" => "text/webviewhtml",
        "ico" => "image/x-icon",
        "ief" => "image/ief",
        "iii" => "application/x-iphone",
        "ins" => "application/x-internet-signup",
        "isp" => "application/x-internet-signup",
        "jfif" => "image/pipeg",
        "jpe" => "image/jpeg",
        "jpeg" => "image/jpeg",
        "jpg" => "image/jpeg",
        "js" => "application/x-javascript",
        "latex" => "application/x-latex",
        "lha" => "application/octet-stream",
        "lsf" => "video/x-la-asf",
        "lsx" => "video/x-la-asf",
        "lzh" => "application/octet-stream",
        "m13" => "application/x-msmediaview",
        "m14" => "application/x-msmediaview",
        "m3u" => "audio/x-mpegurl",
        "man" => "application/x-troff-man",
        "mdb" => "application/x-msaccess",
        "me" => "application/x-troff-me",
        "mht" => "message/rfc822",
        "mhtml" => "message/rfc822",
        "mid" => "audio/mid",
        "mny" => "application/x-msmoney",
        "mov" => "video/quicktime",
        "movie" => "video/x-sgi-movie",
        "mp2" => "video/mpeg",
        "mp3" => "audio/mpeg",
        "mp4" => "video/mp4",
        "mpa" => "video/mpeg",
        "mpe" => "video/mpeg",
        "mpeg" => "video/mpeg",
        "mpg" => "video/mpeg",
        "mpp" => "application/vnd.ms-project",
        "mpv2" => "video/mpeg",
        "ms" => "application/x-troff-ms",
        "mvb" => "application/x-msmediaview",
        "nws" => "message/rfc822",
        "oda" => "application/oda",
        "p10" => "application/pkcs10",
        "p12" => "application/x-pkcs12",
        "p7b" => "application/x-pkcs7-certificates",
        "p7c" => "application/x-pkcs7-mime",
        "p7m" => "application/x-pkcs7-mime",
        "p7r" => "application/x-pkcs7-certreqresp",
        "p7s" => "application/x-pkcs7-signature",
        "pbm" => "image/x-portable-bitmap",
        "pdf" => "application/pdf",
        "pfx" => "application/x-pkcs12",
        "pgm" => "image/x-portable-graymap",
        "pko" => "application/ynd.ms-pkipko",
        "pma" => "application/x-perfmon",
        "pmc" => "application/x-perfmon",
        "pml" => "application/x-perfmon",
        "pmr" => "application/x-perfmon",
        "pmw" => "application/x-perfmon",
        "png" => "image/png",
        "pnm" => "image/x-portable-anymap",
        "pot," => "application/vnd.ms-powerpoint",
        "ppm" => "image/x-portable-pixmap",
        "pps" => "application/vnd.ms-powerpoint",
        "ppt" => "application/vnd.ms-powerpoint",
        "prf" => "application/pics-rules",
        "ps" => "application/postscript",
        "pub" => "application/x-mspublisher",
        "qt" => "video/quicktime",
        "ra" => "audio/x-pn-realaudio",
        "ram" => "audio/x-pn-realaudio",
        "ras" => "image/x-cmu-raster",
        "rgb" => "image/x-rgb",
        "rmi" => "audio/mid",
        "roff" => "application/x-troff",
        "rtf" => "application/rtf",
        "rtx" => "text/richtext",
        "scd" => "application/x-msschedule",
        "sct" => "text/scriptlet",
        "setpay" => "application/set-payment-initiation",
        "setreg" => "application/set-registration-initiation",
        "sh" => "application/x-sh",
        "shar" => "application/x-shar",
        "sit" => "application/x-stuffit",
        "snd" => "audio/basic",
        "spc" => "application/x-pkcs7-certificates",
        "spl" => "application/futuresplash",
        "src" => "application/x-wais-source",
        "sst" => "application/vnd.ms-pkicertstore",
        "stl" => "application/vnd.ms-pkistl",
        "stm" => "text/html",
        "svg" => "image/svg+xml",
        "sv4cpio" => "application/x-sv4cpio",
        "sv4crc" => "application/x-sv4crc",
        "swf" => "application/x-shockwave-flash",
        "t" => "application/x-troff",
        "tar" => "application/x-tar",
        "tcl" => "application/x-tcl",
        "tex" => "application/x-tex",
        "texi" => "application/x-texinfo",
        "texinfo" => "application/x-texinfo",
        "tgz" => "application/x-compressed",
        "tif" => "image/tiff",
        "tiff" => "image/tiff",
        "tr" => "application/x-troff",
        "trm" => "application/x-msterminal",
        "tsv" => "text/tab-separated-values",
        "txt" => "text/plain",
        "uls" => "text/iuls",
        "ustar" => "application/x-ustar",
        "vcf" => "text/x-vcard",
        "vrml" => "x-world/x-vrml",
        "wav" => "audio/x-wav",
        "wcm" => "application/vnd.ms-works",
        "wdb" => "application/vnd.ms-works",
        "wks" => "application/vnd.ms-works",
        "wma" => "audio/x-ms-wma",
        "wmf" => "application/x-msmetafile",
        "wmv" => "video/x-ms-wmv",
        "wps" => "application/vnd.ms-works",
        "wri" => "application/x-mswrite",
        "wrl" => "x-world/x-vrml",
        "wrz" => "x-world/x-vrml",
        "xaf" => "x-world/x-vrml",
        "xbm" => "image/x-xbitmap",
        "xla" => "application/vnd.ms-excel",
        "xlc" => "application/vnd.ms-excel",
        "xlm" => "application/vnd.ms-excel",
        "xls" => "application/vnd.ms-excel",
        "xlt" => "application/vnd.ms-excel",
        "xlw" => "application/vnd.ms-excel",
        "xof" => "x-world/x-vrml",
        "xpm" => "image/x-xpixmap",
        "xwd" => "image/x-xwindowdump",
        "z" => "application/x-compress",
        "zip" => "application/zip",
        "odt" => "application/vnd.oasis.opendocument.text",
        "ott" => "application/vnd.oasis.opendocument.text-template",
        "odg" => "application/vnd.oasis.opendocument.graphics",
        "otg" => "application/vnd.oasis.opendocument.graphics-template",
        "odp" => "application/vnd.oasis.opendocument.presentation",
        "otp" => "application/vnd.oasis.opendocument.presentation-template",
        "ods" => "application/vnd.oasis.opendocument.spreadsheet",
        "ots" => "application/vnd.oasis.opendocument.spreadsheet-template",
        "odc" => "application/vnd.oasis.opendocument.chart",
        "otc" => "application/vnd.oasis.opendocument.chart-template",
        "odi" => "application/vnd.oasis.opendocument.image",
        "oti" => "application/vnd.oasis.opendocument.image-template",
        "odf" => "application/vnd.oasis.opendocument.formula",
        "otf" => "application/vnd.oasis.opendocument.formula-template",
        "odm" => "application/vnd.oasis.opendocument.text-master",
        "oth" => "application/vnd.oasis.opendocument.text-web",
    };

    return $MimeTypes->{$suffix} || "unknown";
}

1;
