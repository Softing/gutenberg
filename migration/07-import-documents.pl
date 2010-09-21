#!/usr/bin/perl;

use utf8;
use strict;

use Data::Dump qw /dump/;
use DBIx::Connector;

use lib "../lib";
use Inprint::Frameworks::Config;
use Inprint::Frameworks::SQL;

my $config = new Inprint::Frameworks::Config("../");

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
        ( SELECT card.stitle
           FROM views.\"passport.owners\" card
          WHERE card.uuid = creator) AS creator_nick
    FROM views.documents LIMIT 100000000
 ")->Hashes;

my $counter=0;
my @errors;

foreach my $item( @{ $documents } ) {
    
    $counter++;
    
    my $oldstate = $sql2->Q("
        SELECT uuid, edition, object_uuid, status_uuid, member_uuid, created
        FROM exchange2.state
        WHERE object_uuid=?
    ", [$item->{uuid}])->Hash;

    # Select branch
    my $branch = $sql->Q("
        SELECT id, catalog, mtype, title, shortcut, description, created, updated
        FROM branches
        WHERE catalog=?
    ", [$item->{edition}])->Hash;
    
    unless ($branch) {
        push @errors, {
            text => "branch", id=> $item->{id}
        };
        next;
    }
    
    # Select stage
    my $stage = $sql->Q("
        SELECT id, branch, color, weight, title, shortcut, description, created, updated
        FROM stages
        WHERE branch=? AND id=?
    ", [$branch->{id}, $oldstate->{status_uuid} ])->Hash;
    
    unless ($stage) {
        $stage = $sql->Q("
            SELECT id, branch, color, weight, title, shortcut, description, created, updated
            FROM stages
            WHERE branch=? ORDER BY weight LIMIT 1
        ", [$branch->{id} ])->Hash;
    }
    
    unless ($stage) {
        push @errors, {
            text => "stage", id=> $item->{id}
        };
        next;
    }
    
    $item->{theowner} = '4f5ad92e-b3e7-4c54-937e-e70aa999c0c7' unless ($item->{theowner});
    $item->{creator}  = '4f5ad92e-b3e7-4c54-937e-e70aa999c0c7' unless ($item->{creator});
    $item->{manager}  = '4f5ad92e-b3e7-4c54-937e-e70aa999c0c7' unless ($item->{manager});
    
    $item->{owner_nick}    = 'Администратор' unless ($item->{owner_nick});
    $item->{creator_nick}  = 'Администратор' unless ($item->{creator_nick});
    $item->{manager_nick}  = 'Администратор' unless ($item->{manager_nick});
    
    $item->{look}   = 'false' unless ($item->{look});
    $item->{isopen} = 'false' unless ($item->{isopen});
    
    $item->{rubric}  = $rootnode unless ($item->{rubric});
    $item->{section}  = $rootnode unless ($item->{section});
    $item->{rubric_name}   = "Not found" unless ($item->{rubric_name});
    $item->{section_name}  = "Not found" unless ($item->{section_name});
    
    print "------------------------------------------------------------\n";
    print ">>$counter\n";
    print "$item->{uuid}\n";
    print "$item->{theowner}, $item->{creator}, $item->{manager}, $item->{owner_nick}, $item->{creator_nick}, $item->{manager_nick}\n";
    print "$item->{edition}, $item->{edition_sname}, []\n";
    print "$item->{look}, $item->{isopen}\n";
    print "$branch->{id}, $branch->{title}, $stage->{id}, $stage->{title}, $stage->{color}, $stage->{weight}\n";
    print "$item->{title}, $item->{author}\n";
    print "$item->{section}, $item->{section_name}, $item->{rubric}, $item->{rubric_name}\n";
    print "$item->{planned_date}, $item->{planned_size}, $item->{real_date}, $item->{calibr_real}\n";
    print "$item->{image_count}, $item->{file_count}\n";
    print "$item->{created}, $item->{updated}\n";
    print "------------------------------------------------------------\n\n";
    
    $sql->Do("
        INSERT INTO documents(
            id,
            holder, creator, manager, owner_shortcut, creator_shortcut, manager_shortcut, 
            maingroup, maingroup_shortcut, ingroups,
            islooked, isopen,
            branch, branch_shortcut, stage, stage_shortcut, color, progress,
            title, author, 
            pdate, psize, rdate, rsize,
            images, files,
            created, updated
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
    ",
    [
        $item->{uuid},
        $item->{theowner}, $item->{creator}, $item->{manager}, $item->{owner_nick}, $item->{creator_nick}, $item->{manager_nick},
        $item->{edition}, $item->{edition_sname}, [],
        $item->{look}, $item->{isopen},
        $branch->{id}, $branch->{title}, $stage->{id}, $stage->{title}, $stage->{color}, $stage->{weight},
        $item->{title}, $item->{author},
        $item->{planned_date}, $item->{planned_size}, $item->{real_date}, $item->{calibr_real},
        $item->{image_count}, $item->{file_count},
        $item->{created}, $item->{updated}
    ]);
    
    # Map document to fascicle
    
    if ($item->{trash}) {
        $item->{fascicle} = '99999999-9999-9999-9999-999999999999';
        $item->{fascicle_name} = "Корзина";
    } else {
        $item->{fascicle} = $rootnode unless ($item->{fascicle});
        $item->{fascicle_name} = "Портфель" unless ($item->{fascicle_name});
    }
    
    $sql->Do("
        INSERT INTO map_documents_to_fascicles(
            document, fascicle, fascicle_nick,
            headline, headline_shortcut, rubric, rubric_shortcut,
            copygroup)
        VALUES (?, ?, ?, ?, ?, ?, ?, uuid_generate_v4());
    ",
    [
        $item->{uuid}, $item->{fascicle}, $item->{fascicle_name},
        $item->{section}, $item->{section_name}, $item->{rubric}, $item->{rubric_name}
    ]);
    

}

# Import history

# Import files

# Import versions

foreach (@errors) {
    print "$_->{text}, $_->{id}\n";
}

print "\n\n>>Total $counter<<\n\n";