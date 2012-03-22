package Inprint::Documents::Profile;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Mojolicious::Controller';

use Inprint::Store::Embedded;
use Inprint::Documents::Access;

sub read {

    my $c = shift;

    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    my $document;
    unless (@errors) {

        $document = $c->Q("
            SELECT
                dcm.id,
                dcm.edition, dcm.edition_shortcut,
                dcm.fascicle, dcm.fascicle_shortcut,
                dcm.headline, dcm.headline_shortcut,
                dcm.rubric, dcm.rubric_shortcut,
                dcm.workgroup, dcm.workgroup_shortcut,
                dcm.maingroup, dcm.maingroup_shortcut,
                dcm.inworkgroups, dcm.copygroup,
                dcm.holder,  dcm.holder_shortcut,
                dcm.creator, dcm.creator_shortcut,
                dcm.manager, dcm.manager_shortcut,
                dcm.islooked, dcm.isopen,
                dcm.branch, dcm.branch_shortcut,
                dcm.stage, stage_shortcut,
                dcm.color, dcm.progress,
                dcm.title, dcm.author,
                to_char(dcm.pdate, 'YYYY-MM-DD HH24:MI:SS') as pdate,
                to_char(dcm.fdate, 'YYYY-MM-DD HH24:MI:SS') as fdate,
                to_char(dcm.ldate, 'YYYY-MM-DD HH24:MI:SS') as ldate,
                dcm.psize, dcm.rsize,
                dcm.images, dcm.files,
                to_char(dcm.created, 'YYYY-MM-DD HH24:MI:SS') as created,
                to_char(dcm.updated, 'YYYY-MM-DD HH24:MI:SS') as updated
            FROM documents dcm WHERE dcm.id=?
        ", [ $i_id ])->Hash;

        $document->{access} = {};
        my $current_member = $c->getSessionValue("member.id");

        if ($document->{holder} eq $current_member) {
            $c->Do("UPDATE documents SET islooked=true WHERE id=?", $document->{id});
        }

        $document->{access} = Inprint::Documents::Access::get($c, $document->{id});

    }

    # Get history
    unless (@errors) {
        $document->{history} = $c->Q("
            SELECT
                id, entity, operation, color, weight,
                branch, branch_shortcut, stage, stage_shortcut,
                destination, destination_shortcut, destination_catalog, destination_catalog_shortcut,
                to_char(created, 'YYYY-MM-DD HH24:MI:SS') as created
            FROM history WHERE entity=? ORDER BY created
        ", [ $document->{id} ])->Hashes;
    }

    # Get co-documents
    unless (@errors) {
        $document->{fascicles} = $c->Q("
            SELECT
                dcm.edition,  dcm.edition_shortcut,
                dcm.fascicle, dcm.fascicle_shortcut,
                dcm.headline, dcm.headline_shortcut,
                dcm.rubric, dcm.rubric_shortcut
            FROM documents dcm
            WHERE 1=1
                AND dcm.copygroup=?
                AND dcm.fascicle <> '99999999-9999-9999-9999-999999999999'
            ORDER BY edition_shortcut, fascicle_shortcut
        ", [ $document->{copygroup} ])->Hashes;
    }


    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $document || {} });
}

1;
