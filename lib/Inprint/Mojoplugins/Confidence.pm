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
                my ($terstring, $area) = split /:/, $rules[$i];
                my ($section, $subsection, $term) = split /\./, $terstring;

                if ($section eq "domain" && !$area) {
                    $rules[$i] = "$terstring:domain";
                }

                if ($section eq "editions") {
                    if ($area eq "*") {
                        splice @rules, $i, $i, "$terstring:edition", "$terstring:editions";
                    }
                }
                if ($section eq "catalog") {
                    if ($area eq "*") {
                        splice @rules, $i, $i, "$terstring:member", "$terstring:group";
                    }
                }
            }

            my %seen;
            @rules = grep { ! $seen{$_}++ } @rules;

            foreach my $rule (@rules) {

                my ($rulestring, $area) = split /:/, $rule;
                my ($section, $subsection, $term) = split /\./, $rulestring;

                $c->dbh()->{pg_placeholder_dollaronly} = 1;

                my $sql = "SELECT binding FROM map_member_to_rule as mapper WHERE 1=1
                    AND mapper.termkey = \$1 AND member = \$2";
                my @params = ($rule, $member);

                $c->dbh()->{pg_placeholder_dollaronly} = 0;

                if ($binding) {
                    $sql .= " AND binding=\$3 ";
                    push @params, $binding;
                }

                my $bindings = $c->Q($sql, \@params)->Values;

                # Domain
                if ($section eq "domain") {
                    return 1 if @$bindings;
                }

                # Editions
                if ($section eq "editions") {

                    if ($area eq "edition") {
                        return 1 if @$bindings;
                    }

                    if ($area eq "editions") {

                        $c->dbh()->{pg_placeholder_dollaronly} = 1;

                        my $subsql = "
                            SELECT EXISTS (
                                SELECT true FROM editions WHERE path ? ARRAY(
                                    SELECT ('*.' || replace(binding::text, '-', '')::text ||'.*')::lquery
                                    FROM map_member_to_rule as mapper WHERE 1=1
                                        AND mapper.termkey = \$1 AND member = \$2 ) ";

                        my @subparams = ( $rule, $member );

                        if ($binding) {
                            $subsql .= " AND path ~ ('*.' || replace(\$3, '-', '')::text ||'.*')::lquery ";
                            push @subparams, $binding;
                        }

                        $subsql .= " ) ";

                        my $exists = $c->Q($subsql, \@subparams)->Value;
                        $c->dbh()->{pg_placeholder_dollaronly} = 0;

                        return 1 if $exists;
                    }
                }

                # Catalog
                if ($section eq "catalog") {

                    $c->dbh()->{pg_placeholder_dollaronly} = 1;

                    my $subsql = "
                        SELECT EXISTS (
                            SELECT true FROM catalog WHERE path ? ARRAY(
                                SELECT ('*.' || replace(binding::text, '-', '')::text ||'.*')::lquery
                                FROM map_member_to_rule as mapper WHERE 1=1
                                    AND mapper.termkey = \$1 AND member = \$2 ) ";

                    my @subparams = ( $rule, $member );

                    if ($binding) {
                        $subsql .= " AND path ~ ('*.' || replace(\$3, '-', '')::text ||'.*')::lquery ";
                        push @subparams, $binding;
                    }

                    $subsql .= " ) ";

                    my $exists = $c->Q($subsql, \@subparams)->Value;
                    $c->dbh()->{pg_placeholder_dollaronly} = 0;

                    return 1 if ($exists);
                }

            }

            return 0;
        } );

        #    my ($c, $terms, $binding, $member) = @_;
        #
        #    my @rules;
        #    my $result = 0;
        #
        #    unless ($member) {
        #        $member = $c->getSessionValue("member.id");
        #    }
        #
        #    if (ref $terms eq "ARRAY") {
        #        @rules = @$terms;
        #    } else {
        #        push @rules, $terms;
        #    }
        #
        #    for (my $i=0; $i <= $#rules; $i++) {
        #        my ($terstring, $area) = split /:/, $rules[$i];
        #        my ($section, $subsection, $term) = split /\./, $terstring;
        #        if ($section eq "editions") {
        #            if ($area eq "*") {
        #                splice @rules, $i, $i, "$terstring:edition", "$terstring:editions";
        #            }
        #        }
        #        if ($section eq "catalog") {
        #            if ($area eq "*") {
        #                splice @rules, $i, $i, "$terstring:member", "$terstring:group";
        #            }
        #        }
        #    }
        #
        #    my %seen; @rules = grep { ! $seen{$_}++ } @rules;
        #
        #    if ($member && @rules) {
        #
        #        my @data;
        #
        #        my $sql = " SELECT true FROM cache_access WHERE member=? AND ? && terms ";
        #        push @data, $member;
        #        push @data, \@rules;
        #
        #        if ($binding) {
        #            $sql .= " AND binding=?";
        #            push @data, $binding;
        #        }
        #
        #        $result = $c->sql->Q("SELECT EXISTS ($sql)", \@data)->Value();
        #    }
        #
        #    return $result;
        #} );

        #$app->helper(
        #    objectDirectAccess => sub {
        #        my ($c, $terms, $binding, $member) = @_;
        #
        #        my @rules;
        #        my $result = 0;
        #
        #        unless ($member) {
        #            $member = $c->getSessionValue("member.id");
        #        }
        #
        #        if (ref $terms eq "ARRAY") {
        #            @rules = @$terms;
        #        } else {
        #            push @rules, $terms;
        #        }
        #
        #        my %seen; @rules = grep { ! $seen{$_}++ } @rules;
        #
        #        if ($member && @rules) {
        #
        #            my @data;
        #
        #            my $sql = "
        #                SELECT true
        #                FROM map_member_to_rule mapper
        #                WHERE member=? AND termkey = ANY(?) ";
        #            push @data, $member;
        #            push @data, \@rules;
        #
        #            if ($binding) {
        #                $sql .= " AND binding=?";
        #                push @data, $binding;
        #            }
        #
        #            $result = $c->sql->Q("SELECT EXISTS ($sql)", \@data)->Value();
        #        }
        #
        #        return $result;
        #    } );

    $app->helper(
        objectBindings => sub {

            my ($c, $terms, $member) = @_;

            my @result;

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
                my ($terstring, $area) = split /:/, $rules[$i];
                my ($section, $subsection, $term) = split /\./, $terstring;
                if ($section eq "editions") {
                    if ($area eq "*") {
                        splice @rules, $i, $i, "$terstring:edition", "$terstring:editions";
                    }
                }
                if ($section eq "catalog") {
                    if ($area eq "*") {
                        splice @rules, $i, $i, "$terstring:member", "$terstring:group";
                    }
                }
            }

            my %seen;
            @rules = grep { ! $seen{$_}++ } @rules;

            foreach my $rule (@rules) {

                my $bindings = [];

                my ($rulestring, $area) = split /:/, $rule;
                my ($section, $subsection, $term) = split /\./, $rulestring;

                $c->dbh()->{pg_placeholder_dollaronly} = 1;

                # Editions
                if ($section eq "editions") {
                    if ($area eq "edition") {
                        $bindings = $c->Q("
                            SELECT binding FROM map_member_to_rule as mapper WHERE 1=1
                                AND mapper.termkey = \$1
                                AND member = \$2 "
                        , [ $rule, $member ] )->Values;

                    }
                    if ($area eq "editions") {
                        $bindings = $c->Q("
                            SELECT id FROM editions WHERE path ? ARRAY(
                                SELECT ('*.' || replace(binding::text, '-', '')::text ||'.*')::lquery
                                FROM map_member_to_rule as mapper WHERE 1=1
                                    AND mapper.termkey = \$1 AND member = \$2 ) "
                        , [ $rule, $member ] )->Values;

                    }
                }

                # Catalog
                if ($section eq "catalog") {
                        $bindings = $c->Q("
                            SELECT id FROM catalog WHERE path ? ARRAY(
                                SELECT ('*.' || replace(binding::text, '-', '')::text ||'.*')::lquery
                                FROM map_member_to_rule as mapper WHERE 1=1
                                    AND mapper.termkey = \$1 AND member = \$2 ) "
                        , [ $rule, $member ] )->Values;
                }

                $c->dbh()->{pg_placeholder_dollaronly} = 0;


                foreach (@$bindings) {
                    push @result, $_;
                }

            }

            my %seen2;
            @result = grep { ! $seen2{$_}++ } @result;

            return \@result;
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
