package Inprint::Catalog::Members;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use File::Path qw(make_path);

use base 'Inprint::BaseController';

sub list {

    my $c = shift;

    my @params;
    my $result = [];

    my $i_filter = $c->param("filter") || undef;
    my $i_node = $c->param("node") || undef;

    if ($i_node eq 'root-node') {
        $i_node = '00000000-0000-0000-0000-000000000000';
    }

    my $sql = "
        SELECT distinct t1.id, t1.login, t2.title, t2.shortcut, t2.position
        FROM members t1
        LEFT JOIN profiles t2 ON t1.id = t2.id
        LEFT JOIN map_member_to_catalog m1 ON m1.member = t1.id
        WHERE 1=1

    ";
    push @params, $i_node;

    if ($i_node eq '00000000-0000-0000-0000-000000000000') {
        $sql .= " AND (
                m1.catalog in (
                     SELECT id FROM catalog WHERE path ~ ('*.' || replace(?, '-', '')::text || '.*')::lquery
                ) OR m1.catalog is null
            )
        ";
    } else {
        $sql .= " AND
            m1.catalog in (
                 SELECT id FROM catalog WHERE path ~ ('*.' || replace(?, '-', '')::text || '.*')::lquery
            ) ";
    }

    if ( $i_filter ) {
        $sql .= " AND (login LIKE ? OR title LIKE ? OR shortcut LIKE ?) ";
        push @params, "%$i_filter%";
        push @params, "%$i_filter%";
        push @params, "%$i_filter%";
    }

    if ($i_node) {
        $result = $c->sql->Q(" $sql ORDER BY t2.shortcut ", \@params)->Hashes;
    }

    $c->render_json( { data => $result } );
}

