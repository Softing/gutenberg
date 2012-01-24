package Inprint::Fascicle::Pages;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Fascicle::Events;
use Inprint::Fascicle::Utils;

use Inprint::Models::Fascicle::Page;
use Inprint::Models::Fascicle::Pages;

use base 'Mojolicious::Controller';

sub read {

    my $c = shift;

    my @i_pages    = $c->param("page");

    my @data, my @errors;

    unless (@errors) {
        foreach my $item (@i_pages) {
            my ($pageid, $seqnum) = split "::", $item;
            my $page = $c->Q(" SELECT * FROM fascicles_pages WHERE id=? AND seqnum=? ", [ $pageid, $seqnum ])->Hash();
            push @data, $page;
        }
    }

    $c->smart_render(\@errors, \@data);
}

sub create {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my $i_template = $c->param("template");
    my $i_headline = $c->param("headline");
    my $i_string   = $c->param("page");

    my $i_copyfrom   = $c->param("copyfrom");

    my @errors;

    $c->check_uuid( \@errors, "template", $i_template);
    $c->check_uuid( \@errors, "fascicle", $i_fascicle);
    my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);

    my $template = {};
    unless (@errors) {
        if ($i_template eq "00000000-0000-0000-0000-000000000000") {
            $template = $c->Q("
                SELECT * FROM fascicles_tmpl_pages
                WHERE bydefault=true AND fascicle=? ",
                [ $fascicle->{id} ])->Hash;
        } else {
            $template = $c->Q("
                SELECT * FROM fascicles_tmpl_pages WHERE id = ? ",
                [ $i_template ])->Hash;
        }
    }

    push @errors, { id => "template", msg => "Can't find object"}
        unless ($template->{id});

    my $headline = {};
    unless (@errors) {
        if ($i_headline) {
            if ($i_template eq "00000000-0000-0000-0000-000000000000") {
                $headline = $c->Q("
                    SELECT * FROM fascicles_indx_headlines
                    WHERE bydefault=true AND fascicle=? ",
                    [ $fascicle->{id} ])->Hash;
            } else {
                $headline = $c->Q("
                    SELECT * FROM fascicles_indx_headlines WHERE id=? ",
                    [ $i_headline ])->Hash;
            }
        }
    }

    push @errors, { id => "headline", msg => "Can't find object"}
        unless ($headline->{id});

    unless (@errors) {

        my $pages  = Inprint::Fascicle::Utils::uncompressString($c, $i_string, 1);
        my $chunks = Inprint::Fascicle::Utils::getChunks($c, $pages);

        my $composition = $c->Q("
            SELECT id, edition, fascicle, headline, seqnum, w, h, created, updated
            FROM fascicles_pages WHERE fascicle = ?; ",[
                $i_fascicle
            ])->Hashes;

        my @inserts;

        foreach my $newpage (@$pages) {

            push @inserts, {
                edition  => $fascicle->{edition},
                fascicle => $fascicle->{id},
                headline => $headline->{id},
                seqnum   => $newpage
            };

            my $offset = 0;

            foreach my $oldpage (@$composition) {
                if ($oldpage->{seqnum} == $newpage) {
                    $offset = 1;
                }
            }

            foreach my $oldpage (@$composition) {
                if ($oldpage->{seqnum} >= $newpage && $offset == 1) {
                    $oldpage->{seqnum} ++;
                    $oldpage->{is_updated} = 1;
                }
            }

        }

        $c->sql->bt;

        foreach my $page (@$composition) {
            if ( $page->{id} && $page->{is_updated} == 1) {
                $c->Do("
                    UPDATE fascicles_pages SET seqnum=? WHERE id=?
                ", [$page->{seqnum}, $page->{id}]);
            }
        }

        foreach my $page (@inserts) {
            my $id = $c->uuid;

            $c->Do("
                INSERT INTO fascicles_pages(id, edition, fascicle, origin, headline, seqnum, w, h, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now());
            ", [$id, $page->{edition}, $page->{fascicle}, $template->{id}, $page->{headline}, $page->{seqnum}, $template->{w}, $template->{h} ]);
        }

        # Create event
        Inprint::Fascicle::Events::onCompositionChanged($c, $fascicle);

        $c->sql->et;

    }

    $c->smart_render(\@errors);
}

sub update {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my $i_headline = $c->param("headline");
    my @i_pages    = $c->param("page");

    my @errors;

    $c->check_uuid( \@errors, "fascicle", $i_fascicle);
    my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);

    push @errors, { id => "fascicle", msg => "Can't find object"}
        unless ($fascicle->{id});

    my $headline = {};
    if ($i_headline) {
        $headline = $c->Q("
            SELECT * FROM fascicles_indx_headlines WHERE id=? ",
            [ $i_headline ])->Hash;
        push @errors, { id => "headline", msg => "Can't find object"}
            unless ($headline->{id});
    }

    $c->sql->bt;
    unless (@errors) {
        foreach my $item (@i_pages) {
            my ($page, $seqnum) = split "::", $item;
            $c->Do(" UPDATE fascicles_pages SET headline=? WHERE id=? AND seqnum=? ", [ $headline->{id}, $page, $seqnum ]);
        }
    }
    $c->sql->et;

    $c->smart_render(\@errors);
}

