package Inprint::Fascicle::Requests;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use Date::Parse;

use Inprint::Fascicle::Events;
use Inprint::Models::Fascicle::Request;

use base 'Mojolicious::Controller';

sub read {
    my $c = shift;
    my $i_request = $c->param("request");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "id", $i_request);

    my $result = [];

    unless (@errors) {

        $result = $c->Q("
            SELECT
                id, serialnum, edition, fascicle, advertiser, advertiser_shortcut,
                place, place_shortcut, manager, manager_shortcut, amount, origin,
                origin_shortcut, origin_area, origin_x, origin_y, origin_w, origin_h,
                module, pages, firstpage, shortcut, description, status, squib, payment,
                readiness, created, updated
            FROM fascicles_requests
            WHERE id=?
        ", [ $i_request ])->Hash;

        $result->{pages} = $c->Q("
            SELECT
                t1.id ||'::'|| t1.seqnum
            FROM fascicles_pages t1, fascicles_map_modules t2
            WHERE t2.page=t1.id AND t2.module=?
        ", [ $result->{module} ])->Values;

    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub list {
    my $c = shift;

    my $result;
    my @errors;
    my $success = $c->json->false;

    my $filter = {
        flt_fascicle => $c->param("flt_fascicle")
    };

    my $sorting = {
        dir => $c->param("dir"),
        column => $c->param("sort")
    };

    $c->check_uuid( \@errors, "id", $filter->{flt_fascicle});

    unless (@errors) {
        $result = Inprint::Models::Fascicle::Request::search($c, $filter, $sorting);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub create {
    my $c = shift;

    my @errors;
    my $success = $c->json->false;

    my $id = $c->uuid();
    my $group_id = $c->uuid();
    my $fs_folder = sprintf ("/datastore/requests/%04d-%02d/%s", ((localtime)[5] +1900), ((localtime)[4] +1), $id);

    my $i_shortcut    = $c->param("shortcut")       // undef;
    my $i_description = $c->param("description")    // undef;

    my $i_fascicle    = $c->param("fascicle")       // undef;
    my $i_advertiser  = $c->param("advertiser")     // undef;

    my $i_module      = $c->param("module")         // undef;
    my $i_template    = $c->param("template")       // undef;

    my $i_status      = $c->param("status")         // undef;
    my $i_squib       = $c->param("squib")          // undef;
    my $i_payment     = $c->param("payment")        // undef;
    my $i_readiness   = $c->param("readiness")      // undef;

    $i_payment   = "no" unless ($i_payment);
    $i_readiness = "no" unless ($i_readiness);

    $c->check_text( \@errors, "shortcut", $i_shortcut);
    $c->check_text( \@errors, "description", $i_description);

    unless ($i_module) {
        unless ($i_template) {
            push @errors, { id => "module",   msg => "Incorrectly filled field"};
        }
    }

    $c->check_uuid( \@errors, "module", $i_module) if (length $i_module > 0);
    $c->check_uuid( \@errors, "template", $i_template) if (length $i_template > 0);

    my $fascicle   = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);
    my $advertiser = $c->check_record(\@errors, "ad_advertisers", "advertiser", $i_advertiser);

    my $place;
    my $pages;
    my $module;
    my $template;

    my $sql_page;
    my $sql_pages;
    my $sql_amount;
    my $sql_module;

    if ($i_module) {

        $module = $c->Q("
                SELECT *
                FROM fascicles_modules
                WHERE id=?
            ", [ $i_module ])->Hash;

        push @errors, { id => "module", msg => "Can't find object"} unless ($module->{id});

        $pages = $c->Q("
                SELECT t2.seqnum
                FROM fascicles_map_modules t1, fascicles_pages t2
                WHERE 1=1
                    AND t2.id = t1.page
                    AND t1.fascicle=?
                    AND t1.module=?
                ORDER BY t2.seqnum
            ", [ $module->{fascicle}, $module->{id} ])->Values;

        $place = $c->Q("
                SELECT t1.*
                FROM fascicles_tmpl_places t1
                WHERE t1.id=?
            ", [ $module->{place} ])->Hash;

        $template = $c->Q("
                SELECT t1.* FROM fascicles_tmpl_modules t1
                WHERE t1.id=?
            ", [ $module->{origin} ])->Hash;

        $sql_module = $module->{id};
        $sql_amount = $module->{amount};
        $sql_page = @$pages[0];
        $sql_pages = join (', ', @$pages);
    }

    if ($i_template) {

        my $map = $c->Q("
                SELECT *
                FROM fascicles_tmpl_index
                WHERE id=? ", [ $i_template ])->Hash;

        $place = $c->Q("
                SELECT *
                FROM fascicles_tmpl_places
                WHERE id=?
            ", [ $map->{place} ])->Hash;

        $template = $c->Q("
                SELECT *
                FROM fascicles_tmpl_modules
                WHERE id=?
            ", [ $map->{entity} ])->Hash;

        $sql_amount = $template->{amount};

    }

    push @errors, { id => "place", msg => "Can't find object"} unless ($place->{id});
    push @errors, { id => "template", msg => "Can't find object"} unless ($template->{id});

    my $error_restrict = 0;
    
    #Restrict by modules
    unless (@errors) {
        
        my $adv_modules = 0;
        
        my $modules = $c->Q("
                SELECT t1.id, t1.area, t1.amount
                FROM fascicles_modules t1, fascicles_map_modules t2, fascicles_pages t3
                WHERE
                    t2.module = t1.id AND t2.page = t3.id AND t3.fascicle=? ",
            [ $fascicle->{id} ])->Hashes;
        
        foreach  my $module(@$modules){
            $module->{area} = 1 if ($module->{amount} > 1);
            $adv_modules +=  $module->{area};
        }
        
        if ($fascicle->{adv_modules} && $fascicle->{adv_modules} <= $adv_modules) {
            $error_restrict = 1;
            push @errors, { id => "restricted", msg => "advertisements.restricted.exceeded_amount" };
        }
    }
    
    #Restrict by date
    unless (@errors) {    
        if ($fascicle->{adv_date} && time() >= str2time($fascicle->{adv_date})) {
            $error_restrict = 1;
            push @errors, { id => "restricted", msg => "advertisements.restricted.exceeded_time" };
        }
    }
    
    unless (@errors) {

        $c->Do("
            INSERT INTO fascicles_requests(
                id,
                edition, fascicle,
                advertiser, advertiser_shortcut,
                place, place_shortcut,
                manager, manager_shortcut,
                group_id, fs_folder,
                origin, origin_shortcut, origin_area, origin_x, origin_y, origin_w, origin_h,
                module, amount,
                firstpage, pages,
                shortcut, description,
                status, squib, payment, readiness,
                created, updated)
            VALUES (
                ?,
                ?, ?,
                ?, ?,
                ?, ?,
                ?, ?,
                ?, ?,
                ?, ?, ?, ?, ?, ?, ?,
                ?, ?,
                ?, ?,
                ?, ?,
                ?, ?, ?, ?,
                now(), now());
        ", [
            $id,
            $fascicle->{edition}, $fascicle->{id},
            $advertiser->{id}, $advertiser->{shortcut},
            $place->{id}, $place->{title},
            $c->getSessionValue("member.id"), $c->getSessionValue("member.shortcut"),
            $group_id, $fs_folder,
            $template->{id}, $template->{title}, $template->{area},  $template->{x},  $template->{y},  $template->{w},  $template->{h},
            $sql_module, $sql_amount,
            $sql_page, $sql_pages,
            $i_shortcut, $i_description,
            $i_status, $i_squib, $i_payment, $i_readiness
        ]);
    } else {
        if($error_restrict) {
            $c->Do("
                    DELETE 
                    FROM fascicles_modules
                    WHERE id=?
                ", [ $module->{id} ]);
        }
    }

    # Create event
    unless (@errors) {
        Inprint::Fascicle::Events::onCompositionChanged($c, $fascicle);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub update {
    my $c = shift;

    my $i_id          = $c->param("id");

    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    my $i_advertiser  = $c->param("advertiser") || undef;
    my $i_manager     = $c->param("manager")    || undef;

    my $i_fascicle    = $c->param("fascicle")   || undef;
    my $i_module      = $c->param("module")     || undef;

    my $i_status      = $c->param("status")     || undef;
    my $i_squib       = $c->param("squib")      || undef;

    my $i_payment     = $c->param("payment")   eq "on" ? "yes" : "no";
    my $i_approved    = $c->param("approved")  eq "on" ? "yes" : "no";

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "id", $i_id);
    $c->check_text( \@errors, "shortcut", $i_shortcut);
    $c->check_text( \@errors, "description", $i_description);

    $c->check_access( \@errors, "domain.roles.manage");

    my $fascicle   = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);

    unless (@errors) {
        $c->Do("
            UPDATE fascicles_requests SET
                advertiser=?,
                status=?, squib=?, payment=?, readiness=?,
                shortcut=?, description=?,
                updated=now()
            WHERE id=?;

        ", [
            $i_advertiser,
            $i_status, $i_squib, $i_payment, $i_approved,
            $i_shortcut, $i_description,
            $i_id
        ]);
    }

    # Create event
    unless (@errors) {
        Inprint::Fascicle::Events::onCompositionChanged($c, $fascicle);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub move {
    my $c = shift;

    my $i_fascicle  = $c->param("fascicle");
    my @i_requests    = $c->param("request");
    my @i_pages       = $c->param("page");

    my @errors;
    my $success = $c->json->false;

    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->objectAccess("domain.roles.manage"));

    my $fascicle   = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);

    my @pages;

    foreach my $string (@i_pages) {

        my ($page_id, $seqnum) = split "::", $string;
        my $page = $c->Q(" SELECT * FROM fascicles_pages WHERE id=? AND seqnum=? ", [ $page_id, $seqnum ])->Hash;

        if ($page->{id}) {
            push @pages, $page;
        }

        push @errors, { id => "page", msg => "Can't find object"}
            unless ($page->{id});
    }

    unless (@errors) {

        foreach my $id (@i_requests) {

            my $request;

            if ($c->is_uuid($id)) {
                $request = $c->Q(" SELECT * FROM fascicles_requests WHERE id=? ", [ $id ])->Hash;
            }

            my $module;

            if ($request->{id}) {
                $module = $c->Q(" SELECT * FROM fascicles_modules WHERE id=? ", [ $request->{module} ])->Hash;
            }

            if ($module->{id}) {

                $c->sql->bt;

                $c->Do(" DELETE FROM fascicles_map_modules WHERE module=? ", [ $request->{module} ]);

                foreach my $page ( @pages ) {

                    $c->Do("
                        INSERT INTO fascicles_map_modules(
                            edition, fascicle, module, page, placed, x, y, created, updated)
                        VALUES (?, ?, ?, ?, false, ?, ?, now(), now());
                        ", [
                        $request->{edition}, $request->{fascicle}, $module->{id}, $page->{id}, "1/1", "1/1"
                    ]);

                }

                $c->sql->et;
            }
        }
    }

    # Create event
    Inprint::Fascicle::Events::onCompositionChanged($c, $fascicle);

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub delete {
    my $c = shift;

    my $i_fascicle  = $c->param("fascicle");

    my $d_request = $c->param("delete-request");
    my $d_module  = $c->param("delete-module");

    my @requests  = $c->param("request");

    my @errors;
    my $success = $c->json->false;

    my $fascicle   = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);

    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->objectAccess("domain.roles.manage"));

    unless (@errors) {

        foreach my $id (@requests ) {

            my $request;

            if ($c->is_uuid($id)) {
                $request = $c->Q(" SELECT * FROM fascicles_requests WHERE id=? ", [ $id ])->Hash;
            }

            if ($request->{id}) {

                $c->sql->bt;

                if ($d_request eq "true") {

                    $c->Do(" DELETE FROM fascicles_requests WHERE id=? ", [ $request->{id} ]);

                    my $exist = $c->Q(" SELECT EXISTS ( SELECT id FROM fascicles_requests WHERE module=? ) ", [ $request->{module} ])->Value;

                    if ($d_module eq "true") {
                        unless ($exist) {
                            $c->Do(" DELETE FROM fascicles_modules WHERE id=? ", [ $request->{module} ]);
                        }
                    }

                }

                $c->sql->et;
            }
        }
    }

    # Create event
    Inprint::Fascicle::Events::onCompositionChanged($c, $fascicle);

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

1;
