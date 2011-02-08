package Inprint::Check;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Inprint::BaseController';

sub exists {
    my ($c, $errors, $field, $value) = @_;
    unless (length($value) > 0) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }
    return 1;
}

sub uuid {
    my ($c, $errors, $field, $value) = @_;
    unless (length($value) > 0 && $value =~ m/^[a-z|0-9]{8}(-[a-z|0-9]{4}){3}-[a-z|0-9]{12}+$/) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }
    return 1;
}

sub date {
    my ($c, $errors, $field, $value) = @_;
    unless (length($value) > 0 && $value =~ m/^[0-9]{4}-[0-9]{2}-[0-9]{2}+$/) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }
    return 1;
}

sub int {
    my ($c, $errors, $field, $value) = @_;
    unless (length($value) > 0 && $value =~ m/^\-?[\d]+$/) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }
    return 1;
}

sub float {
    my ($c, $errors, $field, $value) = @_;
    unless (length($value) > 0 && $value =~ m/^(\d{1,7}|(\d{1,7})?\.\d{0,2}|(\d{0,7})?(\.\d{0,7})?[Ee]((\+?0*[1-7])|-0*\d{1,2}))$/) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }
    return 1;
}

sub text {
    my ($c, $errors, $field, $value) = @_;
    unless (length($value) > 0 && $value =~ m/^[\w|\d|\s|:|\\|\/|"|'|#|\-|.|,|?]+$/) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }
    return 1;
}

sub path{
    my ($c, $errors, $field, $value) = @_;
    unless (length($value) > 0 && $value =~ m/^[\w|\d|\.]+$/) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }
    return 1;
}

sub rule {
    my ($c, $errors, $field, $value) = @_;
    unless (length($value) > 0 && $value =~ m/^[a-z|:|*|-|\.]+$/) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }
    return 1;
}

sub document {
    my ($c, $errors, $id) = @_;
    undef my $document;
    $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $id ])->Hash unless (@$errors);
    push @$errors, { id => "document", msg => "Can't find object"} unless ($document->{id});
    return $document;
}


1;
