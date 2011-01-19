package Inprint::Frameworks::Access;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use utf8;

use Inprint::Frameworks::AccessQuery;

sub new {
    my $class = shift;
    my $c = shift;
    my $self     = bless {}, $class;
    bless($self, $class);
    return $self;
}

sub SetHandler {
    my $c = shift;
    my $handler = shift;
    $c->{handler} = $handler;
}

sub ExtractRules {
    my $c = shift;
    return $c;
}

sub Check {
    my $c = shift;
    my $terms   = shift;
    my $binding = shift;
    my $member  = shift;

    my @rules;
    my $result = 0;

    unless ($member) {
        $member = $c->{handler}->QuerySessionGet("member.id");
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
    my %seen;@rules = grep { ! $seen{$_}++ } @rules;

    #die $member;

    if ($member && @rules) {
        my @data;
        my $sql = " SELECT true FROM cache_access WHERE member=? AND ? && terms ";
        push @data, $member;
        push @data, \@rules;
        if ($binding) {
            $sql .= " AND binding=?";
            push @data, $binding;
        }

        $result = $c->{handler}->sql->Q("SELECT EXISTS ($sql)", \@data)->Value();
    }

    return $result;
}

sub GetBindings {

    my $c = shift;
    my $terms    = shift;
    my $member  = shift;

    my $result = [];

    unless ($member) {
        $member = $c->{handler}->QuerySessionGet("member.id");
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
        $result = $c->{handler}->sql->Q("
            --SELECT parents || childrens FROM cache_visibility WHERE member=? AND term = ANY(?)
            --SELECT binding from cache_access where member = ? AND terms @> ?
            SELECT t1.binding FROM cache_access t1
            WHERE t1.member = ? AND ?::text[] && t1.terms;
        ", [ $member, \@rules ])->Values();
    }

    return $result || [];
}

sub GetChildrens {

    my $c = shift;
    my $terms    = shift;
    my $member  = shift;

    my $result = [];

    unless ($member) {
        $member = $c->{handler}->QuerySessionGet("member.id");
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
        $result = $c->{handler}->sql->Q("
            SELECT childrens FROM cache_visibility WHERE member=? AND term = ANY(?)
        ", [ $member, \@rules ])->Value();
    }

    return $result || [];
}

1;
