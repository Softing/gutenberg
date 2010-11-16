package Inprint::BaseController;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use Data::UUID;
use Mojo::JSON;

no warnings 'redefine';

use Inprint::Frameworks::Access;
use Inprint::Frameworks::Events;

use base 'Mojolicious::Controller';

our %Cache;
our $JSON;

my $ug = new Data::UUID;

sub vc {
    my $c = shift;
    my $vc = Validator::Custom->new;
    return $vc;
}

sub config {
    my $c = shift;
    return $c->app->{config};
}

sub json {
    $JSON = Mojo::JSON->new unless $JSON;
    return $JSON;
}

# SQL

sub dbh {
    my $c = shift;
    return $c->app->dbh;
}

sub sql {
    my $c = shift;
    return $c->app->{sql};
}

sub Q {
    my $c = shift;
    return $c->app->{sql}->Q;
}

sub Do {
    my $c = shift;
    return $c->app->{sql}->Do;
}

# Query session

sub QuerySessionGet () {
    my $c = shift;
    my $param_name = shift;
    return $c->stash( "querySession.$param_name" );
}

sub QuerySessionSet () {
    my $c = shift;
    my $param_name = shift;
    my $param_value = shift;
    $c->stash( "querySession.$param_name" => $param_value );
    return $c;
}

# UUID utils

sub uuid {
    return $ug->create_str();
}

# Overwrite redirect_to

sub redirect_to {

    my $c = shift;

    $c->res->code(302);
    my $url = $c->url_for(@_)->to_rel;
    $url =~ s/\/index.pl//;
    
    $c->res->headers->location($url);
    return $c;
}

# Localization

sub l {
    my $c = shift;
    my $text = shift;
    my @vars = @_;

    $text = $c->stash->{i18n}->{_handle}->get($text) || $text;

    for (1 .. $#vars+1) {
        my $placer = "%$_";
        my $value = $vars[$_-1];
        $text =~ s/$placer/$value/g;
    }

    return $text;
}

# Access

sub access {
    my $c = shift;
    $Cache{Access} = new Inprint::Frameworks::Access($c) unless ($Cache{Access});
    $Cache{Access}->SetHandler($c);
    $Cache{Access}->ExtractRules($c);
    return $Cache{Access};
}

# Events

sub events {
    my $c = shift;
    $Cache{Events} = new Inprint::Frameworks::Events($c) unless ($Cache{Events});
    $Cache{Events}->SetHandler($c);
    return $Cache{Events};
}

# Logs

sub log {
    my $c = shift;
    return $c->app->log;
}

sub debug {
    my $c = shift;
    my $message = shift;
    return $c->app->log->debug($message);
}

sub info {
    my $c = shift;
    my $message = shift;
    return $c->app->log->info($message);
}

sub warn {
    my $c = shift;
    my $message = shift;
    return $c->app->log->warn($message);
}

sub error {
    my $c = shift;
    my $message = shift;
    return $c->app->log->error($message);
}
sub fatal {
    my $c = shift;
    my $message = shift;
    return $c->app->log->fatal($message);
}

# Validation

sub is_uuid {
    my $c = shift;
    my $text = shift;
    return 1 if (length($text) > 0 && $text =~ m/^[a-z|0-9]{8}(-[a-z|0-9]{4}){3}-[a-z|0-9]{12}+$/);
    return 0;
}

sub is_int {
    my $c = shift;
    my $text = shift;
    return 1 if (length($text) > 0 && $text =~ /^\-?[\d]+$/);
    return 0;
}

sub is_text {
    my $c = shift;
    my $text = shift;
    return 1 if (length($text) > 0 && $text =~ m/^[\w|\d|\s|\\|\/|"|'|#|-]+$/);
    return 0;
}

sub is_path {
    my $c = shift;
    my $text = shift;
    return 1 if (length($text) > 0 && $text =~ m/^[\w|\d|\.]+$/);
    return 0;
}

sub is_rule {
    my $c = shift;
    my $text = shift;
    return 1 if (length($text) > 0 && $text =~ m/^[a-z|:|*|\.]+$/);
    return 0;
}

1;
