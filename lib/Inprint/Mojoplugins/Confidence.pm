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
        objectBindings => sub {
            my ($c, $input, $member) = @_;
            unless ($member) {
                $member = $c->getSessionValue("member.id");
            }
            my $terms  = _parseTerms($c, $input);
            my $nodes = _getNodes($c, $terms, $member);
            return $nodes;
        } );

    $app->helper(

        objectAccess2 => sub {

            my ($c, $input, $binding, $member) = @_;

            unless ($member) {
                $member = $c->getSessionValue("member.id");
            }

            my $terms = _parseTerms($c, $input);

            foreach my $rule (@$terms) {

                my ($rulestring, $area) = split /:/, $rule;
                my ($section, $subsection, $term) = split /\./, $rulestring;

                #die "$section, $subsection, $term $area";

                #$c->dbh()->{pg_placeholder_dollaronly} = 1;
                #$c->dbh()->{pg_placeholder_dollaronly} = 0;

                my $sql = "SELECT binding FROM map_member_to_rule as mapper WHERE 1=1
                    AND mapper.termkey = \$1 AND member = \$2";
                my @params = ($rule, $member);

                if ($binding) {
                    $sql .= " AND binding=\$3 ";
                    push @params, $binding;
                }

                my $bindings = $c->Q($sql, \@params)->Values;

                ## Domain
                #if ($section eq "domain") {
                #    return 1 if @$bindings;
                #}

                # Editions
                if ($section eq "editions") {

                #    if ($area eq "edition") {
                #        return 1 if @$bindings;
                #    }

                #    if ($area eq "editions") {

                #        $c->dbh()->{pg_placeholder_dollaronly} = 1;
                #
                #        my $subsql = "
                #            SELECT EXISTS (
                #                SELECT true FROM editions WHERE path ? ARRAY(
                #                    SELECT ('*.' || replace(binding::text, '-', '')::text ||'.*')::lquery
                #                    FROM map_member_to_rule as mapper WHERE 1=1
                #                        AND mapper.termkey = \$1 AND member = \$2 ) ";
                #
                #        my @subparams = ( $rule, $member );
                #
                #        if ($binding) {
                #            $subsql .= " AND path ~ ('*.' || replace(\$3, '-', '')::text ||'.*')::lquery ";
                #            push @subparams, $binding;
                #        }

                #        $subsql .= " ) ";

                #        my $exists = $c->Q($subsql, \@subparams)->Value;
                #        $c->dbh()->{pg_placeholder_dollaronly} = 0;
                #
                #        return 1 if $exists;
                #    }
                }

                # Catalog
                if ($section eq "catalog") {

                    # Select all catalog items for this binding

                    my $bindobj = $c->Q("
                         SELECT * FROM catalog WHERE id = ? ",
                         [ $binding ])->Hash;

                    my $routes = $c->Q("
                        SELECT * FROM catalog
                        WHERE
                            path @> ? OR  path <@ ?"
                        , [ $bindobj->{path}, $bindobj->{path} ])->Values;

                    foreach (@$routes) {
                        setCacheRecord($c, $member, $_, $rule, 0);
                    }

                    $c->dbh()->{pg_placeholder_dollaronly} = 1;

                    my $subsql;

                    if ($area eq "member") {
                        $subsql = "
                            SELECT catalog.id FROM catalog, map_member_to_rule as mapper
                            WHERE 1=1
                                AND catalog.id = mapper.binding
                                AND mapper.termkey = \$1 AND member = \$2 ";
                    }

                    if ($area eq "group") {
                        $subsql = "
                            SELECT id FROM catalog WHERE path ? ARRAY(
                                SELECT ('*.' || replace(binding::text, '-', '')::text ||'.*')::lquery
                                FROM map_member_to_rule as mapper WHERE 1=1
                                    AND mapper.termkey = \$1 AND member = \$2 ) ";
                    }

                    my @subparams = ( $rule, $member );

                    if ($binding) {
                        $subsql .= " AND path ~ ('*.' || replace(\$3, '-', '')::text ||'.*')::lquery ";
                        push @subparams, $binding;
                    }

                    my $items = $c->Q($subsql, \@subparams)->Values;

                    $c->dbh()->{pg_placeholder_dollaronly} = 0;

                    foreach (@$items) {
                        setCacheRecord($c, $member, $_, $rule, 1);
                    }

                    return 1 if (@$items);
                }

            }

            return 0;
        } );

    $app->helper(

        objectAccess => sub {

            my ($c, $input, $binding, $member) = @_;

            unless ($member) {
                $member = $c->getSessionValue("member.id");
            }

            my $terms = _parseTerms($c, $input);

            foreach my $rule (@$terms) {

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

    $app->helper(
        objectChildren => sub {

            my ($c, $input, $table, $node, $member) = @_;

            unless ($member) {
                $member = $c->getSessionValue("member.id");
            }

            my $terms = _parseTerms($c, $input);
            my $nodes = _getNodes($c, $terms, $member);

            my $result = $c->Q("
                    SELECT id FROM $table
                    WHERE 1=1
                        AND path @> ARRAY( SELECT path FROM editions WHERE id = \$1 )
                        AND id = ANY(\$2) ",
                [ $node, $nodes ])->Values;

            return $result;
        } );

}

# The additional Functions

sub _parseTerms {

    my ($c, $input) = @_;

    my @rules;

    if (ref $input eq "ARRAY") {
        @rules = @$input;
    } else {
        push @rules, $input;
    }

    my $terms = [];

    for (my $i=0; $i <= $#rules; $i++) {

        my ($terstring, $area) = split /:/, $rules[$i];

        my ($section, $subsection, $term) = split /\./, $terstring;

        if ($section eq "domain") {
            push @$terms, "$terstring:domain";
        }

        if ($section eq "editions") {
            if ($area eq "*") {
                push @$terms, "$terstring:edition";
                push @$terms, "$terstring:editions";
            } else {
                push @$terms, "$terstring:$area";
            }
        }

        if ($section eq "catalog") {
            if ($area eq "*") {
                push @$terms, "$terstring:member";
                push @$terms, "$terstring:group";
            } else {
                push @$terms, "$terstring:$area";
            }
        }

    }

    my %seen;
    @$terms = grep { ! $seen{$_}++ } @$terms;

    return $terms;
}

sub setCacheRecord {
    my ($c, $member, $binding, $termkey, $enabled) = @_;

    $c->Do("
           DELETE FROM cache_access WHERE member=? AND binding =? AND termkey=? ",
           [ $member, $binding, $termkey ]);

    $c->Do("
           INSERT INTO cache_access (member, binding, termkey, enabled)
           VALUES (?,?,?,?)",
           [ $member, $binding, $termkey, $enabled ]);

}

sub getCacheRecord {
    my ($c, $rule, $binding, $member);
}

sub delCacheRecord {
    my ($c, $rule, $binding, $member);
}

sub _getNodes {

    my ($c, $terms, $member) = @_;

    my $result = [];

    foreach my $rule (@$terms) {

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
            push @$result, $_;
        }

    }

    my %seen;
    @$result = grep { ! $seen{$_}++ } @$result;

    return $result;
}

1;
