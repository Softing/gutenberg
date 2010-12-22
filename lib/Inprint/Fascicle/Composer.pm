package Inprint::Fascicle::Composer;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Utils::Pages;

use base 'Inprint::BaseController';

sub initialize {
    
    my $c = shift;
    
    my @i_pages    = $c->param("page");
    
    my $data;
    my @errors;
    my $success = $c->json->false;
    
    unless (@errors) {
        
        my @pages;
        
        $data->{pages} = $c->sql->Q("
            SELECT id, w, h, seqnum
            FROM fascicles_pages WHERE id = ANY(?) ORDER BY seqnum ASC
        ", [ \@i_pages ])->Hashes;
        
        $data->{modules} = $c->sql->Q("
            SELECT t1.id, t1.shortcut, t1.w, t1.h, t2.page, t2.x, t2.y
            FROM fascicles_modules t1, fascicles_map_modules t2
            WHERE page=ANY(?) AND t2.module=t1.id
        ", [ \@i_pages ])->Hashes;
        
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $data });
}

sub save {
    
    my $c = shift;
    
    my $i_page    = $c->param("page");
    my @i_modules  = $c->param("modules");
    
    my @errors;
    my $success = $c->json->false;
    
    unless (@errors) {
        
        foreach my $string (@i_modules) {
            
            my ($id, $x, $y, $w, $h) = split "::", $string;
            
            my $placed = 1;
            
            #unless ($x eq "0/1") {
            #    unless ($y eq "0/1") {
            #        $placed = 1;
            #    }
            #}
            
            $c->sql->Do("
                    UPDATE fascicles_map_modules SET placed=?, x=?, y=? WHERE page=? AND module=?
                ", [ $placed, $x, $y, $i_page, $id ]);
            
        }
        
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}


1;