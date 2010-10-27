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

$sql->Do("DELETE FROM fascicles");
$sql->Do("DELETE FROM rubrics");
$sql->Do("DELETE FROM headlines");
$sql->Do("DELETE FROM tags");

# Import fascicles

my $fascicles = $sql2->Q(" SELECT id, edition, ownedby, title, dt_started, dt_closed, dt_closed > now() AS enabled FROM edition.calendar ")->Hashes;

# Import default fascicles

$sql->Do("
    INSERT INTO fascicles(id, issystem, edition, title, shortcut, description, enabled, created, updated)
    VALUES (?, true, ?, ?, ?, ?, true, now(), now());
", [ '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', "Портфель", "Портфель", "Портфель материалов" ]);

$sql->Do("
    INSERT INTO fascicles(id, issystem, edition, title, shortcut, description, enabled, created, updated)
    VALUES (?, true, ?, ?, ?, ?, true, now(), now());
", [ '99999999-9999-9999-9999-999999999999', '00000000-0000-0000-0000-000000000000', "Корзина", "Корзина", "Корзина материалов" ]);


$sql->Do("
    INSERT INTO tags(id, mtype, title, shortcut, description, created, updated)
    VALUES (?, ?, ?, ?, ?, now(), now());
", [ '00000000-0000-0000-0000-000000000000', "headline", "Not found", "Not found", "Not found" ]);

$sql->Do("
    INSERT INTO tags(id, mtype, title, shortcut, description, created, updated)
    VALUES (?, ?, ?, ?, ?, now(), now());
", [ '00000000-0000-0000-0000-000000000000', "rubric", "Not found", "Not found", "Not found" ]);

$sql->Do("
    INSERT INTO headlines (id, fascicle, tag, created, updated)
    VALUES (?, ?, ?, now(), now());
", [ '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000' ]);

$sql->Do("
    INSERT INTO rubrics(id, fascicle, headline, tag, created, updated)
    VALUES (?, ?, ?, ?, now(), now());
", [ '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000' ]);



foreach my $item( @{ $fascicles } ) {

    # Check if group exists
    # Editions
    my $EditionId = $sql->Q(" SELECT newid FROM migration WHERE oldid=? AND mtype = 'edition' ", [ $item->{edition} ])->Value;
    die "Can't find edition id $item->{edition}" unless $EditionId;

    if ($EditionId) {
        $sql->Do("
            INSERT INTO fascicles(id, edition, title, shortcut, description, begindate, enddate, enabled, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [ $item->{id}, $EditionId, $item->{title}, $item->{title}, $item->{title}, $item->{dt_started}, $item->{dt_closed}, $item->{enabled} ]);
    } else {
        die 1;
    }

    # Import default headline && rubric

    $sql->Do("
        INSERT INTO headlines(id, fascicle, tag, created, updated)
        VALUES (?, ?, ?, now(), now());
    ", [ '00000000-0000-0000-0000-000000000000', $item->{id}, '00000000-0000-0000-0000-000000000000' ]);

    $sql->Do("
        INSERT INTO rubrics(id, fascicle, headline, tag, created, updated)
        VALUES (?, ?, ?, ?, now(), now());
    ", [ '00000000-0000-0000-0000-000000000000', $item->{id}, '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000' ]);

    # Import headlines

    my $catchwords = $sql2->Q("
        SELECT uuid, base_uuid, fascicle, title, description
        FROM edition.catchword WHERE fascicle = ?
    ", [$item->{id}])->Hashes;

    foreach my $item2 ( @{ $catchwords } ) {

        my $Headline = $sql->Q("
            SELECT * FROM tags WHERE title =? AND mtype='headline'
        ", [$item2->{title} ])->Hash;

        unless ($Headline) {
            $sql->Do("
                INSERT INTO tags(mtype, title, shortcut, description, created, updated)
                VALUES (?, ?, ?, ?, now(), now());
            ", [ "headline", $item2->{title}, $item2->{title}, $item2->{description} || "" ]);
        }

        $Headline = $sql->Q("
            SELECT * FROM tags WHERE title=? AND mtype='headline'
        ", [$item2->{title} ])->Hash;

        $sql->Do("
            INSERT INTO headlines(fascicle, tag, created, updated)
            VALUES (?, ?, now(), now());
        ", [ $item->{id}, $Headline->{id} ]);

    }

    # Import rubrics
    my $rubrics = $sql2->Q("
        SELECT uuid, base_uuid, fascicle, catchword, title, description
        FROM edition.rubric WHERE fascicle = ?
    ", [$item->{id}])->Hashes;

    foreach my $item3 ( @{ $rubrics } ) {

        my $Rubric = $sql->Q("
            SELECT * FROM tags WHERE title =? AND mtype='rubric'
        ", [$item3->{title} ])->Hash;

        unless ($Rubric) {
            $sql->Do("
                INSERT INTO tags(mtype, title, shortcut, description, created, updated)
                VALUES (?, ?, ?, ?, now(), now());
            ", [ "rubric", $item3->{title}, $item3->{title}, $item3->{description} || "" ]);
        }

        $Rubric = $sql->Q("
            SELECT * FROM tags WHERE title =? AND mtype='rubric'
        ", [ $item3->{title} ])->Hash;

        $sql->Do("
            INSERT INTO Rubrics(fascicle, headline, tag, created, updated)
            VALUES (?, ?, ?, now(), now());
        ", [ $item->{id}, $item3->{catchword}, $Rubric->{id} ]);

    }
}
