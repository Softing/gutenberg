package Inprint::Calendar::Fascicle;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Database;
use Inprint::Calendar::Copy;
use Inprint::Calendar::CopyAttachment;

use Inprint::Models::Fascicle;
use Inprint::Models::Attachment;

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

sub list {

    my $c = shift;

    my @errors;
    my @params;

    my $i_edition = $c->param("edition") || undef;

    my $i_fastype = $c->param("fastype") || "issue";
    my $i_archive = $c->param("archive") || "false";

    my $edition  = $c->Q("SELECT * FROM editions WHERE id=?", [ $i_edition ])->Hash;

    # Common sql
    my $sql = "
        SELECT

            t1.id,
            t2.id as edition,
            t2.shortcut as edition_shortcut,
            t1.parent,
            t1.fastype,
            t1.variation,
            t1.shortcut,
            t1.description,
            t1.tmpl,
            t1.tmpl_shortcut,
            t1.circulation,
            t1.num,
            t1.anum,
            t1.manager,
            t1.enabled,
            t1.archived,
            t1.doc_enabled,
            t1.adv_enabled,
            t1.adv_modules,

            to_char(t1.doc_date, 'YYYY-MM-DD HH24:MI:SS')       as doc_date,
            to_char(t1.adv_date, 'YYYY-MM-DD HH24:MI:SS')       as adv_date,
            to_char(t1.print_date, 'YYYY-MM-DD HH24:MI:SS')     as print_date,
            to_char(t1.release_date, 'YYYY-MM-DD HH24:MI:SS')   as release_date,

            to_char(t1.created, 'YYYY-MM-DD HH24:MI:SS')        as created,
            to_char(t1.updated, 'YYYY-MM-DD HH24:MI:SS')        as updated

        FROM
            fascicles t1, editions t2
        WHERE 1=1
            AND t1.deleted = false
            AND t2.id=t1.edition
    ";

    #$sql .= " AND t1.edition = ANY(?) ";
    #push @params, $c->objectChildren("editions", $edition->{id}, [ "editions.fascicle.view:*", "editions.fascicle.manage:*" ]);

    $sql .= " AND t1.edition = ANY(?) ";
    push @params, $c->objectBindings([ "editions.fascicle.view:*", "editions.fascicle.manage:*" ]);

    $sql .= " AND t1.archived = true "      if ($i_archive eq "true");
    $sql .= " AND t1.archived = false "     if ($i_archive eq "false");

    $sql .= " AND t1.fastype = 'issue' "    if ($i_fastype eq "issue");

    $sql .= " ORDER BY t1.release_date DESC, t2.shortcut ASC, t1.shortcut ASC ";

    my $result = $c->Q($sql, \@params)->Hashes;

    $c->smart_render(\@errors, $result);
}

sub create {

    my $c = shift;

    my @errors;

    my $i_edition      = $c->get_uuid(\@errors, "edition");
    my $i_copyfrom     = $c->get_uuid(\@errors, "copyfrom");

    my $i_shortcut     = $c->get_text(\@errors, "shortcut", 1);
    my $i_description  = $c->get_text(\@errors, "description", 1) || "";

    my $i_num          = $c->get_int(\@errors, "num", 1) || 0;
    my $i_anum         = $c->get_int(\@errors, "anum", 1) || 0;

    my $i_circulation  = $c->get_int(\@errors, "circulation", 1) || 0;

    my $i_print_date   = $c->get_date(\@errors, "print_date", 1);
    my $i_release_date = $c->get_date(\@errors, "release_date", 1);

    my $i_adv_date     = $c->get_datetime(\@errors, "adv_date", 1);
    my $i_adv_modules  = $c->get_float(\@errors, "adv_modules", 1);
    my $i_doc_date     = $c->get_datetime(\@errors, "doc_date", 1);

    my $i_adv_enabled  = $c->get_flag(\@errors, "adv_enabled", 1) || 0;
    my $i_doc_enabled  = $c->get_flag(\@errors, "doc_enabled", 1) || 0;

    my $edition  = $c->check_record(\@errors, "editions", "edition", $i_edition);

    unless (@errors) {

        my $issue_id = $c->uuid;

        $c->txBegin();

        # Create issue
        Inprint::Models::Fascicle::create(
            $c, $issue_id,
            $i_edition, $i_copyfrom,
            $i_shortcut, $i_description,
            $i_num, $i_anum, $i_circulation,
            $i_print_date, $i_release_date,
            $i_adv_date, undef, $i_doc_date,
            $i_adv_enabled, $i_doc_enabled);

        # Copy default values
        if ($i_copyfrom && $i_copyfrom eq "00000000-0000-0000-0000-000000000000") {
            Inprint::Calendar::Copy::copyFromDefaults($c, $issue_id);
        }

        # Copy from fascicle
        if ($i_copyfrom && $i_copyfrom ne "00000000-0000-0000-0000-000000000000") {

            Inprint::Calendar::Copy::copyFromIssue($c, $issue_id, $i_copyfrom);

            # Create attachments
            my $attachments = $c->Q("
                SELECT * FROM fascicles
                WHERE 1=1
                    AND deleted = false
                    AND fastype = 'attachment'
                    AND parent=? ",
                [ $i_copyfrom ])->Hashes;

            foreach my $source_attachment (@$attachments) {

                my $attachment_new = Inprint::Calendar::CopyAttachment::copy($c, 0, $source_attachment->{id}, $issue_id, $source_attachment->{edition}, 0, 0, 0);

                $c->Do(" UPDATE fascicles SET circulation=0 WHERE id=?", $attachment_new);
                $c->Do(" UPDATE fascicles SET shortcut=? WHERE id=?", [ $i_shortcut, $attachment_new ]);
                $c->Do(" UPDATE fascicles SET adv_date=? WHERE id=?", [ $i_adv_date, $attachment_new ]);
                $c->Do(" UPDATE fascicles SET doc_date=? WHERE id=?", [ $i_doc_date, $attachment_new ]);
                $c->Do(" UPDATE fascicles SET print_date=? WHERE id=?", [ $i_print_date, $attachment_new ]);
                $c->Do(" UPDATE fascicles SET release_date=? WHERE id=?", [ $i_release_date, $attachment_new ]);

                my $template = $c->Q(" SELECT * FROM template WHERE id=? ", $source_attachment->{tmpl})->Hash();
                if ($template->{id}) {
                    Inprint::Calendar::Copy::copyFromTemplate($c, $attachment_new, $template->{id});
                }

            }

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
    my $i_adv_modules  = $c->get_float(\@errors, "adv_modules", 1);
    my $i_doc_date     = $c->get_datetime(\@errors, "doc_date", 1);

    my $i_adv_enabled  = $c->get_flag(\@errors, "adv_enabled", 1) || 0;
    my $i_doc_enabled  = $c->get_flag(\@errors, "doc_enabled", 1) || 0;

    unless (@errors) {
        Inprint::Models::Fascicle::update(
            $c, $i_id, $i_shortcut, $i_description,
            $i_num, $i_anum, $i_circulation,
            $i_print_date, $i_release_date,
            $i_adv_date, $i_adv_modules, $i_doc_date,
            $i_adv_enabled, $i_doc_enabled);
    }

    $c->smart_render(\@errors);
}

sub remove {
    my $c = shift;

    my @errors;

    my $i_id           = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        $c->Do(" UPDATE fascicles SET deleted = true WHERE id=? ", [ $i_id ]);
        $c->Do(" UPDATE fascicles SET deleted = true WHERE parent=? ", [ $i_id ]);
    }

    $c->smart_render(\@errors);
}

1;
