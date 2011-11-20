#package Inprint::Database::Base;
#
#use utf8;
#use strict;
#use warnings;
#
#use Moose;
#
#use Inprint::Utils::MooseUUID qw(UUID);
#use MooseX::Storage; with Storage( 'format' => 'JSON' );
#
#has "app"   => (isa => "Object",   is => "rw", metaclass => 'DoNotSerialize',);
#has "sql"   => (isa => "Object",   is => "rw", metaclass => 'DoNotSerialize',);
#
#sub BUILD {
#    my ($self) = @_;
#    $self->sql($self->app->sql);
#    return $self;
#}
#
#sub json {
#    my ($self) = @_;
#
#    my $hash = {};
#
#    foreach my $column ($self->COLUMNS) {
#        $hash->{$column} = $self->$column;
#    }
#
#    return $hash;
#}
#
#1;
