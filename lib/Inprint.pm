package Inprint;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use DBIx::Connector;
#use DBD::Pg;

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
    ref($self)->attr( 'config' => sub {
        my $selft = shift;
        return $config;
    } );

    my $name     = $config->get("db.name");
    my $host     = $config->get("db.host");
    my $port     = $config->get("db.port");
    my $username = $config->get("db.user");
    my $password = $config->get("db.user");
    
    my $dsn = 'dbi:Pg:dbname='. $name .';host='. $host .';port='. $port .';';
    my $atr = { AutoCommit=>1, RaiseError=>1, pg_enable_utf8=>1 };
    
    # Create a connection.
    my $conn = DBIx::Connector->new($dsn, $username, $password, $atr );
    
    # Create SQL mappings
    my $sql = new Inprint::Frameworks::SQL();
    $sql->SetConnection($conn);
    
    ref($self)->attr( 'sql' => sub {
        my $selft = shift;
        return $sql;
    } );
    
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
    
    # Settings route
    $sessionBridge->route('/settings/editions/list/')->to( 'settings-editions#list' );
    
    # Index route
    $sessionBridge->route('/')->to('index#index');
    
    
    
    return $self;
}

1;
