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

    # Get session ID
    my $sid = $c->session("sid");

    # Check session
    if ($sid) {
        
        my $session = $c->sql->Q("SELECT * FROM sessions WHERE id=?", [ $sid ])->Hash;
        if ($session->{member}) {
            my $access  = $c->sql->Q("
                SELECT true
                FROM map_member_to_rule
                WHERE member = ? AND term='2fde426b-ed30-4376-9a7b-25278e8f104a'
            ", [ $session->{member} ])->Value;
            if ($access) {
                $c->sql->Do(" UPDATE sessions SET updated=now() WHERE id=? ", [ $sid ] );
            } else {
                $c->redirect_to('/login');
            }
        } else {
            $c->redirect_to('/login');
        }
    } else {
        $c->redirect_to('/login');
    }

    # Create session object
    if ($c->session("sid")) {

        my $member = $c->sql->Q("
            SELECT t2.id, t2.login, t3.title, t3.shortcut, t3.job_position
            FROM sessions t1, members t2 LEFT JOIN profiles t3 ON (t3.id = t2.id) WHERE t1.id=? AND t1.member = t2.id
        ", [ $c->session("sid") ])->Hash || {};

        $c->stash( "member.id" =>       $member->{id});

        $c->QuerySessionSet("member.id",       $member->{id});
        $c->QuerySessionSet("member.login",    $member->{login});
        $c->QuerySessionSet("member.shortcut", $member->{shortcut});
        $c->QuerySessionSet("member.position", $member->{job_position});

        my $options = $c->sql->Q(" SELECT option_name, option_value FROM options WHERE member=? ", [ $member->{id} ])->Hashes || [];
        foreach my $item (@$options) {
            $c->QuerySessionSet("options.". $item->{option_name}, $item->{option_value});
        }

    }

    return $c;
}

1;
