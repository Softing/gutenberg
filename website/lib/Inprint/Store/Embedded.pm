package Inprint::Store::Embedded;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

# This is Public Store API

use utf8;
use Encode;

use strict;

use File::Copy qw(copy move);
use File::Path qw(mkpath make_path remove_tree);

use Inprint::Store::Cache;
use Inprint::Store::Embedded::Editor;
use Inprint::Store::Embedded::Metadata;
use Inprint::Store::Embedded::Versioning;
use Inprint::Store::Embedded::Utils;

# Get list of files from folder ################################################

sub updateCache {

    my $c = shift;
    my $fs_folder = shift;

    my $fs_root = $c->config->get("store.path");
    my $fs_path = "$fs_root/$fs_folder";

    mkpath $fs_path;

    Inprint::Store::Embedded::Utils::checkFolder($c, $fs_path);

    my @files;

    # Read folder
    opendir DIR, $fs_path;
    while( my $filename = readdir(DIR)){

        # Skip hidden files
        next if $filename ~~ ['.', '..'];
        next if $filename =~ m/^\./;

        # Get file extension
        my $extension = Inprint::Store::Embedded::Utils::getExtension($c, $filename);

        my $filepath = Inprint::Store::Embedded::Utils::makePath($c, $fs_path, $filename);
        my $filepath_encoded = Inprint::Store::Embedded::Utils::doDecode($c, $filepath);

        # Create Cache record
        my $digest   = Inprint::Store::Embedded::Metadata::getDigest($c, $filepath);
        my $filesize = Inprint::Store::Embedded::Metadata::getFileSize($c, $filepath);
        my $created  = Inprint::Store::Embedded::Metadata::getFileCreateDate($c, $filepath);
        my $updated  = Inprint::Store::Embedded::Metadata::getFileModifyDate($c, $filepath);

        my $cacheRecord = Inprint::Store::Cache::makeRecord( $c, $fs_folder, $filename, $digest, $filesize, $created, $updated );

        unless ($cacheRecord->{file_exists}) {
            $c->Do(" UPDATE cache_files SET file_exists=true WHERE id=? ", $cacheRecord->{id});
        }

        # Update length
        my $metadata = Inprint::Store::Embedded::Editor::getMetadata($c, $filepath, $digest);

        if ($metadata->{CharacterCount} > 0) {
            $c->Do(" UPDATE cache_files SET file_length=? WHERE id=? ", [ $metadata->{CharacterCount}, $cacheRecord->{id} ]);
        }

        ## Create File record
        my $filehash = {
            id          => $cacheRecord->{id},
            name        => $cacheRecord->{file_name},
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
    Inprint::Store::Cache::cleanup($c, $fs_root, $fs_folder);

    return \@files;
}

# Upload file to folder ########################################################

sub fileUpload {
    my $c = shift;

    my $fs_folder_relative = shift;

    my $upload = shift;
    return unless $upload;

    my $fs_file_name = $upload->filename;
    return unless $fs_file_name;

    my $fs_folder_full = $c->config->get("store.path") . $fs_folder_relative;
    mkdir $fs_folder_full unless -e $fs_folder_full;
    Inprint::Store::Embedded::Utils::checkFolder($c, $fs_folder_full);

    $fs_file_name =~ s/\s+/_/g;

    my $fs_file_path = Inprint::Store::Embedded::Utils::makePath($c, $fs_folder_full, $fs_file_name);
    my $fs_file_path_encoded = Inprint::Store::Embedded::Utils::doEncode($c, $fs_file_path);

    $fs_file_path_encoded = Inprint::Store::Embedded::Utils::normalizeFilename($c, $fs_file_path_encoded);

    $upload->move_to($fs_file_path_encoded);

    die "Can't find path <$fs_file_path_encoded>" unless -e $fs_file_path_encoded;
    die "Can't read path <$fs_file_path_encoded>" unless -r $fs_file_path_encoded;

    # Save original

    my $fs_folder_oirigins = "$fs_folder_full/.origins";
    mkdir $fs_folder_oirigins;
    my $fileorigin = Inprint::Store::Embedded::Utils::makePath($c, $fs_folder_oirigins, $fs_file_name);
    my $fileorigin_encoded = Inprint::Store::Embedded::Utils::doEncode($c, $fileorigin);
    $fileorigin_encoded = Inprint::Store::Embedded::Utils::normalizeFilename($c, $fileorigin_encoded);
    copy $fs_file_path_encoded, $fileorigin_encoded;

    #my $digest   = Inprint::Store::Embedded::Metadata::getDigest($c, $fs_file_path_encoded);
    #my $filesize = Inprint::Store::Embedded::Metadata::getFileSize($c, $fs_file_path_encoded);
    #my $created  = Inprint::Store::Embedded::Metadata::getFileCreateDate($c, $fs_file_path_encoded);
    #my $updated  = Inprint::Store::Embedded::Metadata::getFileModifyDate($c, $fs_file_path_encoded);
    #my $cacheRecord = Inprint::Store::Cache::makeRecord( $c,
    #        $fs_folder_relative,
    #        $digest, $filesize, $created, $updated
    #    );
    #
    #return $cacheRecord;

    return 1;

}

sub fileCreate {
    my ($c, $folder, $filename, $description) = @_;

    Inprint::Store::Embedded::Utils::checkFolder($c, $folder);

    $filename =~ s/\s+/_/g;

    my $filepath = Inprint::Store::Embedded::Utils::makePath($c, $folder, "$filename.rtf");
    my $filepath_encoded = Inprint::Store::Embedded::Utils::doDecode($c, $filepath);
    $filepath_encoded = Inprint::Store::Embedded::Utils::normalizeFilename($c, $filepath_encoded);

    my $templateFile = Inprint::Store::Embedded::Utils::makePath($c, $c->config->get("store.path"), "templates", "template.rtf");
    die "Can't find path <$templateFile>" unless -e $templateFile;
    die "Can't read path <$templateFile>" unless -r $templateFile;

    copy $templateFile, $filepath_encoded;

    die "Can't find path <$filepath_encoded>" unless -e $filepath_encoded;
    die "Can't read path <$filepath_encoded>" unless -r $filepath_encoded;

    my $digest   = Inprint::Store::Embedded::Metadata::getDigest($c, $filepath);
    my $filesize = Inprint::Store::Embedded::Metadata::getFileSize($c, $filepath);
    my $created  = Inprint::Store::Embedded::Metadata::getFileCreateDate($c, $filepath);
    my $updated  = Inprint::Store::Embedded::Metadata::getFileModifyDate($c, $filepath);

    ## Create cache record
    #my $cacheRecord = Inprint::Store::Cache::makeRecord( $c,
    #        $filepath_encoded,
    #        $digest, $filesize, $created, $updated
    #    );
    #
    #return $cacheRecord;

    return 1;
}

sub fileRead {
    my $c = shift;
    my $fid = shift;

    my $cacheRecord = Inprint::Store::Cache::getRecordById($c, $fid);
    return unless $cacheRecord->{id};

    my $rootpath = $c->config->get("store.path");
    return unless $rootpath;

    my $filepath = Inprint::Store::Embedded::Utils::makePath($c, $rootpath, $cacheRecord->{file_path}, $cacheRecord->{file_name});
    my $filepath_encoded = Inprint::Store::Embedded::Utils::doEncode($c, $filepath);

    die "Can't find file <$filepath_encoded>" unless -e $filepath_encoded;
    die "Can't read file <$filepath_encoded>" unless -r $filepath_encoded;

    my $returnText = Inprint::Store::Embedded::Editor::readFile($c, "html", $filepath_encoded);

    return $returnText;
}

sub fileSave {
    my $c = shift;
    my $fid = shift;
    my $text = shift;

    my $cacheRecord = Inprint::Store::Cache::getRecordById($c, $fid);
    return unless $cacheRecord->{id};

    return Inprint::Store::Embedded::Editor::writeFile($c, $cacheRecord->{file_path}, $cacheRecord->{file_name}, $cacheRecord->{file_extension}, $text);

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

    $c->Do("UPDATE cache_files SET file_description=? WHERE id=?", [ $text, $fid ]);

    return $c;
}

sub fileDelete {

    my ($c, $fid) = @_;

    my $cacheRecord = Inprint::Store::Cache::getRecordById($c, $fid);
    return unless $cacheRecord->{id};

    my $rootpath = $c->config->get("store.path");
    return unless $rootpath;

    my $filepath = Inprint::Store::Embedded::Utils::makePath($c, $rootpath, $cacheRecord->{file_path}, $cacheRecord->{file_name});
    my $filepath_encoded = Inprint::Store::Embedded::Utils::doEncode($c, $filepath);

    Inprint::Store::Cache::deleteRecordById($c, $fid);
    unlink $filepath_encoded;

    return $c;
}

sub filePublish {
    my $c = shift;
    my $fid = shift;

    my $cache = Inprint::Store::Cache::getRecordById($c, $fid);
    return unless $cache->{id};

    $c->Do("UPDATE cache_files SET file_published=true WHERE id=?", [ $fid ]);

    return $c;
}

sub fileUnpublish {
    my $c = shift;
    my $fid = shift;

    my $cache = Inprint::Store::Cache::getRecordById($c, $fid);
    return unless $cache->{id};

    $c->Do("UPDATE cache_files SET file_published=false WHERE id=?", [ $fid ]);

    return $c;
}


################################################################################

sub createHotsave {
    my ($c, $fileid, $i_text);

    return $c;
}

sub readHotsave {
    my $c = shift;

    return $c;
}

sub listHotsaves {
    my $c = shift;

    return $c;
}

################################################################################
#
#sub getRelativePath {
#    my $c = shift;
#
#    my $area    = shift;
#    my $date    = shift;
#    my $storeid = shift;
#    my $create  = shift;
#
#    my $path = getFolderPath($c, $area, $date, $storeid, $create);
#
#    die "Can't find configuration of datastore folder" unless $path;
#    die "Can't find datastore folder in filesystem" unless -e $path;
#    die "Can't read datastore folder" unless -r $path;
#    die "Can't write to datastore folder" unless -w $path;
#
#    my $basepath = $c->config->get("store.path");
#
#    $path = substr $path, length($basepath), length($path)-length($basepath);
#
#    $path =~ s/\\/\//g;
#    $path =~ s/\/$//;
#
#    return $path;
#}

sub getFolderPath {
    my $c = shift;

    my $area    = shift;
    my $date    = shift;
    my $storeid = shift;
    my $create  = shift;

    die "Can't read <area>" unless $area;
    die "Can't read <date>" unless $date;
    die "Can't read <storeid>" unless $storeid;

    my $root = $c->config->get("store.path");
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

    $path =~ s/\//\\/g  if ($^O eq "MSWin32");
    $path =~ s/\\+/\\/g if ($^O eq "MSWin32");

    $path =~ s/\\/\//g  if ($^O eq "darwin");
    $path =~ s/\/+/\//g if ($^O eq "darwin");

    $path =~ s/\\/\//g  if ($^O eq "linux");
    $path =~ s/\/+/\//g if ($^O eq "linux");

    return $path;
}



1;
