package Inprint::Models::Fascicle::Pages;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Fascicle::Page;

use base 'Mojolicious::Controller';

sub move {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my $i_after    = $c->param("after");
    my @i_pages    = $c->param("page");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "after", msg => "Incorrectly filled field"}
        unless ($c->is_int($i_after));

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

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

        #die $dbg;

        $c->sql->bt;
        foreach my $page (@$composition) {
            if ( $page->{id} && $page->{is_updated} == 1) {
                $c->Do(" UPDATE fascicles_pages SET seqnum=? WHERE id=? ", [$page->{seqnum}, $page->{id}]);
            }
        }
        $c->sql->et;

    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub right {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my $i_amount   = $c->param("amount");
    my $i_page    = $c->param("page");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "amount", msg => "Incorrectly filled field"}
        unless ($c->is_int($i_amount));

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

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
        $c->sql->et;

    }


    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub left {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my $i_amount   = $c->param("amount");
    my $i_page    = $c->param("page");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "amount", msg => "Incorrectly filled field"}
        unless ($c->is_int($i_amount));

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

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
        $c->sql->et;
    }


    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub resize {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    my $data;

    unless (@errors) {

    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => [ $data ] });
}

sub clean {

    my $c = shift;

    my $i_fascicle  = $c->param("fascicle");
    my $i_documents = $c->param("documents");
    my $i_adverts   = $c->param("adverts");
    my @i_pages    = $c->param("page");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    my $fascicle = $c->Q(" SELECT * FROM fascicles WHERE id = ? ", [ $i_fascicle ])->Hash;

    push @errors, { id => "fascicle", msg => "Can't find object"}
        unless ($fascicle->{id});

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

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub delete {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my @i_pages    = $c->param("page");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    my $fascicle = $c->Q(" SELECT * FROM fascicles WHERE id = ? ", [ $i_fascicle ])->Hash;

    push @errors, { id => "fascicle", msg => "Can't find object"}
        unless ($fascicle->{id});

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
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

1;
