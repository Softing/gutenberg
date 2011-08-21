package Inprint::Models::Attachment;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

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

sub create {

    my ( $c, $id,
        $edition, $parent,
        $shortcut, $description,
        $template, $template_shortcut,
        $circulation, $num, $anum,
        $doc_date, $adv_date,
        $print_date, $release_date ) = @_;

    my $variation = $c->uuid;

    if ($template eq "00000000-0000-0000-0000-000000000000") {
        $template_shortcut = $c->l("Default");
    }

    $c->Do("
        INSERT INTO fascicles(
            id,
            edition, parent,
            shortcut, description,
            fastype, variation,
            tmpl, tmpl_shortcut,
            circulation, num, anum,
            manager, enabled, archived,
            doc_enabled, adv_enabled,
            doc_date, adv_date,
            print_date, release_date,
            created, updated)
        VALUES (
            ?,
            ?, ?,
            ?, ?,
            ?, ?,
            ?, ?,
            ?, ?, ?,
            null, true, false,
            false, false,
            ?, ?,
            ?, ?,
            now(), now());

    ", [ $id,
        $edition, $parent,
        $shortcut, $description,
        "attachment", $variation,
        $template, $template_shortcut,
        $circulation, $num, $anum,
        $doc_date,   $adv_date,
        $print_date, $release_date ]);


    return $id;
}

sub update {

    #my ($c, $id,
    #    $shortcut, $description,
    #    $num, $anum, $circulation,
    #    $print_date, $release_date,
    #    $adv_date, $doc_date,
    #    $adv_enabled, $doc_enabled ) = @_;
    #
    #$c->Do("
    #    UPDATE fascicles
    #        SET shortcut =?, description =?,
    #            num =?, anum =?, circulation =?,
    #            print_date =?, release_date =?,
    #            adv_date =?,  doc_date =?,
    #            adv_enabled =?, doc_enabled =?
    #    WHERE id =?;
    #", [    $shortcut, $description,
    #        $num, $anum, $circulation,
    #        $print_date, $release_date,
    #        $adv_date, $doc_date,
    #        $adv_enabled, $doc_enabled,
    #    $id ]);

    my ($c, $id,
        $circulation,
        $adv_date, $doc_date,
        $adv_enabled, $doc_enabled ) = @_;

    $c->Do("
        UPDATE fascicles
            SET
                circulation =?,
                adv_date =?,  doc_date =?,
                adv_enabled =?, doc_enabled =?
        WHERE id =?;
    ", [    $circulation,
            $adv_date, $doc_date,
            $adv_enabled, $doc_enabled,
        $id ]);

    return $c;
}

sub remove {
    my ($c, $id) = @_;
    $c->Do(" UPDATE fascicles SET deleted = true WHERE id=? ", [ $id ]);
    return $c;
}

1;
