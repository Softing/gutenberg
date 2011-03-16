package Inprint::Documents::Profile;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

use Inprint::Store::Embedded;

sub read {

    my $c = shift;

    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    my $document;
    unless (@errors) {

        $document = $c->sql->Q("
            SELECT
                dcm.id,
                dcm.edition, dcm.edition_shortcut,
                dcm.fascicle, dcm.fascicle_shortcut,
                dcm.headline, dcm.headline_shortcut,
                dcm.rubric, dcm.rubric_shortcut,
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
                to_char(dcm.updated, 'YYYY-MM-DD HH24:MI:SS') as updated
            FROM documents dcm WHERE dcm.id=?
        ", [ $i_id ])->Hash;

        $document->{access} = {};
        my $current_member = $c->QuerySessionGet("member.id");

        if ($document->{holder} eq $current_member) {
            $c->sql->Do("UPDATE documents SET islooked=true WHERE id=?", $document->{id});
        }

        # Get document rules
        my @rules = qw(
           documents.update
           documents.capture
           documents.move
           documents.transfer
           documents.briefcase
           documents.delete
           documents.recover
           documents.discuss
           files.add
           files.delete
           files.work
        );

        foreach (@rules) {

            if ($document->{holder} eq $current_member) {
                if ($c->access->Check(["catalog.$_:*"], $document->{workgroup})) {
                    $document->{access}->{$_} = $c->json->true;
                } else {
                    $document->{access}->{$_} = $c->json->false;
                }
            }

            if ($document->{holder} ne $current_member) {
                if ($c->access->Check("catalog.$_:group", $document->{workgroup})) {
                    $document->{access}->{$_} = $c->json->true;
                } else {
                    $document->{access}->{$_} = $c->json->false;
                }
            }

        }

    }

    unless (@errors) {
        my $relativePath = Inprint::Store::Embedded::getRelativePath($c, "documents", $document->{created}, $document->{id}, 1);

        # Update images count
        my @images = ("jpg", "jpeg", "png", "gif", "bmp", "tiff" );
        my $imgCount = $c->sql->Q(" SELECT count(*) FROM cache_files WHERE file_path=? AND file_exists = true AND file_extension=ANY(?) ", [ $relativePath, \@images ])->Value;
        $c->sql->Do("UPDATE documents SET images=? WHERE filepath=? ", [ $imgCount || 0, $relativePath ]);

        # Update rsize count
        my @documents = ("doc", "docx", "odt", "rtf", "txt" );
        my $lengthCount = $c->sql->Q(" SELECT sum(file_length) FROM cache_files WHERE file_path=? AND file_exists = true AND file_extension=ANY(?) ", [ $relativePath, \@documents ])->Value;
        $c->sql->Do("UPDATE documents SET rsize=? WHERE filepath=? ", [ $lengthCount || 0, $relativePath ]);
    }

    # Get history
    unless (@errors) {
        $document->{history} = $c->sql->Q("
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
        $document->{fascicles} = $c->sql->Q("
            SELECT
                dcm.edition,  dcm.edition_shortcut,
                dcm.fascicle, dcm.fascicle_shortcut,
                dcm.headline, dcm.headline_shortcut,
                dcm.rubric, dcm.rubric_shortcut
            FROM documents dcm WHERE dcm.copygroup=?
            ORDER BY edition_shortcut, fascicle_shortcut
        ", [ $document->{copygroup} ])->Hashes;
    }

    # Get comments
    unless (@errors) {
        $document->{comments} = $c->sql->Q("
            SELECT
                id, entity, path,
                member, member_shortcut,
                stage, stage_shortcut, stage_color,
                fulltext, to_char(created, 'YYYY-MM-DD HH24:MI:SS') as created
            FROM comments WHERE entity = ? ORDER BY created DESC
        ", [ $document->{id} ])->Hashes;
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $document || {} });
}

1;
