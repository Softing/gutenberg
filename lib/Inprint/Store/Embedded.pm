package Inprint::Store::Embedded;

# Inprint Content 5.0
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

# This is Public Store API

use strict;

use File::Copy qw(copy move);
use File::Path qw(make_path remove_tree);

use Inprint::Store::Embedded::Converter;
use Inprint::Store::Embedded::Editor;
use Inprint::Store::Embedded::File;
use Inprint::Store::Embedded::Metadata;
use Inprint::Store::Embedded::Navigation;
use Inprint::Store::Embedded::Versioning;

sub list {
    my $c = shift;

    my $path   = shift;
    my $filter = shift;

    &checkFolderPath($c, $path);

    my @files;
    opendir DIR, $path;

    while( my $filename = readdir(DIR)){

        next if $filename ~~ ['.', '..'];
        next if $filename =~ m/^\./;

        my $extension = Inprint::Store::Embedded::File::getExtension($c, $filename);

        if ($filter) {
            next unless $extension ~~ $filter;
        }

        # Create SQL record
        my $dbh = Inprint::Store::Embedded::Metadata::connect($c, $path);
        my $record = Inprint::Store::Embedded::Metadata::getFileRecord($c, $dbh, $path, $filename);
        Inprint::Store::Embedded::Metadata::disconnect($c, $dbh);

        my $relativePath = Inprint::Store::Embedded::Navigation::getRelativePath($c, $path);
        $relativePath = "$relativePath/$filename";

        my $filemask = $c->sql->Q("SELECT id FROM filesmask WHERE filepath=?", [ $relativePath ])->Value;
        unless ($filemask) {
            $filemask = $c->uuid();
            $c->sql->Do("INSERT INTO filesmask (id, filepath) VALUES (?,?)", [ $filemask, $relativePath ]);
        }

        my $mime = Inprint::Store::Embedded::getMimeData($c, "$path/$filename");

        my $filehash = {
            name => $filename,

            mime => $mime,

            filemask => $filemask,
            preview => "/$filemask/80",

            description => $record->{file_description} || "",
            extension => $extension,
            digest => $record->{digest},
            size => $record->{filesize},

            isdraft => $record->{isdraft} || 1,
            isapproved => $record->{isapproved} || 0,

            created => $record->{created},
            updated => $record->{updated}
        };

        push @files, $filehash;

    }

    closedir DIR;

    return \@files;
}

sub create {
    my $c = shift;

    return $c;
}

sub upload {
    my $c = shift;
    my $path = shift;
    my $filename = shift;
    my $fieldname = shift || "Filedata";

    &checkFolderPath($c, $path);

    my $upload = $c->req->upload($fieldname);

    $filename = Inprint::Store::Embedded::File::normalizeFilename($c, $path, $filename);

    $upload->move_to("$path/$filename");

    my $id = $c->uuid;
    my $digest   = Inprint::Store::Embedded::Metadata::getDigest($c, "$path/$filename");
    my $created  = Inprint::Store::Embedded::Metadata::getFileCreateDate($c, "$path/$filename");
    my $updated  = Inprint::Store::Embedded::Metadata::getFileModifyDate($c, "$path/$filename");

    my $dbh = Inprint::Store::Embedded::Metadata::connect($c, $path);

    $dbh->do("
        INSERT OR REPLACE INTO files
        (file_name, file_digest, created, updated) VALUES (?,?,?,?)", undef,
        $filename, $digest, $created, $updated
    );

    if ($dbh->err()) { die "$DBI::errstr\n"; }

    Inprint::Store::Embedded::Metadata::disconnect($c, $dbh);

    return $c;
}

sub read {
    my $c = shift;
    my $path = shift;
    my $filename = shift;

    die "read";

    return $c;
}

sub save {
    my $c = shift;
    my $path = shift;
    my $filename = shift;
    my $text = shift;

    die "save";

    return $c;
}

sub rename {
    my $c = shift;
    my $path = shift;
    my $filename = shift;
    my $newfilename = shift;

    die "rename";

    return $c;
}

sub delete {
    my $c = shift;
    my $path = shift;
    my $filename = shift;

    die "delete";

    return $c;
}

sub publish {
    my $c = shift;
    my $path = shift;
    my $filename = shift;

    die "publish";

    return $c;
}

sub unpublish {
    my $c = shift;
    my $path = shift;
    my $filename = shift;

    die "unpublish";

    return $c;
}


################################################################################

sub readVersion {
    my $c = shift;

    return $c;
}

sub listVersions {
    my $c = shift;

    return $c;
}

################################################################################

sub downloadArchive {
    my $c = shift;
    my $filter = shift;

    return $c;
}

sub uploadArchive {
    my $c = shift;

    return $c;
}

################################################################################

sub getMimeData {
    my $c = shift;
    my $filepath = shift;

    my $mime = Inprint::Store::Embedded::Metadata::getMimeType($c, $filepath);
    return $mime;
}

sub getFolderPath {
    my $c = shift;

    my $area    = shift;
    my $date    = shift;
    my $storeid = shift;
    my $create  = shift;

    die "Can't read <area>" unless $area;
    die "Can't read <date>" unless $date;
    die "Can't read <storeid>" unless $storeid;

    my $root = Inprint::Store::Embedded::Navigation::getRootPath($c);
    my $prefix = substr $date, 0, 7; #$prefix =~ s/-/\//g;

    my $path = "$root/datastore/$area/$prefix/$storeid";

    unless (-e $path) {
        if ($create) {
            make_path($path);
        }
    }

    &checkFolderPath($c, $path);

    my @subfolders = ('config', 'database', 'origins', 'versions', 'thumbnails', 'tmp');
    foreach my $item (@subfolders) {
        unless (-e "$path/.$item") {
            make_path("$path/.$item");
        }
    }

    if ($^O eq "MSWin32") {
        $path =~ s/\//\\/g;
        $path =~ s/\\+/\\/g;
    }

    if ($^O eq "linux") {
        $path =~ s/\\/\//g;
        $path =~ s/\/+/\//g;
    }

    return $path;
}

sub checkFolderPath {
    my $c = shift;
    my $path = shift;

    die "Can't find path <$path>" unless -e $path;
    die "Can't read path <$path>" unless -r $path;
    die "Can't write path <$path>" unless -w $path;
}

1;
