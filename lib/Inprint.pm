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

    $self->log->level('error');
    $self->secret('passw0rd');

    $self->sessions->cookie_name("inprint");
    $self->sessions->default_expiration(864000);

    $self->types->type(json => 'application/json; charset=utf-8;');

    # Load configuration
    my $config = new Inprint::Frameworks::Config();
    $self->{config} = $config->load( $self->home->to_string );

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

    $self->plugins->namespaces([qw(Mojo::Plugins)]);
    $self->plugin("inprint-access");


    # Create Routes
    $self->routes->route('/setup/database/')->to('setup#database');
    #$self->routes->route('/setup/store/')->to('setup#store');
    $self->routes->route('/setup/import/')->to('setup#import');
    $self->routes->route('/setup/success/')->to('setup#success');

    $self->routes->route('/errors/database/')->to('errors#database');

    my $preinitBridge  = $self->routes->bridge->to('selftest#preinit');
    my $storeBridge    = $preinitBridge->bridge->to('selftest#store');
    my $postinitBridge = $storeBridge->bridge->to('selftest#postinit');

    # Add routes
    $postinitBridge->route('/login/')->to('session#login');
    $postinitBridge->route('/workspace/login/')->to('session#login');
    $postinitBridge->route('/locale/')->to('locale#index');

    # Add sessionable routes
    my $sessionBridge  = $postinitBridge->bridge->to('filters#mysession');

    # Access Framework
    $sessionBridge->route('/access/')                       ->to('access#index');

    # Advertising
    $self->createRoutes($sessionBridge, "advertising/archive",      [ "list" ]);
    $self->createRoutes($sessionBridge, "advertising/advertisers",  [ "list", "create", "read", "update", "delete" ]);
    $self->createRoutes($sessionBridge, "advertising/common",       [ "editions", "fascicles", "places" ]);
    $self->createRoutes($sessionBridge, "advertising/combo",        [ "advertisers", "managers", "fascicles", "places", "modules" ]);
    $self->createRoutes($sessionBridge, "advertising/index",        [ "headlines", "modules", "save" ]);
    $self->createRoutes($sessionBridge, "advertising/modules",      [ "list", "create", "read", "update", "delete" ]);
    $self->createRoutes($sessionBridge, "advertising/pages",        [ "list", "create", "read", "update", "delete" ]);
    $self->createRoutes($sessionBridge, "advertising/places",       [ "list", "create", "read", "update", "delete" ]);
    $self->createRoutes($sessionBridge, "advertising/requests",     [ "list", "create", "read", "update", "delete" ]);

    # Calendar routes
    $sessionBridge->route('/calendar/create/')              ->to('calendar#create');
    $sessionBridge->route('/calendar/read/')                ->to('calendar#read');
    $sessionBridge->route('/calendar/update/')              ->to('calendar#update');
    $sessionBridge->route('/calendar/delete/')              ->to('calendar#delete');
    $sessionBridge->route('/calendar/list/')                ->to('calendar#list');
    $sessionBridge->route('/calendar/tree/')                ->to('calendar#tree');
    $sessionBridge->route('/calendar/enable/')              ->to('calendar#enable');
    $sessionBridge->route('/calendar/disable/')             ->to('calendar#disable');

    # Calendar combos
    $sessionBridge->route('/calendar/combos/editions/')     ->to('calendar-combos#editions');
    $sessionBridge->route('/calendar/combos/parents/')      ->to('calendar-combos#parents');
    $sessionBridge->route('/calendar/combos/sources/')      ->to('calendar-combos#sources');

    # Catalog routes
    $self->createRoutes($sessionBridge, "catalog/combos",                   [ "editions", "groups", "fascicles", "roles", "readiness" ]);
    $self->createRoutes($sessionBridge, "catalog/editions",                 [ "create", "read", "update", "delete", "tree" ]);
    $self->createRoutes($sessionBridge, "catalog/organization",             [ "create", "read", "update", "delete", "tree", "map", "unmap" ]);
    $self->createRoutes($sessionBridge, "catalog/readiness",                [ "create", "read", "update", "delete", "list" ]);
    $self->createRoutes($sessionBridge, "catalog/roles",                    [ "create", "read", "update", "delete", "list", "map", "mapping" ]);
    $self->createRoutes($sessionBridge, "catalog/rules",                    [ "list", "mapping", "map" ]);
    $self->createRoutes($sessionBridge, "catalog/members",                  [ "create", "delete", "list", "rules", "setup" ]); #"map", "mapping",
    $self->createRoutes($sessionBridge, "catalog/stages",                   [ "create", "read", "update", "delete", "list", "map-principals", "unmap-principals", "principals-mapping" ]);
    $self->createRoutes($sessionBridge, "catalog/principals",               [ "list" ]);
    $self->createRoutes($sessionBridge, "catalog/indexes",                  [ "editions" ]);
    $self->createRoutes($sessionBridge, "catalog/headlines",                [ "tree", "read", "create", "update", "delete" ]);
    $self->createRoutes($sessionBridge, "catalog/rubrics",                  [ "list", "read", "create", "update", "delete" ]);

    # Common routes
    $sessionBridge->route('/common/transfer/editions/')     ->to('common-transfer#editions');
    $sessionBridge->route('/common/transfer/branches/')     ->to('common-transfer#branches');
    $sessionBridge->route('/common/transfer/list/')         ->to('common-transfer#list');

    # Documents routes
    $sessionBridge->route('/documents/create/')             ->to('documents#create');
    $sessionBridge->route('/documents/read/')               ->to('documents#read');
    $sessionBridge->route('/documents/update/')             ->to('documents#update');
    $sessionBridge->route('/documents/delete/')             ->to('documents#delete');
    $sessionBridge->route('/documents/list/')               ->to('documents#list');
    $sessionBridge->route('/documents/capture/')            ->to('documents#capture');
    $sessionBridge->route('/documents/transfer/')           ->to('documents#transfer');
    $sessionBridge->route('/documents/briefcase/')          ->to('documents#briefcase');
    $sessionBridge->route('/documents/move/')               ->to('documents#move');
    $sessionBridge->route('/documents/copy/')               ->to('documents#copy');
    $sessionBridge->route('/documents/duplicate/')          ->to('documents#duplicate');
    $sessionBridge->route('/documents/recycle/')            ->to('documents#recycle');
    $sessionBridge->route('/documents/restore/')            ->to('documents#restore');
    $sessionBridge->route('/documents/say/')                ->to('documents#say');

    $sessionBridge->route('/documents/hotsave/list/')        ->to('documents-hotsave#list');
    $sessionBridge->route('/documents/hotsave/read/')        ->to('documents-hotsave#read');

    $sessionBridge->route('/documents/versions/list/')       ->to('documents-versions#list');
    $sessionBridge->route('/documents/versions/read/')       ->to('documents-versions#read');


    # Document common
    $sessionBridge->route('/documents/common/fascicles/')   ->to('documents-common#fascicles');

    # Document combos
    $sessionBridge->route('/documents/combos/stages/')      ->to('documents-combos#stages');
    $sessionBridge->route('/documents/combos/assignments/') ->to('documents-combos#assignments');
    $sessionBridge->route('/documents/combos/managers/')    ->to('documents-combos#managers');
    $sessionBridge->route('/documents/combos/fascicles/')   ->to('documents-combos#fascicles');
    $sessionBridge->route('/documents/combos/headlines/')   ->to('documents-combos#headlines');
    $sessionBridge->route('/documents/combos/rubrics/')     ->to('documents-combos#rubrics');

    # Document trees
    $sessionBridge->route('/documents/trees/editions/')     ->to('documents-trees#editions');
    $sessionBridge->route('/documents/trees/workgroups/')   ->to('documents-trees#workgroups');
    $sessionBridge->route('/documents/trees/fascicles/')    ->to('documents-trees#fascicles');

    # Document filters
    $sessionBridge->route('/documents/filters/editions/')   ->to('documents-filters#editions');
    $sessionBridge->route('/documents/filters/groups/')     ->to('documents-filters#groups');
    $sessionBridge->route('/documents/filters/fascicles/')  ->to('documents-filters#fascicles');
    $sessionBridge->route('/documents/filters/headlines/')  ->to('documents-filters#headlines');
    $sessionBridge->route('/documents/filters/rubrics/')    ->to('documents-filters#rubrics');
    $sessionBridge->route('/documents/filters/holders/')    ->to('documents-filters#holders');
    $sessionBridge->route('/documents/filters/managers/')   ->to('documents-filters#managers');
    $sessionBridge->route('/documents/filters/progress/')   ->to('documents-filters#progress');

    # Document profile
    $sessionBridge->route('/documents/profile/read/')       ->to('documents-profile#read');

    # Document editor
    $sessionBridge->route('/documents/text/get/')           ->to('documents-text#get');
    $sessionBridge->route('/documents/text/set/')           ->to('documents-text#set');

    # Document files
    $sessionBridge->route('/documents/files/list/')         ->to('documents-files#list');
    $sessionBridge->route('/documents/files/create/')       ->to('documents-files#create');
    $sessionBridge->route('/documents/files/upload/')       ->to('documents-files#upload');
    $sessionBridge->route('/documents/files/read/')         ->to('documents-files#read');
    $sessionBridge->route('/documents/files/update/')       ->to('documents-files#update');
    $sessionBridge->route('/documents/files/delete/')       ->to('documents-files#delete');
    $sessionBridge->route('/documents/files/publish/')      ->to('documents-files#publish');
    $sessionBridge->route('/documents/files/unpublish/')    ->to('documents-files#unpublish');
    $sessionBridge->route('/documents/files/description/')  ->to('documents-files#description');

    # Fascicles routes
    $self->createRoutes($sessionBridge, "fascicle",                         [ "seance", "check", "open", "close", "save", "capture" ]);
    $self->createRoutes($sessionBridge, "fascicle/combos",                  [ "templates", "workgroups", "headlines", "rubrics" ]);
    $self->createRoutes($sessionBridge, "fascicle/composer",                [ "initialize", "save", "templates", "modules" ]);
    $self->createRoutes($sessionBridge, "fascicle/documents",               [ "list" ]);
    $self->createRoutes($sessionBridge, "fascicle/indexes",                 [ "editions", "headlines", "rubrics", "create", "update", "delete" ]);
    $self->createRoutes($sessionBridge, "fascicle/headlines",               [ "tree", "read", "create", "update", "delete" ]);
    $self->createRoutes($sessionBridge, "fascicle/modules",                 [ "list", "create", "read", "update", "delete" ]);
    $self->createRoutes($sessionBridge, "fascicle/pages",                   [ "view", "modules", "create", "read", "update", "delete", "move", "left", "right", "resize", "clean" ]);
    $self->createRoutes($sessionBridge, "fascicle/requests",                [ "process", "list", "create", "read", "update", "move", "delete" ]);
    $self->createRoutes($sessionBridge, "fascicle/rubrics",                 [ "list", "read", "create", "update", "delete" ]);

    $self->createRoutes($sessionBridge, "fascicle/templates",               [ "modules" ]);
    $self->createRoutes($sessionBridge, "fascicle/templates/modules",       [ "list", "create", "read", "update", "delete" ]);
    $self->createRoutes($sessionBridge, "fascicle/templates/pages",         [ "list", "create", "read", "update", "delete" ]);
    $self->createRoutes($sessionBridge, "fascicle/templates/places",        [ "tree", "create", "read", "update", "delete" ]);
    $self->createRoutes($sessionBridge, "fascicle/templates/index",         [ "headlines", "modules", "save" ]);

    # Files
    $sessionBridge->route('/files/preview/:id')             ->to('files#preview');
    $sessionBridge->route('/files/download/:id')            ->to('files#download');
    $sessionBridge->route('/files/download/')                   ->to('files#download');

    # Images
    $sessionBridge->route('/aimgs/fascicle/page/:id/:w/:h')     ->to('images#fascicle_page');
    $sessionBridge->route('/aimgs/fascicle/template/:id/:w/:h') ->to('images#fascicle_page');
    $sessionBridge->route('/aimgs/fascicle/module/:id/:w/:h')   ->to('images#fascicle_page');

    $sessionBridge->route('/aimgs/advert/page/:id/:w/:h')       ->to('images#fascicle_page');
    $sessionBridge->route('/aimgs/advert/template/:id/:w/:h')   ->to('images#fascicle_page');
    $sessionBridge->route('/aimgs/advert/module/:id/:w/:h')     ->to('images#fascicle_page');

    # Logout
    $sessionBridge->route('/logout/')->to('session#logout');

    # Inprint menu
    $sessionBridge->route('/menu/')                         ->to('menu#index');

    # Profile routes
    $sessionBridge->route('/profile/read/')                 ->to('profile#read');
    $sessionBridge->route('/profile/update/')               ->to('profile#update');
    $sessionBridge->route('/profile/image/:id')             ->to('profile#image', id => "00000000-0000-0000-0000-000000000000");

    # Options routes
    $sessionBridge->route('/options/update/')               ->to('options#update');
    $self->createRoutes($sessionBridge, "options/combos", [ "capture-destination" ]);

    # State route
    $sessionBridge->route('/state/')                        ->to('state#index');
    $sessionBridge->route('/state/read/')                   ->to('state#read');
    $sessionBridge->route('/state/update/')                 ->to('state#update');

    # System routess
    $sessionBridge->route('/system/events/')                ->to('system-events#list');

    # Workspace routess
    $sessionBridge->route('/workspace/')                    ->to('workspace#index');
    $sessionBridge->route('/workspace/access/')             ->to('workspace#access');
    $sessionBridge->route('/workspace/state/')              ->to('workspace#state');
    $sessionBridge->route('/workspace/appsession/')         ->to('workspace#appsession');
    $sessionBridge->route('/workspace/logout/')             ->to('session#logout');

    # Main route
    $sessionBridge->route('/')->to('workspace#index');

    # Plugin routes
    my $routes = $sql->Q("SELECT * FROM plugins.routes WHERE route_enabled=true")->Hashes;
    foreach my $route (@$routes) {

        my $url = "/plugin" . $route->{route_url};
        my $action = $route->{route_controller} ."#". $route->{route_action};

        if ($route->{route_authentication}) {
            $sessionBridge->route($url)->to($action);
        }
        unless ($route->{route_authentication}) {
            $postinitBridge->route($url)->to($action);
        }
    }

    return $self;
}

sub createRoutes {
    my $c = shift;
    my $bridge = shift;
    my $prefix = shift;
    my $routes = shift;

    foreach my $route (@$routes) {

        my $cprefix = "/$prefix/$route/";

        if ($route eq "index") {
            $cprefix = "/$prefix/";
        }

        my $croute  = $prefix;
        $croute =~ s/\//-/g;

        my @routes = split('-', $route);
        for (my $i=1; $i <= $#routes; $i++) {
            $routes[$i] = ucfirst($routes[$i]);
        }
        $route = join("", @routes);
        $croute = "$croute#$route";

        $bridge->route($cprefix)->to( $croute );
        #say STDERR "$bridge->route($cprefix)->to( $croute );";
    }

    return 1;
}

1;
