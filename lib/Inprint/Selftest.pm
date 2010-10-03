package Inprint::Selftest;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use File::Path qw(make_path);

use base 'Inprint::BaseController';

sub preinit
{
    my $c = shift;

    if ( $c->config->get("core.installed") ne 'yes' ) {
        $c->redirect_to('/setup/database/');
    }

    #$c->app->log->warn("SELFTEST PREINIT");
    return $c;
}

sub store
{
    my $c = shift;

    my $path = $c->config->get("store.path");

    unless ( -e $path ) {
        make_path($path, { mode => 0755 });
    }

    unless ( -e $path ) {
        $c->redirect_to('/setup/store/');
    }

    return $c;
}

sub postinit
{
    my $c = shift;

    #my @pairs;
    #if ($ENV{'REQUEST_METHOD'} eq 'POST') {
    #    read(STDIN, my ($buffer), $ENV{'CONTENT_LENGTH'});
    #    @pairs = split(/&/, $buffer);
    #}
    #
    #foreach my $pair (@pairs) {
    #    my ($name, $value) = split(/=/, $pair);
    #    $value =~ tr/+/ /;
    #    $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    #    $value =~ s/<!--(.|\n)*-->//g;
    #    $c->stash->{params}->append( $name => $value );
    #}

    return $c;
}

1;
