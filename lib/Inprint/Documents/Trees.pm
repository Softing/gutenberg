package Inprint::Documents::Trees;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub editions {
    my $c = shift;

    my $i_term = $c->param("term");
    my $i_node = $c->param("node");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "node", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_node));
    
    push @errors, { id => "term", msg => "Incorrectly filled field"}
        unless ($c->is_rule($i_term));
    
    my @result;
    my $member = $c->QuerySessionGet("member.id");
    
    my @rules;
    push @rules, $i_term;
    
    for (my $i=0; $i <= $#rules; $i++) {
        my ($term, $area) = split /:/, $rules[$i];
        if ($area eq "*") {
            splice @rules, $i, $i, "$term:member", "$term:group";
        }
    }
    my %seen;@rules = grep { ! $seen{$_}++ } @rules;
    
    my $terms = $c->sql->Q("SELECT id FROM view_rules WHERE term_text = ANY (?)", [\@rules])->Values;
    
    unless (@errors) {
        
        my $sql;
        my @data;
        
        if ($i_node eq '00000000-0000-0000-0000-000000000000') {
            $sql = "
                SELECT t2.*, ( SELECT count(*) FROM editions c2 WHERE c2.path ~ ('*.' || t2.path::text || '.*{1}')::lquery ) as have_childs
                FROM map_member_to_rule t1, editions t2
                WHERE t2.id = t1.binding AND t1.member=? AND t1.term = ANY (?)
            ";
            push @data, $member;
            push @data, \@$terms;
        } else {
            $sql = "
                SELECT *, ( SELECT count(*) FROM editions c2 WHERE c2.path ~ ('*.' || editions.path::text || '.*{1}')::lquery ) as have_childs
                FROM editions
                WHERE
                    id <> '00000000-0000-0000-0000-000000000000'
                    AND subpath(path, nlevel(path) - 2, 1)::text = replace(?, '-', '')::text
            ";
            push @data, $i_node;
        }
        
        my $data = $c->sql->Q("$sql ORDER BY shortcut", \@data)->Hashes;
        
        foreach my $item (@$data) {
            my $record = {
                id   => $item->{id},
                text => $item->{shortcut},
                leaf => $c->json->true,
                icon => "book",
                data => $item
            };
            if ( $item->{have_childs} ) {
                $record->{leaf} = $c->json->false;
            }
            push @result, $record;
        }
    }

    $success = $c->json->true unless (@errors);
    
    $c->render_json( \@result );
}

sub workgroups {
    my $c = shift;

    my $i_term = $c->param("term");
    my $i_node = $c->param("node");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "node", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_node));
    
    push @errors, { id => "term", msg => "Incorrectly filled field"}
        unless ($c->is_rule($i_term));
    
    my @result;
    my $member = $c->QuerySessionGet("member.id");
    
    my @rules;
    push @rules, $i_term;
    for (my $i=0; $i <= $#rules; $i++) {
        my ($term, $area) = split /:/, $rules[$i];
        if ($area eq "*") {
            splice @rules, $i, $i, "$term", "$term";
        }
    }
    my %seen;@rules = grep { ! $seen{$_}++ } @rules;
    my $terms = $c->sql->Q("SELECT id FROM view_rules WHERE term_text = ANY (?)", [\@rules])->Values;
    
    unless (@errors) {
        
        my $sql;
        my @data;
        
        if ($i_node eq '00000000-0000-0000-0000-000000000000') {
            $sql = "
                SELECT t2.*, ( SELECT count(*) FROM catalog c2 WHERE c2.path ~ ('*.' || t2.path::text || '.*{1}')::lquery ) as have_childs
                FROM map_member_to_rule t1, catalog t2
                WHERE t2.id = t1.binding AND t1.member=? AND t1.term = ANY(?)
            ";
            push @data, $member;
            push @data, \@$terms;
        } else {
            $sql = "
                SELECT *, ( SELECT count(*) FROM catalog c2 WHERE c2.path ~ ('*.' || catalog.path::text || '.*{1}')::lquery ) as have_childs
                FROM catalog
                WHERE
                    id <> '00000000-0000-0000-0000-000000000000'
                    AND subpath(path, nlevel(path) - 2, 1)::text = replace(?, '-', '')::text
            ";
            push @data, $i_node;
        }
        
        my $data = $c->sql->Q("$sql ORDER BY shortcut", \@data)->Hashes;
        
        foreach my $item (@$data) {
            my $record = {
                id   => $item->{id},
                text => $item->{shortcut},
                leaf => $c->json->true,
                data => $item
            };
            if ( $item->{have_childs} ) {
                $record->{leaf} = $c->json->false;
            }
            push @result, $record;
        }
    }

    $success = $c->json->true unless (@errors);
    
    $c->render_json( \@result );
}

1;
