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

# Create a connection.
my $conn  = DBIx::Connector->new($dsn,  $dbusername, $dbpassword, $atr );

# Create SQL mappings
my $sql = new Inprint::Frameworks::SQL();
$sql->SetConnection($conn);

$sql->Do(" DELETE FROM cache_access ");

# Import roles

my $c = 1;

my $rules = $sql->Q(" 
        SELECT id, member, section, area, binding, term 
        FROM map_member_to_rule ORDER BY member, section, area, binding, term ")->Hashes;

foreach my $item( @{ $rules } ) {

    print "$c  $item->{id}, $item->{member}, $item->{section}, $item->{area}, $item->{binding}, $item->{term} \n";;
    $c++;

    my $member  = $sql->Q(" SELECT * FROM members WHERE id=? ", [ $item->{member} ])->Hash;
    
    $sql->bt;
    if ($member->{id}) {
        $sql->Do("DELETE FROM map_member_to_rule WHERE id=?", [ $item->{id} ]);
        $sql->Do("
            INSERT INTO map_member_to_rule (id, member, section, area, binding, term)
                VALUES (?, ?, ?, ?, ?, ?);
        ", [ $item->{id}, $item->{member}, $item->{section}, $item->{area}, $item->{binding}, $item->{term} ]);
    } else {
        #$sql->Do("DELETE FROM map_member_to_rule WHERE id=?", [ $item->{id} ]);    
    }
    $sql->et;


}
