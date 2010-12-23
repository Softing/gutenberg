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
    my $requests;
    my $summary;
    
    unless (@errors) {
        $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id =? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless $fascicle;
    }
    
    unless (@errors) {
        
        $pages     = $c->getPages($fascicle->{id});
        $documents = $c->getDocumens($fascicle->{id});
        $requests  = $c->getRequests($fascicle->{id});
        $summary   = $c->getSummary($fascicle->{id});
        
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
        
        my $statusbar_all = $c->sql->Q(" SELECT count(*) FROM fascicles_pages WHERE fascicle=? AND seqnum is not null ", [ $fascicle->{id} ])->Value;

        my $statusbar_adv = $c->sql->Q(" 
                SELECT sum(t1.area)
                FROM fascicles_modules t1, fascicles_map_modules t2, fascicles_pages t3
                WHERE 
                    t2.module = t1.id AND t2.page = t3.id AND t3.fascicle=?
            ", [ $fascicle->{id} ]
        )->Value;
        
        my $statusbar_doc = $statusbar_all - $statusbar_adv;

        my $statusbar_doc_average = 0;
        
        if ($statusbar_all > 0) {
            $statusbar_doc_average = $statusbar_doc/ $statusbar_all * 100 ;
        }
        
        my $statusbar_adv_average = 0;
        if ($statusbar_all > 0) {
            $statusbar_adv_average = $statusbar_adv/ $statusbar_all * 100 ;
        }
        
        $fascicle->{pc}  = $statusbar_all || 0;
        $fascicle->{dc}  = sprintf "%.2f", $statusbar_doc || 0;
        $fascicle->{ac}  = sprintf "%.2f", $statusbar_adv || 0;
        $fascicle->{dav} = sprintf "%.2f", $statusbar_doc_average || 0;
        $fascicle->{aav} = sprintf "%.2f", $statusbar_adv_average || 0;
        
        
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({
        success     => $success,
        errors      => \@errors,
        fascicle    => $fascicle || {},
        pages       => [ $pages ],
        documents   => $documents || [],
        requests    => $requests || [],
        summary     => $summary || []
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
    my $i_fascicle  = $c->param("fascicle");
    my @i_documents = $c->param("document");
    
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
        
        $c->sql->bt;
        foreach my $node (@i_documents) {
            
            my ($id, $seqnumstr) = split '::', $node;
            
            next unless ($id);
            
            my $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? AND fascicle=? ", [ $id, $fascicle->{id} ])->Hash;
            
            next unless ($document->{id});
            
            my @seqnums = split /[^\d]/, $seqnumstr;
            
            next unless (@seqnums);
            
            foreach my $seqnum (@seqnums) {
                
                if ($seqnum > 0) {
                    
                    my $page = $c->sql->Q(" SELECT * FROM fascicles_pages WHERE fascicle=? AND seqnum=? ", [ $fascicle->{id}, $seqnum ])->Hash;
                    
                    if ($page->{id}) {
                        
                        unless ($page->{headline}) {
                            $c->sql->Do("
                                UPDATE fascicles_pages SET headline = ? WHERE id=?
                            ", [ $document->{headline}, $page->{id}  ]);
                        }
                        
                        $c->sql->Do("
                            DELETE FROM fascicles_map_documents WHERE edition =? AND fascicle=? AND page=? AND entity=?
                        ", [ $fascicle->{edition}, $fascicle->{id}, $page->{id}, $document->{id} ]);
                        
                        $c->sql->Do("
                            INSERT INTO fascicles_map_documents(edition, fascicle, page, entity, created, updated)
                            VALUES (?, ?, ?, ?, now(), now());
                        ", [ $fascicle->{edition}, $fascicle->{id}, $page->{id}, $document->{id} ]);
                    }
                }
                
                if ($seqnum == 0) {
                    $c->sql->Do("
                            DELETE FROM fascicles_map_documents WHERE edition =? AND fascicle=? AND entity=?
                        ", [ $fascicle->{edition}, $fascicle->{id}, $document->{id} ]);
                }
                
            }
            
        }
        $c->sql->et;
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
            t1.id, t1.seqnum, t1.w, t1.h,
            t2.id as headline, t2.shortcut as headline_shortcut
        FROM fascicles_pages t1
            LEFT JOIN index_fascicles as t2 ON t2.id=t1.headline
        WHERE t1.fascicle = ?
        ORDER BY t1.seqnum
    ", [ $fascicle ])->Hashes;
    
    foreach my $item (@$dbpages) {
        
        $index->{$item->{id}} = $idcounter++;
        
        my ($trash, $headline) = split /\//, $item->{headline_shortcut};
        
        $pages->{$index->{$item->{id}}} = {
            id => $item->{id},
            num => $item->{seqnum},
            dim   => "$item->{w}x$item->{h}",
            headline => $headline || $item->{headline_shortcut}
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
        SELECT t1.id, t1.shortcut, t1.w, t1.h, t2.page, t2.x, t2.y
        FROM fascicles_modules t1, fascicles_map_modules t2
        WHERE t1.fascicle = ? AND t2.module=t1.id AND t2.placed=false
    ", [ $fascicle ])->Hashes;
    
    foreach my $item (@$dbholes) {
        $index->{$item->{id}} = $idcounter++;
        
        $holes->{$index->{$item->{id}}} = {
            id => $item->{id},
            title => $item->{shortcut},
            #x => $item->{x},
            #y => $item->{y},
            #h => $item->{h},
            #w => $item->{w},
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

    #my $editions = $c->access->GetChildrens("editions.documents.work");
    #$sql_filters .= " AND dcm.edition = ANY(?) ";
    #push @params, $editions;
    
    #my $departments = $c->access->GetBindings("catalog.documents.view:*");
    #$sql_filters .= " AND dcm.workgroup = ANY(?) ";
    #push @params, $departments;
    
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

sub getRequests {

    my $c = shift;
    my $fascicle = shift;
    
    return unless $fascicle;
    
    my @params;
    
    # Query headers
    my $sql_query = "
        SELECT
            t1.id, t1.serialnum, t1.edition, t1.fascicle, t1.advertiser, t1.advertiser_shortcut, 
            t1.place, t1.place_shortcut, t1.manager, t1.manager_shortcut, 
            t1.origin, t1.origin_shortcut, t1.origin_area,
            t1.origin_x, t1.origin_y, t1.origin_w, t1.origin_h, 
            t2.id as module, t2.shortcut as module_shortcut, pages, firstpage, 
            t1.amount, t1.shortcut, t1.description, t1.status, t1.payment, t1.readiness,
            to_char(t1.created, 'YYYY-MM-DD HH24:MI:SS') as created,
            to_char(t1.updated, 'YYYY-MM-DD HH24:MI:SS') as updated
        FROM fascicles_requests t1 LEFT JOIN fascicles_modules t2 ON t1.module = t2.id
        WHERE t1.fascicle=?
    ";
    
    push @params, $fascicle;
    
    my $result = $c->sql->Q($sql_query, \@params)->Hashes;
    
    return $result;
}

sub getSummary {
    
    my $c = shift;
    
    my $fascicle = shift;
    
    return unless $fascicle;
    
    my $data;
    
    my $places = $c->sql->Q("
        SELECT id, fascicle, title, shortcut, description, created, updated
        FROM fascicles_tmpl_places WHERE fascicle = ? ORDER BY shortcut
    ", [ $fascicle ])->Hashes;
    
    foreach my $place (@$places) {
        
        my $tmpl_modules = $c->sql->Q("
            SELECT
                t1.id, t1.origin, t1.fascicle, t1.page, t1.title, t1.shortcut,
                t1.description, t1.amount, t1.area, t1.x, t1.y, t1.w, t1.h,
                t1.created, t1.updated
            FROM fascicles_tmpl_modules t1, fascicles_tmpl_index t2
            WHERE t1.fascicle=? AND t2.entity=t1.id AND t2.place=?
        ", [ $fascicle, $place->{id} ])->Hashes;
        
        foreach my $tmpl_module (@$tmpl_modules) {
            
            my $pages = $c->sql->Q("
                    SELECT t3.seqnum
                    FROM fascicles_modules t1, fascicles_map_modules t2, fascicles_pages t3
                    WHERE t2.module=t1.id AND t2.page=t3.id
                        AND t1.fascicle=? AND t1.place=? AND t1.origin=?
                    ORDER BY t3.seqnum
                ", [ $fascicle, $place->{id}, $tmpl_module->{id} ])->Values;
            
            $pages = join ", ", @$pages;
            
            my $hl = $c->sql->Q("
                    SELECT count(*)
                    FROM fascicles_modules t1, fascicles_map_modules t2
                    WHERE t2.module=t1.id AND t1.fascicle=? AND t1.place=? AND t1.origin=?
                ", [ $fascicle, $place->{id}, $tmpl_module->{id} ])->Value || 0;
            
            my $rq = $c->sql->Q("
                SELECT count(*) FROM fascicles_requests WHERE fascicle=? AND place=? AND origin=?
            ", [ $fascicle, $place->{id}, $tmpl_module->{id} ])->Value;
            
            my $fr = $hl - $rq;
            
            push @$data, {
                id              => $place->{id} ."::". $tmpl_module->{id},
                shortcut        => $tmpl_module->{shortcut},
                module          => $tmpl_module->{id},
                place           => $place->{id},
                place_shortcut  => $place->{shortcut},
                pages           => $pages,
                holes           => $hl,
                requests        => $rq,
                free            => $fr
            }
        }
    }
    
    return $data;
}

1;
