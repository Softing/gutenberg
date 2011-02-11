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
use Inprint::Store::Embedded::Metadata;
use Inprint::Store::Embedded::Versioning;
use Inprint::Store::Embedded::Utils;

# Get list of files from folder ################################################

sub findFiles {

    my $c = shift;

    my $path   = shift;
    my $status = shift;
    my $filter = shift;

    # Check folder for existence and the ability to create files
    Inprint::Store::Embedded::Utils::checkFolder($c, $path);

    my @files;

    # Read folder
    opendir DIR, $path;
    while( my $filename = readdir(DIR)){

        # Skip hidden files
        next if $filename ~~ ['.', '..'];
        next if $filename =~ m/^\./;

        # Get file extension
        my $extension = Inprint::Store::Embedded::Utils::getExtension($c, $filename);

        # Apply a filter, if specified
        if ($filter) {
            next unless lc($extension) ~~ $filter;
        }

        my $filepath = Inprint::Store::Embedded::Utils::makePath($c, $path,$filename);
        my $filepath_encoded = Inprint::Store::Embedded::Utils::encode($c, $filepath);

        # Create Cache record

        my $digest   = Inprint::Store::Embedded::Metadata::getDigest($c, $filepath_encoded);
        my $filesize = Inprint::Store::Embedded::Metadata::getFileSize($c, $filepath_encoded);
        my $created  = Inprint::Store::Embedded::Metadata::getFileCreateDate($c, $filepath_encoded);
        my $updated  = Inprint::Store::Embedded::Metadata::getFileModifyDate($c, $filepath_encoded);

        my $cacheRecord = Inprint::Store::Cache::makeRecord( $c,
                $filepath_encoded,
                $digest, $filesize, $created, $updated
            );

        next if ($status eq "published" && $cacheRecord->{isapproved} != 1);
        next if ($status eq "unpublished" && $cacheRecord->{isapproved} != 0);

        ## Create File record
        my $filehash = {
            id          => $cacheRecord->{id},
            name        => $cacheRecord->{file_name} .".". $cacheRecord->{file_extension},
            mime        => $cacheRecord->{file_mime},
            description => $cacheRecord->{file_description},
            extension   => $cacheRecord->{file_extension},
            size        => $cacheRecord->{file_size},
            isapproved  => $cacheRecord->{file_published} || 0,
            created     => $cacheRecord->{created},
            updated     => $cacheRecord->{updated}
        };

        push @files, $filehash;

    }
    closedir DIR;

    # Clear cache
    my $folderpath = Inprint::Store::Embedded::Utils::encode($c, $path);
    Inprint::Store::Cache::cleanup($c, $folderpath);

    return \@files;
}

# Upload file to folder ########################################################

sub fileUpload {
    my $c = shift;
    my $path = shift;
    my $upload = shift;

    return unless $upload;

    my $filename = $upload->filename;

    return unless $filename;

    Inprint::Store::Embedded::Utils::checkFolder($c, $path);

    $filename =~ s/\s+/_/g;

    my $filepath = Inprint::Store::Embedded::Utils::makePath($c, $path,$filename);
    my $filepath_encoded = Inprint::Store::Embedded::Utils::encode($c, $filepath);

    $filepath_encoded = Inprint::Store::Embedded::Utils::normalizeFilename($c, $filepath_encoded);

    $upload->move_to($filepath_encoded);

    my $digest   = Inprint::Store::Embedded::Metadata::getDigest($c, $filepath_encoded);
    my $filesize = Inprint::Store::Embedded::Metadata::getFileSize($c, $filepath_encoded);
    my $created  = Inprint::Store::Embedded::Metadata::getFileCreateDate($c, $filepath_encoded);
    my $updated  = Inprint::Store::Embedded::Metadata::getFileModifyDate($c, $filepath_encoded);

    my $cacheRecord = Inprint::Store::Cache::makeRecord( $c,
            $filepath_encoded,
            $digest, $filesize, $created, $updated
        );

    return $cacheRecord;
}

