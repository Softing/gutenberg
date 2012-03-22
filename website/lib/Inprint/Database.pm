use utf8;
package Inprint::Database;

use strict;
use warnings;

use Inprint::Database::Model::Edition;
use Inprint::Database::Service::Edition;
use Inprint::Database::Service::Editions;

use Inprint::Database::Model::Fascicle;
use Inprint::Database::Service::Fascicle;
use Inprint::Database::Service::Fascicles;

use Inprint::Database::Model::Page;
use Inprint::Database::Service::Page;
use Inprint::Database::Service::Pages;

use Inprint::Database::Model::Document;
use Inprint::Database::Service::Document;
use Inprint::Database::Service::Documents;

#use Inprint::Database::Model::Request;
#use Inprint::Database::Service::Request;
#use Inprint::Database::Service::Requests;

# Editions
sub Edition {
    my ($c, $id) = @_;
    return  Inprint::Database::Model::Edition->new( app => $c );
}
sub EditionService {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Edition->new( app => $c );
}
sub EditionsManager {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Editions->new( app => $c );
}

#Fascicles
sub Fascicle {
    my ($c, $id) = @_;
    return  Inprint::Database::Model::Fascicle->new( app => $c );
}
sub FascicleService {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Fascicle->new( app => $c );
}
sub FasciclesManager {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Fascicles->new( app => $c );
}

# Pages
sub Page {
    my ($c, $id) = @_;
    return  Inprint::Database::Model::Page->new( app => $c );
}
sub PageService {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Page->new( app => $c );
}
sub PagesManager {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Pages->new( app => $c );
}

# Documents
sub Document {
    my ($c, $id) = @_;
    return  Inprint::Database::Model::Document->new( app => $c );
}
sub DocumentService {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Document->new( app => $c );
}
sub DocumentsManager {
    my ($c, $id) = @_;
    return  Inprint::Database::Service::Documents->new( app => $c );
}

# Requests
#sub RequestService {
#    my ($c, $id) = @_;
#    return  Inprint::Database::Model::Requests->new( app => $c );
#}

1;
