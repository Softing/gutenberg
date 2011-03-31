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

    my $i_id = $c->param("id");

    if ($i_id eq "self") {
        $i_id = $c->getSessionValue("member.id");
    }

    my $path = $c->config->get("store.path");

    if ( -r "$path/profiles/$i_id/profile.png") {
        $c->tx->res->headers->content_type('image/png');
        $c->res->content->asset(Mojo::Asset::File->new(path => "$path/profiles/$i_id/profile.png"));
    } elsif ( -r "$path/profiles/00000000-0000-0000-0000-000000000000/profile.png") {
        $c->tx->res->headers->content_type('image/png');
        $c->res->content->asset(Mojo::Asset::File->new(path => "$path/profiles/00000000-0000-0000-0000-000000000000/profile.png"));
    }

    $c->render_json({});
}

sub read {

    my $c = shift;

    my $result = {};
    my $success = $c->json->false;
    my $i_id = $c->param("id");

    if ($i_id eq "self") {
        $i_id = $c->session("member");
    }

    if ($i_id) {
        $result = $c->Q("
            SELECT distinct t1.id, t1.login, t2.title, t2.shortcut, t2.job_position as position
            FROM members t1
            LEFT JOIN profiles t2 ON t1.id = t2.id
            WHERE t1.id = ?
        ", [ $i_id ])->Hash || {};

        $success = $c->json->true;
    }

    $c->render_json( { success => $success, data => $result } );

}

sub update {
    my $c = shift;

    my $i_id = $c->param("id");

    my $i_login    = $c->param("login");
    my $i_password = $c->param("password");

    my $i_title     = $c->param("title");
    my $i_shortcut = $c->param("shortcut");
    my $i_position = $c->param("position");

    my $i_image    = $c->req->upload('image');

    my @errors;
    my $result = {};

    unless (@errors) {

        # Upload image
        if ($i_image) {

            my $path = $c->config->get("store.path");
            my $upload_max_size = 3 * 1024 * 1024;

            my $image_type = $i_image->headers->content_type;
            my %valid_types = map {$_ => 1} qw(image/gif image/jpeg image/png);

            # Content type is wrong
            if ($valid_types{$image_type}) {

                unless (-d "$path/profiles/$i_id/") {
                    make_path "$path/profiles/$i_id/";
                }

                if (-d -w "$path/profiles/$i_id/") {
                    $i_image->move_to("$path/profiles/$i_id/profile.new");
                    system("convert -resize 200 $path/profiles/$i_id/profile.new $path/profiles/$i_id/profile.png");
                }

            }
        }

        # Process profile
        if ($i_login) {
            my $login_exists = $c->Q(" SELECT id FROM members WHERE login=? ", [ $i_login ])->Value;
            unless ($login_exists) {
                $c->Do("UPDATE members SET login=? WHERE id=? ",[ $i_login, $i_id ]);
            }
        }
        if ($i_password) {
            $c->Do("UPDATE members SET password=encode( digest(?, 'sha256'), 'hex') WHERE id=?",[ $i_password, $i_id ]);
        }

        # Update Profile

        my $count = $c->Q("SELECT count(*) FROM profiles WHERE id=?",[$i_id])->Value;

        if ($count) {
            $c->Do("UPDATE profiles SET title=?, shortcut=?, job_position=?, updated=now() WHERE id=?",[$i_title, $i_shortcut, $i_position, $i_id]);
        } else {
            $c->Do("
                INSERT INTO profiles(id, title, shortcut, job_position, created, updated)
                VALUES (?, ?, ?, ?, now(), now());",
            [ $i_id, $i_title, $i_shortcut, $i_position]);
        }

        # Update Documents
        $c->Do("UPDATE documents SET creator_shortcut=? WHERE creator=?",  [ $i_shortcut, $i_id ]);
        $c->Do("UPDATE documents SET manager_shortcut=? WHERE manager=?",  [ $i_shortcut, $i_id ]);
        $c->Do("UPDATE documents SET holder_shortcut=? WHERE holder=?",    [ $i_shortcut, $i_id ]);

    }

    $result->{success} = $c->json->true;

    $c->render_json($result);
}

1;
