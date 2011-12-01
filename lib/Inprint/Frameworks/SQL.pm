package Inprint::Frameworks::SQL;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use utf8;

use Inprint::Frameworks::SQLQuery;

sub new {
    my $class = shift;
    my $self  = {};
    $self     = bless {}, $class;

    $self->{app}   = shift;
    $self->{conn}  = shift;
    $self->{trace} = undef;

    bless($self, $class);
    return $self;
}

sub app {
    return shift->{app};
}

sub conn {
    return shift->{conn};
}

sub Q {
    my $self = shift;

    my $query   = shift;
    my $value   = shift;
    my $trace   = shift;

    unless (ref($value) eq "ARRAY") {
        $value = [ $value ] if $value;
    }

    return new Inprint::Frameworks::SQLQuery($self->app, $self->conn, $query, $value, $trace);
}

sub Do {
    my $self = shift;

    my $query = shift;
    my $value = shift;
    my $trace = shift;

    unless (ref($value) eq "ARRAY") {
        $value = [ $value ] if $value;
    }

    my $count = $self->conn->dbh->do($query, undef, @{$value});
    say STDERR $self->conn->dbh->{Statement} if $trace;

    return 0 if $count eq '0E0';
    return $count;
}

#Utils

sub ArrayToString
{
   my $self = shift;
   my $array = shift;
   my $string;

   $string = join("','", @$array );
   $string = "'$string'";

   return $string;
}

sub trace {
    my $self = shift;
    my $mode  = shift || 'on';
    say STDERR "SQL TRACE MODE $mode";
    $self->{trace} = defined if lc($mode) eq 'on';
    $self->{trace} = undef   if lc($mode) eq 'off';
}

#sub lock_table {
#    my $self  = shift;
#    my $table  = shift;
#    my $access = shift || 'EXCLUSIVE MODE';
#    say STDERR "LOCK TABLE $table IN ACCESS $access;" if ( $self->{trace} );
#    $self->Do({ query => "LOCK TABLE $table IN ACCESS $access;" });
#}

sub bt{
    my $self = shift;
    say STDERR "BEGIN;" if ( $self->{trace} );
    $self->conn->dbh->begin_work;
}

sub rt {
    my $self = shift;
    say STDERR "ROLLBACK;" if ( $self->{trace} );
    $self->conn->dbh->rollback;
}

sub et {
    my $self = shift;
    say STDERR "COMMIT;" if ( $self->{trace} );
    $self->conn->dbh->commit;
}

1;
