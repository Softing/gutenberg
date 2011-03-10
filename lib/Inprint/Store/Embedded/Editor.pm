package Inprint::Store::Embedded::Editor;

# Inprint Content 5.0
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use Encode;

use strict;
use utf8;

use MIME::Base64;
use HTTP::Request;
use LWP::UserAgent;
use File::Basename;
use HTML::Scrubber;

use Inprint::Store::Embedded::Utils;

sub readFile {
    my ($c, $filetype, $filepath) = @_;

    my $result;

    my $extension = __getExtension($c, $filepath);

    if ($extension ~~ ["doc", "docx", "odt", "rtf"]) {

        my $response = convert($c, $filepath, $extension, "html");

        if ($^O eq "linux") {
            $result = Encode::decode_utf8( $response->{responseBody} );
        }
        if ($^O eq "MSWin32") {
            $result = Encode::decode("windows-1251", $response->{responseBody} );
        }

    }

    if ($extension ~~ ["txt"]) {

        open my $FILE, "<", $filepath;
        while (<$FILE>) { $result .= $_; }
        close $FILE;

        if ($^O eq "MSWin32") {
            $result = Encode::decode("windows-1251", $result);
        }

        $result =~ s/\r?\n/<br>/g;
    }

    $result = __clearHtml($result);

    return $result;
}

sub writeFile {

    my ($c, $filetype, $filepath, $text) = @_;

    my ($basename, $basepath, $extension) = fileparse($filepath, qr/(\.[^.]+){1}?/);
    $extension =~ s/^.//g;

    my $hotSaveFilePath = createHotSave($c, $basepath, "$basename.$extension", $text);

    $basepath =~ s/\/$//;

    if ($extension ~~ ["odt"]) {

        my $response = convert($c, $hotSaveFilePath, "html", $extension);

        open my $FILE, ">", "$filepath.$extension" || die "Can't open <$filepath> : $!";
        binmode $FILE;
            print $FILE $response->{responseBody};
        close $FILE;

    }

    if ($extension ~~ ["doc", "docx", "rtf", "txt"]) {

        # create tmp odt file
        my $tmpFolderPath = __clearPath($c, "$basepath/.hotsave");
        my $tmpFilePath   = __clearPath($c, "$basepath/.hotsave/$basename.$extension~". time() .".odt");
        mkdir $tmpFolderPath unless (-e $tmpFolderPath) ;
        die "Can't find hot save folder <$tmpFolderPath>" unless -e $tmpFolderPath;
        die "Can't write to hot save folder <$tmpFolderPath>" unless -w $tmpFolderPath;

        my $response1 = convert($c, $hotSaveFilePath, "html", "odt");

        open my $TMPFILE, ">", $tmpFilePath || die "Can't open <$tmpFilePath> : $!";
        binmode $TMPFILE;
            print $TMPFILE $response1->{responseBody};
        close $TMPFILE;

        die "Can't read tmp file <$tmpFilePath>" unless -r $tmpFilePath;

        my $response2 = convert($c, $tmpFilePath, "odt", $extension);

        open my $FILE, ">", $filepath || die "Can't read <$filepath> : $!";
        binmode $FILE;
            print $FILE $response2->{responseBody};
        close $FILE;

        my $relativePath = Inprint::Store::Embedded::Utils::getRelativePath($c, $basepath);

        $c->sql->Do(
            "UPDATE cache_files SET file_length=? WHERE file_path=? AND file_name=?",
            [ $response2->{"CharacterCount"}, $relativePath, "$basename.$extension" ]);

        unlink $tmpFilePath;

    }

    return $text;
}

