package Inprint::Models::Attachment;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

sub create {

    my ( $c, $edition, $fascicle, $template, $circulation ) = @_;

    my $id = $c->uuid;
    my $variation = $c->uuid;

    if ($template->{id} eq "00000000-0000-0000-0000-000000000000") {
        $template->{shortcut} = $c->l("Default");
    }

    if ($fascicle->{id}) {
        $c->Do("
            INSERT INTO fascicles(
                id,
                edition, parent,
                tmpl, tmpl_shortcut,
                fastype, variation,
                shortcut, description,
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
            $edition->{id},          $fascicle->{id},
            $template->{id},         $template->{shortcut},
            "attachment",            $variation,
            $fascicle->{shortcut},   $fascicle->{description},
            $circulation,            $fascicle->{num},          $fascicle->{anum},
            $fascicle->{doc_date},   $fascicle->{adv_date},
            $fascicle->{print_date}, $fascicle->{release_date} ]);
    }

    return $c;
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

    return $c;
}

sub remove {
    my ($c, $id) = @_;
    $c->Do(" UPDATE fascicles SET deleted = true WHERE id=? ", [ $id ]);
    return $c;
}

1;
