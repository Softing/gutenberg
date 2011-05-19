# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

package Inprint::Common::Transfer;

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub branches {

    my $c = shift;

    my $result = [];

    my $i_node = $c->param("node");

     if ($i_node ne "00000000-0000-0000-0000-000000000000") {
          my $branch = $c->Q(" SELECT id FROM branches WHERE edition=? LIMIT 1 ", [ $i_node ])->Value;

          my $data = $c->Q("
              SELECT t1.id, t1.branch, t1.readiness, t1.weight, t1.title, t1.shortcut, t1.description,
                  t2.shortcut as readiness_shortcut, t2.color as readiness_color
              FROM stages t1, readiness t2
              WHERE t1.branch=? AND t1.readiness=t2.id
              ORDER BY t1.weight, t1.shortcut
          ", [ $branch ])->Hashes || [];

          foreach my $item (@$data) {

              my $record = {
                  id    => $item->{id},
                  text  => $item->{shortcut},
                  leaf  => $c->json->true,
                  icon  => "tag-label",
                  color => $item->{color},
                  data  => $item
              };

              push @$result, $record;
          }
     }

    $c->render_json( $result );
}

sub list {

    my $c = shift;

    my $i_stage = $c->param("node");

    my $result = $c->Q("
        SELECT t1.id, t1.stage, t1.catalog, t1.principal,
            t2.shortcut as catalog_shortcut,
            t3.shortcut as stage_shortcut,
            t4.type,
            t4.shortcut as title,
            t4.description
        FROM map_principals_to_stages t1, catalog t2, stages t3, view_principals t4
        WHERE stage=?
            AND t1.catalog = t2.id
            AND t1.stage = t3.id
            AND t1.principal = t4.id
        ORDER BY t4.type, t4.shortcut
    ", [ $i_stage ])->Hashes;

    $c->render_json( { data => $result || [] } );
}

1;
