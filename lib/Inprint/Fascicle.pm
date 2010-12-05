package Inprint::Fascicle;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Utils;

use base 'Inprint::BaseController';

sub seance {
    
    my $c = shift;
    
    my $i_fascicle = $c->param("fascicle");
    
    my $current_member = $c->QuerySessionGet("member.id");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));
    
    my $fascicle;
    my $pages;
    my $documents;
    my $summary;
    
    unless (@errors) {
        $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id =? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless $fascicle;
    }
    
    unless (@errors) {
        
        $pages = $c->getPages($fascicle->{id});
        $documents = $c->getDocumens($fascicle->{id});
        $summary = $c->getSummary($fascicle->{id});
        
        if ($fascicle->{manager}) {
            $fascicle->{manager_shortcut} = $c->sql->Q(" SELECT shortcut FROM profiles WHERE id=?", [$fascicle->{manager}])->Value;
        }
        
        $fascicle->{access} = {
            open => $c->json->true,
            capture => $c->json->false,
            close => $c->json->false,
            save => $c->json->false,
            manage => $c->json->false
        };
        
        if ($fascicle->{manager}) {
            
            if ($fascicle->{manager} eq $current_member) {
                $fascicle->{access}->{open}    = $c->json->false;
                $fascicle->{access}->{capture} = $c->json->false;
                $fascicle->{access}->{close}   = $c->json->true;
                $fascicle->{access}->{save}    = $c->json->true;
                $fascicle->{access}->{manage}  = $c->json->true;
            }
            
            if ($fascicle->{manager} ne $current_member) {
                $fascicle->{access}->{open}    = $c->json->false;
                $fascicle->{access}->{capture} = $c->json->true;
                $fascicle->{access}->{close}   = $c->json->false;
                $fascicle->{access}->{save}    = $c->json->false;
                $fascicle->{access}->{manage}  = $c->json->false;
            }
        }
        
        $fascicle->{pc} = 0;
        $fascicle->{dc} = 0;
        $fascicle->{ac} = 0;
        $fascicle->{dav} = 0;
        $fascicle->{aav} = 0;
        
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({
        success => $success,
        errors => \@errors,
        fascicle => $fascicle || {},
        pages => [ $pages ],
        documents => $documents || [],
        summary => $summary || []
    });
}

sub check {
    
    my $c = shift;
    my $i_fascicle = $c->param("fascicle");
    
    my @errors;
    my $success = $c->json->false;
    
    my $current_member = $c->QuerySessionGet("member.id");
    
    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));
    
    my $fascicle;
    unless (@errors) {
        $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id =? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless $fascicle;
    }
    
    unless (@errors) {
        
        if ($fascicle->{manager}) {
            $fascicle->{manager_shortcut} = $c->sql->Q(" SELECT shortcut FROM profiles WHERE id=?", [$fascicle->{manager}])->Value;
        }
        
        $fascicle->{access} = {
            open => $c->json->true,
            capture => $c->json->false,
            close => $c->json->false,
            save => $c->json->false,
            manage => $c->json->false
        };
        
        if ($fascicle->{manager}) {
            
            if ($fascicle->{manager} eq $current_member) {
                $fascicle->{access}->{open}    = $c->json->false;
                $fascicle->{access}->{capture} = $c->json->false;
                $fascicle->{access}->{close}   = $c->json->true;
                $fascicle->{access}->{save}    = $c->json->true;
                $fascicle->{access}->{manage}  = $c->json->true;
            }
            
            if ($fascicle->{manager} ne $current_member) {
                $fascicle->{access}->{open}    = $c->json->false;
                $fascicle->{access}->{capture} = $c->json->true;
                $fascicle->{access}->{close}   = $c->json->false;
                $fascicle->{access}->{save}    = $c->json->false;
                $fascicle->{access}->{manage}  = $c->json->false;
            }
        }
        
        $fascicle->{pc} = 0;
        $fascicle->{dc} = 0;
        $fascicle->{ac} = 0;
        $fascicle->{dav} = 0;
        $fascicle->{aav} = 0;
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, fascicle => $fascicle || {} });
}

