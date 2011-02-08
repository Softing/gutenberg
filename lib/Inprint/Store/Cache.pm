package Inprint::Store::Cache;

use utf8;
use strict;
use Encode;

sub createRecord {

    my $c = shift;

    my ( $path, $filename, $extension, $mimetype, $digest) = @_;

    my $cache_id = $c->sql->Q("
            SELECT id FROM cache_files WHERE file_path=? AND file_name=?
            ", [ $path, $filename ])->Value;

    unless ($cache_id) {
        $cache_id = $c->uuid();
        $c->sql->Do("
            INSERT INTO cache_files (id, file_path, file_name,
                file_extension, file_mime, file_digest )
            VALUES (?,?,?,?,?,?)
            ", [ $cache_id, $path, $filename, $extension,
                $mimetype, $digest ]);
    }

    return $cache_id;
}

sub getRecordById {
    my $c = shift;
    my $id = shift;

    my $record = $c->sql->Q(" SELECT * FROM cache_files WHERE id=?", [ $id ])->Hash;

    return $record;
}

sub getRecordByPath {
    my $c = shift;
    my ($path, $filename) = @_;

    my $record = $c->sql->Q("
            SELECT * FROM cache_files WHERE file_path=? AND file_name=?
            ", [ $path, $filename ])->Hash;

    return $record;
}

sub deleteRecordById {
    my $c = shift;
    my $id = shift;

    my $record = $c->sql->Do(" DELETE FROM cache_files WHERE id=? ", [ $id ]);

    return $c;
}

sub cleanup {

    my ($c, $folder, $relativePath) = @_;

    my $cacheRecords = $c->sql->Q("
            SELECT * FROM cache_files WHERE file_path=?
            ", [ $relativePath ])->Hashes;

    foreach my $record (@$cacheRecords) {

        my $filepath = $folder ."/". $record->{file_name};

        if ($^O eq "MSWin32") {
            $filepath =~ s/\//\\/g;
            $filepath =~ s/\\+/\\/g;
            $filepath = encode("cp1251", $filepath);
        }

        if ($^O eq "linux") {
            $filepath =~ s/\\/\//g;
            $filepath =~ s/\/+/\//g;
        }

        unless (-e $filepath) {
            $c->sql->Do(" DELETE FROM cache_files WHERE id=? ", [ $record->{id} ]);
        }
    }

    return;
}

1;
