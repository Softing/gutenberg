package Inprint::Documents::Text;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use DBI;

use utf8;
use Encode;

use File::Temp qw/ tempfile tempdir /;
use LWP::UserAgent;
use HTTP::Request::Common;
use Text::Iconv;

use Inprint::Utils;

use base 'Inprint::BaseController';

sub get {
    my $c = shift;
    
    my $i_oid = $c->param("oid");
    
    my ($document, $file) = split '::', $i_oid;
    
    my @errors;
    my $success = $c->json->false;
    
    
    $document = Inprint::Utils::GetDocumentById($c, $document);
    my $storePath = $c->getDocumentPath($document->{filepath}, \@errors);
    my $sqlite = $c->getSQLiteHandler($storePath);

    $sqlite->{sqlite_unicode} = 0;
    
    my $sth  = $sqlite->prepare("SELECT * FROM files WHERE id = ?");
    $sth->execute( $file );
    my $record = $sth->fetchrow_hashref;
    $sth->finish();
    
    if ($^O eq "MSWin32") {
        my $converter = Text::Iconv->new("utf-8", "windows-1251");
        $record->{filename} = $converter->convert($record->{filename});
    }
    
    my $data;
    
    if ($record->{id} && -r "$storePath/$record->{filename}") {
        
        my $host = $c->config->get("openoffice.host");
        my $port = $c->config->get("openoffice.port");
        my $timeout = $c->config->get("openoffice.timeout");
        
        my $url = "http://$host:$port/api/converter/";
        
        my $ua  = LWP::UserAgent->new();

        my $filepath = "$storePath/$record->{filename}";

        my $request = POST "$url", Content_Type => 'form-data',
            Content => [
                outputFormat => "html",
                inputDocument =>  [  "$storePath/$record->{filename}" ]
            ];
        
        
            
        my $response = $ua->request($request);
        if ($response->is_success()) {
            
            $data = $response->content ;
            die $data;
            
            
            #my $converter = Text::Iconv->new("windows-1251", "utf-8");
            #$data = $converter->convert($data);
            
        } else {
            print $response->as_string;
        }
        
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $data } );
}

sub set {
    my $c = shift;
    
    my $i_document = $c->param("document");
    my $i_file = $c->param("file");
    
}

sub getSQLiteHandler {
    my $c = shift;
    my $filepath = shift;
    
    my $dbargs = { AutoCommit => 0, RaiseError => 1, sqlite_unicode => 1 };
    
    my $dbh = DBI->connect("dbi:SQLite:dbname=$filepath/.database/store.db","","",$dbargs);
    
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
    
    unless (@$errors) {
        $storePath = $c->processPath($storePath);
    }
    
    return $storePath;
}

sub processPath {
    my $c = shift;
    my $filepath = shift;
    
    $filepath =~ s/\\+/\\/g;
    $filepath =~ s/\/+/\//g;
    
    if ($^O eq "MSWin32") {
        $filepath =~ s/\/+/\\/g;
    }
    
    if ($^O eq "linux") {
        $filepath =~ s/\\+/\//g;
    }
    
    return $filepath;
}

1;
