package Inprint::Common::Trees;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub editions {

    my $c = shift;

    my $result;
    my @errors;

    my $i_node = $c->param("node");
    my $i_term = $c->param("term") // undef;

    my $root = "00000000-0000-0000-0000-000000000000";

    if ($i_node ~~ ["all", "root"]) {
        $i_node = $root;
    }

    $c->check_uuid( \@errors, "node", $i_node);
    $c->check_rule( \@errors, "term", $i_term, 1);

    unless (@errors) {

        my $sql = "
            SELECT
                t1.*
            FROM editions t1
            WHERE 1=1
                AND t1.path ~ ('*.' || replace(\$1, '-', '') || '.*{1}')::lquery

            ";

        my $bindings;
        my @params = ( $i_node );

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

        my $data = $c->Q($sql, \@params)->Hashes;

        foreach my $item (@$data) {

            my $id       = $item->{id};
            my $icon     = "blue-folders";
            my $text     = $item->{shortcut};
            my $leaf     = $c->json->true;
            my $disabled = $c->json->false;

            my $have_children = $c->Q("
                SELECT count(*) FROM editions WHERE path ~ ('*.' || ? || '.*{1}')::lquery
                ", $item->{path})->Value;

            if ($i_term) {
                unless ( $id ~~ @$bindings ) {
                    $disabled = $c->json->false;
                }
            }

            if ( $have_children ) {
                $leaf = $c->json->false;
            }

            push @$result, {
                id       => $id,
                type     => "edition",
                text     => $text,
                icon     => $icon,
                leaf     => $leaf,
                disabled => $disabled
            };

        }

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
                    if ($item->{type} eq "edition") {
                        $item->{expanded} = $c->json->true;
                    }
                }
            }
        }

    }

    $c->render_json( \@$result );
}

sub fascicles {
    my $c = shift;

    my $result;
    my @errors;

    my $i_term = $c->param("term");
    my $i_node = $c->param("node");

    my $root = "00000000-0000-0000-0000-000000000000";

    if ($i_node ~~ ["all", "root"]) {
        $i_node = $root;
    }

    $c->check_uuid( \@errors, "node", $i_node);
    $c->check_rule( \@errors, "term", $i_term);

    unless (@errors) {

        my $bindings = $c->objectBindings($i_term);

        my $nodes = $c->Q("
            SELECT id FROM editions
            WHERE path @> ARRAY(
                SELECT path FROM editions WHERE id = ANY(\$1)
            )", [ $bindings ])->Values;

        my $sql = "
            SELECT
                fascicles.id, fascicles.edition, fascicles.shortcut, fascicles.fastype,
                editions.shortcut as edition_shortcut,
                ( SELECT count(*) FROM fascicles children WHERE children.parent = fascicles.id ) as childrens
            FROM fascicles, editions
            WHERE 1=1
                AND editions.id = fascicles.edition
                AND fascicles.enabled  = true
                AND fascicles.archived = false
                AND fascicles.deleted  = false
                AND fascicles.edition  = ANY(\$1)
        ";

        my $icon;
        my @data;
        push @data, $nodes;

        if ($i_node eq $root) {
            $icon = "blue-folder-horizontal";
            $sql .= " AND fascicles.fastype  = 'issue' ";
        }

        if ($i_node ne $root) {
            $icon = "folder-horizontal";
            $sql .= " AND fascicles.fastype  = 'attachment' ";
            $sql .= " AND fascicles.parent   = \$2 ";
            push @data, $i_node;
        }

        $sql .= " ORDER BY fascicles.shortcut ";

        my $data = $c->Q($sql, \@data)->Hashes;

        foreach my $item (@$data) {

            my $id       = $item->{id};
            my $text = $item->{edition_shortcut} ." &ndash; ". $item->{shortcut};
            my $leaf     = $c->json->true;
            my $disabled = $c->json->true;

            if ( $item->{edition} ~~ @$bindings ) {
                $disabled = $c->json->false;
            }

            if ( $item->{childrens} ) {
                $leaf = $c->json->false;
            }

            push @$result, {
                id       => $id,
                text     => $text,
                icon     => $icon,
                leaf     => $leaf,
                disabled => $disabled
            };

        }

        if ($i_node eq $root) {

            my $sql = "
                SELECT count(*)
                FROM fascicles
                WHERE 1=1
                    AND parent = \$1
                    AND edition = ANY(\$2) ";

            my $count = $c->Q($sql, [ $i_node, $nodes ])->Value;

            if ($count < 30) {
                foreach my $item (@$result) {
                    $item->{expanded} = $c->json->true;
                }
            }
        }

    }

    $c->render_json( \@$result );
}

sub workgroups {
    my $c = shift;

    my $i_term = $c->param("term");
    my $i_node = $c->param("node");

    my @result;
    my @errors;
    my $success = $c->json->false;

    $i_node = "00000000-0000-0000-0000-000000000000" if $i_node eq "all";

    $c->check_uuid( \@errors, "node", $i_node);
    $c->check_rule( \@errors, "node", $i_term);

    my $bindings = $c->objectBindings($i_term);

    unless (@errors) {

        my $sql;
        my @data;

        if ($i_node eq "00000000-0000-0000-0000-000000000000") {
            $sql = "
                SELECT t1.*,
                    ( SELECT count(*) FROM catalog c2 WHERE c2.path ~ ('*.' || t1.path::text || '.*{1}')::lquery ) as have_childs
                FROM catalog t1
                WHERE
                    t1.id <> '00000000-0000-0000-0000-000000000000'
                    AND t1.id = ANY(?)
            ";
            push @data, $bindings;
        }

        if ($i_node ne "00000000-0000-0000-0000-000000000000") {
            $sql .= "
                SELECT t1.*,
                    ( SELECT count(*) FROM catalog c2 WHERE c2.path ~ ('*.' || t1.path::text || '.*{1}')::lquery ) as have_childs
                FROM catalog t1
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
                icon => "xfn-friend",
                text => $item->{shortcut},
                leaf => $c->json->true,
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


1;
