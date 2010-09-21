#!/usr/bin/perl

use DBI;


$dbh = DBI->connect("dbi:Pg:dbname=inprint-4.5", 'postgres', 'postgres', {AutoCommit => 0});

my $sth = $dbh->prepare(" select * from catalog where path = ?::ltree ");
$sth->execute([ '00000000000000000000000000000000' ]);

while (my $row = $sth->fetchrow_hashref()){
    print %$row ;
}

$sth->finish();