sub move {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my $i_after    = $c->param("after");
    my @i_pages    = $c->param("page");

    my @errors;

    $c->check_int( \@errors, "after", $i_after);
    $c->check_uuid( \@errors, "fascicle", $i_fascicle);

    my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);

    unless (@errors) {

        my $composition = $c->Q("
            SELECT id, edition, fascicle, headline, seqnum, w, h, created, updated
            FROM fascicles_pages WHERE fascicle = ?; ",[
                $i_fascicle
            ])->Hashes;

        my $dbg;

        my @inputPages;

        foreach my $item (@i_pages) {
            my ($id, $seqnum) = split "::", $item;
            my $page = $c->Q(" SELECT * FROM fascicles_pages WHERE id=? AND seqnum=? ", [ $id, $seqnum ])->Hash;
            if ($page->{id}) {
                push @inputPages, $page;
            }
        }

        @inputPages = sort { $a->{seqnum} < $b->{seqnum} } @inputPages;

        foreach my $page (@inputPages) {

            $dbg .= " [ $page->{seqnum} ] !!! ";

            @$composition = sort { $a > $b} @$composition;

            if ($page->{id}) {

                if ( $page->{seqnum} > $i_after ) {

                    foreach my $oldpage (@$composition) {

                        if ( $oldpage->{id} eq $page->{id} ) {
                            $dbg .= " $oldpage->{seqnum} == ";
                            $oldpage->{seqnum} = $i_after+1;
                            $oldpage->{is_updated} = 1;
                            $dbg .= " $oldpage->{seqnum} | ";
                        }
                        elsif ( $oldpage->{seqnum} > $i_after && $oldpage->{seqnum} < $page->{seqnum} + 1 ) {
                            $dbg .= " $oldpage->{seqnum} > ";
                            $oldpage->{seqnum} ++;
                            $oldpage->{is_updated} = 1;
                            $dbg .= " $oldpage->{seqnum} | ";
                        }
                    }
                }

                if ( $page->{seqnum} < $i_after ) {
                    foreach my $oldpage (@$composition) {

                        if ( $oldpage->{id} eq $page->{id} ) {
                            $dbg .= " $oldpage->{seqnum} == ";
                            $oldpage->{seqnum} = $i_after;
                            $oldpage->{is_updated} = 1;
                            $dbg .= " $oldpage->{seqnum} | ";
                        }

                        elsif ( $oldpage->{seqnum} > $page->{seqnum} &&  $oldpage->{seqnum} < $i_after+1 ) {
                            $dbg .= " $oldpage->{seqnum} > ";
                            $oldpage->{seqnum} --;
                            $oldpage->{is_updated} = 1;
                            $dbg .= " $oldpage->{seqnum} | ";
                        }

                    }
                }

            }

        }

        $c->sql->bt;

        foreach my $page (@$composition) {
            if ( $page->{id} && $page->{is_updated} == 1) {
                $c->Do(" UPDATE fascicles_pages SET seqnum=? WHERE id=? ", [$page->{seqnum}, $page->{id}]);
            }
        }

        # Create event
        Inprint::Fascicle::Events::onCompositionChanged($c, $fascicle);

        $c->sql->et;

    }

    $c->smart_render(\@errors);
}

sub right {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my $i_amount   = $c->param("amount");
    my $i_page    = $c->param("page");

    my @errors;

    $c->check_int( \@errors, "amount", $i_amount);
    $c->check_uuid( \@errors, "fascicle", $i_fascicle);
    my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);

    unless (@errors) {

        my $composition = $c->Q("
            SELECT id, edition, fascicle, headline, seqnum, w, h, created, updated
            FROM fascicles_pages WHERE fascicle = ?; ",[
                $i_fascicle
            ])->Hashes;


        my ($id, $seqnum) = split "::", $i_page;
        my $page = $c->Q(" SELECT * FROM fascicles_pages WHERE id=? AND seqnum=? ", [ $id, $seqnum ])->Hash;

        if ($page->{id}) {

            foreach my $oldpage (@$composition) {
                if ( $oldpage->{seqnum} >= $page->{seqnum} ) {
                    $oldpage->{seqnum} = $oldpage->{seqnum} + $i_amount;
                    $oldpage->{is_updated} = 1;
                }
            }
        }

        $c->sql->bt;
        foreach my $page (@$composition) {
            if ( $page->{id} && $page->{is_updated} == 1) {
                $c->Do(" UPDATE fascicles_pages SET seqnum=? WHERE id=? ", [$page->{seqnum}, $page->{id}]);
            }
        }

        # Create event
        Inprint::Fascicle::Events::onCompositionChanged($c, $fascicle);

        $c->sql->et;

    }

    $c->smart_render(\@errors);
}

