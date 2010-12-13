package Inprint::Documents::Files;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use DBI;

use Text::Iconv;
use Image::Magick;

use File::Copy qw(copy move);
use File::Path qw(make_path remove_tree);
use File::Temp qw/ tempfile tempdir /;

use LWP::UserAgent;
use HTTP::Request::Common;

use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use IO::Compress::Gzip qw(gzip $GzipError) ;

use Inprint::Utils;
use Inprint::Utils::Files;

use base 'Inprint::BaseController';

sub list {

    my $c = shift;

    my $i_document = $c->param("document");

    my @result;
    my @errors;
    my $success = $c->json->false;
    
    my $document = Inprint::Utils::GetDocumentById($c, id => $i_document);
    my $storePath = $c->getDocumentPath($document->{filepath}, \@errors);
    
    my @dir;
    
    if (-r $storePath) {
        opendir DIR, $storePath or die "read dir $storePath - $!";
        @dir = grep !/^\./, readdir DIR;
        
        closedir DIR;
    }
    
    if (@dir) {
    
        @dir = sort(@dir);
        
        my $sqlite = $c->getSQLiteHandler($storePath);
        
        foreach my $file (@dir) {
            
            my $id = undef;
            
            my $filepath = Inprint::Utils::Files::ProcessFilePath($c, "$storePath/$file");
            my $digest   = Inprint::Utils::Files::GetDigest($c, $filepath);
            my $mimetype = Inprint::Utils::Files::GetMimeType($c, $filepath);
            my $filesize = Inprint::Utils::Files::GetFileSize($c, $filepath);
            my $created  = Inprint::Utils::Files::GetFileChangedDate($c, $filepath);
            my $updated  = Inprint::Utils::Files::GetFileModifiedDate($c, $filepath);
            
            if ($^O eq "MSWin32") {
                $file = Encode::decode("cp1251", $file);
            }

            if ($^O eq "linux") {
                $file = Encode::decode("utf8", $file);
            }

            my $sth  = $sqlite->prepare("SELECT * FROM files WHERE filename = ?");
            $sth->execute( $file );
            my $record = $sth->fetchrow_hashref;
            $sth->finish();
            
            if ($record->{id}) {
                if ($record->{digest} ne $digest) {
                    $sqlite->do("UPDATE files SET draft = 1 WHERE id=?", undef, $record->{id} );
                }
            }
            
            unless ($record->{id}) {
                
                $record->{id} = $c->uuid;
                
                $sqlite->do("INSERT INTO files (id, filename, description, digest, mimetype, draft, created, updated) VALUES (?,?,?,?,?,?,?,?)", undef, 
                    $record->{id}, $file, "", $digest, $mimetype, 1, $created, $updated
                );
                
                if ($sqlite->err()) { die "$DBI::errstr\n"; }
                
            }
            
            my $preview  = "/documents/files/preview/$document->{id}/$record->{id}/?rnd=" . rand();
            
            my $extension = Inprint::Utils::Files::GetExtension($c, $filepath);
            
            push @result, {
                id => $record->{id},
                preview => $preview,
                filename => $file,
                extension => $extension,
                description => $record->{description},
                digest => $digest,
                mimetype => $mimetype,
                draft => "draft",
                size => $filesize,
                created => $created,
                updated => $updated
            }
        }
        
        $sqlite->commit();
        $sqlite->disconnect();
    
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => \@result } );
}

