package Inprint::Fascicle::Documents;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Utils;

use base 'Inprint::BaseController';

sub list {

    my $c = shift;

    my @params;

    # Filters
    my $edition  = $c->param("flt_edition")  || undef;
    my $group    = $c->param("flt_group")    || undef;
    my $title    = $c->param("flt_title")    || undef;
    my $fascicle = $c->param("flt_fascicle") || undef;
    my $headline = $c->param("flt_headline") || undef;
    my $rubric   = $c->param("flt_rubric")   || undef;
    my $manager  = $c->param("flt_manager")  || undef;
    my $holder   = $c->param("flt_holder")   || undef;
    my $progress = $c->param("flt_progress") || undef;

    # Query headers
    my $sql_query = "
        SELECT
            dcm.id,

            dcm.edition, dcm.edition_shortcut,
            dcm.fascicle, dcm.fascicle_shortcut,
            dcm.headline, dcm.headline_shortcut,
            dcm.rubric, dcm.rubric_shortcut,

            dcm.workgroup, dcm.workgroup_shortcut,
            dcm.inworkgroups, dcm.copygroup,

            dcm.holder,  dcm.holder_shortcut,
            dcm.creator, dcm.creator_shortcut,
            dcm.manager, dcm.manager_shortcut,

            dcm.islooked, dcm.isopen,
            dcm.branch, dcm.branch_shortcut,
            dcm.stage, stage_shortcut,
            dcm.color, dcm.progress,
            dcm.title, dcm.author,
            dcm.pages,
            to_char(dcm.pdate, 'YYYY-MM-DD HH24:MI:SS') as pdate,
            to_char(dcm.rdate, 'YYYY-MM-DD HH24:MI:SS') as rdate,
            dcm.psize, dcm.rsize,
            dcm.images, dcm.files,
            to_char(dcm.created, 'YYYY-MM-DD HH24:MI:SS') as created,
            to_char(dcm.updated, 'YYYY-MM-DD HH24:MI:SS') as updated

        FROM documents dcm

    ";

    my $sql_total = "
        SELECT count(*)
        FROM documents dcm
    ";

    my $sql_filters = " WHERE 1=1 ";
    
    #$sql_filters .= " AND id = '296f7e02-9728-46a4-9dc1-b38f8d9e1335' ";

    # Set Restrictions

    my $editions = $c->access->GetChildrens("editions.documents.work");
    $sql_filters .= " AND dcm.edition = ANY(?) ";
    push @params, $editions;
    
    my $departments = $c->access->GetChildrens("catalog.documents.view:*");
    $sql_filters .= " AND dcm.workgroup = ANY(?) ";
    push @params, $departments;
    
    # Set Filters
    
    $sql_filters .= " AND isopen is true ";
    $sql_filters .= " AND fascicle <> '99999999-9999-9999-9999-999999999999' ";
    $sql_filters .= " AND fascicle <> '00000000-0000-0000-0000-000000000000' ";

    # Set Filters
    
    if ($title) {
        $sql_filters .= " AND title LIKE ? ";
        push @params, "%$title%";
    }
    
    if ($edition && $edition ne "clear") {
        $sql_filters .= " AND ? = ANY(dcm.ineditions) ";
        push @params, $edition;
    }
    
    if ($group && $group ne "clear") {
        $sql_filters .= " AND ? = ANY(dcm.inworkgroups) ";
        push @params, $group;
    }
    
    if ($fascicle && $fascicle ne "clear") {
        $sql_filters .= " AND fascicle = ? ";
        push @params, $fascicle;
    }
    
    if ($headline && $headline ne "clear") {
        $sql_filters .= " AND headline = ? ";
        push @params, $headline;
    }
    
    if ($rubric && $rubric ne "clear") {
        $sql_filters .= " AND rubric = ? ";
        push @params, $rubric;
    }
    
    if ($manager && $manager ne "clear") {
        $sql_filters .= " AND manager=? ";
        push @params, $manager;
    }
    
    if ($holder && $holder ne "clear") {
        $sql_filters .= " AND holder=? ";
        push @params, $holder;
    }
    
    if ($progress && $progress ne "clear") {
        $sql_filters .= " AND readiness=? ";
        push @params, $progress;
    }

    $sql_total .= $sql_filters;
    $sql_query .= $sql_filters;

    # Calculate total param
    my $total = $c->sql->Q($sql_total, \@params)->Value || 0;
    
    $sql_query .= " ORDER BY headline_shortcut, firstpage";
    
    my $result = $c->sql->Q($sql_query, \@params)->Hashes;
    
    my $current_member = $c->QuerySessionGet("member.id");
    foreach my $document (@$result) {
        
        $document->{pages} = Inprint::Utils::CollapsePagesToString($document->{pages});
        
        my $copy_count = $c->sql->Q(" SELECT count(*) FROM documents WHERE copygroup=? ", [ $document->{copygroup} ])->Value;
        if ($copy_count > 1) {
            $document->{title} = $document->{title} . " ($copy_count)";
        }
        
        $document->{access} = {};
        my @rules = qw(update capture move transfer briefcase delete recover);
        
        foreach (@rules) {
            if ($document->{holder} eq $current_member) {
                if ($c->access->Check(["catalog.documents.$_:*"], $document->{workgroup})) {
                    $document->{access}->{$_} = $c->json->true;
                }
            }
            if ($document->{holder} ne $current_member) {
                if ($c->access->Check("catalog.documents.$_:group", $document->{workgroup})) {
                    $document->{access}->{$_} = $c->json->true;
                }
            }
        }
    }
    
    # Create result
    $c->render_json( { "data" => $result, "total" => $total } );
}

1;

