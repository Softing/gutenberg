package Inprint::Options;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub update {

    my $c = shift;

    my $member_id     = $c->getSessionValue("member.id");
    
    my $i_edition            = $c->param("edition");
    my $i_edition_shortcut   = $c->param("edition-shortcut");
    
    my $i_workgroup          = $c->param("workgroup");
    my $i_workgroup_shortcut = $c->param("workgroup-shortcut");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));
        
    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_edition_shortcut));
        
    push @errors, { id => "workgroup", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_workgroup));
        
    push @errors, { id => "workgroup", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_workgroup_shortcut));
    
    unless (@errors) {
        
        $c->Do("DELETE FROM options WHERE option_name=? AND member=?", ["default.edition", $member_id]);
        $c->Do("INSERT INTO OPTIONS (member, option_name, option_value) VALUES (?, ?, ?)", [$member_id, "default.edition", $i_edition]);
        $c->Do("DELETE FROM options WHERE option_name=? AND member=?", ["default.edition.name", $member_id]);
        $c->Do("INSERT INTO OPTIONS (member, option_name, option_value) VALUES (?, ?, ?)", [$member_id, "default.edition.name", $i_edition_shortcut]);
        
        $c->Do("DELETE FROM options WHERE option_name=? AND member=?", ["default.workgroup", $member_id]);
        $c->Do("INSERT INTO OPTIONS (member, option_name, option_value) VALUES (?, ?, ?)", [$member_id, "default.workgroup", $i_workgroup]);
        $c->Do("DELETE FROM options WHERE option_name=? AND member=?", ["default.workgroup.name", $member_id]);
        $c->Do("INSERT INTO OPTIONS (member, option_name, option_value) VALUES (?, ?, ?)", [$member_id, "default.workgroup.name", $i_workgroup_shortcut]);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });

}


1;
