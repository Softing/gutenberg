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
            id => "all",
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

    my $cgi_edition  = $c->param("flt_edition")  || undef;
    my $cgi_fascicle = $c->param("flt_fascicle") || undef;

    $cgi_edition  = "00000000-0000-0000-0000-000000000000" if $cgi_edition  eq "all";
    $cgi_fascicle = undef if $cgi_fascicle eq "all";

    my @params;
    my $sql = "
        SELECT DISTINCT t1.headline_shortcut as id, t1.headline_shortcut as title
        FROM documents t1
        WHERE t1.edition=ANY(?) AND t1.headline_shortcut is not null
    ";

    my $editions = $c->access->GetChildrens("editions.documents.work");
    push @params, $editions;

    if ($cgi_edition && $cgi_edition ne "all") {
        my $editions = $c->sql->Q(" SELECT id FROM editions WHERE path <@ ( SELECT path FROM editions WHERE id=?)", [ $cgi_edition ])->Values;
        $sql .= " AND t1.edition = ANY(?) ";
        push @params, $editions;
    }

    if ($cgi_fascicle &&  $cgi_fascicle ne "all") {
        $sql .= " AND t1.fascicle = ? ";
        push @params, $cgi_fascicle;
    }

    my $sql_filter = $c->createSqlFilter();
    $sql .= " $sql_filter->{sql} ";
    @params = (@params, @{ $sql_filter->{params} });

    $sql .= " ORDER BY t1.headline_shortcut ";

    my $result = $c->sql->Q($sql, \@params)->Hashes;

    unshift @$result, {
        id => "all",
        icon => "marker",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("All available")
    };

    $c->render_json( { data => $result } );
}

sub rubrics {

    my $c = shift;

    my $cgi_edition  = $c->param("flt_edition")  || undef;
    my $cgi_fascicle = $c->param("flt_fascicle") || undef;
    my $cgi_headline = $c->param("flt_headline") || undef;

    my @params;
    my $sql = "
        SELECT DISTINCT t1.rubric_shortcut as id, t1.rubric_shortcut as title
        FROM documents t1
        WHERE t1.edition=ANY(?) AND t1.rubric_shortcut is not null
    ";

    my $editions = $c->access->GetChildrens("editions.documents.work");
    push @params, $editions;

    if ($cgi_edition &&  $cgi_edition ne "all") {
        my $editions = $c->sql->Q(" SELECT id FROM editions WHERE path <@ ( SELECT path FROM editions WHERE id=?)", [ $cgi_edition ])->Values;
        $sql .= " AND t1.edition = ANY(?) ";
        push @params, $editions;
    }

    if ($cgi_fascicle &&  $cgi_fascicle ne "all") {
        $sql .= " AND t1.fascicle = ? ";
        push @params, $cgi_fascicle;
    }

    if ($cgi_headline &&  $cgi_headline ne "all") {
        $sql .= " AND t1.headline_shortcut = ? ";
        push @params, $cgi_headline;
    }

    my $sql_filter = $c->createSqlFilter();
    $sql .= " $sql_filter->{sql} ";
    @params = (@params, @{ $sql_filter->{params} });

    $sql .= " ORDER BY t1.rubric_shortcut ";

    my $result = $c->sql->Q($sql, \@params)->Hashes;

    unshift @$result, {
        id => "all",
        icon => "marker",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("All available")
    };

    $c->render_json( { data => $result } );
}


sub managers {

    my $c = shift;

    my @params;
    my $sql = "
        SELECT DISTINCT
            t1.manager as id,
            t2.shortcut as title,
            t2.description as description,
            CASE WHEN t2.type='group' THEN 'folders' ELSE 'user' END as icon
        FROM documents t1, view_principals t2 WHERE t2.id = t1.manager
    ";

    my $sql_filter = $c->createSqlFilter();
    $sql .= " $sql_filter->{sql} ";
    @params = (@params, @{ $sql_filter->{params} });

    $sql .= " ORDER BY icon, t2.shortcut; ";

    my $result = $c->sql->Q($sql, \@params)->Hashes;

    unshift @$result, {
        id => "all",
        icon => "user-silhouette",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("All available")
    };

    $c->render_json( { data => $result } );
}


