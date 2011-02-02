package Inprint::Files;

# Inprint Content 5.0
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use File::Basename;
use Image::Magick;

use base 'Inprint::BaseController';

sub download {
    my $c = shift;


    my $id = $c->param("id");

    my $rootpath = $c->config->get("store.path");
    my $filepath = $c->sql->Q("SELECT file_path || '/' || file_name FROM cache_files WHERE id=?", [ $id ])->Value;

    $filepath = "$rootpath/$filepath";

    if ($^O eq "MSWin32") {
        $filepath =~ s/\//\\/g;
        $filepath =~ s/\\+/\\/g;
    }

    if ($^O eq "linux") {
        $filepath =~ s/\\/\//g;
        $filepath =~ s/\/+/\//g;
    }

    $c->tx->res->headers->content_type('image/png');
    $c->res->content->asset(Mojo::Asset::File->new(path => $filepath));
    $c->render_static();
}

sub preview {

    my $c = shift;

    my ($id, $size) = split 'x', $c->param("id");

    #die "$id, $size" . $c->{stash}->{format};

    my @errors;
    my $success = $c->json->false;

    my $rootpath = $c->config->get("store.path");
    my $filepath = $c->sql->Q("SELECT file_path || '/' || file_name FROM cache_files WHERE id=?", [ $id ])->Value;

    $filepath = "$rootpath/$filepath";

    if ($^O eq "MSWin32") {
        $filepath =~ s/\//\\/g;
        $filepath =~ s/\\+/\\/g;
    }

    if ($^O eq "linux") {
        $filepath =~ s/\\/\//g;
        $filepath =~ s/\/+/\//g;
    }

    if (-r $filepath) {
        my ($name, $path, $extension) = fileparse($filepath, qr/(\.[^.]+){1}?/);
        $extension =~ s/^.//g;
        if ($extension ~~ ['jpg', 'jpeg', 'png', 'gif']) {
            if (-w "$path/.thumbnails") {
                unless (-r "$path/.thumbnails/$name-$size.png") {
                    my $image = Image::Magick->new;
                    my $x = $image->Read($filepath);
                    warn "$x" if "$x";

                    $x = $image->AdaptiveResize(geometry=>$size);
                    warn "$x" if "$x";

                    $x = $image->Write("$path/.thumbnails/$name-$size.png");
                    warn "$x" if "$x";
                }
            }
            if (-r "$path/.thumbnails/$name-$size.png") {
                $c->tx->res->headers->content_type('image/png');
                $c->res->content->asset(Mojo::Asset::File->new(path => "$path/.thumbnails/$name-$size.png"));
                $c->render_static();
            }
        }
    }

    #my $storePath = $c->getDocumentPath($document->{filepath}, \@errors);
    #my $sqlite = $c->getSQLiteHandler($storePath);
    #
    #$sqlite->{sqlite_unicode} = 0;
    #
    #my $sth  = $sqlite->prepare("SELECT * FROM files WHERE id = ?");
    #$sth->execute( $i_file );
    #my $record = $sth->fetchrow_hashref;
    #$sth->finish();
    #
    #if ($^O eq "MSWin32") {
    #    my $converter = Text::Iconv->new("utf-8", "windows-1251");
    #    $record->{filename} = $converter->convert($record->{filename});
    #}
    #
    #if ($record->{id} && -r "$storePath/$record->{filename}") {
    #
    #    unless (-r "$storePath/.thumbnails/$record->{id}.png") {
    #
    #        my $host = $c->config->get("openoffice.host");
    #        my $port = $c->config->get("openoffice.port");
    #        my $timeout = $c->config->get("openoffice.timeout");
    #
    #        my $url = "http://$host:$port/api/thumbnail/";
    #
    #        my $ua  = LWP::UserAgent->new();
    #
    #        my $filepath = "$storePath/$record->{filename}";
    #
    #        my $request = POST "$url", Content_Type => 'form-data',
    #            Content => [ inputDocument =>  [  "$storePath/$record->{filename}" ] ];
    #
    #
    #        $ua->timeout($timeout);
    #        my $response = $ua->request($request);
    #
    #        if ($response->is_success()) {
    #            open FILE, "> $storePath/.thumbnails/$record->{id}.png" or die "Can't open $storePath/.thumbnails/$record->{id}.png : $!";
    #                binmode FILE;
    #                print FILE $response->content;
    #            close FILE;
    #        } else {
    #            push @errors, { id => "responce", msg => $response->status_line };
    #        }
    #
    #        if (-w "$storePath/.thumbnails/$record->{id}.png") {
    #            my $image = Image::Magick->new;
    #            my $x = $image->Read("$storePath/.thumbnails/$record->{id}.png");
    #            warn "$x" if "$x";
    #
    #            $x = $image->AdaptiveResize(geometry=>"100x80");
    #            warn "$x" if "$x";
    #
    #            $x = $image->Write("$storePath/.thumbnails/$record->{id}.png");
    #            warn "$x" if "$x";
    #        }
    #
    #    }
    #
    #    if (-r "$storePath/.thumbnails/$record->{id}.png") {
    #        $c->tx->res->headers->content_type('image/png');
    #        $c->res->content->asset(Mojo::Asset::File->new(path => "$storePath/.thumbnails/$record->{id}.png"));
    #        $c->render_static();
    #    }
    #    unless (-r "$storePath/.thumbnails/$record->{id}.png") {
    #        push @errors, { id => "result", msg => "Cant read file thumbnail"}
    #            unless -e -r "$storePath/.thumbnails/$record->{id}.png";
    #    }
    #
    #}
    #
    #$sqlite->disconnect();
    #
    #if (@errors) {
    #    $success = $c->json->true unless (@errors);
    #    $c->render_json( { success => $success, errors => \@errors } );
    #}

    $c->render_json({  });
}

1;