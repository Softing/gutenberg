package Inprint::Store::Embedded::Editor;

use Encode;

use strict;
use utf8;

use MIME::Base64;
use HTTP::Request;
use LWP::UserAgent;
use File::Basename;
use HTML::Scrubber;

sub read {
    my ($c, $filetype, $filepath) = @_;

    my $result;

    my $extension = getExtension($c, $filepath);

    if ($extension ~~ ["doc", "docx", "odt", "rtf"]) {

        my $ooHost = $c->config->get("openoffice.host");
        my $ooPort = $c->config->get("openoffice.port");
        my $ooTimeout = $c->config->get("openoffice.timeout");

        die "Cant read configuration <openoffice.host>" unless $ooHost;
        die "Cant read configuration <openoffice.port>" unless $ooPort;
        die "Cant read configuration <openoffice.timeout>" unless $ooTimeout;

        my $ooUrl = "http://$ooHost:$ooPort/api/converter2/";
        my $ooUagent = LWP::UserAgent->new();

        my $ooRequest = HTTP::Request->new();
        $ooRequest->method("POST");
        $ooRequest->uri( $ooUrl );

        $ooRequest->header("InputFormat", $extension);
        $ooRequest->header("OutputFormat", "html");
        $ooRequest->header("Content-type", "application/octet-stream");

        my $fileContent;
        open FILE, "<", $filepath || die "Can't open <$filepath> : $!";
        binmode FILE;
        while (read(FILE, my $buf, 60*57)) {
            $fileContent .= encode_base64($buf);
        }
        close FILE;

        $ooRequest->content( $fileContent );

        my $ooResponse = $ooUagent->request($ooRequest);
        if ($ooResponse->is_success()) {

            my $decoded = MIME::Base64::decode($ooResponse->content);
            $result = $decoded;

            if ($^O eq "linux") {
                $result = Encode::decode_utf8( $result );
            }
            if ($^O eq "MSWin32") {
                $result = Encode::decode("windows-1251", $result);
            }

        } else {
            die $ooResponse->as_string;
        }
    }

    if ($extension ~~ ["txt"]) {

        open FILE, "<", $filepath;
        while (<FILE>) { $result .= $_; }
        close FILE;

        if ($^O eq "MSWin32") {
            $result = Encode::decode("windows-1251", $result);
        }

        $result =~ s/\r?\n/<br>/g;
    }

    $result = clearHtml($result);

    return $result;
}

