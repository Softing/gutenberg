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

    $self->log->level('debug');
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

    $sessionBridge->route('/logout/')->to('session#logout');

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
    $self->createRoutes($sessionBridge, "calendar",                 [ "create", "read", "update", "delete", "list", "tree", "enable", "disable" ]);
    $self->createRoutes($sessionBridge, "calendar/combos",          [ "editions", "parents", "sources" ]);

    # Common routes
    $self->createRoutes($sessionBridge, "common/transfer",          [ "editions", "branches", "list" ]);

    # Documents routes
    $self->createRoutes($sessionBridge, "documents",                [ "create", "read", "update", "delete", "list", "capture", "transfer", "briefcase", "move", "copy", "duplicate", "recycle", "restore", "say" ]);
    $self->createRoutes($sessionBridge, "documents/common",         [ "fascicles" ]);
    $self->createRoutes($sessionBridge, "documents/combos",         [ "stages", "assignments", "managers", "fascicles", "headlines", "rubrics" ]);
    $self->createRoutes($sessionBridge, "documents/trees",          [ "editions", "workgroups", "fascicles" ]);
    $self->createRoutes($sessionBridge, "documents/filters",        [ "editions", "groups", "fascicles", "headlines", "rubrics", "holders", "managers", "progress" ]);
    $self->createRoutes($sessionBridge, "documents/profile",        [ "read" ]);
    $self->createRoutes($sessionBridge, "documents/files",          [ "list", "create", "read", "update", "delete", "upload" ]);
    $self->createRoutes($sessionBridge, "documents/text",           [ "get", "set" ]);
    $self->createRoutes($sessionBridge, "documents/rss",            [ "read", "update" ]);

    $sessionBridge->route('/documents/files/preview/:document/:file')->to('documents-files#preview', document => "", file => "");
    $sessionBridge->route('/documents/:document/zip/:type')->to('documents-files#createzip', document => "", type => "");

    #$sessionBridge->route('/documents/files/upload/:document')->to('documents-files#upload', document => "");

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

    # Images
    $sessionBridge->route('/aimgs/fascicle/page/:id/:w/:h')->to('images#fascicle_page');
    $sessionBridge->route('/aimgs/fascicle/template/:id/:w/:h')->to('images#fascicle_page');
    $sessionBridge->route('/aimgs/fascicle/module/:id/:w/:h')->to('images#fascicle_page');
    $sessionBridge->route('/aimgs/advert/page/:id/:w/:h')->to('images#fascicle_page');
    $sessionBridge->route('/aimgs/advert/template/:id/:w/:h')->to('images#fascicle_page');
    $sessionBridge->route('/aimgs/advert/module/:id/:w/:h')->to('images#fascicle_page');

    # Profile routes
    $self->createRoutes($sessionBridge, "profile",                          [ "read", "update" ]);
    $sessionBridge->route('/profile/image/:id')->to('profile#image', id => "00000000-0000-0000-0000-000000000000");

    # Options routes
    $self->createRoutes($sessionBridge, "options",                  [ "update" ]);
    $self->createRoutes($sessionBridge, "options/combos",           [ "capture-destination" ]);

    # State route
    $self->createRoutes($sessionBridge, "state",                    [ "index", "read", "update" ]);

    # System routess
    $self->createRoutes($sessionBridge, "system/events",            [ "list" ]);

    # Workspace routess
    $self->createRoutes($sessionBridge, "access",                   [ "index" ]);
    $self->createRoutes($sessionBridge, "menu",                     [ "index" ]);
    $self->createRoutes($sessionBridge, "workspace",                [ "index", "access", "state", "online", "appsession" ]);

    # Main route
    $sessionBridge->route('/')->to('workspace#index');

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
