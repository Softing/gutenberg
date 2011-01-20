#!/usr/bin/perl

use utf8;
use strict;

use Data::UUID;
use Data::Dump qw /dump/;
use DBIx::Connector;

use lib "../../lib";
use Inprint::Frameworks::Config;
use Inprint::Frameworks::SQL;
use Inprint::Models::Rubric;

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

# Create a connection.
my $conn  = DBIx::Connector->new($dsn,  $dbusername, $dbpassword, $atr );

# Create SQL mappings
my $sql = new Inprint::Frameworks::SQL();
$sql->SetConnection($conn);

my $rubrics = $sql->Q("
    SELECT *
    FROM indx_rubrics
    ORDER BY title ASC ")->Hashes;

my $cl = new C;



foreach my $item (@$rubrics) {

    print "$item->{id}, $item->{headline}, $item->{bydefault}, $item->{title}, $item->{description} \n";
    Inprint::Models::Rubric::update($cl, $item->{id}, $item->{edition}, $item->{headline}, $item->{bydefault}, $item->{title}, $item->{description} );

}

package C;

  sub new {
    my $class = shift;
    my %args = @_;
    bless {color=>$args{'color'}, petname=>$args{'petname'}, street=>{'street'} }, $class;
  }

  sub sql { return $sql; }

1;
