package Inprint::Fascicle::Headlines;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Fascicle::Headline;

use base 'Inprint::BaseController';

sub read {
    my $c = shift;
    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

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

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    my $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $i_fascicle ])->Hash;
    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($fascicle->{id});

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

        my $data = $c->sql->Q($sql, \@data)->Hashes;

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

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));

    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.departments.manage"));

    my $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $i_fascicle ])->Hash;
    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($fascicle->{id});

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

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));

    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.editions.manage"));

    my $edition;

    my $headline = Inprint::Models::Fascicle::Headline::read($c, $i_id);
    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($headline->{id});

    unless (@errors) {
        Inprint::Models::Fascicle::Headline::update($c, $i_id, $headline->{edition}, $headline->{fascicle}, $i_bydefault, $i_title, $i_description);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub delete {
    my $c = shift;
    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.editions.manage"));

    unless (@errors) {
        Inprint::Models::Fascicle::Headline::delete($c, $i_id);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });

}

## Inprint Content 4.5
## Copyright(c) 2001-2010, Softing, LLC.
## licensing@softing.ru
## http://softing.ru/license
#
#use strict;
#use warnings;
#
#use base 'Inprint::BaseController';
#
#sub read {
#    my $c = shift;
#
#    my $i_id = $c->param("id");
#
#    my @errors;
#    my $success = $c->json->false;
#
#    push @errors, { id => "id", msg => "Incorrectly filled field"}
#        unless ($c->is_uuid($i_id));
#
#    my $result = [];
#
#    unless (@errors) {
#        $result = $c->sql->Q(" SELECT * FROM fascicles_indx_headlines WHERE id = ? ", [ $i_id ])->Hash;
#    }
#
#    $success = $c->json->true unless (@errors);
#    $c->render_json( { success => $success, errors => \@errors, data => $result } );
#}
#
#sub tree {
#
#    my $c = shift;
#
#    my $i_fasclce = $c->param("fascicle");
#
#    my @result;
#    my @errors;
#    my $success = $c->json->false;
#
#    push @errors, { id => "id", msg => "Incorrectly filled field"}
#        unless ($c->is_uuid($i_fasclce));
#
#    my $fascicle;
#    unless (@errors) {
#        $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $i_fasclce ])->Hash;
#        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
#            unless ($fascicle->{id});
#    }
#
#    unless (@errors) {
#
#        my $sql;
#        my @data;
#
#        $sql = "
#            SELECT id, title, 'marker' as icon, 'current' as status
#            FROM fascicles_indx_headlines WHERE fascicle=?
#            ORDER BY title ASC
#        ";
#        push @data, $fascicle->{id};
#
#        my $data = $c->sql->Q($sql, \@data)->Hashes;
#
#        foreach my $item (@$data) {
#            my $record = {
#                id      => $item->{id},
#                icon    => $item->{icon},
#                status  => $item->{status},
#                text    => $item->{title},
#                leaf    => $c->json->true
#            };
#            push @result, $record;
#        }
#
#    }
#
#    $success = $c->json->true unless (@errors);
#    $c->render_json( \@result );
#}
#
#sub create {
#    my $c = shift;
#
#    my $id            = $c->uuid();
#
#    my $i_fascicle    = $c->param("fascicle");
#    my $i_title       = $c->param("title");
#    my $i_description = $c->param("description");
#
#    my @errors;
#    my $success = $c->json->false;
#
#    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
#        unless ($c->is_uuid($i_fascicle));
#
#    push @errors, { id => "title", msg => "Incorrectly filled field"}
#        unless ($c->is_text($i_title));
#
#    push @errors, { id => "description", msg => "Incorrectly filled field"}
#        unless ($c->is_text($i_description));
#
#
#    my $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $i_fascicle ])->Hash;
#    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
#        unless ($fascicle->{id});
#
#    push @errors, { id => "access", msg => "Not enough permissions [editions.layouts.manage]"}
#        unless ($c->access->Check("editions.layouts.manage", $fascicle->{edition}));
#
#    unless (@errors) {
#        $c->sql->Do("
#            INSERT INTO fascicles_indx_headlines(id, edition, fascicle, origin, title, description, created, updated)
#            VALUES (?, ?, ?, ?, ?, ?, ?, now(), now());
#        ", [ $id, $fascicle->{edition}, $fascicle->{id}, $id, $i_title, $i_description ]);
#    }
#
#    $success = $c->json->true unless (@errors);
#    $c->render_json({ success => $success, errors => \@errors });
#}
#
#sub update {
#    my $c = shift;
#
#    my $i_id          = $c->param("id");
#    my $i_title       = $c->param("title");
#    my $i_description = $c->param("description");
#
#    my @errors;
#    my $success = $c->json->false;
#
#    push @errors, { id => "id", msg => "Incorrectly filled field"}
#        unless ($c->is_uuid($i_id));
#
#    push @errors, { id => "title", msg => "Incorrectly filled field"}
#        unless ($c->is_text($i_title));
#
#    push @errors, { id => "description", msg => "Incorrectly filled field"}
#        unless ($c->is_text($i_description));
#
#
#    my $headline = $c->sql->Q(" SELECT * FROM fascicles_indx_headlines WHERE id=? ", [ $i_id ])->Hash;
#    push @errors, { id => "headline", msg => "Incorrectly filled field"}
#        unless ($headline->{id});
#
#    push @errors, { id => "access", msg => "Not enough permissions [editions.layouts.manage]"}
#        unless ($c->access->Check("editions.layouts.manage", $headline->{edition}));
#
#    unless (@errors) {
#        $c->sql->Do(" UPDATE fascicles_indx_headlines SET title=?, description=? WHERE id=? ",
#            [ $i_title, $i_description, $i_id ]);
#    }
#
#    $success = $c->json->true unless (@errors);
#    $c->render_json({ success => $success, errors => \@errors });
#}
#
#sub delete {
#    my $c = shift;
#    my $i_id = $c->param("id");
#
#    my @errors;
#    my $success = $c->json->false;
#
#    push @errors, { id => "id", msg => "Incorrectly filled field"}
#        unless ($c->is_uuid($i_id));
#
#    my $headline = $c->sql->Q(" SELECT * FROM fascicles_indx_headlines WHERE id=? ", [ $i_id ])->Hash;
#    push @errors, { id => "headline", msg => "Incorrectly filled field"}
#        unless ($headline->{id});
#
#    push @errors, { id => "access", msg => "Not enough permissions [editions.layouts.manage]"}
#        unless ($c->access->Check("editions.layouts.manage", $headline->{edition}));
#
#    unless (@errors) {
#        $c->sql->Do(" DELETE FROM fascicles_indx_rubrics WHERE headline=? ", [ $i_id ]);
#        $c->sql->Do(" DELETE FROM fascicles_indx_headlines WHERE id =? AND ( origin <> '00000000-0000-0000-0000-000000000000' ) ", [ $headline->{id} ]);
#    }
#
#    $success = $c->json->true unless (@errors);
#    $c->render_json({ success => $success, errors => \@errors });
#
#}

1;
