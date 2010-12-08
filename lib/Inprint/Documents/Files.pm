package Inprint::Documents::Files;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use DBI;

use Digest::file qw(digest_file_hex);

#use utf8;
use Text::Iconv;
use Image::Magick;

use File::Basename;
#use File::Spec;
use File::Copy qw(copy move);
use File::Path qw(make_path remove_tree);

#use File::Type;
use File::Util;

use POSIX qw(strftime);

use LWP::UserAgent;
use HTTP::Request::Common;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );

use Inprint::Utils;

use base 'Inprint::BaseController';

sub list {

    my $c = shift;

    my $i_id = $c->param("id");
    
    my @result;
    my @errors;
    my $success = $c->json->false;
    
    my $document = Inprint::Utils::GetDocumentById($c, $i_id);
    my $storePath = $c->getDocumentPath($document->{filepath}, \@errors);
    
    my @dir;
    
    use Encode;
    
    if (-r $storePath) {
        opendir DIR, $storePath or die "read dir $storePath - $!";
        @dir = grep !/^\./, readdir DIR;
        
        closedir DIR;
    }
    
    if (@dir) {
    
        @dir = sort(@dir);
        
        my $sqlite = $c->getSQLiteHandler($storePath);
        
        foreach my $file (@dir) {
            
            my $id = undef;
            
            my $filepath = $c->processPath("$storePath/$file");
            my $digest   = $c->getDigest($filepath);
            my $mimetype = $c->getMimeType($filepath);
            my $filesize = $c->getFileSize($filepath);
            my $created  = $c->getFileChangedDate($filepath);
            my $updated  = $c->getFileModifiedDate($filepath);
            
            if ($^O eq "MSWin32") {
                #my $converter = Text::Iconv->new("UTF-16LE", "utf-8");
                #$file = $converter->convert($file);
            }

            if ($^O eq "linux") {
                $file = Encode::decode("utf8", $file);
            }

            my $sth  = $sqlite->prepare("SELECT * FROM files WHERE filename = ?");
            $sth->execute( $file );
            my $record = $sth->fetchrow_hashref;
            $sth->finish();
            
            if ($record->{id}) {
                if ($record->{digest} ne $digest) {
                    $sqlite->do("UPDATE files SET draft = 1 WHERE id=?", undef, $record->{id} );
                }
            }
            
            unless ($record->{id}) {
                
                $record->{id} = $c->uuid;
                
                $sqlite->do("INSERT INTO files (id, filename, description, digest, mimetype, draft, created, updated) VALUES (?,?,?,?,?,?,?,?)", undef, 
                    $record->{id}, $file, "", $digest, $mimetype, 1, $created, $updated
                );
                
                if ($sqlite->err()) { die "$DBI::errstr\n"; }
                
            }
            
            my $preview  = "/documents/files/preview/$document->{id}/$record->{id}/?rnd=" . rand();
            
            push @result, {
                id => $record->{id},
                preview => $preview,
                filename => $file,
                description => $record->{description},
                digest => $digest,
                mimetype => $mimetype,
                draft => "draft",
                size => $filesize,
                created => $created,
                updated => $updated
            }
        }
        
        $sqlite->commit();
        $sqlite->disconnect();
    
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => \@result } );
}

