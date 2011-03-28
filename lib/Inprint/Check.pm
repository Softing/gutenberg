package Inprint::Check;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use Inprint::Frameworks::Access;

sub exists {
    my ($c, $errors, $field, $value) = @_;
    unless (length($value) > 0) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }
    return 1;
}

sub uuid {
    my ($c, $errors, $field, $value, $ifexists) = @_;

    if ($ifexists) {
        return 1 unless $value;
        return 1 if $value eq 'undefined';
    }

    unless (length($value) > 0 && $value =~ m/^[a-z|0-9]{8}(-[a-z|0-9]{4}){3}-[a-z|0-9]{12}+$/) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }
    return 1;
}

sub date {
    my ($c, $errors, $field, $value, $ifexists) = @_;

    if ($ifexists) {
        return 1 unless $value;
        return 1 if $value eq 'undefined';
    }

    unless (length($value) > 0 && $value =~ m/^[0-9]{4}-[0-9]{2}-[0-9]{2}+$/) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }
    return 1;
}

sub int {
    my ($c, $errors, $field, $value, $ifexists) = @_;

    if ($ifexists) {
        return 1 unless $value;
        return 1 if $value eq 'undefined';
    }

    unless (length($value) > 0 && $value =~ m/^\-?[\d]+$/) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }
    return 1;
}

sub float {
    my ($c, $errors, $field, $value, $ifexists) = @_;

    if ($ifexists) {
        return 1 unless $value;
        return 1 if $value eq 'undefined';
    }

    unless (length($value) > 0 && $value =~ m/^(\d{1,7}|(\d{1,7})?\.\d{0,2}|(\d{0,7})?(\.\d{0,7})?[Ee]((\+?0*[1-7])|-0*\d{1,2}))$/) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }

    return 1;
}

sub flag {
    my ($c, $errors, $field, $value, $ifexists) = @_;

    if ($ifexists) {
        return 1 unless $value;
        return 1 if $value eq 'undefined';
    }

    unless (length($value) > 0 && $value =~ m/^[a-z|0-9]+$/) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }

    return 1;
}

sub text {
    my ($c, $errors, $field, $value, $ifexists) = @_;

    if ($ifexists) {
        return 1 unless $value;
        return 1 if $value eq 'undefined';
    }

    unless (length($value) > 0) {
    #unless (length($value) > 0 && $value =~ m/^[\w|\d|\s|:|\\|\/|"|'|#|\-|.|,|?]+$/) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }

    return 1;
}

sub url {
    my ($c, $errors, $field, $value, $ifexists) = @_;

    if ($ifexists) {
        return 1 unless $value;
        return 1 if $value eq 'undefined';
    }

    unless (length($value) > 0) {
    #unless (length($value) > 0 && $value =~ m/^[\w|\d|\s|:|\\|\/|"|'|#|\-|.|,|?]+$/) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }

    return 1;
}

sub path{
    my ($c, $errors, $field, $value, $ifexists) = @_;

    if ($ifexists) {
        return 1 unless $value;
        return 1 if $value eq 'undefined';
    }

    unless (length($value) > 0 && $value =~ m/^[\w|\d|\.|-]+$/) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }
    return 1;
}

sub rule {
    my ($c, $errors, $field, $value, $ifexists) = @_;

    if ($ifexists) {
        return 1 unless $value;
        return 1 if $value eq 'undefined';
    }

    unless (length($value) > 0 && $value =~ m/^[a-z|:|*|-|\.]+$/) {
        push @$errors, { id => $field, msg => "Incorrectly filled field"};
        return 0;
    }

    return 1;
}

sub object {
    my ($c, $errors, $field, $object) = @_;
    unless ($object && $object->{id}) {
        push @$errors, { id => $field, msg => "Can't find object"};
        return 0;
    }

    return 1;
}

# Access checks

sub access {
    my ($c, $errors, $terms, $binding, $member) = @_;

    my @rules;
    my $result = 0;

    $member = $c->QuerySessionGet("member.id") unless ($member);

    if (ref $terms eq "ARRAY") {
        @rules = @$terms;
    } else {
        push @rules, $terms;
    }

    for (my $i=0; $i <= $#rules; $i++) {
        my ($term, $area) = split /:/, $rules[$i];
        if ($area eq "*") {
            splice @rules, $i, $i, "$term:member", "$term:group";
        }
    }
    my %seen;@rules = grep { ! $seen{$_}++ } @rules;

    if ($member && @rules) {
        my @data;
        my $sql = " SELECT true FROM cache_access WHERE member=? AND ? && terms ";
        push @data, $member;
        push @data, \@rules;
        if ($binding) {
            $sql .= " AND binding=?";
            push @data, $binding;
        }

        $result = $c->sql->Q("SELECT EXISTS ($sql)", \@data)->Value();
    }

    if ($errors) {
        unless ($result) {
            my $terms = join ', ', @rules;
            push @$errors, { id => "access", msg => "Not enough permissions <$terms>"};
        }
    }

    return $result;
}

# Objects checks

sub document {
    my ($c, $errors, $id) = @_;
    undef my $item;
    $item = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $id ])->Hash unless (@$errors);
    push @$errors, { id => "document", msg => "Can't find object"} unless ($item->{id});
    return $item;
}

sub department {
    my ($c, $errors, $id) = @_;
    undef my $item;
    $item = $c->sql->Q(" SELECT * FROM catalog WHERE id=? ", [ $id ])->Hash unless (@$errors);
    push @$errors, { id => "department", msg => "Can't find object"} unless ($item->{id});
    return $item;
}

sub edition {
    my ($c, $errors, $id) = @_;
    undef my $item;
    $item = $c->sql->Q(" SELECT * FROM editions WHERE id=? ", [ $id ])->Hash unless (@$errors);
    push @$errors, { id => "edition", msg => "Can't find object"} unless ($item->{id});
    return $item;
}

sub advertiser {
    my ($c, $errors, $id) = @_;
    undef my $item;
    $item = $c->sql->Q(" SELECT * FROM ad_advertisers WHERE id=? ", [ $id ])->Hash unless (@$errors);
    push @$errors, { id => "advertiser", msg => "Can't find object"} unless ($item->{id});
    return $item;
}

sub fascicle {
    my ($c, $errors, $id) = @_;
    undef my $item;
    $item = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $id ])->Hash unless (@$errors);
    push @$errors, { id => "fascicle", msg => "Can't find object"} unless ($item->{id});
    return $item;
}

sub principal {
    my ($c, $errors, $id) = @_;
    undef my $item;
    $item = $c->sql->Q(" SELECT * FROM view_principals WHERE id=? ", [ $id ])->Hash unless (@$errors);
    push @$errors, { id => "principal", msg => "Can't find object"} unless ($item->{id});
    return $item;
}

# Comomn

sub dbrecord {
    my ($c, $errors, $table, $title, $id) = @_;
    undef my $item;
    $item = $c->sql->Q(" SELECT * FROM $table WHERE id=? ", [ $id ])->Hash unless (@$errors);
    push @$errors, { id => $title, msg => "Can't find record"} unless ($item->{id});
    return $item;
}

# Render error

sub checkErrors {
    my ($c, $errors) = @_;
    if (@{ $errors }) {
        $c->render_json({ success => $c->json->false, errors => \@$errors });
        return;
    }
    return $c;
}

1;
