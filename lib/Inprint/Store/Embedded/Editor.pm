package Inprint::Store::Embedded::Editor;

use strict;

use utf8;
use Encode;
use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use File::Basename;
use HTML::Scrubber;

sub read {
    my ($c, $filetype, $filepath) = @_;

    my $result;

    my $extension = getExtension($c, $filepath);

    if ($extension ~~ ["doc", "odt", "rtf"]) {

        my $ooHost = $c->config->get("openoffice.host");
        my $ooPort = $c->config->get("openoffice.port");
        my $ooTimeout = $c->config->get("openoffice.timeout");

        die "Cant read configuration <openoffice.host>" unless $ooHost;
        die "Cant read configuration <openoffice.port>" unless $ooPort;
        die "Cant read configuration <openoffice.timeout>" unless $ooTimeout;

        my $ooUrl = "http://$ooHost:$ooPort/api/converter/";
        my $ooUagent = LWP::UserAgent->new();

        my $ooRequest = POST(
            $ooUrl,
            Content_Type => 'form-data',
            Content => [
                outputFormat => $filetype,
                inputDocument =>  [ $filepath ]
            ]
        );

        my $ooResponse = $ooUagent->request($ooRequest);
        if ($ooResponse->is_success()) {

            $result = $ooResponse->content ;

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

    my $scrubber = HTML::Scrubber->new( allow => [ qw[ p b i u hr ul ol li sub sup ] ] );
    $result = $scrubber->scrub($result);

    $result =~ s/\s+/ /g;
    $result =~ s/\t//g;

    return $result;
}

sub write {
    my ($c, $filetype, $filepath, $text) = @_;

    my ($basename, $basepath, $extension) = fileparse($filepath, qr/(\.[^.]+){1}?/);
    $extension =~ s/^.//g;

    my $hotSaveFolderPath = clearPath($c, "$basepath/.hotsave");
    my $hotSaveFilePath   = clearPath($c, "$basepath/.hotsave/$basename.$extension~". time() .".html");

    unless (-e $hotSaveFolderPath) {
        mkdir $hotSaveFolderPath;
    }

    die "Can't find hot save folder <$hotSaveFolderPath>" unless -e $hotSaveFolderPath;
    die "Can't write to hot save folder <$hotSaveFolderPath>" unless -w $hotSaveFolderPath;

    # Create hotsave

    my $scrubber = HTML::Scrubber->new( allow => [ qw[ p b i u hr ul ol li sub sup ] ] );

    my $hotSaveText = $scrubber->scrub($text);

    $hotSaveText =~ s/charset=windows-1251/charset=utf8/;
    $hotSaveText =~ s/charset=iso-8859-1/charset=utf8/;

    #TODO: add more meta tags

    $hotSaveText = '<meta name="GENERATOR" content="OpenOffice.org 3.2 (Win32)">' . $hotSaveText;
    $hotSaveText = '<meta http-equiv="CONTENT-TYPE" content="text/html; charset=utf8">' . $hotSaveText;

    $hotSaveText =~ s/\s+/ /g;
    $hotSaveText =~ s/\t//g;

    open VERSION, ">:utf8", $hotSaveFilePath;
    print VERSION $hotSaveText;
    close VERSION;

    die "Can't find hotsave file <$hotSaveFilePath>" unless -r $hotSaveFilePath;

    if ($extension ~~ ["doc", "odt", "rtf"]) {

        # Update file
        my $ooHost = $c->config->get("openoffice.host");
        my $ooPort = $c->config->get("openoffice.port");
        my $ooTimeout = $c->config->get("openoffice.timeout");

        die "Cant read configuration <openoffice.host>" unless $ooHost;
        die "Cant read configuration <openoffice.port>" unless $ooPort;
        die "Cant read configuration <openoffice.timeout>" unless $ooTimeout;

        my $ooUrl = "http://$ooHost:$ooPort/api/converter/";
        my $ooUagent = LWP::UserAgent->new();

        my $ooRequest = POST(
            $ooUrl,
            Content_Type => 'form-data',
            Content => [
                outputFormat => $filetype,
                inputDocument =>  [ $hotSaveFilePath ]
            ]
        );

        my $ooResponse = $ooUagent->request($ooRequest);
        if ($ooResponse->is_success()) {

            open FILE, "> $filepath" or die "Can't open <$filepath> : $!";
            binmode FILE;
                print FILE $ooResponse->content;
            close FILE;

        } else {
            die $ooResponse->as_string;
        }

    }

    if ($extension ~~ ["txt"]) {

        #my $converter = Text::Iconv->new("utf-8", "windows-1251");
        #my $text = $converter->convert($i_text);
        #
        #$text =~ s/<br>/\r\n/g;
        #
        #open FILE, "> $storePath/$baseName$baseExtension" or die "Can't open $storePath/$baseName$baseExtension : $!";
        #    print FILE $text;
        #close FILE;

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

1;