sub open {
    
    my $c = shift;
    my $i_fascicle = $c->param("fascicle");
    
    my @errors;
    my $success = $c->json->false;
    
    my $current_member = $c->QuerySessionGet("member.id");
    
    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));
    
    my $fascicle;
    unless (@errors) {
        $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id =? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless $fascicle;
    }
    
    unless (@errors) {
        push @errors, { id => "error", msg => "I can not open this issue, another user has edited it"}
            if ($fascicle->{manager} && $fascicle->{manager} ne $current_member);
    }
    
    unless (@errors) {
        push @errors, { id => "error", msg => "I can not open this issue, you already edit it"}
            if ($fascicle->{manager} && $fascicle->{manager} eq $current_member);
    }
    
    unless (@errors) {
        $c->sql->Do(" UPDATE fascicles SET manager=? WHERE id=?", [ $current_member, $fascicle->{id} ]);
        $c->sql->Do(" UPDATE documents SET fascicle_blocked=true WHERE fascicle=?", [ $fascicle->{id} ]);
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub close {
    
    my $c = shift;
    my $i_fascicle = $c->param("fascicle");
    
    my @errors;
    my $success = $c->json->false;
    
    my $current_member = $c->QuerySessionGet("member.id");
    
    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));
    
    my $fascicle;
    unless (@errors) {
        $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id =? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless $fascicle;
    }
    
    unless (@errors) {
        $c->sql->Do(" UPDATE fascicles SET manager=null WHERE manager=? AND id=?", [ $current_member, $fascicle->{id} ]);
        $c->sql->Do(" UPDATE documents SET fascicle_blocked=false WHERE fascicle=?", [ $fascicle->{id} ]);
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({
        success => $success,
        errors => \@errors
    });
}

sub capture {
    
    my $c = shift;
    my $i_fascicle = $c->param("fascicle");
    
    my @errors;
    my $success = $c->json->false;
    
    my $current_member = $c->QuerySessionGet("member.id");
    
    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));
    
    my $fascicle;
    unless (@errors) {
        $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id =? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless $fascicle;
    }
    
    unless (@errors) {
        $c->sql->Do(" UPDATE fascicles SET manager=? WHERE id=?", [ $current_member, $fascicle->{id} ]);
        $c->sql->Do(" UPDATE documents SET fascicle_blocked=true WHERE fascicle=?", [ $fascicle->{id} ]);
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({
        success => $success,
        errors => \@errors
    });
}

sub save {
    
    my $c = shift;
    my $i_fascicle = $c->param("fascicle");
    
    my @errors;
    my $success = $c->json->false;
    
    my $current_member = $c->QuerySessionGet("member.id");
    
    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));
    
    my $fascicle;
    unless (@errors) {
        $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id =? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless $fascicle;
    }
    
    unless (@errors) {
        
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({
        success => $success,
        errors => \@errors
    });
}

