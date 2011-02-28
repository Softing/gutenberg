package Inprint::Calendar;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Utils::Documents;
use Inprint::Models::Fascicle;

use Inprint::Check;

use base 'Inprint::BaseController';

sub tree {

    my $c = shift;

    my $i_node = $c->param("node");
    $i_node = '00000000-0000-0000-0000-000000000000' unless ($i_node);
    $i_node = '00000000-0000-0000-0000-000000000000' if ($i_node eq "root-node");

    my @errors;
    my $success = $c->json->false;

    Inprint::Check::uuid($c, \@errors, "id", $i_node);

    my @result;

    unless (@errors) {

        my $sql;
        my @data;

        my $bindings = $c->access->GetBindings(["editions.calendar.manage", "editions.calendar.work"]);

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

        my $data = $c->sql->Q("$sql ORDER BY shortcut", \@data)->Hashes;

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
    my $i_archive = $c->param("showArchive") || "false";

    my $edition  = $c->sql->Q("SELECT * FROM editions WHERE id=?", [ $i_edition ])->Hash;
    my $editions = $c->access->GetChildrens("editions.documents.work");

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
    my $sql_parent = $sql . " AND edition=? AND t1.fastype = 'issue' ";
    push @params, $edition->{id};

    $sql_parent .= " AND t1.archived = true "  if ($i_archive eq 'true');
    $sql_parent .= " AND t1.archived = false " if ($i_archive ne 'true');

    $sql_parent .= " ORDER BY t1.dateout DESC ";

    my $result = $c->sql->Q($sql_parent, \@params)->Hashes;

    foreach my $node (@{ $result }) {

        $node->{leaf} = $c->json->true;
        $node->{icon} = "/icons/blue-folder-open.png";

        #my $sql_childrens = $sql . " AND t1.parent=? ORDER BY t1.deadline DESC ";
        #$node->{children} = $c->sql->Q($sql_childrens, [ $node->{id} ])->Hashes;
        #
        #foreach my $subnode (@{ $node->{children} }) {
        #    $node->{leaf} = $c->json->false;
        #    $subnode->{icon} = "/icons/blueprint.png";
        #    $subnode->{leaf} = $c->json->true;
        #    $subnode->{shortcut} = $subnode->{edition_shortcut} ."/". $subnode->{shortcut};
        #}

        #$node->{shortcut} = $node->{edition_shortcut} ."/". $node->{shortcut};

    }

    $c->render_json( $result );
}

sub create {

    my $c = shift;

    my $id        = $c->uuid();
    my $variation = $c->uuid();
    my $enabled   = 1;
    my $archived  = 0;
    my $fastype   = "issue";

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

    Inprint::Check::uuid($c, \@errors, "edition", $i_edition);

    Inprint::Check::text($c, \@errors, "shortcut",    $i_shortcut);
    Inprint::Check::text($c, \@errors, "description", $i_description, 1);

    Inprint::Check::int($c, \@errors, "circulation", $i_circulation, 1);

    Inprint::Check::date($c, \@errors, "dateadv",   $i_dateadv, 1);
    Inprint::Check::date($c, \@errors, "datedoc",   $i_datedoc, 1);
    Inprint::Check::date($c, \@errors, "dateout",   $i_dateout, 1);
    Inprint::Check::date($c, \@errors, "dateprint", $i_dateprint, 1);

    Inprint::Check::flag($c, \@errors, "flagdoc", $i_flagdoc, 1);
    Inprint::Check::flag($c, \@errors, "flagadv", $i_flagadv, 1);

    Inprint::Check::int($c, \@errors, "anum", $i_anum, 1);
    Inprint::Check::int($c, \@errors, "pnum", $i_pnum, 1);

    my $edition = Inprint::Check::edition($c, \@errors, $i_edition);

    unless (@errors) {

        $c->sql->bt;

        # Create new Fascicle
        Inprint::Models::Fascicle::create( $c,
            $id, $i_edition, $i_edition, $fastype, $variation,
            $i_shortcut, $i_description,
            $i_circulation, $i_pnum, $i_anum, undef, $enabled, $archived,
            $i_flagdoc, $i_flagadv,
            $i_datedoc, $i_dateadv, $i_dateprint, $i_dateout);

    #    # Import from Defaults
    #    if ($i_copyfrom && $i_copyfrom eq "00000000-0000-0000-0000-000000000000") {
    #        Inprint::Models::Fascicle::importFromDefaults($c, $id);
    #    }
    #
    #    # Import from Fascicle
    #    if ($i_copyfrom && $i_copyfrom ne "00000000-0000-0000-0000-000000000000") {
    #        Inprint::Models::Fascicle::importFromFascicle($c, $id, $i_copyfrom);
    #    }
    #
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
    my $fascicle = $c->sql->Q("
        SELECT id, shortcut FROM fascicles WHERE id=? ",
        [ $i_fascicle ])->Hash;
    next unless ($fascicle->{id});

    # Get childrens
    my $childrens = $c->sql->Q("
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
        #$c->sql->Do(" UPDATE documents SET fascicle=?, fascicle_shortcut=? WHERE id=? ", [ $fascicle->{id}, $fascicle->{shortcut}, $id ]);
        #Inprint::Utils::Documents::MoveDocumentIndexToFascicle($c, \@errors, $fascicle->{id});

    $c->sql->et;

    $c->render_json( { success => $c->json->true } );
}

1;
