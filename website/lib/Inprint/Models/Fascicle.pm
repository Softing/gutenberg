package Inprint::Models::Fascicle;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

sub create {

    my ($c, $id,
        $edition, $template,
        $shortcut, $description,
        $num, $anum, $circulation,
        $print_date, $release_date,
        $adv_date, $doc_date,
        $adv_enabled, $doc_enabled ) = @_;

    my $variation = $c->uuid;

    $c->Do("
        INSERT INTO fascicles(
            id,
            edition, parent,
            fastype, variation,
            shortcut, description,
            circulation, num, anum, manager, enabled, archived,
            doc_enabled, adv_enabled, doc_date, adv_date, print_date, release_date, created, updated)
        VALUES (
            ?,
            ?, ?,
            'issue', ?,
            ?, ?,
            ?, ?, ?, null, true, false, ?, ?, ?, ?, ?, ?, now(), now());

    ", [ $id, $edition, $edition, $variation, $shortcut, $description,
        $circulation, $num, $anum,
        $doc_enabled, $adv_enabled, $doc_date, $adv_date, $print_date, $release_date ]);

    return $id;
}

sub read {
    my $c = shift;
    my $id = shift;

    my $result = $c->Q("
        SELECT
            id, edition, parent, fastype, variation,
            shortcut, description,
            circulation, num, anum,
            manager,
            enabled, archived,
            doc_enabled, adv_enabled,

            to_char(doc_date,     'YYYY-MM-DD HH24:MI:SS') as doc_date,
            to_char(adv_date,     'YYYY-MM-DD HH24:MI:SS') as adv_date,
            to_char(print_date,   'YYYY-MM-DD HH24:MI:SS') as print_date,
            to_char(release_date, 'YYYY-MM-DD HH24:MI:SS') as release_date,

            to_char(created, 'YYYY-MM-DD HH24:MI:SS') as created,
            to_char(updated, 'YYYY-MM-DD HH24:MI:SS') as updated
        FROM fascicles
        WHERE id=?
    ", [ $id ])->Hash;

    return $result;
}

sub update {

    my ($c, $id,
        $shortcut, $description,
        $num, $anum, $circulation,
        $print_date, $release_date,
        $adv_date, $doc_date,
        $adv_enabled, $doc_enabled ) = @_;

    $c->Do("
        UPDATE fascicles
            SET shortcut =?, description =?,
                num =?, anum =?, circulation =?,
                print_date =?, release_date =?,
                adv_date =?,  doc_date =?,
                adv_enabled =?, doc_enabled =?
        WHERE id =?;
    ", [    $shortcut, $description,
            $num, $anum, $circulation,
            $print_date, $release_date,
            $adv_date, $doc_date,
            $adv_enabled, $doc_enabled,
        $id ]);

    $c->Do("
        UPDATE fascicles
            SET
                num =?, anum =?,
                print_date =?, release_date =?,
                adv_date =?,  doc_date =?,
                adv_enabled =?, doc_enabled =?
        WHERE 1=1
            AND fastype = 'attachment'
            AND parent =?;
    ", [
            $num, $anum,
            $print_date, $release_date,
            $adv_date, $doc_date,
            $adv_enabled, $doc_enabled,
        $id ]);

    return $c;
}

sub remove {
    my ($c, $id) = @_;

    $c->Do(" UPDATE fascicles SET deleted = true WHERE id=? ", [ $id ]);
    $c->Do(" UPDATE fascicles SET deleted = true WHERE parent=? ", [ $id ]);

    return $c;
}

sub enable {
    my ($c, $id) = @_;
    $c->Do(" UPDATE fascicles SET enabled = true WHERE id=? ", [ $id ]);
    return $c;
}
sub disable {
    my ($c, $id) = @_;
    $c->Do(" UPDATE fascicles SET enabled = false WHERE id=? ", [ $id ]);
    return $c;
}

sub archive {
    my ($c, $id) = @_;

    $c->txBegin;

    my $fascicles = $c->Q(" SELECT id FROM fascicles WHERE parent=\$1 OR id=\$1 ", $id)->Values;

    $c->Do("
        UPDATE fascicles SET
            archived = true,
            enabled = false
        WHERE id= ANY(?) ", [ $fascicles ]);

    # Move linked documents to Archive
    $c->Do("
        UPDATE documents SET
            isopen=false
        WHERE 1=1
            AND fascicle = ANY(\$1)
            AND EXISTS(
                SELECT true
                FROM fascicles_map_documents as fasmap
                WHERE 1=1
                    AND fasmap.fascicle=documents.fascicle
                    AND fasmap.entity = documents.id)", [ $fascicles ]);

    # Move unlinked documents to Briefcase
    $c->Do("
        UPDATE documents SET
            isopen=true,
            fascicle = \$1,
            fascicle_shortcut = \$2
        WHERE 1=1
            AND fascicle = ANY(\$3)
            AND NOT EXISTS(
                SELECT true
                FROM fascicles_map_documents as fasmap
                WHERE 1=1
                    AND fasmap.fascicle=documents.fascicle
                    AND fasmap.entity = documents.id)",
        [ '00000000-0000-0000-0000-000000000000', $c->l("Briefcase"), $fascicles ]);

    $c->txCommit;

    return $c;
}

sub unarchive {
    my ($c, $id) = @_;

    $c->txBegin;

    my $fascicles = $c->Q(" SELECT id FROM fascicles WHERE parent=\$1 OR id=\$1 ", $id)->Values;

    $c->Do("
        UPDATE fascicles SET
            archived = false,
            enabled = true
        WHERE id= ANY(?) ", [ $fascicles ]);

    # Move linked documents to Archive
    $c->Do("
        UPDATE documents SET
            isopen=true
        WHERE 1=1
            AND fascicle = ANY(\$1)", [ $fascicles ]);

    $c->txCommit;

    return $c;
}

1;
