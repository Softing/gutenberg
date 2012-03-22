package Inprint::Models::Fascicle::Index;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Tag;

sub get {

    my ($c, $headline_id, $rubric_id, $params) = @_;

    my $result;

    if ($headline_id) {
        my $sql = "
            SELECT tag
            FROM fascicles_indx_headlines WHERE id=? ";
        my @params = ($headline_id);

        my $headline_tag = $c->sql($sql, \@params)->Value;
        $result->{headline} = Inprint::Models::Tag::getById($c, $headline_tag);
    }

    if ($result->{headline}->{tag} && $rubric_id) {

        my $sql = "
            SELECT tag
            FROM fascicles_indx_rubrics WHERE id=? AND headline=?";
        my @params = ($rubric_id, $headline_id);

        my $rubric_tag = $c->sql($sql, \@params)->Value;
        $result->{rubric} = Inprint::Models::Tag::getById($c, $rubric_tag);

    }

    return $result;
}

1;