sub left {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my $i_amount   = $c->param("amount");
    my $i_page    = $c->param("page");

    my @errors;

    $c->check_int( \@errors, "amount", $i_amount);
    $c->check_uuid( \@errors, "fascicle", $i_fascicle);

    my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);

    unless (@errors) {

        my $composition = $c->Q("
            SELECT id, edition, fascicle, headline, seqnum, w, h, created, updated
            FROM fascicles_pages WHERE fascicle = ?; ",[
                $i_fascicle
            ])->Hashes;

        my ($id, $seqnum) = split "::", $i_page;
        my $page = $c->Q(" SELECT * FROM fascicles_pages WHERE id=? AND seqnum=? ", [ $id, $seqnum ])->Hash;

        if ($page->{id}) {

            my $dbg;

            # check max amount
            my $min_page = 0;
            foreach my $oldpage (@$composition) {
                if ( $oldpage->{seqnum} >= $page->{seqnum} -  $i_amount ) {
                    if ( $oldpage->{seqnum} < $page->{seqnum} ) {
                        if ( $oldpage->{seqnum} > $min_page ) {
                            $min_page = $oldpage->{seqnum};
                        }
                    }
                }
            }

            my $amount = $i_amount;

            if ($page->{seqnum}-$amount  < $min_page+1) {
                $amount = $page->{seqnum} - $min_page - 1;
            }

            if ($amount > 0) {
                foreach my $oldpage (@$composition) {
                    if ( $oldpage->{seqnum} >= $page->{seqnum} ) {
                        $oldpage->{seqnum} = $oldpage->{seqnum} - $amount;
                        $oldpage->{is_updated} = 1;
                    }
                }
            }
        }

        $c->sql->bt;
        foreach my $page (@$composition) {
            if ( $page->{id} && $page->{is_updated} == 1) {
                $c->Do(" UPDATE fascicles_pages SET seqnum=? WHERE id=? ", [$page->{seqnum}, $page->{id}]);
            }
        }

        # Create event
        Inprint::Fascicle::Events::onCompositionChanged($c, $fascicle);

        $c->sql->et;
    }

    $c->smart_render(\@errors);
}

sub clean {

    my $c = shift;

    my $i_fascicle  = $c->param("fascicle");
    my $i_documents = $c->param("documents");
    my $i_adverts   = $c->param("adverts");
    my @i_pages     = $c->param("page");

    my @errors;

    $c->check_uuid( \@errors, "fascicle", $i_fascicle);
    my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);

    unless (@errors) {
        foreach my $item (@i_pages) {
            my ($id, $seqnum) = split "::", $item;
            my $page = $c->Q(" SELECT * FROM fascicles_pages WHERE id=? AND seqnum=? ", [ $id, $seqnum ])->Hash;
            if ($page->{id}) {
                $c->sql->bt;

                if ($i_documents eq "true") {
                    $c->Do(" DELETE FROM fascicles_map_documents WHERE page=? ", [ $page->{id} ]);
                }

                if ($i_adverts eq "true") {
                    my $modules = $c->Q(" SELECT DISTINCT module FROM fascicles_map_modules WHERE page=? ", [ $page->{id} ])->Values;
                    $c->Do(" DELETE FROM fascicles_modules WHERE id=ANY(?) ", [ $modules ]);
                    #$c->Do(" UPDATE fascicles_map_modules SET placed=false WHERE page=? ", [ $page->{id} ]);
                }

                $c->sql->et;
            }
        }
    }

    # Create event
    Inprint::Fascicle::Events::onCompositionChanged($c, $fascicle);

    $c->smart_render(\@errors);
}

sub delete {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my @i_pages    = $c->param("page");

    my @errors;
    #my $success = $c->json->false;

    $c->check_uuid( \@errors, "fascicle", $i_fascicle);
    my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);

    unless (@errors) {

        foreach my $item (@i_pages) {
            my ($id, $seqnum) = split "::", $item;

            my $page    = $c->Q(" SELECT * FROM fascicles_pages WHERE id=? AND seqnum=? ", [ $id, $seqnum ])->Hash;
            next unless ($page->{id});

            $c->sql->bt;

            my $modules = $c->Q(" SELECT module FROM fascicles_map_modules WHERE page=?", [ $page->{id} ])->Values;

            foreach my $id (@$modules) {
                $c->Do(" DELETE FROM fascicles_modules WHERE id=? ", [ $id ]);
            }

            $c->Do(" DELETE FROM fascicles_pages WHERE id=? ", [ $page->{id} ]);

            $c->sql->et;
        }

        # Create event
        Inprint::Fascicle::Events::onCompositionChanged($c, $fascicle);

    }

    $c->smart_render(\@errors);
}

1;
