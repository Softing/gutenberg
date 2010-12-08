package Inprint::Documents::Files;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Digest::MD5 qw(md5 md5_hex md5_base64);
use YAML qw(DumpFile LoadFile);
use File::Spec;
use File::Copy qw(copy move);
use File::Path qw(make_path remove_tree);

use LWP::UserAgent;
use HTTP::Request::Common;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );

use Inprint::Utils;

use base 'Inprint::BaseController';

sub list {

    my $c = shift;

    my $i_id = $c->param("id");
    
    my @errors;
    my $success = $c->json->false;
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub create {

    my $c = shift;

    my $i_id = $c->param("id");
    
    my $i_title = $c->param("title");
    my $i_description = $c->param("description");
    
    my @errors;
    my $success = $c->json->false;

    my $document = Inprint::Utils::GetDocumentById($c, $i_id);
    
    # Get and check filepath
    my $storePath    = $c->config->get("store.path");
    my $templateFile = "$storePath/templates/template.rtf";
    
    push @errors, { id => "filepath", msg => "Cant read store root folder from settings"}
        unless -e -w $storePath;
        
    push @errors, { id => "filepath", msg => "Cant read store root folder from settings"}
        unless -e -r $templateFile;
    
    push @errors, { id => "filepath", msg => "Cant read document folder name from db"}
        unless defined $document->{filepath};
    
    unless (@errors) {
        $storePath .= "/documents/" . $document->{filepath};
        make_path($storePath) unless -e -w $storePath;
        push @errors, { id => "filepath", msg => "Cant create document folder"}
            unless -e -w $storePath;
    }
    
    unless (@errors) {
        make_path("$storePath/.thumbnails") unless -e -w "$storePath/.thumbnails";
        push @errors, { id => "filepath", msg => "Cant create document thumbnails folder"}
            unless -e -w "$storePath/.thumbnails";
    }
    
    my $fileId = $c->uuid;
    my $fileName = "$i_title.rtf";
    
    # Create file
    unless (@errors) {
        
        if (-e "$storePath/$fileName") {
            for (1..100) {
                $fileName = "$i_title($_).rtf";
                unless (-e "$storePath/$fileName") {
                    last;
                }
            }
        }
        copy $templateFile, "$storePath/$fileName";
        push @errors, { id => "filepath", msg => "Cant read new file"}
            unless -e -r "$storePath/$fileName";
    }
    
    # Create metadata
    unless (@errors) {
        
        my $digest = md5_hex("$storePath/$fileName");
        
        $c->set_attributes( $storePath, $fileName, {
            id => $fileId,
            digest => $digest,
            title => $i_title,
            description => $i_description
        } );
        
        push @errors, { id => "filepath", msg => "Cant read new file metadata"}
            unless -e -r "$storePath/.metadata/$fileName.metadata";
    }
    
    # Create preview
    unless (@errors) {
        
        my $host = $c->config->get("openoffice.host");
        my $port = $c->config->get("openoffice.port");
        my $timeout = $c->config->get("openoffice.timeout");
        
        my $url = "http://$host:$port/api/thumbnail/";
        
        my $ua  = LWP::UserAgent->new();
        my $request = POST "$url", Content_Type => 'form-data',
            Content => [
                inputDocument =>  [ "$storePath/$fileName" ]
            ];
        
        $ua->timeout($timeout);
        my $response = $ua->request($request);
        
        if ($response->is_success()) {
            open FILE, "> $storePath/.thumbnails/$fileId.png" or die "Can't open $storePath/.thumbnails/$fileId.png : $!";
                binmode FILE;
                print FILE $response->content;
            close FILE;
        }
        
        push @errors, { id => "filepath", msg => "Cant read new file thumbnail"}
            unless -e -r "$storePath/.thumbnails/$fileId.png";
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub upload {

    my $c = shift;

    my $i_id = $c->param("id");
    
    my @errors;
    my $success = $c->json->false;

    

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
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

    my $i_id = $c->param("id");
    
    my @errors;
    my $success = $c->json->false;

    

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

# Attributes

sub get_attributes {
    my $self = shift;
    my $path = shift;
    my $file = shift;
    
    my @attributes = $self->_list_attr($path, $file);
    
    my %result;
    foreach my $attribute (@attributes){
        $result{$attribute} = $self->_get_attr($path, $file, $attribute);
    }
    
    return %result;
}

sub set_attributes {
    my $self = shift;
    my $path = shift;
    my $file = shift;
    my $attributes = shift;
    foreach my $key (keys %$attributes){
        $self->_set_attr($path, $file, $key, $attributes->{$key});
    }
}

sub _load_attr {
    my $self = shift;
    my $path = shift;
    my $file = shift;
    my $data;
    my $attrfile = "$path/.metadata/$file.metadata";
    if (-r $attrfile) {
       $data = LoadFile($attrfile);
    }
    return $data;
}

sub _save_attr {
    my $self = shift;
    my $path = shift;
    my $file = shift;
    my $data = shift;
    
    my $attrfile = "$path/.metadata/$file.metadata";
    
    unless (-e "$path/.metadata") {
        make_path("$path/.metadata/") ;
    }
    
    if (-w "$path/.metadata") {
        if(!scalar keys %$data){
            unlink $attrfile;
        }
        else {
            DumpFile($attrfile, $data);
        }
    }
}

sub _list_attr  {
    my $self = shift;
    my $path = shift;
    my $file = shift;
    my $data = {};
    eval {
        $data = $self->_load_attr($path, $file);
    };
    return keys %{$data};
}

sub _get_attr  {
    my $self = shift;
    my $path = shift;
    my $file = shift;
    my $attr = shift;
    my $data = $self->_load_attr($path, $file);
    return $data->{$attr};
}

sub _set_attr {
    my $self  = shift;
    my $path  = shift;
    my $file  = shift;
    my $key   = shift;
    my $value = shift;

    my $data = {};
    
    eval {
        $data = $self->_load_attr($path, $file);
    };
    
    $data->{$key} = $value;
    $self->_save_attr($path, $file, $data);
    return 1;
}

sub _unset_attr {
    my $self = shift;
    my $path = shift;
    my $file = shift;
    my $key  = shift;
    
    my $data = {};
    eval {
        $data = $self->_load_attr($path, $file);
    };
    
    delete $data->{$key};
    $self->_save($path, $file, $data);
    return 1;
}

1;
