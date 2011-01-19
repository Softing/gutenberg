package Inprint::Calendar;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Utils::Documents;
use Inprint::Models::Fascicle;

use base 'Inprint::BaseController';

sub tree {

    my $c = shift;

    my $i_node = $c->param("node");
    $i_node = '00000000-0000-0000-0000-000000000000' unless ($i_node);
    $i_node = '00000000-0000-0000-0000-000000000000' if ($i_node eq "root-node");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_node));

    my @result;

    unless (@errors) {
        my $sql;
        my @data;

        $sql = "
            SELECT *,
                ( SELECT count(*) FROM editions c2 WHERE c2.path ~ ('*.' || editions.path::text || '.*{1}')::lquery ) as have_childs
            FROM editions
            WHERE
                id <> '00000000-0000-0000-0000-000000000000'
                AND EXISTS(
                    SELECT true
                    FROM cache_access access
                    WHERE access.path @> editions.path AND access.type = 'editions' AND 'editions.documents.work' = ANY(access.terms)
                )
        ";

        if ($i_node ne "00000000-0000-0000-0000-000000000000") {
            $sql .= " AND subpath(path, nlevel(path) - 2, 1)::text = replace(?, '-', '')::text ";
            push @data, $i_node;
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

    #    EXTRACT( DAY FROM t1.enddate-t1.begindate) as totaldays,
    #    EXTRACT( DAY FROM now()-t1.begindate) as passeddays

    # Common sql
    my $sql = "
        SELECT
            t1.id,
            t2.id as edition, t2.shortcut as edition_shortcut,
            t1.parent, t1.title, t1.shortcut, t1.description, t1.manager, t1.variation,
            to_char(t1.deadline, 'YYYY-MM-DD HH24:MI:SS') as deadline,
            to_char(t1.advert_deadline, 'YYYY-MM-DD HH24:MI:SS') as advert_deadline,
            t1.created, t1.updated
        FROM fascicles t1, editions t2 WHERE t2.id=t1.edition
    ";

    # Parent query
    my $sql_parent = $sql . " AND edition=? AND t1.edition=t1.parent ";
    push @params, $edition->{id};

    # Archive
    if ($i_archive eq 'true') {
        $sql_parent .= " AND t1.deadline < now() ";
    }

    if ($i_archive ne 'true') {
        $sql_parent .= " AND t1.deadline >= now() ";
    }

    $sql_parent .= " ORDER BY t1.deadline DESC ";

    my $result = $c->sql->Q($sql_parent, \@params)->Hashes;

    foreach my $node (@{ $result }) {

        $node->{leaf} = $c->json->true;
        $node->{icon} = "/icons/blue-folder-open.png";

        my $sql_childrens = $sql . " AND t1.parent=? ORDER BY t1.deadline DESC ";
        $node->{children} = $c->sql->Q($sql_childrens, [ $node->{id} ])->Hashes;

        foreach my $subnode (@{ $node->{children} }) {
            $node->{leaf} = $c->json->false;
            $subnode->{icon} = "/icons/blueprint.png";
            $subnode->{leaf} = $c->json->true;
            $subnode->{shortcut} = $subnode->{edition_shortcut} ."/". $subnode->{shortcut};
        }

        $node->{shortcut} = $node->{edition_shortcut} ."/". $node->{shortcut};

    }

    $c->render_json( $result );
}

sub create {

    my $c = shift;

    my $id      = $c->uuid();
    my $version = $c->uuid();

    my $i_edition       = $c->param("edition");
    my $i_parent        = $c->param("parent");

    my $i_enabled       = $c->param("enabled");

    my $i_title         = $c->param("title");
    my $i_shortcut      = $c->param("shortcut");
    my $i_description   = $c->param("description");

    my $i_deadline      = $c->param("deadline");
    my $i_advertisement = $c->param("advertisement");

    my $i_copyfrom      = $c->param("copyfrom");

    my $enabled = 0;
    if ($i_enabled eq "on") {
        $enabled = 1;
    }

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    if ($i_shortcut) {
        push @errors, { id => "shortcut", msg => "Incorrectly filled field"}
            unless ($c->is_text($i_shortcut));
    }

    if ($i_description) {
        push @errors, { id => "description", msg => "Incorrectly filled field"}
            unless ($c->is_text($i_description));
    }

    if ($i_copyfrom) {
        push @errors, { id => "copypages", msg => "Incorrectly filled field"}
            unless ($c->is_uuid($i_copyfrom));
    }

    unless ($i_parent) {
        $i_parent = $i_edition;
    }

    #TODO: add date checks

    my $edition;
    unless (@errors) {
        $edition = $c->sql->Q("
            SELECT * FROM editions WHERE id=? ",
            [ $i_edition ])->Hash;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($edition->{id});
    }

    unless (@errors) {

        $c->sql->bt;

        # Create new Fascicle
        Inprint::Models::Fascicle::create( $c, $id, $i_edition, $i_parent, $enabled, $i_title,
            $i_shortcut, $i_description, $version, $i_deadline, $i_advertisement );

        # Import from Defaults
        if ($i_copyfrom && $i_copyfrom eq "00000000-0000-0000-0000-000000000000") {
            Inprint::Models::Fascicle::importFromDefaults($c, $id);
        }

        # Import from Fascicle
        if ($i_copyfrom && $i_copyfrom ne "00000000-0000-0000-0000-000000000000") {
            Inprint::Models::Fascicle::importFromFascicle($c, $id, $i_copyfrom);
        }

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