sub create {

    my $c = shift;

    my $i_document = $c->param("document");
    
    my $i_title = $c->param("title");
    my $i_description = $c->param("description");
    
    my @errors;
    my $success = $c->json->false;

    my $storePath    = $c->config->get("store.path");
    my $templateFile = $c->processPath("$storePath/templates/template.rtf");
    push @errors, { id => "filepath", msg => "Cant read template file from settings"}
        unless -e -r $templateFile;
        
    my $document = Inprint::Utils::GetDocumentById($c, $i_document);
    my $documentPath = $c->getDocumentPath($document->{filepath}, \@errors);
    
    my $fileId = $c->uuid;
    my $fileName = "$i_title.rtf";
    
    # Create file
    unless (@errors) {
        
        if (-e "$documentPath/$fileName") {
            for (1..100) {
                $fileName = "$i_title($_).rtf";
                unless (-e "$documentPath/$fileName") {
                    last;
                }
            }
        }
        
        copy $templateFile, "$documentPath/$fileName";
        push @errors, { id => "filepath", msg => "Cant read new file"}
            unless -e -r "$documentPath/$fileName";
    }
    
    unless (@errors) {
        
        my $id = $c->uuid;
        my $digest   = $c->getDigest("$documentPath/$fileName");
        my $mimetype = $c->getMimeType("$documentPath/$fileName");
        my $filesize = $c->getFileSize("$documentPath/$fileName");
        my $created  = $c->getFileChangedDate("$documentPath/$fileName");
        my $updated  = $c->getFileModifiedDate("$documentPath/$fileName");
        
        my $sqlite = $c->getSQLiteHandler($documentPath);
        $sqlite->do("INSERT INTO files (id, filename, description, digest, mimetype, draft, created, updated) VALUES (?,?,?,?,?,?,?,?)", undef, 
            $id, $fileName, $i_description, $digest, $mimetype, 1, $created, $updated
        );
        $sqlite->commit;
        $sqlite->disconnect;
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub upload {

    my $c = shift;
    
    my $i_document = $c->param("document");
    my $i_filename = $c->param("Filename");
    my $upload = $c->req->upload("Filedata");
    
    my @errors;
    my $success = $c->json->false;

    my $document = Inprint::Utils::GetDocumentById($c, $i_document);
    my $storePath = $c->getDocumentPath($document->{filepath}, \@errors);
    
    
    my ($name,$path,$suffix) = fileparse("$storePath/$i_filename", qr/(\.[^.]+){1}?/);
    
    if ($^O eq "MSWin32") {
        my $converter = Text::Iconv->new("utf-8", "windows-1251");
        $name = $converter->convert($name);
        $suffix = $converter->convert($suffix);
    }
    
    $i_filename = "$name$suffix";
    
    if (-e "$storePath/$i_filename") {
        for (1..100) {
            $i_filename = "$name($_)$suffix";
            unless (-e "$storePath/$i_filename") {
                last;
            }
        }
    }
    
    $upload->move_to("$storePath/$i_filename");
    
        my $id = $c->uuid;
        my $digest   = $c->getDigest("$storePath/$i_filename");
        my $mimetype = $c->getMimeType("$storePath/$i_filename");
        my $filesize = $c->getFileSize("$storePath/$i_filename");
        my $created  = $c->getFileChangedDate("$storePath/$i_filename");
        my $updated  = $c->getFileModifiedDate("$storePath/$i_filename");
        
        my $sqlite = $c->getSQLiteHandler($storePath);
        $sqlite->do("INSERT INTO files (id, filename, description, digest, mimetype, draft, created, updated) VALUES (?,?,?,?,?,?,?,?)", undef, 
            $id, $i_filename, "", $digest, $mimetype, 1, $created, $updated
        );
        $sqlite->commit;
        $sqlite->disconnect;
    
    $c->render_json( {"jsonrpc" => "2.0", "result" => 'null', success=> $c->json->true, "id" => "id"} );
}

sub update {

    my $c = shift;

    my $i_id = $c->param("id");
    
    my @errors;
    my $success = $c->json->false;
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub delete {

    my $c = shift;

    my $i_document = $c->param("document");
    my @i_files = $c->param("files");
    
    my @errors;
    my $success = $c->json->false;

    my $document = Inprint::Utils::GetDocumentById($c, $i_document);
    my $storePath = $c->getDocumentPath($document->{filepath}, \@errors);
    
    my $sqlite = $c->getSQLiteHandler($storePath);
    
    foreach my $file (@i_files) {
        
        my $sth  = $sqlite->prepare("SELECT * FROM files WHERE id = ?");
        $sth->execute( $file );
        my $record = $sth->fetchrow_hashref;
        $sth->finish();
        
        if ($record->{id} && -w $storePath && -w "$storePath/$record->{filename}") {
            
            $sqlite->do("DELETE FROM files WHERE id = ?", undef, $record->{id});
            $sqlite->commit();
            
            unlink("$storePath/$record->{filename}");
            if (-w "$storePath/.thumbnails/$record->{id}.png") {
                unlink "$storePath/.thumbnails/$record->{id}.png";
            }
        }
    }
    
    $sqlite->disconnect();
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub preview {

    my $c = shift;

    my $i_document = $c->param("document");
    my $i_file = $c->param("file");
    
    my @errors;
    my $success = $c->json->false;

    my $document = Inprint::Utils::GetDocumentById($c, $i_document);
    my $storePath = $c->getDocumentPath($document->{filepath}, \@errors);
    my $sqlite = $c->getSQLiteHandler($storePath);
    
    my $sth  = $sqlite->prepare("SELECT * FROM files WHERE id = ?");
    $sth->execute( $i_file );
    my $record = $sth->fetchrow_hashref;
    $sth->finish();

    if ($record->{id} && -r "$storePath/$record->{filename}") {
        
        unless (-r "$storePath/.thumbnails/$record->{id}.png") {
            
            my $host = $c->config->get("openoffice.host");
            my $port = $c->config->get("openoffice.port");
            my $timeout = $c->config->get("openoffice.timeout");
            
            my $url = "http://$host:$port/api/thumbnail/";
            
            my $ua  = LWP::UserAgent->new();
                
            my $request = POST "$url", Content_Type => 'form-data',
                Content => [ inputDocument =>  [ "$storePath/$record->{filename}" ] ];
            
            $ua->timeout($timeout);
            my $response = $ua->request($request);
            
            if ($response->is_success()) {
                open FILE, "> $storePath/.thumbnails/$record->{id}.png" or die "Can't open $storePath/.thumbnails/$record->{id}.png : $!";
                    binmode FILE;
                    print FILE $response->content;
                close FILE;
            } else {
                push @errors, { id => "responce", msg => $response->status_line };
            }
            
            if (-w "$storePath/.thumbnails/$record->{id}.png") {
                my $image = Image::Magick->new;
                my $x = $image->Read("$storePath/.thumbnails/$record->{id}.png");
                warn "$x" if "$x";
                
                $x = $image->AdaptiveResize(geometry=>"100x80");
                warn "$x" if "$x";
                
                $x = $image->Write("$storePath/.thumbnails/$record->{id}.png");
                warn "$x" if "$x";
            }
            
        }
        
        if (-r "$storePath/.thumbnails/$record->{id}.png") {
            $c->tx->res->headers->content_type('image/png');
            $c->res->content->asset(Mojo::Asset::File->new(path => "$storePath/.thumbnails/$record->{id}.png"));
            $c->render_static();
        }
        unless (-r "$storePath/.thumbnails/$record->{id}.png") {
            push @errors, { id => "result", msg => "Cant read file thumbnail"}
                unless -e -r "$storePath/.thumbnails/$record->{id}.png";
        }
        
    }
    
    $sqlite->disconnect();
    
    if (@errors) {
        $success = $c->json->true unless (@errors);
        $c->render_json( { success => $success, errors => \@errors } );
    }
}

# Utils

sub getSQLiteHandler {
    my $c = shift;
    my $filepath = shift;
    
    my $dbargs = { AutoCommit => 0, RaiseError => 1, sqlite_unicode => 1};

    my $dbh = DBI->connect("dbi:SQLite:dbname=$filepath/.database/store.db","","",$dbargs);
    
    
    $dbh->do("
        CREATE TABLE IF NOT EXISTS files (
            id TEXT primary key,
            filename TEXT,
            description TEXT,
            digest TEXT,
            mimetype TEXT,
            draft INTEGER DEFAULT 1,
            created TEXT,
            updated TEXT
        );
    ");
    
    $dbh->do("
        CREATE TABLE IF NOT EXISTS versions (
            id TEXT primary key,
            fileid TEXT,
            filename TEXT,
            filedigest TEXT,
            version TEXT,
            created TEXT
        );
    ");
    
    $dbh->commit();
    if ($dbh->err()) { die "$DBI::errstr\n"; }
    
    
    return $dbh;
}

sub processPath {
    my $c = shift;
    my $filepath = shift;
    
    $filepath =~ s/\\+/\\/g;
    $filepath =~ s/\/+/\//g;
    
    if ($^O eq "MSWin32") {
        $filepath =~ s/\/+/\\/g;
    }
    
    if ($^O eq "linux") {
        $filepath =~ s/\\+/\//g;
    }
    
    return $filepath;
}

sub getDigest {
    my $c = shift;
    my $filepath = shift;
    
    return digest_file_hex($filepath, "MD5");
}

sub getMimeType {
    my $c = shift;
    my $filepath = shift;
    
    my ($name,$path,$suffix) = fileparse($filepath, qr/(\.[^.]+){1}?/);
    
    return $c->extractMimeType($suffix) || "application/octets-stream";
}

sub getFileChangedDate {
    my $c = shift;
    my $filepath = shift;
    my $date = File::Util::last_changed($filepath);
    return strftime("%Y-%m-%d %H:%M:%S", gmtime($date));
}

sub getFileModifiedDate {
    my $c = shift;
    my $filepath = shift;
    my $date = File::Util::last_modified($filepath);
    return strftime("%Y-%m-%d %H:%M:%S", gmtime($date));
}

sub getFileSize {
    my $c = shift;
    my $filepath = shift;
    
    my $filesize = File::Util::size($filepath);
    
    if ($filesize > 1024) {
        $filesize = sprintf("%.2f", $filesize / 1024) ."Kb";
    }
    
    if ($filesize > 1024*1024) {
        $filesize = sprintf("%.2f", $filesize / 1024^2) ."Mb";
    }
    
    return $filesize;
}

sub getDocumentPath {
    
    my $c = shift;
    my $filepath = shift;
    my $errors = shift;
    
    return unless $filepath;
    return unless $errors;
    
    # Get and check filepath
    my $storePath    = $c->config->get("store.path");
    
    return unless $storePath;
    
    push @$errors, { id => "filepath", msg => "Cant read store root folder from settings"}
        unless -e -w $storePath;
    
    push @$errors, { id => "filepath", msg => "Cant read document folder name from db"}
        unless defined $filepath;
    
    unless (@$errors) {
        $storePath .= "/documents/" . $filepath;
        make_path($storePath) unless -e -w $storePath;
        push @$errors, { id => "filepath", msg => "Cant create document folder"}
            unless -e -w $storePath;
    }
    
    # Config folder
    unless (@$errors) {
        make_path("$storePath/.config") unless -e -w "$storePath/.config";
        push @$errors, { id => "filepath", msg => "Cant create document database folder"}
            unless -e -w "$storePath/.config";
    }
    
    # DB folder
    unless (@$errors) {
        make_path("$storePath/.database") unless -e -w "$storePath/.database";
        push @$errors, { id => "filepath", msg => "Cant create document database folder"}
            unless -e -w "$storePath/.database";
    }
    
    # Origins folder
    unless (@$errors) {
        make_path("$storePath/.origins") unless -e -w "$storePath/.origins";
        push @$errors, { id => "filepath", msg => "Cant create document database folder"}
            unless -e -w "$storePath/.origins";
    }
    
    # Versions folder
    unless (@$errors) {
        make_path("$storePath/.versions") unless -e -w "$storePath/.versions";
        push @$errors, { id => "filepath", msg => "Cant create document versions folder"}
            unless -e -w "$storePath/.versions";
    }
    
    # Thembnails folder
    unless (@$errors) {
        make_path("$storePath/.thumbnails") unless -e -w "$storePath/.thumbnails";
        push @$errors, { id => "filepath", msg => "Cant create document thumbnails folder"}
            unless -e -w "$storePath/.thumbnails";
    }
    
    unless (@$errors) {
        $storePath = $c->processPath($storePath);
    }
    
    return $storePath;
}

sub extractMimeType {

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
1;