sub create {

    my $c = shift;

    my $i_document = $c->param("document");
    
    my $i_title = $c->param("title");
    my $i_description = $c->param("description");
    
    my @errors;
    my $success = $c->json->false;
    
    my $storePath;
    my $documentStorePath;
    my $templateFile;
    
    my $document = Inprint::Utils::GetDocumentById($c, id => $i_document);
    push @errors, { id => "id", msg => "Cant find object with this id"}
        unless $document->{id};
    
    unless (@errors) {
        $storePath    = $c->config->get("store.path");
        push @errors, { id => "path", msg => "Cant find path"}
            unless $storePath;
    }
    
    unless (@errors) {
        $documentStorePath = $c->getDocumentPath($document->{filepath}, \@errors);
        push @errors, { id => "path", msg => "Cant find path"}
            unless $documentStorePath;
    }
    
    unless (@errors) {
        $templateFile = Inprint::Utils::Files::ProcessFilePath($c, "$storePath/templates/template.rtf");
        push @errors, { id => "filepath", msg => "Cant read template file from settings"}
            unless -e -r $templateFile;
    }
    
    my $suffix;
    my $fileName = $i_title;
    my $localFileName  = $i_title;
    
    unless (@errors) {
        
        if ($^O eq "MSWin32") {
            my $converter = Text::Iconv->new("utf-8", "windows-1251");
            $localFileName = $converter->convert($localFileName);
        }
        
        if (-e "$documentStorePath/$localFileName.rtf") {
            for (1..100) {
                unless (-e "$documentStorePath/$localFileName($_).rtf") {
                    $suffix = "($_)";
                    last;
                }
            }
        }
        
        copy $templateFile, "$documentStorePath/$localFileName$suffix.rtf";
        push @errors, { id => "filepath", msg => "Cant read new file"}
            unless -e -r "$documentStorePath/$localFileName$suffix.rtf";
        
    }
    
    unless (@errors) {
        
        my $id = $c->uuid;
        my $digest   = Inprint::Utils::Files::GetDigest($c, "$documentStorePath/$localFileName$suffix.rtf");
        my $mimetype = Inprint::Utils::Files::GetMimeType($c, "$documentStorePath/$localFileName$suffix.rtf");
        my $filesize = Inprint::Utils::Files::GetFileSize($c, "$documentStorePath/$localFileName$suffix.rtf");
        my $created  = Inprint::Utils::Files::GetFileChangedDate($c, "$documentStorePath/$localFileName$suffix.rtf");
        my $updated  = Inprint::Utils::Files::GetFileModifiedDate($c, "$documentStorePath/$localFileName$suffix.rtf");
        
        my $sqlite = $c->getSQLiteHandler($documentStorePath);
        $sqlite->do("INSERT INTO files (id, filename, description, digest, mimetype, draft, created, updated) VALUES (?,?,?,?,?,?,?,?)", undef, 
            $id, "$fileName$suffix.rtf", $i_description, $digest, $mimetype, 1, $created, $updated
        );
        $sqlite->commit;
        $sqlite->disconnect;
        
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub upload {

    my $c = shift;
    
    my $i_document = $c->param("document");
    my $i_filename = $c->param("Filename");
    my $upload = $c->req->upload("Filedata");
    
    my @errors;
    my $success = $c->json->false;

    my $document = Inprint::Utils::GetDocumentById($c, id => $i_document);
    my $storePath = $c->getDocumentPath($document->{filepath}, \@errors);
    
    
    my ($name,$path,$extension) = fileparse("$storePath/$i_filename", qr/(\.[^.]+){1}?/);
    
    my $baseName = $name;
    my $baseExtension = $extension;
    
    if ($^O eq "MSWin32") {
        my $converter = Text::Iconv->new("utf-8", "windows-1251");
        $baseName = $converter->convert($baseName);
        $baseExtension = $converter->convert($baseExtension);
    }
    
    my $suffix;
    if (-e "$storePath/$baseName$baseExtension") {
        for (1..100) {
            unless (-e "$storePath/$baseName($_)$baseExtension") {
                $suffix = "($_)";
                last;
            }
        }
    }
    
    $upload->move_to("$storePath/$baseName$suffix$baseExtension");
    
        my $id = $c->uuid;
        my $digest   = Inprint::Utils::Files::GetDigest($c, "$storePath/$baseName$suffix$baseExtension");
        my $mimetype = Inprint::Utils::Files::GetMimeType($c, "$storePath/$baseName$suffix$baseExtension");
        my $filesize = Inprint::Utils::Files::GetFileSize($c, "$storePath/$baseName$suffix$baseExtension");
        my $created  = Inprint::Utils::Files::GetFileChangedDate($c, "$storePath/$baseName$suffix$baseExtension");
        my $updated  = Inprint::Utils::Files::GetFileModifiedDate($c, "$storePath/$baseName$suffix$baseExtension");
        
        my $sqlite = $c->getSQLiteHandler($storePath);
        $sqlite->do("INSERT INTO files (id, filename, description, digest, mimetype, draft, created, updated) VALUES (?,?,?,?,?,?,?,?)", undef, 
            $id, "$name$suffix$extension", "", $digest, $mimetype, 1, $created, $updated
        );
        $sqlite->commit;
        $sqlite->disconnect;
    
    $c->render_json( { success=> $c->json->true } );
}

sub update {

    my $c = shift;

    my $i_id = $c->param("id");
    
    my @errors;
    my $success = $c->json->false;
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub delete {

    my $c = shift;

    my $i_document = $c->param("document");
    my @i_files = $c->param("files");
    
    my @errors;
    my $success = $c->json->false;

    my $document = Inprint::Utils::GetDocumentById($c, id => $i_document);
    my $storePath = $c->getDocumentPath($document->{filepath}, \@errors);
    
    my $sqlite = $c->getSQLiteHandler($storePath);
    
    foreach my $file (@i_files) {
        
        my $sth  = $sqlite->prepare("SELECT * FROM files WHERE id = ?");
        $sth->execute( $file );
        my $record = $sth->fetchrow_hashref;
        $sth->finish();
        
        if ($^O eq "MSWin32") {
            my $converter = Text::Iconv->new("utf-8", "windows-1251");
            $record->{filename} = $converter->convert($record->{filename});
        }
        
        if ($record->{id} && -w $storePath && -w "$storePath/$record->{filename}") {
            
            $sqlite->do("DELETE FROM files WHERE id = ?", undef, $record->{id});
            $sqlite->commit();
            
            unlink("$storePath/$record->{filename}");
            if (-w "$storePath/.thumbnails/$record->{id}.png") {
                unlink "$storePath/.thumbnails/$record->{id}.png";
            }
        }
    }
    
    $sqlite->disconnect();
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub preview {

    my $c = shift;

    my $i_document = $c->param("document");
    my $i_file = $c->param("file");
    
    my @errors;
    my $success = $c->json->false;

    my $document = Inprint::Utils::GetDocumentById($c, id => $i_document);
    my $storePath = $c->getDocumentPath($document->{filepath}, \@errors);
    my $sqlite = $c->getSQLiteHandler($storePath);

    $sqlite->{sqlite_unicode} = 0;
    
    my $sth  = $sqlite->prepare("SELECT * FROM files WHERE id = ?");
    $sth->execute( $i_file );
    my $record = $sth->fetchrow_hashref;
    $sth->finish();

    if ($^O eq "MSWin32") {
        my $converter = Text::Iconv->new("utf-8", "windows-1251");
        $record->{filename} = $converter->convert($record->{filename});
    }

    if ($record->{id} && -r "$storePath/$record->{filename}") {
        
        unless (-r "$storePath/.thumbnails/$record->{id}.png") {
            
            my $host = $c->config->get("openoffice.host");
            my $port = $c->config->get("openoffice.port");
            my $timeout = $c->config->get("openoffice.timeout");
            
            my $url = "http://$host:$port/api/thumbnail/";
            
            my $ua  = LWP::UserAgent->new();

            my $filepath = "$storePath/$record->{filename}";

            my $request = POST "$url", Content_Type => 'form-data',
                Content => [ inputDocument =>  [  "$storePath/$record->{filename}" ] ];

            
            $ua->timeout($timeout);
            my $response = $ua->request($request);
            
            if ($response->is_success()) {
                open FILE, "> $storePath/.thumbnails/$record->{id}.png" or die "Can't open $storePath/.thumbnails/$record->{id}.png : $!";
                    binmode FILE;
                    print FILE $response->content;
                close FILE;
            } else {
                push @errors, { id => "responce", msg => $response->status_line };
            }
            
            if (-w "$storePath/.thumbnails/$record->{id}.png") {
                my $image = Image::Magick->new;
                my $x = $image->Read("$storePath/.thumbnails/$record->{id}.png");
                warn "$x" if "$x";
                
                $x = $image->AdaptiveResize(geometry=>"100x80");
                warn "$x" if "$x";
                
                $x = $image->Write("$storePath/.thumbnails/$record->{id}.png");
                warn "$x" if "$x";
            }
            
        }
        
        if (-r "$storePath/.thumbnails/$record->{id}.png") {
            $c->tx->res->headers->content_type('image/png');
            $c->res->content->asset(Mojo::Asset::File->new(path => "$storePath/.thumbnails/$record->{id}.png"));
            $c->render_static();
        }
        unless (-r "$storePath/.thumbnails/$record->{id}.png") {
            push @errors, { id => "result", msg => "Cant read file thumbnail"}
                unless -e -r "$storePath/.thumbnails/$record->{id}.png";
        }
        
    }
    
    $sqlite->disconnect();
    
    if (@errors) {
        $success = $c->json->true unless (@errors);
        $c->render_json( { success => $success, errors => \@errors } );
    }
}

sub createzip {
    my $c = shift;

    my $i_document = $c->param("document");
    my $i_type = $c->param("type");
    
    my @errors;
    my $success = $c->json->false;
    
    my $document = Inprint::Utils::GetDocumentById($c, id => $i_document);
    my $storePath = $c->getDocumentPath($document->{filepath}, \@errors);
    
    my @files;
    
    if (-r $storePath) {
        opendir DIR, $storePath or die "read dir $storePath - $!";
        @files = grep Inprint::Utils::Files::GetExtension($c, $_) ~~ ["doc", "odt", "rtf", "txt"], readdir DIR;
        closedir DIR;
    }
    
    unless (@errors) {
        
        my @archive;
        foreach my $file (@files) {
            my $filepath =   Inprint::Utils::Files::ProcessFilePath($c, "$storePath\\$file");
            #Encode::decode("utf8", $filepath);
            if (-r $filepath) {
                push @archive, "\"$filepath\"";
            }
        }
        
        my $ArcilveFileName = Inprint::Utils::Files::ProcessFilePath($c, "$storePath\\.tmp\\" . $c->uuid . ".7z");
        
        my $bin7z;
        if ($^O eq "MSWin32") {
            $bin7z = "7z";
        }
        
        if ($^O eq "linux") {
            $bin7z = "7z";
        }
        
        my $cmd = "export LANG=en_US.UTF-8; $bin7z a $ArcilveFileName " . join " ", @archive;

        `$cmd`;

        if (-r $ArcilveFileName) {
            my $headers = Mojo::Headers->new;
            $headers->add('Content-Type','application/x-7z-compressed;name=test.7z');
            $headers->add('Content-Disposition','attachment;filename=test.7z');
            $headers->add('Content-Description','7z');
            $c->res->content->headers($headers); 
            $c->res->content->asset(Mojo::Asset::File->new(path => $ArcilveFileName));
            $c->render_static();
        } else {
            push @errors, { id => "file", msg => "Cant read file $ArcilveFileName"};
        }

    }
    
    if (@errors) {
        $success = $c->json->true unless (@errors);
        $c->render_json( { success => $success, errors => \@errors, files => \@files } );
    }

    return $c;
}

# Utils

sub getSQLiteHandler {
    my $c = shift;
    my $filepath = shift;
    
    my $dbargs = { AutoCommit => 0, RaiseError => 1, sqlite_unicode => 1 };

    my $dbh = DBI->connect("dbi:SQLite:dbname=$filepath/.database/store.db","","",$dbargs);
    
    
    $dbh->do("
        CREATE TABLE IF NOT EXISTS files (
            id TEXT primary key,
            filename TEXT,
            description TEXT,
            digest TEXT,
            mimetype TEXT,
            draft INTEGER DEFAULT 1,
            created TEXT,
            updated TEXT
        );
    ");
    
    $dbh->do("
        CREATE TABLE IF NOT EXISTS versions (
            id TEXT primary key,
            fileid TEXT,
            filename TEXT,
            filedigest TEXT,
            version TEXT,
            created TEXT
        );
    ");
    
    $dbh->commit();
    if ($dbh->err()) { die "$DBI::errstr\n"; }
    
    
    return $dbh;
}

sub getDocumentPath {
    
    my $c = shift;
    my $filepath = shift;
    my $errors = shift;
    
    return unless $filepath;
    return unless $errors;
    
    # Get and check filepath
    my $storePath    = $c->config->get("store.path");
    
    return unless $storePath;
    
    push @$errors, { id => "filepath", msg => "Cant read store root folder from settings"}
        unless -e -w $storePath;
    
    push @$errors, { id => "filepath", msg => "Cant read document folder name from db"}
        unless defined $filepath;
    
    unless (@$errors) {
        $storePath .= "/documents/" . $filepath;
        make_path($storePath) unless -e -w $storePath;
        push @$errors, { id => "filepath", msg => "Cant create document folder"}
            unless -e -w $storePath;
    }
    
    # Config folder
    unless (@$errors) {
        make_path("$storePath/.config") unless -e -w "$storePath/.config";
        push @$errors, { id => "filepath", msg => "Cant create document database folder"}
            unless -e -w "$storePath/.config";
    }
    
    # DB folder
    unless (@$errors) {
        make_path("$storePath/.database") unless -e -w "$storePath/.database";
        push @$errors, { id => "filepath", msg => "Cant create document database folder"}
            unless -e -w "$storePath/.database";
    }
    
    # Origins folder
    unless (@$errors) {
        make_path("$storePath/.origins") unless -e -w "$storePath/.origins";
        push @$errors, { id => "filepath", msg => "Cant create document database folder"}
            unless -e -w "$storePath/.origins";
    }
    
    # Versions folder
    unless (@$errors) {
        make_path("$storePath/.versions") unless -e -w "$storePath/.versions";
        push @$errors, { id => "filepath", msg => "Cant create document versions folder"}
            unless -e -w "$storePath/.versions";
    }
    
    # Thumbnails folder
    unless (@$errors) {
        make_path("$storePath/.thumbnails") unless -e -w "$storePath/.thumbnails";
        push @$errors, { id => "filepath", msg => "Cant create document thumbnails folder"}
            unless -e -w "$storePath/.thumbnails";
    }

    # Tmp folder
    unless (@$errors) {
        make_path("$storePath/.tmp") unless -e -w "$storePath/.tmp";
        push @$errors, { id => "filepath", msg => "Cant create document tmp folder"}
            unless -e -w "$storePath/.tmp";
    }



    
    unless (@$errors) {
        $storePath = Inprint::Utils::Files::ProcessFilePath($c, $storePath);
    }
    
    return $storePath;
}

1;