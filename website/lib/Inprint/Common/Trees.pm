# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

package Inprint::Common::Trees;

use strict;
use warnings;

use base 'Mojolicious::Controller';

# Function returns a tree of editions by an access rule
# Params:
#   uuid term - Access rule

sub editions {

    my $c = shift;

    my $result;
    my @errors;

    # Get variables from POST
    my $i_node = $c->param("node");
    my $i_term = $c->param("term") // undef;

    my $options = $c->optionalize( $c->param("options") );

    # Process root value
    my $root = "00000000-0000-0000-0000-000000000000";

    if ($i_node ~~ ["all", "root"]) {
        $i_node = $root;
    }

    # Check variables
    $c->check_uuid( \@errors, "node", $i_node);
    $c->check_rule( \@errors, "term", $i_term, 1);

    # Do something
    unless (@errors) {

        # Create SQL query
        my $sql = "
            SELECT t1.*
            FROM editions t1
            WHERE 1=1
                AND t1.path ~ ('*.' || replace(\$1, '-', '') || '.*{1}')::lquery ";

        my $bindings;
        my @params = ( $i_node );

        # There is some rule
        if ($i_term) {

            $bindings = $c->objectBindings($i_term);

            my $nodes = $c->Q("
                SELECT id FROM editions
                WHERE path @> ARRAY(
                    SELECT path FROM editions WHERE id = ANY(\$1)
                )", [ $bindings ])->Values;

            $sql .= " AND t1.id = ANY(\$2) ";
            push @params, $nodes;

        }

        $sql .= " ORDER BY shortcut ";

        # Do SQL query
        my $data = $c->Q($sql, \@params)->Hashes;

        # Process SQL query result
        foreach my $item (@$data) {

            my $id       = $item->{id};
            my $icon     = "blue-folders";
            my $text     = $item->{shortcut};
            my $leaf     = $c->json->true;
            my $disabled = $c->json->false;

            my $have_children = $c->Q("
                SELECT count(*) FROM editions WHERE path ~ ('*.' || ? || '.*{1}')::lquery ",
                $item->{path})->Value;

            if ( $have_children ) {
                $leaf = $c->json->false;
            }

            if ($i_term) {
                unless ( $id ~~ @$bindings ) {
                    $disabled = $c->json->true;
                }
            }

            push @$result, {
                id       => $id,
                text     => $text,
                icon     => $icon,
                leaf     => $leaf,
                disabled => $disabled
            };

        }

        # Autoexpand node if it is a root
        if ($i_node eq $root) {

            my $sql = "
                SELECT count(*)
                FROM editions
                WHERE path ~ ('*.' || replace(\$1, '-', '') || '.*{2}')::lquery ";

            if ($i_term) {
                $sql .= " AND id = ANY(\$2) "; }

            my $count = $c->Q($sql, \@params)->Value;

            if ($count < 30) {
                foreach my $item (@$result) {
                    $item->{expanded} = $c->json->true;
                }
            }

            if ($options->{showRoot}) {
                $c->render_json( [{
                    id          => $root,
                    text        => $c->l("Publishing house"),
                    leaf        => $c->json->false,
                    expanded    => $c->json->true,
                    icon        => "blue-folders",
                    disabled    => $c->json->false,
                    children    => $result
                }] );
            }
        }

    }

    $c->render_json( \@$result );
}

# Function returns a tree of fascicles by an access rule
# Params:
#   uuid term - Access rule
#   uuid edition - Filter by edition
#   bool briefcase  - Flag of show of a Briefcase
#   bool trashcan   - Flag of show of a Recycle Bin

sub fascicles {
    my $c = shift;

    my $result;
    my @errors;

    # Get variables from POST
    my $i_term      = $c->param("term")      // 0;
    my $i_node      = $c->param("node")      // 0;

    my $i_edition      = $c->param("edition")      // 0;
    my $i_briefcase    = $c->param("briefcase")    // 0;
    my $i_trashcan     = $c->param("trashcan")     // 0;
    my $i_attachments  = $c->param("attachments")  // 1;

    my $options = $c->optionalize(
        $c->param("options"));

    # Process root value
    my $root = "00000000-0000-0000-0000-000000000000";

    if ($i_node ~~ ["all", "root"]) {
        $i_node = $root;
    }

    # Check variables
    $c->check_uuid( \@errors, "node", $i_node);
    $c->check_rule( \@errors, "term", $i_term, 1);
    $c->check_uuid( \@errors, "edition", $i_edition, 1);
    $c->check_flag( \@errors, "briefcase", $i_briefcase, 1);
    $c->check_flag( \@errors, "trashcan", $i_trashcan, 1);

    # Do something
    unless (@errors) {

        my $sql = "
            SELECT
                fascicles.id, fascicles.shortcut, fascicles.fastype,
                editions.id as edition, editions.shortcut as edition_shortcut
            FROM fascicles, editions
            WHERE 1=1
                AND editions.id = fascicles.edition ";

        if ($options->{mode} eq "archive")
        {
            $sql .= "
                AND fascicles.archived = true
                AND fascicles.deleted  = false ";
        }
        else
        {
            $sql .= "
                AND fascicles.enabled  = true
                AND fascicles.archived = false
                AND fascicles.deleted  = false ";
        }

        my $icon;
        my $bindings;

        my @params;
        my @params_count;

        # Filter by edition
        if ($i_edition) {
            my $nodes = $c->Q("
                SELECT id FROM editions WHERE
                    path @> (
                        SELECT path FROM editions WHERE id = ? )
                    OR
                    path <@ (
                        SELECT path FROM editions WHERE id = ? )",
                [ $i_edition, $i_edition ])->Values;

            $sql .= " AND fascicles.edition  = ANY(?) ";
            push @params, $nodes;
        }

        # There is some rule
        if ($i_term) {

            $bindings = $c->objectBindings($i_term);

            my $nodes = $c->Q("
                SELECT id FROM editions
                WHERE path @> ARRAY(
                    SELECT path FROM editions WHERE id = ANY(?)
                )", [ $bindings ])->Values;

            $sql .= " AND fascicles.edition  = ANY(?) ";
            push @params, $nodes;

        }

        # This is root node, show Fascicles
        if ($i_node eq $root) {
            $sql .= " AND fascicles.fastype  = 'issue' ";
        }

        # This is fascicle node, show Attahments
        if ( $i_node ne $root) {
            $sql .= " AND fascicles.fastype  = 'attachment' ";
            $sql .= " AND fascicles.parent   = ? ";
            push @params, $i_node;
        }

        if ($options->{mode} eq "archive")
        {
            $sql .= " ORDER BY fascicles.shortcut DESC ";
        }
        else
        {
            $sql .= " ORDER BY fascicles.shortcut ASC ";
        }

        # Do SQL query
        my $data = $c->Q($sql, \@params)->Hashes;

        # Process SQL query result
        foreach my $item (@$data) {

            my $id       = $item->{id};
            my $text     = $item->{edition_shortcut} ." / ". $item->{shortcut};
            my $edition  = $item->{edition};
            my $leaf     = $c->json->true;
            my $disabled = $c->json->false;

            if ($item->{fastype} eq "issue") {
                $icon = "blue-folder-horizontal";
            }

            if ($item->{fastype} eq "attachment") {
                $icon = "folder-horizontal";
            }

            my $have_children = $c->Q("
                SELECT count(id) FROM fascicles WHERE parent = ?  ",
                $item->{id})->Value;

            if ($i_attachments && $have_children ) {
                $leaf = $c->json->false;
            }

            if ($i_term) {
                unless ( $item->{edition} ~~ @$bindings ) {
                    $disabled = $c->json->true;
                }
            }

            push @$result, {
                id       => $id,
                text     => $text,
                edition  => $edition,
                icon     => $icon,
                leaf     => $leaf,
                disabled => $disabled
            };

        }

        # Autoexpand node if it is a root
        if ($i_node eq $root) {

            foreach my $item (@$result) {
                $item->{expanded} = $c->json->true;
            }

            # Show predefined items
            if ($i_briefcase eq "true") {
                unshift @$result, {
                    id => "00000000-0000-0000-0000-000000000000",
                    icon => "briefcase",
                    text => $c->l("Briefcase"),
                    leaf => $c->json->true
                };
            }

            if ($i_trashcan eq "true") {
                unshift @$result, {
                    id => "00000000-0000-0000-0000-000000000000",
                    icon => "bin",
                    text => $c->l("Recycle Bin"),
                    leaf => $c->json->true
                };
            }

        }

    }

    $c->render_json( \@$result );
}

# Function returns a tree of workgroups by an access rule
# Params:
#   uuid term - Access rule

sub workgroups {

    my $c = shift;

    my $result;
    my @errors;

    # Get variables from POST
    my $i_node = $c->param("node") // 0;
    my $i_term = $c->param("term") // 0;

    my $options = $c->optionalize(
        $c->param("options"));

    # Process root value
    my $root = "00000000-0000-0000-0000-000000000000";

    if ($i_node ~~ ["all", "root"]) {
        $i_node = $root;
    }

    # Check variables
    $c->check_uuid( \@errors, "node", $i_node);
    $c->check_rule( \@errors, "term", $i_term, 1);

    # Do something
    unless (@errors) {

        # Create SQL query
        my $sql = "
            SELECT t1.*
            FROM catalog t1
            WHERE 1=1
                AND t1.path ~ ('*.' || replace(\$1, '-', '') || '.*{1}')::lquery ";

        my $bindings;
        my @params = ( $i_node );

        # There is some rule
        if ($i_term) {

            $bindings = $c->objectBindings($i_term);
            my $nodes = $c->Q("
                SELECT id FROM catalog
                WHERE path @> ARRAY(
                    SELECT path FROM catalog WHERE id = ANY(\$1)
                )", [ $bindings ])->Values;

            $sql .= " AND t1.id = ANY(\$2) ";
            push @params, $nodes;

        }

        $sql .= " ORDER BY shortcut ";

        # Do SQL query
        my $data = $c->Q($sql, \@params)->Hashes;

        # Process SQL query result
        foreach my $item (@$data) {

            my $id       = $item->{id};
            my $icon     = "xfn-friend";
            my $text     = $item->{shortcut};
            my $leaf     = $c->json->true;
            my $disabled = $c->json->false;

            my $have_children = $c->Q("
                SELECT count(*) FROM catalog WHERE path ~ ('*.' || ? || '.*{1}')::lquery ",
                $item->{path})->Value;

            if ( $have_children ) {
                $leaf = $c->json->false;
            }

            if ($i_term) {
                unless ( $id ~~ @$bindings ) {
                    $disabled = $c->json->true;
                }
            }

            push @$result, {
                id       => $id,
                text     => $text,
                icon     => $icon,
                leaf     => $leaf,
                disabled => $disabled
            };

        }

        # Autoexpand node if it is a root
        if ($i_node eq $root) {

            my $sql = "
                SELECT count(*)
                FROM catalog
                WHERE path ~ ('*.' || replace(\$1, '-', '') || '.*{2}')::lquery ";

            if ($i_term) {
                $sql .= " AND id = ANY(\$2) "; }

            my $count = $c->Q($sql, \@params)->Value;

            if ($count < 30) {
                foreach my $item (@$result) {
                    $item->{expanded} = $c->json->true;
                }
            }

        }

    }

    $c->render_json( \@$result );
}

1;
