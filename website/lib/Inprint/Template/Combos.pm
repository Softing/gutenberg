package Inprint::Template::Combos;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub templates {
    my $c = shift;

    my $result;
    my @errors;

    my $i_fascicle = $c->get_uuid(\@errors, "fascicle");

    my $fascicle = $c->check_record(\@errors, "template", "template", $i_fascicle);
    my $edition  = $c->check_record(\@errors, "editions", "edition", $fascicle->{edition});

    unless (@errors) {

        my $editions = $c->Q("
            SELECT id FROM editions WHERE path @> ? order by path asc; ",
            [ $edition->{path} ])->Values;

        $result = $c->Q("
            SELECT DISTINCT t1.id, title FROM ad_pages t1
            WHERE t1.edition = ANY(?)
            ORDER BY t1.title
        ", [ $editions ])->Hashes;
    }

    $c->smart_render(\@errors, $result || []);
}

sub headlines {
    my $c = shift;

    my $result;
    my @errors;

    my $i_fascicle = $c->get_uuid(\@errors, "fascicle");

    my $fascicle = $c->check_record(\@errors, "template", "template", $i_fascicle);
    my $edition  = $c->check_record(\@errors, "editions", "edition", $fascicle->{edition});

    unless (@errors) {

        my $editions = $c->Q("
            SELECT id FROM editions WHERE path @> ? order by path asc;",
            [ $edition->{path} ])->Values;

        $result = $c->Q("
            SELECT DISTINCT id, title FROM indx_headlines
            WHERE edition = ANY (?)
            ORDER BY title ",
            [ $editions ])->Hashes;
    }

    $c->smart_render(\@errors, $result || []);
}

#sub rubrics {
#    my $c = shift;
#
#
#    my @errors;
#    my $result;
#
#    my $i_headline = $c->param("headline") || undef;
#
#    push @errors, { id => "headline", msg => "Incorrectly filled field"}
#        unless ($c->is_uuid($i_headline));
#
#    unless (@errors) {
#        $result = $c->Q("
#            SELECT DISTINCT id, title FROM fascicles_indx_rubrics
#            WHERE fascicle=?
#            ORDER BY title ",
#            [ $i_headline ])->Hashes;
#    }
#
#    $c->smart_render(\@errors, $result || []);
#}


1;
