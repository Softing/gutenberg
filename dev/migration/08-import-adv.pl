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

#$sql_new->Do(" DELETE FROM fascicles_pages ");
#$sql_new->Do(" DELETE FROM fascicles_map_documents ");

#$sql_new->Do(" DELETE FROM ad_places ");
#$sql_new->Do(" DELETE FROM ad_advertisers ");
#$sql_new->Do(" SELECT setval('ad_advertisers_serialnum_seq', 1); ");
$sql_new->Do(" DELETE FROM ad_requests ");
$sql_new->Do(" SELECT setval('ad_requests_serialnum_seq', 1); ");
#$sql_new->Do(" DELETE FROM ad_modules ");
#$sql_new->Do(" DELETE FROM fascicles_map_holes ");


#################################################################################
#$count = 0;
#say("Import pages");
#my $pages = $sql_old->Q(" SELECT t1.* FROM edition.page as t1 ORDER BY fascicle, seqnum ")->Hashes;
#foreach my $item ( @{ $pages } ) {
#    
#    my $fascicle = $sql_new->Q(" SELECT * FROM fascicles WHERE id=? ", [ $item->{fascicle} ])->Hash;
#    my $edition = $sql_new->Q(" SELECT * FROM editions WHERE id=? ", [ $fascicle->{edition} ])->Hash;
#    
#    if( $edition && $fascicle ) {
#        say "Import fascicle " . translit($fascicle->{shortcut}) ." page $item->{seqnum}";
#        
#        my $fpage = $sql_old->Q(" SELECT * FROM edition.fascicle_page WHERE page=?", [ $item->{uuid} ])->Hash;
#        
#        if ($fpage) {
#            $item->{seqnum} = $fpage->{seqnum};
#        }
#        
#        $sql_new->Do("
#            INSERT INTO fascicles_pages(id, edition, fascicle, seqnum, w, h, created, updated)
#            VALUES (?, ?, ?, ?, ?, ?, now(), now());
#        ", [ $item->{uuid}, $edition->{id}, $fascicle->{id}, $item->{seqnum}, 32, 32 ]);
#        
#        
#        my $catchword = $sql_old->Q(" SELECT * FROM edition.catchword WHERE uuid=? ", [ $item->{catchword} ])->Hash;
#        if ($catchword) {
#            
#            my $headline = $sql_new->Q(" SELECT * FROM index WHERE edition=? AND title=? ", [ $fascicle->{edition}, $catchword->{title} ])->Hash;
#            
#            if ($headline) {
#                my $mapping  = $sql_new->Q(" SELECT * FROM index_mapping WHERE parent=? AND child=? ", [ $fascicle->{id}, $headline->{id} ])->Hash;
#                unless ($mapping) {
#                    $sql_new->Do(" DELETE FROM index_mapping WHERE parent=? AND child=? ", [ $fascicle->{id}, $headline->{id} ]);
#                    $sql_new->Do(" INSERT INTO index_mapping (entity, parent, child) VALUES (?,?,?) ", [ $edition->{id}, $fascicle->{id}, $headline->{id} ]);
#                }
#                $sql_new->Do(" UPDATE fascicles_pages SET headline=? WHERE id=? ", [ $headline->{id}, $item->{uuid} ]);
#            } else {
#                die 1;
#            }
#        }
#
#    } else {
#        say $item->{fascicle};
#    }
#}
#
#
#################################################################################
#$count = 0;
#say("Import documents");
#my $documents = $sql_old->Q(" SELECT fascicle, page, document FROM edition.document")->Hashes;
#foreach my $item ( @{ $documents } ) {
#    
#    #say $count++;
#    
#    my $fascicle = $sql_new->Q(" SELECT * FROM fascicles WHERE id=? ", [ $item->{fascicle} ])->Hash;
#    my $edition  = $sql_new->Q(" SELECT * FROM editions WHERE id=? ",  [ $fascicle->{edition} ])->Hash;
#    my $document = $sql_new->Q(" SELECT * FROM documents WHERE id=? ", [ $item->{document} ])->Hash;
#    my $page     = $sql_new->Q(" SELECT * FROM fascicles_pages WHERE id=? ", [ $item->{page} ])->Hash;
#    
#    if( $edition && $fascicle && $document && $page ) {
#        say "Map document $document->{id} to page $page->{seqnum} for fascicle ". translit($fascicle->{shortcut});
#        $sql_new->Do("
#            INSERT INTO fascicles_map_documents(edition, fascicle, page, entity, created, updated)
#            VALUES (?, ?, ?, ?, now(), now());
#        ", [ $edition->{id}, $fascicle->{id}, $page->{id}, $item->{id} ]);
#    } else {
#        say "Cant find page $item->{page} for fascicle ". translit($fascicle->{shortcut});
#    }
#}


