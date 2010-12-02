#!/usr/bin/perl

use utf8;
use strict;
use feature qw(say);

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
my $con_new = DBIx::Connector->new($dsn,  $dbusername, $dbpassword, $atr );
my $con_old = DBIx::Connector->new($dsn2, $dbusername, $dbpassword, $atr );

# Create SQL mappings
my $sql_new = new Inprint::Frameworks::SQL();
$sql_new->SetConnection($con_new);

my $sql_old = new Inprint::Frameworks::SQL();
$sql_old->SetConnection($con_old);

my $count;
my $rootnode = '00000000-0000-0000-0000-000000000000';

$sql_new->Do(" DELETE FROM fascicles_pages ");

################################################################################
$count = 0;
say("Import pages");
my $pages = $sql_old->Q(" SELECT t1.* FROM edition.page as t1 ORDER BY fascicle, seqnum ")->Hashes;
foreach my $item ( @{ $pages } ) {
    
    my $fascicle = $sql_new->Q(" SELECT * FROM fascicles WHERE id=? ", [ $item->{fascicle} ])->Hash;
    my $edition = $sql_new->Q(" SELECT * FROM editions WHERE id=? ", [ $fascicle->{edition} ])->Hash;
    
    if( $edition && $fascicle ) {
        say "Import fascicle " . translit($fascicle->{shortcut}) ." page $item->{seqnum}";
        
        my $fpage = $sql_old->Q(" SELECT * FROM edition.fascicle_page WHERE page=?", [ $item->{uuid} ])->Hash;
        
        if ($fpage) {
            $item->{seqnum} = $fpage->{seqnum};
        }
        
        $sql_new->Do("
            INSERT INTO fascicles_pages(id, edition, fascicle, seqnum, w, h, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, now(), now());
        ", [ $item->{uuid}, $edition->{id}, $fascicle->{id}, $item->{seqnum}, 32, 32 ]);
        
        
        my $catchword = $sql_old->Q(" SELECT * FROM edition.catchword WHERE uuid=? ", [ $item->{catchword} ])->Hash;
        if ($catchword) {
            
            my $headline = $sql_new->Q(" SELECT * FROM index WHERE edition=? AND title=? ", [ $fascicle->{edition}, $catchword->{title} ])->Hash;
            
            if ($headline) {
                my $mapping  = $sql_new->Q(" SELECT * FROM index_mapping WHERE parent=? AND child=? ", [ $fascicle->{id}, $headline->{id} ])->Hash;
                unless ($mapping) {
                    $sql_new->Do(" DELETE FROM index_mapping WHERE parent=? AND child=? ", [ $fascicle->{id}, $headline->{id} ]);
                    $sql_new->Do(" INSERT INTO index_mapping (entity, parent, child) VALUES (?,?,?) ", [ $edition->{id}, $fascicle->{id}, $headline->{id} ]);
                }
                $sql_new->Do(" UPDATE fascicles_pages SET headline=? WHERE id=? ", [ $headline->{id}, $item->{uuid} ]);
            } else {
                die 1;
            }
        }

    } else {
        say $item->{fascicle};
    }
}

sub translit

    { ($_)=@_;
    
    #
    # Fonetic correct translit
    #
    
    s/Сх/S\'h/; s/сх/s\'h/; s/СХ/S\'H/;
    s/Ш/Sh/g; s/ш/sh/g;
    
    s/Сцх/Sc\'h/; s/сцх/sc\'h/; s/СЦХ/SC\'H/;
    s/Щ/Sch/g; s/щ/sch/g;
    
    s/Цх/C\'h/; s/цх/c\'h/; s/ЦХ/C\'H/;
    s/Ч/Ch/g; s/ч/ch/g;
    
    s/Йа/J\'a/; s/йа/j\'a/; s/ЙА/J\'A/;
    s/Я/Ja/g; s/я/ja/g;
    
    s/Йо/J\'o/; s/йо/j\'o/; s/ЙО/J\'O/;
    s/Ё/Jo/g; s/ё/jo/g;
    
    s/Йу/J\'u/; s/йу/j\'u/; s/ЙУ/J\'U/;
    s/Ю/Ju/g; s/ю/ju/g;
    
    s/Э/E\'/g; s/э/e\'/g;
    s/Е/E/g; s/е/e/g;
    
    s/Зх/Z\'h/g; s/зх/z\'h/g; s/ЗХ/Z\'H/g;
    s/Ж/Zh/g; s/ж/zh/g;
    
    tr/абвгдзийклмнопрстуфхцъыьАБВГДЗИЙКЛМHОПРСТУФХЦЪЫЬ/abvgdzijklmnoprstufhc\"y\'ABVGDZIJKLMNOPRSTUFHC\"Y\'/;
    
    return $_;

}

