package Inprint::Fascicle;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Fascicle::Utils;

use Inprint::Models::Documents;
use Inprint::Models::Fascicle::Request;

use base 'Mojolicious::Controller';

sub seance {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");

    my $current_member = $c->getSessionValue("member.id");

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
        $fascicle = $c->Q(" SELECT * FROM fascicles WHERE id =? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless $fascicle;
    }

    unless (@errors) {

        $pages     = $c->getPages($fascicle->{id});

        $documents = $c->getDocumens($fascicle->{id});

        $requests  = $c->getRequests($fascicle->{id});

        $summary   = $c->getSummary($fascicle->{id});

        if ($fascicle->{manager}) {
            $fascicle->{manager_shortcut} = $c->Q("
                SELECT shortcut FROM profiles WHERE id=?", $fascicle->{manager})->Value;
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

        my $statusbar_all = $c->Q(" SELECT count(*) FROM fascicles_pages WHERE fascicle=? AND seqnum is not null ", [ $fascicle->{id} ])->Value;

        my $statusbar_adv = $c->Q("
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

    my $current_member = $c->getSessionValue("member.id");

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    my $fascicle;
    unless (@errors) {
        $fascicle = $c->Q(" SELECT * FROM fascicles WHERE id =? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless $fascicle;
    }

    unless (@errors) {

        if ($fascicle->{manager}) {
            $fascicle->{manager_shortcut} = $c->Q(" SELECT shortcut FROM profiles WHERE id=?", [$fascicle->{manager}])->Value;
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

    my $current_member = $c->getSessionValue("member.id");

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    my $fascicle;
    unless (@errors) {
        $fascicle = $c->Q(" SELECT * FROM fascicles WHERE id =? ", [ $i_fascicle ])->Hash;
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
        $c->Do(" UPDATE fascicles SET manager=? WHERE id=?", [ $current_member, $fascicle->{id} ]);
        $c->Do(" UPDATE documents SET fascicle_blocked=true WHERE fascicle=?", [ $fascicle->{id} ]);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub close {

    my $c = shift;
    my $i_fascicle = $c->param("fascicle");

    my @errors;
    my $success = $c->json->false;

    my $current_member = $c->getSessionValue("member.id");

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    my $fascicle;
    unless (@errors) {
        $fascicle = $c->Q(" SELECT * FROM fascicles WHERE id =? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless $fascicle;
    }

    unless (@errors) {
        $c->Do(" UPDATE fascicles SET manager=null WHERE manager=? AND id=?", [ $current_member, $fascicle->{id} ]);
        $c->Do(" UPDATE documents SET fascicle_blocked=false WHERE fascicle=?", [ $fascicle->{id} ]);
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

    my $current_member = $c->getSessionValue("member.id");

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    my $fascicle;
    unless (@errors) {
        $fascicle = $c->Q(" SELECT * FROM fascicles WHERE id =? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless $fascicle;
    }

    unless (@errors) {
        $c->Do(" UPDATE fascicles SET manager=? WHERE id=?", [ $current_member, $fascicle->{id} ]);
        $c->Do(" UPDATE documents SET fascicle_blocked=true WHERE fascicle=?", [ $fascicle->{id} ]);
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

    my $current_member = $c->getSessionValue("member.id");

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    my $fascicle;
    unless (@errors) {
        $fascicle = $c->Q(" SELECT * FROM fascicles WHERE id =? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless $fascicle;
    }

    unless (@errors) {

        $c->sql->bt;
        foreach my $node (@i_documents) {

            my ($id, $seqnumstr) = split '::', $node;
            next unless ($id);

            my $document = $c->Q(" SELECT * FROM documents WHERE id=? AND fascicle=? ", [ $id, $fascicle->{id} ])->Hash;
            next unless ($document->{id});

            # clear pages for document
            $c->Do("
                DELETE FROM fascicles_map_documents WHERE edition =? AND fascicle=? AND entity=?
                ", [ $fascicle->{edition}, $fascicle->{id}, $document->{id} ]);

            my $seqnums = Inprint::Fascicle::Utils::uncompressString($c, $seqnumstr);
            next unless (@$seqnums);

            foreach my $seqnum (@$seqnums) {

                # Change pages for document
                if ($seqnum > 0) {

                    my $page = $c->Q("
                        SELECT * FROM fascicles_pages WHERE fascicle=? AND seqnum=? ",
                        [ $fascicle->{id}, $seqnum ])->Hash;
                    next unless ($page->{id});

                    unless ($page->{headline}) {
                        $c->Do("
                            UPDATE fascicles_pages SET headline = ? WHERE id=? ",
                            [ $document->{headline}, $page->{id}  ]);
                    }

                    $c->Do("
                        INSERT INTO fascicles_map_documents(edition, fascicle, page, entity, created, updated)
                        VALUES (?, ?, ?, ?, now(), now());
                    ", [ $fascicle->{edition}, $fascicle->{id}, $page->{id}, $document->{id} ]);

                }

                # Remove document from all pages
                if ($seqnum == 0) {
                    $c->Do("
                            DELETE FROM fascicles_map_documents WHERE edition =? AND fascicle=? AND entity=?
                        ", [ $fascicle->{edition}, $fascicle->{id}, $document->{id} ]);
                }

            }

        }

        # Update documents' pages cache
        Inprint::Fascicle::Utils::updateDocumentsPagesCache($c, $fascicle->{id});

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
    my $dbpages = $c->Q("
        SELECT
            t1.id, t1.seqnum, t1.w, t1.h,
            t2.id as headline, t2.title as headline_shortcut
        FROM
            fascicles_pages t1
            LEFT JOIN fascicles_indx_headlines as t2 ON t2.id=t1.headline
        WHERE t1.fascicle=?
        ORDER BY t1.seqnum ",
        [ $fascicle ])->Hashes;

    foreach my $item (@$dbpages) {

        $index->{$item->{id}} = $idcounter++;

        my ($trash, $headline) = split /\//, $item->{headline_shortcut};

        $pages->{$index->{$item->{id}}} = {
            id => $item->{id},
            num => $item->{seqnum},
            headline => $headline || $item->{headline_shortcut}
        };

        push @pageorder, $index->{$item->{id}};
    }

    my $documents = {};
    my $doccount = 0;
    my $dbdocuments = $c->Q("
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

        my $docpages = $c->Q("
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

    my $dbholes = $c->Q("
        SELECT t1.id, t1.title, t1.w, t1.h, t2.page, t2.x, t2.y
        FROM fascicles_modules t1, fascicles_map_modules t2
        WHERE t1.fascicle = ? AND t2.module=t1.id AND t2.placed=false
    ", [ $fascicle ])->Hashes;

    foreach my $item (@$dbholes) {
        $index->{$item->{id}} = $idcounter++;

        $holes->{$index->{$item->{id}}} = {
            id => $item->{id},
            title => $item->{title}
        };

        my $pageindex = $index->{$item->{page}};
        if ($pageindex) {
            push @{ $pages->{$pageindex}->{holes} }, $index->{$item->{id}};
        }
    }

    my $requests;

    my $dbrequests = $c->Q("
        SELECT t1.id, t1.shortcut, t2.page
        FROM fascicles_requests t1, fascicles_map_modules t2
        WHERE t1.fascicle = ? AND t1.module=t2.module AND t2.placed=false
    ", [ $fascicle ])->Hashes;

    foreach my $item (@$dbrequests) {

        $index->{$item->{id}} = $idcounter++;

        $requests->{$index->{$item->{id}}} = {
            id => $item->{id},
            title => $item->{shortcut}
        };

        my $pageindex = $index->{$item->{page}};

        if ($pageindex) {
            push @{ $pages->{$pageindex}->{requests} }, $index->{$item->{id}};
        }

    }

    $data->{pages}      = $pages;
    $data->{documents}  = $documents;
    $data->{holes}      = $holes;
    $data->{requests}   = $requests;
    $data->{pageorder}  = \@pageorder;

    return $data ;
}

sub getDocumens {

    my $c = shift;
    my $fascicle = shift;

    return unless $fascicle;

    my $searchResult = Inprint::Models::Documents::search($c, {
        paginate        => "no",
        baseSort        => "headline_shortcut",
        flt_fascicle    => $fascicle
    });

    return $searchResult->{result};
}

sub getRequests {

    my $c = shift;
    my $fascicle = shift;

    return unless $fascicle;

    my $filter = {
        flt_fascicle => $fascicle
    };

    my $result = Inprint::Models::Fascicle::Request::search($c, $filter);

    return $result;
}

sub getSummary {

    my $c = shift;

    my $fascicle = shift;

    return unless $fascicle;

    my $data;

    # Get adv places
    my $places = $c->Q("
        SELECT id, fascicle, title, description, created, updated
        FROM fascicles_tmpl_places WHERE fascicle = ? ORDER BY title
    ", [ $fascicle ])->Hashes;

    foreach my $place (@$places) {

        # Get adv modules for place
        my $tmpl_modules = $c->Q("
            SELECT
                t1.id, t1.origin, t1.fascicle, t1.page, t1.title,
                t1.description, t1.amount, t1.area, t1.x, t1.y, t1.w, t1.h,
                t1.created, t1.updated
            FROM fascicles_tmpl_modules t1, fascicles_tmpl_index t2
            WHERE t1.fascicle=? AND t2.entity=t1.id AND t2.place=?
        ", [ $fascicle, $place->{id} ])->Hashes;

        foreach my $tmpl_module (@$tmpl_modules) {

            my $pages = $c->Q("
                    SELECT t3.seqnum
                    FROM fascicles_modules t1, fascicles_map_modules t2, fascicles_pages t3
                    WHERE t2.module=t1.id AND t2.page=t3.id
                        AND t1.fascicle=? AND t1.place=? AND t1.origin=?
                    ORDER BY t3.seqnum
                ", [ $fascicle, $place->{id}, $tmpl_module->{id} ])->Values;

            $pages = join ", ", @$pages;

            my $modules = $c->Q("
                    SELECT count(*)
                    FROM fascicles_modules t1
                    WHERE t1.fascicle=? AND t1.place=? AND t1.origin=?
                ", [ $fascicle, $place->{id}, $tmpl_module->{id} ])->Value || 0;

            my $requests = $c->Q("
                SELECT count(*) FROM fascicles_requests WHERE fascicle=? AND place=? AND origin=?
            ", [ $fascicle, $place->{id}, $tmpl_module->{id} ])->Value || 0;

            my $freespace = $modules - $requests;

            push @$data, {
                id              => $place->{id} ."::". $tmpl_module->{id},
                shortcut        => $tmpl_module->{title},
                module          => $tmpl_module->{id},
                place           => $place->{id},
                place_shortcut  => $place->{title},
                pages           => $pages,
                holes           => $modules,
                requests        => $requests,
                free            => $freespace
            }
        }
    }

    return $data;
}

1;