#################################################################################
#$count = 0;
#say("Import places ");
#my $places = $sql_old->Q(" SELECT uuid, fascicle, title, description, deleted, created FROM edition.adv_places; ")->Hashes;
#foreach my $item ( @{ $places } ) {
#    
#    #say $count++;
#    
#    my $fascicle = $sql_new->Q(" SELECT * FROM fascicles WHERE id=? ", [ $item->{fascicle} ])->Hash;
#    my $edition = $sql_new->Q(" SELECT * FROM editions WHERE id=? ", [ $fascicle->{edition} ])->Hash;
#    
#    if( $edition && $fascicle ) {
#        say "Import place $item->{uuid}";
#        $sql_new->Do("
#            INSERT INTO ad_places(id, edition, fascicle, title, shortcut, description, created, updated)
#            VALUES (?, ?, ?, ?, ?, ?, now(), now());
#        ", [ $item->{uuid}, $edition->{id}, $fascicle->{id}, $item->{title}, $item->{stitle} || $item->{title}, "" ]);
#    } else {
#        say $item->{fascicle};
#    }
#}



#################################################################################
#$count = 0;
#say("Import advertisers");
#my $advertisers = $sql_old->Q(" SELECT uuid, edition, title, stitle FROM adv.advertiser; ")->Hashes;
#foreach my $item( @{ $advertisers } ) {
#    
#    #say $count++;
#    
#    my $edition = $sql_new->Q(" SELECT t1.* FROM editions t1, migration t2 WHERE t1.id = t2.newid AND t2.oldid=? ", [ $item->{edition} ])->Hash;
#    
#    if( $edition ) {
#        say "Import advertiser $item->{uuid}";
#        $sql_new->Do("
#            INSERT INTO ad_advertisers(id, edition, title, shortcut, created, updated)
#            VALUES (?, ?, ?, ?, now(), now());
#        ", [ $item->{uuid}, $edition->{id}, $item->{title}, $item->{stitle} ]);
#    } else {
#        say $item->{edition};
#    }
#}



