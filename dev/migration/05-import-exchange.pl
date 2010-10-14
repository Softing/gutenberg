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

$sql->Do("DELETE FROM branches");
$sql->Do("DELETE FROM stages");
$sql->Do("DELETE FROM readiness");
$sql->Do("DELETE FROM map_principals_to_stages");

$sql->Do(" DELETE FROM migration WHERE mtype = 'branch' OR mtype='stage' ");

# Import statuses

my @readiness = (
    {
        percent=>10,
        description=>"Автор",
        color=>"ffcd04",
        title=>"Написание",
        shortcut=>"Написание",
    },
    {
        percent=>25,
        description=>"Зав. отделом",
        color=>"f6f67d",
        title=>"Редактирование",
        shortcut=>"Редактирование",
    },
    {
        percent=>50,
        description=>"Зам.гл. редактора",
        color=>"b2be0f",
        title=>"Сдача и утверждение",
        shortcut=>"Сдача и утверждение",
    },
    {
        percent=>60,
        description=>"Шеф по тексту",
        color=>"f87878",
        title=>"Правка",
        shortcut=>"Правка",
    },
    {
        percent=>70,
        description=>"Автор",
        color=>"01cd42",
        title=>"Вычитка",
        shortcut=>"Вычитка",
    },
    {
        percent=>80,
        description=>"Корректор",
        color=>"07f9c4",
        title=>"Корректура",
        shortcut=>"Корректура",
    },
    {
        percent=>90,
        description=>"Отдел ОХО",
        color=>"009790",
        title=>"Верстка",
        shortcut=>"Верстка",
    },
    {
        percent=>100,
        description=>"",
        color=>"0c48f9",
        title=>"Сверстано",
        shortcut=>"Сверстано",
    }
);

foreach my $item ( @readiness ) {
    $item->{color} =~ s/#//g;
    $sql->Do("
        INSERT INTO readiness (color, weight, title, shortcut, description, created, updated)
            VALUES (?, ?, ?, ?, ?, now(), now());
    ", [ $item->{color}, $item->{percent}, $item->{title}, $item->{shortcut}, $item->{description} ]);
}


# Import chains

my $chains = $sql2->Q("
    SELECT distinct t2.uuid as catalog, t2.name, t2.sname
    FROM exchange2.readiness t1, edition.edition t2
    WHERE t1.edition = t2.uuid;
")->Hashes;

foreach my $item( @{ $chains } ) {

    my $idBranch = $ug->create_str();

    $sql->Do("INSERT INTO migration(mtype, oldid, newid) VALUES (?, ?, ?) ",
        [ "branch", $item->{catalog}, $idBranch ]);

    my $idEdition = $sql->Q("
        SELECT newid FROM migration WHERE mtype='edition' AND oldid=?
    ", [ $item->{catalog} ])->Value;

    die "Cant find branch for $item->{catalog}" unless $idBranch;

    $sql->Do("
        INSERT INTO branches (id, edition, title, shortcut, description, created, updated)
            VALUES (?,?,?,?,?,now(),now());
    ", [ $idBranch, $idEdition, $item->{name}, $item->{sname}, "" ]);

    # Import stages
    my $stages = $sql2->Q("
        SELECT
            uuid as id, status_title as name, status_description as description,
            status_percent as weight, status_color as color
        FROM exchange2.readiness
        WHERE edition =?
    ", [ $item->{catalog} ])->Hashes;

    foreach my $item2( @{ $stages } ) {

        my $idStage = $ug->create_str();

        my $idReadiness = $sql->Q("
            SELECT id FROM readiness WHERE weight >= ? AND weight <= 100  ORDER BY weight LIMIT 1
        ", [$item2->{weight}])->Value;

        die "Cant find Readiness for $item2->{weight}" unless $idReadiness;

        #my $idBranch = $sql->Q("
        #    SELECT newid FROM migration WHERE mtype='edition' AND oldid=?
        #", [ $item->{catalog} ])->Value;
        #
        #die "Cant find branch for $item->{catalog}" unless $idBranch;

        $sql->Do("INSERT INTO migration(mtype, oldid, newid) VALUES (?, ?, ?) ",
            [ "stage", $item2->{id}, $idStage ]);

        $sql->Do("
            INSERT INTO stages(id, branch, readiness, weight, title, shortcut, description, created, updated)
                VALUES (?,?,?,?,?,?,?,now(),now());
        ", [ $idStage, $idBranch, $idReadiness, $item2->{weight}, $item2->{name}, $item2->{name}, $item2->{description} ]);

        # Import users
        my $members = $sql2->Q("
            SELECT uuid, edition, status_uuid, member_uuid, is_group
            FROM exchange2.mappings WHERE status_uuid=? AND is_group = false;
        ", [ $item2->{id} ])->Hashes;

        foreach my $item3( @{ $members } ) {

            my $idMember = $sql->Q("
                SELECT id FROM members WHERE id=?
            ", [ $item3->{member_uuid} ])->Value;

            my $idDepartment = $sql2->Q("
                SELECT department FROM passport.member_department WHERE edition=? AND member=? LIMIT 1
            ", [ $item3->{edition}, $item3->{member_uuid} ])->Value || '00000000-0000-0000-0000-000000000000';

            my $idCatalog = $sql->Q(" SELECT id FROM catalog WHERE id = ? ", [ $idDepartment ])->Value;

            if ($idMember) {
                $sql->Do("
                    INSERT INTO map_principals_to_stages( stage, catalog, principal)
                    VALUES (?, ?, ?);
                ",
                [ $idStage, $idDepartment, $idMember ]);

            }
        }

        # Import departments
        my $departments = $sql2->Q("
            SELECT uuid, edition, status_uuid, member_uuid, is_group
            FROM exchange2.mappings WHERE status_uuid=? AND is_group = true;
        ", [ $item2->{id} ])->Hashes;

        foreach my $item4 ( @{ $departments } ) {

            my $idDepartment = $sql->Q("
                SELECT id FROM catalog WHERE id=?
            ", [ $item4->{member_uuid} ])->Value;

            die "cant't find department $idDepartment" unless $idDepartment;

            if ($idDepartment) {
                $sql->Do("
                    INSERT INTO map_principals_to_stages( stage, catalog, principal)
                    VALUES (?, ?, ?);
                ",
                [ $idStage, $idDepartment, $idDepartment ]);

            }
        }

    }

}
