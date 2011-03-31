package Inprint::Calendar;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Utils::Documents;
use Inprint::Models::Fascicle;
use Inprint::Models::Fascicle::Template;
use Inprint::Models::Fascicle::Attachment;

use base 'Mojolicious::Controller';

sub tree {

    my $c = shift;

    my $i_node = $c->param("node");
    $i_node = '00000000-0000-0000-0000-000000000000' unless ($i_node);
    $i_node = '00000000-0000-0000-0000-000000000000' if ($i_node eq "root-node");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "id", $i_node);

    my @result;

    unless (@errors) {

        my $sql;
        my @data;

        my $bindings = $c->objectBindings(["editions.calendar.manage", "editions.calendar.work"]);

        if ($i_node eq "00000000-0000-0000-0000-000000000000") {
            $sql = "
                SELECT t1.*,
                    ( SELECT count(*) FROM editions c2 WHERE c2.path ~ ('*.' || t1.path::text || '.*{1}')::lquery ) as have_childs
                FROM editions t1
                WHERE
                    t1.id <> '00000000-0000-0000-0000-000000000000'
                    AND t1.id = ANY(?)
            ";
            push @data, $bindings;
        }

        if ($i_node ne "00000000-0000-0000-0000-000000000000") {
            $sql .= "
                SELECT t1.*,
                    ( SELECT count(*) FROM editions c2 WHERE c2.path ~ ('*.' || t1.path::text || '.*{1}')::lquery ) as have_childs
                FROM editions t1
                WHERE
                    t1.id <> '00000000-0000-0000-0000-000000000000'
                    AND subpath(t1.path, nlevel(t1.path) - 2, 1)::text = replace(?, '-', '')::text
                    AND t1.id = ANY(?)
                ";
            push @data, $i_node;
            push @data, $bindings;
        }

        my $data = $c->Q("$sql ORDER BY shortcut", \@data)->Hashes;

        foreach my $item (@$data) {
            my $record = {
                id   => $item->{id},
                text => $item->{shortcut},
                leaf => $c->json->true,
                icon => "blue-folders",
                data => $item
            };
            if ( $item->{have_childs} ) {
                $record->{leaf} = $c->json->false;
            }
            push @result, $record;
        }
    }

    $success = $c->json->true unless (@errors);

    $c->render_json( \@result );
}

sub list {

    my $c = shift;

    my @params;

    my $i_edition = $c->param("edition") || undef;
    my $i_fastype = $c->param("fastype") || "issue";
    my $i_archive = $c->param("archive") || "false";

    my $edition  = $c->Q("SELECT * FROM editions WHERE id=?", [ $i_edition ])->Hash;
    my $editions = $c->objectChildrens("editions.documents.work");

    # Common sql
    my $sql = "
        SELECT

            t1.id,
            t2.id as edition, t2.shortcut as edition_shortcut,
            t1.parent, t1.fastype, t1.variation,
            t1.shortcut, t1.description,
            t1.circulation, t1.pnum, t1.anum,
            t1.manager,
            t1.enabled, t1.archived,
            t1.flagdoc, t1.flagadv,

            to_char(t1.datedoc, 'YYYY-MM-DD HH24:MI:SS')   as datedoc,
            to_char(t1.dateadv, 'YYYY-MM-DD HH24:MI:SS')   as dateadv,
            to_char(t1.dateprint, 'YYYY-MM-DD HH24:MI:SS')   as dateprint,
            to_char(t1.dateout, 'YYYY-MM-DD HH24:MI:SS')   as dateout,

            to_char(t1.created, 'YYYY-MM-DD HH24:MI:SS') as created,
            to_char(t1.updated, 'YYYY-MM-DD HH24:MI:SS') as updated

        FROM fascicles t1, editions t2 WHERE t2.id=t1.edition
    ";

    # Parent query
    my $sql_parent = $sql . " AND edition=? AND t1.fastype <> 'system' ";
    push @params, $edition->{id};

    $sql_parent .= " AND t1.archived = true "      if ($i_archive eq "true");

    $sql_parent .= " AND ( t1.fastype = 'issue' "    if ($i_fastype eq "issue");
    $sql_parent .= " OR t1.fastype = 'attachment' ) "    if ($i_fastype eq "issue");

    $sql_parent .= " AND t1.fastype = 'template' " if ($i_fastype eq "template");

    $sql_parent .= " ORDER BY t1.dateout DESC ";

    my $result = $c->Q($sql_parent, \@params)->Hashes;

    foreach my $node (@{ $result }) {

        $node->{leaf} = $c->json->true;
        $node->{icon} = "/icons/blue-folder-open.png";

        my $sql_childrens = $sql . " AND t1.parent=? ORDER BY t1.dateout DESC ";
        $node->{children} = $c->Q($sql_childrens, [ $node->{id} ])->Hashes;

        foreach my $subnode (@{ $node->{children} }) {
            $node->{leaf} = $c->json->false;
            $subnode->{icon} = "/icons/blueprint.png";
            $subnode->{leaf} = $c->json->true;
            $subnode->{shortcut} = $subnode->{edition_shortcut};
        }

        #$node->{shortcut} = $node->{edition_shortcut} ."/". $node->{shortcut};

    }

    $c->render_json( $result );
}

