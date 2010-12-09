package Inprint::Documents::Text;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use DBI;

use Digest::file qw(digest_file_hex);
use Encode;

use File::Basename;
use File::Temp qw/ tempfile tempdir /;
use LWP::UserAgent;
use HTTP::Request::Common;
use Text::Iconv;
use HTML::Scrubber;

use Inprint::Utils;

use base 'Inprint::BaseController';

sub get {
    my $c = shift;
    
    my $i_oid = $c->param("oid");
    
    my ($document, $file) = split '::', $i_oid;
    
    my @errors;
    my $success = $c->json->false;
    
    
    $document = Inprint::Utils::GetDocumentById($c, $document);
    my $storePath = $c->getDocumentPath($document->{filepath}, \@errors);
    my $sqlite = $c->getSQLiteHandler($storePath);

    $sqlite->{sqlite_unicode} = 0;
    
    my $sth  = $sqlite->prepare("SELECT * FROM files WHERE id = ?");
    $sth->execute( $file );
    my $record = $sth->fetchrow_hashref;
    $sth->finish();
    
    if ($^O eq "MSWin32") {
        my $converter = Text::Iconv->new("utf-8", "windows-1251");
        $record->{filename} = $converter->convert($record->{filename});
    }
    
    my $data;
    
    if ($record->{id} && -r "$storePath/$record->{filename}") {
        
        my $host = $c->config->get("openoffice.host");
        my $port = $c->config->get("openoffice.port");
        my $timeout = $c->config->get("openoffice.timeout");
        
        my $url = "http://$host:$port/api/converter/";
        
        my $ua  = LWP::UserAgent->new();
        
        my $filepath = "$storePath/$record->{filename}";
        
        my $request = POST "$url", Content_Type => 'form-data',
            Content => [
                outputFormat => "html",
                inputDocument =>  [  "$storePath/$record->{filename}" ]
            ];
        
        my $response = $ua->request($request);
        if ($response->is_success()) {
            
            $data = $response->content ;
            
            if ($^O eq "linux") {
                $data = Encode::decode_utf8( $data );
            }
            
            $data = $c->scrub($data);
            
        } else {
            print $response->as_string;
        }
        
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $data } );
}

sub set {
    my $c = shift;
    
    my $i_oid  = $c->param("oid");
    my $i_text = $c->param("text");
    
    my ($document, $file) = split '::', $i_oid;
    
    my @errors;
    my $success = $c->json->false;
    
    $document = Inprint::Utils::GetDocumentById($c, $document);
    my $storePath = $c->getDocumentPath($document->{filepath}, \@errors);
    my $sqlite = $c->getSQLiteHandler($storePath);

    $sqlite->{sqlite_unicode} = 0;
    
    my $sth  = $sqlite->prepare("SELECT * FROM files WHERE id = ?");
    $sth->execute( $file );
    my $dbrecord = $sth->fetchrow_hashref;
    $sth->finish();
    
    my $filerecord = $dbrecord;
    
    if ($^O eq "MSWin32") {
        my $converter = Text::Iconv->new("utf-8", "windows-1251");
        $filerecord->{filename} = $converter->convert($filerecord->{filename});
    }
    
    my $data;
    
    if ($filerecord->{id} && -r "$storePath/$filerecord->{filename}") {
        
        my $version_id = $c->uuid();
        
        my ($name,$path,$extension) = fileparse("$storePath/$filerecord->{filename}", qr/(\.[^.]+){1}?/);
        
        my $baseName = $name;
        my $baseExtension = $extension;
        
        my $suffix;
        if (-e "$storePath/.versions/$baseName$baseExtension.html") {
            for (1..100) {
                unless (-e "$storePath/.versions/$baseName($_)$baseExtension.html") {
                    $suffix = "($_)";
                    last;
                }
            }
        }
        
        open VERSION, ">$storePath/.versions/$baseName$suffix$baseExtension.html";
        print VERSION $i_text;
        close VERSION;
        
        my $version_digest = $c->getDigest("$storePath/$filerecord->{filename}");
        
        $sqlite->do("
            INSERT INTO versions (id, fileid, filename, filedigest, version, created)
                VALUES (?,?,?,?,?,?)
        ", undef, $version_id, $dbrecord->{id}, $dbrecord->{filename}, $version_digest, "$dbrecord->{filename}$suffix$baseExtension.html", "");
        
        $sqlite->commit;
        
        
        
        my $fileExt = $c->extractExtension($dbrecord->{mimetype});
        
        my $host = $c->config->get("openoffice.host");
        my $port = $c->config->get("openoffice.port");
        my $timeout = $c->config->get("openoffice.timeout");
        
        my $url = "http://$host:$port/api/converter/";
        my $ua  = LWP::UserAgent->new();
        
        my $request = POST "$url", Content_Type => 'form-data',
            Content => [
                outputFormat => $fileExt,
                inputDocument =>  [  "$storePath/.versions/$baseName$suffix$baseExtension.html" ]
            ];
        
        my $response = $ua->request($request);
        
        if ($response->is_success()) {
           
            open FILE, "> $storePath/$baseName$baseExtension" or die "Can't open $storePath/$baseName$baseExtension : $!";
            binmode FILE;
                print FILE $response->content;
            close FILE;
            
        } else {
            die 1;
        #    #print $response->as_string;
        }
        
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $data } );
    
}

