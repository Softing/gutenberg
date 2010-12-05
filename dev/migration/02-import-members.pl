#!/usr/bin/perl

use utf8;
use strict;

use Data::Dump qw /dump/;
use DBIx::Connector;

use lib "../../lib";
use Inprint::Frameworks::Config;
use Inprint::Frameworks::SQL;

my $config = new Inprint::Frameworks::Config();
$config->load("../../");

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

$sql->Do("DELETE FROM members WHERE login <> 'root'");
$sql->Do("DELETE FROM map_member_to_catalog");
$sql->Do("DELETE FROM profiles");

# Import Members and Cards

my $members = $sql2->Q("
        SELECT * FROM passport.member t1
            LEFT JOIN passport.card t2 ON t1.uuid = t2.uuid ")->Hashes();

foreach my $item( @{ $members } ) {

    $sql->Do("
        INSERT INTO members (id, login, password, created, updated)
        VALUES (?, ?, ?, ?, now())
    ", [ $item->{uuid}, $item->{uid}, $item->{secret}, $item->{created} ]);

    $sql->Do("
        INSERT INTO profiles (id, title, shortcut, job_position)
        VALUES (?, ?, ?, ?)
    ", [ $item->{uuid}, $item->{title}, $item->{stitle}, $item->{position} ]);

}

# Import members to department mapping

my $mtodep = $sql2->Q("

        SELECT distinct t1.*, t2.uid, t3.title, t4.name
        FROM
                passport.member_department t1,
                passport.member t2,
                passport.department t3,
                edition.edition t4
        WHERE
                t1.member = t2.uuid
                and t1.edition = t4.uuid
                and t1.department = t3.uuid
        ORDER BY name, title, uid

    ")->Hashes();

foreach my $item( @{ $mtodep } ) {
    $sql->Do(" INSERT INTO map_member_to_catalog (member, catalog) VALUES (?, ?) ", [ $item->{member}, $item->{department} ]);
}
