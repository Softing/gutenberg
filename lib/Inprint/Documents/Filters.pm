package Inprint::Documents::Filters;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub fascicles {

    my $c = shift;

    my @data;
    my $i_edition  = $c->param("flt_edition") || undef;
    my $i_gridmode = $c->param("gridmode")    || undef;

    my $sql = "
        SELECT t1.id, t2.shortcut ||'/'|| t1.title as title, t1.description
        FROM fascicles t1, editions t2
        WHERE t1.edition = t2.id AND t1.is_system = false AND edition = ANY(?)
    ";

    my $editions = $c->access->GetChildrens("editions.documents.work");
    push @data, $editions;

    if ($i_edition) {
        $sql .= " AND t1.edition IN (
            SELECT id FROM editions WHERE path ~ ('*.' || replace(?, '-', '')::text || '.*')::lquery
        ) ";
        push @data, $i_edition;
    }

    if ($i_gridmode eq "archive")  {
        $sql .= " AND t1.is_enabled = false ";
    } else {
        $sql .= " AND t1.is_enabled = true ";
    }

    $sql .= " ORDER BY t1.enddate ASC, t2.shortcut, t1.title ";

    my $result;
    
    if ( $i_gridmode ne "briefcase" ){
        $result = $c->sql->Q($sql, \@data)->Hashes;
    }

    if ( $i_gridmode ne "archive" ){
        unshift @$result, {
            id => "00000000-0000-0000-0000-000000000000",
            icon => "briefcase",
            spacer => $c->json->true,
            bold => $c->json->true,
            title => $c->l("Briefcase")
        };
    }

    if ( $i_gridmode ne "briefcase" ){
        unshift @$result, {
            id => "clear",
            icon => "folders",
            spacer => $c->json->true,
            bold => $c->json->true,
            title => $c->l("All available")
        };
    }

    $c->render_json( { data => $result } );
}

sub headlines {

    my $c = shift;

    my @data;

    my $cgi_fascicle = $c->param("flt_fascicle") || undef;

    my $sql = " SELECT DISTINCT headline as id, headline_shortcut as title FROM documents WHERE edition=ANY(?) AND headline_shortcut is not null ";

    my $editions = $c->access->GetChildrens("editions.documents.work");
    push @data, $editions;

    if ($cgi_fascicle &&  $cgi_fascicle ne "clear") {
        $sql .= " AND fascicle = ? ";
        push @data, $cgi_fascicle;
    }
    
    $sql .= " ORDER BY headline_shortcut ";

    my $result = $c->sql->Q($sql, \@data)->Hashes;

    unshift @$result, {
        id => "clear",
        icon => "marker",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("All available")
    };

    $c->render_json( { data => $result } );
}

sub rubrics {

    my $c = shift;

    my @data;

    my $cgi_fascicle = $c->param("flt_fascicle") || undef;
    my $cgi_headline = $c->param("flt_headline") || undef;

    my $sql = " SELECT DISTINCT rubric as id, rubric_shortcut as title FROM documents WHERE edition=ANY(?) AND rubric_shortcut is not null ";

    my $editions = $c->access->GetChildrens("editions.documents.work");
    push @data, $editions;

    if ($cgi_fascicle &&  $cgi_fascicle ne "clear") {
        $sql .= " AND fascicle = ? ";
        push @data, $cgi_fascicle;
    }

    if ($cgi_headline &&  $cgi_headline ne "clear") {
        $sql .= " AND headline = ? ";
        push @data, $cgi_headline;
    }

    $sql .= " ORDER BY rubric_shortcut ";

    my $result = $c->sql->Q($sql, \@data)->Hashes;

    unshift @$result, {
        id => "clear",
        icon => "marker",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("All available")
    };

    $c->render_json( { data => $result } );
}


sub managers {

    my $c = shift;

    my $sql = $c->createSqlFilter([],
        "
            SELECT DISTINCT
                t1.manager as id,
                t2.shortcut as title,
                t2.description as description,
                CASE WHEN t2.type='group' THEN 'folders' ELSE 'user' END as icon
            FROM documents t1, view_principals t2 WHERE t2.id = t1.manager
        ",
        " ORDER BY icon, t2.shortcut; ");
    
    my $result = $c->sql->Q($sql->{sql}, $sql->{params})->Hashes;

    unshift @$result, {
        id => "clear",
        icon => "user-silhouette",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("All available")
    };

    $c->render_json( { data => $result } );
}


