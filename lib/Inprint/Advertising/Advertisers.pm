package Inprint::Advertising::Advertisers;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Mojolicious::Controller';

sub read {
    my $c = shift;
    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    my $result = [];

    unless (@errors) {
        $result = $c->Q("
            SELECT t1.id, t2.id as edition, t2.shortcut as edition_shortcut, t1.serialnum, t1.title, t1.shortcut, t1.description, t1.address, t1.contact, t1.phones, t1.inn, t1.kpp, t1.bank, t1.rs, t1.ks, t1.bik, t1.created, t1.updated
            FROM ad_advertisers t1, editions t2 WHERE t2.id = t1.edition AND t1.id=?
        ", [ $i_id ])->Hash;
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub list {
    my $c = shift;

    my @data;
    my $total;
    my $result = [];

    my @errors;

    my $i_start     = $c->get_int (\@errors, "start", 1) || 0;
    my $i_limit     = $c->get_int (\@errors, "limit", 1) || 100;

    $c->fail_render(\@errors);

    unless (@errors) {

        my $editions = $c->objectBindings("editions.advert.manage:*");

        $total = $c->Q("
            SELECT count(*)
            FROM ad_advertisers t1, editions t2
            WHERE 1=1
                AND t2.id = t1.edition
                AND t1.edition = ANY(?)
        ", [ $editions ])->Value;

        $result = $c->Q("
            SELECT
                t1.id,
                t2.id as edition, t2.shortcut as edition_shortcut,
                t1.serialnum, t1.title, t1.shortcut, t1.description, t1.address,
                t1.contact, t1.phones, t1.inn, t1.kpp, t1.bank, t1.rs, t1.ks, t1.bik,
                t1.created, t1.updated
            FROM ad_advertisers t1, editions t2
            WHERE 1=1
                AND t2.id = t1.edition
                AND t1.edition= ANY(?)
            ORDER BY t2.shortcut, t1.shortcut
            LIMIT ? OFFSET ?
        ", [ $editions, $i_limit, $i_start ])->Hashes;

    }

    $c->smart_render( \@errors, $result, $total );
}

sub create {
    my $c = shift;

    my $id = $c->uuid();

    my @errors;

    my $i_edition     = $c->get_uuid(\@errors, "edition");
    my $i_shortcut    = $c->get_text(\@errors, "shortcut");
    my $i_contact     = $c->get_text(\@errors, "contact", 1);
    my $i_address     = $c->get_text(\@errors, "address", 1);
    my $i_phones      = $c->get_text(\@errors, "phones", 1);
    my $i_rs          = $c->get_text(\@errors, "rs", 1);
    my $i_bank        = $c->get_text(\@errors, "bank", 1);
    my $i_bik         = $c->get_text(\@errors, "bik", 1);
    my $i_inn         = $c->get_text(\@errors, "inn", 1);
    my $i_kpp         = $c->get_text(\@errors, "kpp", 1);
    my $i_ks          = $c->get_text(\@errors, "ks", 1);

    $c->fail_render(\@errors);

    my $edition = $c->check_record(\@errors, "editions", "edition", $i_edition);

    $c->fail_render(\@errors);

    $c->check_access(\@errors, "editions.advert.manage:*", $edition->{id});

    $c->fail_render(\@errors);

    unless (@errors) {
        $c->Do("
            INSERT INTO ad_advertisers(
                id, edition, shortcut,
                address, contact, phones,
                inn, kpp, bank, rs, ks, bik,
                created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [
            $id, $edition->{id}, $i_shortcut,
            $i_address, $i_contact, $i_phones,
            $i_inn, $i_kpp, $i_bank, $i_rs, $i_ks, $i_bik
        ]);
    }

    $c->smart_render(\@errors);
}

sub update {
    my $c = shift;

    my @errors;

    my $i_id          = $c->get_uuid(\@errors, "id");
    my $i_shortcut    = $c->get_text(\@errors, "shortcut");
    my $i_contact     = $c->get_text(\@errors, "contact", 1);
    my $i_address     = $c->get_text(\@errors, "address", 1);
    my $i_phones      = $c->get_text(\@errors, "phones", 1);
    my $i_rs          = $c->get_text(\@errors, "rs", 1);
    my $i_bank        = $c->get_text(\@errors, "bank", 1);
    my $i_bik         = $c->get_text(\@errors, "bik", 1);
    my $i_inn         = $c->get_text(\@errors, "inn", 1);
    my $i_kpp         = $c->get_text(\@errors, "kpp", 1);
    my $i_ks          = $c->get_text(\@errors, "ks", 1);

    my $record = $c->check_record(\@errors, "ad_advertisers", "record", $i_id);

    $c->fail_render(\@errors);

    $c->check_access(\@errors, "editions.advert.manage:*", $record->{edition});

    $c->fail_render(\@errors);

    unless (@errors) {
        $c->Do("
            UPDATE ad_advertisers SET
                shortcut=?,
                address=?, contact=?, phones=?,
                inn=?, kpp=?, bank=?, rs=?, ks=?, bik=?,
                updated=now()
            WHERE id =?;
        ", [
                $i_shortcut,
                $i_address, $i_contact, $i_phones,
                $i_inn, $i_kpp, $i_bank, $i_rs, $i_ks, $i_bik,
                $i_id
        ]);
    }

    $c->smart_render(\@errors);
}

sub delete {

    my $c = shift;
    my @ids = $c->param("id");

    my @errors;

    unless (@ids) {
        $c->check_uuid(\@errors, "id", $_);
    }

    $c->fail_render(\@errors);

    foreach my $id (@ids) {
        my $record = $c->Q(" SELECT id, edition FROM ad_advertisers WHERE id=? ", $id)->Hash;
        $c->check_uuid(\@errors, "record", $record->{id});
    }

    $c->fail_render(\@errors);

    foreach my $id (@ids) {
        $c->check_access(\@errors, "editions.advert.manage:*", $id);
    }

    $c->fail_render(\@errors);

    foreach my $id (@ids) {
            $c->Do(" DELETE FROM ad_advertisers WHERE id=? ", [ $id ]);
    }

    $c->smart_render(\@errors);
}


1;