sub getSQLiteHandler {
    my $c = shift;
    my $filepath = shift;
    
    my $dbargs = { AutoCommit => 0, RaiseError => 1, sqlite_unicode => 1 };
    
    my $dbh = DBI->connect("dbi:SQLite:dbname=$filepath/.database/store.db","","",$dbargs);
    
    return $dbh;
}

sub getDigest {
    my $c = shift;
    my $filepath = shift;
    
    return digest_file_hex($filepath, "MD5");
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
    
    unless (@$errors) {
        $storePath = $c->processPath($storePath);
    }
    
    return $storePath;
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


sub scrub {

    my $c = shift;
    my $data = shift;

    # Обрабатываем текст

    my $scrubber = HTML::Scrubber->new( allow => [ qw[ html head body title meta p b i u hr br ol ul li font table col tr td th tbody ] ]); #span
    $scrubber->rules(

        meta => {
            '*' => 1
        },
        
        title => {
            '*' => 1
        },

        table => {
            border => 1,
            bordercolor => 1,
            cellspacing => 1,
            cellpadding => 1,
            '*' 	=> 0
        },

        tr => {
            valign 	=> 1,
            '*' 	=> 0
        },

        col => {
            width 	=> 1,
            '*' 	=> 0
        },

        td => {
            width 	=> 0,
            colspan => 1,
            rowspan => 1,
            '*' 	=> 0
        },

        p => {
            align 	=> 0,
            '*' 	=> 0
        },

        font =>
        {
            size 	=> 0,
            color 	=> 1,
            style 	=> 0,
            '*' 	=> 0,
        }

      );

    $data =~ s/<title>(.*?)<\/title>//ig;

    $data = $scrubber->scrub($data);

    # постпроцессинг
    $data =~ s/\n+/ /g;

    $data =~ s/(<br>)+/<br>/ig;
    $data =~ s/<p><br>\s+<\/p>/ /ig;

    $data =~ s/<b>\s+<\/b>/ /ig;

    $data =~ s/<font>\n+<\/font>/ /ig;
    $data =~ s/<font>\s+<\/font>/ /ig;

    $data =~ s/<td>\s+<\/td>/<td>&nbsp;<\/td>/ig;

    $data =~ s/<font>(.*?)<\/font>/$1/ig;
    $data =~ s/<font \w+="#\w+"> <\/font>/ /isg;

    $data =~ s/\s+\./\./ig;
    $data =~ s/\s+/ /ig;

  return $data;

}

sub extractExtension {

    my $self = shift;
    my $mime = shift;

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
    
    while (my ($k, $v) = each %$MimeTypes ) {
        if ($v eq $mime) {
            return $k;
        }
    }
    
    return undef;
}

1;