sub getPages {
    
    my $c = shift;
    my $fascicle = shift;
    
    return unless $fascicle;
    
    my $data = {};

    my $idcounter = 1;
    my $index;
    
    my @pageorder;
    
    my $pages;
    my $dbpages = $c->sql->Q("
        SELECT 
            t1.id, t1.place, t1.seqnum, t1.w, t1.h,
            t2.id as headline, t2.shortcut as headline_shortcut
        FROM fascicles_pages t1
            LEFT JOIN index as t2 ON t2.id=t1.headline
        WHERE fascicle = ?
        ORDER BY seqnum
    ", [ $fascicle ])->Hashes;
    
    foreach my $item (@$dbpages) {
        
        $index->{$item->{id}} = $idcounter++;
        
        my ($trash, $headline) = split /\//, $item->{headline_shortcut};
        
        $pages->{$index->{$item->{id}}} = {
            id => $item->{id},
            num => $item->{seqnum},
            dim   => "$item->{w}x$item->{h}",
            headline => $headline
        };
        
        push @pageorder, $index->{$item->{id}};
    }
    
    my $documents = {};
    my $doccount = 0;
    my $dbdocuments = $c->sql->Q("
        SELECT DISTINCT t2.edition, t2.fascicle, t2.id, t2.title
        FROM fascicles_map_documents t1, documents t2
        WHERE t2.id = t1.entity AND t1.fascicle = ?
    ", [ $fascicle ])->Hashes;
    
    foreach my $item (@$dbdocuments) {
        
        $index->{$item->{id}} = $idcounter++;
        
        $documents->{$index->{$item->{id}}} = {
            id => $item->{id},
            title => $item->{title}
        };
        
        my $docpages = $c->sql->Q("
            SELECT t2.id
            FROM fascicles_map_documents t1, fascicles_pages t2
            WHERE t2.id = t1.page AND t1.fascicle = ? AND entity = ?
        ", [ $fascicle, $item->{id} ])->Values;
        foreach my $pageid (@$docpages) {
            my $pageindex = $index->{$pageid};
            if ($pageindex) {
                push @{ $pages->{$pageindex}->{documents} }, $index->{$item->{id}};
            }
        }
    }
    
    my $holes;
    my $dbholes = $c->sql->Q("
        SELECT
            t1.id, t1.place, t1.page, t1.entity, t1.x, t1.y, t1.h, t1.w,
            t2.id as module, t2.shortcut as module_shortcut
        FROM fascicles_map_holes t1, ad_modules t2
        WHERE t2.id = t1.module
            AND t1.fascicle = ?
    ", [ $fascicle ])->Hashes;
    
    foreach my $item (@$dbholes) {
        $index->{$item->{id}} = $idcounter++;
        
        $holes->{$index->{$item->{id}}} = {
            id => $item->{id},
            title => $item->{module_shortcut},
            entity => $item->{entity},
            x => $item->{x},
            y => $item->{y},
            h => $item->{h},
            w => $item->{w},
        };
        
        my $pageindex = $index->{$item->{page}};
        if ($pageindex) {
            push @{ $pages->{$pageindex}->{holes} }, $index->{$item->{id}};
        }
    }
    
    $data->{pages}      = $pages;
    $data->{documents}  = $documents;
    $data->{holes}      = $holes;
    $data->{pageorder}  = \@pageorder;
    
    return $data ;
}

sub getDocumens {

    my $c = shift;
    my $fascicle = shift;
    
    return unless $fascicle;

    my @params;

    # Filters
    my $edition  = $c->param("flt_edition")  || undef;
    my $group    = $c->param("flt_group")    || undef;
    my $title    = $c->param("flt_title")    || undef;
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
            to_char(dcm.fdate, 'YYYY-MM-DD HH24:MI:SS') as fdate,
            to_char(dcm.ldate, 'YYYY-MM-DD HH24:MI:SS') as ldate,
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
    
    
    return $result;
}

sub getSummary {
    
    my $c = shift;
    
    my $fascicle = shift;
    
    return unless $fascicle;
    
    my $data;
    
    my $places = $c->sql->Q("
        SELECT id, edition, fascicle, title, shortcut, description, created, updated
        FROM ad_places WHERE fascicle = ? ORDER BY shortcut
    ", [ $fascicle ])->Hashes;
    
    foreach my $place (@$places) {
        
        my $modules = $c->sql->Q("
            SELECT id, edition, fascicle, place, title, shortcut, description, amount, volume, w, h, created, updated
            FROM ad_modules WHERE fascicle = ? AND place = ?
        ", [ $fascicle, $place->{id} ])->Hashes;
        
        foreach my $module (@$modules) {
            
            my $hl = $c->sql->Q("
                SELECT count(*) FROM fascicles_map_holes WHERE fascicle=? AND place=? AND module=?
            ", [ $fascicle, $place->{id}, $module->{id} ])->Value;
            
            my $rq = $c->sql->Q("
                SELECT count(*) FROM fascicles_map_holes WHERE fascicle=? AND place=? AND module=? -- AND entity is not null
            ", [ $fascicle, $place->{id}, $module->{id} ])->Value;
            
            my $fr = $hl - $rq;
            
            push @$data, {
                place => $place->{id},
                place_shortcut => $place->{shortcut},
                module => $module->{id},
                module_shortcut => $module->{shortcut},
                holes => $hl,
                requests => $rq,
                free => $fr
            }
        }
    }
    
    return $data;
}

1;
