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

foreach my $fascicle ( @{ $fascicles } ) {

    my $edition_id = $sql_new->Q(" SELECT newid FROM migration WHERE oldid=? AND mtype = 'edition' ", [ $fascicle->{edition} ])->Value;
    
    die "Can't find edition id $fascicle->{edition}" unless $edition_id;
    
    $sql_new->Do("
        INSERT INTO fascicles(id, base_edition, edition, variation, title, shortcut, description, begindate, enddate, is_system, is_enabled, is_blocked, created, updated)
        VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, false, ?, false, now(), now());
    ", [ $fascicle->{id}, $edition_id, $edition_id, $fascicle->{id}, $fascicle->{title}, $fascicle->{title}, $fascicle->{title}, $fascicle->{dt_started}, $fascicle->{dt_closed}, $fascicle->{enabled} ]);
    
    # Select headline from old db
    
    my $old_headlines = $sql_old->Q("
        SELECT uuid, base_uuid, fascicle, title, description FROM edition.catchword WHERE fascicle=?;
    ", [ $fascicle->{id} ])->Hashes;
    
    foreach my $old_headline ( @{ $old_headlines } ) {
        
        # Select headline from new db
        
        my $headline = $sql_new->Q("
            SELECT * FROM index WHERE edition=? AND nature=? AND shortcut=?;
        ", [ $edition_id, "headline", $old_headline->{title} ])->Hash;
        
        if ($headline) {
            
            $sql_new->Do("
                INSERT INTO index_fascicles(
                    edition, fascicle, origin, parent,
                    nature, title, shortcut, description, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now());
            ", [
                    $edition_id, $fascicle->{id}, $headline->{id}, $fascicle->{id},
                    'headline', $headline->{title}, $headline->{shortcut}, $headline->{description} || "" ]);
            
            # Select rubrics from old db
            
            my $old_rubrics = $sql_old->Q("
                SELECT uuid, base_uuid, catchword, title, description, fascicle FROM edition.rubric WHERE catchword=?;
            ", [ $headline->{uuid} ])->Hashes;
            
            foreach my $old_rubric ( @{ $old_rubrics } ) {
                
                # Select rubric from new db
                
                my $rubric = $sql_new->Q("
                    SELECT * FROM index WHERE edition=? AND nature=? AND shortcut=?;
                ", [ $edition_id, "rubric", $old_rubric->{title} ])->Hash;
                
                if ($rubric) {
                    
                    $sql_new->Do("
                        INSERT INTO index_fascicles(
                            edition, fascicle, origin, parent, nature,
                            title, shortcut, description, created, updated)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now());
                    ", [
                            $edition_id, $fascicle->{id}, $rubric->{id}, $headline->{id},
                            'headline', $rubric->{title}, $rubric->{shortcut}, $rubric->{description} || "" ]);
                    
                } else {
                    print "Can't find rubric $old_rubric->{title}\n";
                }
                
            }
        } else {
            print "Can't find headline $old_headline->{title}\n";
        }
    }
    
}
