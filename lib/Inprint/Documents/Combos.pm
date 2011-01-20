package Inprint::Documents::Combos;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub managers {

    my $c = shift;

    my $i_edition   = $c->param("edition") || undef;
    my $i_workgroup = $c->param("workgroup") || undef;

    my $result;
    my @errors;
    my $success = $c->json->false;

    unless (@errors) {

        my @params;
        my $sql = "
            SELECT
                t1.id,
                t1.shortcut as title,
                t3.shortcut || '/' || t1.description as description,
                'user' as icon
            FROM view_principals t1, map_member_to_catalog t2, catalog t3
            WHERE
                t1.type = 'member'
                AND t1.id = t2.member
                AND t3.id = t2.catalog
        ";

        # Filter by workgroup
        if ($i_workgroup) {
            $sql .= " AND t2.catalog = ? ";
            push @params, $i_workgroup;
        }

        $sql .= " AND ( 1=1 ";

        # Filter by rules
        my $create_bindings = $c->access->GetChildrens("catalog.documents.create:*");
        $sql .= " OR t2.catalog = ANY(?) ";
        push @params, $create_bindings;

        my $assign_bindings = $c->access->GetChildrens("catalog.documents.assign:*");
        $sql .= " OR  t2.catalog = ANY(?) ";
        push @params, $assign_bindings;

        $sql .= " ) ";
        $sql .= " ORDER BY icon, t1.shortcut; ";

        $result = $c->sql->Q($sql, \@params)->Hashes;

        if ($i_workgroup) {
            if ($c->access->Check("catalog.documents.assign:*", $i_workgroup)) {
                unshift @$result, {
                    "icon" => "users",
                    "title" => $c->l("Add to the department"),
                    "id" => $i_workgroup,
                    "description" => $c->l("Department")
                };
            }
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $result });

}

sub fascicles {

    my $c = shift;

    my $i_term     = $c->param("term") || undef;
    my $i_edition  = $c->param("flt_edition") || undef;

    my $result;
    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));

    if ($i_term) {
        push @errors, { id => "term", msg => "Incorrectly filled field"}
            unless ($c->is_rule($i_term));
    }

    unless (@errors) {

        my @params;
        my $sql = "
                SELECT t1.id, t2.shortcut ||'/'|| t1.title as title, t1.description
                FROM fascicles t1, editions t2
                WHERE
                    t1.edition = t2.id
                    AND t1.deadline >= now()
                    AND t1.id <> '99999999-9999-9999-9999-999999999999'
                    AND t1.id <> '00000000-0000-0000-0000-000000000000'
        ";

        if ($i_term) {
            my $bindings = $c->access->GetChildrens($i_term);
            $sql .= " AND t1.edition = ANY(?) ";
            push @params, $bindings;
        }

        my $editions = $c->sql->Q(" SELECT id FROM editions WHERE path ~ ('*.' || replace(?, '-', '')::text || '.*')::lquery ", [$i_edition])->Values;
        $sql .= " AND t1.edition = ANY(?) ";
        push @params, $editions;

        $result = $c->sql->Q(" $sql ORDER BY t1.deadline DESC, t2.shortcut, t1.title ", \@params)->Hashes;

        if ($c->access->Check($i_term, $i_edition)) {
            unshift @$result, {
                id => "00000000-0000-0000-0000-000000000000",
                icon => "briefcase",
                bold => $c->json->true,
                title => $c->l("Briefcase"),
                description => $c->l("Briefcase for reserved documents")
            };
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $result || [] });
}

sub headlines {
    my $c = shift;

    my $i_edition  = $c->param("flt_edition") || undef;
    my $i_fascicle = $c->param("flt_fascicle") || undef;

    my $result;
    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    my $edition; unless (@errors) {
        $edition = $c->sql->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($edition->{id});
    }

    my $fascicle; unless (@errors) {
        $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless ($fascicle->{id});
    }

    unless (@errors) {
        $result = $c->sql->Q("
            SELECT DISTINCT id, title FROM fascicles_indx_headlines
            WHERE fascicle=?
            ORDER BY title",
            [ $i_fascicle ])->Hashes;
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $result || [] });
}

sub rubrics {
    my $c = shift;

    my $i_fascicle = $c->param("flt_fascicle") || undef;
    my $i_headline = $c->param("flt_headline") || undef;

    my $result;
    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    push @errors, { id => "headline", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_headline));

    my $fascicle; unless (@errors) {
        $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless ($fascicle->{id});
    }

    unless (@errors) {
        $result = $c->sql->Q("
            SELECT DISTINCT id, title FROM fascicles_indx_rubrics
            WHERE fascicle=? AND headline = ?
            ORDER BY title",
            [ $i_fascicle, $i_headline ])->Hashes;
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $result || [] });
}


1;
