package Inprint::Store::Embedded::Metadata;

# Inprint Content 5.0
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use Encode;

use strict;

use DBI;
use Digest::file qw(digest_file_hex);
use File::Basename;
use File::Util;
use POSIX qw(strftime);

sub connect {
    my $c = shift;
    my $path = shift;

    my $dbargs = { RaiseError => 1, sqlite_unicode => 1 };
    my $dbpath = &clearPath($c, "$path/.database/main.db");
    my $dbh = DBI->connect("dbi:SQLite:dbname=$dbpath","","",$dbargs);

    &createDefaults($c, $dbh);

    return $dbh;
}

sub createDefaults {
    my $c = shift;
    my $dbh = shift;

    $dbh->do("
        CREATE TABLE IF NOT EXISTS files (
            file_name TEXT primary key,
            file_description TEXT,
            file_digest TEXT,
            isdraft INTEGER DEFAULT 1,
            isapproved INTEGER DEFAULT 0,
            created TEXT,
            updated TEXT
        );
    ");

    $dbh->do("
        CREATE TABLE IF NOT EXISTS versions (
            id TEXT primary key,
            file_id TEXT,
            file_name TEXT,
            file_digest TEXT,
            version_text TEXT,
            ischeckpoint INTEGER DEFAULT 0,
            created TEXT
        );
    ");

    $dbh->commit();
    if ($dbh->err()) { die "$DBI::errstr\n"; }

    return $c;
}

sub disconnect {
    my $c = shift;
    my $dbh = shift;
    $dbh->disconnect;
    return $c;
}

sub getFileRecord {
    my $c = shift;

    my $dbh = shift;

    my $path = shift;
    my $filename = shift;

    my $filename_utf8 = $filename;

    if ($^O eq "MSWin32") {
        $filename_utf8 = Encode::decode("cp1251", $filename_utf8);
    }

    if ($^O eq "linux") {
        $filename_utf8 = Encode::decode("utf8", $filename_utf8);
    }

    my $filepath = "$path/$filename";

    my $sth  = $dbh->prepare("SELECT * FROM files WHERE file_name = ?");
    $sth->execute( $filename_utf8 );
    my $record = $sth->fetchrow_hashref;
    $sth->finish();

    my $digest   = Inprint::Store::Embedded::Metadata::getDigest($c, $filepath);
    my $filesize = Inprint::Store::Embedded::Metadata::getFileSize($c, $filepath);
    my $created  = Inprint::Store::Embedded::Metadata::getFileCreateDate($c, $filepath);
    my $updated  = Inprint::Store::Embedded::Metadata::getFileModifyDate($c, $filepath);

    # Create new record
    unless ($record->{file_name}) {
        $dbh->do("
            INSERT OR REPLACE INTO files
            (file_name, file_digest, created, updated) VALUES (?,?,?,?)", undef,
            $filename_utf8, $digest, $created, $updated
        );
        if ($dbh->err()) { die "$DBI::errstr\n"; }

        $sth  = $dbh->prepare("SELECT * FROM files WHERE file_name = ?");
        $sth->execute( $filename_utf8 );
        $record = $sth->fetchrow_hashref;
        $sth->finish();

    }

    # Update record
    if ($record->{file_digest} && $record->{file_digest} ne $digest) {
        $dbh->do("
            UPDATE files
            SET file_digest = ?, updated=? WHERE file_name=?", undef,
            $digest, $updated, $filename_utf8
        );
        if ($dbh->err()) { die "$DBI::errstr\n"; }
    }

    $record->{mimetype} = getMimeType($c, "$path/$filename");
    $record->{filesize} = $filesize;
    $record->{digest}   = $digest;
    $record->{created}  = $created;
    $record->{updated}  = $updated;

    return $record;
}

sub createFileRecord {
    my $c = shift;

    my $dbh = shift;

    my $filename = shift;
    my $digest = shift;
    my $created = shift;
    my $updated = shift;

    my $filename_utf8 = $filename;

    if ($^O eq "MSWin32") {
        $filename_utf8 = Encode::decode("cp1251", $filename_utf8);
    }

    if ($^O eq "linux") {
        $filename_utf8 = Encode::decode("utf8", $filename_utf8);
    }

    $dbh->do("
        INSERT OR REPLACE INTO files
        (file_name, file_digest, created, updated) VALUES (?,?,?,?)", undef,
        $filename_utf8, $digest, $created, $updated
    );

    if ($dbh->err()) { die "$DBI::errstr\n"; }

    return $c;
}

sub deleteFileRecord {
    my $c = shift;
    my $dbh = shift;
    my $filename = shift;

    $dbh->do(" DELETE FROM files WHERE file_name=?", undef, $filename );
    if ($dbh->err()) { die "$DBI::errstr\n"; }

    return $c;
}

sub publishRecord {
    my $c = shift;
    my $dbh = shift;
    my $filename = shift;

    $dbh->do(" UPDATE files SET isapproved=1 WHERE file_name=?", undef, $filename );
    if ($dbh->err()) { die "$DBI::errstr\n"; }
    return $c;
}

sub unpublishRecord {
    my $c = shift;
    my $dbh = shift;
    my $filename = shift;
    $dbh->do(" UPDATE files SET isapproved=0 WHERE file_name=?", undef, $filename );
    if ($dbh->err()) { die "$DBI::errstr\n"; }
    return $c;
}

sub changeRecordDesciption {
    my $c = shift;
    my $dbh = shift;
    my $filename = shift;
    my $text = shift;
    $dbh->do(" UPDATE files SET file_description=? WHERE file_name=?", undef, $text, $filename );
    if ($dbh->err()) { die "$DBI::errstr\n"; }
    return $c;
}

################################################################################


sub clearPath {

    my ($c, $filepath) = @_;

    if ($^O eq "MSWin32") {
        $filepath =~ s/\//\\/g;
        $filepath =~ s/\\+/\\/g;
    }

    if ($^O eq "linux") {
        $filepath =~ s/\\/\//g;
        $filepath =~ s/\/+/\//g;
    }

    return $filepath;
}

sub getDigest {
    my ($c, $filepath) = @_;
    $filepath = clearPath($c, $filepath);
    return digest_file_hex($filepath, "MD5");
}


sub getFileCreateDate {
    my $c = shift;
    my $filepath = shift;
    my $date = File::Util::created($filepath);
    return strftime("%Y-%m-%d %H:%M:%S", gmtime($date));
}

sub getFileModifyDate {
    my ($c, $filepath) = @_;
    my $date = File::Util::last_modified($filepath);
    return strftime("%Y-%m-%d %H:%M:%S", gmtime($date));
}

sub getFileSize {
    my ($c, $filepath) = @_;
    my $filesize = File::Util::size($filepath);
    return $filesize;
}

1;
