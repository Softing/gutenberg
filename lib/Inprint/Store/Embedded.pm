package Inprint::Store::Embedded;

# Inprint Content 5.0
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

# This is Public Store API

use utf8;
use Encode;

use strict;

use File::Copy qw(copy move);
use File::Path qw(make_path remove_tree);

use Inprint::Store::Cache;
use Inprint::Store::Embedded::Converter;
use Inprint::Store::Embedded::Editor;
use Inprint::Store::Embedded::File;
use Inprint::Store::Embedded::Metadata;
use Inprint::Store::Embedded::Navigation;
use Inprint::Store::Embedded::Versioning;

# Get list of files from folder ################################################

sub findFiles {
    my $c = shift;

    my $path   = shift;
    my $status = shift;
    my $filter = shift;

    # Check folder for existence and the ability to create files
    &checkFolderPath($c, $path);

    my $relativePath =
            Inprint::Store::Embedded::Navigation::getRelativePath($c, $path);

    my @files;

    # Read folder
    opendir DIR, $path;
    while( my $filename = readdir(DIR)){

        # Skip hidden files
        next if $filename ~~ ['.', '..'];
        next if $filename =~ m/^\./;

        my $filename_utf8 = $filename;

        if ($^O eq "MSWin32") {
            $filename_utf8 = Encode::decode("cp1251", $filename_utf8);
        }

        if ($^O eq "linux") {
            $filename_utf8 = Encode::decode("utf8", $filename_utf8);
        }

        # Get file extension
        my $extension
            = Inprint::Store::Embedded::File::getExtension($c, $filename);

        # Apply a filter, if specified
        if ($filter) {
            next unless lc($extension) ~~ $filter;
        }

        # Create SQLite record
        my $dbh = Inprint::Store::Embedded::Metadata::connect($c, $path);
        my $record = Inprint::Store::Embedded::Metadata::getFileRecord($c, $dbh, $path, $filename);
        Inprint::Store::Embedded::Metadata::disconnect($c, $dbh);

        # Create Cache record

        my $cache_id = Inprint::Store::Cache::createRecord($c, $relativePath,
            $filename_utf8, $extension, $record->{mimetype}, $record->{digest});

        next if ($status eq "published" && $record->{isapproved} != 1);
        next if ($status eq "unpublished" && $record->{isapproved} != 0);

        # Create File record
        my $filehash = {
            name => $filename_utf8,

            cache => $cache_id,

            mime => $record->{mimetype},
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

    # Clear cache
    my $cache_id = Inprint::Store::Cache::cleanup($c, $path, $relativePath);

    return \@files;
}

# Upload file to folder ########################################################

sub fileUpload {
    my $c = shift;
    my $path = shift;
    my $filename = shift;
    my $fieldname = shift || "Filedata";

    my $upload = $c->req->upload($fieldname);

    &checkFolderPath($c, $path);
    $filename = Inprint::Store::Embedded::File::normalizeFilename($c, $path, $filename);

    my $filename_utf8 = $filename;

    if ($^O eq "MSWin32") {
        $filename_utf8 = Encode::encode("cp1251", $filename_utf8);
    }

    if ($^O eq "linux") {
        $filename_utf8 = Encode::encode("utf8", $filename_utf8);
    }

    $filename_utf8 =~ s/\s+/_/g;

    $upload->move_to("$path/$filename_utf8");

    my $id = $c->uuid;
    my $digest   = Inprint::Store::Embedded::Metadata::getDigest($c, "$path/$filename_utf8");
    my $created  = Inprint::Store::Embedded::Metadata::getFileCreateDate($c, "$path/$filename_utf8");
    my $updated  = Inprint::Store::Embedded::Metadata::getFileModifyDate($c, "$path/$filename_utf8");

    # Create metadata record
    my $dbh = Inprint::Store::Embedded::Metadata::connect($c, $path);
    Inprint::Store::Embedded::Metadata::createFileRecord($c, $dbh, $filename_utf8, $digest, $created, $updated);
    my $record = Inprint::Store::Embedded::Metadata::getFileRecord($c, $dbh, $path, $filename_utf8);
    Inprint::Store::Embedded::Metadata::disconnect($c, $dbh);

    # Create cache record
    my $relativePath =
        Inprint::Store::Embedded::Navigation::getRelativePath($c, $path);

    my $extension
        = Inprint::Store::Embedded::File::getExtension($c, $filename);

    my $cache_id = Inprint::Store::Cache::createRecord($c, $relativePath,
            $filename, $extension, $record->{mimetype}, $record->{digest});

    return $c;
}

sub fileCreate {
    my ($c, $folder, $filename, $description) = @_;

    &checkFolderPath($c, $folder);
    $filename = Inprint::Store::Embedded::File::normalizeFilename($c, $folder, "$filename.rtf");

    my $filename_utf8 = $filename;

    if ($^O eq "MSWin32") {
        $filename_utf8 = Encode::encode("cp1251", $filename_utf8);
    }

    if ($^O eq "linux") {
        $filename_utf8 = Encode::encode("utf8", $filename_utf8);
    }

    my $templateFile = $c->config->get("store.path") . "/templates/template.rtf";
    die "Can't find path <$templateFile>" unless -e $templateFile;
    die "Can't read path <$templateFile>" unless -r $templateFile;

    copy $templateFile, "$folder/$filename_utf8";

    die "Can't find path <$filename_utf8>" unless -e "$folder/$filename_utf8";
    die "Can't read path <$filename_utf8>" unless -r "$folder/$filename_utf8";

    my $id = $c->uuid;
    my $digest   = Inprint::Store::Embedded::Metadata::getDigest($c, "$folder/$filename_utf8");
    my $created  = Inprint::Store::Embedded::Metadata::getFileCreateDate($c, "$folder/$filename_utf8");
    my $updated  = Inprint::Store::Embedded::Metadata::getFileModifyDate($c, "$folder/$filename_utf8");

    # Create metadata record
    my $dbh = Inprint::Store::Embedded::Metadata::connect($c, $folder);
    Inprint::Store::Embedded::Metadata::createFileRecord($c, $dbh, $filename_utf8, $digest, $created, $updated);
    Inprint::Store::Embedded::Metadata::changeRecordDesciption($c, $dbh, $filename_utf8, $description);
    my $record = Inprint::Store::Embedded::Metadata::getFileRecord($c, $dbh, $folder, $filename_utf8);
    Inprint::Store::Embedded::Metadata::disconnect($c, $dbh);

    die "Can't find record <$filename_utf8>" unless $record->{digest};

    # Create cache record
    my $relativePath =
        Inprint::Store::Embedded::Navigation::getRelativePath($c, $folder);

    my $extension
        = Inprint::Store::Embedded::File::getExtension($c, $filename);

    my $cache_id = Inprint::Store::Cache::createRecord($c, $relativePath,
            $filename, $extension, $record->{mimetype}, $record->{digest});

    return $c;
}

sub fileRead {
    my $c = shift;
    my $fid = shift;

    my $cacheRecord = Inprint::Store::Cache::getRecordById($c, $fid);

    die "Can't find cache record <$fid>" unless $cacheRecord->{file_digest};

    my $rootpath = Inprint::Store::Embedded::Navigation::getRootPath($c);
    my $filepath = clearPath( $c, $rootpath, $cacheRecord->{file_path}, $cacheRecord->{file_name} );

    if ($^O eq "MSWin32") {
        $filepath = encode("cp1251", $filepath);
    }

    if ($^O eq "linux") {
        $filepath = encode("utf8", $filepath);
    }

    die "Can't find file <$filepath>" unless -e $filepath;
    die "Can't read file <$filepath>" unless -r $filepath;

    my $text = Inprint::Store::Embedded::Editor::read($c, "html", $filepath);

    return $text ;
}

sub fileSave {
    my $c = shift;
    my $fid = shift;
    my $text = shift;

    my $cacheRecord = Inprint::Store::Cache::getRecordById($c, $fid);

    die "Can't find cache record <$fid>" unless $cacheRecord->{file_digest};

    my $rootpath = Inprint::Store::Embedded::Navigation::getRootPath($c);
    my $filepath = clearPath( $c, $rootpath, $cacheRecord->{file_path}, $cacheRecord->{file_name} );

    if ($^O eq "MSWin32") {
        $filepath = encode("cp1251", $filepath);
    }

    if ($^O eq "linux") {
        $filepath = encode("utf8", $filepath);
    }


    die "Can't find file <$filepath>" unless -e $filepath;
    die "Can't read file <$filepath>" unless -r $filepath;

    Inprint::Store::Embedded::Editor::write($c, $cacheRecord->{file_extension}, $filepath, $text);

    return $c;
}

sub fileRename {
    my $c = shift;
    my $fid = shift;
    my $filename = shift;

    die "rename";

    return $c;
}

sub fileChangeDescription {
    my $c = shift;
    my $fid = shift;
    my $text = shift;

    my $root = Inprint::Store::Embedded::Navigation::getRootPath($c);
    my $cache = Inprint::Store::Cache::getRecordById($c, $fid);
    return unless $cache->{id};

    my $folderpath = clearPath( $c, $root, $cache->{file_path} );

    my $dbh = Inprint::Store::Embedded::Metadata::connect($c, $folderpath);
    Inprint::Store::Embedded::Metadata::changeRecordDesciption($c, $dbh, $cache->{file_name}, $text);
    Inprint::Store::Embedded::Metadata::disconnect($c, $dbh);

    $c->sql->Do("UPDATE cache_files SET file_description=? WHERE id=?", [ $text, $fid ]);

    return $c;
}

sub fileDelete {

    my $c = shift;
    my $fid = shift;

    my $root = Inprint::Store::Embedded::Navigation::getRootPath($c);
    my $cache = Inprint::Store::Cache::getRecordById($c, $fid);
    return unless $cache->{id};

    my $folderpath = clearPath( $c, $root, $cache->{file_path} );

    my $dbh = Inprint::Store::Embedded::Metadata::connect($c, $folderpath);
    Inprint::Store::Embedded::Metadata::deleteFileRecord($c, $dbh, $cache->{file_name});
    Inprint::Store::Embedded::Metadata::disconnect($c, $dbh);

    Inprint::Store::Cache::deleteRecordById($c, $fid);

    my $filepath = $cache->{file_path};
    my $filename = $cache->{file_name};

    if ($^O eq "MSWin32") {
        $filepath = Encode::encode("cp1251", $filepath);
        $filename = Encode::encode("cp1251", $filename);
    }

    if ($^O eq "linux") {
        $filepath = Encode::encode("utf8", $filepath);
        $filename = Encode::encode("utf8", $filename);
    }

    $c->sql->Do("UPDATE cache_files SET file_exists=false WHERE id=?", [ $fid ]);

    unlink clearPath( $c, $root, $filepath, $filename );

    return $c;
}

sub filePublish {
    my $c = shift;
    my $fid = shift;

    my $root = Inprint::Store::Embedded::Navigation::getRootPath($c);
    my $cache = Inprint::Store::Cache::getRecordById($c, $fid);
    return unless $cache->{id};

    my $folderpath = clearPath( $c, $root, $cache->{file_path} );

    my $dbh = Inprint::Store::Embedded::Metadata::connect($c, $folderpath);
    Inprint::Store::Embedded::Metadata::publishRecord($c, $dbh, $cache->{file_name});
    Inprint::Store::Embedded::Metadata::disconnect($c, $dbh);

    $c->sql->Do("UPDATE cache_files SET file_published=true WHERE id=?", [ $fid ]);

    return $c;
}

sub fileUnpublish {
    my $c = shift;
    my $fid = shift;

    my $root = Inprint::Store::Embedded::Navigation::getRootPath($c);
    my $cache = Inprint::Store::Cache::getRecordById($c, $fid);
    return unless $cache->{id};

    my $folderpath = clearPath( $c, $root, $cache->{file_path} );

    my $dbh = Inprint::Store::Embedded::Metadata::connect($c, $folderpath);
    Inprint::Store::Embedded::Metadata::unpublishRecord($c, $dbh, $cache->{file_name});
    Inprint::Store::Embedded::Metadata::disconnect($c, $dbh);

    $c->sql->Do("UPDATE cache_files SET file_published=false WHERE id=?", [ $fid ]);

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

sub clearPath {

    my $c = shift;
    my $root = shift;

    my $path;
    foreach (@_) {
        $path .= '\\' . $_;
    }

    $path = $root ."\\". $path;

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

# Make some test
sub checkFolderPath {
    my $c = shift;
    my $path = shift;

    die "Can't find path <$path>" unless -e $path;
    die "Can't read path <$path>" unless -r $path;
    die "Can't write path <$path>" unless -w $path;
}

1;
