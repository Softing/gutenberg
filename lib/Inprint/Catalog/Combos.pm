package Inprint::Catalog::Combos;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub editions {
    my $c = shift;

    my @params;
    my $sql = "
        SELECT t1.id, t1.shortcut as title, nlevel(path) as nlevel, description,
            array_to_string( ARRAY( SELECT shortcut FROM editions WHERE path @> t1.path ORDER BY nlevel(path) ), '.') as title_path
        FROM editions t1
    ";

    my $result = $c->Q(" $sql ORDER BY title_path ", \@params)->Hashes;
    $c->render_json( { data => $result } );
}

sub groups {
    my $c = shift;
    my $result = $c->Q("
        SELECT t1.id, t1.shortcut as title, nlevel(path) as nlevel, '' as description,
            array_to_string( ARRAY( SELECT shortcut FROM catalog WHERE path @> t1.path ORDER BY nlevel(path) ), '.') as title_path
        FROM catalog t1
        ORDER BY title_path
    ")->Hashes;
    $c->render_json( { data => $result } );
}

sub fascicles {
    my $c = shift;

    my $i_term = $c->param("term") || undef;

    my @data;
    my $sql = "
        SELECT t1.id, t2.shortcut || '/' || t1.shortcut as title, t1.shortcut, t1.description,
            CASE WHEN is_enabled is true THEN  'rocket-fly' ELSE 'book' END as icon
        FROM fascicles t1, editions t2
        WHERE t2.id = t1.edition AND is_system = false
    ";

    if ($i_term) {
        my $access = $c->objectBindingsByTerm($i_term);
        $sql .= " AND edition = ANY(?) ";
        push @data, $access;
    }

    my $result = $c->Q("
        $sql
        ORDER BY is_enabled DESC, t2.shortcut, t1.shortcut
    ", \@data)->Hashes;
    $c->render_json( { data => $result } );
}

sub readiness {
    my $c = shift; #weight || '% ' ||
    my $sql = "
        SELECT id, color, shortcut as title, description
        FROM readiness ORDER BY weight, shortcut;
    ";
    my $result = $c->Q($sql)->Hashes;
    $c->render_json( { data => $result } );
}

sub roles {
    my $c = shift;
    my $sql = " SELECT id, title, shortcut, description FROM fascicles WHERE 1=1 ";
    $sql .= " ORDER BY is_system DESC, enddate, title ";
    my $result = $c->Q($sql)->Hashes;
    $c->render_json( { data => $result } );
}

1;
