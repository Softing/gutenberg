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
        SELECT distinct t1.id, t1.login, t2.title, t2.shortcut, t2.job_position as position
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
            INSERT INTO profiles (id, title, shortcut, job_position)
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

sub rules {

    my $c = shift;

    my $i_member = $c->param("member") || $c->QuerySessionGet("member.id");

    my $result = $c->sql->Q("
        (
            SELECT t1.area, t1.binding, t2.shortcut as binding_shortcut
            FROM map_member_to_rule t1, editions t2
            WHERE t1.member=? AND t1.area = 'domain' AND t2.id = t1.binding
            GROUP BY area, binding, shortcut )
        UNION ALL
        (
            SELECT t1.area, t1.binding, t2.shortcut as binding_shortcut
            FROM map_member_to_rule t1, editions t2
            WHERE t1.member=? AND t1.area = 'edition' AND t2.id = t1.binding
            GROUP BY area, binding, shortcut )
        UNION ALL
        (
            SELECT t1.area, t1.binding, t2.shortcut as binding_shortcut
            FROM map_member_to_rule t1, catalog t2
            WHERE t1.member=? AND t1.area = 'group' AND t2.id = t1.binding
            GROUP BY area, binding, shortcut)
        UNION ALL
        (
            SELECT t1.area, t1.binding, t2.shortcut as binding_shortcut
            FROM map_member_to_rule t1, catalog t2
            WHERE t1.member=? AND t1.area = 'member' AND t2.id = t1.binding
            GROUP BY area, binding, shortcut)
    ", [ $i_member, $i_member, $i_member, $i_member ])->Hashes;
    
    foreach my $item (@$result) {
        $item->{rules} = $c->sql->Q("
            SELECT t2.title
            FROM map_member_to_rule t1, rules t2
            WHERE t1.member=? AND t1.area=? AND binding=? AND t2.id=t1.term
        ",[ $i_member, $item->{area}, $item->{binding} ])->Values;
    }

    $c->render_json( { data => $result } );
}

sub setup {
    my $c = shift;

    my $member_id     = $c->QuerySessionGet("member.id");

    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_position    = $c->param("position");
    my $i_image       = $c->req->upload('image');

    my $i_edition            = $c->param("edition");
    my $i_edition_shortcut   = $c->param("edition-shortcut");
    
    my $i_workgroup          = $c->param("workgroup");
    my $i_workgroup_shortcut = $c->param("workgroup-shortcut");

    my @errors;
    my $success = $c->json->false;

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

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));
        
    push @errors, { id => "shortcut", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_shortcut));
        
    push @errors, { id => "position", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_position));
        
    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));
        
    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_edition_shortcut));
        
    push @errors, { id => "workgroup", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_workgroup));
        
    push @errors, { id => "workgroup", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_workgroup_shortcut));
    
    unless (@errors) {
        $c->sql->Do("DELETE FROM profiles WHERE id=?", [ $member_id ]);
        $c->sql->Do("INSERT INTO profiles (id, title, shortcut, job_position) VALUES (?, ?, ?, ?)",[
            $member_id, $i_title, $i_shortcut, $i_position
        ]);
        
        $c->sql->Do("DELETE FROM options WHERE option_name=? AND member=?", ["default.edition", $member_id]);
        $c->sql->Do("INSERT INTO OPTIONS (member, option_name, option_value) VALUES (?, ?, ?)", [$member_id, "default.edition", $i_edition]);
        $c->sql->Do("DELETE FROM options WHERE option_name=? AND member=?", ["default.edition.name", $member_id]);
        $c->sql->Do("INSERT INTO OPTIONS (member, option_name, option_value) VALUES (?, ?, ?)", [$member_id, "default.edition.name", $i_edition_shortcut]);
        
        $c->sql->Do("DELETE FROM options WHERE option_name=? AND member=?", ["default.workgroup", $member_id]);
        $c->sql->Do("INSERT INTO OPTIONS (member, option_name, option_value) VALUES (?, ?, ?)", [$member_id, "default.workgroup", $i_workgroup]);
        $c->sql->Do("DELETE FROM options WHERE option_name=? AND member=?", ["default.workgroup.name", $member_id]);
        $c->sql->Do("INSERT INTO OPTIONS (member, option_name, option_value) VALUES (?, ?, ?)", [$member_id, "default.workgroup.name", $i_workgroup_shortcut]);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

1;
