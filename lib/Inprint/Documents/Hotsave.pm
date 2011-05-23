package Inprint::Documents::Hotsave;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use Encode;

use strict;
use warnings;

use HTML::Scrubber;

use base 'Mojolicious::Controller';

sub list {
    my $c = shift;

    my $i_file = $c->param("file");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "file", $i_file);

    my $cacheRecord = $c->Q(" SELECT * FROM cache_files WHERE id=? ", [ $i_file ])->Hash;

    $c->check_uuid( \@errors, "record", $cacheRecord->{id} );

    my $filename = $cacheRecord->{file_path} ."/". $cacheRecord->{file_name};
    $filename =~ s/\/+/\//g;

    my $data = $c->Q(" SELECT
            id,
            hotsave_creator_shortcut as creator,
            hotsave_branch_shortcut as branch,
            hotsave_stage_shortcut as stage,
            hotsave_color as color,
            to_char(created, 'YYYY-MM-DD HH24:MI:SS') as created
        FROM cache_hotsave WHERE hotsave_origin=? ORDER BY created DESC", [ $filename ])->Hashes;

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $data } );
}

sub read {
    my $c = shift;

    my $i_version = $c->param("version");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "version", $i_version);

    my $fileContent;

    my $cacheRecord = $c->Q(" SELECT hotsave_path FROM cache_hotsave WHERE id=? ", [ $i_version ])->Value;

    my $basepath = $c->config->get("store.path");
    my $filepath = "$basepath/$cacheRecord";

    $filepath = __adaptPath($c, $filepath);
    $filepath = __encodePath($c, $filepath);

    if ( -r $filepath ) {
        open my $INPUT, "<", $filepath || die "Can't open <$filepath> : $!";
        binmode $INPUT;
        while (<$INPUT>) { $fileContent .= $_; }
        close $INPUT;
    }
    else {
        $fileContent = "File not found!";
    }

    $success = $c->json->true unless (@errors);

    $fileContent = __clearHtml($fileContent);

    $fileContent = Encode::decode("utf8", $fileContent);

    $c->render( text => "$fileContent" );
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

sub __clearHtml {

    my $html = shift;

    my $scrubber = HTML::Scrubber->new( allow => [ qw[ p br b i u ol ul li sub sup table col tr td th tbody ] ]);
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

    $html =~ s/<title>(.*?)<\/title>//ig;

    $html = $scrubber->scrub($html);

    $html =~ s/^\s+|\s+$//g;
    $html =~ s/<font><font>//g;
    $html =~ s/<\/font><\/font>//g;

    $html =~ s/<table/<table border=1/ig;

    $html =~ s/\t+/ /ig;
    $html =~ s/\s+/ /ig;

  return $html;
}

1;