sub holders {

    my $c = shift;
    
    my $sql = $c->createSqlFilter([],
        "   SELECT DISTINCT
                t1.holder as id,
                t2.shortcut as title,
                t2.description as description,
                CASE WHEN t2.type='group' THEN 'folders' ELSE 'user' END as icon
            FROM documents t1, view_principals t2 WHERE t2.id = t1.holder
        ",
        " ORDER BY icon, t2.shortcut; ");

    my $result = $c->sql->Q($sql->{sql}, $sql->{params})->Hashes;

    unshift @$result, {
        id => "clear",
        icon => "user-silhouette",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("All available")
    };

    $c->render_json( { data => $result } );
}

sub progress {

    my $c = shift;

    my $sql = $c->createSqlFilter([],
        "   SELECT DISTINCT t1.readiness as id, t1.progress || '% - ' || t1.readiness_shortcut as title, t1.color, t1.progress
            FROM documents t1 WHERE 1=1 ",
        " ORDER BY progress, title ");

    my $result = $c->sql->Q($sql->{sql}, $sql->{params})->Hashes;

    unshift @$result, {
        id => "clear",
        icon => "category",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("All available")
    };

    $c->render_json( { data => $result } );
}

sub createSqlFilter {

    my $c       = shift;
    my $filters = shift;
    my $sql     = shift;
    my $order   = shift;

    my @params;

    my $mode     = $c->param("gridmode")     || "all";

    my $edition  = $c->param("flt_edition")  || undef;
    my $group    = $c->param("flt_group")    || undef;
    my $title    = $c->param("flt_title")    || undef;
    my $fascicle = $c->param("flt_fascicle") || undef;
    
    #my $editions = $c->access->GetChildrens("editions.documents.work");
    #push @params, $editions;
    #
    #$sql .= " AND t1.edition = ANY (?)";

    # Modes

    my $current_member = $c->QuerySessionGet("member.id");

    $sql .= " AND ( ";
    my $editions = $c->access->GetChildrens("editions.documents.work");
    my $departments = $c->access->GetChildrens("catalog.documents.view:*");

    $sql .= " ( ";
    $sql .= "    dcm.edition = ANY(?) ";
    $sql .= "    AND dcm.workgroup = ANY(?) ";
    $sql .= " ) ";
    push @params, $editions;
    push @params, $departments;
    $sql .= " OR manager=? ";
    push @params, $current_member;
    $sql .= " ) ";

    if ($mode eq "todo") {
        my @holders;
        $sql .= " AND holder = ANY(?) ";
        
        my $departments = $c->sql->Q(" SELECT catalog FROM map_member_to_catalog WHERE member =? ", [ $current_member ])->Values;
        
        foreach (@$departments) {
            push @holders, $_;
        }
        
        push @holders, $current_member;
        push @params, \@holders;
        
        $sql .= " AND isopen = true ";
        $sql .= " AND fascicle <> '99999999-9999-9999-9999-999999999999' ";
    }

    if ($mode eq "all") {
        $sql .= " AND isopen is true ";
        $sql .= " AND fascicle <> '99999999-9999-9999-9999-999999999999' ";
        if ($fascicle && $fascicle ne 'clear' && $fascicle ne '00000000-0000-0000-0000-000000000000') {
            $sql .= " AND fascicle <> '00000000-0000-0000-0000-000000000000' ";
        }
    }

    if ($mode eq "archive") {
        $sql .= " AND t1.isopen = false ";
        $sql .= " AND t1.fascicle <> '99999999-9999-9999-9999-999999999999' ";
        $sql .= " AND t1.fascicle <> '00000000-0000-0000-0000-000000000000' ";
    }

    if ($mode eq "briefcase") {
        $sql .= " AND t1.fascicle = '00000000-0000-0000-0000-000000000000' ";
    }

    if ($mode eq "recycle") {
        $sql .= " AND t1.fascicle = '99999999-9999-9999-9999-999999999999' ";
    }


    # Filters

    if ($title) {
        $sql .= " AND t1.title LIKE ? ";
        push @params, "%$title%";
    }

    if ($edition && $edition ne "clear") {
        $sql .= " AND ? = ANY(t1.ineditions) ";
        push @params, $edition;
    }

    if ($group && $group ne "clear") {
        $sql .= " AND ? = ANY(t1.inworkgroups) ";
        push @params, $group;
    }

    if ($fascicle && $fascicle ne "clear") {
        $sql .= " AND t1.fascicle = ? ";
        push @params, $fascicle;
    }
    
    $sql .= $order;

    return { sql => $sql, params => \@params };
}

1;
