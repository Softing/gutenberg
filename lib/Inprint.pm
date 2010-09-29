    package Inprint;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Devel::SimpleTrace;
use DBIx::Connector;

use base 'Mojolicious';

use Inprint::Frameworks::Config;
use Inprint::Frameworks::SQL;

__PACKAGE__->attr('dbh');
__PACKAGE__->attr('config');
__PACKAGE__->attr('locale');
__PACKAGE__->attr('sql');

sub startup {

    my $self = shift;

    $self->log->level('warn');
    $self->secret('passw0rd');

    $self->session->cookie_name("inprint");
    $self->session->default_expiration(864000);

    $self->types->type(json => 'application/json; charset=utf-8;');

    # Load configuration
    my $config = new Inprint::Frameworks::Config(
        $self->home->to_string
    );

    $self->{config} = $config;

    my $name     = $config->get("db.name");
    my $host     = $config->get("db.host");
    my $port     = $config->get("db.port");
    my $username = $config->get("db.user");
    my $password = $config->get("db.user");

    my $dsn = 'dbi:Pg:dbname='. $name .';host='. $host .';port='. $port .';';
    my $atr = { AutoCommit=>1, RaiseError=>1, PrintError=>1, pg_enable_utf8=>1 };

    # Create a connection.
    my $conn = DBIx::Connector->new($dsn, $username, $password, $atr );

    # Create SQL mappings
    my $sql = new Inprint::Frameworks::SQL();
    $sql->SetConnection($conn);

    $self->{sql} = $sql;

    # Load Plugins
    $self->plugin('i18n');

    # Create Routes

    $self->routes->route('/setup/database/')->to('setup#database');
    $self->routes->route('/setup/import/')->to('setup#import');
    $self->routes->route('/setup/success/')->to('setup#success');

    $self->routes->route('/errors/database/')->to('errors#database');

    my $preinitBridge = $self->routes->bridge->to('selftest#preinit');
    #my $databaseBridge = $preinitBridge->bridge->to('filters#database');
    my $postinitBridge = $preinitBridge->bridge->to('selftest#postinit');

    # Add routes
    $postinitBridge->route('/login/')->to('session#login');
    $postinitBridge->route('/logout/')->to('session#logout');
    $postinitBridge->route('/locale/')->to('locale#index');

    $postinitBridge->route('/common/list/edition-all/')->to('common-list#editions', filter => 'all');

    # Add sessionable routes
    my $sessionBridge  = $postinitBridge->bridge->to('filters#mysession');

    # Workspace routes
    $sessionBridge->route('/workspace/')->to('index#index');
    $sessionBridge->route('/workspace/menu/')->to('index#menu');
    $sessionBridge->route('/workspace/state/')->to('index#state');
    $sessionBridge->route('/workspace/online/')->to('index#online');
    $sessionBridge->route('/workspace/appsession/')->to('index#appsession');

    # Calendar routes
    $sessionBridge->route('/calendar/list/')->to( 'calendar#list' );
    $sessionBridge->route('/calendar/create/')->to( 'calendar#create' );
    $sessionBridge->route('/calendar/read/')->to( 'calendar#read' );
    $sessionBridge->route('/calendar/update/')->to( 'calendar#update' );
    $sessionBridge->route('/calendar/delete/')->to( 'calendar#delete' );
    $sessionBridge->route('/calendar/enable/')->to( 'calendar#enable' );
    $sessionBridge->route('/calendar/disable/')->to( 'calendar#disable' );
    $sessionBridge->route('/calendar/combo/groups/')->to( 'calendar#combogroups' );

    # Documents routes
    $sessionBridge->route('/documents/list/')->to( 'documents#list' );
    $sessionBridge->route('/documents/create/')->to( 'documents#create' );
    $sessionBridge->route('/documents/read/')->to( 'documents#read' );
    $sessionBridge->route('/documents/update/')->to( 'documents#update' );
    $sessionBridge->route('/documents/delete/')->to( 'documents#delete' );

    # Documents combos
    $sessionBridge->route('/documents/combos/groups')->to( 'documents-combos#groups' );
    $sessionBridge->route('/documents/combos/fascicles')->to( 'documents-combos#fascicles' );
    $sessionBridge->route('/documents/combos/headlines')->to( 'documents-combos#headlines' );
    $sessionBridge->route('/documents/combos/rubrics')->to( 'documents-combos#rubrics' );
    $sessionBridge->route('/documents/combos/holders')->to( 'documents-combos#holders' );
    $sessionBridge->route('/documents/combos/managers')->to( 'documents-combos#managers' );
    $sessionBridge->route('/documents/combos/progress')->to( 'documents-combos#progress' );

    # Catalog routes
    $sessionBridge->route('/catalog/tree/')->to( 'catalog#tree' );
    $sessionBridge->route('/catalog/combo/')->to( 'catalog#combo' );
    $sessionBridge->route('/catalog/create/')->to( 'catalog#create' );
    $sessionBridge->route('/catalog/read/')->to( 'catalog#read' );
    $sessionBridge->route('/catalog/update/')->to( 'catalog#update' );
    $sessionBridge->route('/catalog/delete/')->to( 'catalog#delete' );


    # Catalog combos
    $sessionBridge->route('/catalog/combos/groups/')->to( 'catalog-combos#groups' );
    $sessionBridge->route('/catalog/combos/roles/')->to( 'catalog-combos#roles' );

    # Rules routes
    $sessionBridge->route('/rules/list/')->to( 'rules#list' );

    # Roles routes
    $sessionBridge->route('/roles/list/')->to( 'roles#list' );
    $sessionBridge->route('/roles/create/')->to( 'roles#create' );
    $sessionBridge->route('/roles/read/')->to( 'roles#read' );
    $sessionBridge->route('/roles/update/')->to( 'roles#update' );
    $sessionBridge->route('/roles/delete/')->to( 'roles#delete' );
    $sessionBridge->route('/roles/map/')->to( 'roles#map' );
    $sessionBridge->route('/roles/mapping/')->to( 'roles#mapping' );

    # Principals routes
    $sessionBridge->route('/principals/list/') ->to( 'principals#list' );
    $sessionBridge->route('/principals/combo/')->to( 'principals#combo' );

    # Members routes
    $sessionBridge->route('/members/list/')   ->to( 'members#list' );
    $sessionBridge->route('/members/combo/')  ->to( 'members#combo' );
    $sessionBridge->route('/members/create/') ->to( 'members#create' );
    $sessionBridge->route('/members/delete/') ->to( 'members#delete' );
    $sessionBridge->route('/members/map/')    ->to( 'members#map' );
    $sessionBridge->route('/members/mapping/')->to( 'members#mapping' );

    # Profile routes
    $sessionBridge->route('/profile/load/')->to( 'profile#load' );
    $sessionBridge->route('/profile/image/:id')->to( 'profile#image' );
    $sessionBridge->route('/profile/update/')->to( 'profile#update' );

    # Chains route
    $sessionBridge->route('/chains/create/')->to( 'chains#create' );
    $sessionBridge->route('/chains/read/')->to( 'chains#read' );
    $sessionBridge->route('/chains/update/')->to( 'chains#update' );
    $sessionBridge->route('/chains/delete/')->to( 'chains#delete' );
    $sessionBridge->route('/chains/combo/')->to( 'chains#combo' );

    # Stages route
    $sessionBridge->route('/stages/create/')->to( 'stages#create' );
    $sessionBridge->route('/stages/read/')->to( 'stages#read' );
    $sessionBridge->route('/stages/update/')->to( 'stages#update' );
    $sessionBridge->route('/stages/delete/')->to( 'stages#delete' );
    $sessionBridge->route('/stages/list/')->to( 'stages#list' );

    # State route
    $sessionBridge->route('/state/')->to('state#index');

    # Main route
    $sessionBridge->route('/')->to('index#index');

    return $self;
}

1;
