package Inprint::Fascicle::Pages;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Utils::Pages;

use base 'Inprint::BaseController';

sub read {

    my $c = shift;

    my @i_pages    = $c->param("page");

    my @data;
    my @errors;
    my $success = $c->json->false;

    unless (@errors) {
        foreach my $item (@i_pages) {
            my ($pageid, $seqnum) = split "::", $item;
            my $page = $c->sql->Q(" SELECT * FROM fascicles_pages WHERE id=? AND seqnum=? ", [ $pageid, $seqnum ])->Hash();
            push @data, $page;
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => \@data });
}

sub templates {
    my $c = shift;

    my @i_pages = $c->param("page");

    my $amount = $#i_pages+1;

    my $result = [];

    my @errors;
    my $success = $c->json->false;

    foreach (@i_pages) {
        push @errors, { id => "page", msg => "Incorrectly filled field"}
            unless ($c->is_uuid($_));
    }

    # Get templates from pages
    my $templates; unless (@errors) {
        $templates = $c->sql->Q(" SELECT DISTINCT origin FROM fascicles_pages WHERE id= ANY(?) ", [ \@i_pages ])->Values;
        push @errors, { id => "page", msg => "Can't find object!"}
            unless (@$templates);
    }

    my $sql;
    my @queries;
    my @params;

    unless (@errors) {

        foreach my $tmpl_id (@$templates) {

            push @queries, "
                SELECT
                    t1.id, t1.origin, t1.fascicle, t1.page, t1.title, t1.description,
                    t1.amount, round(t1.area::numeric, 2) as area, t1.x, t1.y, t1.w, t1.h,
                    t3.title as place_title,
                    t1.created, t1.updated
                FROM fascicles_tmpl_modules t1, fascicles_tmpl_index t2, fascicles_tmpl_places t3
                WHERE
                    t1.page=? AND t1.amount=?
                    AND t2.entity = t1.id AND t2.place = t3.id
                ";
            push @params, $tmpl_id;
            push @params, $amount;
        }

        $sql = join "\n INTERSECT \n", @queries;

    }

    unless (@errors) {
        $result = $c->sql->Q(" $sql ", \@params)->Hashes;
        $c->render_json( { data => $result } );
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub create {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my $i_template = $c->param("template");
    my $i_headline = $c->param("headline");
    my $i_string   = $c->param("page");

    my $i_copyfrom   = $c->param("copyfrom");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    my $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id = ? ", [ $i_fascicle ])->Hash;

    push @errors, { id => "fascicle", msg => "Can't find object"}
        unless ($fascicle->{id});

    push @errors, { id => "template", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_template));

    my $template = {};
    unless (@errors) {
        if ($i_template eq "00000000-0000-0000-0000-000000000000") {
            $template = $c->sql->Q("
                SELECT * FROM fascicles_tmpl_pages
                WHERE bydefault=true AND fascicle=? ",
                [ $fascicle->{id} ])->Hash;
        } else {
            $template = $c->sql->Q("
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
                $headline = $c->sql->Q("
                    SELECT * FROM fascicles_indx_headlines
                    WHERE bydefault=true AND fascicle=? ",
                    [ $fascicle->{id} ])->Hash;
            } else {
                $headline = $c->sql->Q("
                    SELECT * FROM fascicles_indx_headlines WHERE id=? ",
                    [ $i_headline ])->Hash;
            }
        }
    }

    push @errors, { id => "headline", msg => "Can't find object"}
        unless ($headline->{id});

    unless (@errors) {

        my $pages = Inprint::Utils::Pages::UncompressString($c, $i_string);

        my $chunks = Inprint::Utils::Pages::GetChunks($c, $pages);

        my $composition = $c->sql->Q("
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
                $c->sql->Do("
                    UPDATE fascicles_pages SET seqnum=? WHERE id=?
                ", [$page->{seqnum}, $page->{id}]);
            }
        }

        foreach my $page (@inserts) {
            my $id = $c->uuid;

            $c->sql->Do("
                INSERT INTO fascicles_pages(id, edition, fascicle, origin, headline, seqnum, w, h, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now());
            ", [$id, $page->{edition}, $page->{fascicle}, $template->{id}, $page->{headline}, $page->{seqnum}, $template->{w}, $template->{h} ]);
        }

        $c->sql->et;

    }


    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub update {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my $i_headline = $c->param("headline");
    my @i_pages    = $c->param("page");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
    unless ($c->is_uuid($i_fascicle));

    my $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id = ? ", [ $i_fascicle ])->Hash;

    push @errors, { id => "fascicle", msg => "Can't find object"}
        unless ($fascicle->{id});

    my $headline = {};
    if ($i_headline) {
        $headline = $c->sql->Q("
            SELECT * FROM fascicles_indx_headlines WHERE id=? ",
            [ $i_headline ])->Hash;
        push @errors, { id => "headline", msg => "Can't find object"}
            unless ($headline->{id});
    }

    $c->sql->bt;
    unless (@errors) {
        foreach my $item (@i_pages) {
            my ($page, $seqnum) = split "::", $item;
            $c->sql->Do(" UPDATE fascicles_pages SET headline=? WHERE id=? AND seqnum=? ", [ $headline->{id}, $page, $seqnum ]);
        }
    }
    $c->sql->et;


    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

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

        my $composition = $c->sql->Q("
            SELECT id, edition, fascicle, headline, seqnum, w, h, created, updated
            FROM fascicles_pages WHERE fascicle = ?; ",[
                $i_fascicle
            ])->Hashes;

        my $dbg;

        my @inputPages;

        foreach my $item (@i_pages) {
            my ($id, $seqnum) = split "::", $item;
            my $page = $c->sql->Q(" SELECT * FROM fascicles_pages WHERE id=? AND seqnum=? ", [ $id, $seqnum ])->Hash;
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
                $c->sql->Do(" UPDATE fascicles_pages SET seqnum=? WHERE id=? ", [$page->{seqnum}, $page->{id}]);
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

        my $composition = $c->sql->Q("
            SELECT id, edition, fascicle, headline, seqnum, w, h, created, updated
            FROM fascicles_pages WHERE fascicle = ?; ",[
                $i_fascicle
            ])->Hashes;


        my ($id, $seqnum) = split "::", $i_page;
        my $page = $c->sql->Q(" SELECT * FROM fascicles_pages WHERE id=? AND seqnum=? ", [ $id, $seqnum ])->Hash;

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
                $c->sql->Do(" UPDATE fascicles_pages SET seqnum=? WHERE id=? ", [$page->{seqnum}, $page->{id}]);
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

        my $composition = $c->sql->Q("
            SELECT id, edition, fascicle, headline, seqnum, w, h, created, updated
            FROM fascicles_pages WHERE fascicle = ?; ",[
                $i_fascicle
            ])->Hashes;

        my ($id, $seqnum) = split "::", $i_page;
        my $page = $c->sql->Q(" SELECT * FROM fascicles_pages WHERE id=? AND seqnum=? ", [ $id, $seqnum ])->Hash;

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
                $c->sql->Do(" UPDATE fascicles_pages SET seqnum=? WHERE id=? ", [$page->{seqnum}, $page->{id}]);
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

    my $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id = ? ", [ $i_fascicle ])->Hash;

    push @errors, { id => "fascicle", msg => "Can't find object"}
        unless ($fascicle->{id});

    unless (@errors) {
        foreach my $item (@i_pages) {
            my ($id, $seqnum) = split "::", $item;
            my $page = $c->sql->Q(" SELECT * FROM fascicles_pages WHERE id=? AND seqnum=? ", [ $id, $seqnum ])->Hash;
            if ($page->{id}) {
                $c->sql->bt;

                if ($i_documents eq "true") {
                    $c->sql->Do(" DELETE FROM fascicles_map_documents WHERE page=? ", [ $page->{id} ]);
                }

                if ($i_adverts eq "true") {
                    my $modules = $c->sql->Q(" SELECT DISTINCT module FROM fascicles_map_modules WHERE page=? ", [ $page->{id} ])->Values;
                    $c->sql->Do(" DELETE FROM fascicles_modules WHERE id=ANY(?) ", [ $modules ]);
                    #$c->sql->Do(" UPDATE fascicles_map_modules SET placed=false WHERE page=? ", [ $page->{id} ]);
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

    my $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id = ? ", [ $i_fascicle ])->Hash;

    push @errors, { id => "fascicle", msg => "Can't find object"}
        unless ($fascicle->{id});

    unless (@errors) {
        foreach my $item (@i_pages) {
            my ($id, $seqnum) = split "::", $item;

            my $page    = $c->sql->Q(" SELECT * FROM fascicles_pages WHERE id=? AND seqnum=? ", [ $id, $seqnum ])->Hash;
            next unless ($page->{id});

            $c->sql->bt;

            my $modules = $c->sql->Q(" SELECT module FROM fascicles_map_modules WHERE page=?", [ $page->{id} ])->Values;

            foreach my $id (@$modules) {
                $c->sql->Do(" DELETE FROM fascicles_modules WHERE id=? ", [ $id ]);
            }

            $c->sql->Do(" DELETE FROM fascicles_pages WHERE id=? ", [ $page->{id} ]);

            $c->sql->et;
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

1;