sub createHotSave {

    my ($c, $basepath, $basename, $text) = @_;

    my $hotSaveFileName = "$basename~". time() .".html";

    my $hotSaveFolderPath = __clearPath($c, "$basepath/.hotsave");
    my $hotSaveFilePath   = __clearPath($c, "$basepath/.hotsave/$hotSaveFileName");

    mkdir $hotSaveFolderPath unless (-e $hotSaveFolderPath) ;
    die "Can't find hot save folder <$hotSaveFolderPath>" unless -e $hotSaveFolderPath;
    die "Can't write to hot save folder <$hotSaveFolderPath>" unless -w $hotSaveFolderPath;

    # Create hotsave

    my $hotSaveText = $text;
    $hotSaveText = __clearHtml($hotSaveText);

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

    my $relativePath = Inprint::Store::Embedded::Utils::getRelativePath($c, $basepath);

    my $cmember  = $c->QuerySessionGet("member.id");

    my $member  = $c->sql->Q("SELECT * FROM profiles WHERE id=?", [ $cmember ])->Hash;
    my $copyid  = $c->sql->Q("SELECT copygroup FROM documents WHERE filepath=?", [ $relativePath ])->Value;
    my $history = $c->sql->Q("SELECT * FROM history WHERE entity=? ORDER BY created LIMIT 1", [ $copyid ])->Hash;

    $c->sql->Do("
        INSERT INTO cache_hotsave(
            hotsave_origin, hotsave_path,
            hotsave_branch, hotsave_branch_shortcut,
            hotsave_stage, hotsave_stage_shortcut,
            hotsave_color, hotsave_creator, hotsave_creator_shortcut, created)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, now());
        ", [
            "$relativePath/$basename", "$relativePath/.hotsave/$hotSaveFileName",
            $history->{branch}, $history->{branch_shortcut},
            $history->{stage}, $history->{stage_shortcut},
            $history->{color}, $member->{id}, $member->{shortcut}
        ]);

    return $hotSaveFilePath;
}

sub getMetadata {

    my ($c, $filepath) = @_;

    my ($basename, $basepath, $extension) = fileparse($filepath, qr/(\.[^.]+){1}?/);
    $extension =~ s/^.//g;

    my $metadata = {};

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

        my $responseBody;
        my $ParagraphCount = 0;
        my $CharacterCount = 0;
        my $WordCount = 0;

        my $ooResponse = $ooUagent->request($ooRequest);
        if ($ooResponse->is_success()) {

            $ParagraphCount = $ooResponse->header("Softing-Meta-WordCount");
            $CharacterCount = $ooResponse->header("Softing-Meta-CharacterCount");
            $WordCount = $ooResponse->header("Softing-Meta-WordCount");

        } else {
            die $ooResponse->as_string;
        }

        $metadata = {
            responseBody => $responseBody,
            ParagraphCount => $ParagraphCount,
            CharacterCount => $CharacterCount,
            WordCount => $WordCount
        };

    }

    return $metadata;
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

################################################################################

sub __getExtension {
    my ($c, $filepath) = @_;

    my ($name,$path,$suffix) = fileparse($filepath, qr/(\.[^.]+){1}?/);
    $suffix =~ s/^.//g;

    return $suffix;
}

sub __clearPath {

    my ($c, $filepath) = @_;

    if ($^O eq "MSWin32") {
        $filepath =~ s/\//\\/g;
        $filepath =~ s/\\+/\\/g;
    }

    if ($^O eq "linux") {
        $filepath =~ s/\\/\//g;
        $filepath =~ s/\/+/\//g;
    }

    return $filepath;
}

sub __clearHtml {

    my $html = shift;

    my $scrubber = HTML::Scrubber->new( allow => [ qw[ p b i u ol ul li sub sup table col tr td th tbody ] ]);
    $scrubber->rules(

        table =>{
            border => 1,
            width => 1,
            bordercolor => 1,
            cellspacing => 1,
            cellpadding => 1,
            '*' => 0
        },

        tr => {
            valign => 1,
            '*'    => 0
        },

        col =>
        {
            width => 1,
            '*'   => 0
        },

        td =>
        {
            width   => 1,
            colspan => 1,
            rowspan => 1,
            '*'     => 0
        },

        p =>
        {
            align => 0,
            '*'   => 0
        },

        font =>
        {
            size  => 0,
            color => 1,
            style => 0,
            '*'   => 0,
        }

    );

    #$data =~ s/<title>(.*?)<\/title>//ig;

    $html = $scrubber->scrub($html);

    ## постпроцессинг
    $html =~ s/\n+/ /g;
    $html =~ s/\r+/ /g;

    $html =~ s/<table/<table border=1/ig;

    #$data =~ s/(<br>)+/<br>/ig;
    #$data =~ s/<p><br>\s+<\/p>/ /ig;
    #
    #$data =~ s/<b>\s+<\/b>/ /ig;
    #
    #$data =~ s/<font>\n+<\/font>/ /ig;
    #$data =~ s/<font>\s+<\/font>/ /ig;
    #
    #$data =~ s/<td>\s+<\/td>/<td>&nbsp;<\/td>/ig;
    #
    #$data =~ s/<font>(.*?)<\/font>/$1/ig;
    #$data =~ s/<font \w+="#\w+"> <\/font>/ /isg;

    $html =~ s/\t+/ /ig;
    $html =~ s/\s+/ /ig;

  return $html;
}

1;
