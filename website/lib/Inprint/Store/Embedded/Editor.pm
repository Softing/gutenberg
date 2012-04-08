# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

package Inprint::Store::Embedded::Editor;

use Encode;
use Storable qw(store retrieve);

use strict;
use utf8;

use MIME::Base64;
use HTTP::Request;
use LWP::UserAgent;
use File::Basename;

use Inprint::Store::Embedded::Utils;

sub readFile {

    my ($c, $filetype, $filepath) = @_;

    my $responce = {};

    my $extension = __getExtension($c, $filepath);

    if ($extension ~~ ["doc", "docx", "odt", "rtf"]) {
        $responce = convert($c, $filepath, $extension, "html");
        if ($^O eq "linux") {
            $responce->{text} = Encode::decode_utf8( $responce->{text} );
        }
        if ($^O eq "darwin") {
            $responce->{text} = Encode::decode_utf8( $responce->{text} );
        }
        if ($^O eq "MSWin32") {
            $responce->{text} = Encode::decode("windows-1251", $responce->{text} );
        }
    }

    if ($extension ~~ ["txt"]) {
        open my $FILE, "<", $filepath;
        while (<$FILE>) { $responce->{text} .= $_; }
        close $FILE;
        if ($^O eq "MSWin32") {
            $responce->{text} = Encode::decode("windows-1251", $responce->{text});
        }
        $responce->{text} =~ s/\r?\n/<br>/g;
    }

    return $responce;
}

sub writeFile {

    my ($c, $fs_folder, $fs_file, $extension, $text) = @_;

    my $hotSaveFilePath = createHotSave($c, $fs_folder, $fs_file, $text);

    my $rootpath = $c->config->get("store.path");

    my $folder = Inprint::Store::Embedded::Utils::makePath($c, $rootpath, $fs_folder);

    my $filepath = Inprint::Store::Embedded::Utils::makePath($c, $rootpath, $fs_folder, $fs_file);
    my $filepath_encoded = Inprint::Store::Embedded::Utils::doEncode($c, $filepath);
    die "Can't find file <$filepath_encoded>" unless -e $filepath_encoded;
    die "Can't read file <$filepath_encoded>" unless -r $filepath_encoded;

    if ($extension ~~ ["odt"]) {
        my $response = convert($c, $hotSaveFilePath, "html", $extension);
        open my $FILE, ">", $filepath || die "Can't open <$filepath> : $!";
        binmode $FILE;
            print $FILE $response->{text};
        close $FILE;
    }

    if ($extension ~~ ["txt"]) {
        open my $FILE, ">:encoding(windows-1251)", $filepath || die "Can't open <$filepath> : $!";
            print $FILE $text;
        close $FILE;
    }

    if ($extension ~~ ["doc", "docx", "rtf"]) {

        # create tmp odt file
        my $tmpFolderPath = "$folder/.hotsave";
        my $tmpFilePath   = "$folder/.hotsave/${fs_file}-tmp-". time() .".odt";
        $tmpFilePath = __encodePath($c, $tmpFilePath);

        my $response1 = convert($c, $hotSaveFilePath, "html", "odt");

        open my $TMPFILE, ">", $tmpFilePath || die "Can't open <$tmpFilePath> : $!";
        binmode $TMPFILE;
            print $TMPFILE $response1->{text};
        close $TMPFILE;

        die "Can't read tmp file <$tmpFilePath>" unless -r $tmpFilePath;

        my $response2 = convert($c, $tmpFilePath, "odt", $extension);

        open my $FILE, ">", $filepath_encoded || die "Can't read <$filepath_encoded> : $!";
        binmode $FILE;
            print $FILE $response2->{text};
        close $FILE;

        $c->Do(
            "UPDATE cache_files SET file_length=? WHERE file_path=? AND file_name=? ",
            [ $response2->{"CharacterCount"}, $fs_folder, $fs_file ]);

        unlink $tmpFilePath;

    }

    return $text;
}

