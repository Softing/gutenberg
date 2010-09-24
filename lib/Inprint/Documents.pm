package Inprint::Documents;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub list {

    my $c = shift;
    
    my @params;
    
    # Pagination
    my $start = $c->param("start") || 0;
    my $limit = $c->param("limit") || 60;
    
    # Filters
    my $group    = $c->param("group")    || undef;
    my $title    = $c->param("title")    || undef;
    my $fascicle = $c->param("fascicle") || undef;
    my $headline = $c->param("headline") || undef;
    my $rubric   = $c->param("rubric")   || undef;
    my $manager  = $c->param("mmanager") || undef;
    my $owner    = $c->param("owner")    || undef;
    my $progress = $c->param("progress") || undef;
    
    # Query headers
    my $sql_query = "
        SELECT 
            dcm.id,
            
            dcm.fascicle, dcm.fascicle_shortcut,
            dcm.headline, dcm.headline_shortcut,
            dcm.rubric, dcm.rubric_shortcut,
            dcm.copygroup,
            
            dcm.holder, dcm.creator, dcm.manager, holder_shortcut, dcm.creator_shortcut, dcm.manager_shortcut,
            dcm.maingroup, dcm.maingroup_shortcut, dcm.ingroups,
            dcm.islooked, dcm.isopen,
            dcm.branch, dcm.branch_shortcut, dcm.stage,stage_shortcut, dcm.color, dcm.progress,
            dcm.title, dcm.author,
            to_char(dcm.pdate, 'YYYY-MM-DD HH24:MI:SS') as pdate,
            to_char(dcm.rdate, 'YYYY-MM-DD HH24:MI:SS') as rdate,
            dcm.psize, dcm.rsize,
            dcm.images, dcm.files,
            to_char(dcm.created, 'YYYY-MM-DD HH24:MI:SS') as created,
            to_char(dcm.updated, 'YYYY-MM-DD HH24:MI:SS') as updated
            
        FROM documents dcm
        
    ";
    
    my $sql_total = "
        SELECT count(*)
        FROM documents dcm
    ";
    
    # Set filters
    my $sql_filters = " WHERE 1=1 ";
    
    if ($group) {
        $sql_filters .= "";
    }
    
    if ($title) {
        $sql_filters .= "";
    }
    
    if ($fascicle) {
        $sql_filters .= "";
    }
    
    if ($headline) {
        $sql_filters .= "";
    }
    
    if ($rubric) {
        $sql_filters .= "";
    }
    
    if ($manager) {
        $sql_filters .= "";
    }
    
    if ($owner) {
        $sql_filters .= "";
    }
    
    if ($progress) {
        $sql_filters .= "";
    }
    
    $sql_total .= $sql_filters;
    $sql_query .= $sql_filters;
    
    # Calculate total param
    my $total = $c->sql->Q($sql_total, \@params)->Value || 0;
    
    # Select rows with pagination
    $sql_query .= " LIMIT ? OFFSET ? ";
    push @params, $limit;
    push @params, $start;
    my $result = $c->sql->Q($sql_query, \@params)->Hashes;

    # Create result
    $c->render_json( { "data" => $result, "total" => $total } );
}


sub create {
    my $c = shift;

    my $id = $c->uuid();

    my $i_name        = $c->param("name");
    my $i_path        = $c->param("path");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    $c->sql->Do("
        INSERT INTO roles(id, catalog, name, shortcut, description, created, updated)
        VALUES (?, ?, ?, ?, ?, now(), now());
    ", [ $id, $i_path, $i_name, $i_shortcut, $i_description ]);

    $c->render_json( { success => $c->json->true} );
}

sub read {

    my $c = shift;

    my $id = $c->param("id");

    my $result = $c->sql->Q("
        SELECT t1.id, t1.name, t1.shortcut, t1.description,
            t2.id as catalog_id, t2.name as catalog_name, t2.shortcut as catalog_shortcut
        FROM roles t1, catalog t2
        WHERE t1.id =? AND t1.catalog = t2.id
        ORDER BY t2.shortcut, t1.shortcut
    ", [ $id ])->Hash;

    $c->render_json( { success => $c->json->true, data => $result } );
}


sub update {
    my $c = shift;

    my $i_id          = $c->param("id");
    my $i_name        = $c->param("name");
    my $i_path        = $c->param("path");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    $c->sql->Do("
        UPDATE roles
            SET catalog=?, name=?, shortcut=?, description=?, updated=now()
        WHERE id =?;
    ", [ $i_path, $i_name, $i_shortcut, $i_description, $i_id ]);

    $c->render_json( { success => $c->json->true} );
}

sub delete {
    my $c = shift;
    my @ids = $c->param("id");
    foreach my $id (@ids) {
        $c->sql->Do(" DELETE FROM roles WHERE id=? ", [ $id ]);
    }
    $c->render_json( { success => $c->json->true } );
}



1;
