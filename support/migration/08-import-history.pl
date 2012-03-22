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
my $conn  = DBIx::Connector->new($dsn,  $dbusername, $dbpassword, $atr );
my $conn2 = DBIx::Connector->new($dsn2, $dbusername, $dbpassword, $atr );

# Create SQL mappings
my $sql = new Inprint::Frameworks::SQL();
$sql->SetConnection($conn);

my $sql2 = new Inprint::Frameworks::SQL();
$sql2->SetConnection($conn2);

my $rootnode = '00000000-0000-0000-0000-000000000000';

$sql->Do("DELETE FROM history ");
$sql->Do(" DELETE FROM profiles WHERE id = '00000000-0000-0000-0000-000000000000' ");

# Import history

$sql->Do("
    INSERT INTO profiles(id, title, shortcut, position, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', 'not found', 'not found', 'not found', now(), now());
");

my $count = 0;

my $history = $sql2->Q("
    SELECT
        uuid, edition, object_uuid, status_uuid, status_title, status_description,
        status_percent, status_color, member_uuid, member_title, member_type, created
  FROM exchange2.history
  ORDER BY created DESC LIMIT 100000
")->Hashes;

foreach my $item( @{ $history } ) {

    say $count++;

    # Get document id

    my $Document = $sql->Q("
            SELECT * FROM documents WHERE id=?
        ", [ $item->{object_uuid} ])->Hash;

    die "Can't find document $item->{object_uuid}" unless $Document->{id};

    # Get Stage

    my $idStage = $sql->Q("
            SELECT newid FROM migration WHERE oldid=? AND mtype = 'stage'
        ", [ $item->{status_uuid} ])->Value;
    die "Can't find stage id $item->{status_uuid}" unless $idStage;

    my $Stage = $sql->Q("
            SELECT * FROM stages WHERE id=?
        ", [ $idStage ])->Hash;

    die "Can't find stage object $idStage" unless $Stage;

    # Get Status

    my $Readiness = $sql->Q("
            SELECT * FROM readiness WHERE id=?
        ", [ $Stage->{readiness} ])->Hash;

    die "Can't find readiness object " unless $Readiness;

    # Get Branch

    my $Branch = $sql->Q("
            SELECT * FROM branches WHERE id=?
        ", [ $Stage->{branch} ])->Hash;

    die "Can't find branch object $Stage->{branch}" unless $Branch;

    # Get Sender

    my $SenderId = $sql2->Q("
        select member_uuid from exchange2.history where created <= ?
        order by created desc limit 1 offset 1
    ", [ $item->{created} ])->Value || $item->{member_uuid};

    my $Sender = $sql->Q(" SELECT * FROM view_principals WHERE id=? ", [ $SenderId ])->Hash;


    say "Can't find sender object $SenderId" unless $Sender;
    next unless $Sender;

    # Sender edition

    my $SenderEditionId = $sql->Q("
        SELECT newid FROM migration WHERE mtype='edition' AND oldid=?
    ", [ $item->{edition} ])->Value;

    say "Can't find edition id $item->{edition}" unless $SenderEditionId;

    my $SenderEdition = $sql->Q("
        SELECT * FROM editions WHERE id=?
    ", [ $SenderEditionId ])->Hash;

    say "Can't find edition object $SenderEditionId" unless $SenderEdition;

    # Sender catalog

    my $SenderDepartmentId = $sql2->Q("
        SELECT department FROM passport.member_department WHERE edition=? AND member=? LIMIT 1
    ", [ $item->{edition}, $SenderId ])->Value;
    say "Can't find sender department id $item->{edition}, $SenderId" unless $SenderDepartmentId;
    my $SenderCatalog = $sql->Q(" SELECT * FROM catalog WHERE id = ? ", [ $SenderDepartmentId || '00000000-0000-0000-0000-000000000000' ])->Hash;
    say "Can't find sender department $SenderDepartmentId" unless $SenderCatalog;

    unless ($SenderCatalog) {
        my $SenderCatalogId = $sql->Q("
            SELECT newid FROM migration WHERE mtype='catalog' AND oldid=?
        ", [ $item->{edition} ])->Value;
        $SenderCatalog = $sql->Q(" SELECT * FROM catalog WHERE id = ? ", [ $SenderCatalogId ])->Hash;
    }

    die "Can't find sender department" unless $SenderCatalog;

    # Get Receiver
    my $Receiver = $sql->Q(" SELECT * FROM view_principals WHERE id=? ", [ $item->{member_uuid} ])->Hash;

    say "Can't find receiver object $item->{member_uuid}" unless $Receiver;
    next unless $Receiver;

    # Receiver edition

    my $ReceiverEditionId = $sql->Q("
        SELECT newid FROM migration WHERE mtype='edition' AND oldid=?
    ", [ $item->{edition} ])->Value;
    say "Can't find edition id $item->{edition}" unless $ReceiverEditionId;

    my $ReceiverEdition = $sql->Q("
        SELECT * FROM editions WHERE id=?
    ", [ $ReceiverEditionId ])->Hash;
    say "Can't find edition object $ReceiverEditionId" unless $ReceiverEdition;

    # Receiver catalog

    my $ReceiverDepartmentId = $sql2->Q("
        SELECT department FROM passport.member_department WHERE edition=? AND member=? LIMIT 1
    ", [ $item->{edition}, $item->{member_uuid} ])->Value;
    say "Can't find Receiver department id $item->{edition}, $item->{member_uuid}" unless $ReceiverDepartmentId;
    my $ReceiverCatalog = $sql->Q(" SELECT * FROM catalog WHERE id = ? ", [ $ReceiverDepartmentId || '00000000-0000-0000-0000-000000000000' ])->Hash;
    say "Can't find receiver department $ReceiverDepartmentId" unless $ReceiverCatalog;

    unless ($ReceiverCatalog) {
        my $ReceiverCatalogId = $sql->Q("
            SELECT newid FROM migration WHERE mtype='catalog' AND oldid=?
        ", [ $item->{edition} ])->Value;
        $ReceiverCatalog = $sql->Q(" SELECT * FROM catalog WHERE id = ? ", [ $ReceiverCatalogId ])->Hash;
    }

    die "Can't find sender department" unless $ReceiverCatalog;

    say "\t$Document->{id}";
    say "\t$Readiness->{color}, $Readiness->{weight}";

    say "\tBranch $Branch->{id}, $Branch->{shortcut}";
    say "\tStage $Stage->{id}, $Stage->{shortcut}";

    say "\tSender member $Sender->{id}, $Sender->{shortcut}";
    say "\tSender edition $SenderEdition->{id},   $SenderEdition->{shortcut}";
    say "\tSender catalog $SenderCatalog->{id}, $SenderCatalog->{shortcut}";

    say "\tReceiver member $Receiver->{id}, $Receiver->{shortcut}";
    say "\tReceiver edition $ReceiverEdition->{id}, $ReceiverEdition->{shortcut}";
    say "\tReceiver catalog $ReceiverCatalog->{id}, $ReceiverCatalog->{shortcut}";

    say "\t$item->{created}";
    say "--------------------------------------------------------";

    $sql->Do("
        INSERT INTO history(
            item,
            color, weight,
            branch, branch_shortcut,
            stage, stage_shortcut,
            sender, sender_shortcut, sender_edition, sender_edition_shortcut, sender_catalog, sender_catalog_shortcut,
            receiver, receiver_shortcut, receiver_edition, receiver_edition_shortcut, receiver_catalog, receiver_catalog_shortcut,
            created
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
    ", [
        $Document->{id},
        $Readiness->{color}, $Readiness->{weight},
        $Branch->{id}, $Branch->{shortcut},
        $Stage->{id}, $Stage->{shortcut},
        $Sender->{id},   $Sender->{shortcut},   $SenderEdition->{id},   $SenderEdition->{shortcut},   $SenderCatalog->{id}, $SenderCatalog->{shortcut},
        $Receiver->{id}, $Receiver->{shortcut}, $ReceiverEdition->{id}, $ReceiverEdition->{shortcut}, $ReceiverCatalog->{id}, $ReceiverCatalog->{shortcut},
        $item->{created}
    ]);

}
