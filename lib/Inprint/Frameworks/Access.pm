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
    
    $c->{handler}->{SessionRules} = $c->{handler}->sql->Q("
        SELECT t2.id, t2.section ||'.'|| t2.subsection ||'.'|| t2.term as term, t1.member, t1.area, t1.binding, ARRAY( select id from editions where path @> ( select path from editions where id=t1.binding) ) as path
        FROM map_member_to_rule t1, rules t2
        WHERE t1.section = 'editions' AND t2.id = t1.term
            AND t1.member=?
        
        UNION 
        
        SELECT t2.id, t2.section ||'.'|| t2.subsection ||'.'|| t2.term as term, t1.member, t1.area, t1.binding, ARRAY( select id from catalog where path @> ( select path from catalog where id=t1.binding) ) as path
        FROM map_member_to_rule t1, rules t2
        WHERE t1.section = 'catalog' AND t2.id = t1.term
            AND t1.member=?
        
        UNION 
        
        SELECT t2.id, t2.section ||'.'|| t2.subsection ||'.'|| t2.term as term, t1.member, t1.area, t1.binding, ARRAY['00000000-0000-0000-0000-000000000000'::uuid] as path
        FROM map_member_to_rule t1, rules t2
        WHERE t1.section = 'domain' AND t2.id = t1.term
            AND t1.member=?
    ", [
        $c->{handler}->QuerySessionGet("member.id"),
        $c->{handler}->QuerySessionGet("member.id"),
        $c->{handler}->QuerySessionGet("member.id")
    ])->Hashes;
    
    return $c;
}

sub One {
    my $c = shift;
    my $term = shift;
    
    
    
}

sub In {
    my $c = shift;
    my $term = shift;
    my $path = shift;
    
    return undef unless $term;
    
    foreach my $rule (@{ $c->{handler}->{SessionRules} }) {
        if ( $rule->{term} eq "domain.control.all") {
            #die @{ $rule->{path} }
        }
    }
}


1;
