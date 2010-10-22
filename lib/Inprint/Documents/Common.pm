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
            t1.id, t1.issystem, t1.edition, t2.shortcut as edition_shortcut,
            t1.title, t1.shortcut, t1.description,
            to_char(t1.begindate, 'YYYY-MM-DD HH24:MI:SS') as begindate,
            to_char(t1.enddate, 'YYYY-MM-DD HH24:MI:SS') as enddate,
            t1.enabled, t1.created, t1.updated,
            EXTRACT( DAY FROM t1.enddate-t1.begindate) as totaldays,
            EXTRACT( DAY FROM now()-t1.begindate) as passeddays
        FROM fascicles t1, editions t2
        WHERE
            t1.issystem = false AND t1.edition = t2.id AND t1.enabled = true
    ";

    if ($edition) {
        $sql .= " AND edition=? ";
        push @params, $edition;
    }

    $sql .= " ORDER BY enabled desc, edition_shortcut, begindate ";

    my $result = $c->sql->Q($sql, \@params)->Hashes;

    $c->render_json( { data => $result } );
}
1;