sub createHotSave {

    my ($c, $fs_folder, $fs_file, $text) = @_;

    my $rootpath = $c->config->get("store.path");

    my $hotSaveFileName = "$fs_file-". time() .".html";

    my $hotSaveFolderPath = "$rootpath/$fs_folder/.hotsave";
    my $hotSaveFilePath   = "$hotSaveFolderPath/$hotSaveFileName";

    $hotSaveFilePath = __encodePath($c, $hotSaveFilePath);

    mkdir $hotSaveFolderPath unless (-e $hotSaveFolderPath) ;
    die "Can't find hot save folder <$hotSaveFolderPath>" unless -e $hotSaveFolderPath;
    die "Can't write to hot save folder <$hotSaveFolderPath>" unless -w $hotSaveFolderPath;

    # Create hotsave
    my $hotSaveText = $text;

    $hotSaveText = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
    <HTML>
    <HEAD>
        <META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf-8">
        <TITLE></TITLE>
        <STYLE TYPE="text/css">
        <!--
            @page { size: 21cm 29.7cm; margin: 2cm }
            P { margin-bottom: 0.21cm }
        -->
        </STYLE>
    </HEAD>
    <BODY LANG="ru-RU" LINK="#000080" VLINK="#800000" DIR="LTR">'. $hotSaveText .'</BODY></HTML>';

    open my $VERSION, ">:utf8", $hotSaveFilePath;
    print $VERSION $hotSaveText;
    close $VERSION;

    die "Can't find hotsave file <$hotSaveFilePath>" unless -r $hotSaveFilePath;

    # create metadata
    my $cmember  = $c->getSessionValue("member.id");

    my $member  = $c->Q("SELECT * FROM profiles WHERE id=?", [ $cmember ])->Hash;
    my $copyid  = $c->Q("SELECT copygroup FROM documents WHERE fs_folder = ?", [ $fs_folder ])->Value;
    my $history = $c->Q("SELECT * FROM history WHERE entity=? ORDER BY created LIMIT 1", [ $copyid ])->Hash;

    unless ($history) {
        $history->{branch} = "00000000-0000-0000-0000-000000000000";
        $history->{branch_shortcut} = "Default";
        $history->{stage} = "00000000-0000-0000-0000-000000000000";
        $history->{stage_shortcut} = "Default";
        $history->{color} = "FFFFFF";
    }

    $c->Do("
        INSERT INTO cache_hotsave(
            hotsave_origin, hotsave_path,
            hotsave_branch, hotsave_branch_shortcut,
            hotsave_stage, hotsave_stage_shortcut,
            hotsave_color, hotsave_creator, hotsave_creator_shortcut, created)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, now()); ",
        [
            "$fs_folder/$fs_file", "$fs_folder/.hotsave/$hotSaveFileName",
            $history->{branch}, $history->{branch_shortcut},
            $history->{stage}, $history->{stage_shortcut},
            $history->{color}, $member->{id}, $member->{shortcut}
        ]
    );

    return $hotSaveFilePath;
}

sub getMetadata {

    my ($c, $filepath, $digest) = @_;

    my ($basename, $basepath, $extension) = fileparse($filepath, qr/(\.[^.]+){1}?/);
    $extension =~ s/^.//g;

    my $metadata = {};

    my $cacheFolderPath = "$basepath/.metacache";
    my $cacheFlePath    = "$basepath/.metacache/$basename.$extension.cache";

    unless (-e $cacheFolderPath) {
        mkdir $cacheFolderPath;
    }

    my $cache = {};

    if(-r $cacheFlePath) {
        $cache = retrieve($cacheFlePath);
    }

    unless ($cache->{digest} eq $digest ) {

        if ($extension ~~ ["doc", "docx", "odt", "rtf", "txt"]) {

            my $ooHost    = $c->config->get("openoffice.host");
            my $ooPort    = $c->config->get("openoffice.port");
            my $ooTimeout = $c->config->get("openoffice.timeout");

            die "Cant read configuration <openoffice.host>" unless $ooHost;
            die "Cant read configuration <openoffice.port>" unless $ooPort;
            die "Cant read configuration <openoffice.timeout>" unless $ooTimeout;

            my $ooUrl = "http://$ooHost:$ooPort/api/query/";

            my $ooUagent = LWP::UserAgent->new();
            $ooUagent->timeout( $ooTimeout );

            my $ooRequest = HTTP::Request->new();
            $ooRequest->method("POST");
            $ooRequest->uri( $ooUrl );

            $ooRequest->header("InputFormat", $extension);
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

            $metadata = __processResponce($c, $ooUagent->request($ooRequest));

            $cache = {
                "digest"         => $digest,
                "text"           => $metadata->{text},
                "CharacterCount" => $metadata->{CharacterCount},
                "WordCount"      => $metadata->{WordCount},
                "ParagraphCount" => $metadata->{ParagraphCount},
                };

            store($cache, $cacheFlePath) || die "Cant store metacache in $cacheFlePath";

        }

    }

    return $cache;
}


sub convert {

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
    my $result = __processResponce($c, $ooUagent->request($ooRequest));

    return $result;
}

################################################################################

sub __processResponce {
    my ($c, $response) = @_;

    my $result;

    if ($response->is_success()) {
        $result = {
            text            => MIME::Base64::decode($response->content),
            ParagraphCount  => $response->header("Softing-Meta-WordCount"),
            CharacterCount  => $response->header("Softing-Meta-CharacterCount"),
            WordCount       => $response->header("Softing-Meta-WordCount")
        }
    } else {
        print STDERR $response->as_string;
        $result = {
            text            => "",
            error           => $response->as_string,
            ParagraphCount  => 0,
            CharacterCount  => 0,
            WordCount       => 0
        }
    }

    return $result;
}

sub __getExtension {
    my ($c, $filepath) = @_;

    my ($name,$path,$suffix) = fileparse($filepath, qr/(\.[^.]+){1}?/);
    $suffix =~ s/^.//g;

    return $suffix;
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

1;
