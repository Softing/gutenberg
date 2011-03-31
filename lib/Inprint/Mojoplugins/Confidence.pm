package Inprint::Mojoplugins::Confidence;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use warnings;
use strict;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

sub register {
    my ( $self, $app, $conf ) = @_;

    # Plugin config
    $conf ||= {};

    $app->helper(
        objectAccess => sub {
            my ($c, $terms, $binding, $member) = @_;

            my @rules;
            my $result = 0;

            unless ($member) {
                $member = $c->getSessionValue("member.id");
            }

            if (ref $terms eq "ARRAY") {
                @rules = @$terms;
            } else {
                push @rules, $terms;
            }

            for (my $i=0; $i <= $#rules; $i++) {
                my ($term, $area) = split /:/, $rules[$i];
                if ($area eq "*") {
                    splice @rules, $i, $i, "$term:member", "$term:group";
                }
            }
            my %seen; @rules = grep { ! $seen{$_}++ } @rules;

            if ($member && @rules) {

                my @data;

                my $sql = " SELECT true FROM cache_access WHERE member=? AND ? && terms ";
                push @data, $member;
                push @data, \@rules;

                if ($binding) {
                    $sql .= " AND binding=?";
                    push @data, $binding;
                }

                $result = $c->sql->Q("SELECT EXISTS ($sql)", \@data)->Value();
            }

            return $result;
        } );

    $app->helper(
        objectDirectAccess => sub {
            my ($c, $terms, $binding, $member) = @_;

            my @rules;
            my $result = 0;

            unless ($member) {
                $member = $c->getSessionValue("member.id");
            }

            if (ref $terms eq "ARRAY") {
                @rules = @$terms;
            } else {
                push @rules, $terms;
            }

            my %seen; @rules = grep { ! $seen{$_}++ } @rules;

            if ($member && @rules) {

                my @data;

                my $sql = "
                    SELECT true
                    FROM map_member_to_rule map LEFT JOIN rules ON map.term = rules.id
                    WHERE member=? AND rules.section || '.' || rules.subsection || '.' || rules.term = ANY(?) ";
                push @data, $member;
                push @data, \@rules;

                if ($binding) {
                    $sql .= " AND binding=?";
                    push @data, $binding;
                }

                $result = $c->sql->Q("SELECT EXISTS ($sql)", \@data)->Value();
            }

            return $result;
        } );

    $app->helper(
        objectBindings => sub {

            my ($c, $terms, $member) = @_;

            my $result = [];

            unless ($member) {
                $member = $c->getSessionValue("member.id");
            }

            my @rules;

            if (ref $terms eq "ARRAY") {
                @rules = @$terms;
            } else {
                push @rules, $terms;
            }

            for (my $i=0; $i <= $#rules; $i++) {
                my ($term, $area) = split /:/, $rules[$i];
                if ($area eq "*") {
                    splice @rules, $i, $i, "$term:member", "$term:group";
                }
            }

            my %seen;
            @rules = grep { ! $seen{$_}++ } @rules;

            if (@rules && $member) {
                $result = $c->sql->Q("
                    SELECT t1.binding FROM cache_access t1
                    WHERE t1.member = ? AND ?::text[] && t1.terms;
                ", [ $member, \@rules ])->Values();
            }

            return $result || [];
        } );

    $app->helper(
        objectChildrens => sub {

            my ($c, $terms, $member) = @_;

            my $result = [];

            unless ($member) {
                $member = $c->getSessionValue("member.id");
            }

            my @rules;

            if (ref $terms eq "ARRAY") {
                @rules = @$terms;
            } else {
                push @rules, $terms;
            }

            for (my $i=0; $i <= $#rules; $i++) {
                my ($term, $area) = split /:/, $rules[$i];
                if ($area eq "*") {
                    splice @rules, $i, $i, "$term:member", "$term:group";
                }
            }

            my %seen;
            @rules = grep { ! $seen{$_}++ } @rules;

            if (@rules && $member) {
                $result = $c->sql->Q("
                    SELECT childrens FROM cache_visibility WHERE member=? AND term = ANY(?)
                ", [ $member, \@rules ])->Value();
            }

            return $result || [];
        } );
}

1;
