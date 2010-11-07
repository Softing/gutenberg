package Inprint::Workspace;

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

    my $path = $c->app->home->to_string;

    # Find css files
    my @cssfiles;
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
    my @jsfiles;
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
    my @jsplugins;
    my @cssplugins;
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

    my $member = $c->sql->Q("
        SELECT t2.id, t2.login, t3.title, t3.shortcut, t3.position
        FROM sessions t1, members t2 LEFT JOIN profiles t3 ON (t3.id = t2.id) WHERE t1.id=? AND t1.member = t2.id
    ", [ $c->session("sid") ])->Hash || {};

    $result->{member} = $member;

    $c->QuerySessionSet("member.id",  $result->{member}->{id});

    my $options = $c->sql->Q(" SELECT option_name, option_value FROM options WHERE member=? ", [ $member->{id} ])->Hashes || [];
    foreach my $item (@$options) {
        $result->{options}->{$item->{option_name}} = $item->{option_value};
        $c->QuerySessionSet("options.". $item->{option_name}, $item->{option_value});
    }

    $c->render_json($result);
}


sub online
{
    my $c = shift;
=cut
 $data = $rh_data->{SqlDrive}->Query({
	type	=> 'array_hashref',
        query 	=> "
	SELECT DISTINCT t1.uuid, t1.updated, t2.title, t2.stitle, t2.position ,
	(extract( epoch FROM now() - t1.updated )/60)::integer as isonline
	FROM passport.session t1, passport.card t2
	WHERE
	    t1.uuid=t2.uuid  AND t1.edition=?
		AND TO_CHAR ( t1.updated, 'mm/dd/yyyy') = TO_CHAR (now(), 'mm/dd/yyyy')
		AND t1.updated = ( SELECT max(updated) from passport.session WHERE uuid = t1.uuid AND edition=t1.edition )

		ORDER BY isonline ASC, t1.updated DESC

	",
        value	=> [ $edition ]
    });
=cut
    $c->render_json({});
}

1;
