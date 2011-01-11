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

$sql->Do("DELETE FROM indx_rubrics WHERE id <> '00000000-0000-0000-0000-000000000000' ");
$sql->Do("DELETE FROM indx_headlines WHERE id <> '00000000-0000-0000-0000-000000000000' ");
$sql->Do("DELETE FROM indx_tags WHERE id <> '00000000-0000-0000-0000-000000000000' ");

# Import index

my $editions = $sql2->Q(" SELECT id, name, sname, description, uuid, deleted
    FROM edition.edition WHERE deleted=false ")->Hashes;

foreach my $edition ( @{ $editions } ) {

    my $EditionId = $sql->Q(" SELECT newid FROM migration WHERE oldid=? AND mtype = 'edition' ", [ $edition->{uuid} ])->Value;
    die "Can't find edition id $edition->{uuid}" unless $EditionId;

    # Import headlines
    my $fascicleIds = $sql2->Q(" SELECT id FROM edition.calendar WHERE edition =? ", [ $edition->{uuid} ])->Values;

    my $headlines = $sql2->Q(" SELECT uuid, fascicle, lower(title) as title FROM edition.catchword WHERE fascicle = ANY(?) ", [ $fascicleIds ])->Hashes;

    foreach my $headline ( @{ $headlines } ) {

        my $tag1 = getTagByTitle($sql, $headline->{title}, "");

        my $headline_id = $sql->Q(" SELECT id FROM indx_headlines WHERE edition=? AND tag=?", [ $EditionId, $tag1->{id} ])->Value;

        unless ($headline_id) {
            $headline_id = $ug->create_str();
            $sql->Do("
                INSERT INTO indx_headlines(id, edition, tag, title, description, bydefault, created, updated)
                VALUES (?, ?, ?, ?, ?, false, now(), now());
            ", [ $headline_id, $EditionId, $tag1->{id}, $headline->{title}, $headline->{description} || "" ]);
        }

        # Import rubrics

        my $rubrics = $sql2->Q(" SELECT uuid, lower(title) as title FROM edition.rubric WHERE catchword=? ", [ $headline->{uuid} ])->Hashes;

        foreach my $rubric ( @{ $rubrics } ) {

            my $tag2 = getTagByTitle($sql, $rubric->{title}, "");

            my $rubric_id = $sql->Q(" SELECT id FROM indx_rubrics WHERE headline=? AND tag=?", [ $headline_id, $tag2->{id} ])->Value;

            unless ($rubric_id) {
                $rubric_id = $ug->create_str();
                $sql->Do("
                    INSERT INTO indx_rubrics(id, edition, headline, tag, title, description, created, updated)
                        VALUES (?, ?, ?, ?, ?, ?, now(), now());
                ", [$rubric_id, $EditionId, $headline_id, $tag2->{id}, $rubric->{title}, $rubric->{description} || "" ]);
            }

        }
    }
}

sub getTagByTitle {
    my $sql = shift;
    my ($title, $description ) = @_;

    my $tag = $sql->Q("
        SELECT id, title FROM indx_tags WHERE title=? ",
        [ $title ])->Hash;

    unless ($tag->{id}) {

        $sql->Do("
            INSERT INTO indx_tags (id, title, description, created, updated)
            VALUES (?, ?, ?, now(), now()); ",
            [ $ug->create_str(), $title, $description ]);

        $tag = $sql->Q("
            SELECT id, title FROM indx_tags WHERE title=? ",
            [ $title ])->Hash;

    }

    return $tag;
}
