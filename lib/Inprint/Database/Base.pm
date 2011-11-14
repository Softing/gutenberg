package Inprint::Database::Base;

use utf8;
use strict;
use warnings;

use Moose;

use Inprint::Database::Model::Edition;

use Inprint::Database::Model::Document;

use Inprint::Database::Model::Fascicle;
use Inprint::Database::Model::FasciclePage;
use Inprint::Database::Model::FascicleRequest;
use Inprint::Database::Model::FascicleModule;
use Inprint::Database::Model::FascicleModuleMapping;

sub setSql {
    my ($c, $sql) = @_;
    $c->sql($sql);
    return $c;
}

1;
