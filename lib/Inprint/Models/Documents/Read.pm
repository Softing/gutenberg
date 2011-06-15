package Inprint::Models::Documents;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

sub read {

    my ($c, $id) = @_;

    my $document = $c->Q("
        SELECT
            dcm.id,
            dcm.edition, dcm.edition_shortcut,
            dcm.fascicle, dcm.fascicle_shortcut,
            dcm.headline, dcm.headline_shortcut,
            dcm.rubric, dcm.rubric_shortcut,
            dcm.maingroup, dcm.maingroup_shortcut,
            dcm.workgroup, dcm.workgroup_shortcut,
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
            to_char(dcm.updated, 'YYYY-MM-DD HH24:MI:SS') as updated,
            to_char(dcm.uploaded, 'YYYY-MM-DD HH24:MI:SS') as uploaded,
            to_char(dcm.moved, 'YYYY-MM-DD HH24:MI:SS') as moved
        FROM documents dcm
        WHERE dcm.id=?
    ", [ $id ])->Hash;

    $document->{access} = {};
    my $current_member = $c->getSessionValue("member.id");

    my @rules = qw(
        documents.update documents.capture documents.move documents.transfer
        documents.briefcase documents.delete documents.recover documents.discuss
        files.add files.delete files.work
    );
    foreach (@rules) {

        if ($document->{holder} eq $current_member) {
            if ($c->objectAccess(["catalog.$_:member"], $document->{workgroup})) {
                $document->{access}->{$_} = $c->json->true;
            }
        }

        if ($document->{holder} ne $current_member) {
            if ($c->objectAccess("catalog.$_:group", $document->{workgroup})) {
                $document->{access}->{$_} = $c->json->true;
            }
        }

        if ($_ eq 'documents.capture' && $document->{holder} eq $current_member) {
            $document->{access}->{$_} = $c->json->false;
        }

        if ($_ eq 'documents.briefcase' && $document->{fascicle} eq '00000000-0000-0000-0000-000000000000') {
            $document->{access}->{$_} = $c->json->false;
        }
    }

    return $document;
}

1;
