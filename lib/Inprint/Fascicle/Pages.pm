package Inprint::Fascicle::Pages;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub view {
    
    my $c = shift;
    
    my $i_fascicle = $c->param("fascicle");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));
    
    my $data = {};
    
    unless (@errors) {
        
        my $idcounter = 1;
        my $index;
        
        my @pageorder;
        
        my $pages;
        my $dbpages = $c->sql->Q("
            SELECT 
                t1.id, t1.place, t1.seqnum, t1.w, t1.h,
                t2.id as headline, t2.shortcut as headline_shortcut
            FROM fascicles_pages t1
                LEFT JOIN index as t2 ON t2.id=t1.headline
            WHERE fascicle = ?
            ORDER BY seqnum
        ", [ $i_fascicle ])->Hashes;
        
        foreach my $item (@$dbpages) {
            
            $index->{$item->{id}} = $idcounter++;
            
            my ($trash, $headline) = split /\//, $item->{headline_shortcut};
            
            $pages->{$index->{$item->{id}}} = {
                id => $item->{id},
                num => $item->{seqnum},
                dim   => "$item->{w}x$item->{h}",
                headline => $headline
            };
            
            push @pageorder, $index->{$item->{id}};
        }
        
        my $documents = {};
        my $doccount = 0;
        my $dbdocuments = $c->sql->Q("
            SELECT DISTINCT t2.edition, t2.fascicle, t2.id, t2.title
            FROM fascicles_map_documents t1, documents t2
            WHERE t2.id = t1.entity AND t1.fascicle = ?
        ", [ $i_fascicle ])->Hashes;
        
        foreach my $item (@$dbdocuments) {
            
            $index->{$item->{id}} = $idcounter++;
            
            $documents->{$index->{$item->{id}}} = {
                id => $item->{id},
                title => $item->{title}
            };
            
            my $docpages = $c->sql->Q("
                SELECT t2.id
                FROM fascicles_map_documents t1, fascicles_pages t2
                WHERE t2.id = t1.page AND t1.fascicle = ? AND entity = ?
            ", [ $i_fascicle, $item->{id} ])->Values;
            foreach my $pageid (@$docpages) {
                my $pageindex = $index->{$pageid};
                if ($pageindex) {
                    push @{ $pages->{$pageindex}->{documents} }, $index->{$item->{id}};
                }
            }
        }
        
        my $holes;
        my $dbholes = $c->sql->Q("
            SELECT
                t1.id, t1.place, t1.page, t1.entity, t1.x, t1.y, t1.h, t1.w,
                t2.id as module, t2.shortcut as module_shortcut
            FROM fascicles_map_holes t1, ad_modules t2
            WHERE t2.id = t1.module
                AND t1.fascicle = ?
        ", [ $i_fascicle ])->Hashes;
        
        foreach my $item (@$dbholes) {
            $index->{$item->{id}} = $idcounter++;
            
            $holes->{$index->{$item->{id}}} = {
                id => $item->{id},
                title => $item->{module_shortcut},
                entity => $item->{entity},
                x => $item->{x},
                y => $item->{y},
                h => $item->{h},
                w => $item->{w},
            };
            
            my $pageindex = $index->{$item->{page}};
            if ($pageindex) {
                push @{ $pages->{$pageindex}->{holes} }, $index->{$item->{id}};
            }
        }
        
        $data->{pages}      = $pages;
        $data->{documents}  = $documents;
        $data->{holes}      = $holes;
        $data->{pageorder}  = \@pageorder;
        
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => [ $data ] });
}


1;
