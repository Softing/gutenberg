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
    
    $self->{rules} = $c->sql->Q(" SELECT edition || '::' || regulation FROM passport.member_regulation WHERE member=? ",
        [ $c->session("uid") ]
    )->Values;
    
    bless($self, $class);
    return $self;
}

sub In {
    my $c = shift;
    
    my @a = qw( 1 2 3 4 5 6 );
    my @b = qw( 1 3 6 );

    my %seen; # lookup table
    my @only;# answer
    
    @seen{@b} = ();
    foreach my $item (@a) {
        push(@only, $item) if exists $seen{$item};
    }
    
    return defined if @only;
}


1;
