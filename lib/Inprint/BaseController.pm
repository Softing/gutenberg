package Inprint::BaseController;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Data::UUID;
use Mojo::JSON;

no warnings 'redefine';

use Inprint::Frameworks::Access;

use base 'Mojolicious::Controller';

our %Cache;
our $JSON;

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

# UUID utils

sub uuid {
    my $ug = new Data::UUID;
    return $ug->create_str();
}

# Overwrite redirect_to

sub redirect_to {

    my $c = shift;

    $c->res->code(302);
    my $url = $c->url_for(@_)->to_abs;
    $url =~ s/\/index.pl//;
    $c->res->headers->location($url);

    return $c;
}

# Localization

sub l {
    my $c = shift;
    my $text = shift;
    my @vars = @_;

    eval { $text = $c->stash->{i18n}->localize($text); };

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

    return $Cache{Access};

}

# Logging

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


1;
