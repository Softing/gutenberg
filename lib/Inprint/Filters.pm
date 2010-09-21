package Inprint::Filters;

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

#    my $name     = $c->config->get("db.name");
#    my $host     = $c->config->get("db.host");
#    my $port     = $c->config->get("db.port");
#    my $username = $c->config->get("db.user");
#    my $password = $c->config->get("db.user");

#    my $dsn = 'dbi:Pg:dbname='. $name .';host='. $host .';port='. $port .';';
#    my $atr = { AutoCommit=>1, RaiseError=>1, pg_enable_utf8=>1 };

    # Create a connection.
#    my $conn = DBIx::Connector->new($dsn, $username, $password, $atr );

    # Get the database handle and do something with it.
#    my $dbh  = $conn->dbh;


#    eval {
#        $dbh = DBI->connect(
#            'dbi:Pg:dbname='. $name .';host='. $host .';port='. $port .';', $user, $password,
#            {   AutoCommit=>1, RaiseError=>1, pg_enable_utf8=>1 }
#        );
#    };

#    unless ($dbh) {
#        $c->render(controller => 'errors', action => 'database', error=>$DBI::errstr );
#        return;
#    }

#    ref($c->app)->attr( 'dbh' => sub { return $dbh; } );
#    $c->app->sql->SetDBH($dbh);

    return $c;
}

sub mysession
{
    my $c = shift;
    my $sid = $c->session("sid");
    if ($sid) {
        my $session = $c->sql->Q("SELECT * FROM sessions WHERE id=?", [ $sid ])->Hash;
        if ($session) {
            $c->sql->Do(" UPDATE sessions SET updated=now() WHERE id=? ", [ $sid ] );
        } else {
            $c->redirect_to('/login');
        }
    } else {
        $c->redirect_to('/login');
    }
}

1;
