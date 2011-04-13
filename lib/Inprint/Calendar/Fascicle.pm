package Inprint::Calendar::Fascicle;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Calendar::Copy;
use Inprint::Models::Fascicle;

use base 'Mojolicious::Controller';

sub read {
    my $c = shift;

    my $result;
    my @errors;

    my $i_id           = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        $result = Inprint::Models::Fascicle::read($c, $i_id);
    }

    $c->smart_render(\@errors, $result);
}

sub create {
    my $c = shift;

    my @errors;

    my $i_edition      = $c->get_uuid(\@errors, "edition");
    my $i_template     = $c->get_uuid(\@errors, "template");

    my $i_shortcut     = $c->get_text(\@errors, "shortcut", 1);
    my $i_description  = $c->get_text(\@errors, "description", 1) || "";

    my $i_num          = $c->get_int(\@errors, "num", 1) || 0;
    my $i_anum         = $c->get_int(\@errors, "anum", 1) || 0;

    my $i_circulation  = $c->get_int(\@errors, "circulation", 1) || 0;

    my $i_print_date   = $c->get_date(\@errors, "print_date", 1);
    my $i_release_date = $c->get_date(\@errors, "release_date", 1);

    my $i_adv_date     = $c->get_datetime(\@errors, "adv_date", 1);
    my $i_doc_date     = $c->get_datetime(\@errors, "doc_date", 1);

    my $i_adv_enabled  = $c->get_flag(\@errors, "adv_enabled", 1) || 0;
    my $i_doc_enabled  = $c->get_flag(\@errors, "doc_enabled", 1) || 0;

    unless (@errors) {

        my $id = $c->uuid;

        $c->txBegin();

        Inprint::Models::Fascicle::create(
            $c, $id,
            $i_edition, $i_template,
            $i_shortcut, $i_description,
            $i_num, $i_anum, $i_circulation,
            $i_print_date, $i_release_date,
            $i_adv_date, $i_doc_date,
            $i_adv_enabled, $i_doc_enabled);

        if ($i_template eq "00000000-0000-0000-0000-000000000000") {
            Inprint::Calendar::Copy::copyFromDefaults($c, $id);
        }

        $c->txCommit();

    }

    $c->smart_render(\@errors);
}

sub update {
    my $c = shift;

    my @errors;

    my $i_id           = $c->get_uuid(\@errors, "id");

    my $i_shortcut     = $c->get_text(\@errors, "shortcut", 1);
    my $i_description  = $c->get_text(\@errors, "description", 1) || "";

    my $i_num          = $c->get_int(\@errors, "num", 1) || 0;
    my $i_anum         = $c->get_int(\@errors, "anum", 1) || 0;

    my $i_circulation  = $c->get_int(\@errors, "circulation", 1) || 0;

    my $i_print_date   = $c->get_date(\@errors, "print_date", 1);
    my $i_release_date = $c->get_date(\@errors, "release_date", 1);

    my $i_adv_date     = $c->get_datetime(\@errors, "adv_date", 1);
    my $i_doc_date     = $c->get_datetime(\@errors, "doc_date", 1);

    my $i_adv_enabled  = $c->get_flag(\@errors, "adv_enabled", 1) || 0;
    my $i_doc_enabled  = $c->get_flag(\@errors, "doc_enabled", 1) || 0;

    unless (@errors) {
        Inprint::Models::Fascicle::update(
            $c, $i_id, $i_shortcut, $i_description,
            $i_num, $i_anum, $i_circulation,
            $i_print_date, $i_release_date,
            $i_adv_date, $i_doc_date,
            $i_adv_enabled, $i_doc_enabled);
    }

    $c->smart_render(\@errors);
}

sub template {

    my $c = shift;

    my @errors;

    my $i_id = $c->get_uuid(\@errors, "id");

    my $template_id = $c->uuid();

    my $source = $c->check_record(\@errors, "fascicles", "fascicle", $i_id);

    Inprint::Calendar::Copy::copyFascicle($c, $source->{id}, $template_id, {
        fastype => "template"
    });

    my $destination = $c->check_record(\@errors, "fascicles", "fascicle", $template_id);

    my $attachments = $c->Q(" SELECT id FROM fascicles WHERE parent=? ", $source->{id})->Values;
    foreach my $id (@$attachments) {

        my $attachment_id = $c->uuid();

        Inprint::Calendar::Copy::copyFascicle($c, $id, $attachment_id, {
            parent => $destination->{id}
        });

    }

    $c->smart_render(\@errors);
}

sub deadline {
    my $c = shift;

    my @errors;

    my $i_id           = $c->get_uuid(\@errors, "id");

    my $i_print_date   = $c->get_date(\@errors, "print_date", 1);
    my $i_release_date = $c->get_date(\@errors, "release_date", 1);

    my $i_adv_date     = $c->get_datetime(\@errors, "adv_date", 1);
    my $i_doc_date     = $c->get_datetime(\@errors, "doc_date", 1);

    my $i_adv_enabled  = $c->get_flag(\@errors, "adv_enabled", 1) || 0;
    my $i_doc_enabled  = $c->get_flag(\@errors, "doc_enabled", 1) || 0;

    unless (@errors) {
        Inprint::Models::Fascicle::deadline(
            $c, $i_id,
            $i_print_date, $i_release_date,
            $i_adv_date, $i_doc_date,
            $i_adv_enabled, $i_doc_enabled);
    }

    $c->smart_render(\@errors);
}

sub remove {
    my $c = shift;

    my @errors;

    my $i_id           = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        Inprint::Models::Fascicle::remove($c, $i_id);
    }

    $c->smart_render(\@errors);
}

sub archive {
    my $c = shift;

    my @errors;

    my $i_id           = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        Inprint::Models::Fascicle::archive($c, $i_id);
    }

    $c->smart_render(\@errors);
}

sub unarchive {
    my $c = shift;

    my @errors;

    my $i_id           = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        Inprint::Models::Fascicle::unarchive($c, $i_id);
    }

    $c->smart_render(\@errors);
}

sub enable {
    my $c = shift;

    my $result;
    my @errors;

    my $i_id           = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        $result = Inprint::Models::Fascicle::enable($c, $i_id);
    }

    $c->smart_render(\@errors, $result);
}

sub disable {
    my $c = shift;

    my $result;
    my @errors;

    my $i_id           = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        $result = Inprint::Models::Fascicle::disable($c, $i_id);
    }

    $c->smart_render(\@errors, $result);
}

1;
