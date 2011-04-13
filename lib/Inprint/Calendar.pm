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

    my @errors;
    my @result;

    my $i_node = $c->param("node");

    if ($i_node eq "root-node") {
        $i_node = '00000000-0000-0000-0000-000000000000';
    }

    $c->check_uuid( \@errors, "id", $i_node);

    unless (@errors) {

        my $sql;
        my @data;

        # Get editions with grant
        my $bindings = $c->objectBindings([
            "editions.fascicle.manage:*", "editions.attachment.manage:*" ]);

        my $paths = $c->Q("
            SELECT id FROM editions
            WHERE path @> ARRAY(
                SELECT path FROM editions WHERE id = ANY(\$1)
            )", [ $bindings ])->Values;

        $sql = "
            SELECT
                t1.*,
                ( SELECT count(*) FROM editions c2 WHERE c2.path ~ ('*.' || t1.path::text || '.*{1}')::lquery ) as have_childs
            FROM editions t1
            WHERE 1=1
                AND t1.path ~ ('*.' || replace(\$1, '-', '') || '.*{1}')::lquery
                AND t1.id = ANY(\$2)
            ORDER BY shortcut
        ";
        push @data, $i_node;
        push @data, $paths;

        my $data = $c->Q($sql, \@data)->Hashes;

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

    $c->render_json( \@result );
}

sub list {

    my $c = shift;

    my @params;

    my $i_edition = $c->param("edition") || undef;
    my $i_fastype = $c->param("fastype") || "issue";
    my $i_archive = $c->param("archive") || "false";

    my $edition  = $c->Q("SELECT * FROM editions WHERE id=?", [ $i_edition ])->Hash;
    my $editions = $c->objectBindings("editions.documents.work:*");

    # Common sql
    my $sql = "
        SELECT

            t1.id,
            t2.id as edition, t2.shortcut as edition_shortcut,
            t1.parent, t1.fastype, t1.variation,
            t1.shortcut, t1.description,
            t1.tmpl, t1.tmpl_shortcut,
            t1.circulation, t1.num, t1.anum,
            t1.manager,
            t1.enabled, t1.archived,
            t1.doc_enabled, t1.adv_enabled,

            to_char(t1.doc_date, 'YYYY-MM-DD HH24:MI:SS')     as doc_date,
            to_char(t1.adv_date, 'YYYY-MM-DD HH24:MI:SS')     as adv_date,
            to_char(t1.print_date, 'YYYY-MM-DD HH24:MI:SS')   as print_date,
            to_char(t1.release_date, 'YYYY-MM-DD HH24:MI:SS') as release_date,

            to_char(t1.created, 'YYYY-MM-DD HH24:MI:SS') as created,
            to_char(t1.updated, 'YYYY-MM-DD HH24:MI:SS') as updated

        FROM fascicles t1, editions t2
        WHERE 1=1
            AND t1.deleted = false
            AND t2.id=t1.edition
    ";

    # Parent query
    my $sql_parent = $sql . " AND edition=? ";
    push @params, $edition->{id};

    $sql_parent .= " AND t1.archived = true "      if ($i_archive eq "true");
    $sql_parent .= " AND t1.archived = false "     if ($i_archive eq "false");

    $sql_parent .= " AND t1.fastype = 'issue' "    if ($i_fastype eq "issue");
    $sql_parent .= " AND t1.fastype = 'template' " if ($i_fastype eq "template");

    $sql_parent .= " ORDER BY t1.release_date DESC ";

    my $result = $c->Q($sql_parent, \@params)->Hashes;

    foreach my $node (@{ $result }) {

        $node->{leaf} = $c->json->true;
        $node->{expanded} = $c->json->true;
        $node->{icon} = "/icons/blue-folder-small-horizontal.png";

        my $sql_childrens = $sql;

        $sql_childrens .= " AND t1.parent=? ";
        $sql_childrens .= " ORDER BY t1.release_date DESC ";

        $node->{children} = $c->Q($sql_childrens, [ $node->{id} ])->Hashes;

        foreach my $subnode (@{ $node->{children} }) {
            $node->{leaf} = $c->json->false;
            $subnode->{icon} = "/icons/folder-small-horizontal.png";
            $subnode->{leaf} = $c->json->true;
            $subnode->{shortcut} = $subnode->{edition_shortcut};
        }

    }


    my $sql_childrens = $sql;

    $sql_childrens .= " AND edition=? ";

    $sql_childrens .= " AND t1.fastype='attachment' ";

    $sql_childrens .= " AND t1.archived = true "      if ($i_archive eq "true");
    $sql_childrens .= " AND t1.archived = false "     if ($i_archive eq "false");

    $sql_childrens .= " ORDER BY t1.release_date DESC ";

    my $children = $c->Q($sql_childrens, [ $edition->{id} ])->Hashes;

    foreach my $node (@$children) {
        $node->{icon} = "/icons/folder-small-horizontal.png";
        $node->{leaf} = $c->json->true;
        $node->{shortcut} = $node->{edition_shortcut};
        push @$result, $node;
    }

    $c->render_json( $result );
}

1;
