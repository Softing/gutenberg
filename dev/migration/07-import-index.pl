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

$sql->Do("DELETE FROM index");
$sql->Do("DELETE FROM index_mapping");

# Import index

my $editions = $sql2->Q(" SELECT id, name, sname, description, uuid, deleted
    FROM edition.edition WHERE deleted=false ")->Hashes;

foreach my $edition ( @{ $editions } ) {

    my $EditionId = $sql->Q(" SELECT newid FROM migration WHERE oldid=? AND mtype = 'edition' ", [ $edition->{uuid} ])->Value;
    die "Can't find edition id $edition->{uuid}" unless $EditionId;

    # Import default headline
    $sql->Do("
            INSERT INTO index(id, edition, variation, title, shortcut, description, created, updated)
            VALUES (?, ?, 'headline', ?, ?, ?, now(), now());
    ", ['00000000-0000-0000-0000-000000000000', $EditionId, '--', '--', '--' ]);
    $sql->Do("
            INSERT INTO index(id, edition, variation, title, shortcut, description, created, updated)
            VALUES (?, ?, 'rubric', ?, ?, ?, now(), now());
    ", ['00000000-0000-0000-0000-000000000000', $EditionId, '--', '--', '--' ]);

    # Import headlines
    my $fascicleIds = $sql2->Q(" SELECT id FROM edition.calendar WHERE edition =? ", [ $edition->{uuid} ])->Values;
    
    my $catchwords = $sql2->Q(" SELECT uuid, fascicle, title, description FROM edition.catchword WHERE fascicle = ANY(?) ", [ $fascicleIds ])->Hashes;

    foreach my $headline ( @{ $catchwords } ) {
        
        my $headline_id = $ug->create_str();
        
        $sql->Do(" DELETE FROM index_mapping WHERE entity=? AND parent=? AND child=? ", [ $EditionId, $headline->{fascicle}, $headline_id ]);
        $sql->Do(" INSERT INTO index_mapping(entity, parent, child) VALUES (?,?,?)", [ $EditionId, $headline->{fascicle}, $headline_id ]);
        
        $sql->Do(" DELETE FROM index WHERE variation='headline' AND title=? AND edition=?", [ $headline->{title}, $EditionId ]);
        $sql->Do("
            INSERT INTO index(id, edition, variation, title, shortcut, description, created, updated)
            VALUES (?, ?, 'headline', ?, ?, ?, now(), now());
        ", [$headline_id, $EditionId, $headline->{title}, $headline->{title}, $headline->{description} || "" ]);
        
        # Import rubrics
        
        my $rubrics = $sql2->Q(" SELECT uuid, title, description FROM edition.rubric WHERE catchword=? ", [ $headline->{uuid} ])->Hashes;
        
        foreach my $rubric ( @{ $rubrics } ) {
            
            my $rubric_id = $ug->create_str();
            
            $sql->Do(" DELETE FROM index_mapping WHERE entity=? AND parent=? AND child=? ", [ $headline->{fascicle}, $headline_id, $rubric_id ]);
            $sql->Do(" INSERT INTO index_mapping(entity, parent, child) VALUES (?,?,?)", [ $headline->{fascicle}, $headline_id, $rubric_id ]);
            
            $sql->Do(" DELETE FROM index WHERE variation='rubric' AND title=? AND edition=? ", [ $rubric->{title}, $EditionId ]);
            $sql->Do("
                INSERT INTO index(id, edition, variation, title, shortcut, description, created, updated)
                VALUES (?, ?, 'rubric', ?, ?, ?, now(), now());
            ", [$rubric_id, $EditionId, $rubric->{title}, $rubric->{title}, $rubric->{description} || "" ]);
        }
    }
}