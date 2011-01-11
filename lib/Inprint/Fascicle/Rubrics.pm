package Inprint::Fascicle::Rubrics;


# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Fascicle::Rubric;

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
        $result = Inprint::Models::Fascicle::Rubric::read($c, $i_id);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub list {
    my $c = shift;

    my $i_headline = $c->param("headline");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_headline));

    my $result;
    unless (@errors) {
        $result = $c->sql->Q("
            SELECT id, tag, title, description
            FROM fascicles_indx_rubrics WHERE headline=?
            ORDER BY title ASC ",
            [ $i_headline ] )->Hashes;
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result || [] } );
}

sub create {
    my $c = shift;

    my $id            = $c->uuid();

    my $i_headline    = $c->param("headline");
    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "headline", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_headline));

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));

    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.departments.manage"));

    my $headline = $c->sql->Q(" SELECT * FROM fascicles_indx_headlines WHERE id=? ", [ $i_headline ])->Hash;
    push @errors, { id => "headline", msg => "Incorrectly filled field"}
        unless ($headline->{id});

    unless (@errors) {
        Inprint::Models::Fascicle::Rubric::create($c, $id, $headline->{edition}, $headline->{fascicle}, $headline->{id}, $i_title, $i_description);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub update {
    my $c = shift;

    my $i_id          = $c->param("id");
    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");

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

    my $headline = Inprint::Models::Fascicle::Rubric::read($c, $i_id);
    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($headline->{id});

    unless (@errors) {

        my $editions = $c->sql->Q("
            SELECT id FROM editions WHERE path @> ? OR path <@ ? order by path asc; ",
            [ $edition->{path}, $edition->{path} ])->Values;

        my $exists_title = $c->sql->Q("
            SELECT EXISTS(
                    SELECT id FROM indx_headlines WHERE edition=ANY(?)
                    AND lower(title) = lower(?)
                )",
            [ $editions, $i_title ])->Value;

        push @errors, { id => "title", msg => "Already exists"}
            if ($exists_title);

    }

    unless (@errors) {
        Inprint::Models::Fascicle::Rubric::update($c, $i_id, $i_title, $i_description);
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
        Inprint::Models::Fascicle::Rubric::delete($c, $i_id);
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
#        $result = $c->sql->Q("
#            SELECT * FROM fascicles_indx_rubrics WHERE id=? ",
#            [ $i_id ])->Hash;
#    }
#
#    $success = $c->json->true unless (@errors);
#    $c->render_json( { success => $success, errors => \@errors, data => $result || {} } );
#}
#
#sub list {
#    my $c = shift;
#
#    my $i_headline = $c->param("headline");
#
#    my @errors;
#    my $success = $c->json->false;
#
#    push @errors, { id => "id", msg => "Incorrectly filled field"}
#        unless ($c->is_uuid($i_headline));
#
#    my $result;
#    unless (@errors) {
#        $result = $c->sql->Q("
#            SELECT id, title
#            FROM fascicles_indx_rubrics WHERE headline=?
#            ORDER BY title ASC
#        ", [ $i_headline ] )->Hashes;
#    }
#
#    $success = $c->json->true unless (@errors);
#    $c->render_json( { success => $success, errors => \@errors, data => $result || [] } );
#}
#
#sub create {
#    my $c = shift;
#
#    my $id            = $c->uuid();
#
#    my $i_fascicle    = $c->param("fascicle");
#    my $i_headline    = $c->param("headline");
#    my $i_title       = $c->param("title");
#    my $i_description = $c->param("description");
#
#    my @errors;
#    my $success = $c->json->false;
#
#    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
#        unless ($c->is_uuid($i_fascicle));
#
#    push @errors, { id => "headline", msg => "Incorrectly filled field"}
#        unless ($c->is_uuid($i_headline));
#
#    push @errors, { id => "title", msg => "Incorrectly filled field"}
#        unless ($c->is_text($i_title));
#
#    push @errors, { id => "description", msg => "Incorrectly filled field"}
#        unless ($c->is_text($i_description));
#
#    my $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $i_fascicle ])->Hash;
#    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
#        unless ($fascicle->{id});
#
#    my $headline = $c->sql->Q(" SELECT * FROM fascicles_indx_headlines WHERE id=? ", [ $i_headline ])->Hash;
#    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
#        unless ($headline->{id});
#
#     push @errors, { id => "access", msg => "Not enough permissions [editions.layouts.manage]"}
#        unless ($c->access->Check("editions.layouts.manage", $headline->{edition}));
#
#    unless (@errors) {
#        $c->sql->Do("
#            INSERT INTO fascicles_indx_rubrics(id, edition, fascicle, origin, headline, title, description, created, updated)
#            VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now());
#        ", [ $id, $fascicle->{edition}, $fascicle->{id}, $id, $headline->{id}, $i_title, $i_description ]);
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
#    my $rubric = $c->sql->Q(" SELECT * FROM fascicles_indx_rubrics WHERE id=? ", [ $i_id ])->Hash;
#    push @errors, { id => "rubric", msg => "Incorrectly filled field"}
#        unless ($rubric->{id});
#
#    push @errors, { id => "access", msg => "Not enough permissions [editions.layouts.manage]"}
#        unless ($c->access->Check("editions.layouts.manage", $rubric->{edition}));
#
#    unless (@errors) {
#        $c->sql->Do(" UPDATE fascicles_indx_rubrics SET title=?, description=? WHERE id=? ",
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
#    my $rubric = $c->sql->Q(" SELECT * FROM fascicles_indx_rubrics WHERE id=? ", [ $i_id ])->Hash;
#    push @errors, { id => "rubric", msg => "Incorrectly filled field"}
#        unless ($rubric->{id});
#
#    push @errors, { id => "access", msg => "Not enough permissions [editions.layouts.manage]"}
#        unless ($c->access->Check("editions.layouts.manage", $rubric->{edition}));
#
#    unless (@errors) {
#        $c->sql->Do("
#            DELETE FROM fascicles_indx_rubrics WHERE id =?
#            AND ( origin <> '00000000-0000-0000-0000-000000000000' )
#        ", [ $i_id ]);
#    }
#
#    $success = $c->json->true unless (@errors);
#    $c->render_json({ success => $success, errors => \@errors });
#
#}

1;
