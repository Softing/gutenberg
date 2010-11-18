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

binmode STDOUT, ":utf8";

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

$sql->Do("DELETE FROM documents");
$sql->Do("DELETE FROM map_documents_to_fascicles");

# Import documents

my $documents = $sql2->Q("
    SELECT
        id, uuid, edition, fascicle, theowner, creator, manager, department,
        progress, title, author, section, rubric, planned_size, planned_date,
        real_date, status, look, block, trash, createdold, updatedold,
        created, updated, isopen, fascicle_name, edition_name, edition_sname,
        department_name, section_name, rubric_name, owner_nick, manager_nick,
        image_count, file_count, calibr_real, page,
        ( SELECT card.stitle FROM views.\"passport.owners\" card WHERE card.uuid = creator) AS creator_nick,
        to_char(created, 'YYYY/MM') as filepath
    FROM views.documents
    -- WHERE uuid = 'e009789c-7da2-47a5-b9d3-0dfae34515df'
    -- WHERE trash = 1
    -- LIMIT 30
 ")->Hashes;

my $counter=0;
my @errors;

foreach my $item( @{ $documents } ) {

    $counter++;

    print "------------------------------------------------------------\n";
    print ">>$counter\n";
    print "$item->{uuid}\n";
    #print "$item->{theowner}, $item->{creator}, $item->{manager}, $item->{owner_nick}, $item->{creator_nick}, $item->{manager_nick}\n";
    #print "$item->{edition}, $item->{edition_sname}, []\n";
    #print "$item->{look}, $item->{isopen}\n";
    #print "$item->{title}, $item->{author}\n";
    #print "$item->{section}, $item->{section_name}, $item->{rubric}, $item->{rubric_name}\n";
    #print "$item->{planned_date}, $item->{planned_size}, $item->{real_date}, $item->{calibr_real}\n";
    #print "$item->{image_count}, $item->{file_count}\n";
    #print "$item->{created}, $item->{updated}\n";
    print "------------------------------------------------------------\n\n";

    # Editions
    my $EditionId = $sql->Q(" SELECT newid FROM migration WHERE oldid=? AND mtype = 'edition' ", [ $item->{edition} ])->Value;
    die "Can't find edition id $item->{edition}" unless $EditionId;

    my $Edition = $sql->Q(" SELECT * FROM editions WHERE id = ? ",
        [ $EditionId ])->Hash;
    die "Can't find edition object $EditionId" unless $Edition;

    # Select Editions index
    my $Editions = $sql->Q("
        SELECT ARRAY( select id from editions where path @> ( select path from editions where id = ? ) )
    ", [ $EditionId ])->Array;

    # Oldstate
    my $oldstate = $sql2->Q("
        SELECT uuid, edition, object_uuid, status_uuid, member_uuid, created
        FROM exchange2.state
        WHERE object_uuid=?
    ", [$item->{uuid}])->Hash;
    push @errors, { id=>"oldstate", text=>"Cant found old status $item->{uuid}" } unless ($oldstate);

    # Select Branch
    my $Branch = $sql->Q(" SELECT * FROM branches WHERE edition=? ", [ $EditionId ])->Hash;
    die "Cant found branch $EditionId" unless ($Branch);

    my $Stage = {};
    my $Readiness  = {};

    if ($oldstate) {

        # Select stage
        my $StageId = $sql->Q(" SELECT newid FROM migration WHERE oldid=? AND mtype = 'stage' ", [ $oldstate->{status_uuid} ])->Value;
        die "Cant found stage id $oldstate->{status_uuid}" unless ($StageId);

        $Stage = $sql->Q(" SELECT * FROM stages WHERE id=? ", [ $StageId ])->Hash;
        die "Cant found stage object $StageId " unless ($Stage);

    } else {

        $Stage = $sql->Q(" SELECT * FROM stages WHERE branch=? ORDER BY weight LIMIT 1 ", [ $Branch->{id} ])->Hash;
        die "Cant found stage object by Branch $Branch->{id}" unless ($Stage);
    }

    # Select readiness
    $Readiness = $sql->Q(" SELECT * FROM readiness WHERE id=? ", [ $Stage->{readiness} ])->Hash;
    die "Cant found readiness object $Stage->{readiness}" unless ($Readiness);

    # Found catalog folder

    my $CatalogID = $sql->Q(" SELECT newid FROM migration WHERE oldid=? AND mtype = 'catalog' ", [ $item->{edition} ])->Value;
    die "Cant find catalog id $item->{edition}" unless $CatalogID;

    my $Catalog = $sql->Q(" SELECT * FROM catalog WHERE id=? ", [ $CatalogID ])->Hash;
    die "Cant found catalog object $CatalogID" unless ($Catalog);

    my $catalog_folder   = $Catalog->{id};
    my $catalog_shortcut = $Catalog->{shortcut};

    if ($item->{department}) {
        my $department = $sql->Q(" SELECT id, shortcut FROM catalog WHERE id = ? ", [ $item->{department} ])->Hash;
        if ($department) {
            $catalog_folder = $department->{id};
            $catalog_shortcut = $department->{shortcut};
        }
    }

    # Map document to fascicle
    if ($item->{trash}) {
        $item->{fascicle} = '99999999-9999-9999-9999-999999999999';
        $item->{fascicle_name} = "Корзина";
    }

    if ($item->{fascicle} eq $rootnode || ! $item->{fascicle}) {
        $item->{fascicle} = $rootnode;
        $item->{fascicle_name} = "Портфель";
    }

    # Select groups index
    my $groups = $sql->Q("
        SELECT ARRAY( select id from catalog where path @> ( select path from catalog where id = ? ) )
    ", [ $catalog_folder ])->Array;

    # Other fields

    $item->{theowner} = '4f5ad92e-b3e7-4c54-937e-e70aa999c0c7' unless ($item->{theowner});
    $item->{creator}  = '4f5ad92e-b3e7-4c54-937e-e70aa999c0c7' unless ($item->{creator});
    $item->{manager}  = '4f5ad92e-b3e7-4c54-937e-e70aa999c0c7' unless ($item->{manager});

    $item->{owner_nick}    = 'Администратор' unless ($item->{owner_nick});
    $item->{creator_nick}  = 'Администратор' unless ($item->{creator_nick});
    $item->{manager_nick}  = 'Администратор' unless ($item->{manager_nick});

    $item->{look}   = 'false' unless ($item->{look});
    $item->{isopen} = 'false' unless ($item->{isopen});

    # Process Tags

    print "TAG1-1 - $Edition->{id} - $item->{section_name}\n";
    my $Tag1 = $sql->Q(" SELECT * FROM index WHERE edition=? AND title=? AND variation='headline' ", [ $Edition->{id}, $item->{section_name} || "--" ])->Hash;
    unless ($Tag1) {
        $sql->Do("
            INSERT INTO index(edition, variation, title, shortcut, description, created, updated)
            VALUES (?, 'headline', ?, ?, ?, now(), now());
        ", [$EditionId, $item->{section_name}, $item->{section_name}, '' ]);
        $Tag1 = $sql->Q(" SELECT * FROM index WHERE edition=? AND title=? AND variation='headline' ", [ $Edition->{id}, $item->{section_name} || "--" ])->Hash;
    }
    die unless $Tag1;
    
    print "TAG1-2 $Tag1->{id} = $Tag1->{title}, fascicle = $item->{fascicle}\n";
    my $Headline = $sql->Q(" SELECT * FROM index_mapping WHERE parent=? AND child=? ", [ $item->{fascicle}, $Tag1->{id} ])->Hash;
    unless ($Headline) {
        $sql->Do(" INSERT INTO index_mapping(entity,parent,child) VALUES (?,?,?); ", [ $Edition->{id}, $item->{fascicle}, $Tag1->{id} ]);
        $Headline = $sql->Q(" SELECT * FROM index_mapping WHERE parent=? AND child=? ", [ $item->{fascicle}, $Tag1->{id} ])->Hash;
    }
    die unless $Headline;

    print "TAG2-1 - $item->{rubric_name}\n" ;
    my $Tag2 = $sql->Q(" SELECT * FROM index WHERE edition=? AND title=? AND variation='rubric' ", [ $Edition->{id}, $item->{rubric_name} || "--" ])->Hash;
    unless ($Tag2) {
        $sql->Do("
            INSERT INTO index(edition, variation, title, shortcut, description, created, updated)
            VALUES (?, 'rubric', ?, ?, ?, now(), now());
        ", [$EditionId, $item->{rubric_name}, $item->{rubric_name}, '' ]);
        $Tag2 = $sql->Q(" SELECT * FROM index WHERE edition=? AND title=? AND variation='rubric' ", [ $Edition->{id}, $item->{rubric_name} || "--" ])->Hash;
    }
    die unless $Tag2;

    print "TAG2-2 = $Tag2->{title}, = $item->{fascicle} = $Headline->{id} = $Tag2->{id}\n";
    my $Rubric = $sql->Q(" SELECT * FROM index_mapping WHERE entity=? AND parent=? AND child=? ", [ $item->{fascicle}, $Tag1->{id}, $Tag2->{id} ])->Hash;
    unless ($Rubric) {
        $sql->Do(" INSERT INTO index_mapping(entity,parent,child) VALUES (?,?,?); ", [ $item->{fascicle}, $Tag1->{id}, $Tag2->{id} ]);
        $Rubric = $sql->Q(" SELECT * FROM index_mapping WHERE entity=? AND parent=? AND child=? ", [ $item->{fascicle}, $Tag1->{id}, $Tag2->{id} ])->Hash;
    }
    die unless $Rubric;

    # do insert
    $sql->Do("
        INSERT INTO documents(
            id,
            edition, edition_shortcut, ineditions,
            copygroup,
            workgroup, workgroup_shortcut, inworkgroups,
            holder, creator, manager, holder_shortcut, creator_shortcut, manager_shortcut,
            fascicle, fascicle_shortcut,
            headline, headline_shortcut,
            rubric, rubric_shortcut,
            islooked, isopen,
            branch, branch_shortcut, stage, stage_shortcut,
            readiness, readiness_shortcut, color, progress,
            title, author,
            pdate, psize, rdate, rsize,
            filepath, images, files,
            created, updated
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
    ",
    [
        $item->{uuid},
        $Edition->{id}, $Edition->{shortcut}, @$Editions[0],
        $item->{uuid},
        $catalog_folder, $catalog_shortcut, @$groups[0],
        $item->{theowner}, $item->{creator}, $item->{manager}, $item->{owner_nick}, $item->{creator_nick}, $item->{manager_nick},
        $item->{fascicle}, $item->{fascicle_name},
        $Tag1->{id}, $Tag1->{title},
        $Tag2->{id}, $Tag2->{title},
        $item->{look}, $item->{isopen},
        $Branch->{id}, $Branch->{title}, $Stage->{id}, $Stage->{title},
        $Readiness->{id}, $Readiness->{shortcut}, $Readiness->{color}, $Readiness->{weight},
        $item->{title}, $item->{author},
        $item->{planned_date}, $item->{planned_size}, $item->{real_date}, $item->{calibr_real},
        "/". $item->{filepath} ."/". $item->{uuid}, $item->{image_count}, $item->{file_count},
        $item->{created}, $item->{updated}
    ]);

}

# Import history

# Import files

# Import versions

my $errcount = 0;

foreach (@errors) {
    print $errcount++;
    print "$_->{text}, $_->{id}\n";
}

print "\n\n>>Total $counter<<\n\n";