sub fileCreate {
    my ($c, $folder, $filename, $description) = @_;

    Inprint::Store::Embedded::Utils::checkFolder($c, $folder);

    $filename =~ s/\s+/_/g;

    my $filepath = Inprint::Store::Embedded::Utils::makePath($c, $folder, "$filename.rtf");
    my $filepath_encoded = Inprint::Store::Embedded::Utils::encode($c, $filepath);

    $filepath_encoded = Inprint::Store::Embedded::Utils::normalizeFilename($c, $filepath_encoded);

    my $templateFile = Inprint::Store::Embedded::Utils::makePath($c, $c->config->get("store.path"), "templates", "template.rtf");
    die "Can't find path <$templateFile>" unless -e $templateFile;
    die "Can't read path <$templateFile>" unless -r $templateFile;

    copy $templateFile, $filepath_encoded;

    die "Can't find path <$filepath_encoded>" unless -e $filepath_encoded;
    die "Can't read path <$filepath_encoded>" unless -r $filepath_encoded;

    my $digest   = Inprint::Store::Embedded::Metadata::getDigest($c, $filepath_encoded);
    my $filesize = Inprint::Store::Embedded::Metadata::getFileSize($c, $filepath_encoded);
    my $created  = Inprint::Store::Embedded::Metadata::getFileCreateDate($c, $filepath_encoded);
    my $updated  = Inprint::Store::Embedded::Metadata::getFileModifyDate($c, $filepath_encoded);

    my $cacheRecord = Inprint::Store::Cache::makeRecord( $c,
            $filepath_encoded,
            $digest, $filesize, $created, $updated
        );

    return $cacheRecord;
}

sub fileRead {
    my $c = shift;
    my $fid = shift;

    my $cacheRecord = Inprint::Store::Cache::getRecordById($c, $fid);
    return unless $cacheRecord->{id};

    my $rootpath = Inprint::Store::Embedded::Utils::getRootPath($c);
    return unless $rootpath;

    my $filepath = Inprint::Store::Embedded::Utils::makePath($c, $rootpath, $cacheRecord->{file_path}, $cacheRecord->{file_name} .".". $cacheRecord->{file_extension});
    my $filepath_encoded = Inprint::Store::Embedded::Utils::encode($c, $filepath);

    die "Can't find file <$filepath_encoded>" unless -e $filepath_encoded;
    die "Can't read file <$filepath_encoded>" unless -r $filepath_encoded;

    my $text = Inprint::Store::Embedded::Editor::read($c, "html", $filepath_encoded);

    return $text ;
}

sub fileSave {
    my $c = shift;
    my $fid = shift;
    my $text = shift;

    my $cacheRecord = Inprint::Store::Cache::getRecordById($c, $fid);
    return unless $cacheRecord->{id};

    my $rootpath = Inprint::Store::Embedded::Utils::getRootPath($c);
    return unless $rootpath;

    my $filepath = Inprint::Store::Embedded::Utils::makePath($c, $rootpath, $cacheRecord->{file_path}, $cacheRecord->{file_name} .".". $cacheRecord->{file_extension});
    my $filepath_encoded = Inprint::Store::Embedded::Utils::encode($c, $filepath);

    die "Can't find file <$filepath_encoded>" unless -e $filepath_encoded;
    die "Can't read file <$filepath_encoded>" unless -r $filepath_encoded;

    Inprint::Store::Embedded::Editor::write($c, $cacheRecord->{file_extension}, $filepath_encoded, $text);

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

    my $cache = Inprint::Store::Cache::getRecordById($c, $fid);
    return unless $cache->{id};

    $c->sql->Do("UPDATE cache_files SET file_description=? WHERE id=?", [ $text, $fid ]);

    return $c;
}

sub fileDelete {

    my ($c, $fid) = @_;

    my $cacheRecord = Inprint::Store::Cache::getRecordById($c, $fid);
    return unless $cacheRecord->{id};

    my $rootpath = Inprint::Store::Embedded::Utils::getRootPath($c);
    return unless $rootpath;

    my $filepath = Inprint::Store::Embedded::Utils::makePath($c, $rootpath, $cacheRecord->{file_path}, $cacheRecord->{file_name} .".". $cacheRecord->{file_extension});
    my $filepath_encoded = Inprint::Store::Embedded::Utils::encode($c, $filepath);

    Inprint::Store::Cache::deleteRecordById($c, $fid);
    unlink $filepath_encoded;

    return $c;
}

sub filePublish {
    my $c = shift;
    my $fid = shift;

    my $cache = Inprint::Store::Cache::getRecordById($c, $fid);
    return unless $cache->{id};

    $c->sql->Do("UPDATE cache_files SET file_published=true WHERE id=?", [ $fid ]);

    return $c;
}

sub fileUnpublish {
    my $c = shift;
    my $fid = shift;

    my $cache = Inprint::Store::Cache::getRecordById($c, $fid);
    return unless $cache->{id};

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

    my $root = Inprint::Store::Embedded::Utils::getRootPath($c);
    my $prefix = substr $date, 0, 7;

    my $path = "$root/datastore/$area/$prefix/$storeid";

    unless (-e $path) {
        if ($create) {
            make_path($path);
        }
    }

    Inprint::Store::Embedded::Utils::checkFolder($c, $path);

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



1;
