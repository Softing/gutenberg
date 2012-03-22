package Inprint::Documents::Common;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub fascicles {

    my $c = shift;

    my $edition = $c->param("edition") || undef;

    my @params;

    my $sql = "
        SELECT
            fascicles.id,
            editions.id as edition, editions.shortcut as edition_shortcut,
            fascicles.parent, fascicles.shortcut, fascicles.description,
            fascicles.manager, fascicles.variation, fascicles.fastype,
            to_char(fascicles.doc_date, 'YYYY-MM-DD HH24:MI:SS') as datedoc,
            to_char(fascicles.adv_date, 'YYYY-MM-DD HH24:MI:SS') as dateadv,
            fascicles.created, fascicles.updated
        FROM
            fascicles, editions
        WHERE 1=1
            AND editions.id=fascicles.edition
            AND fascicles.enabled = true
            AND fascicles.archived = false
            AND fascicles.deleted  = false
    ";

    my $editions = $c->objectBindings("editions.documents.work:*");
    $sql .= " AND fascicles.edition = ANY(?) ";
    push @params, $editions;

    if ($edition) {
        $sql .= " AND edition=? ";
        push @params, $edition;
    }


    $sql .= " ORDER BY fascicles.release_date DESC ";

    my $result = $c->Q($sql, \@params)->Hashes;

    $c->render_json( { data => $result } );
}
1;
