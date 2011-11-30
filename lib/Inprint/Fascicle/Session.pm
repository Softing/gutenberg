package Inprint::Fascicle::Session;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Database;

use base 'Mojolicious::Controller';

sub seance {

    my $c = shift;

    my @errors;

    my $fascicle  = Inprint::Database::FascicleService($c)->load( id => $c->param("fascicle") );
    my $edition   = Inprint::Database::EditionService($c)->load( id => $fascicle->edition );

    $fascicle->{shortcut} = $edition->shortcut ."/". $fascicle->shortcut;

    # Statusbar
    $c->smart_render(\@errors, {
        fascicle    => $fascicle->json,
        summary     => $fascicle->Summary(),
        access      => $fascicle->Access(),
        composition => _createComposeIndex($c, $fascicle),
        documents   => _createDocumentsIndex($c, $fascicle),
        advertising => _createAdvertIndex($c, $fascicle),
        requests    => _createRequestsIndex($c, $fascicle),
    });

}

sub check {

    my $c = shift;

    my @errors;

    my $fascicle  = Inprint::Database::FascicleService($c)->load( id => $c->param("fascicle") );
    my $edition   = Inprint::Database::Edition($c)->load( id => $fascicle->edition );

    $fascicle->{shortcut} = $edition->shortcut ."/". $fascicle->shortcut;

    $c->smart_render(\@errors, {
        fascicle    => $fascicle->json,
        summary     => $fascicle->Summary(),
        access      => $fascicle->Access(),
    });

}

sub _createDocumentsIndex {
    my ($c, $fascicle) = @_;
    return Inprint::Database::DocumentsManager($c)->list(fascicle => $fascicle->id, orderBy => "headline_shortcut")->json;
}

sub _createComposeIndex {

    my ($c, $fascicle) = @_;

    my $result = {};

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
        [ $fascicle->id ])->Hashes;

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
    ", [ $fascicle->id ])->Hashes;

    foreach my $item (@$dbdocuments) {

        $item->{title} =~ s/"/&quot;/ig;

        $index->{$item->{id}} = $idcounter++;

        $documents->{$index->{$item->{id}}} = {
            id => $item->{id},
            title => $item->{title}
        };

        my $docpages = $c->Q("
            SELECT t2.id
            FROM fascicles_map_documents t1, fascicles_pages t2
            WHERE t2.id = t1.page AND t1.fascicle = ? AND entity = ?
        ", [ $fascicle->id, $item->{id} ])->Values;

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
    ", [ $fascicle->id ])->Hashes;

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
    ", [ $fascicle->id ])->Hashes;

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

    $result->{pages}      = $pages;
    $result->{documents}  = $documents;
    $result->{holes}      = $holes;
    $result->{requests}   = $requests;
    $result->{pageorder}  = \@pageorder;

    return [ $result ];
}

sub _createRequestsIndex {
    my ($c, $fascicle) = @_;
    return $fascicle->Requests;
}

sub _createAdvertIndex {

    my ($c, $fascicle) = @_;

    my @result;

    # Get adv places
    my $places = $c->Q("
        SELECT id, fascicle, title, description, created, updated
        FROM fascicles_tmpl_places WHERE fascicle = ? ORDER BY title
    ", [ $fascicle->id ])->Hashes;

    foreach my $place (@$places) {

        # Get adv modules for place
        my $tmpl_modules = $c->Q("
            SELECT
                t1.id, t1.origin, t1.fascicle, t1.page, t1.title,
                t1.description, t1.amount, t1.area, t1.x, t1.y, t1.w, t1.h,
                t1.created, t1.updated
            FROM fascicles_tmpl_modules t1, fascicles_tmpl_index t2
            WHERE t1.fascicle=? AND t2.entity=t1.id AND t2.place=?
        ", [ $fascicle->id, $place->{id} ])->Hashes;

        foreach my $tmpl_module (@$tmpl_modules) {

            my $pages = $c->Q("
                    SELECT t3.seqnum
                    FROM fascicles_modules t1, fascicles_map_modules t2, fascicles_pages t3
                    WHERE t2.module=t1.id AND t2.page=t3.id
                        AND t1.fascicle=? AND t1.place=? AND t1.origin=?
                    ORDER BY t3.seqnum
                ", [ $fascicle->id, $place->{id}, $tmpl_module->{id} ])->Values;

            $pages = join ", ", @$pages;

            my $modules = $c->Q("
                    SELECT count(*)
                    FROM fascicles_modules t1
                    WHERE t1.fascicle=? AND t1.place=? AND t1.origin=?
                ", [ $fascicle->id, $place->{id}, $tmpl_module->{id} ])->Value || 0;

            my $requests = $c->Q("
                SELECT count(*) FROM fascicles_requests WHERE fascicle=? AND place=? AND origin=?
            ", [ $fascicle->id, $place->{id}, $tmpl_module->{id} ])->Value || 0;

            my $freespace = $modules - $requests;

            push @result, {
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

    return \@result;
}

1;
