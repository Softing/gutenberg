package Inprint::Advertising::Requests;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license
use utf8;
use strict;
use warnings;

use Encode;
use File::Path;
use File::Basename;
use File::stat;
use Text::Unidecode;

use Inprint::Utils::Files;
use Inprint::Store::Embedded;
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

    my $flt_fascicle = $c->param("flt_fascicle");
    my $flt_checked  = $c->param("flt_checked");

    my $filter = {
        flt_fascicle => $flt_fascicle,
        flt_checked  => $flt_checked,
    };

    my $sorting = {
        dir    => $c->param("dir") || "asc",
        column => $c->param("sort") || "shortcut",
    };

    $c->check_uuid( \@errors, "id", $filter->{flt_fascicle});

    unless (@errors) {
        $result = Inprint::Models::Fascicle::Request::search($c, $filter, $sorting);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub summary {
    my $c = shift;

    my @result;
    my @errors;

    my $i_fascicle = $c->get_uuid(\@errors, "flt_fascicle");

    $c->smart_render( \@errors ) if @errors;

    my $bindings = $c->objectBindings([
        "editions.advert.manage:*",
        "editions.advert.view:*" ]);

    my $fascicle = $c->Q("
            SELECT t1.id, t1.shortcut, t2.id as edition, t2.shortcut as edition_shortcut
            FROM fascicles t1, editions t2
            WHERE 1=1
                AND t1.id=?
                AND t1.edition = ANY(?)
                AND t1.edition  = t2.id
                AND t1.enabled  = true
                AND t1.archived = false
                AND t1.deleted  = false ",
        [ $i_fascicle, $bindings ])->Hash;

    my $children = $c->Q("
            SELECT t1.id, t1.shortcut, t2.id as edition, t2.shortcut as edition_shortcut
            FROM fascicles t1, editions t2
            WHERE 1=1
                AND t1.parent=?
                AND t1.edition = ANY(?)
                AND t1.edition  = t2.id
                AND t1.enabled  = true
                AND t1.archived = false
                AND t1.deleted  = false
            ORDER BY t1.shortcut ",
        [ $i_fascicle, $bindings ])->Hashes;

    if ($fascicle->{id}) {
        push @result, $fascicle;
    }

    foreach (@$children) {
        if ($_->{id}) {
            push @result, $_;
        }
    }

    foreach my $item (@result) {
        my $total    = $c->Q(" SELECT count(*) FROM fascicles_requests WHERE fascicle=?", $item->{id})->Value;
        my $check    = $c->Q(" SELECT count(*) FROM fascicles_requests WHERE fascicle=? AND check_status='check' ", $item->{id})->Value;
        my $error    = $c->Q(" SELECT count(*) FROM fascicles_requests WHERE fascicle=? AND check_status='error' ", $item->{id})->Value;
        my $ready    = $c->Q(" SELECT count(*) FROM fascicles_requests WHERE fascicle=? AND check_status='ready' ", $item->{id})->Value;
        my $anothers = $c->Q(" SELECT count(*) FROM fascicles_requests WHERE fascicle=? AND anothers_layout=true ", $item->{id})->Value;
        my $imposed  = $c->Q(" SELECT count(*) FROM fascicles_requests WHERE fascicle=? AND check_status='imposed' ", $item->{id})->Value;
        $item->{total}    = $total;
        $item->{check}    = $check;
        $item->{error}    = $error;
        $item->{ready}    = $ready;
        $item->{anothers} = $anothers;
        $item->{imposed}  = $imposed;
    }

    $c->smart_render( \@errors, \@result );
}

sub status {
    my $c = shift;

    my @errors;

    my @i_id     = $c->param("id");
    my $i_status = $c->param("status");

    unless ($i_status ~~ [ "error", "check", "ready", "imposed", "anothers", "notanothers" ]) {
        push @errors, {
            id => "status", msg => "Status not found"
        }
    }

    unless (@errors) {
        foreach my $id (@i_id) {

            if ($i_status ~~ [ "error", "check", "ready", "imposed" ]) {
                $c->Do(" UPDATE fascicles_requests SET check_status=? WHERE id=? ", [ $i_status, $id ]);
            }

            if ($i_status eq "anothers") {
                $c->Do(" UPDATE fascicles_requests SET anothers_layout=true WHERE id=? ", [ $id ]);
                $c->Do(" UPDATE fascicles_requests SET check_status='ready' WHERE id=? ", [ $id ]);
            }
            if ($i_status eq "notanothers") {
                $c->Do(" UPDATE fascicles_requests SET anothers_layout=false WHERE id=? ", [ $id ]);
                $c->Do(" UPDATE fascicles_requests SET check_status='check' WHERE id=? ", [ $id ]);
            }
        }
    }

    $c->smart_render( \@errors);
}

sub create {
    my $c = shift;

    my $id = $c->uuid();

    my $i_shortcut    = $c->param("shortcut") || undef;
    my $i_description = $c->param("description") || undef;

    my $i_fascicle    = $c->param("fascicle") || undef;
    my $i_advertiser  = $c->param("advertiser") || undef;

    my $i_module      = $c->param("module") || undef;
    my $i_template    = $c->param("template") || undef;

    my $i_status      = $c->param("status") || undef;
    my $i_squib       = $c->param("squib") || undef;
    my $i_payment     = $c->param("payment") || undef;
    my $i_readiness   = $c->param("readiness") || undef;

    my @errors;
    my $success = $c->json->false;

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

    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->objectAccess("domain.roles.manage"));

    if ($i_module) {

        my $module;
        unless(@errors) {
            $module = $c->Q(" SELECT * FROM fascicles_modules WHERE id=? ", [ $i_module ])->Hash;
            push @errors, { id => "module", msg => "Can't find object"}
                unless ($module->{id});
        }

        my $place;
        unless(@errors) {
            $place = $c->Q("
                    SELECT t1.* FROM fascicles_tmpl_places t1
                    WHERE t1.id=?
                ", [ $module->{place} ])->Hash;
            push @errors, { id => "place", msg => "Can't find object"}
                unless ($place->{id});
        }

        my $template;
        unless(@errors) {
            $template = $c->Q("
                    SELECT t1.* FROM fascicles_tmpl_modules t1
                    WHERE t1.id=?
                ", [ $module->{origin} ])->Hash;
            push @errors, { id => "template", msg => "Can't find object"}
                unless ($template->{id});
        }

        my $pages;
        unless(@errors) {
            $pages = $c->Q("
                    SELECT t2.seqnum
                    FROM fascicles_map_modules t1, fascicles_pages t2
                    WHERE t2.id = t1.page AND t1.fascicle=? AND t1.module=?
                    ORDER BY t2.seqnum
                ", [ $module->{fascicle}, $module->{id} ])->Values;
        }

        unless (@errors) {
            $c->Do("
                INSERT INTO fascicles_requests(
                    id,
                    edition, fascicle,
                    advertiser, advertiser_shortcut,
                    place, place_shortcut,
                    manager, manager_shortcut,
                    origin, origin_shortcut, origin_area, origin_x, origin_y, origin_w, origin_h,
                    module, amount,
                    pages, firstpage,
                    shortcut, description,
                    status, squib, payment, readiness,
                    created, updated)
                VALUES (
                    ?,
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
                $template->{id}, $template->{title}, $template->{area},  $template->{x},  $template->{y},  $template->{w},  $template->{h},
                $module->{id}, $module->{amount},
                join (', ', @$pages), @$pages[0],
                $i_shortcut, $i_description,
                $i_status, $i_squib, $i_payment, $i_readiness
            ]);
        }

    }

    if ($i_template) {

        my $template;
        unless(@errors) {
            $template = $c->Q(" SELECT * FROM fascicles_tmpl_modules WHERE id=? ", [ $i_template ])->Hash;
            push @errors, { id => "template", msg => "Can't find object"}
                unless ($template->{id});
        }

        my $place;
        unless(@errors) {
            $place = $c->Q("
                    SELECT t1.* FROM fascicles_tmpl_places t1, fascicles_tmpl_index t2
                    WHERE t2.place=t1.id AND t2.nature='module' AND t2.entity=?
                ", [ $template->{id} ])->Hash;
            push @errors, { id => "place", msg => "Can't find object"}
                unless ($place->{id});
        }

        unless (@errors) {
            $c->Do("
                INSERT INTO fascicles_requests(
                    id,
                    edition, fascicle,
                    advertiser, advertiser_shortcut,
                    place, place_shortcut,
                    manager, manager_shortcut,
                    origin, origin_shortcut, origin_area, origin_x, origin_y, origin_w, origin_h,
                    module, amount,
                    shortcut, description,
                    status, squib, payment, readiness,
                    created, updated)
                VALUES (
                    ?,
                    ?, ?,
                    ?, ?,
                    ?, ?,
                    ?, ?,
                    ?, ?, ?, ?, ?, ?, ?,
                    null, ?,
                    ?, ?,
                    ?, ?, ?, ?,
                    now(), now());
            ", [
                $id,
                $fascicle->{edition}, $fascicle->{id},
                $advertiser->{id}, $advertiser->{shortcut},
                $place->{id}, $place->{title},
                $c->getSessionValue("member.id"), $c->getSessionValue("member.shortcut"),
                $template->{id}, $template->{title}, $template->{area},  $template->{x},  $template->{y},  $template->{w},  $template->{h},
                $template->{amount},
                $i_shortcut, $i_description,
                $i_status, $i_squib, $i_payment, $i_readiness
            ]);
        }

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

    #my $module = $c->Q(" SELECT * FROM fascile_modules WHERE id=? ", [ $i_module ])->Hash;
    #my $place  = $c->Q(" SELECT * FROM fascile_tmpl_places WHERE id=? ", [ $module->{place} ])->Hash;

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

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub download {

    my $c = shift;

    my @errors;

    my @i_requests  = $c->param("request[]");
    my $i_safemode  = $c->param("safemode");

    my $temp        = $c->uuid;
    my $rootPath    = $c->config->get("store.path");
    my $tempPath    = $c->config->get("store.temp");
    my $tempFolder  = "$tempPath/inprint-$temp";
    my $tempArchive = "$tempPath/inprint-$temp.7z";

    $tempFolder  = __FS_AdaptPath($c, $tempFolder);
    $tempArchive = __FS_AdaptPath($c, $tempArchive);

    mkdir $tempFolder;

    die "Can't create temporary folder $tempFolder" unless (-e -w $tempFolder);

    my $fileListString;

    my $currentMember = $c->getSessionValue("member.id");

    foreach my $id (@i_requests) {

        my $object = $c->check_record(\@errors, "fascicles_requests", "request", $id);
        next unless ($object->{id});

        my $folder = Inprint::Store::Embedded::getFolderPath($c, "requests", $object->{created}, $object->{id}, 1);

        opendir(my $dh, $folder) || die "can't opendir $folder: $!";
        my @files = readdir($dh);
        closedir $dh;

        foreach my $file_name (@files) {

            next if ($file_name eq ".");
            next if ($file_name eq "..");

            my $file_ext = __FS_GetExtension($c, $file_name);
            next unless $file_ext ~~ ["tif", "tiff", "eps", "pdf"];

            $file_name = Encode::decode("utf8", $file_name);

            my $pathSource  = $folder ."/".  $file_name;
            #my $pathSymlink = $tempFolder ."/". $object->{shortcut} ."__". $file_name;
            my $pathSymlink = $tempFolder ."/__". $file_name;

            if ($i_safemode eq 'true') {
                $pathSymlink = unidecode($pathSymlink);
                $pathSymlink =~ s/[^\w|\d|\\|\/|\.|-]//g;
                $pathSymlink =~ s/\s+/_/g;
            }

            #$pathSource  = __FS_ProcessPath($c, $pathSource);
            #$pathSymlink = __FS_ProcessPath($c, $pathSymlink);

            next unless (-e -r $pathSource);

            symlink $pathSource, $pathSymlink;

            die "Can't read symlink $pathSymlink" unless (-e -r $pathSymlink);

            $fileListString .= ' "'. $pathSymlink .'" ';

        }
    }

    __FS_CreateTempArchive($c, $tempArchive, $fileListString);

    rmtree($tempFolder);

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

    $year += 1900; $mon++;

    my $archname = "Downloads_for_${year}_${mon}_${mday}_${hour}${min}${sec}";

    $c->on(finish=>sub {
        unlink $tempArchive;
    });

    $c->tx->res->headers->content_length(-s $tempArchive);
    $c->tx->res->headers->content_disposition("attachment;name=$archname.7z");
    $c->tx->res->headers->content_type("application/x-7z-compressed;name=$archname.7z");

    $c->res->content->asset(
        Mojo::Asset::File->new(path => $tempArchive )
    );

    $c->smart_render([]);
    #$c->render();
}

sub delete {
    my $c = shift;

    my $i_fascicle  = $c->param("fascicle");

    my $d_request = $c->param("delete-request");
    my $d_module  = $c->param("delete-module");

    my @requests  = $c->param("request");

    my @errors;
    my $success = $c->json->false;

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

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

1;
