package Inprint::Calendar::Trees;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub editions {
    my $c = shift;

    my $i_node = $c->param("node") || "00000000-0000-0000-0000-000000000000";

    my @result;
    my @errors;

    $c->check_uuid( \@errors, "node", $i_node);

    unless (@errors) {

        my $sql;
        my @data;

        my $bindings = $c->objectBindings("editions.attachment.manage:*");

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

        my $data = $c->Q("$sql ORDER BY shortcut ", \@data)->Hashes;

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

1;
