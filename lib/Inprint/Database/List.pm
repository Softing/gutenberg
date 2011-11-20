package Inprint::Database::List;

use utf8;
use strict;
use warnings;

use Moose;

use MooseX::Storage;
with Storage( 'format' => 'JSON' );

use MooseX::UndefTolerant;

has "app"       => (isa => "Object",   is => "rw", metaclass => "DoNotSerialize" );
has "sql"       => (isa => "Object",   is => "rw", metaclass => 'DoNotSerialize',);
has "records"   => (isa => "ArrayRef", default => sub { [] }, is => "rw", metaclass => 'DoNotSerialize',);

sub BUILD {
    my ($self) = @_;
    $self->sql($self->app->sql);
    return $self;
}

sub json {
    my ($self) = @_;

    my @array;

    foreach my $record (@{ $self->records }) {
        push @array, $record->json;
    }

    return \@array;
}

sub _makeColumnsList {
    my ($self, $columns) = @_;

    my @result;

    foreach (@$columns) {
        if ($_ =~ /(.*?)::date$/) {
            $_ = "to_char($1,'YYYY-MM-DD HH24:MI:SS') as $1";
        }
        push @result, $_;
    }

    return join ",", @result;
}

1;
