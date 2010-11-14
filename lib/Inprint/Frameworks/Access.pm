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
    my $term    = shift;
    my $binding = shift;
    my $member  = shift;
    
    my $result = 0;
    
    unless ($member) {
        $member = $c->{handler}->QuerySessionGet("member.id");
    }
    
    if ($member && $term) {
        
        my @data;
        
        my $sql = "
            SELECT true FROM cache_access WHERE
                member=? AND ? = ANY(terms)
        ";
        
        push @data, $member;
        push @data, $term;
        
        if ($binding) {
            $sql .= " AND binding=?";
            push @data, $binding;
        }
        
        $result = $c->{handler}->sql->Q("
            SELECT EXISTS ($sql)", \@data)->Value();
    }
    
    return $result;
}

sub GetBindings {
    
    my $c = shift;
    my $term    = shift;
    my $member  = shift;
    
    my $result = [];
    
    unless ($member) {
        $member = $c->{handler}->QuerySessionGet("member.id");
    }
    
    if ($term && $member) {
        $result = $c->{handler}->sql->Q("
            SELECT parents FROM cache_visibility WHERE member=? AND term=? 
        ", [ $member, $term ])->Value();
    }
    
    return $result || [];
}

1;