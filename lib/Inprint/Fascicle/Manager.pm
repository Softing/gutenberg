package Inprint::Fascicle::Manager;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

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


1;
