package Inprint::Documents::Combos;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub stages {
    my $c = shift;

    my $i_edition  = $c->param("flt_edition") || undef;

    my $branchID = $c->sql->Q(" SELECT id FROM branches WHERE edition=?", [ $i_edition ])->Value;
    my $result = [];

    if ($branchID) {
        $result = $c->sql->Q("
            SELECT t1.id, t1.shortcut as title, t2.color
            FROM stages t1, readiness t2
            WHERE branch=? AND t2.id = t1.readiness
            ORDER BY t2.weight, t1.shortcut
        ", [$branchID])->Hashes;
    }

    $c->render_json( { data => $result || [] } );
}

sub managers {

    my $c = shift;
    
    my $i_term      = $c->param("term") || undef;
    my $i_workgroup = $c->param("workgroup") || undef;
    
    my $sql = "
        SELECT DISTINCT
            t1.manager as id,
            t2.shortcut as title,
            t2.description as description,
            'user' as icon
        FROM documents t1, view_principals t2, map_member_to_catalog t3
        WHERE
            t2.id = t1.manager
            AND t3.member = t1.manager
            AND t2.type = 'member'
    ";
    
    my @data;
    my @errors;
    my $success = $c->json->false;

    if ($i_term) {
        push @errors, { id => "term", msg => "Incorrectly filled field"}
            unless ($c->is_rule($i_term));
            
        unless (@errors) {
            my $bindings = $c->access->GetChildrens($i_term);
            #die @$bindings;
            #$sql .= " AND t3.catalog = ANY(?) ";
            #push @data, $bindings;
        }
    }
    
    if ($i_workgroup) {
        push @errors, { id => "workgroup", msg => "Incorrectly filled field"}
            unless ($c->is_uuid($i_workgroup));
        
        my $bindings = $c->sql->Q("
            SELECT id FROM catalog WHERE path ~ ('*.'|| replace(?, '-', '')::text ||'.*')::lquery
        ", [$i_workgroup])->Values;
        
        unless (@errors) {
            $sql .= " AND t3.catalog = ANY(?) ";
            push @data, $bindings;
        }
    }
    
    $sql .= " ORDER BY icon, t2.shortcut; ";

    my $result = $c->sql->Q($sql, \@data)->Hashes;

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $result });
    
}

sub assignments {
    my $c = shift;

    my $i_stage = $c->param("flt_stage") || undef;

    my $result = $c->sql->Q("
        SELECT t1.id, t2.type, t2.shortcut as title, t2.description,
            CASE WHEN t2.type='group' THEN 'folders' ELSE 'user' END as icon
        FROM map_principals_to_stages t1, view_principals t2
        WHERE t2.id = t1.principal AND t1.stage=?
        ORDER BY t2.type, t2.shortcut
    ", [ $i_stage ])->Hashes;

    $c->render_json( { data => $result } );
}

sub fascicles {

    my $c = shift;

    my $i_edition  = $c->param("flt_edition") || undef;

    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));

    my $result;

    unless (@errors) {
        my $sql = "
            SELECT t1.id, t2.shortcut ||'/'|| t1.title as title, t1.description
            FROM fascicles t1, editions t2
            WHERE
                t1.edition = t2.id
                AND edition = ANY(?)
                AND t1.issystem = false
                AND t1.enabled = true
                AND t1.edition IN (
                    SELECT id FROM editions WHERE path ~ ('*.' || replace(?, '-', '')::text || '.*')::lquery
                )
            ORDER BY t1.enddate DESC, t2.shortcut, t1.title ";
        
        my $editions = $c->access->GetChildrens("editions.documents.work");
        $result = $c->sql->Q($sql, [ $editions, $i_edition ])->Hashes;
        
        unshift @$result, {
            id => "99999999-9999-9999-9999-999999999999",
            icon => "bin",
            spacer => $c->json->true,
            bold => $c->json->true,
            title => $c->l("Recycle Bin"),
            description => $c->l("Removed documents")
        };
        unshift @$result, {
            id => "00000000-0000-0000-0000-000000000000",
            icon => "briefcase",
            bold => $c->json->true,
            title => $c->l("Briefcase"),
            description => $c->l("Briefcase for reserved documents")
        };
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $result || [] });
}

sub headlines {
    my $c = shift;
    my $i_fascicle = $c->param("flt_fascicle") || undef;
    my $sql = " SELECT DISTINCT headline as id, headline_shortcut as title FROM documents WHERE fascicle = ? ORDER BY headline_shortcut ";
    my $result = $c->sql->Q($sql, [ $i_fascicle ])->Hashes;
    $c->render_json( { data => $result } );
}

sub rubrics {
    my $c = shift;
    my $i_headline = $c->param("flt_headline") || undef;
    my $sql = " SELECT rubric as id, rubric_shortcut as title FROM documents WHERE headline=? ORDER BY rubric_shortcut ";
    my $result = $c->sql->Q($sql, [ $i_headline ])->Hashes;
    $c->render_json( { data => $result } );
}

1;