################################################################################
$count = 0;
say("Import requests");
my $requests = $sql_old->Q(" SELECT uuid, advertiser, fascicle, page, place, size, description FROM adv.request; ")->Hashes;
foreach my $item( @{ $requests } ) {
    
    #say $count++;
    
    my $fascicle   = $sql_new->Q(" SELECT * FROM fascicles WHERE id=? ", [ $item->{fascicle} ])->Hash;
    my $edition    = $sql_new->Q(" SELECT * FROM editions WHERE id=? ", [ $fascicle->{edition} ])->Hash;
    my $place      = $sql_new->Q(" SELECT * FROM ad_places WHERE id=? ", [ $item->{place} ])->Hash;
    my $advertiser = $sql_new->Q(" SELECT * FROM ad_advertisers WHERE id=? ", [ $item->{advertiser} ])->Hash;
    
    if ($fascicle && $edition && $advertiser) {
        say "Import request $item->{uuid}";
        my $title = "Заявка от <$advertiser->{title}> в выпуск <$fascicle->{title}>";
        my $shortcut = "<$advertiser->{title}> в <$fascicle->{title}>";
        $sql_new->Do("
            INSERT INTO ad_requests (id, edition,  advertiser, fascicle, place, title, shortcut, manager, status, payment, readiness, created, updated) 
            VALUES (?, ?, ?, ?, ?, ?, ?, null, 0, 0, 0, now(), now());
        ", [ $item->{uuid}, $edition->{id}, $advertiser->{id}, $fascicle->{id}, $place->{id}, $title, $shortcut ]);
    } else {
        say $item->{advertiser};
    }
}


#################################################################################
#$count = 0;
#say("Import modules");
#
#my $modsizes = {
#    '1/32'              => { size => 0.03,  w=>1,  h=>1,  amount => 1 },
#    '1/16'              => { size => 0.06,  w=>2,  h=>2,  amount => 1 },
#    '1/12'              => { size => 0.083, w=>3,  h=>3,  amount => 1 },
#    '1/8'               => { size => 0.12,  w=>4,  h=>4,  amount => 1 },
#    '1/8 верт'          => { size => 0.12,  w=>4,  h=>4,  amount => 1 },
#    '1/8 вертик'        => { size => 0.12,  w=>4,  h=>4,  amount => 1 },
#    '1/8 гор'           => { size => 0.12,  w=>4,  h=>4,  amount => 1 },
#    '1/8 гориз'         => { size => 0.12,  w=>4,  h=>4,  amount => 1 },
#    '1/6 вер'           => { size => 0.16,  w=>5,  h=>5,  amount => 1 },
#    '1/6 верт'          => { size => 0.16,  w=>5,  h=>5,  amount => 1 },
#    '1/6 гор'           => { size => 0.16,  w=>5,  h=>5,  amount => 1 },
#    '1/4'               => { size => 0.25,  w=>8,  h=>8,  amount => 1 },
#    '1/4 вер'           => { size => 0.25,  w=>8,  h=>8,  amount => 1 },
#    '1/4 верт'          => { size => 0.25,  w=>8,  h=>8,  amount => 1 },
#    '1/4 гор'           => { size => 0.25,  w=>8,  h=>8,  amount => 1 },
#    '1/4 квадр'         => { size => 0.25,  w=>8,  h=>8,  amount => 1 },
#    '1/3'               => { size => 0.33,  w=>10, h=>10, amount => 1 },
#    '1/3 вер'           => { size => 0.33,  w=>10, h=>10, amount => 1 },
#    '1/3 верт'          => { size => 0.33,  w=>10, h=>10, amount => 1 },
#    '1/3 гор'           => { size => 0.33,  w=>10, h=>10, amount => 1 },
#    '1/2 вер'           => { size => 0.5,   w=>16, h=>16, amount => 1 },
#    '1/2 вер б/п'       => { size => 0.5,   w=>16, h=>16, amount => 1 },
#    '1/2 верт'          => { size => 0.5,   w=>16, h=>16, amount => 1 },
#    '1/2 верт б/п'      => { size => 0.5,   w=>16, h=>16, amount => 1 },
#    '1/2 верт.'         => { size => 0.5,   w=>16, h=>16, amount => 1 },
#    '1/2 гор'           => { size => 0.5,   w=>16, h=>16, amount => 1 },
#    '1/2 гор б/п'       => { size => 0.5,   w=>16, h=>16, amount => 1 },
#    '1/2 гор.'          => { size => 0.5,   w=>16, h=>16, amount => 1 },
#    '2/3 вер'           => { size => 0.66,  w=>21, h=>21, amount => 1 },
#    '2/3 верт'          => { size => 0.66,  w=>21, h=>21, amount => 1 },
#    '1/1'               => { size => 1,     w=>32, h=>32, amount => 1 },
#    '2/1'               => { size => 2,     w=>32, h=>32, amount => 2 },
#    'гейтфолдер'        => { size => 2,     w=>32, h=>32, amount => 2 },
#    'ЖВ'                => { size => 2,     w=>32, h=>32, amount => 2 },
#    'Клапан'            => { size => 2,     w=>32, h=>32, amount => 2 },
#    'буклет'            => { size => 0,     w=>21, h=>21, amount => 1 },
#    'Вложение'          => { size => 0,     w=>21, h=>21, amount => 1 },
#    'Вложение (буклет)' => { size => 0,     w=>21, h=>21, amount => 1 },
#    'гейтфолдер'        => { size => 0,     w=>21, h=>21, amount => 1 },
#    'логотип'           => { size => 0,     w=>21, h=>21, amount => 1 },
#};
#
#my $modules = $sql_old->Q("
#    SELECT t2.uuid, t2.fascicle, t2.title, t2.description, t2.size, t2.deleted, t2.created, t1.place
#    FROM edition.adv_matrix t1, edition.adv_sizes t2 WHERE t1.size = t2.uuid ORDER BY t2.size
#")->Hashes;
#foreach my $item( @{ $modules } ) {
#    
#    #say $count++;
#    
#    my $fascicle = $sql_new->Q(" SELECT * FROM fascicles WHERE id=? ", [ $item->{fascicle} ])->Hash;
#    my $edition  = $sql_new->Q(" SELECT * FROM editions WHERE id=? ", [ $fascicle->{edition} ])->Hash;
#    my $place    = $sql_new->Q(" SELECT * FROM ad_places WHERE id=? ", [ $item->{place} ])->Hash;
#    
#    my $amount = $modsizes->{$item->{title}}->{amount};
#    my $volume = $modsizes->{$item->{title}}->{size};
#    my $w = $modsizes->{$item->{title}}->{w};
#    my $h = $modsizes->{$item->{title}}->{h};
#    
#    if( $edition && $fascicle && $place && $amount >= 0 && $volume >= 0 && $w >= 0 && $h >= 0 ) {
#        say "Import module $item->{uuid}";
#        $sql_new->Do("
#            INSERT INTO ad_modules(edition, fascicle, place, title, shortcut, description, amount, volume, w, h, created, updated) 
#            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now());
#        ", [ $edition->{id}, $fascicle->{id}, $place->{id}, $item->{title}, $item->{title}, "", $amount, $volume, $w, $h ]);
#    } else {
#        say "$fascicle && $amount && $volume && $w && $h";
#    }
#}


#################################################################################
#$count = 0;
#say("Import holes");
#my $holes = $sql_old->Q(" select t1.*, t2.title, t2.size from edition.hole t1, edition.adv_sizes t2 where t1.size = t2.uuid  ")->Hashes;
#foreach my $item( @{ $holes } ) {
#    
#    say $count++;
#    
#    my $fascicle = $sql_new->Q(" SELECT * FROM fascicles WHERE id=? ", [ $item->{fascicle} ])->Hash;
#    my $edition  = $sql_new->Q(" SELECT * FROM editions WHERE id=? ", [ $fascicle->{edition} ])->Hash;
#    
#    my $place    = $sql_new->Q(" SELECT * FROM ad_places WHERE id=? ", [ $item->{place} ])->Hash;
#    my $page     = $sql_new->Q(" SELECT * FROM fascicles_pages WHERE id=? ", [ $item->{page} ])->Hash;
#    my $module   = $sql_new->Q(" SELECT * FROM ad_modules WHERE fascicle=? AND place=? AND shortcut=?", [ $item->{fascicle}, $place->{id}, $item->{title} ])->Hash;
#    
#    unless ($module) {
#        my $module_any  = $sql_new->Q(" SELECT * FROM ad_modules WHERE shortcut=? LIMIT 1", [ $item->{title} ])->Hash;
#        if ($module_any) {
#            $sql_new->Do("
#                INSERT INTO ad_modules(edition, fascicle, place, shortcut, amount, volume, w, h, created, updated) 
#                VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now());
#            ", [ $edition->{id}, $fascicle->{id}, $place->{id}, $item->{title}, $module_any->{amount}, $module_any->{volume}, $module_any->{w}, $module_any->{h} ]);
#            $module   = $sql_new->Q(" SELECT * FROM ad_modules WHERE fascicle=? AND place=? AND shortcut=?", [ $item->{fascicle}, $place->{id}, $item->{title} ])->Hash;
#        }
#    }
#    
#    if ($edition && $fascicle && $place && $page && $module) {
#        say "Import hole $item->{uuid}";
#        $sql_new->Do("
#            INSERT INTO fascicles_map_holes(id, edition, fascicle, place, module, page, entity, x, y, w, h, created, updated)
#            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now());
#        ", [ $item->{uuid}, $edition->{id}, $fascicle->{id}, $place->{id}, $page->{id}, $module->{id}, undef, 0, 0, $module->{w}, $module->{h} ]);
#    } else {
#        say "$edition >> $fascicle >> $place >> $page >> $module";
#    }
#}

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

