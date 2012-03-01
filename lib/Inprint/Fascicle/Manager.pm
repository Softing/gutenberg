package Inprint::Fascicle::Manager;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Fascicle::Utils;
use Inprint::Fascicle::Events;

use base 'Mojolicious::Controller';

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
    my @i_modules   = $c->param("module");

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

        my $log;
        $c->sql->bt;

        foreach my $node (@i_modules) {
            my %modpages;

            my ($place_id, $modtype_id, $seqnumstr) = split '::', $node;

            my $place = $c->Q(" SELECT * FROM fascicles_tmpl_places WHERE id=? AND fascicle=? ", [ $place_id, $fascicle->{id} ])->Hash;
            next unless ($place->{id});

            my $modtype = $c->Q(" SELECT * FROM fascicles_tmpl_modules WHERE id=? AND fascicle=? ", [ $modtype_id, $fascicle->{id} ])->Hash;
            next unless ($modtype->{id});

            my $seqnums = Inprint::Fascicle::Utils::uncompressString($c, $seqnumstr);

            # Clean unused modules
            my $usedModules = $c->Q("SELECT * FROM fascicles_modules WHERE fascicle=? AND place=? AND origin=?", [ $fascicle->{id}, $place->{id}, $modtype->{id} ])->Hashes;
            foreach my $usedModule (@$usedModules) {
                my $pages = $c->Q(" SELECT t2.seqnum FROM fascicles_map_modules t1, fascicles_pages t2 WHERE t1.module = ? AND t1.page = t2.id", $usedModule->{id})->Values;
                foreach my $page (@$pages) {
                    unless ( $page ~~ @$seqnums) {
                        my $request = $c->Q(" SELECT * FROM fascicles_requests WHERE module = ? ", $usedModule->{id})->Hash;
                        unless ($request) {
                            $c->Do("DELETE FROM fascicles_modules WHERE fascicle=? AND id=?", [ $fascicle->{id}, $usedModule->{id} ]);
                        }
                    }
                }
            }

            next unless (@$seqnums);

            foreach my $seqnum (@$seqnums) {
                if ($seqnum > 0) {
                    my $page = $c->Q("
                        SELECT * FROM fascicles_pages WHERE fascicle=? AND seqnum=? ",
                        [ $fascicle->{id}, $seqnum ])->Hash;
                    if ($page->{id}) {
                        $modpages{$page->{id}} ++;
                    }
                }
            }

            while (my ($page_id, $page_count) = each %modpages){

                #$log .= "[$page_id = $page_count]";

                # Count number of units with advertising
                my $unitsWithAdvertising  = $c->Q("
                        SELECT t1.id, t3.module
                        FROM fascicles_modules t1
                            LEFT JOIN fascicles_map_modules t2 ON  t1.id = t2.module
                            LEFT OUTER JOIN fascicles_requests t3 ON t1.id = t3.module
                        WHERE t3.module IS NULL AND t1.fascicle=? AND t2.page=?
                    ", [ $fascicle->{id}, $page_id ])->Hashes;

                $log .= "[$fascicle->{id}, $page_id]";

                # Count number of units without advertising
                my $unitsWithoutAdvertising  = $c->Q("
                        SELECT t1.id, t3.module
                        FROM fascicles_modules t1
                            LEFT JOIN fascicles_map_modules t2 ON  t1.id = t2.module
                            LEFT OUTER JOIN fascicles_requests t3 ON t1.id = t3.module
                        WHERE t3.module IS NOT NULL AND t1.fascicle=? AND t2.page=?
                    ", [ $fascicle->{id}, $page_id ])->Hashes;

                # Count the actual number of units without advertising

                my $unitsWithAdvertisingCount    = $#{ $unitsWithAdvertising } +1;
                my $unitsWithoutAdvertisingCount = $#{ $unitsWithoutAdvertising } +1;

                $log .= "[page_count=$page_count";
                $log .= " with=$unitsWithAdvertisingCount";
                $log .= " without=$unitsWithoutAdvertisingCount";
                my $requiredNnumberOf = ($page_count - $unitsWithAdvertisingCount);
                $log .= " >$requiredNnumberOf]";
                $log .= "\n";

                foreach my $unit (@$unitsWithoutAdvertising) {
                    $c->Do("DELETE FROM fascicles_modules WHERE fascicle=? AND id=?", [ $fascicle->{id}, $unit->{id} ]);
                }

                for (1..$requiredNnumberOf) {

                    $log .= "Create module for page $page_id\n";

                    my $module_id = $c->uuid();

                    $c->Do(" INSERT INTO fascicles_modules (
                        id,
                        edition, fascicle, place, origin,
                        title, description, amount,
                        w, h, area,
                        width, height,
                        fwidth, fheight,
                        created, updated)
                        VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,now(),now())", [
                            $module_id,
                            $fascicle->{edition}, $fascicle->{id}, $place->{id}, $modtype->{id},
                            $modtype->{title}, $modtype->{description}, $modtype->{amount},
                            $modtype->{w}, $modtype->{h}, $modtype->{area},
                            $modtype->{width}, $modtype->{height},
                            $modtype->{fwidth}, $modtype->{fheight},
                        ]);

                    my $module = $c->Q("
                        SELECT * FROM fascicles_modules WHERE fascicle=? AND id=? ",
                        [ $fascicle->{id}, $module_id ])->Hash;

                    if ($module->{id}) {
                        $c->Do(" INSERT INTO fascicles_map_modules (
                            edition, fascicle, module, page, placed, x, y, created, updated)
                            VALUES (?,?,?,?,?,?,?,now(),now())",
                            [ $module->{edition}, $module->{fascicle}, $module->{id}, $page_id, 0, $modtype->{w}, $modtype->{h} ]
                        );
                    }
                }
            }
        }
        $c->sql->et;

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

            my $seqnums = Inprint::Fascicle::Utils::uncompressString($c, $seqnumstr, 1);
            next unless (@$seqnums);

            foreach my $seqnum (@$seqnums) {

                # Change pages for document
                if ($seqnum > 0) {

                    my $page = $c->Q("
                        SELECT * FROM fascicles_pages WHERE fascicle=? AND seqnum=? ",
                        [ $fascicle->{id}, $seqnum ])->Hash;

                    next unless ($page->{id});

                    # Update page Headline

                    my $headline = $c->Q("
                        SELECT * FROM fascicles_indx_headlines WHERE id = ? ",
                        $document->{headline})->Hash;
                    
                    unless ($headline) {
                        $headline = $c->Q("
                            SELECT * FROM indx_headlines WHERE tag = ? ",
                            $document->{headline})->Hash;
                    }
                    
                    if ($headline) {
                        
                        my $fascicle_headline = $c->Q("
                            SELECT * FROM fascicles_indx_headlines WHERE fascicle = ? AND title = ?",
                            [ $fascicle->{id}, $headline->{title} ])->Hash;
                        
                        unless ($fascicle_headline) {
                            my $fascicle_headline = $c->Do("
                                INSERT INTO fascicles_indx_headlines
                                    (edition, fascicle, tag, bydefault, title, description, created, updated)
                                    VALUES
                                    (?,?,?,?,?,?,now(),now())",
                                [ $fascicle->{edition}, $fascicle->{id},
                                $headline->{tag}, $headline->{bydefault}, $headline->{title}, $headline->{description}]);
                            
                            $fascicle_headline = $c->Q("
                                SELECT * FROM fascicles_indx_headlines WHERE fascicle = ? AND title = ?",
                                $fascicle->{id}, $headline->{title})->Hash;
                        }
    
                        if ($fascicle_headline) {
                            $c->Do("
                                UPDATE fascicles_pages SET headline = ? WHERE id=? ",
                                [ $fascicle_headline->{id}, $page->{id} ]);
                        }
                    }
                    
                    # Update mappings
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

        # Create event
        Inprint::Fascicle::Events::onCompositionChanged($c, $fascicle);

        $c->sql->et;
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({
        success => $success,
        errors => \@errors
    });
}


1;
