package Inprint::Profile;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use File::Path qw(make_path);

use base 'Inprint::BaseController';

sub image {
    my $c = shift;

    my $id = $c->param("id");

    my $body = '';

    my $path = $c->config->get("store.path");

    if ( -r "$path/profiles/$id/profile.png") {
        $c->tx->res->headers->content_type('image/png');
        $c->res->content->asset(Mojo::Asset::File->new(path => "$path/profiles/$id/profile.png"));
    }

    $c->render_json({});
}

sub load {
    my $c = shift;
}

sub update {
    my $c = shift;

    my $id = $c->param("id");

    my $login    = $c->param("login");
    my $password = $c->param("password");

    my $name     = $c->param("name");
    my $shortcut = $c->param("shortcut");
    my $position = $c->param("position");

    my $image    = $c->req->upload('image');

    my @errors;
    my $result = {};

    # upload image
    if ($image) {

        my $path = $c->config->get("store.path");
        my $upload_max_size = 3 * 1024 * 1024;

        #if ($image->size > $upload_max_size) {

            my $image_type = $image->headers->content_type;
            my %valid_types = map {$_ => 1} qw(image/gif image/jpeg image/png);

            # Content type is wrong
            if ($valid_types{$image_type}) {

                unless (-d "$path/profiles/$id/") {
                    make_path "$path/profiles/$id/";
                }

                if (-d -w "$path/profiles/$id/") {
                    $image->move_to("$path/profiles/$id/profile.new");
                    system("convert -resize 200 $path/profiles/$id/profile.new $path/profiles/$id/profile.png");
                }
            }
        #}
    }

    # save result to DB
    if ($login) {

    }

    if ($password) {
        $c->sql->Do(
            "UPDATE members SET password=encode( digest(?, 'sha256'), 'hex') WHERE id=?",[
                $password, $id
        ]);
    }

    $c->sql->Do(
        "UPDATE profiles SET name=?, shortcut=?, position=? WHERE id=?",[
            $name, $shortcut, $position, $id
    ]);

    unless (@errors) {
        $result->{success} = 1;
    }

    $c->render_json($result);
}

1;
