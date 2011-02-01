package Inprint::Store::Embedded::Metadata;

# Inprint Content 5.0
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;

use DBI;
use Digest::file qw(digest_file_hex);
use File::Basename;
use File::Util;
use POSIX qw(strftime);

sub connect {
    my $c = shift;
    my $path = shift;

    my $dbargs = { RaiseError => 1, sqlite_unicode => 1 };
    my $dbpath = clearPath($c, "$path/.database/main.db");
    my $dbh = DBI->connect("dbi:SQLite:dbname=$dbpath","","",$dbargs);

    &createDefaults($c, $dbh);

    return $dbh;
}

sub createDefaults {
    my $c = shift;
    my $dbh = shift;

    $dbh->do("
        CREATE TABLE IF NOT EXISTS files (
            file_name TEXT primary key,
            file_description TEXT,
            file_digest TEXT,
            isdraft INTEGER DEFAULT 1,
            isapproved INTEGER DEFAULT 0,
            created TEXT,
            updated TEXT
        );
    ");

    $dbh->do("
        CREATE TABLE IF NOT EXISTS versions (
            id TEXT primary key,
            file_id TEXT,
            file_name TEXT,
            file_digest TEXT,
            version_text TEXT,
            ischeckpoint INTEGER DEFAULT 0,
            created TEXT
        );
    ");

    $dbh->commit();
    if ($dbh->err()) { die "$DBI::errstr\n"; }

    return $c;
}

sub disconnect {
    my $c = shift;
    my $dbh = shift;
    $dbh->disconnect;
    return $c;
}

sub getFileRecord {
    my $c = shift;

    my $dbh = shift;

    my $path = shift;
    my $filename = shift;

    my $sth  = $dbh->prepare("SELECT * FROM files WHERE file_name = ?");
    $sth->execute( $filename );
    my $record = $sth->fetchrow_hashref;
    $sth->finish();

    my $digest   = Inprint::Store::Embedded::Metadata::getDigest($c, "$path/$filename");
    my $filesize = Inprint::Store::Embedded::Metadata::getFileSize($c, "$path/$filename");
    my $created  = Inprint::Store::Embedded::Metadata::getFileCreateDate($c, "$path/$filename");
    my $updated  = Inprint::Store::Embedded::Metadata::getFileModifyDate($c, "$path/$filename");

    # Create new record
    unless ($record->{file_name}) {
        $dbh->do("
            INSERT OR REPLACE INTO files
            (file_name, file_digest, created, updated) VALUES (?,?,?,?)", undef,
            $filename, $digest, $created, $updated
        );
        if ($dbh->err()) { die "$DBI::errstr\n"; }
    }

    $sth  = $dbh->prepare("SELECT * FROM files WHERE file_name = ?");
    $sth->execute( $filename );
    $record = $sth->fetchrow_hashref;
    $sth->finish();

    # Update record
    if ($record->{file_digest} && $record->{file_digest} ne $digest) {
        $dbh->do("
            UPDATE files
            SET file_digest = ?, updated=? WHERE file_name=?", undef,
            $digest, $updated, $filename
        );
        if ($dbh->err()) { die "$DBI::errstr\n"; }
    }

    $record->{mimetype} = getMimeType($c, "$path/$filename");
    $record->{filesize} = $filesize;
    $record->{digest}   = $digest;
    $record->{created}  = $created;
    $record->{updated}  = $updated;

    return $record;
}

sub createFileRecord {
    my $c = shift;

    my $dbh = shift;

    my $filename = shift;
    my $digest = shift;
    my $created = shift;
    my $updated = shift;

    $dbh->do("
        INSERT OR REPLACE INTO files
        (file_name, file_digest, created, updated) VALUES (?,?,?,?)", undef,
        $filename, $digest, $created, $updated
    );

    if ($dbh->err()) { die "$DBI::errstr\n"; }

    return $c;
}

sub deleteFileRecord {
    my $c = shift;
    my $dbh = shift;
    my $filename = shift;

    $dbh->do(" DELETE FROM files WHERE file_name=?", undef, $filename );
    if ($dbh->err()) { die "$DBI::errstr\n"; }

    return $c;
}

sub publishRecord {
    my $c = shift;
    my $dbh = shift;
    my $filename = shift;
    $dbh->do(" UPDATE files SET isapproved=1 WHERE file_name=?", undef, $filename );
    if ($dbh->err()) { die "$DBI::errstr\n"; }
    return $c;
}

sub unpublishRecord {
    my $c = shift;
    my $dbh = shift;
    my $filename = shift;
    $dbh->do(" UPDATE files SET isapproved=0 WHERE file_name=?", undef, $filename );
    if ($dbh->err()) { die "$DBI::errstr\n"; }
    return $c;
}

sub changeRecordDesciption {
    my $c = shift;
    my $dbh = shift;
    my $filename = shift;
    my $text = shift;
    $dbh->do(" UPDATE files SET file_description=? WHERE file_name=?", undef, $text, $filename );
    if ($dbh->err()) { die "$DBI::errstr\n"; }
    return $c;
}

################################################################################

sub getDigest {
    my $c = shift;
    my $filepath = shift;

    return digest_file_hex($filepath, "MD5");
}

sub getMimeType {
    my $c = shift;
    my $filepath = shift;

    my ($name,$path,$suffix) = fileparse($filepath, qr/(\.[^.]+){1}?/);

    return _extractMimeType($c, $suffix) || "application/octets-stream";
}

sub getFileCreateDate {
    my $c = shift;
    my $filepath = shift;
    my $date = File::Util::created($filepath);
    return strftime("%Y-%m-%d %H:%M:%S", gmtime($date));
}

sub getFileModifyDate {
    my $c = shift;
    my $filepath = shift;
    my $date = File::Util::last_modified($filepath);
    return strftime("%Y-%m-%d %H:%M:%S", gmtime($date));
}

sub getFileSize {
    my $c = shift;
    my $filepath = shift;

    my $filesize = File::Util::size($filepath);

    return $filesize;
}

sub _extractMimeType {

    my $self = shift;
    my $suffix = shift;

    $suffix =~ s/^.//g;

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
    "wmf" => "application/x-msmetafile",
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

    return $MimeTypes->{$suffix} || undef;
}

sub clearPath {

    my $c = shift;
    my $path = shift;

    if ($^O eq "MSWin32") {
        $path =~ s/\//\\/g;
        $path =~ s/\\+/\\/g;
    }

    if ($^O eq "linux") {
        $path =~ s/\\/\//g;
        $path =~ s/\/+/\//g;
    }

    return $path;
}

1;