sub create {

    my $c = shift;
    my $i_type = $c->param("type");

    if ($i_type eq "issue") {
        createIssue($c);
    }

    if ($i_type eq "attachment") {
        createAttachment($c);
    }

    if ($i_type eq "template") {

        createTemplate($c);
    }

    return $c;
}

sub createIssue {

    my $c = shift;

    my $id        = $c->uuid();
    my $variation = $c->uuid();

    my $enabled   = 1;
    my $archived  = 0;

    my $i_type          = $c->param("type");
    my $i_parent        = $c->param("parent");

    my $i_edition       = $c->param("edition");

    my $i_shortcut      = $c->param("shortcut");
    my $i_description   = $c->param("description");

    my $i_circulation   = $c->param("circulation") || 0;

    my $i_dateadv       = $c->param("dateadv");
    my $i_datedoc       = $c->param("datedoc");
    my $i_dateout       = $c->param("dateout");
    my $i_dateprint     = $c->param("dateprint");

    my $i_flagadv       = $c->param("flagadv") || 'bydate';
    my $i_flagdoc       = $c->param("flagdoc") || 'bydate';

    my $i_anum          = $c->param("anum") || 0;
    my $i_pnum          = $c->param("pnum") || 0;

    my @errors;
    my $success = $c->json->false;

    $i_dateadv   = undef if $i_dateadv eq 'undefined';
    $i_datedoc   = undef if $i_datedoc eq 'undefined';
    $i_dateout   = undef if $i_dateout eq 'undefined';
    $i_dateprint = undef if $i_dateprint eq 'undefined';

    $i_dateout   = $i_datedoc unless $i_dateout;
    $i_dateprint = $i_datedoc unless $i_dateprint;

    unless ($i_shortcut) {
        if ($i_anum) {
            $i_shortcut = $i_anum;
        }
        elsif ($i_pnum) {
            $i_shortcut = $i_pnum;
        }
        elsif ($i_dateprint) {
            $i_shortcut = $i_dateprint;
        }
        elsif ($i_dateout) {
            $i_shortcut = $i_dateout;
        }
    }

    # Checks

    unless ($i_type ~~ ["issue", "attachment", "template"]) {
        push @errors, {
            id => "type", msg => "Can't find type"
        }
    }

    if ($i_type eq "attachment") {
        $c->check_uuid( \@errors, "parent", $i_parent);
    }

    $i_parent = $i_edition unless ($i_parent);

    $c->check_uuid( \@errors, "edition", $i_edition);

    $c->check_text( \@errors, "shortcut",    $i_shortcut);
    $c->check_text( \@errors, "description", $i_description, 1);

    $c->check_int( \@errors, "circulation", $i_circulation, 1);

    $c->check_date( \@errors, "dateadv",   $i_dateadv, 1);
    $c->check_date( \@errors, "datedoc",   $i_datedoc, 1);
    $c->check_date( \@errors, "dateout",   $i_dateout, 1);
    $c->check_date( \@errors, "dateprint", $i_dateprint, 1);

    $c->check_flag( \@errors, "flagdoc", $i_flagdoc, 1);
    $c->check_flag( \@errors, "flagadv", $i_flagadv, 1);

    $c->check_int( \@errors, "anum", $i_anum, 1);
    $c->check_int( \@errors, "pnum", $i_pnum, 1);

    my $edition = $c->check_record(\@errors, "editions", "edition", $i_edition);

    unless (@errors) {

        $c->sql->bt;

        # Create new Fascicle
        Inprint::Models::Fascicle::create( $c,
            $id, $i_edition, $i_parent, $i_type, $variation,
            $i_shortcut, $i_description,
            $i_circulation, $i_pnum, $i_anum, undef, $enabled, $archived,
            $i_flagdoc, $i_flagadv,
            $i_datedoc, $i_dateadv, $i_dateprint, $i_dateout);

    # Import from Defaults
    #    if ($i_copyfrom && $i_copyfrom eq "00000000-0000-0000-0000-000000000000") {
            Inprint::Models::Fascicle::importFromDefaults($c, $id);
    #    }

    # Import from Fascicle
    #    if ($i_copyfrom && $i_copyfrom ne "00000000-0000-0000-0000-000000000000") {
    #        Inprint::Models::Fascicle::importFromFascicle($c, $id, $i_copyfrom);
    #    }

        $c->sql->et;
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub createAttachment {

    my $c = shift;

    my $id        = $c->uuid();
    my $variation = $c->uuid();

    my $enabled   = 1;
    my $archived  = 0;

    my $i_type          = $c->param("type");
    my $i_parent        = $c->param("parent");

    my $i_edition       = $c->param("edition");

    my $i_template      = $c->param("template");
    my $i_circulation   = $c->param("circulation") || 0;

    my @errors;
    my $success = $c->json->false;

    # Checks

    $c->check_uuid( \@errors, "parent", $i_parent);
    $c->check_uuid( \@errors, "edition", $i_edition);

    $c->check_int( \@errors, "circulation", $i_circulation, 1);
    $c->check_uuid( \@errors, "tempalte", $i_template, 1);

    my $edition = $c->check_record(\@errors, "editions", "edition", $i_edition);
    my $parent  = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);

    unless (@errors) {

        $c->sql->bt;

        # Create new Fascicle
        Inprint::Models::Fascicle::create( $c,
            $id, $edition->{id}, $parent->{id},
            $i_type, $variation,
            $parent->{shortcut}, $parent->{description},
            $i_circulation, $parent->{pnum}, $parent->{anum}, undef, $enabled, $archived,
            $parent->{flagdoc}, $parent->{flagadv},
            $parent->{datedoc}, $parent->{dateadv}, $parent->{dateprint}, $parent->{dateout}
        );

        Inprint::Models::Fascicle::importFromDefaults($c, $id);

        $c->sql->et;

    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub createTemplate {

    my $c = shift;

    my $id        = $c->uuid();
    my $variation = $c->uuid();

    my $enabled   = 1;
    my $archived  = 0;

    my $i_type          = $c->param("type");

    my $i_edition       = $c->param("edition");

    my $i_shortcut      = $c->param("shortcut");
    my $i_description   = $c->param("description");

    my @errors;
    my $success = $c->json->false;

    # Checks

    $c->check_uuid( \@errors, "edition", $i_edition);

    $c->check_text( \@errors, "shortcut",    $i_shortcut);
    $c->check_text( \@errors, "description", $i_description, 1);

        my $edition = $c->check_record(\@errors, "editions", "edition", $i_edition);

    unless (@errors) {

        $c->sql->bt;

        # Create new Fascicle
        Inprint::Models::Fascicle::Template::create(
            $c, $id, $i_edition, "template", $i_shortcut, $i_description);

        $c->sql->et;
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub read {

    my $c = shift;

    my $i_id = $c->param("id");

    my $result = Inprint::Models::Fascicle::read($c, $i_id);

    $c->render_json( { success => $c->json->true, data => $result } );
}


sub update {
    my $c = shift;

    my $i_id            = $c->param("id");

    my $i_enabled       = $c->param("enabled");

    my $i_title         = $c->param("title");
    my $i_shortcut      = $c->param("shortcut");
    my $i_description   = $c->param("description");

    my $i_deadline      = $c->param("deadline");
    my $i_advertisement = $c->param("advertisement");

    my $enabled = 0;
    if ($i_enabled eq "on") {
        $enabled = 1;
    }

    Inprint::Models::Fascicle::update( $c, $i_id, $enabled, $i_title,
            $i_shortcut, $i_description, $i_deadline, $i_advertisement );

    $c->render_json( { success => $c->json->true} );
}

sub delete {
    my $c = shift;

    my $i_fascicle = $c->param("id");

    my @errors;

    # Get fascicle
    my $fascicle = $c->Q("
        SELECT id, shortcut FROM fascicles WHERE id=? ",
        [ $i_fascicle ])->Hash;
    next unless ($fascicle->{id});

    # Get childrens
    my $childrens = $c->Q("
        SELECT id, shortcut FROM fascicles WHERE parent=? ",
        [ $i_fascicle ])->Hashes;

    # Begin transaction
    $c->sql->bt;

        # Delete all childrens
        foreach my $item (@{ $childrens }) {
            Inprint::Models::Fascicle::delete($c, $item->{id});
        }

        # Delete fascicle
        Inprint::Models::Fascicle::delete($c, $fascicle->{id});

        # Update documents
        #$c->Do(" UPDATE documents SET fascicle=?, fascicle_shortcut=? WHERE id=? ", [ $fascicle->{id}, $fascicle->{shortcut}, $id ]);
        #Inprint::Utils::Documents::MoveDocumentIndexToFascicle($c, \@errors, $fascicle->{id});

    $c->sql->et;

    $c->render_json( { success => $c->json->true } );
}

1;
