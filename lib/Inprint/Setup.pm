package Inprint::Setup;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub database
{
    my $c = shift;

    my $error;

    if ($c->param("action") eq 'submit') {

        # check input values

        $error = "field_db" unless $c->param("db");
        $error = "field_host" unless $c->param("host");
        $error = "field_port" unless $c->param("port");
        $error = "field_user" unless $c->param("user");
        $error = "field_password" unless $c->param("password");

        # Database Connection check
        my $dbh;
        eval {
            $dbh = DBI->connect(
                'dbi:Pg:dbname='. $c->param("db") .';host='. $c->param("host") .';port='. $c->param("port") .';', $c->param("user"), $c->param("password"),
                {   AutoCommit=>1, RaiseError=>1, pg_enable_utf8=>1 }
            ) || die $!;
        };
        if ($@) { $error = $@; }

        # Save config
        unless ($error) {

            $c->config->set("db.name",     $c->param("db"));
            $c->config->set("db.host",     $c->param("host"));
            $c->config->set("db.port",     $c->param("port"));
            $c->config->set("db.user",     $c->param("user"));
            $c->config->set("db.password", $c->param("password"));

            $c->config->write();

            # Database Integrity check
            my $sth = $dbh->table_info('', 'edition', 'edition', 'TABLE');
            my $table1 = $sth->fetchrow_hashref();

            unless ($table1) {
                $c->redirect_to('/setup/import/');
            } else {
                $c->config->set("core.installed", "yes");
                $c->redirect_to('/setup/success/') unless ($error);
            }
        }
    }

    $c->render( error => $error );
}

sub import {
    my $c = shift;

    my ($error, $dbh);

    eval {
        $dbh = DBI->connect(
            'dbi:Pg:dbname='. $c->config->get("db.name") .';host='. $c->config->get("db.host") .';port='. $c->config->get("db.port") .';', $c->config->get("db.user"), $c->config->get("db.password"),
            {   AutoCommit=>1, RaiseError=>1, pg_enable_utf8=>1 }
        ) || die $!;
    };
    if ($@) { $error = $@; }

    unless ($error) {

        # Database Integrity check
        my $sth = $dbh->table_info('', 'edition', 'edition', 'TABLE');
        my $table1 = $sth->fetchrow_hashref();

        if ($table1) {
            $c->config->set("core.installed", "yes");
            $c->config->write();
            $c->redirect_to('/setup/success/');
        }

    } else {
        $c->config->set("core.installed", "no");
        $c->config->write();
        $c->redirect_to('/setup/database/');
    }

    $c->render( error => $error );
}

sub success {
    my $c = shift;

    my ($error, $dbh);

    eval {
        $dbh = DBI->connect(
            'dbi:Pg:dbname='. $c->config->get("db.name") .';host='. $c->config->get("db.host") .';port='. $c->config->get("db.port") .';', $c->config->get("db.user"), $c->config->get("db.password"),
            {   AutoCommit=>1, RaiseError=>1, pg_enable_utf8=>1 }
        ) || die $!;
    };
    if ($@) { $error = $@; }

    unless ($error) {

        my $sth = $dbh->table_info('', 'edition', 'edition', 'TABLE');
        my $table1 = $sth->fetchrow_hashref();

        if ($table1) {
            $c->config->set("core.installed", "yes");
            $c->config->write();
        } else {
            $c->config->set("core.installed", "no");
            $c->config->write();
            $c->redirect_to('/setup/import/');
        }

    } else {
        $c->config->set("core.installed", "no");
        $c->config->write();
        $c->redirect_to('/setup/database/');
    }
}

1;
