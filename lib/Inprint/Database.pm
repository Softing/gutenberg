use utf8;
package Inprint::Database;

use strict;
use warnings;

use Inprint::Database::Model::Fascicle;

sub fascicle {
    my ($c, $fascicle) = @_;
    my $hash = $c->sql->Q(" SELECT * FROM fascicles WHERE id = ?", $fascicle)->Hash;

    my $item = Inprint::Database::Model::Fascicle->new($hash)->setSql($c->sql);

    return $item;
}

1;
