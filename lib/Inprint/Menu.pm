package Inprint::Menu;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use File::Find;

use base 'Inprint::BaseController';

sub index
{
    my $c = shift;

    sub AddItem {
        my ($id, $icon, $text, $path, $type) = @_;
        my $result = {};
        $result->{id}   = $id   if $id;
        $result->{icon} = $icon if $icon;
        $result->{text} = $text if $text;
        $result->{path} = $path if $path;
        $result->{type} = $type if $type;
        return $result;
    }

    my @result;

    # About programm
    my $about = {
        id => "core",
        menu => [
            { id=> "core-help" },
            { id=> "core-about" }
        ]
    };
    push @result, $about;
    push @result, "-";

    #
    # Documents menu items
    #

    my $accessViewDocuments   = $c->access->Check(["catalog.documents.view:*"]);
    my $accessCreateDocuments = $c->access->Check(["catalog.documents.create:*"]);

    if ($accessViewDocuments) {

        my $documents = {
            id => "documents"
        };

        if ($accessCreateDocuments) {
            push @{ $documents->{menu} }, { id => "documents-create" };
        }

        push @{ $documents->{menu} }, { id => "documents-todo" };
        push @{ $documents->{menu} }, '-';
        push @{ $documents->{menu} }, { id => "documents-all" };
        push @{ $documents->{menu} }, { id => "documents-archive" };
        push @{ $documents->{menu} }, { id => "documents-briefcase" };

        push @{ $documents->{menu} }, { id => "documents-recycle" };

        push @{ $documents->{menu} }, { id => "documents-rss" };

        push @result, $documents;
        push @result, "-";
    }

    ############################################################################
    # Advertising
    ############################################################################

    my $advertising = {
        id => "advertising"
    };
    #push @{ $advertising->{menu} }, { id => "advert-requests" };
    push @{ $advertising->{menu} }, { id => "advert-advertisers" };
    push @{ $advertising->{menu} }, "-";
    push @{ $advertising->{menu} }, { id => "advert-modules" };
    push @{ $advertising->{menu} }, { id => "advert-index" };
    #push @{ $advertising->{menu} }, { id => "advert-archive" };

    push @result, $advertising;
    push @result, "-";



    ############################################################################
    # Fascicles and Composition
    ############################################################################

    my $accessCalendarEditions = $c->access->Check("editions.calendar.view");
    my $accessLayoutEditions   = $c->access->GetBindings("editions.layouts.view");

    if ( $accessCalendarEditions ) {
        push @result, {
            id => 'fascicles',
            menu => [
                {
                    id   => "composition-calendar"
                },
                {
                    id   => "briefcase-index",
                    oid  => "00000000-0000-0000-0000-000000000000"
                }
            ]
        };
    }

    ## Выбираем выпуски
    my $fascicles = $c->sql->Q("
        SELECT
            t1.id, t1.shortcut, t2.id as edition, t2.shortcut as edition_shortcut
        FROM fascicles t1, editions t2
        WHERE
            t1.edition = t2.id
            AND t1.edition = ANY (?)
            AND t1.enabled = true
            AND t1.edition=t1.parent
            AND t1.deadline >= now()
        ORDER BY t1.deadline, t2.shortcut, t1.shortcut
    ", [ $accessLayoutEditions ])->Hashes;

    my $composition  = {
        id => "composition"
    };

    foreach my $fascicle (@$fascicles) {

        my $accessLayoutView     = $c->access->Check("editions.layouts.view",   $fascicle->{edition});
        my $accessLayoutManage   = $c->access->Check("editions.layouts.manage", $fascicle->{edition});
        my $accessAdvertManage   = $c->access->Check("editions.advert.manage",  $fascicle->{edition});

        my $fascicle_menu = {
            id   => "fascicle",
            text => $fascicle->{edition_shortcut} . '/'. $fascicle->{shortcut},
            menu => []
        };

        push @{ $fascicle_menu->{menu} }, {
            id   => "fascicle-plan",
            oid  => $fascicle->{id},
            description => $fascicle->{shortcut}
        } if $accessLayoutView;

        push @{ $fascicle_menu->{menu} }, {
            id   => "fascicle-planner",
            oid  => $fascicle->{id},
            description => $fascicle->{shortcut}
        } if $accessLayoutManage;

        push @{ $fascicle_menu->{menu} }, "-";

        push @{ $fascicle_menu->{menu} }, {
            id  => "fascicle-index",
            oid => $fascicle->{id},
            description => $fascicle->{shortcut}
        } if $accessLayoutManage;

        push @{ $fascicle_menu->{menu} }, {
            id  => "fascicle-templates",
            oid => $fascicle->{id},
            description => $fascicle->{shortcut}
        } if $accessLayoutManage;

        push @{ $fascicle_menu->{menu} }, {
            id  => "fascicle-places",
            oid => $fascicle->{id},
            description => $fascicle->{shortcut}
        } if $accessLayoutManage;

        my $childrens = $c->sql->Q("
            SELECT
                t1.id, t1.shortcut, t2.id as edition, t2.shortcut as edition_shortcut
            FROM fascicles t1, editions t2
            WHERE
                t1.edition = t2.id
                AND t1.edition = ANY (?)
                AND t1.enabled = true
                AND t1.deadline >= now()
                AND t1.parent = ?
            ORDER BY t1.deadline, t2.shortcut, t1.shortcut
        ", [ $accessLayoutEditions, $fascicle->{id} ])->Hashes;

        foreach my $children (@$childrens) {

            my $accessLayoutView     = $c->access->Check("editions.layouts.view",   $children->{edition});
            my $accessLayoutManage   = $c->access->Check("editions.layouts.manage", $children->{edition});
            my $accessAdvertManage   = $c->access->Check("editions.advert.manage",  $children->{edition});

            my $children_menu = {
                id   => "fascicle",
                text => $children->{edition_shortcut} . '/'. $children->{shortcut},
                menu => []
            };

            push @{ $children_menu->{menu} }, {
                id   => "fascicle-plan",
                oid  => $children->{id},
                description => $children->{shortcut}
            } if $accessLayoutView;

            push @{ $children_menu->{menu} }, {
                id   => "fascicle-planner",
                oid  => $children->{id},
                description => $children->{shortcut}
            } if $accessLayoutManage;

            push @{ $children_menu->{menu} }, "-";

            push @{ $children_menu->{menu} }, {
                id  => "fascicle-index",
                oid => $children->{id},
                description => $children->{shortcut}
            } if $accessLayoutManage;

            push @{ $children_menu->{menu} }, {
                id  => "fascicle-templates",
                oid => $children->{id},
                description => $children->{shortcut}
            } if $accessLayoutManage;

            push @{ $children_menu->{menu} }, {
                id  => "fascicle-places",
                oid => $children->{id},
                description => $children->{shortcut}
            } if $accessLayoutManage;

            push @{ $fascicle_menu->{menu} }, "-";
            push @{ $fascicle_menu->{menu} }, $children_menu;
        }

        push @result, $fascicle_menu;

    }

    push @result, '->';

    ############################################################################
    # Employee
    ############################################################################

    my $employee = {
        id => "employee",
        text => $c->QuerySessionGet("member.shortcut")
    };

    push @{ $employee->{menu} }, { id => "employee-card" };
    push @{ $employee->{menu} }, { id => "employee-settings" };
    push @{ $employee->{menu} }, "-";
    push @{ $employee->{menu} }, { id => "employee-access" };
    push @{ $employee->{menu} }, { id => "employee-logs" };
    push @{ $employee->{menu} }, "-";
    push @{ $employee->{menu} }, { id => "employee-logout" };

    push @result, $employee;



    ############################################################################
    # Settings
    ############################################################################

    my $accessViewSettings = $c->access->Check("domain.configuration.view");

    if ($accessViewSettings) {
        my $settings = {
            id => "settings"
        };

        push @{ $settings->{menu} }, { id => "settings-organization" };
        push @{ $settings->{menu} }, { id => "settings-editions" };
        push @{ $settings->{menu} }, { id => "settings-roles" };
        push @{ $settings->{menu} }, { id => "settings-readiness" };
        push @{ $settings->{menu} }, { id => "settings-index" };

        push @result, $settings;
    }

    $c->render_json({ data => \@result });
}


1;
