#!/usr/bin/perl

use utf8;
use strict;

use Data::UUID;
use Data::Dump qw /dump/;
use DBIx::Connector;

use lib "../../lib";
use Inprint::Frameworks::Config;
use Inprint::Frameworks::SQL;

my $ug = new Data::UUID;

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

$sql->Do("DELETE FROM branches");
$sql->Do("DELETE FROM stages");
$sql->Do("DELETE FROM statuses");

# Import statuses
my $statuses = $sql2->Q("
    SELECT distinct
        status_title as title, status_percent as weight, status_color as color
    FROM exchange2.readiness
")->Hashes;

foreach my $item ( @$statuses ) {
    $item->{color} =~ s/#//g;
    $sql->Do("
        INSERT INTO statuses(color, weight, title, shortcut, description, created, updated)
            VALUES (?, ?, ?, ?, ?, now(), now());
    ", [ $item->{color}, $item->{weight}, $item->{title}, $item->{title}, "" ]);
}

# Import chains

my $chains = $sql2->Q("
    SELECT distinct t2.uuid as catalog, t2.name, t2.sname
    FROM exchange2.readiness t1, edition.edition t2
    WHERE t1.edition = t2.uuid;
")->Hashes;

foreach my $item( @{ $chains } ) {

    my $id = $ug->create_str();

    $sql->Do("
        INSERT INTO branches (id, catalog, title, shortcut, description, created, updated)
            VALUES (?,?,?,?,?,now(),now());
    ", [ $id, $item->{catalog}, $item->{name}, $item->{sname}, "" ]);

    # Import stages
    my $stages = $sql2->Q("
        SELECT
            uuid as id, status_title as name, status_description as description,
            status_percent as weight, status_color as color
        FROM exchange2.readiness
        WHERE edition =?
    ", [ $item->{catalog} ])->Hashes;

    foreach my $item2( @{ $stages } ) {
        $item2->{color} =~ s/#//g;
        $sql->Do("
            INSERT INTO stages(id, branch, color, weight, title, shortcut, description, created, updated)
                VALUES (?,?,?,?,?,?,?,now(),now());
        ", [ $item2->{id}, $id, $item2->{color}, $item2->{weight}, $item2->{name}, $item2->{name}, $item2->{description} ]);

    }

}
