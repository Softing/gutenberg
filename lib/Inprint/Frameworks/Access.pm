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

sub One {
    my $c = shift;
    my $term    = shift;
    my $binding = shift;
    my $member  = shift;
    
    my $result = 0;
    
    my ($section, $subsection, $action) = split /\./, $term;
    
    unless ($member) {
        $member = $c->{handler}->QuerySessionGet("member.id");
    }
    
    if ($section && $subsection && $action && $member) {
        
        my @data;
        
        my $sql = "
            SELECT count(*) FROM view_rules WHERE
                section=? AND subsection=? AND term=? AND member=?
        ";
        
        push @data, $section;
        push @data, $subsection;
        push @data, $action;
        push @data, $member;
        
        if ($binding) {
            $sql .= " AND (binding=? OR ? = ANY (childrens)) ";
            push @data, $binding;
            push @data, $binding;
        }
        
        $result = $c->{handler}->sql->Q($sql, \@data)->Value();
    }
    
    return $result;
}

sub GetBindingsByTerm {
    
    my $c = shift;
    my $term    = shift;
    my $member  = shift;
    
    my $result = [];
    
    unless ($member) {
        $member = $c->{handler}->QuerySessionGet("member.id");
    }
    
    my ($section, $subsection, $action) = split /\./, $term;
    
    if ($section && $subsection && $action) {
        
        my $termid = $c->{handler}->sql->Q("
            SELECT id FROM rules WHERE section =? AND subsection=? AND term=? LIMIT 1
        ", [$section, $subsection, $action])->Value;
        
        if ($termid) {
            $result = $c->{handler}->sql->Q("
                SELECT binding FROM map_member_to_rule
                WHERE member=? AND term=? 
            ", [ $member, $termid ])->Values();
        }
    }
    
    return $result;
}

sub GetEditionsByTerm {
    
    my $c = shift;
    my $term    = shift;
    my $member  = shift;
    
    my $result = [];
    
    unless ($member) {
        $member = $c->{handler}->QuerySessionGet("member.id");
    }
    
    my ($section, $subsection, $action) = split /\./, $term;
    
    if ($section && $subsection && $action) {
        
        my $termid = $c->{handler}->sql->Q("
            SELECT id FROM rules WHERE section =? AND subsection=? AND term=? LIMIT 1
        ", [$section, $subsection, $action])->Value;
        
        if ($termid) {
            $result = $c->{handler}->sql->Q("
                SELECT t1.id FROM editions t1
                WHERE
                (
                    ARRAY(SELECT editions.id FROM editions WHERE editions.path ~ ((t1.path::text || '.*'::text)::lquery)) 
                    &&
                    ARRAY(select binding from map_member_to_rule where member=? and term=? )
                )
            ", [ $member, $termid ])->Values();
        }
    }
    
    return $result;
}

1;