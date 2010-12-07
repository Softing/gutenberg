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
my $sql_new = new Inprint::Frameworks::SQL();
$sql_new->SetConnection($conn);

my $sql_old = new Inprint::Frameworks::SQL();
$sql_old->SetConnection($conn2);

my $rootnode = '00000000-0000-0000-0000-000000000000';

$sql_new->Do("DELETE FROM fascicles");
$sql_new->Do("DELETE FROM index_fascicles");

# Import default fascicles
$sql_new->Do("
    INSERT INTO fascicles(id, base_edition, edition, variation, title, shortcut, description, is_system, is_enabled, is_blocked, created, updated)
    VALUES (?, ?, ?, ?, ?, ?, ?, true, true, false, now(), now());
", [ '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', "Портфель", "Портфель", "Портфель материалов" ]);

$sql_new->Do("
    INSERT INTO fascicles(id, base_edition, edition, variation, title, shortcut, description, is_system, is_enabled, is_blocked, created, updated)
    VALUES (?, ?, ?, ?, ?, ?, ?, true, true, false, now(), now());
", [ '99999999-9999-9999-9999-999999999999', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', "Корзина", "Корзина", "Корзина материалов" ]);


# Import fascicles
my $fascicles = $sql_old->Q(" SELECT id, edition, ownedby, title, dt_started, dt_closed, dt_closed > now() AS enabled FROM edition.calendar ")->Hashes;

foreach my $item( @{ $fascicles } ) {

    my $edition_id = $sql_new->Q(" SELECT newid FROM migration WHERE oldid=? AND mtype = 'edition' ", [ $item->{edition} ])->Value;
    
    die "Can't find edition id $item->{edition}" unless $edition_id;
    
    $sql_new->Do("
        INSERT INTO fascicles(id, base_edition, edition, variation, title, shortcut, description, begindate, enddate, is_system, is_enabled, is_blocked, created, updated)
        VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, false, ?, false, now(), now());
    ", [ $item->{id}, $edition_id, $edition_id, $item->{id}, $item->{title}, $item->{title}, $item->{title}, $item->{dt_started}, $item->{dt_closed}, $item->{enabled} ]);
    
    my $headlines = $sql_old->Q("
        SELECT uuid, base_uuid, fascicle, title, description FROM edition.catchword WHERE fascicle=?;
    ", [ $item->{id} ])->Hashes;
    
    foreach my $item2 ( @{ $headlines } ) {
        
        my $headline = $sql_new->Q("
            SELECT * FROM index WHERE edition=? AND nature=? AND shortcut=?;
        ", [ $edition_id, "headline", $item2->{title} ])->Hash;
        
        if ($headline) {
            
            $sql_new->Do("
                INSERT INTO index_fascicles( edition, fascicle, entity, nature, parent, title, shortcut, description, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now());
            ", [$edition_id, $item->{id}, $headline->{id}, 'headline', $item->{id}, $headline->{title}, $headline->{shortcut}, $headline->{description} || "" ]);
            
            my $rubrics = $sql_old->Q("
                SELECT uuid, base_uuid, catchword, title, description, fascicle FROM edition.rubric WHERE catchword=?;
            ", [ $headline->{uuid} ])->Hashes;
            
            foreach my $item3 ( @{ $rubrics } ) {
                
                my $rubric = $sql_new->Q("
                    SELECT * FROM index WHERE edition=? AND nature=? AND shortcut=?;
                ", [ $edition_id, "rubric", $item3->{title} ])->Hash;
                
                if ($rubric) {
                    
                    $sql_new->Do("
                        INSERT INTO index_fascicles( edition, fascicle, entity, nature, parent, title, shortcut, description, created, updated)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now());
                    ", [$edition_id, $item->{id}, $rubric->{id}, 'headline', $headline->{id}, $rubric->{title}, $rubric->{shortcut}, $rubric->{description} || "" ]);
                } else {
                    print "Can't find rubric $item3->{title}\n";
                }
            }
        } else {
            print "Can't find headline $item2->{title}\n";
        }
    }
    
}
