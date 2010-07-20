package Inprint::Index;

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

sub menu
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
    
    # Portal
    my $portal = {
        id   => "portal"
    };
    push @result, $portal;
    
    # Documents menu items
    my $documents = {
        id => "documents"
    };
    
    #if ( Inprint::Core::Check::rules_or( 'document.edition.view', 'document.department.view', 'document.owner.view' ) ) {
    push @{ $documents->{menu} }, { id => "documents-create" };
    push @{ $documents->{menu} }, { id => "documents-todo" };
    push @{ $documents->{menu} }, '-';
    push @{ $documents->{menu} }, { id => "documents-all" };
    push @{ $documents->{menu} }, { id => "documents-archive" };
    push @{ $documents->{menu} }, { id => "documents-briefcase" };
    
    #if ( Inprint::Core::Check::rules_or( 'document.edition.restore', 'document.department.restore', 'document.owner.restore' ) ) {
    push @{ $documents->{menu} }, { id => "documents-recycle" };
    
    push @result, $documents;
    
    
    
    # Editions
    #if ( &check_rule('edition.view') ) {

    my $editions = $c->sql->Q(
        "SELECT uuid, name as title, sname as stitle FROM edition.edition WHERE deleted=false ORDER BY sname"
    )->Hashes;
    
    push @result, "-";
    
    foreach my $item (@$editions) {
        
        my $edition = {
            id => "edition",
            text => $item->{title}
        };
        
        #if ( &check_rule('edition.manage') ) {
        push @{ $edition->{menu} }, { id => 'edition-calendar', oid => $item->{uuid} };
        push @{ $edition->{menu} }, { id => 'edition-archive',  oid => $item->{uuid} };
        
        # Выбираем выпуски
        my $fascicles = $c->sql->Q(
            "SELECT id, title FROM edition.calendar WHERE dt_started < now() AND dt_closed > now() AND edition=? ORDER BY dt_closed, title",
            [ $item->{uuid} ]
        )->Hashes;
        
        if ($fascicles) {
            push @{ $edition->{menu} }, "-";
        }
        
        foreach my $item2 (@$fascicles) {

            my $fascicle = {
                id   => "fascicle",
                text => $item2->{title}
            };

            push @{ $fascicle->{menu} }, {
                id   => "fascicle-plan",
                oid  => $item2->{id},
                description => $item2->{title}
            };
    
            #if ( &check_rule('edition.manage') ) {
            push @{ $fascicle->{menu} }, {
                id   => "fascicle-planner",
                oid  => $item2->{id},
                description => $item2->{title}
            };
            push @{ $fascicle->{menu} }, {
                id  => "fascicle-advert",
                oid => $item2->{id},
                description => $item2->{title}
            };
            push @{ $fascicle->{menu} }, {
                id  => "fascicle-catchword",
                oid => $item2->{id},
                description => $item2->{title}
            };
            
            push @{ $edition->{menu} }, $fascicle;
            
        }
        
        push @result, $edition;
    }
    
    push @result, '->';
    
    # Settings
    my $settings = {
        id => "settings"
    };
    
    #if ( &check_rule('settings.manage.edition') ) {
    push @{ $settings->{menu} }, { id => "settings-editions" };
    
    #if ( &check_rule('settings.manage.people') ) {
    push @{ $settings->{menu} }, "-";
    push @{ $settings->{menu} }, { id => "settings-roles" };
    push @{ $settings->{menu} }, { id => "settings-departments" };
    push @{ $settings->{menu} }, { id => "settings-members" };
    
    #if ( &check_rule('settings.manage.exchange') ) {
    push @{ $settings->{menu} }, "-";
    push @{ $settings->{menu} }, { id => "settings-exchange" };
    
    #if ( &check_rule('settings.view') ) {
    push @result, $settings;
    
    # Employee
    my $employee = {
        id => "employee",
        text => $c->session("stitle")
    };
    
    push @{ $employee->{menu} }, { id => "employee-card" };
    push @{ $employee->{menu} }, { id => "employee-settings" };
    push @{ $employee->{menu} }, "-";
    push @{ $employee->{menu} }, { id => "employee-access" };
    push @{ $employee->{menu} }, { id => "employee-logs" };
    push @{ $employee->{menu} }, "-";
    push @{ $employee->{menu} }, { id => "employee-logout" };
    
    push @result, $employee;
    
    $c->render_json({ data => \@result });
}

sub appsession
{
    my $c = shift;
    
    my $result = {
#       access   => Inprint::Core::User::Access(),
#       card     => Inprint::Core::User::Card(),
#       session  => Inprint::Core::User::Session(),
#       settings => Inprint::Core::User::Settings(),
    };
    
    $c->render_json($result);
}

sub state
{
    my $c = shift;
    
=cut
my $cgi_action = Inprint::Core::CGI::param('action');
my $cgi_name   = Inprint::Core::CGI::param('name');
my $cgi_value  = Inprint::Core::CGI::param('value');

if ( $cgi_action eq 'save' )
{
	$rh_data->{SqlDrive}->Do({
		query 	=> " DELETE FROM inprint.state WHERE member=? AND variable=? ",
		value	=> [ $rh_data->{session}->{uuid}, $cgi_name ]
	});
	$rh_data->{SqlDrive}->Do({
		query 	=> " INSERT INTO inprint.state ( member, variable, variable_value) VALUES (?,?,?) ",
		value	=> [ $rh_data->{session}->{uuid}, $cgi_name, $cgi_value ]
	});
	Inprint::Core::render_json({
	    success => $JSON::true
	});
}

if ( $cgi_action eq 'clear' )
{
	$rh_data->{SqlDrive}->Do({
		query 	=> " DELETE FROM inprint.state WHERE member=? AND variable=? ",
		value	=> [ $rh_data->{session}->{uuid}, $cgi_name ]
	});
	Inprint::Core::render_json({
	    success => $JSON::true
	});
}

if ( $cgi_action eq 'read' )
{
	my $data = $rh_data->{SqlDrive}->Query({
		type	=> 'array_hashref',
		query 	=> " SELECT variable as name, variable_value as value FROM inprint.state WHERE member=? ",
		value	=> [ $rh_data->{session}->{uuid} ]
	});

	Inprint::Core::render_json({
		data => $data,
	    success => $JSON::true
	});
}
=cut
    
    $c->render_json({});
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
