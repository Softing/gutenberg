package Inprint::Plugins::Rss::Control;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Utils::Documents;
use Inprint::Models::Fascicle;

use base 'Inprint::BaseController';

sub tree {

    my $c = shift;

    my $i_node = $c->param("node");
    $i_node = '00000000-0000-0000-0000-000000000000' unless ($i_node);
    $i_node = '00000000-0000-0000-0000-000000000000' if ($i_node eq "root-node");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_node));

    my @result;

    unless (@errors) {
        my $sql;
        my @data;

        $sql .= "
            SELECT t1.*
            FROM rss_feeds t1 ";

        my $data = $c->sql->Q("$sql ORDER BY title", \@data)->Hashes;

        foreach my $item (@$data) {
            my $record = {
                id   => $item->{id},
                text => $item->{title},
                leaf => $c->json->true,
                icon => "feed",
                data => $item
            };
            push @result, $record;
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( \@result );
}

sub list {

    my $c = shift;

    #my $i_feed = $c->param("feed");

    my @errors;
    my $success = $c->json->false;

    #push @errors, { id => "feed", msg => "Incorrectly filled field"}
    #    unless ($c->is_uuid($i_feed));

    my $result;

    unless (@errors) {

        my $editions = $c->sql->Q("
                SELECT edtns.*,
                    (
                        SELECT COUNT(*)
                        FROM indx_headlines indx
                        WHERE indx.edition=edtns.id
                            AND indx.id <> '00000000-0000-0000-0000-000000000000'
                    ) as leaf
                FROM editions edtns
                WHERE id <> '00000000-0000-0000-0000-000000000000'
                ORDER BY edtns.shortcut
            ", [])->Hashes;

        foreach my $edition (@$editions) {

            my $record = {
                id => $edition->{id} . "::edition",
                title => $edition->{shortcut},
                description => $edition->{description},
                _id => $edition->{id} . "::edition",
                _parent => undef,
                _is_leaf => $edition->{leaf} ? $c->json->false : $c->json->true
            };

            push @$result, $record;

            my $headlines = $c->sql->Q("
                    SELECT hdlns.*,
                        (
                            SELECT COUNT(*)
                            FROM indx_rubrics indx
                            WHERE indx.headline=hdlns.id
                                AND indx.id <> '00000000-0000-0000-0000-000000000000'
                        ) as leaf
                    FROM indx_headlines hdlns
                    WHERE hdlns.edition=?
                    ORDER BY hdlns.title
                ", [ $edition->{id} ])->Hashes;

            # Get Headlines
            foreach my $headline (@$headlines) {

                my $record2 = {
                    id => $headline->{tag} . "::headline",
                    title => $headline->{title},
                    description => $headline->{description},
                    _id => $headline->{tag} . "::headline",
                    _parent => $edition->{id},
                    _is_leaf => $headline->{leaf}? $c->json->false : $c->json->true
                };

                push @$result, $record2;

                my $rubrics = $c->sql->Q("
                        SELECT *
                        FROM indx_rubrics
                        WHERE headline=?
                        ORDER BY title
                    ", [ $headline->{id} ])->Hashes;

                # Get Rubrics
                foreach my $rubric (@$rubrics) {

                    my $record3 = {
                        id => $rubric->{tag} . "::rubric",
                        title => $rubric->{title},
                        description => $rubric->{description},
                        _id => $rubric->{tag} . "::rubric",
                        _parent => $headline->{id},
                        _is_leaf => $c->json->true
                    };

                    push @$result, $record3;
                }
            }

        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, data => $result } );
}

sub create {
    my $c = shift;

    my $id            = $c->uuid();

    my $i_url         = $c->param("url");
    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "url", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_url));

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));

    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->access->Check("domain.editions.manage"));

    unless (@errors) {
        $c->sql->Do("
            INSERT INTO rss_feeds (id, url, title, description)
                VALUES (?, ?, ?, ?)
        ", [ $id, $i_url, $i_title, $i_description ]);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub read {
    my $c = shift;
    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    my $result = [];

    unless (@errors) {
        $result = $c->sql->Q("
            SELECT t1.*
            FROM rss_feeds t1 WHERE t1.id = ?
        ", [ $i_id ])->Hash;
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub update {
    my $c = shift;

    my $i_id          = $c->param("id");
    my $i_url         = $c->param("url");
    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    push @errors, { id => "url", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_url));

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        if ($i_id eq "00000000-0000-0000-0000-000000000000");

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));

    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->access->Check("domain.editions.manage"));

    unless (@errors) {

        $c->sql->Do("
            UPDATE rss_feeds SET url=?, title=?, description=?
            WHERE id=? ",
            [ $i_url, $i_title, $i_description, $i_id ]);
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

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        if ($i_id eq "00000000-0000-0000-0000-000000000000");

    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->access->Check("domain.editions.manage"));

    unless (@errors) {
        $c->sql->Do(" DELETE FROM rss_feeds WHERE id =? ", [ $i_id ]);
    }

    $success = $c->json->true unless (@errors);

    $c->render_json({ success => $success, errors => \@errors });
}

sub fill {
    my $c = shift;
    my $i_feed = $c->param("feed");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "feed", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_feed));

    ##push @errors, { id => "access", msg => "Not enough permissions"}
    ##    unless ($c->access->Check("domain.editions.manage"));
    #

    my $result = []; unless (@errors) {
        $result = $c->sql->Q("
            SELECT tag || '::' || nature FROM rss_feeds_mapping
            WHERE feed=? ",
            [ $i_feed ])->Values;
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $result });
}


sub save {
    my $c = shift;
    my $i_feed    = $c->param("feed");
    my @i_rubrics = $c->param("rubrics");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "feed", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_feed));

    ##push @errors, { id => "access", msg => "Not enough permissions"}
    ##    unless ($c->access->Check("domain.editions.manage"));
    #

    $c->sql->Do(" DELETE FROM rss_feeds_mapping WHERE feed =? ", [ $i_feed ]);

    foreach my $rubric_str (@i_rubrics) {
        my ($tag, $nature) = split '::', $rubric_str;

        next unless $tag;
        next unless $nature;

        $c->sql->Do("
                INSERT INTO rss_feeds_mapping (feed, nature, tag)
                VALUES (?,?,?)
            ", [ $i_feed, $nature, $tag ]);

    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

1;
