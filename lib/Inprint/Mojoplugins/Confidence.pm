package Inprint::Mojoplugins::Confidence;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use warnings;
use strict;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.02';

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

        objectAccess => sub {

            my ($c, $input, $binding, $member) = @_;

            undef my $granted;

            unless ($member) {
                $member = $c->getSessionValue("member.id");
            }

            my $terms = _prepareTerms($c, $input);

            # Get rules from cache
            foreach my $term (@$terms) {
                $granted = getCacheRecord($c, $member, $binding, $term);

                if ($granted == 1 || $granted == 0) {
                    return $granted;
                }
            }

            $granted = 0;

            my $rules = _parseTerms($c, $terms);

            foreach my $rule (@$rules) {

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
                    if (@$bindings) {
                        $granted = 1;
                        last;
                    }
                }

                # Editions
                if ($section eq "editions" && $area eq "edition") {
                    if (@$bindings) {
                        $granted = 1;
                        last;
                    }
                }

                # Editions recursive
                if ($section eq "editions" && $area eq "editions") {

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

                    if ($exists) {
                        $granted = 1;
                        last;
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

                    if ($exists) {
                        $granted = 1 ;
                        last;
                    }

                }

            }

            # Save rules to cache
            foreach my $term (@$terms) {
                setCacheRecord($c, $member, $binding, $term, $granted);
            }

            return $granted;
        } );

    $app->helper(

        objectChildren => sub {

            my ($c, $table, $id, $term, $member) = @_;

            unless ($member) {
                $member = $c->getSessionValue("member.id");
            }

            my $sql = "
                SELECT id FROM $table
                WHERE path ~ ('*.' || replace(\$1, '-', '')::text ||'.*')::lquery  ";

            my @params = ( $id );

            my $childrens = $c->Q($sql, \@params)->Values;
            my $nodes = $c->objectBindings("editions.template.manage:*");

            my %isect;
            my %inion;

            foreach my $e (@$nodes, @$childrens) {$inion{$e}++ && $isect{$e}++;}
            my @result = keys %isect;

            return \@result;
        } );

    $app->helper(

        objectParents => sub {

            my ($c, $table, $id, $term, $member) = @_;

            unless ($member) {
                $member = $c->getSessionValue("member.id");
            }

            my $terms = _parseTerms($c, $term);
            my $nodes = _getNodes($c, $terms, $member);

            my $result = $c->Q("
                SELECT id FROM $table
                WHERE 1=1
                    AND path @> ARRAY( SELECT path FROM editions WHERE id = \$1 )
                    AND id = ANY(\$2) ",
                    [ $id, $nodes ])->Values;

            return $result;
        } );

}

# The additional Functions

sub setCacheRecord {
    my ($c, $member, $binding, $termkey, $enabled) = @_;

    unless ($binding) {
        $binding = '00000000-0000-0000-0000-000000000000';
    }

    $c->Do("
           DELETE FROM cache_access WHERE member=? AND binding =? AND termkey=? ",
           [ $member, $binding, $termkey ]);

    $c->Do("
           INSERT INTO cache_access (member, binding, termkey, enabled)
           VALUES (?,?,?,?)",
           [ $member, $binding, $termkey, $enabled ]);

}

sub getCacheRecord {
    my ($c, $member, $binding, $termkey) = @_;

    unless ($binding) {
        $binding = '00000000-0000-0000-0000-000000000000';
    }

    my $granted = $c->Q("
           SELECT enabled FROM cache_access WHERE member=? AND binding=? AND termkey=? ",
           [ $member, $binding, $termkey ])->Value;

    unless (defined $granted) {
        $granted = -1;
    }

    return $granted;
}

sub delCacheRecord {
    my ($c, $member, $binding) = @_;

    $c->Do("
           DELETE FROM cache_access WHERE member=? AND binding=? ",
           [ $member, $binding ]);

    return 0;
}

sub _prepareTerms {
   my ($c, $input) = @_;

    my @rules;

    if (ref $input eq "ARRAY") {
        @rules = @$input;
    } else {
        push @rules, $input;
    }

    return \@rules;
}

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
