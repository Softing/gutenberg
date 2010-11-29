package Inprint::Utils::FileAttributes;
use strict;
use warnings;

use YAML;
use File::Spec;

our $VERSION = '0.04';

sub _load {
    my $self = shift;
    my $file = shift;
    my $attrfile = $self->_attribute_file($file);
    
    my $data = LoadFile($attrfile);
    return $data;
}

sub _save {
    my $self = shift;
    my $file = shift;
    my $data = shift;
    my $attrfile = $self->_attribute_file($file);

    if(!scalar keys %$data){
        unlink $attrfile;
    }
    else {
        DumpFile($attrfile, $data);
    }
}

sub list {
    my $self = shift;
    my $file = shift;
    my $data = {};

    eval {
        $data = $self->_load($file);
    };

    return keys %{$data};
}

sub get {
    my $self = shift;
    my $file = shift;
    my $attr = shift;
    my $data = $self->_load($file);
    
    return $data->{$attr};
}

sub set {
    my $self  = shift;
    my $file  = shift;
    my $key   = shift;
    my $value = shift;

    my $data = {};
    
    eval {
        $data = $self->_load($file);
    };
    
    $data->{$key} = $value;
    $self->_save($file, $data);
    return 1;
}

sub unset {
    my $self = shift;
    my $file = shift;
    my $key  = shift;
    
    my $data = {};
    eval {
        $data = $self->_load($file);
    };
    
    delete $data->{$key};
    $self->_save($file, $data);
    return 1;
}

sub set_attributes {
    my $file  = shift;
    my $first = shift;

    # if someone passes a hashref instead, handle that nicely
    my %attributes;
    if(ref $first){
        %attributes = %{$first};
    }
    else {
    %attributes = ($first, @_);
    }    
    
    foreach my $key (keys %attributes){
        set_attribute($file, $key, $attributes{$key});
    }
}

sub get_attributes {
    my $file = shift;
    my @attributes = list_attributes($file);
    my %result;
    foreach my $attribute (@attributes){
        $result{$attribute} = get_attribute($file, $attribute);
    }
    return %result;
}

1;