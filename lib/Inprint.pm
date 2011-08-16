package Inprint;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
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

    $self->log->level('info');
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

    $self->plugin("Inprint::Mojoplugins::Common");
    $self->plugin("Inprint::Mojoplugins::Confidence");
    $self->plugin("Inprint::Mojoplugins::Database");
    $self->plugin("Inprint::Mojoplugins::Events");
    $self->plugin("Inprint::Mojoplugins::Localization");
    $self->plugin("Inprint::Mojoplugins::Logger");
    $self->plugin("Inprint::Mojoplugins::Render");
    $self->plugin("Inprint::Mojoplugins::Session");
    $self->plugin("Inprint::Mojoplugins::Validation");

    # Add routes
    $self->routes->route('/login/')                             ->to('session#login');
    $self->routes->route('/workspace/login/')                   ->to('session#login');
    $self->routes->route('/locale/')                            ->to('locale#index');

    # Add sessionable routes
    my $sessionBridge  = $self->routes->bridge                  ->to('filters#mysession');

    # Access Framework
    $sessionBridge->route('/access/')                           ->to('access#index');

    # Advertisers
    $sessionBridge->route("/advertisers/list/")                 ->to("advertising-advertisers#list");
    $sessionBridge->route("/advertisers/create/")               ->to("advertising-advertisers#create");
    $sessionBridge->route("/advertisers/read/")                 ->to("advertising-advertisers#read");
    $sessionBridge->route("/advertisers/update/")               ->to("advertising-advertisers#update");
    $sessionBridge->route("/advertisers/delete/")               ->to("advertising-advertisers#delete");

    # Advertising
    $sessionBridge->route("/advertising/archive/list/")         ->to("advertising-archive#list");

    $sessionBridge->route("/advertising/advertisers/list/")     ->to("advertising-advertisers#list");
    $sessionBridge->route("/advertising/advertisers/create/")   ->to("advertising-advertisers#create");
    $sessionBridge->route("/advertising/advertisers/read/")     ->to("advertising-advertisers#read");
    $sessionBridge->route("/advertising/advertisers/update/")   ->to("advertising-advertisers#update");
    $sessionBridge->route("/advertising/advertisers/delete/")   ->to("advertising-advertisers#delete");

    $sessionBridge->route("/advertising/common/editions/")      ->to("advertising-common#editions");
    $sessionBridge->route("/advertising/common/fascicles/")     ->to("advertising-common#fascicles");
    $sessionBridge->route("/advertising/common/places/")        ->to("advertising-common#places");

    $sessionBridge->route("/advertising/combo/advertisers/")    ->to("advertising-combo#advertisers");
    $sessionBridge->route("/advertising/combo/managers/")       ->to("advertising-combo#managers");
    $sessionBridge->route("/advertising/combo/fascicles/")      ->to("advertising-combo#fascicles");
    $sessionBridge->route("/advertising/combo/places/")         ->to("advertising-combo#places");
    $sessionBridge->route("/advertising/combo/modules/")        ->to("advertising-combo#modules");

    $sessionBridge->route("/advertising/index/headlines/")      ->to("advertising-index#headlines");
    $sessionBridge->route("/advertising/index/modules/")        ->to("advertising-index#modules");
    $sessionBridge->route("/advertising/index/save/")           ->to("advertising-index#save");

    $sessionBridge->route("/advertising/modules/list/")         ->to("advertising-modules#list");
    $sessionBridge->route("/advertising/modules/create/")       ->to("advertising-modules#create");
    $sessionBridge->route("/advertising/modules/read/")         ->to("advertising-modules#read");
    $sessionBridge->route("/advertising/modules/update/")       ->to("advertising-modules#update");
    $sessionBridge->route("/advertising/modules/delete/")       ->to("advertising-modules#delete");

    $sessionBridge->route("/advertising/pages/list/")           ->to("advertising-pages#list");
    $sessionBridge->route("/advertising/pages/create/")         ->to("advertising-pages#create");
    $sessionBridge->route("/advertising/pages/read/")           ->to("advertising-pages#read");
    $sessionBridge->route("/advertising/pages/update/")         ->to("advertising-pages#update");
    $sessionBridge->route("/advertising/pages/delete/")         ->to("advertising-pages#delete");

    $sessionBridge->route("/advertising/places/list/")          ->to("advertising-places#list");
    $sessionBridge->route("/advertising/places/create/")        ->to("advertising-places#create");
    $sessionBridge->route("/advertising/places/read/")          ->to("advertising-places#read");
    $sessionBridge->route("/advertising/places/update/")        ->to("advertising-places#update");
    $sessionBridge->route("/advertising/places/delete/")        ->to("advertising-places#delete");

    $sessionBridge->route("/advertising/requests/list/")        ->to("advertising-requests#list");
    $sessionBridge->route("/advertising/requests/summary/")     ->to("advertising-requests#summary");
    $sessionBridge->route("/advertising/requests/download/")    ->to("advertising-requests#download");
    $sessionBridge->route("/advertising/requests/create/")      ->to("advertising-requests#create");
    $sessionBridge->route("/advertising/requests/read/")        ->to("advertising-requests#read");
    $sessionBridge->route("/advertising/requests/update/")      ->to("advertising-requests#update");
    $sessionBridge->route("/advertising/requests/delete/")      ->to("advertising-requests#delete");
    $sessionBridge->route("/advertising/requests/status/")      ->to("advertising-requests#status");

    $sessionBridge->route("/advertising/requests/comments/list/")       ->to("advertising-requests-comments#list");
    $sessionBridge->route("/advertising/requests/comments/save/")       ->to("advertising-requests-comments#save");

    $sessionBridge->route("/advertising/requests/files/list/")          ->to("advertising-requests-files#list");
    $sessionBridge->route("/advertising/requests/files/upload/")        ->to("advertising-requests-files#upload");
    $sessionBridge->route("/advertising/requests/files/download/")      ->to("advertising-requests-files#download");
    $sessionBridge->route("/advertising/requests/files/publish/")       ->to("advertising-requests-files#publish");
    $sessionBridge->route("/advertising/requests/files/unpublish/")     ->to("advertising-requests-files#unpublish");
    $sessionBridge->route("/advertising/requests/files/description/")   ->to("advertising-requests-files#description");
    $sessionBridge->route("/advertising/requests/files/delete/")        ->to("advertising-requests-files#delete");

    # Calendar routes
    $sessionBridge->route("/calendar/list/")                    ->to("calendar#list");
    $sessionBridge->route("/calendar/tree/")                    ->to("calendar#tree");

    $sessionBridge->route("/calendar/layout/format/")           ->to("calendar-layout#format");

    $sessionBridge->route("/calendar/fascicle/read/")           ->to("calendar-fascicle#read");
    $sessionBridge->route("/calendar/fascicle/create/")         ->to("calendar-fascicle#create");
    $sessionBridge->route("/calendar/fascicle/update/")         ->to("calendar-fascicle#update");
    $sessionBridge->route("/calendar/fascicle/remove/")         ->to("calendar-fascicle#remove");
    $sessionBridge->route("/calendar/fascicle/template/")       ->to("calendar-fascicle#template");
    $sessionBridge->route("/calendar/fascicle/archive/")        ->to("calendar-fascicle#archive");
    $sessionBridge->route("/calendar/fascicle/unarchive/")      ->to("calendar-fascicle#unarchive");
    $sessionBridge->route("/calendar/fascicle/enable/")         ->to("calendar-fascicle#enable");
    $sessionBridge->route("/calendar/fascicle/disable/")        ->to("calendar-fascicle#disable");
    $sessionBridge->route("/calendar/fascicle/deadline/")       ->to("calendar-fascicle#deadline");

    $sessionBridge->route("/calendar/attachment/read/")         ->to("calendar-attachment#read");
    $sessionBridge->route("/calendar/attachment/create/")       ->to("calendar-attachment#create");
    $sessionBridge->route("/calendar/attachment/update/")       ->to("calendar-attachment#update");
    $sessionBridge->route("/calendar/attachment/remove/")       ->to("calendar-attachment#remove");

    $sessionBridge->route("/calendar/template/list/")         ->to("calendar-template#list");
    $sessionBridge->route("/calendar/template/read/")         ->to("calendar-template#read");
    $sessionBridge->route("/calendar/template/create/")       ->to("calendar-template#create");
    $sessionBridge->route("/calendar/template/update/")       ->to("calendar-template#update");
    $sessionBridge->route("/calendar/template/remove/")       ->to("calendar-template#remove");

    # Calendar combos
    $sessionBridge->route('/calendar/combos/editions/')         ->to('calendar-combos#editions');
    $sessionBridge->route('/calendar/combos/parents/')          ->to('calendar-combos#parents');
    $sessionBridge->route('/calendar/combos/childrens/')        ->to('calendar-combos#childrens');
    $sessionBridge->route('/calendar/combos/sources/')          ->to('calendar-combos#sources');
    $sessionBridge->route('/calendar/combos/templates/')        ->to('calendar-combos#templates');

    # Calendar trees
    $sessionBridge->route('/calendar/trees/editions/')          ->to('calendar-trees#editions');

    # Catalog routes
    $sessionBridge->route("/catalog/combos/editions/")          ->to("catalog-combos#creeditionsate");
    $sessionBridge->route("/catalog/combos/groups/")            ->to("catalog-combos#groups");
    $sessionBridge->route("/catalog/combos/fascicles/")         ->to("catalog-combos#fascicles");
    $sessionBridge->route("/catalog/combos/roles/")             ->to("catalog-combos#roles");
    $sessionBridge->route("/catalog/combos/readiness/")         ->to("catalog-combos#readiness");

    $sessionBridge->route("/catalog/editions/create/")          ->to("catalog-editions#create");
    $sessionBridge->route("/catalog/editions/read/")            ->to("catalog-editions#read");
    $sessionBridge->route("/catalog/editions/update/")          ->to("catalog-editions#update");
    $sessionBridge->route("/catalog/editions/delete/")          ->to("catalog-editions#delete");
    $sessionBridge->route("/catalog/editions/tree/")            ->to("catalog-editions#tree");

    $sessionBridge->route("/catalog/organization/create/")      ->to("catalog-organization#create");
    $sessionBridge->route("/catalog/organization/read/")        ->to("catalog-organization#read");
    $sessionBridge->route("/catalog/organization/update/")      ->to("catalog-organization#update");
    $sessionBridge->route("/catalog/organization/delete/")      ->to("catalog-organization#delete");
    $sessionBridge->route("/catalog/organization/tree/")        ->to("catalog-organization#tree");
    $sessionBridge->route("/catalog/organization/map/")         ->to("catalog-organization#map");
    $sessionBridge->route("/catalog/organization/unmap/")       ->to("catalog-organization#unmap");

    $sessionBridge->route("/catalog/readiness/create/")         ->to("catalog-readiness#create");
    $sessionBridge->route("/catalog/readiness/read/")           ->to("catalog-readiness#read");
    $sessionBridge->route("/catalog/readiness/update/")         ->to("catalog-readiness#update");
    $sessionBridge->route("/catalog/readiness/delete/")         ->to("catalog-readiness#delete");
    $sessionBridge->route("/catalog/readiness/list/")           ->to("catalog-readiness#list");

    $sessionBridge->route("/catalog/roles/create/")             ->to("catalog-roles#create");
    $sessionBridge->route("/catalog/roles/read/")               ->to("catalog-roles#read");
    $sessionBridge->route("/catalog/roles/update/")             ->to("catalog-roles#update");
    $sessionBridge->route("/catalog/roles/delete/")             ->to("catalog-roles#delete");
    $sessionBridge->route("/catalog/roles/tree/")               ->to("catalog-roles#tree");
    $sessionBridge->route("/catalog/roles/map/")                ->to("catalog-roles#map");
    $sessionBridge->route("/catalog/roles/mapping/")            ->to("catalog-roles#mapping");

    $sessionBridge->route('/catalog/rules/list/')               ->to('catalog-rules#list');
    $sessionBridge->route('/catalog/rules/clear/')              ->to('catalog-rules#clear');
    $sessionBridge->route('/catalog/rules/map/')                ->to('catalog-rules#map');
    $sessionBridge->route('/catalog/rules/mapping/')            ->to('catalog-rules#mapping');

    $sessionBridge->route('/catalog/members/create/')           ->to('catalog-members#create');
    $sessionBridge->route('/catalog/members/delete/')           ->to('catalog-members#delete');
    $sessionBridge->route('/catalog/members/list/')             ->to('catalog-members#list');
    $sessionBridge->route('/catalog/members/rules/')            ->to('catalog-members#rules');
    $sessionBridge->route('/catalog/members/setup/')            ->to('catalog-members#setup');

    $sessionBridge->route('/catalog/stages/create/')            ->to('catalog-stages#create');
    $sessionBridge->route('/catalog/stages/read/')              ->to('catalog-stages#read');
    $sessionBridge->route('/catalog/stages/update/')            ->to('catalog-stages#update');
    $sessionBridge->route('/catalog/stages/delete/')            ->to('catalog-stages#delete');
    $sessionBridge->route('/catalog/stages/list/')              ->to('catalog-stages#list');
    $sessionBridge->route('/catalog/stages/map-principals/')    ->to('catalog-stages#mapPrincipals');
    $sessionBridge->route('/catalog/stages/unmap-principals/')  ->to('catalog-stages#unmapPrincipals');
    $sessionBridge->route('/catalog/stages/principals-mapping/')->to('catalog-stages#principalsMapping');

    $sessionBridge->route('/catalog/principals/list/')          ->to('catalog-principals#list');

    $sessionBridge->route('/catalog/indexes/editions/')         ->to('catalog-indexes#editions');

    $sessionBridge->route("/catalog/headlines/tree/")           ->to("catalog-headlines#tree");
    $sessionBridge->route("/catalog/headlines/create/")         ->to("catalog-headlines#create");
    $sessionBridge->route("/catalog/headlines/read/")           ->to("catalog-headlines#read");
    $sessionBridge->route("/catalog/headlines/update/")         ->to("catalog-headlines#update");
    $sessionBridge->route("/catalog/headlines/delete/")         ->to("catalog-headlines#delete");

    $sessionBridge->route("/catalog/rubrics/list/")             ->to("catalog-rubrics#list");
    $sessionBridge->route("/catalog/rubrics/create/")           ->to("catalog-rubrics#create");
    $sessionBridge->route("/catalog/rubrics/read/")             ->to("catalog-rubrics#read");
    $sessionBridge->route("/catalog/rubrics/update/")           ->to("catalog-rubrics#update");
    $sessionBridge->route("/catalog/rubrics/delete/")           ->to("catalog-rubrics#delete");

    # Common routes
    $sessionBridge->route('/common/transfer/branches/')         ->to('common-transfer#branches');
    $sessionBridge->route('/common/transfer/editions/')         ->to('common-transfer#editions');
    $sessionBridge->route('/common/transfer/list/')             ->to('common-transfer#list');

    $sessionBridge->route('/common/combo/stages/')              ->to('common-combos#stages');
    $sessionBridge->route('/common/combo/assignments/')         ->to('common-combos#assignments');
    $sessionBridge->route('/common/combo/managers/')            ->to('common-combos#managers');
    $sessionBridge->route('/common/combo/fascicles/')           ->to('common-combos#fascicles');
    $sessionBridge->route('/common/combo/headlines/')           ->to('common-combos#headlines');
    $sessionBridge->route('/common/combo/rubrics/')             ->to('common-combos#rubrics');

    $sessionBridge->route('/common/tree/editions/')             ->to('common-trees#editions');
    $sessionBridge->route('/common/tree/workgroups/')           ->to('common-trees#workgroups');
    $sessionBridge->route('/common/tree/fascicles/')            ->to('common-trees#fascicles');

    # Documents routes
    $sessionBridge->route('/documents/array/')                  ->to("controllers-documents#array");
    $sessionBridge->route('/documents/briefcase/')              ->to("controllers-documents#briefcase");
    $sessionBridge->route('/documents/capture/')                ->to("controllers-documents#capture");
    $sessionBridge->route('/documents/copy/')                   ->to("controllers-documents#copy");
    $sessionBridge->route('/documents/create/')                 ->to("controllers-documents#create");
    $sessionBridge->route('/documents/delete/')                 ->to("controllers-documents#delete");
    $sessionBridge->route('/documents/duplicate/')              ->to("controllers-documents#duplicate");
    $sessionBridge->route('/documents/list/')                   ->to("controllers-documents#list");
    $sessionBridge->route('/documents/move/')                   ->to("controllers-documents#move");
    $sessionBridge->route('/documents/read/')                   ->to("controllers-documents#read");
    $sessionBridge->route('/documents/recycle/')                ->to("controllers-documents#recycle");
    $sessionBridge->route('/documents/restore/')                ->to("controllers-documents#restore");
    $sessionBridge->route('/documents/transfer/')               ->to("controllers-documents#transfer");
    $sessionBridge->route('/documents/update/')                 ->to("controllers-documents#update");

    $sessionBridge->route('/documents/comments/list/')          ->to('documents-comments#list');
    $sessionBridge->route('/documents/comments/save/')          ->to('documents-comments#save');

    $sessionBridge->route('/documents/hotsave/list/')           ->to('documents-hotsave#list');
    $sessionBridge->route('/documents/hotsave/read/')           ->to('documents-hotsave#read');

    $sessionBridge->route('/documents/versions/list/')          ->to('documents-versions#list');
    $sessionBridge->route('/documents/versions/read/')          ->to('documents-versions#read');


    # Document common
    $sessionBridge->route('/documents/common/fascicles/')       ->to('documents-common#fascicles');

    # Document combos
    $sessionBridge->route('/documents/combos/stages/')          ->to('documents-combos#stages');
    $sessionBridge->route('/documents/combos/assignments/')     ->to('documents-combos#assignments');
    $sessionBridge->route('/documents/combos/managers/')        ->to('documents-combos#managers');
    $sessionBridge->route('/documents/combos/fascicles/')       ->to('documents-combos#fascicles');
    $sessionBridge->route('/documents/combos/headlines/')       ->to('documents-combos#headlines');
    $sessionBridge->route('/documents/combos/rubrics/')         ->to('documents-combos#rubrics');

    # Document trees
    $sessionBridge->route('/documents/trees/editions/')         ->to('documents-trees#editions');
    $sessionBridge->route('/documents/trees/workgroups/')       ->to('documents-trees#workgroups');
    $sessionBridge->route('/documents/trees/fascicles/')        ->to('documents-trees#fascicles');

    # Document filters
    $sessionBridge->route('/documents/filters/editions/')       ->to('documents-filters#editions');
    $sessionBridge->route('/documents/filters/groups/')         ->to('documents-filters#groups');
    $sessionBridge->route('/documents/filters/fascicles/')      ->to('documents-filters#fascicles');
    $sessionBridge->route('/documents/filters/headlines/')      ->to('documents-filters#headlines');
    $sessionBridge->route('/documents/filters/rubrics/')        ->to('documents-filters#rubrics');
    $sessionBridge->route('/documents/filters/holders/')        ->to('documents-filters#holders');
    $sessionBridge->route('/documents/filters/managers/')       ->to('documents-filters#managers');
    $sessionBridge->route('/documents/filters/progress/')       ->to('documents-filters#progress');

    $sessionBridge->route('/documents/profile/read/')           ->to('documents-profile#read');

    $sessionBridge->route('/documents/text/get/')               ->to('documents-text#get');
    $sessionBridge->route('/documents/text/set/')               ->to('documents-text#set');

    $sessionBridge->route('/documents/files/list/')             ->to('documents-files#list');
    $sessionBridge->route('/documents/files/create/')           ->to('documents-files#create');
    $sessionBridge->route('/documents/files/upload/')           ->to('documents-files#upload');
    $sessionBridge->route('/documents/files/read/')             ->to('documents-files#read');
    $sessionBridge->route('/documents/files/update/')           ->to('documents-files#update');
    $sessionBridge->route('/documents/files/delete/')           ->to('documents-files#delete');
    $sessionBridge->route('/documents/files/publish/')          ->to('documents-files#publish');
    $sessionBridge->route('/documents/files/unpublish/')        ->to('documents-files#unpublish');
    $sessionBridge->route('/documents/files/description/')      ->to('documents-files#description');

    $sessionBridge->route('/documents/downloads/list/')         ->to('documents-downloads#list');
    $sessionBridge->route('/documents/downloads/download/')     ->to('documents-downloads#download');

    # Fascicles routes
    $sessionBridge->route('/fascicle/seance/')                  ->to('fascicle#seance');
    $sessionBridge->route('/fascicle/check/')                   ->to('fascicle#check');
    $sessionBridge->route('/fascicle/open/')                    ->to('fascicle#open');
    $sessionBridge->route('/fascicle/close/')                   ->to('fascicle#close');
    $sessionBridge->route('/fascicle/save/')                    ->to('fascicle#save');
    $sessionBridge->route('/fascicle/capture/')                 ->to('fascicle#capture');

    $sessionBridge->route('/fascicle/combos/templates/')        ->to('fascicle-combos#templates');
    $sessionBridge->route('/fascicle/combos/workgroups/')       ->to('fascicle-combos#workgroups');
    $sessionBridge->route('/fascicle/combos/headlines/')        ->to('fascicle-combos#headlines');
    $sessionBridge->route('/fascicle/combos/rubrics/')          ->to('fascicle-combos#rubrics');

    $sessionBridge->route('/fascicle/composer/initialize/')     ->to('fascicle-composer#initialize');
    $sessionBridge->route('/fascicle/composer/save/')           ->to('fascicle-composer#save');
    $sessionBridge->route('/fascicle/composer/templates/')      ->to('fascicle-composer#templates');
    $sessionBridge->route('/fascicle/composer/modules/')        ->to('fascicle-composer#modules');

    $sessionBridge->route('/fascicle/documents/list/')          ->to('fascicle-documents#list');

    $sessionBridge->route('/fascicle/indexes/editions/')        ->to('fascicle-indexes#editions');
    $sessionBridge->route('/fascicle/indexes/headlines/')       ->to('fascicle-indexes#headlines');
    $sessionBridge->route('/fascicle/indexes/rubrics/')         ->to('fascicle-indexes#rubrics');
    $sessionBridge->route('/fascicle/indexes/create/')          ->to('fascicle-indexes#create');
    $sessionBridge->route('/fascicle/indexes/update/')          ->to('fascicle-indexes#update');
    $sessionBridge->route('/fascicle/indexes/delete/')          ->to('fascicle-indexes#delete');

    $sessionBridge->route("/fascicle/headlines/tree/")          ->to("fascicle-headlines#tree");
    $sessionBridge->route("/fascicle/headlines/create/")        ->to("fascicle-headlines#create");
    $sessionBridge->route("/fascicle/headlines/read/")          ->to("fascicle-headlines#read");
    $sessionBridge->route("/fascicle/headlines/update/")        ->to("fascicle-headlines#update");
    $sessionBridge->route("/fascicle/headlines/delete/")        ->to("fascicle-headlines#delete");

    $sessionBridge->route("/fascicle/modules/list/")            ->to("fascicle-modules#list");
    $sessionBridge->route("/fascicle/modules/create/")          ->to("fascicle-modules#create");
    $sessionBridge->route("/fascicle/modules/read/")            ->to("fascicle-modules#read");
    $sessionBridge->route("/fascicle/modules/update/")          ->to("fascicle-modules#update");
    $sessionBridge->route("/fascicle/modules/delete/")          ->to("fascicle-modules#delete");

    $sessionBridge->route("/fascicle/pages/view/")              ->to("fascicle-pages#view");
    $sessionBridge->route("/fascicle/pages/modules/")           ->to("fascicle-pages#modules");
    $sessionBridge->route("/fascicle/pages/create/")            ->to("fascicle-pages#create");
    $sessionBridge->route("/fascicle/pages/read/")              ->to("fascicle-pages#read");
    $sessionBridge->route("/fascicle/pages/update/")            ->to("fascicle-pages#update");
    $sessionBridge->route("/fascicle/pages/delete/")            ->to("fascicle-pages#delete");
    $sessionBridge->route("/fascicle/pages/move/")              ->to("fascicle-pages#move");
    $sessionBridge->route("/fascicle/pages/left/")              ->to("fascicle-pages#left");
    $sessionBridge->route("/fascicle/pages/right/")             ->to("fascicle-pages#right");
    $sessionBridge->route("/fascicle/pages/resize/")            ->to("fascicle-pages#resize");
    $sessionBridge->route("/fascicle/pages/clean/")             ->to("fascicle-pages#clean");

    $sessionBridge->route("/fascicle/requests/list/")           ->to("fascicle-requests#list");
    $sessionBridge->route("/fascicle/requests/create/")         ->to("fascicle-requests#create");
    $sessionBridge->route("/fascicle/requests/read/")           ->to("fascicle-requests#read");
    $sessionBridge->route("/fascicle/requests/update/")         ->to("fascicle-requests#update");
    $sessionBridge->route("/fascicle/requests/delete/")         ->to("fascicle-requests#delete");
    $sessionBridge->route("/fascicle/requests/process/")        ->to("fascicle-requests#process");
    $sessionBridge->route("/fascicle/requests/move/")           ->to("fascicle-requests#move");

    $sessionBridge->route("/fascicle/rubrics/list/")            ->to("fascicle-rubrics#list");
    $sessionBridge->route("/fascicle/rubrics/create/")          ->to("fascicle-rubrics#create");
    $sessionBridge->route("/fascicle/rubrics/read/")            ->to("fascicle-rubrics#read");
    $sessionBridge->route("/fascicle/rubrics/update/")          ->to("fascicle-rubrics#update");
    $sessionBridge->route("/fascicle/rubrics/delete/")          ->to("fascicle-rubrics#delete");

    # Fascicle Templates
    $sessionBridge->route("/fascicle/templates/modules/")           ->to("fascicle-templates#modules");

    $sessionBridge->route("/fascicle/templates/modules/list/")      ->to("fascicle-templates-modules#list");
    $sessionBridge->route("/fascicle/templates/modules/create/")    ->to("fascicle-templates-modules#create");
    $sessionBridge->route("/fascicle/templates/modules/read/")      ->to("fascicle-templates-modules#read");
    $sessionBridge->route("/fascicle/templates/modules/update/")    ->to("fascicle-templates-modules#update");
    $sessionBridge->route("/fascicle/templates/modules/delete/")    ->to("fascicle-templates-modules#delete");

    $sessionBridge->route("/fascicle/templates/pages/list/")        ->to("fascicle-templates-pages#list");
    $sessionBridge->route("/fascicle/templates/pages/create/")      ->to("fascicle-templates-pages#create");
    $sessionBridge->route("/fascicle/templates/pages/read/")        ->to("fascicle-templates-pages#read");
    $sessionBridge->route("/fascicle/templates/pages/update/")      ->to("fascicle-templates-pages#update");
    $sessionBridge->route("/fascicle/templates/pages/delete/")      ->to("fascicle-templates-pages#delete");

    $sessionBridge->route("/fascicle/templates/places/tree/")       ->to("fascicle-templates-places#tree");
    $sessionBridge->route("/fascicle/templates/places/create/")     ->to("fascicle-templates-places#create");
    $sessionBridge->route("/fascicle/templates/places/read/")       ->to("fascicle-templates-places#read");
    $sessionBridge->route("/fascicle/templates/places/update/")     ->to("fascicle-templates-places#update");
    $sessionBridge->route("/fascicle/templates/places/delete/")     ->to("fascicle-templates-places#delete");

    $sessionBridge->route("/fascicle/templates/index/headlines/")   ->to("fascicle-templates-index#headlines");
    $sessionBridge->route("/fascicle/templates/index/modules/")     ->to("fascicle-templates-index#modules");
    $sessionBridge->route("/fascicle/templates/index/save/")        ->to("fascicle-templates-index#save");

    # Files
    $self->routes->route('/files/preview/:id')                    ->to('files#preview');
    $self->routes->route('/files/download/:id')                   ->to('files#download');
    $self->routes->route('/files/download/')                      ->to('files#download');
    $self->routes->route('/files/view/:id')                       ->to('files#view');
    $self->routes->route('/files/view/')                          ->to('files#view');

    # Images
    $sessionBridge->route('/aimgs/fascicle/page/:id/:w/:h')     ->to('images#fascicle_page');
    $sessionBridge->route('/aimgs/fascicle/template/:id/:w/:h') ->to('images#fascicle_page');
    $sessionBridge->route('/aimgs/fascicle/module/:id/:w/:h')   ->to('images#fascicle_page');

    $sessionBridge->route('/aimgs/advert/page/:id/:w/:h')       ->to('images#fascicle_page');
    $sessionBridge->route('/aimgs/advert/template/:id/:w/:h')   ->to('images#fascicle_page');
    $sessionBridge->route('/aimgs/advert/module/:id/:w/:h')     ->to('images#fascicle_page');

    # Logout
    $sessionBridge->route('/logout/')                           ->to('session#logout');

    # Inprint menu
    $sessionBridge->route('/menu/')                             ->to('menu#index');

    # Profile routes
    $sessionBridge->route('/profile/read/')                     ->to('profile#read');
    $sessionBridge->route('/profile/update/')                   ->to('profile#update');

    $sessionBridge->route('/profile/image/:id')                 ->to('profile#image', id => "00000000-0000-0000-0000-000000000000");

    # Reports
    $sessionBridge->route('/reports/advertising/fascicle/:fascicle')            ->to('reports-advertising-fascicle#index');

    # Options routes
    $sessionBridge->route('/options/update/')                   ->to('options#update');
    $sessionBridge->route('/options/combos/capture-destination/')->to('capture-destination');

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
    $sessionBridge->route('/workspace/startsession/')       ->to('workspace#startsession');
    $sessionBridge->route('/workspace/updatesession/')      ->to('workspace#updatesession');
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
            $self->routes->route($url)->to($action);
        }
    }

    $self->hook(after_dispatch => sub {
        my $tx = shift;
        $tx->res->headers->expires("Thu, 01 Dec 1994 16:00:00 GMT");
        $tx->res->headers->cache_control("max-age=1, no-cache, no-store");
    });
    return $self;
}

1;