sub holders {

    my $c = shift;

    my @params;
    my $sql = "
        SELECT DISTINCT
            t1.holder as id,
            t2.shortcut as title,
            t2.description as description,
            CASE WHEN t2.type='group' THEN 'folders' ELSE 'user' END as icon
        FROM documents t1, view_principals t2 WHERE t2.id = t1.holder
    ";

    my $sql_filter = $c->createSqlFilter();
    $sql .= " $sql_filter->{sql} ";
    @params = (@params, @{ $sql_filter->{params} });

    $sql .= " ORDER BY icon, t2.shortcut; ";

    my $result = $c->sql->Q($sql, \@params)->Hashes;

    unshift @$result, {
        id => "all",
        icon => "user-silhouette",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("All available")
    };

    $c->render_json( { data => $result } );
}

sub progress {

    my $c = shift;

    my @params;
    my $sql = "
        SELECT DISTINCT t1.readiness as id, t1.progress || '% - ' || t1.readiness_shortcut as title, t1.color, t1.progress
        FROM documents t1 WHERE 1=1 ";

    my $sql_filter = $c->createSqlFilter();
    $sql .= " $sql_filter->{sql} ";
    @params = (@params, @{ $sql_filter->{params} });

    $sql .= " ORDER BY progress, title ";

    my $result = $c->sql->Q($sql, \@params)->Hashes;

    unshift @$result, {
        id => "all",
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

    my $sql_filters;
    my @params;

    my $mode     = $c->param("gridmode")     || "all";

    my $edition  = $c->param("flt_edition")  || undef;
    my $group    = $c->param("flt_group")    || undef;
    my $title    = $c->param("flt_title")    || undef;
    my $fascicle = $c->param("flt_fascicle") || undef;

    # Modes

    my $current_member = $c->QuerySessionGet("member.id");

    # Set view restrictions
    my $editions = $c->access->GetBindings("editions.documents.work");
    my $departments = $c->access->GetBindings("catalog.documents.view:*");

    $sql_filters .= " AND ( ";

    $sql_filters .= " ( ";
    $sql_filters .= "    dcm.edition = ANY(?) ";
    $sql_filters .= "    AND ";
    $sql_filters .= "    dcm.workgroup = ANY(?) ";
    $sql_filters .= " ) ";
    push @params, $editions;
    push @params, $departments;

    $sql_filters .= " ) ";

    # Set Filters

    if ($mode eq "todo") {
        # get documents fpor departments
        my @holders;
        $sql_filters .= " AND dcm.holder = ANY(?) ";
        my $departments = $c->sql->Q(" SELECT catalog FROM map_member_to_catalog WHERE member=? ", [ $current_member ])->Values;
        foreach (@$departments) {
            push @holders, $_;
        }
        push @holders, $current_member;
        push @params, \@holders;

        $sql_filters .= " AND fsc.enabled = true ";
        $sql_filters .= " AND dcm.fascicle <> '99999999-9999-9999-9999-999999999999' ";
    }

    if ($mode eq "all") {
        $sql_filters .= " AND fsc.enabled = true ";
        $sql_filters .= " AND dcm.fascicle <> '99999999-9999-9999-9999-999999999999' ";
        if ($fascicle && $fascicle ne "all" && $fascicle ne '00000000-0000-0000-0000-000000000000') {
            $sql_filters .= " AND dcm.fascicle <> '00000000-0000-0000-0000-000000000000' ";
        }
    }

    if ($mode eq "archive") {
        $sql_filters .= " AND fsc.enabled  <> true ";
        $sql_filters .= " AND dcm.fascicle <> '99999999-9999-9999-9999-999999999999' ";
        $sql_filters .= " AND dcm.fascicle <> '00000000-0000-0000-0000-000000000000' ";
    }

    if ($mode eq "briefcase") {
        $sql_filters .= " AND dcm.fascicle = '00000000-0000-0000-0000-000000000000' ";
    }

    if ($mode eq "recycle") {
        $sql_filters .= " AND dcm.fascicle = '99999999-9999-9999-9999-999999999999' ";
    }

    # Set Filters

    if ($title) {
        $sql_filters .= " AND dcm.title LIKE ? ";
        push @params, "%$title%";
    }

    if ($edition && $edition ne "all") {
        $sql_filters .= " AND ? = ANY(dcm.ineditions) ";
        push @params, $edition;
    }

    if ($group && $group ne "all") {
        $sql_filters .= " AND ? = ANY(dcm.inworkgroups) ";
        push @params, $group;
    }

    if ($fascicle && $fascicle ne "all") {
        $sql_filters .= " AND dcm.fascicle = ? ";
        push @params, $fascicle;
    }

    return { sql => $sql_filters, params => \@params };
}

1;
