package Inprint::Workspace;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
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

    my $cacheable = $c->config->get("core.cached") || undef;

    my $path = $c->app->home->to_string;

    my @jsfiles;
    my @cssfiles;
    my @jsplugins;
    my @cssplugins;

    if (
        $cacheable eq "true"
        && -r "$path/public/cache/inprint.min.js"
        && -r "$path/public/cache/inprint.min.css"
        && -r "$path/public/cache/plugins.min.js"
        && -r "$path/public/cache/plugins.min.css"
        ) {

            push @jsfiles, "/cache/inprint.min.js";
            push @cssfiles, "/cache/inprint.min.css";
            push @jsplugins, "/cache/plugins.min.js";
            push @cssplugins, "/cache/plugins.min.css";

    } else {

        # Find css files
        find({ wanted => sub {
            if ( -r $File::Find::name && (/\.css$/) ) {
                my $file = $File::Find::name;
                $file  =~ s/\/+/\//g;
                $file = substr ($file, length("$path/public"), length($file));
                return if ( $file =~ /\/css\/themes\// );
                return if ( $file =~ /\/css\/engines\// );
                push @cssfiles, $file;
            }
        }}, "$path/public/css");
        @cssfiles = sort { $a cmp $b } @cssfiles;

        # Find js files
        find({ wanted => sub {
            if ( -r $File::Find::name && (/\.js$/) ) {
                    my $file = $File::Find::name;
                    $file  =~ s/\/+/\//g;
                    $file = substr ($file, length("$path/public"), length($file));
                    push @jsfiles, $file;
            }
        }}, "$path/public/widgets");
        @jsfiles = sort { $a cmp $b } @jsfiles;

        # Find plugins
        find({ wanted => sub {
            if ( -r $File::Find::name && ((/\.js$/) || (/\.css$/)) ) {
                my $file = $File::Find::name;
                $file  =~ s/\/+/\//g;
                $file = substr ($file, length("$path/public"), length($file));
                push @jsplugins, $file if ($file =~ m/\.js$/);
                push @cssplugins, $file if ($file =~ m/\.css$/);
            }
        }}, "$path/public/plugins");
        @jsplugins = sort { $a cmp $b } @jsplugins;
        @cssplugins = sort { $a cmp $b } @cssplugins;

    }

    $c->render(
        js  => \@jsfiles,
        css =>\@cssfiles,
        jsplugins  => \@jsplugins,
        cssplugins =>\@cssplugins
    );
}

sub appsession {

    my $c = shift;

    my $result = {};

    my $member = $c->Q("
        SELECT t2.id, t2.login, t3.title, t3.shortcut, t3.job_position as position
        FROM sessions t1, members t2 LEFT JOIN profiles t3 ON (t3.id = t2.id) WHERE t1.id=? AND t1.member = t2.id
    ", [ $c->session("sid") ])->Hash || {};

    $result->{member} = $member;

    $c->setSessionValue("member.id",  $result->{member}->{id});

    my $options = $c->Q(" SELECT option_name, option_value FROM options WHERE member=? ", [ $member->{id} ])->Hashes || [];
    foreach my $item (@$options) {
        $result->{options}->{$item->{option_name}} = $item->{option_value};
        $c->setSessionValue("options.". $item->{option_name}, $item->{option_value});
    }

    my $edition   = $c->Q(" SELECT id, shortcut FROM editions WHERE id=? ", [$result->{options}->{"default.edition"}])->Hash;

    $result->{options}->{"default.edition"} = $edition->{id};
    $result->{options}->{"default.edition.name"} = $edition->{shortcut};

    my $workgroup = $c->Q(" SELECT id, shortcut FROM catalog WHERE id=? ", [$result->{options}->{"default.workgroup"}])->Hash;

    $result->{options}->{"default.workgroup"} = $workgroup->{id};
    $result->{options}->{"default.workgroup.name"} = $workgroup->{shortcut};

    $c->render_json($result);
}


sub online
{
    my $c = shift;
    $c->render_json({});
}

1;
