package Inprint::Mojoplugins::Validation;

use warnings;
use strict;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

sub register {
    my ( $self, $app, $conf ) = @_;

    # Plugin config
    $conf ||= {};

    # NEW ACCESS CHECK

    $app->helper(
        check_access => sub {

            my ($c, $errors, $terms, $binding, $member) = @_;

            my @rules;
            my $result = 0;

            $member = $c->getSessionValue("member.id") unless ($member);

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

                $result = $c->Q("SELECT EXISTS ($sql)", \@data)->Value();
            }

            if ($errors) {
                unless ($result) {
                    my $terms = join ', ', @rules;
                    push @$errors, { id => "access", msg => "Not enough permissions <$terms>"};
                }
            }

            return $result;
        });

    # NEW DB CHECK

    $app->helper(
        check_record => sub {
            my ($c, $errors, $table, $title, $id) = @_;
            undef my $item;
            $item = $c->Q(" SELECT * FROM $table WHERE id=? ", [ $id ])->Hash unless (@$errors);
            push @$errors, { id => $title, msg => "Can't find record"} unless ($item->{id});
            return $item;
        });

    # NEW CHECK RULES

    $app->helper(
        check_exists => sub {
            my ($c, $errors, $field, $value) = @_;
            unless (length($value) > 0) {
                push @$errors, { id => $field, msg => "Incorrectly filled field"};
                return 0;
            }
            return 1;
        });

    $app->helper(
        check_uuid => sub {
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
        });

    $app->helper(
        check_date => sub {
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
        });

    $app->helper(
        check_int => sub {
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
        });

    $app->helper(
        check_float => sub {
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
        });

    $app->helper(
        check_flag => sub {
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
        });

    $app->helper(
        check_text => sub {
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
        });

    $app->helper(
        check_url => sub {
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
        });

    $app->helper(
        check_path => sub {
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
        });

    $app->helper(
        check_rule => sub {
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
        });

    $app->helper(
        check_object => sub {
            my ($c, $errors, $field, $object) = @_;
            unless ($object && $object->{id}) {
                push @$errors, { id => $field, msg => "Can't find object"};
                return 0;
            }

            return 1;
        });

    # OLD CHECK RULES

    $app->helper(
        is_date => sub {
            my $c = shift;
            my $text = shift;
            return 1 if (length($text) > 0 && $text =~ m/^[0-9]{4}-[0-9]{2}-[0-9]{2}+$/);
            return 0;
        });

    $app->helper(
        is_uuid => sub {
            my $c = shift;
            my $text = shift;
            return 1 if (length($text) > 0 && $text =~ m/^[a-z|0-9]{8}(-[a-z|0-9]{4}){3}-[a-z|0-9]{12}+$/);
            return 0;
        });

    $app->helper(
        is_int => sub {
            my $c = shift;
            my $text = shift;
            return 1 if (length($text) > 0 && $text =~ m/^\-?[\d]+$/);
            return 0;
        });

    $app->helper(
        is_float => sub {
            my $c = shift;
            my $text = shift;
            return 1 if (length($text) > 0 && $text =~ m/^(\d{1,7}|(\d{1,7})?\.\d{0,2}|(\d{0,7})?(\.\d{0,7})?[Ee]((\+?0*[1-7])|-0*\d{1,2}))$/);
            return 0;
        });

    $app->helper(
        is_text => sub {
            my $c = shift;
            my $text = shift;
            return 1 if (length($text) > 0 && $text =~ m/^[\w|\d|\s|:|\\|\/|"|'|#|\-|.|,|?]+$/);
            return 0;
        });

    $app->helper(
        is_path => sub {
            my $c = shift;
            my $text = shift;
            return 1 if (length($text) > 0 && $text =~ m/^[\w|\d|\.]+$/);
            return 0;
        });

    $app->helper(
        is_rule => sub {
            my $c = shift;
            my $text = shift;
            return 1 if (length($text) > 0 && $text =~ m/^[a-z|:|*|-|\.]+$/);
            return 0;
        });

}

1;
