package Inprint::Fascicle::Headlines;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;


use Inprint::Models::Fascicle::Headline;

use base 'Mojolicious::Controller';

sub read {
    my $c = shift;
    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "id", $i_id);

    my $result = [];

    unless (@errors) {
        $result = Inprint::Models::Fascicle::Headline::read($c, $i_id);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub tree {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "fascicle", $i_fascicle);

    my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);

    my @result;
    unless (@errors) {

        my $sql;
        my @data;

        $sql = "
            SELECT id, title, 'marker' as icon, 'current' as status
            FROM fascicles_indx_headlines WHERE fascicle=?
            ORDER BY title ASC
        ";
        push @data, $fascicle->{id};

        my $data = $c->Q($sql, \@data)->Hashes;

        foreach my $item (@$data) {
            my $record = {
                id      => $item->{id},
                icon    => $item->{icon},
                status  => $item->{status},
                text    => $item->{title},
                leaf    => $c->json->true
            };
            push @result, $record;
        }

    }

    $success = $c->json->true unless (@errors);
    $c->render_json( \@result );
}

sub create {
    my $c = shift;

    my $id            = $c->uuid();

    my $i_fascicle    = $c->param("fascicle");
    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");
    my $i_bydefault   = $c->param("bydefault");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "fascicle", $i_fascicle);
    $c->check_text( \@errors, "title", $i_title);
    $c->check_text( \@errors, "description", $i_description, 1);

    my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);

    $c->check_access( \@errors, "editions.index.manage", $fascicle->{edition});

    unless (@errors) {
        Inprint::Models::Fascicle::Headline::create($c, $id, $fascicle->{edition}, $fascicle->{id}, $i_bydefault, $i_title, $i_description);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub update {
    my $c = shift;

    my $i_id          = $c->param("id");
    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");
    my $i_bydefault   = $c->param("bydefault");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "id", $i_id);
    $c->check_text( \@errors, "title", $i_title);
    $c->check_text( \@errors, "description", $i_description, 1);

    my $oldItem = Inprint::Models::Fascicle::Headline::read($c, $i_id);

    $c->check_object( \@errors, "headline", $oldItem);
    $c->check_access( \@errors, "editions.index.manage", $oldItem->{edition});

    unless (@errors) {

        # Update headlines in fascicle
        Inprint::Models::Fascicle::Headline::update($c, $oldItem->{id}, $oldItem->{edition}, $oldItem->{fascicle}, $i_bydefault, $i_title, $i_description);

        # Re-read headline
        my $newItem = Inprint::Models::Fascicle::Headline::read($c, $i_id);

        # Update documents in fascicle
        $c->Do("UPDATE documents SET headline=?, headline_shortcut=? WHERE fascicle=? AND headline=?",
            [ $newItem->{tag}, $newItem->{title}, $oldItem->{fascicle}, $oldItem->{tag} ]);

    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub delete {

    my $c = shift;

    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "id", $i_id);

    my $item = Inprint::Models::Fascicle::Headline::read($c, $i_id);

    $c->check_object( \@errors, "headline", $item);
    $c->check_access( \@errors, "editions.index.manage", $item->{edition});

    unless (@errors) {

        # Delete headline
        Inprint::Models::Fascicle::Headline::delete($c, $i_id);

        # Update documents
        $c->Do("
                UPDATE documents SET
                    headline ='00000000-0000-0000-0000-000000000000', headline_shortcut = '--',
                    rubric   ='00000000-0000-0000-0000-000000000000', rubric_shortcut   = '--'
                WHERE fascicle=? AND headline=?
            ", [ $item->{fascicle}, $item->{tag} ]);

    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });

}

1;
