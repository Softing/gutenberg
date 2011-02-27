package Inprint::Documents::Common;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub fascicles {

    my $c = shift;

    my $edition = $c->param("edition") || undef;

    my @params;

    my $sql = "
        SELECT
            t1.id,
            t2.id as edition, t2.shortcut as edition_shortcut,
            t1.parent, t1.title, t1.shortcut, t1.description, t1.manager, t1.variation,
            to_char(t1.datedoc, 'YYYY-MM-DD HH24:MI:SS') as datedoc,
            to_char(t1.dateadv, 'YYYY-MM-DD HH24:MI:SS') as dateadv,
            t1.created, t1.updated
        FROM fascicles t1, editions t2 WHERE t2.id=t1.edition AND t1.enabled = true
    ";

    my $editions = $c->access->GetChildrens("editions.documents.work");
    $sql .= " AND t1.edition = ANY(?) ";
    push @params, $editions;

    if ($edition) {
        $sql .= " AND edition=? ";
        push @params, $edition;
    }


    $sql .= " ORDER BY t1.dateout DESC ";

    my $result = $c->sql->Q($sql, \@params)->Hashes;

    $c->render_json( { data => $result } );
}
1;
