package Inprint::Template::Pages;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Fascicle::Utils;
use Inprint::Models::Fascicle::Page;
use Inprint::Models::Fascicle::Pages;

use Inprint::Fascicle::Utils;

use base 'Mojolicious::Controller';

sub read {

    my $c = shift;

    my @i_pages    = $c->param("page");

    my @data, my @errors;

    unless (@errors) {
        foreach my $item (@i_pages) {
            my ($pageid, $seqnum) = split "::", $item;
            my $page = $c->Q(
                " SELECT * FROM template_page WHERE id=? AND seqnum=? ",
                [ $pageid, $seqnum ])->Hash();
            push @data, $page;
        }
    }

    $c->smart_render(\@errors, \@data);
}

sub create {

    my $c = shift;

    my @errors;

    my $i_string   = $c->param("page");

    my $i_fascicle = $c->get_uuid(\@errors, "fascicle");
    my $i_template = $c->get_uuid(\@errors, "template");
    my $i_headline = $c->get_uuid(\@errors, "headline");

    my $fascicle = $c->check_record(\@errors, "template", "template", $i_fascicle);

    my $template = $c->Q("
        SELECT * FROM ad_pages WHERE id = ? ",
        [ $i_template ])->Hash;

    push @errors, { id => "template", msg => "Can't find object"}
        unless ($template->{id});

    my $headline = $c->Q("
        SELECT * FROM indx_headlines WHERE id=? ",
        [ $i_headline ])->Hash;

    push @errors, { id => "headline", msg => "Can't find object"}
        unless ($headline->{id});

    unless (@errors) {

        my $pages  = Inprint::Fascicle::Utils::uncompressString($c, $i_string);
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
                    UPDATE template_page SET seqnum=? WHERE id=?
                ", [$page->{seqnum}, $page->{id}]);
            }
        }

        foreach my $page (@inserts) {
            my $id = $c->uuid;

            $c->Do("
                INSERT INTO template_page
                    (
                        id,
                        edition, template,
                        headline,
                        seqnum,
                        origin, width, height,
                        created, updated)
                    VALUES (
                        ?,
                        ?, ?,
                        ?,
                        ?,
                        ?, ?, ?,
                        now(), now()); ",
                [
                    $id,
                    $page->{edition}, $page->{fascicle},
                    $page->{headline},
                    $page->{seqnum},
                    $template->{id}, $template->{w}, $template->{h} ]);
        }

        $c->sql->et;

    }

    $c->smart_render(\@errors);
}

sub update {

    my $c = shift;

    my @errors;

    my @i_pages    = $c->param("page");

    my $i_fascicle = $c->get_uuid(\@errors, "fascicle");
    my $i_template = $c->get_uuid(\@errors, "template");
    my $i_headline = $c->get_uuid(\@errors, "headline");

    my $fascicle = $c->check_record(\@errors, "template", "template", $i_fascicle);

    my $template = $c->Q("
        SELECT * FROM ad_pages WHERE id = ? ",
        [ $i_template ])->Hash;

    push @errors, { id => "template", msg => "Can't find object"}
        unless ($template->{id});

    my $headline = $c->Q("
        SELECT * FROM indx_headlines WHERE id=? ",
        [ $i_headline ])->Hash;

    push @errors, { id => "headline", msg => "Can't find object"}
        unless ($headline->{id});

    $c->sql->bt;
    unless (@errors) {
        foreach my $item (@i_pages) {
            my ($page, $seqnum) = split "::", $item;
            $c->Do("
                UPDATE template_page
                    SET
                        headline=?,
                        origin=?, width=?, height=?

                WHERE 1=1
                    AND id=?
                    AND seqnum=? ",
                [
                    $headline->{id},
                    $template->{id}, $template->{w}, $template->{h},
                    $page, $seqnum ]);
        }
    }
    $c->sql->et;

    $c->smart_render(\@errors);
}

sub move {

    my $c = shift;

    my @errors;

    my $i_fascicle = $c->get_uuid(\@errors, "fascicle");
    my $i_after    = $c->get_int(\@errors, "after");
    my @i_pages    = $c->param("page");

    my $fascicle = $c->check_record(\@errors, "template", "template", $i_fascicle);

    unless (@errors) {

        my $composition = $c->Q("
            SELECT id, edition, template, headline, seqnum, width as w, height as h, created, updated
            FROM template_page WHERE template = ?; ",[
                $i_fascicle
            ])->Hashes;

        my $dbg;

        my @inputPages;

        foreach my $item (@i_pages) {
            my ($id, $seqnum) = split "::", $item;
            my $page = $c->Q(" SELECT * FROM template_page WHERE id=? AND seqnum=? ", [ $id, $seqnum ])->Hash;
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
                $c->Do(" UPDATE template_page SET seqnum=? WHERE id=? ", [$page->{seqnum}, $page->{id}]);
            }
        }

        $c->sql->et;

    }

    $c->smart_render(\@errors);
}


sub left {

    my $c = shift;

    my @errors;

    my $i_fascicle = $c->get_uuid(\@errors, "fascicle");
    my $i_amount   = $c->get_int(\@errors, "amount");
    my $i_page     = $c->param("page");

    my $fascicle = $c->check_record(\@errors, "template", "template", $i_fascicle);

    unless (@errors) {

        my $composition = $c->Q("
            SELECT id, edition, template, headline, seqnum, width as w, height as h, created, updated
            FROM template_page WHERE template = ?; ",[
                $i_fascicle
            ])->Hashes;

        my ($id, $seqnum) = split "::", $i_page;
        my $page = $c->Q(" SELECT * FROM template_page WHERE id=? AND seqnum=? ", [ $id, $seqnum ])->Hash;

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
                $c->Do(" UPDATE template_page SET seqnum=? WHERE id=? ", [$page->{seqnum}, $page->{id}]);
            }
        }

        $c->sql->et;
    }

    $c->smart_render(\@errors);
}

sub right {

    my $c = shift;

    my @errors;

    my $i_fascicle = $c->get_uuid(\@errors, "fascicle");
    my $i_amount   = $c->get_int(\@errors, "amount");
    my $i_page     = $c->param("page");

    my $fascicle = $c->check_record(\@errors, "template", "template", $i_fascicle);

    unless (@errors) {

        my $composition = $c->Q("
            SELECT id, edition, template, headline, seqnum, width as w, height as h, created, updated
            FROM template_page WHERE template = ?; ",[
                $i_fascicle
            ])->Hashes;


        my ($id, $seqnum) = split "::", $i_page;
        my $page = $c->Q(" SELECT * FROM template_page WHERE id=? AND seqnum=? ", [ $id, $seqnum ])->Hash;

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
                $c->Do(" UPDATE template_page SET seqnum=? WHERE id=? ", [$page->{seqnum}, $page->{id}]);
            }
        }

        $c->sql->et;

    }

    $c->smart_render(\@errors);
}


sub delete {

    my $c = shift;

    my @errors;

    my $i_fascicle = $c->get_uuid(\@errors, "fascicle");
    my @i_pages    = $c->param("page");

    my $fascicle = $c->check_record(\@errors, "template", "template", $i_fascicle);

    unless (@errors) {

        foreach my $item (@i_pages) {
            my ($id, $seqnum) = split "::", $item;

            my $page    = $c->Q(" SELECT * FROM template_page WHERE id=? AND seqnum=? ", [ $id, $seqnum ])->Hash;
            next unless ($page->{id});

            $c->sql->bt;
            $c->Do(" DELETE FROM template_page WHERE id=? ", [ $page->{id} ]);
            $c->sql->et;
        }

    }

    $c->smart_render(\@errors);
}

1;
