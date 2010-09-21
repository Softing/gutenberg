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

$sql->Do("DELETE FROM catalog");
$sql->Do("DELETE FROM catalog_tree");


$sql->Do("
    INSERT INTO catalog (id, parent, path, named_path, name, shortcut, description, type, capables, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', null, '00000000-0000-0000-0000-000000000000', 'pubhouse', 'Publish House', 'pubhouse', 'ph', 'ou', '{default}', '2010-08-03 19:01:13.77+04', '2010-08-03 19:01:13.77+04');
");

# Import Editions

my $editions = $sql2->Q(" SELECT * FROM edition.edition WHERE deleted=false ")->Hashes();

foreach my $item( @{ $editions } ) {
    $sql->Do("
        INSERT INTO catalog (id, parent, name, shortcut, description, type, capables)
        VALUES (?, ?, ?, ?, ?, 'ou', '{default}')
    ", [ $item->{uuid}, $rootnode, $item->{name}, $item->{sname}, $item->{description} ]);
}

# Import Departments

my $departments = $sql2->Q("SELECT * FROM passport.department")->Hashes();

foreach my $item( @{ $departments } ) {
    $sql->Do("
        INSERT INTO catalog (id, parent, name, shortcut, description, type, capables)
        VALUES (?, ?, ?, ?, ?, 'ou', '{default}')
    ", [ $item->{uuid}, $item->{edition}, $item->{title}, $item->{title}, $item->{description} ]);
}