sub write {
    my ($c, $filetype, $filepath, $text) = @_;

    my ($basename, $basepath, $extension) = fileparse($filepath, qr/(\.[^.]+){1}?/);
    $extension =~ s/^.//g;

    my $hotSaveFolderPath = clearPath($c, "$basepath/.hotsave");
    my $hotSaveFilePath   = clearPath($c, "$basepath/.hotsave/$basename.$extension~". time() .".html");
    mkdir $hotSaveFolderPath unless (-e $hotSaveFolderPath) ;
    die "Can't find hot save folder <$hotSaveFolderPath>" unless -e $hotSaveFolderPath;
    die "Can't write to hot save folder <$hotSaveFolderPath>" unless -w $hotSaveFolderPath;

    # Create hotsave

    my $hotSaveText = $text;
    $hotSaveText = clearHtml($hotSaveText);

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

    open VERSION, ">:utf8", $hotSaveFilePath;
    print VERSION $hotSaveText;
    close VERSION;

    die "Can't find hotsave file <$hotSaveFilePath>" unless -r $hotSaveFilePath;

    # Update file
    my $ooHost = $c->config->get("openoffice.host");
    my $ooPort = $c->config->get("openoffice.port");
    my $ooTimeout = $c->config->get("openoffice.timeout");

    die "Cant read configuration <openoffice.host>" unless $ooHost;
    die "Cant read configuration <openoffice.port>" unless $ooPort;
    die "Cant read configuration <openoffice.timeout>" unless $ooTimeout;

    if ($extension ~~ ["odt"]) {

        my $ooUrl = "http://$ooHost:$ooPort/api/converter/";
        my $ooUagent = LWP::UserAgent->new();

        my $ooRequest = HTTP::Request->new();
        $ooRequest->method("POST");
        $ooRequest->uri( $ooUrl );

        $ooRequest->header("InputFormat", "html");
        $ooRequest->header("OutputFormat", $extension);
        $ooRequest->header("Content-type", "application/octet-stream");

        my $fileContent;
        open FILE, "<", $hotSaveFilePath || die "Can't open <$hotSaveFilePath> : $!";
        binmode FILE;
        while (read(FILE, my $buf, 60*57)) {
            $fileContent .= encode_base64($buf);
        }
        close FILE;

        $ooRequest->content( $fileContent );

        my $ooResponse = $ooUagent->request($ooRequest);
        if ($ooResponse->is_success()) {

            open FILE, "> $filepath.$extension" or die "Can't open <$filepath> : $!";
            binmode FILE;
                my $decoded = MIME::Base64::decode($ooResponse->content);
                print FILE $decoded;
            close FILE;

        } else {
            die $ooResponse->as_string;
        }

    }

    if ($extension ~~ ["doc", "docx", "rtf", "txt"]) {

        my $ooUrl = "http://$ooHost:$ooPort/api/converter2/";
        my $ooUagent = LWP::UserAgent->new();

        # create tmp odt file
        my $tmpFolderPath = clearPath($c, "$basepath/.hotsave");
        my $tmpFilePath   = clearPath($c, "$basepath/.hotsave/$basename.$extension~". time() .".odt");
        mkdir $tmpFolderPath unless (-e $tmpFolderPath) ;
        die "Can't find hot save folder <$tmpFolderPath>" unless -e $tmpFolderPath;
        die "Can't write to hot save folder <$tmpFolderPath>" unless -w $tmpFolderPath;

        my $ooRequest = HTTP::Request->new();
        $ooRequest->method("POST");
        $ooRequest->uri( $ooUrl );

        $ooRequest->header("InputFormat", "html");
        $ooRequest->header("OutputFormat", "odt");
        $ooRequest->header("Content-type", "application/octet-stream");

        my $fileContent;
        open FILE, "<", $hotSaveFilePath || die "Can't open <$hotSaveFilePath> : $!";
        binmode FILE;
        while (read(FILE, my $buf, 60*57)) {
            $fileContent .= encode_base64($buf);
        }
        close FILE;

        $ooRequest->content( $fileContent );

        my $ooResponse = $ooUagent->request($ooRequest);
        if ($ooResponse->is_success()) {
            open FILE, "> $tmpFilePath" or die "Can't open <$tmpFilePath> : $!";
            binmode FILE;
                my $decoded = MIME::Base64::decode($ooResponse->content);
                print FILE $decoded;
            close FILE;
        } else {
            die $ooResponse->as_string;
        }

        die "Can't read tmp file <$tmpFilePath>" unless -r $tmpFilePath;

        my $ooRequest2 = HTTP::Request->new();
        $ooRequest2->method("POST");
        $ooRequest2->uri( $ooUrl );

        $ooRequest2->header("InputFormat", "odt");
        $ooRequest2->header("OutputFormat", $extension);
        $ooRequest2->header("Content-type", "application/octet-stream");

        my $fileContent2;
        open FILE, "<", $tmpFilePath || die "Can't open <$tmpFilePath>: $!";
        binmode FILE;
        while (read(FILE, my $buf, 60*57)) {
            $fileContent2 .= encode_base64($buf);
        }
        close FILE;

        $ooRequest->content( $fileContent2 );

        my $ooResponse2 = $ooUagent->request($ooRequest2);
        if ($ooResponse2->is_success()) {

            my $decoded = MIME::Base64::decode($ooResponse->content);

            open FILE, "> $filepath" or die "Can't open <$filepath> : $!";
            binmode FILE;
                print FILE $decoded;
            close FILE;

        } else {
            die $ooResponse2->as_string;
        }

        unlink $tmpFilePath;

    }

    return $c;
}

sub getExtension {
    my ($c, $filepath) = @_;

    my ($name,$path,$suffix) = fileparse($filepath, qr/(\.[^.]+){1}?/);
    $suffix =~ s/^.//g;

    return $suffix;
}

sub clearPath {

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

sub clearHtml {

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
