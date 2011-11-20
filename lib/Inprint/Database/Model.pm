package Inprint::Database::Model;

use utf8;
use strict;
use warnings;

use Moose;

use MooseX::Storage;
with Storage( 'format' => 'JSON' );

use MooseX::UndefTolerant;

has "app" => (isa => "Object",   is => "rw", metaclass => "DoNotSerialize" );
has "sql" => (isa => "Object",   is => "rw", metaclass => "DoNotSerialize" );

sub BUILD {
    my ($self) = @_;
    $self->sql($self->app->sql);
    return $self;
}

sub load {

    my ($self, %args) = @_;

    die "Bad id for ". $self->ID . " <$args{id}>" unless $args{id};

    my $hash = $self->sql->Q(" SELECT * FROM ". $self->TABLE ." WHERE id=? ", $args{id})->Hash;

    die "Cant find ". $self->ID . " <$args{id}>" unless $hash->{id};

    while (my ($k, $v) = each %$hash) {
        if (my $attr = $self->meta->find_attribute_by_name($k)) {
            $attr->set_value($self, $v) if defined $v;
        }
    }

    return $self;
}

sub map {

    my ($self, $record) = @_;

    die "Bad id for ". $self->ID . " <$record->{id}>" unless $record->{id};

    while (my ($k, $v) = each %$record) {
        if (my $attr = $self->meta->find_attribute_by_name($k)) {
            $attr->set_value($self, $v) if defined $v;
        }
    }

    return $self;
}

sub json {
    my ($self) = @_;

    my $hash = {};

    foreach my $item ($self->COLUMNS) {
        my ($column, $behaviour) = split "::", $item;
        if ($self->meta->find_attribute_by_name($column)) {
            $hash->{$column} = $self->$column;
        }
    }

    foreach my $item ($self->FIELDS) {
        my ($column, $behaviour) = split "::", $item;
        if ($self->meta->find_attribute_by_name($column)) {
            $hash->{$column} = $self->$column;
        }
    }

    return $hash;
}

1;
