package Inprint::Frameworks::SQL;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use utf8;

use Inprint::Frameworks::SQLQuery;

sub new {
    my $class = shift;
    my $self  = {};
    $self     = bless {}, $class;

    $self->{DBH} = undef;
    $self->{conn} = undef;
    $self->{trace} = undef;

    bless($self, $class);
    return $self;
}

sub SetConnection {
    my $c = shift;
    $c->{conn} = shift;
}

sub SetDBH {
    my $c = shift;
    $c->{DBH} = shift;
}

sub Q {
    my $c = shift;
    
    my $query = shift;
    my $value = shift;
    my $trace = shift;

    $trace = 1;

    return new Inprint::Frameworks::SQLQuery($c->{conn}, $query, $value, $trace);
}

sub Do {
    my $c = shift;
    
    my $query = shift;
    my $value = shift;
    my $trace = shift;
    
    my $count = $c->{conn}->dbh->do($query, undef, @{$value});
    say STDERR $c->{conn}->dbh->{Statement} if $trace;
    
    return 0 if $count eq '0E0';
    return $count;
}

#Utils

sub ArrayToString 
{
   my $class = shift;
   my $array = shift;
   my $string;
   
   $string = join("','", @$array );
   $string = "'$string'";
   
   return $string;
}

sub trace {
    my $c = shift;
    my $mode  = shift || 'on';
    say STDERR "SQL TRACE MODE $mode";
    $c->{trace} = defined if lc($mode) eq 'on';
    $c->{trace} = undef   if lc($mode) eq 'off';
}

sub lock_table {
    my $c  = shift;
    my $table  = shift;
    my $access = shift || 'EXCLUSIVE MODE';
    say STDERR "LOCK TABLE $table IN ACCESS $access;" if ( $c->{trace} );
    $c->Do({ query => "LOCK TABLE $table IN ACCESS $access;" });
}

sub start_t{
    my $c = shift;
    say STDERR "BEGIN;" if ( $c->{trace} );
    $c->{DBH}->begin_work;
}

sub rollback_t {
    my $c = shift;
    say STDERR "ROLLBACK;" if ( $c->{trace} );
    $c->{DBH}->rollback;
}

sub stop_t {
    my $c = shift;
    say STDERR "COMMIT;" if ( $c->{trace} );
    $c->{DBH}->commit;
}

1;