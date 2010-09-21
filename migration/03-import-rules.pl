#!/usr/bin/perl;

use utf8;
use strict;

use Data::Dump qw /dump/;
use DBIx::Connector;

use lib "../lib";
use Inprint::Frameworks::Config;
use Inprint::Frameworks::SQL;

my $config = new Inprint::Frameworks::Config("../");

my $dbname     = $config->get("db.name");
my $dbhost     = $config->get("db.host");
my $dbport     = $config->get("db.port");
my $dbusername = $config->get("db.user");
my $dbpassword = $config->get("db.password");

my $atr = { AutoCommit=>1, RaiseError=>1, PrintError=>1, pg_enable_utf8=>1 };

my $dsn  = 'dbi:Pg:dbname='. $dbname .';host='. $dbhost .';port='. $dbport .';';
my $dsn2 = 'dbi:Pg:dbname=inprint-4.3;host='. $dbhost .';port='. $dbport .';';

# Create a connection.
my $conn  = DBIx::Connector->new($dsn,  $dbusername, $dbpassword, $atr );
my $conn2 = DBIx::Connector->new($dsn2, $dbusername, $dbpassword, $atr );

# Create SQL mappings
my $sql = new Inprint::Frameworks::SQL();
$sql->SetConnection($conn);

my $sql2 = new Inprint::Frameworks::SQL();
$sql2->SetConnection($conn2);

my $rootnode = '00000000-0000-0000-0000-000000000000';

#$sql->Do("DELETE FROM rules");

# Import rules
#
#my $rgroups = $sql2->Q(" SELECT id, uuid, title, weight FROM passport.regulation_group ")->Hashes();
#
#foreach my $item( @{ $rgroups } ) {
#
#    $sql->Do('
#        INSERT INTO rules(id, "group", rule, name, shortcut, description, sortorder )
#            VALUES (?, null, ?, ?, \'\', \'\', ?);
#    ', [ $item->{uuid}, $item->{id}, $item->{title}, $item->{weight} ]);
#
#    my $rules = $sql2->Q('
#        SELECT uuid, regulation, title, stitle, description, "group", type, weight
#        FROM passport.regulation
#        WHERE "group" = ?', [ $item->{id} ])->Hashes();
#
#    foreach my $item2( @{ $rules } ) {
#
#        next unless $item2->{stitle};
#
#        $item2->{description} = '' unless $item2->{description};
#
#        $sql->Do('
#            INSERT INTO rules(id, "group", rule, name, shortcut, description, sortorder )
#                VALUES (?, ?, ?, ?, ?, ?, ?);
#        ', [ $item2->{uuid}, $item->{id}, $item2->{regulation}, $item2->{title}, $item2->{stitle}, $item2->{description}, $item2->{weight} ]);
#
#    }
#}

# TODO add rule to member mapping
