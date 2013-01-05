package Inprint::Calendar::Attachment;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Attachment;
use Inprint::Calendar::Copy;
use Inprint::Calendar::CopyAttachment;

use base 'Mojolicious::Controller';

sub read {
    my $c = shift;

    my $result;
    my @errors;

    my $i_id           = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        $result = Inprint::Models::Attachment::read($c, $i_id);
    }

    $c->smart_render(\@errors, $result);
}


sub list {

    my $c = shift;

    my @errors;
    my @params;

    my $i_edition = $c->param("edition") || undef;
    my $i_issue = $c->param("issue") || undef;

    my $i_fastype = $c->param("fastype") || "issue";
    my $i_archive = $c->param("archive") || "false";

    my $edition  = $c->Q("SELECT * FROM editions WHERE id=?", [ $i_edition ])->Hash;
    my $issue    = $c->Q("SELECT * FROM fascicles WHERE id=?", [ $i_issue ])->Hash;

    my $editions = $c->objectBindings("editions.documents.work:*");

    my $bindings = $c->objectBindings([ "editions.attachment.view:*", "editions.attachment.manage:*" ]);

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
            fascicles t1,
            editions t2
        WHERE 1=1
            AND t1.deleted = false
            AND t2.id=t1.edition
    ";

    $sql .= " AND t1.edition = ANY(?) ";
    push @params, $bindings;

    $sql .= " AND t1.parent = ? ";
    push @params, $issue->{id};

    $sql .= " AND t1.edition = ANY(?) ";
    push @params, $c->objectBindings([ "editions.attachment.view:*", "editions.attachment.manage:*" ]);

    $sql .= " AND t1.archived = true "      if ($i_archive eq "true");
    $sql .= " AND t1.archived = false "     if ($i_archive eq "false");

    $sql .= " ORDER BY t2.shortcut ASC, t1.shortcut ASC ";

    my $result = $c->Q($sql, \@params)->Hashes;

    $c->smart_render(\@errors, $result);
}

sub create {
    my $c = shift;

    my @errors;

    my $i_parent       = $c->get_uuid(\@errors, "parent");
    my $i_edition      = $c->get_uuid(\@errors, "edition");
    my $i_template     = $c->get_uuid(\@errors, "template");
    my $i_circulation  = $c->get_int(\@errors, "circulation", 1) || 0;

    my $edition  = $c->check_record(\@errors, "editions",  "edition", $i_edition);
    my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", $i_parent);
    my $template = $c->check_record(\@errors, "template",  "template", $i_template);

    unless (@errors) {
        my $exists = $c->Q("
            SELECT * 
            FROM fascicles 
            WHERE 1=1
                AND edition = ?
                AND parent  = ? 
                AND deleted = false", [$i_edition, $i_parent])->Hash;

	#die "$i_edition, $i_parent";

        if (exists $exists->{id}) {
            return $c->throw("edition", "This object already exists in databse");
        }
    }
    
    unless (@errors) {

        my $id = $c->uuid;
        
        my $adv_modules = $template->{adv_modules} // $fascicle->{adv_modules};

        Inprint::Models::Attachment::create(
            $c, $id,
            $edition->{id}, $fascicle->{id},
            $fascicle->{shortcut}, $fascicle->{description},
            $template->{id}, $template->{shortcut},
            $i_circulation, $fascicle->{num}, $fascicle->{anum},
            $fascicle->{doc_date}, $fascicle->{adv_date}, $adv_modules,
            $fascicle->{print_date}, $fascicle->{release_date}
        );

        if ($i_template && $i_template eq "00000000-0000-0000-0000-000000000000") {
            Inprint::Calendar::Copy::copyFromDefaults($c, $id);
        }

        if ($i_template && $i_template ne "00000000-0000-0000-0000-000000000000") {
            Inprint::Calendar::Copy::copyFromTemplate($c, $id, $i_template);
        }

    }

    $c->smart_render(\@errors);
}

sub update {
    my $c = shift;

    my @errors;

    my $i_id           = $c->get_uuid(\@errors, "id");

    my $i_shortcut     = $c->get_text(\@errors, "shortcut", 1);

    my $i_circulation  = $c->get_int(\@errors, "circulation", 1) || 0;

    unless (@errors) {
        Inprint::Models::Attachment::update(
            $c, $i_id,
            $i_shortcut,
            $i_circulation
        );
    }

    $c->smart_render(\@errors);
}

sub restrictions {
    my $c = shift;

    my @errors;

    my $i_id           = $c->get_uuid(\@errors, "id");

    my $i_adv_date     = $c->get_datetime(\@errors, "adv_date", 1);
    my $i_adv_modules  = $c->get_float(\@errors, "adv_modules", 1);
    my $i_doc_date     = $c->get_datetime(\@errors, "doc_date", 1);

    unless (@errors) {
        Inprint::Models::Attachment::restrictions(
            $c, $i_id,
            $i_adv_date, $i_adv_modules, $i_doc_date);
    }

    $c->smart_render(\@errors);
}



sub remove {
    my $c = shift;

    my @errors;

    my $i_id = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        Inprint::Models::Attachment::remove($c, $i_id);
    }

    $c->smart_render(\@errors);
}



sub copy {
    my $c = shift;

    my @errors;

    my $i_source       = $c->get_uuid(\@errors, "source");
    my $i_issue        = $c->get_uuid(\@errors, "issue");
    my $i_edition      = $c->get_uuid(\@errors, "edition");
    my $i_confirmation = $c->get_text(\@errors, "confirmation");

    my $source = $c->Q(" SELECT * FROM fascicles WHERE id=? ", $i_source)->Hash;
    push @errors, { id => "Error", msg => "Can't copy 1"}
        if ($source->{fastype} ne "attachment");

    my $issue = $c->Q(" SELECT * FROM fascicles WHERE id=? ", $i_issue)->Hash;
    push @errors, { id => "Error", msg => "Can't copy 2"}
        if ($issue->{fastype} ne "issue");

    push @errors, { id => "confirmation", msg => "Incorrectly filled field"}
        unless ( $i_confirmation eq "on" );

    unless (@errors) {
        Inprint::Calendar::CopyAttachment::copy($c, 1, $i_source, $i_issue, $i_edition, 1, 1, 1);
    }

    $c->smart_render(\@errors);
}

1;