sub create {

    my $c = shift;

    my $i_login    = $c->param("login");
    my $i_title     = $c->param("title");
    my $i_password = $c->param("password");
    my $i_position = $c->param("position");
    my $i_shortcut = $c->param("shortcut");

    my $result = {
        errors => []
    };

    # Check input

    push @{ $result->{errors} }, { id => "login", msg => "" }
        unless $i_login;

    push @{ $result->{errors} }, { id => "title", msg => "" }
        unless $i_title;

    push @{ $result->{errors} }, { id => "password", msg => "" }
        unless $i_password;

    push @{ $result->{errors} }, { id => "position", msg => "" }
        unless $i_position;

    push @{ $result->{errors} }, { id => "shortcut", msg => "" }
        unless $i_shortcut;

    my $login = $c->sql->Q(
        " SELECT true FROM members WHERE login=?", [ $i_login ])->Value;

    if ($login) {
        push @{ $result->{errors} }, { id => "login", msg => "" };
    }

    # Process request

    unless (@{ $result->{errors} }) {

        $result->{success} = 1;

        my $id = $c->uuid();

        $c->sql->Do("
            INSERT INTO members (id, login, password)
                VALUES (?,?,encode( digest(?, 'sha256'), 'hex'))
        ", [ $id, $i_login, $i_password ]);

        $c->sql->Do("
            INSERT INTO map_member_to_catalog (member, catalog)
                VALUES (?,?)
            ", [ $id, '00000000-0000-0000-0000-000000000000' ]);


        $c->sql->Do("
            INSERT INTO profiles (id, title, shortcut, position)
                VALUES (?,?,?,?)
            ", [ $id, $i_title, $i_shortcut, $i_position ]);

    }
    $c->render_json( $result );
}

sub delete {
    my $c = shift;

    my @ids = $c->param("id");

    foreach my $id (@ids) {
        $c->sql->Do(" DELETE FROM members WHERE id=? ", [ $id ]);
    }

    $c->render_json( { success => 1 } );
}

sub setup {
    my $c = shift;

    my $member_id     = $c->QuerySessionGet("member.id");

    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_position    = $c->param("position");
    my $i_image       = $c->req->upload('image');

    my $i_destination = $c->param("capture.destination");

    if ($i_image) {

        my $path = $c->config->get("store.path");
        my $upload_max_size = 3 * 1024 * 1024;

        my $image_type = $i_image->headers->content_type;
        my %valid_types = map {$_ => 1} qw(image/gif image/jpeg image/png);

        # Content type is wrong
        if ($valid_types{$image_type}) {

            unless (-d "$path/profiles/$member_id/") {
                make_path "$path/profiles/$member_id/";
            }

            if (-d -w "$path/profiles/$member_id/") {
                $i_image->move_to("$path/profiles/$member_id/profile.new");
                system("convert -resize 200 $path/profiles/$member_id/profile.new $path/profiles/$member_id/profile.png");
            }
        }
    }

    my $result = {
        success => $c->json->false,
        errors  => []
    };

    push @{ $result->{errors} }, { id => "title", msg => "" }
        unless $i_title;

    push @{ $result->{errors} }, { id => "shortcut", msg => "" }
        unless $i_shortcut;

    push @{ $result->{errors} }, { id => "position", msg => "" }
        unless $i_position;

    push @{ $result->{errors} }, { id => "destination", msg => "" }
        unless $i_destination;

    unless (@{ $result->{errors} }) {

        $c->sql->Do("DELETE FROM profiles WHERE id=?", [ $member_id ]);
        $c->sql->Do("INSERT INTO profiles (id, title, shortcut, position) VALUES (?, ?, ?, ?)",[
            $member_id, $i_title, $i_shortcut, $i_position
        ]);

        $c->sql->Do(
            "DELETE FROM options WHERE option_name=? AND member=?", [
                "transfer.capture.destination", $member_id
        ]);
        $c->sql->Do(
            "INSERT INTO OPTIONS (member, option_name, option_value) VALUES (?, ?, ?)", [
                $member_id, "transfer.capture.destination", $i_destination
        ]);

        $result->{success} = $c->json->true;
    }

    $c->render_json( $result );
}

sub map {
    my $c = shift;

    my $i_member      = $c->param("member");
    my $i_catalog     = $c->param("catalog");
    my @i_rules       = $c->param("rules");
    my $i_recursive   = $c->param("recursive");

    $c->sql->Do(
        " DELETE FROM map_member_to_rule WHERE member=? AND catalog=? ",
        [ $i_member, $i_catalog ]);

    foreach my $string (@i_rules) {
        my ($rule, $mode) = split "::", $string;
        $c->sql->Do("
            INSERT INTO map_member_to_rule(member, catalog, rule, mode)
                VALUES (?, ?, ?, ?);
        ", [$i_member, $i_catalog, $rule, $mode]);
    }

    if ($i_recursive) {

        my $groups = $c->sql->Q(
            " SELECT id FROM catalog WHERE path LIKE ? ",
            ["%$i_catalog%"])->Hashes;

        foreach my $item (@$groups) {

            $c->sql->Do(
                " DELETE FROM map_member_to_rule WHERE member=? AND catalog=? ",
                [ $i_member, $item->{id} ]);

            foreach my $string (@i_rules) {
                my ($rule, $mode) = split "::", $string;
                $c->sql->Do("
                    INSERT INTO map_member_to_rule(member, catalog, rule, mode)
                        VALUES (?, ?, ?, ?);
                ", [$i_member, $item->{id}, $rule, $mode]);
            }

        }
    }

    $c->render_json( { success => $c->json->true } );
}

sub unmap {
    my $c = shift;

    my $i_member      = $c->param("member");
    my $i_catalog     = $c->param("catalog");
    my @i_rules       = $c->param("rules");
    my $i_recursive   = $c->param("recursive");

    $c->sql->Do(
        " DELETE FROM map_member_to_rule WHERE member=? AND catalog=? ",
        [ $i_member, $i_catalog ]);

    foreach my $string (@i_rules) {
        my ($rule, $mode) = split "::", $string;
        $c->sql->Do("
            INSERT INTO map_member_to_rule(member, catalog, rule, mode)
                VALUES (?, ?, ?, ?);
        ", [$i_member, $i_catalog, $rule, $mode]);
    }

    if ($i_recursive) {

        my $groups = $c->sql->Q(
            " SELECT id FROM catalog WHERE path LIKE ? ",
            ["%$i_catalog%"])->Hashes;

        foreach my $item (@$groups) {

            $c->sql->Do(
                " DELETE FROM map_member_to_rule WHERE member=? AND catalog=? ",
                [ $i_member, $item->{id} ]);

            foreach my $string (@i_rules) {
                my ($rule, $mode) = split "::", $string;
                $c->sql->Do("
                    INSERT INTO map_member_to_rule(member, catalog, rule, mode)
                        VALUES (?, ?, ?, ?);
                ", [$i_member, $item->{id}, $rule, $mode]);
            }

        }
    }

    $c->render_json( { success => $c->json->true } );
}


1;
